// TODO: These tests require serverpod_test setup with a running test database.
// Run with: cd verily_server && dart test
//
// To run these tests, you need:
// 1. A running PostgreSQL test database
// 2. serverpod_test configured with test session support
// 3. Generated protocol code from `serverpod generate`

import 'package:test/test.dart';
import 'package:serverpod/serverpod.dart';
import 'package:verily_core/verily_core.dart';

// These imports will resolve once `serverpod generate` has been run:
// import 'package:verily_server/src/generated/protocol.dart';
// import 'package:verily_server/src/services/action_service.dart';
// import 'package:verily_server/src/services/action_step_service.dart';
// import 'package:verily_server/src/exceptions/server_exceptions.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Shared test data
  // ---------------------------------------------------------------------------

  final testCreatorId = UuidValue.fromString(
    'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee',
  );

  group('ActionStepService', () {
    // late Session session;
    // late Action sequentialAction;
    // late Action oneOffAction;

    // setUp(() async {
    //   session = await createTestSession();
    //
    //   // Create a sequential action with 5 steps for testing.
    //   sequentialAction = await ActionService.create(
    //     session,
    //     title: 'Sequential Test Action',
    //     description: 'A test sequential action',
    //     creatorId: testCreatorId,
    //     actionType: ActionType.sequential.value,
    //     verificationCriteria: 'Complete each step',
    //     totalSteps: 5,
    //   );
    //
    //   // Create a one-off action for negative testing.
    //   oneOffAction = await ActionService.create(
    //     session,
    //     title: 'One-Off Test Action',
    //     description: 'A test one-off action',
    //     creatorId: testCreatorId,
    //     actionType: ActionType.oneOff.value,
    //     verificationCriteria: 'Do the thing',
    //   );
    // });

    // tearDown(() async {
    //   await session.close();
    // });

    // -------------------------------------------------------------------------
    // create()
    // -------------------------------------------------------------------------

    group('create()', () {
      test(
        'creates a step for a sequential action',
        () async {
          // final step = await ActionStepService.create(
          //   session,
          //   actionId: sequentialAction.id!,
          //   stepNumber: 1,
          //   title: 'Step 1',
          //   verificationCriteria: 'Do step 1',
          // );
          //
          // expect(step.id, isNotNull);
          // expect(step.actionId, equals(sequentialAction.id));
          // expect(step.stepNumber, equals(1));
          // expect(step.title, equals('Step 1'));
          // expect(step.verificationCriteria, equals('Do step 1'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'creates a step with optional description',
        () async {
          // final step = await ActionStepService.create(
          //   session,
          //   actionId: sequentialAction.id!,
          //   stepNumber: 2,
          //   title: 'Step 2',
          //   verificationCriteria: 'Do step 2',
          //   description: 'Detailed description for step 2',
          // );
          //
          // expect(step.description, equals('Detailed description for step 2'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws NotFoundException for non-existent action',
        () async {
          // expect(
          //   () => ActionStepService.create(
          //     session,
          //     actionId: 99999,
          //     stepNumber: 1,
          //     title: 'Orphan Step',
          //     verificationCriteria: 'criteria',
          //   ),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException for non-sequential action',
        () async {
          // expect(
          //   () => ActionStepService.create(
          //     session,
          //     actionId: oneOffAction.id!,
          //     stepNumber: 1,
          //     title: 'Bad Step',
          //     verificationCriteria: 'criteria',
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException when stepNumber exceeds totalSteps',
        () async {
          // expect(
          //   () => ActionStepService.create(
          //     session,
          //     actionId: sequentialAction.id!,
          //     stepNumber: 6, // totalSteps is 5
          //     title: 'Too Far',
          //     verificationCriteria: 'criteria',
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException when stepNumber is less than 1',
        () async {
          // expect(
          //   () => ActionStepService.create(
          //     session,
          //     actionId: sequentialAction.id!,
          //     stepNumber: 0,
          //     title: 'Zero Step',
          //     verificationCriteria: 'criteria',
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException when stepNumber is negative',
        () async {
          // expect(
          //   () => ActionStepService.create(
          //     session,
          //     actionId: sequentialAction.id!,
          //     stepNumber: -1,
          //     title: 'Negative Step',
          //     verificationCriteria: 'criteria',
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // createBatch()
    // -------------------------------------------------------------------------

    group('createBatch()', () {
      test(
        'creates multiple steps in a single batch',
        () async {
          // final steps = [
          //   ActionStep(
          //     actionId: sequentialAction.id!,
          //     stepNumber: 1,
          //     title: 'Batch Step 1',
          //     verificationCriteria: 'criteria 1',
          //   ),
          //   ActionStep(
          //     actionId: sequentialAction.id!,
          //     stepNumber: 2,
          //     title: 'Batch Step 2',
          //     verificationCriteria: 'criteria 2',
          //   ),
          //   ActionStep(
          //     actionId: sequentialAction.id!,
          //     stepNumber: 3,
          //     title: 'Batch Step 3',
          //     verificationCriteria: 'criteria 3',
          //   ),
          // ];
          //
          // final created = await ActionStepService.createBatch(
          //   session,
          //   actionId: sequentialAction.id!,
          //   steps: steps,
          // );
          //
          // expect(created.length, equals(3));
          // expect(created[0].title, equals('Batch Step 1'));
          // expect(created[1].title, equals('Batch Step 2'));
          // expect(created[2].title, equals('Batch Step 3'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException if any step exceeds totalSteps',
        () async {
          // final steps = [
          //   ActionStep(
          //     actionId: sequentialAction.id!,
          //     stepNumber: 1,
          //     title: 'OK Step',
          //     verificationCriteria: 'criteria',
          //   ),
          //   ActionStep(
          //     actionId: sequentialAction.id!,
          //     stepNumber: 10, // exceeds totalSteps of 5
          //     title: 'Bad Step',
          //     verificationCriteria: 'criteria',
          //   ),
          // ];
          //
          // expect(
          //   () => ActionStepService.createBatch(
          //     session,
          //     actionId: sequentialAction.id!,
          //     steps: steps,
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws ValidationException for non-sequential action',
        () async {
          // final steps = [
          //   ActionStep(
          //     actionId: oneOffAction.id!,
          //     stepNumber: 1,
          //     title: 'Bad Step',
          //     verificationCriteria: 'criteria',
          //   ),
          // ];
          //
          // expect(
          //   () => ActionStepService.createBatch(
          //     session,
          //     actionId: oneOffAction.id!,
          //     steps: steps,
          //   ),
          //   throwsA(isA<ValidationException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // findByActionId()
    // -------------------------------------------------------------------------

    group('findByActionId()', () {
      test(
        'returns steps ordered by step number',
        () async {
          // Create steps out of order.
          // await ActionStepService.create(
          //   session,
          //   actionId: sequentialAction.id!,
          //   stepNumber: 3,
          //   title: 'Step 3',
          //   verificationCriteria: 'criteria',
          // );
          // await ActionStepService.create(
          //   session,
          //   actionId: sequentialAction.id!,
          //   stepNumber: 1,
          //   title: 'Step 1',
          //   verificationCriteria: 'criteria',
          // );
          // await ActionStepService.create(
          //   session,
          //   actionId: sequentialAction.id!,
          //   stepNumber: 2,
          //   title: 'Step 2',
          //   verificationCriteria: 'criteria',
          // );
          //
          // final steps = await ActionStepService.findByActionId(
          //   session,
          //   actionId: sequentialAction.id!,
          // );
          //
          // expect(steps.length, equals(3));
          // expect(steps[0].stepNumber, equals(1));
          // expect(steps[1].stepNumber, equals(2));
          // expect(steps[2].stepNumber, equals(3));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'returns empty list for action with no steps',
        () async {
          // final steps = await ActionStepService.findByActionId(
          //   session,
          //   actionId: sequentialAction.id!,
          // );
          // expect(steps, isEmpty);
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // findByActionAndStep()
    // -------------------------------------------------------------------------

    group('findByActionAndStep()', () {
      test(
        'returns the correct step',
        () async {
          // await ActionStepService.create(
          //   session,
          //   actionId: sequentialAction.id!,
          //   stepNumber: 1,
          //   title: 'Find This Step',
          //   verificationCriteria: 'criteria',
          // );
          //
          // final step = await ActionStepService.findByActionAndStep(
          //   session,
          //   actionId: sequentialAction.id!,
          //   stepNumber: 1,
          // );
          //
          // expect(step.title, equals('Find This Step'));
          // expect(step.stepNumber, equals(1));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws NotFoundException for non-existent step number',
        () async {
          // expect(
          //   () => ActionStepService.findByActionAndStep(
          //     session,
          //     actionId: sequentialAction.id!,
          //     stepNumber: 99,
          //   ),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // findById()
    // -------------------------------------------------------------------------

    group('findById()', () {
      test(
        'returns step by primary key',
        () async {
          // final created = await ActionStepService.create(
          //   session,
          //   actionId: sequentialAction.id!,
          //   stepNumber: 1,
          //   title: 'PK Lookup',
          //   verificationCriteria: 'criteria',
          // );
          //
          // final found = await ActionStepService.findById(session, created.id!);
          // expect(found.title, equals('PK Lookup'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'throws NotFoundException for non-existent id',
        () async {
          // expect(
          //   () => ActionStepService.findById(session, 99999),
          //   throwsA(isA<NotFoundException>()),
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // update()
    // -------------------------------------------------------------------------

    group('update()', () {
      test('updates step title', () async {
        // final created = await ActionStepService.create(
        //   session,
        //   actionId: sequentialAction.id!,
        //   stepNumber: 1,
        //   title: 'Original',
        //   verificationCriteria: 'criteria',
        // );
        //
        // final updated = await ActionStepService.update(
        //   session,
        //   id: created.id!,
        //   title: 'Updated Title',
        // );
        //
        // expect(updated.title, equals('Updated Title'));
      }, skip: 'Requires serverpod_test database session');

      test(
        'updates step description',
        () async {
          // final created = await ActionStepService.create(
          //   session,
          //   actionId: sequentialAction.id!,
          //   stepNumber: 1,
          //   title: 'Step',
          //   verificationCriteria: 'criteria',
          // );
          //
          // final updated = await ActionStepService.update(
          //   session,
          //   id: created.id!,
          //   description: 'New description',
          // );
          //
          // expect(updated.description, equals('New description'));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'updates step verificationCriteria',
        () async {
          // final created = await ActionStepService.create(
          //   session,
          //   actionId: sequentialAction.id!,
          //   stepNumber: 1,
          //   title: 'Step',
          //   verificationCriteria: 'old criteria',
          // );
          //
          // final updated = await ActionStepService.update(
          //   session,
          //   id: created.id!,
          //   verificationCriteria: 'new criteria',
          // );
          //
          // expect(updated.verificationCriteria, equals('new criteria'));
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // delete()
    // -------------------------------------------------------------------------

    group('delete()', () {
      test('deletes a step by id', () async {
        // final created = await ActionStepService.create(
        //   session,
        //   actionId: sequentialAction.id!,
        //   stepNumber: 1,
        //   title: 'Delete Me',
        //   verificationCriteria: 'criteria',
        // );
        //
        // await ActionStepService.delete(session, created.id!);
        //
        // expect(
        //   () => ActionStepService.findById(session, created.id!),
        //   throwsA(isA<NotFoundException>()),
        // );
      }, skip: 'Requires serverpod_test database session');
    });

    // -------------------------------------------------------------------------
    // deleteAllForAction()
    // -------------------------------------------------------------------------

    group('deleteAllForAction()', () {
      test(
        'removes all steps for an action',
        () async {
          // for (var i = 1; i <= 3; i++) {
          //   await ActionStepService.create(
          //     session,
          //     actionId: sequentialAction.id!,
          //     stepNumber: i,
          //     title: 'Step $i',
          //     verificationCriteria: 'criteria',
          //   );
          // }
          //
          // await ActionStepService.deleteAllForAction(
          //   session,
          //   actionId: sequentialAction.id!,
          // );
          //
          // final remaining = await ActionStepService.findByActionId(
          //   session,
          //   actionId: sequentialAction.id!,
          // );
          // expect(remaining, isEmpty);
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'is a no-op if action has no steps',
        () async {
          // Expect no exception.
          // await ActionStepService.deleteAllForAction(
          //   session,
          //   actionId: sequentialAction.id!,
          // );
        },
        skip: 'Requires serverpod_test database session',
      );
    });

    // -------------------------------------------------------------------------
    // countForAction()
    // -------------------------------------------------------------------------

    group('countForAction()', () {
      test(
        'returns correct count of steps',
        () async {
          // for (var i = 1; i <= 3; i++) {
          //   await ActionStepService.create(
          //     session,
          //     actionId: sequentialAction.id!,
          //     stepNumber: i,
          //     title: 'Step $i',
          //     verificationCriteria: 'criteria',
          //   );
          // }
          //
          // final count = await ActionStepService.countForAction(
          //   session,
          //   actionId: sequentialAction.id!,
          // );
          // expect(count, equals(3));
        },
        skip: 'Requires serverpod_test database session',
      );

      test(
        'returns 0 for action with no steps',
        () async {
          // final count = await ActionStepService.countForAction(
          //   session,
          //   actionId: sequentialAction.id!,
          // );
          // expect(count, equals(0));
        },
        skip: 'Requires serverpod_test database session',
      );
    });
  });
}
