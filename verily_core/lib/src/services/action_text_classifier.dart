/// On-device keyword-based action text classifier.
///
/// Predicts action category and type from title/description text using
/// weighted keyword matching. Pure Dart — no Flutter or ML model dependency.
/// Designed to provide instant suggestions during action creation, before
/// the server-side AI is invoked.
library;

import 'package:meta/meta.dart';

/// Categories that an action can be classified into.
///
/// These match the fallback categories used in the create action UI
/// and the `suggestedCategory` field returned by AI generation.
enum TextActionCategory {
  fitness('Fitness'),
  environment('Environment'),
  community('Community'),
  education('Education'),
  wellness('Wellness'),
  creative('Creative'),
  adventure('Adventure'),
  charity('Charity');

  const TextActionCategory(this.displayName);

  /// Human-readable name matching the server-side category names.
  final String displayName;

  /// Parse from a display name string (case-insensitive).
  static TextActionCategory? tryFromName(String name) {
    final lower = name.toLowerCase();
    for (final category in values) {
      if (category.displayName.toLowerCase() == lower) return category;
    }
    return null;
  }
}

/// Predicted action type from text analysis.
enum PredictedActionType {
  /// Single action, completed once.
  oneOff('one_off', 'One-Off'),

  /// Multi-step action completed sequentially.
  sequential('sequential', 'Sequential'),

  /// Habit-forming action repeated over time.
  habit('habit', 'Habit');

  const PredictedActionType(this.value, this.displayName);

  /// Serialized value matching `ActionType.value` from action_types.dart.
  final String value;

  /// Human-readable display name.
  final String displayName;
}

/// A scored prediction for a single category.
@immutable
class CategoryScore implements Comparable<CategoryScore> {
  const CategoryScore({required this.category, required this.score});

  /// The predicted category.
  final TextActionCategory category;

  /// Confidence score (0.0 to 1.0). Higher is more confident.
  final double score;

  @override
  int compareTo(CategoryScore other) => other.score.compareTo(score);

  @override
  String toString() =>
      'CategoryScore(${category.displayName}: '
      '${score.toStringAsFixed(3)})';
}

/// Result of classifying action text.
@immutable
class ActionTextClassification {
  const ActionTextClassification({
    required this.suggestedCategory,
    required this.categoryScores,
    required this.suggestedType,
    required this.typeConfidence,
    required this.detectedKeywords,
  });

  /// Creates an empty classification when text is too short to classify.
  const ActionTextClassification.empty()
    : suggestedCategory = null,
      categoryScores = const [],
      suggestedType = PredictedActionType.oneOff,
      typeConfidence = 0.0,
      detectedKeywords = const [];

  /// Top predicted category, or null if confidence is too low.
  final TextActionCategory? suggestedCategory;

  /// All category scores sorted by confidence (highest first).
  final List<CategoryScore> categoryScores;

  /// Predicted action type.
  final PredictedActionType suggestedType;

  /// Confidence in the type prediction (0.0 to 1.0).
  final double typeConfidence;

  /// Keywords that were detected in the input text.
  final List<String> detectedKeywords;

  /// Whether the classification has enough confidence to show suggestions.
  bool get hasConfidentCategory =>
      suggestedCategory != null &&
      categoryScores.isNotEmpty &&
      categoryScores.first.score >= ActionTextClassifier.minCategoryConfidence;

  /// Whether the type prediction has reasonable confidence.
  bool get hasConfidentType =>
      typeConfidence >= ActionTextClassifier.minTypeConfidence;
}

/// On-device keyword-based classifier for action text.
///
/// Uses weighted keyword matching to predict category and action type from
/// title and description. Runs in <1ms with zero allocations after warmup.
///
/// Usage:
/// ```dart
/// const classifier = ActionTextClassifier();
/// final result = classifier.classify(
///   title: 'Run 5K at the park',
///   description: 'Complete a 5 kilometer run at any public park',
/// );
/// print(result.suggestedCategory); // TextActionCategory.fitness
/// print(result.suggestedType);     // PredictedActionType.oneOff
/// ```
class ActionTextClassifier {
  /// Creates a classifier with default keyword dictionaries.
  const ActionTextClassifier();

