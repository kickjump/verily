import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

import 'package:verily_server/src/exceptions/server_exceptions.dart';
import 'package:verily_server/src/generated/protocol.dart';
import 'package:verily_server/src/services/rewards/reward_pool_service.dart';
import 'package:verily_server/src/services/submissions/submission_service.dart';
import 'package:verily_server/src/services/verification/verification_service.dart';
import 'package:verily_server/src/services/wallet/solana_service.dart';
import 'package:verily_server/src/verification/gemini_service.dart';

/// Coordinates end-to-end Gemini verification for a submission.
class SubmissionVerificationOrchestrator {
  SubmissionVerificationOrchestrator._();

  static final _log = VLogger('SubmissionVerificationOrchestrator');
  static const _verificationLeaseDuration = Duration(minutes: 10);

  /// Runs (or re-runs) verification for [submissionId].
  ///
  /// If [forceReprocess] is false and a result exists, returns the existing
  /// record. If Gemini is unavailable, marks the submission as `error` and
  /// returns `null`.
  static Future<VerificationResult?> processSubmission(
    Session session, {
    required int submissionId,
    bool forceReprocess = false,
  }) async {
    final submission = await ActionSubmission.db.findById(
      session,
      submissionId,
    );
    if (submission == null) {
      throw NotFoundException('Submission with id $submissionId not found');
    }

    final action = await Action.db.findById(session, submission.actionId);
    if (action == null) {
      await SubmissionService.markError(session, id: submissionId);
      throw NotFoundException(
        'Action with id ${submission.actionId} not found',
      );
    }

    final existing = await VerificationService.findBySubmissionId(
      session,
      submissionId,
    );
    if (existing != null && !forceReprocess) {
      return existing;
    }

    final leaseAcquired = await _acquireVerificationLease(
      session,
      submissionId: submissionId,
      forceReprocess: forceReprocess,
    );

    if (!leaseAcquired) {
      if (forceReprocess) {
        throw ValidationException(
          'Verification is already processing for submission $submissionId',
        );
      }

      final current = await VerificationService.findBySubmissionId(
        session,
        submissionId,
      );
      if (current != null) {
        return current;
      }

      _log.info(
        'Skipped submission $submissionId because verification lease is held '
        'by another worker',
      );
      return null;
    }

    final currentVerification =
        existing ??
        await VerificationService.findBySubmissionId(session, submissionId);

    try {
      final geminiResponse = await GeminiService.analyzeVideo(
        session,
        videoUrl: submission.videoUrl,
        actionTitle: action.title,
        actionDescription: action.description,
        verificationCriteria: action.verificationCriteria,
        latitude: submission.latitude,
        longitude: submission.longitude,
      );

      if (geminiResponse == null) {
        await SubmissionService.markError(session, id: submissionId);
        return null;
      }

      if (currentVerification != null) {
        final passed =
            geminiResponse.confidenceScore >=
                VerificationService.passingConfidenceThreshold &&
            !geminiResponse.spoofingDetected;

        currentVerification
          ..passed = passed
          ..confidenceScore = geminiResponse.confidenceScore
          ..analysisText = geminiResponse.analysisText
          ..spoofingDetected = geminiResponse.spoofingDetected
          ..structuredResult = geminiResponse.structuredResult
          ..modelUsed = geminiResponse.modelUsed
          ..createdAt = DateTime.now().toUtc();

        final updated = await VerificationResult.db.updateRow(
          session,
          currentVerification,
        );
        if (passed) {
          await SubmissionService.markPassed(session, id: submissionId);
          await _handleSuccessfulSubmission(
            session,
            action: action,
            submission: submission,
          );
        } else {
          await SubmissionService.markFailed(session, id: submissionId);
        }
        return updated;
      }

      final created = await VerificationService.createFromGeminiResponse(
        session,
        submissionId: submissionId,
        analysisText: geminiResponse.analysisText,
        confidenceScore: geminiResponse.confidenceScore,
        spoofingDetected: geminiResponse.spoofingDetected,
        modelUsed: geminiResponse.modelUsed,
        structuredResult: geminiResponse.structuredResult,
      );

      if (created.passed) {
        await _handleSuccessfulSubmission(
          session,
          action: action,
          submission: submission,
        );
      }

      return created;
    } on Exception catch (error, stackTrace) {
      _log.severe(
        'Failed processing verification for submission $submissionId',
        error,
        stackTrace,
      );
      await SubmissionService.markError(session, id: submissionId);
      rethrow;
    }
  }

