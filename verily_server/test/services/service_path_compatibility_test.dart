import 'package:test/test.dart';
import 'package:verily_server/src/services/action_category_service.dart'
    as legacy_action_category_service;
import 'package:verily_server/src/services/action_service.dart'
    as legacy_action_service;
import 'package:verily_server/src/services/action_step_service.dart'
    as legacy_action_step_service;
import 'package:verily_server/src/services/actions/action_category_service.dart'
    as domain_action_category_service;
import 'package:verily_server/src/services/actions/action_service.dart'
    as domain_action_service;
import 'package:verily_server/src/services/actions/action_step_service.dart'
    as domain_action_step_service;
import 'package:verily_server/src/services/actions/ai_action_service.dart'
    as domain_ai_action_service;
import 'package:verily_server/src/services/ai_action_service.dart'
    as legacy_ai_action_service;
import 'package:verily_server/src/services/attestation_service.dart'
    as legacy_attestation_service;
import 'package:verily_server/src/services/bootstrap/seed_service.dart'
    as domain_seed_service;
import 'package:verily_server/src/services/location/location_service.dart'
    as domain_location_service;
import 'package:verily_server/src/services/location/mapbox_geocoding_service.dart'
    as domain_mapbox_geocoding_service;
import 'package:verily_server/src/services/location_service.dart'
    as legacy_location_service;
import 'package:verily_server/src/services/mapbox_geocoding_service.dart'
    as legacy_mapbox_geocoding_service;
import 'package:verily_server/src/services/reward_pool_service.dart'
    as legacy_reward_pool_service;
import 'package:verily_server/src/services/reward_service.dart'
    as legacy_reward_service;
import 'package:verily_server/src/services/rewards/reward_pool_service.dart'
    as domain_reward_pool_service;
import 'package:verily_server/src/services/rewards/reward_service.dart'
    as domain_reward_service;
import 'package:verily_server/src/services/seed_service.dart'
    as legacy_seed_service;
import 'package:verily_server/src/services/social/user_follow_service.dart'
    as domain_user_follow_service;
import 'package:verily_server/src/services/solana_service.dart'
    as legacy_solana_service;
import 'package:verily_server/src/services/submission_service.dart'
    as legacy_submission_service;
import 'package:verily_server/src/services/submissions/submission_service.dart'
    as domain_submission_service;
import 'package:verily_server/src/services/user_follow_service.dart'
    as legacy_user_follow_service;
import 'package:verily_server/src/services/user_profile_service.dart'
    as legacy_user_profile_service;
import 'package:verily_server/src/services/users/user_profile_service.dart'
    as domain_user_profile_service;
import 'package:verily_server/src/services/verification/attestation_service.dart'
    as domain_attestation_service;
import 'package:verily_server/src/services/verification/verification_service.dart'
    as domain_verification_service;
import 'package:verily_server/src/services/verification_service.dart'
    as legacy_verification_service;
import 'package:verily_server/src/services/wallet/solana_service.dart'
    as domain_solana_service;

void main() {
  group('service path compatibility', () {
    test('legacy service paths export the same service types', () {
      expect(
        identical(
          legacy_action_category_service.ActionCategoryService,
          domain_action_category_service.ActionCategoryService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_action_service.ActionService,
          domain_action_service.ActionService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_action_step_service.ActionStepService,
          domain_action_step_service.ActionStepService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_ai_action_service.AiActionService,
          domain_ai_action_service.AiActionService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_seed_service.SeedService,
          domain_seed_service.SeedService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_location_service.LocationService,
          domain_location_service.LocationService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_mapbox_geocoding_service.MapboxGeocodingService,
          domain_mapbox_geocoding_service.MapboxGeocodingService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_reward_service.RewardService,
          domain_reward_service.RewardService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_reward_pool_service.RewardPoolService,
          domain_reward_pool_service.RewardPoolService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_submission_service.SubmissionService,
          domain_submission_service.SubmissionService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_user_follow_service.UserFollowService,
          domain_user_follow_service.UserFollowService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_user_profile_service.UserProfileService,
          domain_user_profile_service.UserProfileService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_attestation_service.AttestationService,
          domain_attestation_service.AttestationService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_verification_service.VerificationService,
          domain_verification_service.VerificationService,
        ),
        isTrue,
      );
      expect(
        identical(
          legacy_solana_service.SolanaService,
          domain_solana_service.SolanaService,
        ),
        isTrue,
      );
    });
  });
}