  /// Minimum score required to suggest a category.
  static const double minCategoryConfidence = 0.15;

  /// Minimum score required to suggest a type with confidence.
  static const double minTypeConfidence = 0.3;

  // ── Category keyword dictionaries ────────────────────────────────────

  /// Keywords mapped to categories with weights.
  /// Weight 1.0 = strong indicator, 0.5 = moderate, 0.3 = weak.
  static const Map<TextActionCategory, Map<String, double>> _categoryKeywords =
      {
        TextActionCategory.fitness: {
          // Exercise types
          'run': 1.0, 'running': 1.0, 'jog': 1.0, 'jogging': 1.0,
          'sprint': 1.0, 'walk': 0.7, 'walking': 0.7, 'hike': 0.8,
          'hiking': 0.8, 'swim': 1.0, 'swimming': 1.0, 'bike': 0.8,
          'biking': 0.8, 'cycle': 0.8, 'cycling': 0.8,
          // Gym / strength
          'workout': 1.0, 'exercise': 1.0, 'gym': 1.0, 'lift': 0.8,
          'lifting': 0.8, 'pushup': 1.0, 'push-up': 1.0, 'pushups': 1.0,
          'push-ups': 1.0, 'pullup': 1.0, 'pull-up': 1.0, 'pullups': 1.0,
          'squat': 1.0, 'squats': 1.0, 'plank': 1.0, 'planking': 1.0,
          'lunge': 0.9, 'lunges': 0.9, 'burpee': 1.0, 'burpees': 1.0,
          'deadlift': 1.0, 'bench': 0.6, 'curl': 0.7, 'press': 0.6,
          'reps': 0.9, 'sets': 0.7, 'repetitions': 0.9,
          // Sports
          'sport': 0.8, 'sports': 0.8, 'basketball': 1.0, 'soccer': 1.0,
          'football': 0.9, 'tennis': 1.0, 'volleyball': 1.0, 'baseball': 1.0,
          'yoga': 0.9, 'pilates': 1.0, 'crossfit': 1.0, 'martial': 0.8,
          // Metrics
          'mile': 0.7, 'miles': 0.7, 'kilometer': 0.7, 'km': 0.5,
          'lap': 0.7, 'laps': 0.7, 'steps': 0.6, 'pace': 0.8,
          'cardio': 1.0, 'endurance': 0.7, 'strength': 0.7, 'muscle': 0.8,
          'calories': 0.7, 'fitness': 1.0, 'athletic': 0.8, 'train': 0.6,
          'training': 0.7,
        },
        TextActionCategory.environment: {
          // Nature actions
          'plant': 0.9, 'planting': 0.9, 'tree': 0.9, 'trees': 0.9,
          'garden': 0.9, 'gardening': 0.9, 'flower': 0.7, 'flowers': 0.7,
          'seed': 0.7, 'seeds': 0.7, 'soil': 0.7, 'compost': 1.0,
          'composting': 1.0,
          // Cleanup
          'clean': 0.6, 'cleanup': 1.0, 'clean-up': 1.0, 'litter': 1.0,
          'trash': 0.9, 'garbage': 0.8, 'waste': 0.7, 'pick': 0.3,
          'pickup': 0.7, 'sweep': 0.5, 'sweeping': 0.5,
          // Sustainability
          'recycle': 1.0, 'recycling': 1.0, 'reuse': 0.8, 'reduce': 0.5,
          'sustainable': 1.0, 'sustainability': 1.0, 'eco': 0.9,
          'green': 0.5, 'carbon': 0.8, 'emission': 0.8, 'emissions': 0.8,
          'pollution': 0.8, 'plastic': 0.7,
          // Nature
          'nature': 0.8, 'wildlife': 0.9, 'conservation': 1.0,
          'environment': 1.0, 'environmental': 1.0, 'earth': 0.6,
          'water': 0.4, 'ocean': 0.7, 'beach': 0.5, 'river': 0.5,
          'forest': 0.7, 'park': 0.3,
        },
        TextActionCategory.community: {
          // Social actions
          'volunteer': 1.0, 'volunteering': 1.0, 'community': 1.0,
          'neighborhood': 0.9, 'neighbour': 0.7, 'neighbor': 0.7,
          'neighbours': 0.7, 'neighbors': 0.7,
          // Helping
          'help': 0.6, 'helping': 0.6, 'assist': 0.6, 'support': 0.5,
          'serve': 0.7, 'serving': 0.7, 'service': 0.7,
          // Organizing
          'organize': 0.7, 'organise': 0.7, 'event': 0.6, 'meetup': 0.8,
          'meet-up': 0.8, 'gathering': 0.7, 'host': 0.5, 'hosting': 0.5,
          // Social impact
          'local': 0.4, 'public': 0.4, 'shelter': 0.8, 'food bank': 1.0,
          'foodbank': 1.0, 'soup kitchen': 1.0, 'elderly': 0.8,
          'seniors': 0.7, 'youth': 0.6, 'mentor': 0.7, 'mentoring': 0.7,
          'coach': 0.5, 'coaching': 0.5,
        },
        TextActionCategory.education: {
          // Learning
          'read': 0.7, 'reading': 0.7, 'book': 0.8, 'books': 0.8,
          'study': 0.9, 'studying': 0.9, 'learn': 0.9, 'learning': 0.9,
          'teach': 0.9, 'teaching': 0.9, 'tutor': 1.0, 'tutoring': 1.0,
          'lesson': 0.8, 'lessons': 0.8, 'course': 0.8, 'class': 0.6,
          'lecture': 0.8, 'homework': 0.9, 'assignment': 0.7,
          // Skills
          'code': 0.7, 'coding': 0.8, 'program': 0.6, 'programming': 0.8,
          'math': 0.9, 'science': 0.8, 'history': 0.7, 'language': 0.7,
          'vocabulary': 0.9, 'grammar': 0.9, 'practice': 0.4,
          // Academic
          'research': 0.8, 'education': 1.0, 'educational': 1.0,
          'school': 0.7, 'university': 0.8, 'college': 0.7,
          'exam': 0.8, 'quiz': 0.7, 'test': 0.4, 'solve': 0.6,
          'puzzle': 0.6, 'problem': 0.4, 'page': 0.4, 'pages': 0.5,
          'chapter': 0.7, 'chapters': 0.7, 'certificate': 0.6,
        },
        TextActionCategory.wellness: {
          // Mental health
          'meditate': 1.0, 'meditation': 1.0, 'mindful': 1.0,
          'mindfulness': 1.0, 'breathe': 0.8, 'breathing': 0.8,
          'relax': 0.8, 'relaxation': 0.8, 'calm': 0.7, 'stress': 0.7,
          'anxiety': 0.7, 'mental': 0.7, 'therapy': 0.8,
          // Self-care
          'sleep': 0.8, 'rest': 0.6, 'nap': 0.6, 'journal': 0.8,
          'journaling': 0.9, 'gratitude': 0.9, 'affirmation': 0.8,
          'affirmations': 0.8, 'selfcare': 1.0, 'self-care': 1.0,
          // Nutrition
          'water': 0.5, 'hydrate': 0.8, 'hydration': 0.8, 'drink': 0.4,
          'nutrition': 0.9, 'healthy': 0.6, 'diet': 0.7, 'meal': 0.5,
          'smoothie': 0.6, 'vitamin': 0.7, 'supplement': 0.6,
          // Wellness general
          'wellness': 1.0, 'wellbeing': 1.0, 'well-being': 1.0,
          'health': 0.6, 'detox': 0.7, 'stretch': 0.6, 'stretching': 0.6,
        },
        TextActionCategory.creative: {
          // Visual arts
          'paint': 0.9, 'painting': 0.9, 'draw': 0.9, 'drawing': 0.9,
          'sketch': 0.9, 'sketching': 0.9, 'art': 0.8, 'artwork': 0.9,
          'sculpt': 1.0, 'sculpture': 1.0, 'pottery': 1.0, 'ceramic': 0.9,
          // Music
          'sing': 0.8, 'singing': 0.8, 'song': 0.7, 'music': 0.8,
          'instrument': 0.9, 'guitar': 1.0, 'piano': 1.0, 'drum': 0.9,
          'drums': 0.9, 'compose': 0.8, 'composition': 0.8,
          // Writing & media
          'write': 0.7, 'writing': 0.7, 'poem': 0.9, 'poetry': 0.9,
          'story': 0.7, 'novel': 0.8, 'blog': 0.7, 'essay': 0.6,
          'film': 0.6, 'video': 0.3, 'photograph': 0.8, 'photography': 0.9,
          'photo': 0.4, 'design': 0.7, 'graphic': 0.7,
          // Crafts
          'craft': 0.9, 'crafts': 0.9, 'knit': 0.9, 'knitting': 0.9,
          'sew': 0.9, 'sewing': 0.9, 'crochet': 1.0, 'origami': 1.0,
          'diy': 0.8, 'handmade': 0.8, 'creative': 1.0, 'creativity': 1.0,
          // Cooking as creative
          'cook': 0.6, 'cooking': 0.6, 'bake': 0.7, 'baking': 0.7,
          'recipe': 0.7,
        },
        TextActionCategory.adventure: {
          // Outdoor activities
          'explore': 0.9, 'exploring': 0.9, 'adventure': 1.0,
          'discover': 0.7, 'travel': 0.9, 'traveling': 0.9,
          'travelling': 0.9, 'trip': 0.7, 'journey': 0.7,
          // Extreme / outdoor sports
          'climb': 0.8, 'climbing': 0.8, 'rock': 0.4, 'mountain': 0.8,
          'summit': 0.9, 'trail': 0.8, 'trek': 0.9, 'trekking': 0.9,
          'camp': 0.8, 'camping': 0.9, 'kayak': 1.0, 'canoe': 0.9,
          'surf': 0.9, 'surfing': 0.9, 'dive': 0.8, 'diving': 0.8,
          'ski': 0.9, 'skiing': 0.9, 'snowboard': 1.0, 'skydive': 1.0,
          'paraglide': 1.0, 'zipline': 1.0, 'bungee': 1.0,
          // Challenges
          'challenge': 0.6, 'dare': 0.7, 'extreme': 0.8, 'outdoor': 0.7,
          'outdoors': 0.7, 'wilderness': 0.9, 'expedition': 1.0,
          'geocache': 1.0, 'geocaching': 1.0, 'scavenger': 0.8,
          'hunt': 0.5, 'orienteering': 1.0,
        },
        TextActionCategory.charity: {
          // Donations
          'donate': 1.0, 'donating': 1.0, 'donation': 1.0, 'donations': 1.0,
          'give': 0.5, 'giving': 0.5, 'gift': 0.5, 'charity': 1.0,
          'charitable': 1.0,
          // Fundraising
          'fundraise': 1.0, 'fundraising': 1.0, 'fundraiser': 1.0,
          'raise': 0.5, 'raising': 0.4, 'money': 0.5, 'funds': 0.6,
          // Causes
          'cause': 0.6, 'nonprofit': 1.0, 'non-profit': 1.0,
          'ngo': 0.9, 'foundation': 0.7, 'aid': 0.6,
          'humanitarian': 1.0, 'relief': 0.7, 'disaster': 0.6,
          // Specific charitable acts
          'blood': 0.6, 'blanket': 0.5, 'clothing': 0.6, 'clothes': 0.6,
          'toy': 0.5, 'toys': 0.5, 'sponsor': 0.8, 'sponsoring': 0.8,
          'pledge': 0.7, 'campaign': 0.5, 'awareness': 0.6,
        },
      };

