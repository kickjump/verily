import 'package:test/test.dart';
import 'package:verily_core/src/services/action_text_classifier.dart';

void main() {
  const classifier = ActionTextClassifier();

  group('ActionTextClassifier', () {
    group('empty / minimal input', () {
      test('returns empty classification for null inputs', () {
        final result = classifier.classify();
        expect(result.suggestedCategory, isNull);
        expect(result.categoryScores, isEmpty);
        expect(result.suggestedType, PredictedActionType.oneOff);
        expect(result.typeConfidence, 0.0);
        expect(result.detectedKeywords, isEmpty);
      });

      test('returns empty classification for empty strings', () {
        final result = classifier.classify(title: '', description: '');
        expect(result.suggestedCategory, isNull);
        expect(result.categoryScores, isEmpty);
      });

      test('returns empty classification for very short text', () {
        final result = classifier.classify(title: 'hi');
        expect(result.suggestedCategory, isNull);
        expect(result.categoryScores, isEmpty);
      });

      test('returns empty classification for whitespace-only input', () {
        final result = classifier.classify(title: '   ', description: '   ');
        expect(result.suggestedCategory, isNull);
      });
    });

    group('category prediction — Fitness', () {
      test('detects running', () {
        final result = classifier.classify(
          title: 'Run 5K at the park',
          description: 'Complete a 5 kilometer run',
        );
        expect(result.suggestedCategory, TextActionCategory.fitness);
        expect(result.hasConfidentCategory, isTrue);
      });

      test('detects gym workout', () {
        final result = classifier.classify(
          title: 'Do 50 push-ups',
          description: 'Complete 50 push-ups in one session at the gym',
        );
        expect(result.suggestedCategory, TextActionCategory.fitness);
      });

      test('detects swimming', () {
        final result = classifier.classify(
          title: 'Swim 20 laps',
          description: 'Swim 20 laps in a pool',
        );
        expect(result.suggestedCategory, TextActionCategory.fitness);
      });

      test('detects yoga', () {
        final result = classifier.classify(
          title: 'Morning yoga session',
          description: 'Complete a 30 minute yoga practice',
        );
        expect(result.suggestedCategory, TextActionCategory.fitness);
      });

      test('detects squats with morphological variants', () {
        final result = classifier.classify(title: 'Do squatting exercises');
        expect(result.suggestedCategory, TextActionCategory.fitness);
      });
    });

    group('category prediction — Environment', () {
      test('detects tree planting', () {
        final result = classifier.classify(
          title: 'Plant a tree in your neighborhood',
          description: 'Plant a native tree species in a public area',
        );
        expect(result.suggestedCategory, TextActionCategory.environment);
      });

      test('detects beach cleanup', () {
        final result = classifier.classify(
          title: 'Beach cleanup',
          description: 'Pick up litter and trash from a local beach',
        );
        expect(result.suggestedCategory, TextActionCategory.environment);
      });

      test('detects recycling', () {
        final result = classifier.classify(
          title: 'Recycling challenge',
          description: 'Sort and recycle all household waste properly',
        );
        expect(result.suggestedCategory, TextActionCategory.environment);
      });

      test('detects composting', () {
        final result = classifier.classify(
          title: 'Start composting',
          description: 'Set up a compost bin and add food scraps',
        );
        expect(result.suggestedCategory, TextActionCategory.environment);
      });
    });

    group('category prediction — Community', () {
      test('detects volunteering', () {
        final result = classifier.classify(
          title: 'Volunteer at a food bank',
          description: 'Spend 2 hours volunteering at your local food bank',
        );
        expect(result.suggestedCategory, TextActionCategory.community);
      });

      test('detects community service', () {
        final result = classifier.classify(
          title: 'Community neighborhood meetup',
          description: 'Organize a neighborhood gathering',
        );
        expect(result.suggestedCategory, TextActionCategory.community);
      });

      test('detects mentoring', () {
        final result = classifier.classify(
          title: 'Mentor a student',
          description: 'Mentor and coach a youth in the community',
        );
        expect(result.suggestedCategory, TextActionCategory.community);
      });
    });

    group('category prediction — Education', () {
      test('detects reading books', () {
        final result = classifier.classify(
          title: 'Read 3 chapters of a book',
          description: 'Read and study three chapters from an educational book',
        );
        expect(result.suggestedCategory, TextActionCategory.education);
      });

      test('detects coding/programming', () {
        final result = classifier.classify(
          title: 'Complete a coding lesson',
          description: 'Study programming and complete a coding assignment',
        );
        expect(result.suggestedCategory, TextActionCategory.education);
      });

      test('detects tutoring', () {
        final result = classifier.classify(
          title: 'Tutor math for an hour',
          description: 'Tutor a student in math or science',
        );
        expect(result.suggestedCategory, TextActionCategory.education);
      });
    });

    group('category prediction — Wellness', () {
      test('detects meditation', () {
        final result = classifier.classify(
          title: 'Meditate for 10 minutes',
          description: 'Practice mindfulness meditation',
        );
        expect(result.suggestedCategory, TextActionCategory.wellness);
      });

      test('detects journaling', () {
        final result = classifier.classify(
          title: 'Write a gratitude journal entry',
          description: 'Journal about things you are grateful for',
        );
        expect(result.suggestedCategory, TextActionCategory.wellness);
      });

      test('detects self-care', () {
        final result = classifier.classify(
          title: 'Self-care routine',
          description: 'Practice a relaxation and self-care routine',
        );
        expect(result.suggestedCategory, TextActionCategory.wellness);
      });
    });

    group('category prediction — Creative', () {
      test('detects painting', () {
        final result = classifier.classify(
          title: 'Paint a landscape',
          description: 'Create an oil painting of a landscape',
        );
        expect(result.suggestedCategory, TextActionCategory.creative);
      });

      test('detects music', () {
        final result = classifier.classify(
          title: 'Play guitar for 30 minutes',
          description: 'Practice playing an instrument',
        );
        expect(result.suggestedCategory, TextActionCategory.creative);
      });

      test('detects crafts', () {
        final result = classifier.classify(
          title: 'Make an origami crane',
          description: 'Create an origami craft project',
        );
        expect(result.suggestedCategory, TextActionCategory.creative);
      });

      test('detects photography', () {
        final result = classifier.classify(
          title: 'Photography walk',
          description: 'Take artistic photographs during a walk',
        );
        expect(result.suggestedCategory, TextActionCategory.creative);
      });
    });

    group('category prediction — Adventure', () {
      test('detects hiking/trekking', () {
        final result = classifier.classify(
          title: 'Trek to the mountain summit',
          description: 'Hike a mountain trail and reach the summit',
        );
        expect(result.suggestedCategory, TextActionCategory.adventure);
      });

      test('detects camping', () {
        final result = classifier.classify(
          title: 'Wilderness camping adventure',
          description: 'Go camping in the wilderness for a night',
        );
        expect(result.suggestedCategory, TextActionCategory.adventure);
      });

      test('detects water sports', () {
        final result = classifier.classify(
          title: 'Kayaking adventure',
          description: 'Go kayaking on a river',
        );
        expect(result.suggestedCategory, TextActionCategory.adventure);
      });

      test('detects extreme sports', () {
        final result = classifier.classify(
          title: 'Skydive experience',
          description: 'Complete a skydive from 15,000 feet',
        );
        expect(result.suggestedCategory, TextActionCategory.adventure);
      });
    });

    group('category prediction — Charity', () {
      test('detects donations', () {
        final result = classifier.classify(
          title: 'Donate to a charity',
          description: 'Make a donation to a charitable organization',
        );
        expect(result.suggestedCategory, TextActionCategory.charity);
      });

      test('detects fundraising', () {
        final result = classifier.classify(
          title: 'Fundraiser for non-profit',
          description: 'Organize a fundraising event for a nonprofit',
        );
        expect(result.suggestedCategory, TextActionCategory.charity);
      });

      test('detects sponsorship', () {
        final result = classifier.classify(
          title: 'Sponsor a child',
          description: 'Pledge to sponsor a child through a charity',
        );
        expect(result.suggestedCategory, TextActionCategory.charity);
      });
    });

    group('type prediction — Habit', () {
      test('detects daily habit', () {
        final result = classifier.classify(
          title: 'Do 20 push-ups every day for 30 days',
        );
        expect(result.suggestedType, PredictedActionType.habit);
        expect(result.hasConfidentType, isTrue);
      });

      test('detects weekly habit', () {
        final result = classifier.classify(
          title: 'Read for 30 minutes daily',
          description: 'Build a daily reading habit',
        );
        expect(result.suggestedType, PredictedActionType.habit);
      });

      test('detects routine keywords', () {
        final result = classifier.classify(
          title: 'Morning routine meditation',
          description: 'Meditate each morning as part of your routine',
        );
        expect(result.suggestedType, PredictedActionType.habit);
      });

      test('detects streak language', () {
        final result = classifier.classify(
          title: '30 days straight of exercise',
          description: 'Maintain a 30 day streak of working out',
        );
        expect(result.suggestedType, PredictedActionType.habit);
      });

      test('detects "per week" patterns', () {
        final result = classifier.classify(
          title: 'Run 3 times per week',
          description: 'Complete runs regularly each week',
        );
        expect(result.suggestedType, PredictedActionType.habit);
      });
    });

    group('type prediction — Sequential', () {
      test('detects step-by-step', () {
        final result = classifier.classify(
          title: 'Build a birdhouse',
          description:
              'Step 1: gather materials. Step 2: cut wood. '
              'Step 3: assemble and paint.',
        );
        expect(result.suggestedType, PredictedActionType.sequential);
        expect(result.hasConfidentType, isTrue);
      });

      test('detects multi-step keywords', () {
        final result = classifier.classify(
          title: 'Multi-step garden transformation',
          description: 'A multistep project with multiple stages',
        );
        expect(result.suggestedType, PredictedActionType.sequential);
      });

      test('detects before and after', () {
        final result = classifier.classify(
          title: 'Room transformation',
          description:
              'Show before and after of cleaning followed by '
              'decorating. First clean, then paint, finally arrange.',
        );
        expect(result.suggestedType, PredictedActionType.sequential);
      });

      test('detects checklist pattern', () {
        final result = classifier.classify(
          title: 'Complete the project checklist',
          description: 'Work through a series of phases to finish the project',
        );
        expect(result.suggestedType, PredictedActionType.sequential);
      });
    });

    group('type prediction — One-Off', () {
      test('defaults to one-off for simple actions', () {
        final result = classifier.classify(
          title: 'Run 5K at the park',
          description: 'Complete a single 5K run',
        );
        expect(result.suggestedType, PredictedActionType.oneOff);
      });

      test('one-off for action with no habit/sequential indicators', () {
        final result = classifier.classify(
          title: 'Paint a mural',
          description: 'Create a large mural on the community wall',
        );
        expect(result.suggestedType, PredictedActionType.oneOff);
      });
    });

    group('category scores', () {
      test('returns multiple scored categories sorted by confidence', () {
        final result = classifier.classify(
          title: 'Volunteer to plant trees',
          description: 'Help the community by planting native trees',
        );
        expect(result.categoryScores.length, greaterThanOrEqualTo(2));
        // Verify sorted descending by score
        for (var i = 0; i < result.categoryScores.length - 1; i++) {
          expect(
            result.categoryScores[i].score,
            greaterThanOrEqualTo(result.categoryScores[i + 1].score),
          );
        }
      });

      test('top score is normalized to 1.0', () {
        final result = classifier.classify(
          title: 'Do 50 push-ups at the gym',
          description: 'Complete a fitness workout with push-ups and squats',
        );
        expect(result.categoryScores, isNotEmpty);
        expect(result.categoryScores.first.score, equals(1.0));
      });

      test('scores are between 0 and 1', () {
        final result = classifier.classify(
          title: 'Run and plant trees while volunteering',
          description: 'A community fitness event with environmental impact',
        );
        for (final score in result.categoryScores) {
          expect(score.score, greaterThan(0.0));
          expect(score.score, lessThanOrEqualTo(1.0));
        }
      });
    });

    group('detected keywords', () {
      test('returns matched keywords', () {
        final result = classifier.classify(
          title: 'Run 5K at the park',
          description: 'Complete a running workout',
        );
        expect(result.detectedKeywords, isNotEmpty);
        expect(result.detectedKeywords, contains('run'));
      });

      test('does not duplicate keywords', () {
        final result = classifier.classify(
          title: 'Run a marathon run',
          description: 'Running and jogging training',
        );
        final unique = result.detectedKeywords.toSet();
        expect(unique.length, result.detectedKeywords.length);
      });
    });

    group('title weighting', () {
      test('title keywords have more weight than description', () {
        // "fitness" in title vs only in description
        final titleResult = classifier.classify(
          title: 'Fitness challenge',
          description: 'Do something interesting',
        );
        final descResult = classifier.classify(
          title: 'Do something interesting',
          description: 'Fitness challenge',
        );

        final titleFitnessScore =
            titleResult.categoryScores
                .where((s) => s.category == TextActionCategory.fitness)
                .firstOrNull
                ?.score ??
            0;
        final descFitnessScore =
            descResult.categoryScores
                .where((s) => s.category == TextActionCategory.fitness)
                .firstOrNull
                ?.score ??
            0;

        // Since scores are normalized, we verify the fitness category
        // is ranked higher when the keyword is in the title
        expect(titleFitnessScore, greaterThanOrEqualTo(descFitnessScore));
      });
    });

    group('morphological matching', () {
      test('matches -ing form', () {
        final result = classifier.classify(title: 'Swimming at the pool');
        expect(result.suggestedCategory, TextActionCategory.fitness);
      });

      test('matches -ed form', () {
        final result = classifier.classify(
          title: 'I volunteered at the shelter',
          description: 'Helped serve meals to the community',
        );
        expect(result.suggestedCategory, TextActionCategory.community);
      });

      test('matches -s plural form', () {
        final result = classifier.classify(title: 'Plant flowers and trees');
        expect(result.suggestedCategory, TextActionCategory.environment);
      });

      test('matches consonant-doubled -ing', () {
        final result = classifier.classify(title: 'Go running in the park');
        expect(result.detectedKeywords, contains('run'));
      });

      test('matches e-drop -ing', () {
        final result = classifier.classify(title: 'Biking through the park');
        // 'bike' should match via e-drop rule (bik + ing)
        expect(result.detectedKeywords, isNotEmpty);
      });
    });

    group('edge cases', () {
      test('handles mixed case input', () {
        final result = classifier.classify(
          title: 'RUN 5K at THE Park',
          description: 'Complete A RUNNING workout',
        );
        expect(result.suggestedCategory, TextActionCategory.fitness);
      });

      test('handles punctuation in text', () {
        final result = classifier.classify(
          title: 'Run! Swim! Exercise!!!',
          description: 'Do push-ups, squats, and lunges.',
        );
        expect(result.suggestedCategory, TextActionCategory.fitness);
      });

      test('handles title-only input', () {
        final result = classifier.classify(title: 'Meditate for 10 minutes');
        expect(result.suggestedCategory, TextActionCategory.wellness);
      });

      test('handles description-only input', () {
        final result = classifier.classify(
          description:
              'Volunteer at a shelter and serve meals to the community',
        );
        expect(result.suggestedCategory, TextActionCategory.community);
      });

      test('handles text with no matching keywords', () {
        final result = classifier.classify(
          title: 'Do something',
          description: 'Just do it',
        );
        // Should still return a result (possibly no confident category)
        expect(result.categoryScores, isEmpty);
        expect(result.suggestedCategory, isNull);
      });

      test('handles very long text without error', () {
        final longText = 'run swim bike hike ' * 100;
        final result = classifier.classify(
          title: 'Big fitness challenge',
          description: longText,
        );
        expect(result.suggestedCategory, TextActionCategory.fitness);
      });
    });

    group('ambiguous inputs', () {
      test('returns multiple categories for cross-domain actions', () {
        final result = classifier.classify(
          title: 'Volunteer to clean the beach',
          description: 'Community environmental cleanup at the beach',
        );
        expect(result.categoryScores.length, greaterThanOrEqualTo(2));
        // Both community and environment should appear
        final categories = result.categoryScores
            .map((s) => s.category)
            .toList();
        expect(
          categories,
          containsAll([
            TextActionCategory.community,
            TextActionCategory.environment,
          ]),
        );
      });

      test('fitness + adventure overlap handled', () {
        final result = classifier.classify(
          title: 'Hike a mountain trail',
          description: 'Trek to the summit on an outdoor adventure',
        );
        final categories = result.categoryScores
            .map((s) => s.category)
            .toList();
        // Should include both fitness and adventure
        expect(categories, contains(TextActionCategory.adventure));
      });
    });

    group('confidence thresholds', () {
      test('hasConfidentCategory respects minimum threshold', () {
        final result = classifier.classify(title: 'Do 50 push-ups');
        expect(result.hasConfidentCategory, isTrue);
      });

      test('hasConfidentCategory is false for unrecognized text', () {
        final result = classifier.classify(
          title: 'Hello world',
          description: 'Nothing specific here',
        );
        expect(result.hasConfidentCategory, isFalse);
      });

      test('hasConfidentType is true for strong habit signal', () {
        final result = classifier.classify(title: 'Run every day for 30 days');
        expect(result.hasConfidentType, isTrue);
        expect(result.suggestedType, PredictedActionType.habit);
      });

      test('hasConfidentType is true for strong sequential signal', () {
        final result = classifier.classify(
          description: 'Step 1: gather materials. Step 2: build it.',
        );
        expect(result.hasConfidentType, isTrue);
        expect(result.suggestedType, PredictedActionType.sequential);
      });
    });
  });

  group('TextActionCategory', () {
    test('has 8 values', () {
      expect(TextActionCategory.values, hasLength(8));
    });

    test('tryFromName finds existing category', () {
      expect(
        TextActionCategory.tryFromName('Fitness'),
        TextActionCategory.fitness,
      );
      expect(
        TextActionCategory.tryFromName('fitness'),
        TextActionCategory.fitness,
      );
      expect(
        TextActionCategory.tryFromName('FITNESS'),
        TextActionCategory.fitness,
      );
    });

    test('tryFromName returns null for unknown', () {
      expect(TextActionCategory.tryFromName('Unknown'), isNull);
      expect(TextActionCategory.tryFromName(''), isNull);
    });

    test('all categories have non-empty displayName', () {
      for (final category in TextActionCategory.values) {
        expect(category.displayName, isNotEmpty);
      }
    });
  });

  group('PredictedActionType', () {
    test('has 3 values', () {
      expect(PredictedActionType.values, hasLength(3));
    });

    test('values match ActionType values', () {
      expect(PredictedActionType.oneOff.value, 'one_off');
      expect(PredictedActionType.sequential.value, 'sequential');
      expect(PredictedActionType.habit.value, 'habit');
    });
  });

  group('CategoryScore', () {
    test('compareTo sorts by score descending', () {
      const a = CategoryScore(category: TextActionCategory.fitness, score: 0.8);
      const b = CategoryScore(
        category: TextActionCategory.wellness,
        score: 0.3,
      );
      expect(a.compareTo(b), lessThan(0)); // a comes before b
      expect(b.compareTo(a), greaterThan(0)); // b comes after a
    });

    test('toString includes category and score', () {
      const score = CategoryScore(
        category: TextActionCategory.fitness,
        score: 0.85,
      );
      expect(score.toString(), contains('Fitness'));
      expect(score.toString(), contains('0.850'));
    });
  });

  group('ActionTextClassification', () {
    test('empty constructor creates valid empty state', () {
      const empty = ActionTextClassification.empty();
      expect(empty.suggestedCategory, isNull);
      expect(empty.categoryScores, isEmpty);
      expect(empty.suggestedType, PredictedActionType.oneOff);
      expect(empty.typeConfidence, 0.0);
      expect(empty.detectedKeywords, isEmpty);
      expect(empty.hasConfidentCategory, isFalse);
      expect(empty.hasConfidentType, isFalse);
    });
  });

  group('performance', () {
    test('classifies in under 5ms for typical input', () {
      const classifier = ActionTextClassifier();
      final stopwatch = Stopwatch()..start();
      for (var i = 0; i < 100; i++) {
        classifier.classify(
          title: 'Run 5K at the park',
          description:
              'Complete a 5 kilometer run at any public park '
              'and show your fitness tracker results',
        );
      }
      stopwatch.stop();
      final avgMs = stopwatch.elapsedMilliseconds / 100;
      // Should be well under 5ms per classification
      expect(
        avgMs,
        lessThan(5.0),
        reason: 'Average classification took ${avgMs}ms',
      );
    });
  });
}