  static Future<bool> _acquireVerificationLease(
    Session session, {
    required int submissionId,
    required bool forceReprocess,
  }) async {
    final now = DateTime.now().toUtc();
    final leaseCutoff = now.subtract(_verificationLeaseDuration);

    final updatedRows = await session.db.transaction<List<ActionSubmission>>((
      transaction,
    ) async {
      return ActionSubmission.db.updateWhere(
        session,
        columnValues: (t) => [
          t.status(VerificationStatus.processing.value),
          t.updatedAt(now),
        ],
        where: (t) =>
            t.id.equals(submissionId) &
            _leasePredicate(
              t,
              leaseCutoff: leaseCutoff,
              forceReprocess: forceReprocess,
            ),
        limit: 1,
        transaction: transaction,
      );
    });

    return updatedRows.isNotEmpty;
  }

  static Expression<dynamic> _leasePredicate(
    ActionSubmissionTable table, {
    required DateTime leaseCutoff,
    required bool forceReprocess,
  }) {
    final staleProcessing =
        table.status.equals(VerificationStatus.processing.value) &
        (table.updatedAt < leaseCutoff);

    if (forceReprocess) {
      return table.status.notEquals(VerificationStatus.processing.value) |
          staleProcessing;
    }

    final pendingOrRetryable =
        table.status.equals(VerificationStatus.pending.value) |
        table.status.equals(VerificationStatus.error.value);

    return pendingOrRetryable | staleProcessing;
  }

  static Future<void> _handleSuccessfulSubmission(
    Session session, {
    required Action action,
    required ActionSubmission submission,
  }) async {
    final actionId = action.id;
    final submissionId = submission.id;
    if (actionId == null || submissionId == null) {
      return;
    }

    final completionSatisfied = await _isCompletionSatisfied(
      session,
      action: action,
      performerId: submission.performerId,
    );
    if (!completionSatisfied) {
      return;
    }

    await _closeActionIfCapacityReached(
      session,
      action: action,
      actionId: actionId,
    );

    final pools = await RewardPoolService.findByAction(
      session,
      actionId: actionId,
      status: PoolStatus.active.value,
    );

    for (final pool in pools) {
      final poolId = pool.id;
      if (poolId == null) {
        continue;
      }

      try {
        await SolanaService.distributeReward(
          session,
          rewardPoolId: poolId,
          recipientId: submission.performerId,
          submissionId: submissionId,
        );
      } on ValidationException catch (error, stackTrace) {
        _log.warning(
          'Skipped reward distribution for submission $submissionId '
          'in pool $poolId',
          error,
          stackTrace,
        );
      }
    }
  }

  static Future<bool> _isCompletionSatisfied(
    Session session, {
    required Action action,
    required UuidValue performerId,
  }) async {
    final actionId = action.id;
    if (actionId == null) {
      return false;
    }

    final type = ActionType.fromValue(action.actionType);
    switch (type) {
      case ActionType.oneOff:
        return true;
      case ActionType.sequential:
        return SubmissionService.hasCompletedAllSteps(
          session,
          actionId: actionId,
          performerId: performerId,
        );
      case ActionType.habit:
        final requiredCompletions = action.habitTotalRequired ?? 1;
        if (requiredCompletions <= 1) {
          return true;
        }

        final passedCount = await ActionSubmission.db.count(
          session,
          where: (t) =>
              t.actionId.equals(actionId) &
              t.performerId.equals(performerId) &
              t.status.equals(VerificationStatus.passed.value),
        );

        return passedCount >= requiredCompletions;
    }
  }

  static Future<void> _closeActionIfCapacityReached(
    Session session, {
    required Action action,
    required int actionId,
  }) async {
    final maxPerformers = action.maxPerformers;
    if (maxPerformers == null || maxPerformers < 1) {
      return;
    }
    if (action.status != ActionStatus.active.value) {
      return;
    }

    final passedSubmissions = await ActionSubmission.db.find(
      session,
      where: (t) =>
          t.actionId.equals(actionId) &
          t.status.equals(VerificationStatus.passed.value),
    );

    final distinctPerformerCount = passedSubmissions
        .map((s) => s.performerId)
        .toSet()
        .length;
    if (distinctPerformerCount < maxPerformers) {
      return;
    }

    action
      ..status = ActionStatus.completed.value
      ..updatedAt = DateTime.now().toUtc();
    await Action.db.updateRow(session, action);

    _log.info(
      'Action $actionId marked completed after reaching max performers '
      '($maxPerformers)',
    );
  }
}