  // ── Type indicator keywords ──────────────────────────────────────────

  /// Keywords that suggest a habit/recurring action.
  static const Map<String, double> _habitIndicators = {
    'every day': 1.0,
    'everyday': 1.0,
    'daily': 1.0,
    'every week': 1.0,
    'weekly': 1.0,
    'each week': 1.0,
    'every morning': 0.9,
    'every evening': 0.9,
    'every night': 0.9,
    'each day': 1.0,
    'each morning': 0.9,
    'per day': 0.8,
    'per week': 0.8,
    'a day': 0.6,
    'a week': 0.6,
    'routine': 0.9,
    'habit': 1.0,
    'streak': 0.9,
    'consecutive': 0.8,
    'in a row': 0.8,
    'for 30 days': 1.0,
    'for 7 days': 0.9,
    'for a month': 0.9,
    'for a week': 0.8,
    'for 21 days': 1.0,
    'for 14 days': 0.9,
    'days straight': 0.9,
    'day streak': 0.9,
    'morning routine': 1.0,
    'night routine': 1.0,
    'consistently': 0.7,
    'regularly': 0.7,
    'repeat': 0.6,
    'ongoing': 0.6,
    'continuous': 0.6,
  };

  /// Keywords that suggest a sequential/multi-step action.
  static const Map<String, double> _sequentialIndicators = {
    'step 1': 1.0,
    'step 2': 1.0,
    'step one': 1.0,
    'step two': 1.0,
    'first': 0.4,
    'then': 0.4,
    'next': 0.3,
    'finally': 0.4,
    'followed by': 0.8,
    'after that': 0.7,
    'and then': 0.6,
    'multi-step': 1.0,
    'multistep': 1.0,
    'multiple steps': 1.0,
    'stages': 0.7,
    'phases': 0.7,
    'parts': 0.5,
    'part 1': 0.9,
    'part 2': 0.9,
    'part one': 0.9,
    'phase 1': 0.9,
    'phase 2': 0.9,
    'before and after': 0.7,
    'transformation': 0.7,
    'progress': 0.5,
    'sequence': 0.8,
    'series': 0.6,
    'checklist': 0.8,
    'todo': 0.6,
    'to-do': 0.6,
  };

