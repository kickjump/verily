import 'package:flutter/foundation.dart';

/// Quality level for an action description.
enum DescriptionQuality {
  /// Text is too short to evaluate.
  tooShort,

  /// Description is too vague to be verifiable.
  vague,

  /// Description has some verifiable elements but could be improved.
  fair,

  /// Description is specific and verifiable.
  good,
}

/// Feedback from on-device classification of an action description.
@immutable
class DescriptionFeedback {
  const DescriptionFeedback({
    required this.quality,
    required this.suggestions,
    required this.hasActionVerb,
    required this.hasSpecificity,
    required this.hasVerifiableElement,
    required this.hasMeasurable,
  });

  /// Overall quality classification.
  final DescriptionQuality quality;

  /// Actionable suggestions for improvement.
  final List<String> suggestions;

  /// Whether description contains an action verb (do, run, make, etc.)
  final bool hasActionVerb;

  /// Whether description has specific details (numbers, places, objects).
  final bool hasSpecificity;

  /// Whether description contains visually verifiable elements.
  final bool hasVerifiableElement;

  /// Whether description has measurable criteria (count, duration, distance).
  final bool hasMeasurable;

  /// A score from 0.0 to 1.0 summarising description readiness.
  double get score {
    var s = 0.0;
    if (hasActionVerb) s += 0.25;
    if (hasSpecificity) s += 0.25;
    if (hasVerifiableElement) s += 0.25;
    if (hasMeasurable) s += 0.25;
    return s;
  }
}

/// On-device heuristic classifier that evaluates whether an action description
/// is specific enough for AI verification.
///
/// Runs entirely on-device with zero latency — no network calls, no ML model
/// download. Designed to match what the server-side Gemini expects: action
/// verbs, specificity, measurable criteria, and visually verifiable elements.
class ActionDescriptionClassifier {
  const ActionDescriptionClassifier();

  // ── Word lists ──────────────────────────────────────────────────────────

  static const _actionVerbs = {
    // Physical
    'run', 'walk', 'jog', 'sprint', 'hike', 'swim', 'bike', 'cycle', 'ride',
    'climb', 'jump', 'skip', 'dance', 'stretch', 'lift', 'push', 'pull',
    'carry', 'drag', 'throw', 'catch', 'kick', 'hit', 'punch', 'squat',
    'lunge', 'plank', 'curl', 'press', 'row', 'deadlift', 'bench', 'exercise',
    'workout', 'train', 'practice', 'play',
    // Creative
    'paint', 'draw', 'sketch', 'write', 'compose', 'sing', 'perform',
    'record', 'film', 'photograph', 'sculpt', 'craft', 'build', 'create',
    'design', 'make', 'cook', 'bake', 'brew', 'prepare', 'assemble',
    // Social / community
    'donate', 'volunteer', 'help', 'teach', 'tutor', 'mentor', 'coach',
    'organize', 'host', 'attend', 'join', 'meet', 'greet', 'introduce',
    'share', 'give', 'deliver', 'serve', 'clean', 'sweep', 'collect',
    'pick', 'plant', 'garden', 'water', 'recycle', 'compost', 'sort',
    // Wellness / learning
    'meditate', 'breathe', 'relax', 'read', 'study', 'learn', 'complete',
    'finish', 'solve', 'code', 'program', 'type', 'research',
    // General action
    'do', 'go', 'take', 'visit', 'explore', 'discover', 'try', 'attempt',
    'show', 'demonstrate', 'prove', 'document', 'capture', 'submit',
  };

  static const _verifiableIndicators = {
    // Visual evidence words
    'video', 'photo', 'picture', 'image', 'screenshot', 'recording',
    'selfie', 'footage', 'clip', 'film', 'show', 'showing', 'visible',
    'clearly', 'before', 'after', 'progress',
    // Observable outcomes
    'result', 'outcome', 'proof', 'evidence', 'completed', 'finished',
    'done', 'achievement', 'badge', 'certificate',
    // Context clues for verifiability
    'wearing', 'holding', 'standing', 'sitting', 'outside', 'inside',
    'outdoors', 'indoors', 'location', 'place', 'park', 'gym', 'beach',
    'street', 'home', 'kitchen', 'garden', 'office', 'school', 'library',
    'public', 'neighborhood', 'community',
  };

  static const _measurableIndicators = {
    // Units of measure
    'minutes', 'minute', 'min', 'mins', 'hours', 'hour', 'seconds', 'second',
    'days', 'day', 'weeks', 'week', 'months', 'month',
    'miles', 'mile', 'km', 'kilometers', 'metres', 'meters', 'feet', 'yards',
    'laps', 'reps', 'sets', 'rounds', 'repetitions', 'times',
    'liters', 'litres', 'gallons', 'cups', 'pieces', 'items', 'pages',
    'chapters', 'words', 'calories',
    // Quantifiers
    'at least', 'minimum', 'maximum', 'no more than', 'no less than',
    'between', 'each', 'every', 'per', 'daily', 'weekly',
  };

  // ── Classification logic ────────────────────────────────────────────────