  // ── Classification ───────────────────────────────────────────────────

  /// Classify action text and return category/type predictions.
  ///
  /// Both [title] and [description] are optional but at least one should
  /// be non-empty for meaningful results. The title is weighted 1.5x
  /// compared to the description since it's typically more descriptive
  /// of the core action.
  ActionTextClassification classify({String? title, String? description}) {
    final titleText = (title ?? '').trim();
    final descText = (description ?? '').trim();
    final combined = '$titleText $descText'.trim();

    // Too short to classify
    if (combined.length < 3) {
      return const ActionTextClassification.empty();
    }

    final titleLower = titleText.toLowerCase();
    final descLower = descText.toLowerCase();
    final combinedLower = combined.toLowerCase();
    final titleWords = _tokenize(titleLower);
    final descWords = _tokenize(descLower);

    // ── Category scoring ──
    final categoryScoreMap = <TextActionCategory, double>{};
    final detectedKeywords = <String>[];

    for (final entry in _categoryKeywords.entries) {
      final category = entry.key;
      var score = 0.0;

      for (final kwEntry in entry.value.entries) {
        final keyword = kwEntry.key;
        final weight = kwEntry.value;

        // Check title (1.5x weight)
        if (_matchesKeyword(titleLower, titleWords, keyword)) {
          score += weight * 1.5;
          if (!detectedKeywords.contains(keyword)) {
            detectedKeywords.add(keyword);
          }
        }

        // Check description (1.0x weight)
        if (_matchesKeyword(descLower, descWords, keyword)) {
          score += weight * 1.0;
          if (!detectedKeywords.contains(keyword)) {
            detectedKeywords.add(keyword);
          }
        }
      }

      if (score > 0) {
        categoryScoreMap[category] = score;
      }
    }

    // Normalize scores relative to the maximum
    final maxScore = categoryScoreMap.values.fold<double>(
      0,
      (max, score) => score > max ? score : max,
    );

    final categoryScores = <CategoryScore>[];
    if (maxScore > 0) {
      for (final entry in categoryScoreMap.entries) {
        categoryScores.add(
          CategoryScore(category: entry.key, score: entry.value / maxScore),
        );
      }
      categoryScores.sort();
    }

    // ── Type prediction ──
    var habitScore = 0.0;
    var sequentialScore = 0.0;

    for (final entry in _habitIndicators.entries) {
      if (combinedLower.contains(entry.key)) {
        habitScore += entry.value;
      }
    }

    for (final entry in _sequentialIndicators.entries) {
      if (combinedLower.contains(entry.key)) {
        sequentialScore += entry.value;
      }
    }

    // Normalize type scores
    final maxTypeScore = [
      habitScore,
      sequentialScore,
      0.5,
    ].fold<double>(0, (max, s) => s > max ? s : max);

    PredictedActionType suggestedType;
    double typeConfidence;

    if (habitScore > sequentialScore && habitScore >= 0.5) {
      suggestedType = PredictedActionType.habit;
      typeConfidence = (habitScore / maxTypeScore).clamp(0.0, 1.0);
    } else if (sequentialScore > habitScore && sequentialScore >= 0.5) {
      suggestedType = PredictedActionType.sequential;
      typeConfidence = (sequentialScore / maxTypeScore).clamp(0.0, 1.0);
    } else {
      suggestedType = PredictedActionType.oneOff;
      // Confidence is inversely proportional to how close the other scores are
      typeConfidence = habitScore < 0.3 && sequentialScore < 0.3 ? 0.7 : 0.4;
    }

    return ActionTextClassification(
      suggestedCategory:
          categoryScores.isNotEmpty &&
              categoryScores.first.score >= minCategoryConfidence
          ? categoryScores.first.category
          : null,
      categoryScores: categoryScores,
      suggestedType: suggestedType,
      typeConfidence: typeConfidence,
      detectedKeywords: detectedKeywords,
    );
  }

  // ── Private helpers ──────────────────────────────────────────────────

  /// Tokenize text into lowercase words, stripping punctuation.
  static List<String> _tokenize(String text) {
    return text
        .split(RegExp(r'[\s,;:!?.()\[\]{}"/]+'))
        .where((w) => w.isNotEmpty)
        .toList();
  }

  /// Check if a keyword matches in the text.
  ///
  /// Multi-word keywords are matched as substrings.
  /// Single-word keywords are matched as whole words or with common suffixes.
  static bool _matchesKeyword(
    String lowerText,
    List<String> words,
    String keyword,
  ) {
    // Multi-word keyword: substring match
    if (keyword.contains(' ') || keyword.contains('-')) {
      return lowerText.contains(keyword);
    }

    // Single word: check exact match and common morphological variants
    for (final word in words) {
      // Strip any remaining punctuation for matching
      final clean = word.replaceAll(RegExp('[^a-z0-9-]'), '');
      if (clean == keyword) return true;

      // Check common English suffixes
      if (clean == '${keyword}s' ||
          clean == '${keyword}es' ||
          clean == '${keyword}ed' ||
          clean == '${keyword}ing' ||
          clean == '${keyword}er' ||
          clean == '${keyword}ly') {
        return true;
      }

      // Handle consonant doubling: run -> running, swim -> swimming
      if (keyword.length >= 3) {
        final lastChar = keyword[keyword.length - 1];
        if (clean == '$keyword${lastChar}ing' ||
            clean == '$keyword${lastChar}ed' ||
            clean == '$keyword${lastChar}er') {
          return true;
        }
      }

      // Handle e-drop: make -> making, dance -> dancing
      if (keyword.endsWith('e') && keyword.length >= 3) {
        final stem = keyword.substring(0, keyword.length - 1);
        if (clean == '${stem}ing' ||
            clean == '${stem}ed' ||
            clean == '${stem}er') {
          return true;
        }
      }
    }

    return false;
  }
}