  /// Classify an action description and return instant feedback.
  DescriptionFeedback classify(String text) {
    final trimmed = text.trim();
    final lower = trimmed.toLowerCase();
    final words = lower.split(RegExp(r'\s+'));

    // Too short — don't evaluate further.
    if (trimmed.length < 10 || words.length < 3) {
      return const DescriptionFeedback(
        quality: DescriptionQuality.tooShort,
        suggestions: [],
        hasActionVerb: false,
        hasSpecificity: false,
        hasVerifiableElement: false,
        hasMeasurable: false,
      );
    }

    final hasActionVerb = _checkActionVerb(words);
    final hasSpecificity = _checkSpecificity(lower, words);
    final hasVerifiable = _checkVerifiableElement(lower, words);
    final hasMeasurable = _checkMeasurable(lower, words);

    final suggestions = <String>[];

    if (!hasActionVerb) {
      suggestions.add(
        'Add an action verb — what should the person DO? '
        '(e.g. run, cook, plant, clean)',
      );
    }
    if (!hasSpecificity) {
      suggestions.add(
        'Be more specific — mention a place, object, or detail '
        '(e.g. "at a park", "a tree", "push-ups")',
      );
    }
    if (!hasMeasurable) {
      suggestions.add(
        'Add a measurable goal — how many, how long, or how far? '
        '(e.g. "50 reps", "10 minutes", "1 mile")',
      );
    }
    if (!hasVerifiable) {
      suggestions.add(
        'Describe what the video should show so AI can verify it '
        '(e.g. "show the before and after")',
      );
    }

    // Determine overall quality.
    final trueCount = [
      hasActionVerb,
      hasSpecificity,
      hasVerifiable,
      hasMeasurable,
    ].where((b) => b).length;

    final DescriptionQuality quality;
    if (trueCount >= 3) {
      quality = DescriptionQuality.good;
    } else if (trueCount >= 2) {
      quality = DescriptionQuality.fair;
    } else {
      quality = DescriptionQuality.vague;
    }

    return DescriptionFeedback(
      quality: quality,
      suggestions: suggestions,
      hasActionVerb: hasActionVerb,
      hasSpecificity: hasSpecificity,
      hasVerifiableElement: hasVerifiable,
      hasMeasurable: hasMeasurable,
    );
  }

  // ── Private helpers ─────────────────────────────────────────────────────

  bool _checkActionVerb(List<String> words) {
    // Check each word and also common verb forms (stem match).
    for (final word in words) {
      // Strip trailing punctuation.
      final clean = word.replaceAll(RegExp('[^a-z]'), '');
      if (_actionVerbs.contains(clean)) return true;
      // Check for common -ing/-ed/-s forms.
      for (final verb in _actionVerbs) {
        if (clean == '${verb}s' ||
            clean == '${verb}ing' ||
            clean == '${verb}ed' ||
            clean == '${verb}es' ||
            // Handle consonant doubling: run -> running, swim -> swimming
            clean == '$verb${verb[verb.length - 1]}ing' ||
            // Handle e-drop: make -> making, dance -> dancing
            (verb.endsWith('e') &&
                clean == '${verb.substring(0, verb.length - 1)}ing')) {
          return true;
        }
      }
    }
    return false;
  }

  bool _checkSpecificity(String lower, List<String> words) {
    // Contains a number?
    if (RegExp(r'\d+').hasMatch(lower)) return true;

    // Contains a specific noun/place indicator?
    if (words.length >= 5) {
      // Longer descriptions tend to be more specific.
      // Check for prepositions followed by nouns (at a, in the, etc.)
      final prepPattern = RegExp(
        r'\b(at|in|on|to|from|near|around|inside|outside)\b'
        r'\s+\b(a|an|the|my|your|our|their)\b',
      );
      if (prepPattern.hasMatch(lower)) {
        return true;
      }
    }

    // Longer descriptions with multiple clauses indicate specificity.
    if (lower.length > 80 && words.length >= 12) return true;

    return false;
  }

  bool _checkVerifiableElement(String lower, List<String> words) {
    for (final word in words) {
      final clean = word.replaceAll(RegExp('[^a-z]'), '');
      if (_verifiableIndicators.contains(clean)) return true;
    }
    // Also check multi-word phrases.
    if (lower.contains('before and after') ||
        lower.contains('in the video') ||
        lower.contains('on camera') ||
        lower.contains('take a photo') ||
        lower.contains('take a video') ||
        lower.contains('record a') ||
        lower.contains('film a') ||
        lower.contains('show that') ||
        lower.contains('show the') ||
        lower.contains('clearly show') ||
        lower.contains('must be visible') ||
        lower.contains('can be seen') ||
        lower.contains('should show')) {
      return true;
    }
    return false;
  }

  bool _checkMeasurable(String lower, List<String> words) {
    // Number + unit pattern: "50 reps", "10 minutes", "3 miles"
    if (RegExp(
      r'\d+\s*(minutes?|mins?|hours?|seconds?|days?|weeks?|months?|miles?|km|kilometers?|metres?|meters?|feet|yards?|laps?|reps?|sets?|rounds?|repetitions?|times?|liters?|litres?|gallons?|cups?|pieces?|items?|pages?|chapters?|words?|calories?)',
    ).hasMatch(lower)) {
      return true;
    }

    // Check standalone measurable indicators.
    for (final indicator in _measurableIndicators) {
      if (indicator.contains(' ')) {
        // Multi-word indicator
        if (lower.contains(indicator)) return true;
      } else {
        for (final word in words) {
          final clean = word.replaceAll(RegExp('[^a-z]'), '');
          if (clean == indicator) return true;
        }
      }
    }

    return false;
  }
}
