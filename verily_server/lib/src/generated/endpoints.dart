/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../endpoints/action_category_endpoint.dart' as _i2;
import '../endpoints/action_endpoint.dart' as _i3;
import '../endpoints/action_step_endpoint.dart' as _i4;
import '../endpoints/ai_action_endpoint.dart' as _i5;
import '../endpoints/attestation_endpoint.dart' as _i6;
import '../endpoints/auth_apple_endpoint.dart' as _i7;
import '../endpoints/auth_email_endpoint.dart' as _i8;
import '../endpoints/auth_google_endpoint.dart' as _i9;
import '../endpoints/auth_wallet_endpoint.dart' as _i10;
import '../endpoints/geocoding_endpoint.dart' as _i11;
import '../endpoints/location_endpoint.dart' as _i12;
import '../endpoints/reward_endpoint.dart' as _i13;
import '../endpoints/reward_pool_endpoint.dart' as _i14;
import '../endpoints/seed_endpoint.dart' as _i15;
import '../endpoints/solana_endpoint.dart' as _i16;
import '../endpoints/submission_endpoint.dart' as _i17;
import '../endpoints/user_follow_endpoint.dart' as _i18;
import '../endpoints/user_profile_endpoint.dart' as _i19;
import '../endpoints/verification_endpoint.dart' as _i20;
import 'package:verily_server/src/generated/action_category.dart' as _i21;
import 'package:verily_server/src/generated/action.dart' as _i22;
import 'package:verily_server/src/generated/action_step.dart' as _i23;
import 'package:verily_server/src/generated/location.dart' as _i24;
import 'package:verily_server/src/generated/action_submission.dart' as _i25;
import 'package:verily_server/src/generated/user_profile.dart' as _i26;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i27;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i28;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'actionCategory': _i2.ActionCategoryEndpoint()
        ..initialize(
          server,
          'actionCategory',
          null,
        ),
      'action': _i3.ActionEndpoint()
        ..initialize(
          server,
          'action',
          null,
        ),
      'actionStep': _i4.ActionStepEndpoint()
        ..initialize(
          server,
          'actionStep',
          null,
        ),
      'aiAction': _i5.AiActionEndpoint()
        ..initialize(
          server,
          'aiAction',
          null,
        ),
      'attestation': _i6.AttestationEndpoint()
        ..initialize(
          server,
          'attestation',
          null,
        ),
      'authApple': _i7.AuthAppleEndpoint()
        ..initialize(
          server,
          'authApple',
          null,
        ),
      'authEmail': _i8.AuthEmailEndpoint()
        ..initialize(
          server,
          'authEmail',
          null,
        ),
      'authGoogle': _i9.AuthGoogleEndpoint()
        ..initialize(
          server,
          'authGoogle',
          null,
        ),
      'authWallet': _i10.AuthWalletEndpoint()
        ..initialize(
          server,
          'authWallet',
          null,
        ),
      'geocoding': _i11.GeocodingEndpoint()
        ..initialize(
          server,
          'geocoding',
          null,
        ),
      'location': _i12.LocationEndpoint()
        ..initialize(
          server,
          'location',
          null,
        ),
      'reward': _i13.RewardEndpoint()
        ..initialize(
          server,
          'reward',
          null,
        ),
      'rewardPool': _i14.RewardPoolEndpoint()
        ..initialize(
          server,
          'rewardPool',
          null,
        ),
      'seed': _i15.SeedEndpoint()
        ..initialize(
          server,
          'seed',
          null,
        ),
      'solana': _i16.SolanaEndpoint()
        ..initialize(
          server,
          'solana',
          null,
        ),
      'submission': _i17.SubmissionEndpoint()
        ..initialize(
          server,
          'submission',
          null,
        ),
      'userFollow': _i18.UserFollowEndpoint()
        ..initialize(
          server,
          'userFollow',
          null,
        ),
      'userProfile': _i19.UserProfileEndpoint()
        ..initialize(
          server,
          'userProfile',
          null,
        ),
      'verification': _i20.VerificationEndpoint()
        ..initialize(
          server,
          'verification',
          null,
        ),
    };
    connectors['actionCategory'] = _i1.EndpointConnector(
      name: 'actionCategory',
      endpoint: endpoints['actionCategory']!,
      methodConnectors: {
        'list': _i1.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['actionCategory'] as _i2.ActionCategoryEndpoint)
                      .list(session),
        ),
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'category': _i1.ParameterDescription(
              name: 'category',
              type: _i1.getType<_i21.ActionCategory>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['actionCategory'] as _i2.ActionCategoryEndpoint)
                      .create(
                        session,
                        params['category'],
                      ),
        ),
        'get': _i1.MethodConnector(
          name: 'get',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['actionCategory'] as _i2.ActionCategoryEndpoint)
                      .get(
                        session,
                        params['id'],
                      ),
        ),
      },
    );
    connectors['action'] = _i1.EndpointConnector(
      name: 'action',
      endpoint: endpoints['action']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'action': _i1.ParameterDescription(
              name: 'action',
              type: _i1.getType<_i22.Action>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['action'] as _i3.ActionEndpoint).create(
                session,
                params['action'],
              ),
        ),
        'listActive': _i1.MethodConnector(
          name: 'listActive',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['action'] as _i3.ActionEndpoint).listActive(
                session,
              ),
        ),
        'listNearby': _i1.MethodConnector(
          name: 'listNearby',
          params: {
            'lat': _i1.ParameterDescription(
              name: 'lat',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'lng': _i1.ParameterDescription(
              name: 'lng',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'radiusMeters': _i1.ParameterDescription(
              name: 'radiusMeters',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['action'] as _i3.ActionEndpoint).listNearby(
                session,
                params['lat'],
                params['lng'],
                params['radiusMeters'],
              ),
        ),
        'listInBoundingBox': _i1.MethodConnector(
          name: 'listInBoundingBox',
          params: {
            'southLat': _i1.ParameterDescription(
              name: 'southLat',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'westLng': _i1.ParameterDescription(
              name: 'westLng',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'northLat': _i1.ParameterDescription(
              name: 'northLat',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'eastLng': _i1.ParameterDescription(
              name: 'eastLng',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['action'] as _i3.ActionEndpoint).listInBoundingBox(
                    session,
                    params['southLat'],
                    params['westLng'],
                    params['northLat'],
                    params['eastLng'],
                  ),
        ),
        'listByCategory': _i1.MethodConnector(
          name: 'listByCategory',
          params: {
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['action'] as _i3.ActionEndpoint).listByCategory(
                    session,
                    params['categoryId'],
                  ),
        ),
        'search': _i1.MethodConnector(
          name: 'search',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['action'] as _i3.ActionEndpoint).search(
                session,
                params['query'],
              ),
        ),
        'get': _i1.MethodConnector(
          name: 'get',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['action'] as _i3.ActionEndpoint).get(
                session,
                params['id'],
              ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'action': _i1.ParameterDescription(
              name: 'action',
              type: _i1.getType<_i22.Action>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['action'] as _i3.ActionEndpoint).update(
                session,
                params['action'],
              ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['action'] as _i3.ActionEndpoint).delete(
                session,
                params['id'],
              ),
        ),
        'listByCreator': _i1.MethodConnector(
          name: 'listByCreator',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['action'] as _i3.ActionEndpoint)
                  .listByCreator(session),
        ),
      },
    );
    connectors['actionStep'] = _i1.EndpointConnector(
      name: 'actionStep',
      endpoint: endpoints['actionStep']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'actionStep': _i1.ParameterDescription(
              name: 'actionStep',
              type: _i1.getType<_i23.ActionStep>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['actionStep'] as _i4.ActionStepEndpoint).create(
                    session,
                    params['actionStep'],
                  ),
        ),
        'listByAction': _i1.MethodConnector(
          name: 'listByAction',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['actionStep'] as _i4.ActionStepEndpoint)
                  .listByAction(
                    session,
                    params['actionId'],
                  ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'actionStep': _i1.ParameterDescription(
              name: 'actionStep',
              type: _i1.getType<_i23.ActionStep>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['actionStep'] as _i4.ActionStepEndpoint).update(
                    session,
                    params['actionStep'],
                  ),
        ),
        'delete': _i1.MethodConnector(
          name: 'delete',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['actionStep'] as _i4.ActionStepEndpoint).delete(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['aiAction'] = _i1.EndpointConnector(
      name: 'aiAction',
      endpoint: endpoints['aiAction']!,
      methodConnectors: {
        'generate': _i1.MethodConnector(
          name: 'generate',
          params: {
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'latitude': _i1.ParameterDescription(
              name: 'latitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'longitude': _i1.ParameterDescription(
              name: 'longitude',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['aiAction'] as _i5.AiActionEndpoint).generate(
                    session,
                    params['description'],
                    latitude: params['latitude'],
                    longitude: params['longitude'],
                  ),
        ),
        'generateCriteria': _i1.MethodConnector(
          name: 'generateCriteria',
          params: {
            'actionTitle': _i1.ParameterDescription(
              name: 'actionTitle',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'actionDescription': _i1.ParameterDescription(
              name: 'actionDescription',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['aiAction'] as _i5.AiActionEndpoint)
                  .generateCriteria(
                    session,
                    params['actionTitle'],
                    params['actionDescription'],
                  ),
        ),
        'generateSteps': _i1.MethodConnector(
          name: 'generateSteps',
          params: {
            'actionTitle': _i1.ParameterDescription(
              name: 'actionTitle',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'actionDescription': _i1.ParameterDescription(
              name: 'actionDescription',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'numberOfSteps': _i1.ParameterDescription(
              name: 'numberOfSteps',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['aiAction'] as _i5.AiActionEndpoint).generateSteps(
                    session,
                    params['actionTitle'],
                    params['actionDescription'],
                    params['numberOfSteps'],
                  ),
        ),
      },
    );
    connectors['attestation'] = _i1.EndpointConnector(
      name: 'attestation',
      endpoint: endpoints['attestation']!,
      methodConnectors: {
        'createChallenge': _i1.MethodConnector(
          name: 'createChallenge',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['attestation'] as _i6.AttestationEndpoint)
                  .createChallenge(
                    session,
                    params['actionId'],
                  ),
        ),
        'submitAttestation': _i1.MethodConnector(
          name: 'submitAttestation',
          params: {
            'submissionId': _i1.ParameterDescription(
              name: 'submissionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'platform': _i1.ParameterDescription(
              name: 'platform',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'keyId': _i1.ParameterDescription(
              name: 'keyId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['attestation'] as _i6.AttestationEndpoint)
                  .submitAttestation(
                    session,
                    params['submissionId'],
                    params['platform'],
                    params['token'],
                    keyId: params['keyId'],
                  ),
        ),
      },
    );
    connectors['authApple'] = _i1.EndpointConnector(
      name: 'authApple',
      endpoint: endpoints['authApple']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'identityToken': _i1.ParameterDescription(
              name: 'identityToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'authorizationCode': _i1.ParameterDescription(
              name: 'authorizationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isNativeApplePlatformSignIn': _i1.ParameterDescription(
              name: 'isNativeApplePlatformSignIn',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
            'firstName': _i1.ParameterDescription(
              name: 'firstName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'lastName': _i1.ParameterDescription(
              name: 'lastName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['authApple'] as _i7.AuthAppleEndpoint).login(
                    session,
                    identityToken: params['identityToken'],
                    authorizationCode: params['authorizationCode'],
                    isNativeApplePlatformSignIn:
                        params['isNativeApplePlatformSignIn'],
                    firstName: params['firstName'],
                    lastName: params['lastName'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authApple'] as _i7.AuthAppleEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['authEmail'] = _i1.EndpointConnector(
      name: 'authEmail',
      endpoint: endpoints['authEmail']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['authEmail'] as _i8.AuthEmailEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authEmail'] as _i8.AuthEmailEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authEmail'] as _i8.AuthEmailEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authEmail'] as _i8.AuthEmailEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authEmail'] as _i8.AuthEmailEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authEmail'] as _i8.AuthEmailEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authEmail'] as _i8.AuthEmailEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authEmail'] as _i8.AuthEmailEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['authGoogle'] = _i1.EndpointConnector(
      name: 'authGoogle',
      endpoint: endpoints['authGoogle']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'idToken': _i1.ParameterDescription(
              name: 'idToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'accessToken': _i1.ParameterDescription(
              name: 'accessToken',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['authGoogle'] as _i9.AuthGoogleEndpoint).login(
                    session,
                    idToken: params['idToken'],
                    accessToken: params['accessToken'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authGoogle'] as _i9.AuthGoogleEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['authWallet'] = _i1.EndpointConnector(
      name: 'authWallet',
      endpoint: endpoints['authWallet']!,
      methodConnectors: {
        'requestChallenge': _i1.MethodConnector(
          name: 'requestChallenge',
          params: {
            'publicKey': _i1.ParameterDescription(
              name: 'publicKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authWallet'] as _i10.AuthWalletEndpoint)
                  .requestChallenge(
                    session,
                    params['publicKey'],
                  ),
        ),
        'verifyChallenge': _i1.MethodConnector(
          name: 'verifyChallenge',
          params: {
            'publicKey': _i1.ParameterDescription(
              name: 'publicKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'signatureBase64': _i1.ParameterDescription(
              name: 'signatureBase64',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['authWallet'] as _i10.AuthWalletEndpoint)
                  .verifyChallenge(
                    session,
                    params['publicKey'],
                    params['signatureBase64'],
                  ),
        ),
      },
    );
    connectors['geocoding'] = _i1.EndpointConnector(
      name: 'geocoding',
      endpoint: endpoints['geocoding']!,
      methodConnectors: {
        'searchPlaces': _i1.MethodConnector(
          name: 'searchPlaces',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'proximityLat': _i1.ParameterDescription(
              name: 'proximityLat',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'proximityLng': _i1.ParameterDescription(
              name: 'proximityLng',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['geocoding'] as _i11.GeocodingEndpoint)
                  .searchPlaces(
                    session,
                    params['query'],
                    params['proximityLat'],
                    params['proximityLng'],
                  ),
        ),
        'reverseGeocode': _i1.MethodConnector(
          name: 'reverseGeocode',
          params: {
            'lat': _i1.ParameterDescription(
              name: 'lat',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'lng': _i1.ParameterDescription(
              name: 'lng',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['geocoding'] as _i11.GeocodingEndpoint)
                  .reverseGeocode(
                    session,
                    params['lat'],
                    params['lng'],
                  ),
        ),
      },
    );
    connectors['location'] = _i1.EndpointConnector(
      name: 'location',
      endpoint: endpoints['location']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'location': _i1.ParameterDescription(
              name: 'location',
              type: _i1.getType<_i24.Location>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['location'] as _i12.LocationEndpoint).create(
                    session,
                    params['location'],
                  ),
        ),
        'searchNearby': _i1.MethodConnector(
          name: 'searchNearby',
          params: {
            'lat': _i1.ParameterDescription(
              name: 'lat',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'lng': _i1.ParameterDescription(
              name: 'lng',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'radiusMeters': _i1.ParameterDescription(
              name: 'radiusMeters',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['location'] as _i12.LocationEndpoint).searchNearby(
                    session,
                    params['lat'],
                    params['lng'],
                    params['radiusMeters'],
                  ),
        ),
        'get': _i1.MethodConnector(
          name: 'get',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['location'] as _i12.LocationEndpoint).get(
                session,
                params['id'],
              ),
        ),
      },
    );
    connectors['reward'] = _i1.EndpointConnector(
      name: 'reward',
      endpoint: endpoints['reward']!,
      methodConnectors: {
        'listByAction': _i1.MethodConnector(
          name: 'listByAction',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['reward'] as _i13.RewardEndpoint).listByAction(
                    session,
                    params['actionId'],
                  ),
        ),
        'listByUser': _i1.MethodConnector(
          name: 'listByUser',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reward'] as _i13.RewardEndpoint)
                  .listByUser(session),
        ),
        'getLeaderboard': _i1.MethodConnector(
          name: 'getLeaderboard',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['reward'] as _i13.RewardEndpoint)
                  .getLeaderboard(session),
        ),
      },
    );
    connectors['rewardPool'] = _i1.EndpointConnector(
      name: 'rewardPool',
      endpoint: endpoints['rewardPool']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'rewardType': _i1.ParameterDescription(
              name: 'rewardType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'totalAmount': _i1.ParameterDescription(
              name: 'totalAmount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'perPersonAmount': _i1.ParameterDescription(
              name: 'perPersonAmount',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'tokenMintAddress': _i1.ParameterDescription(
              name: 'tokenMintAddress',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'maxRecipients': _i1.ParameterDescription(
              name: 'maxRecipients',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'expiresAt': _i1.ParameterDescription(
              name: 'expiresAt',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rewardPool'] as _i14.RewardPoolEndpoint).create(
                    session,
                    params['actionId'],
                    params['rewardType'],
                    params['totalAmount'],
                    params['perPersonAmount'],
                    tokenMintAddress: params['tokenMintAddress'],
                    maxRecipients: params['maxRecipients'],
                    expiresAt: params['expiresAt'],
                  ),
        ),
        'get': _i1.MethodConnector(
          name: 'get',
          params: {
            'poolId': _i1.ParameterDescription(
              name: 'poolId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rewardPool'] as _i14.RewardPoolEndpoint).get(
                    session,
                    params['poolId'],
                  ),
        ),
        'listByAction': _i1.MethodConnector(
          name: 'listByAction',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rewardPool'] as _i14.RewardPoolEndpoint)
                  .listByAction(
                    session,
                    params['actionId'],
                  ),
        ),
        'listByCreator': _i1.MethodConnector(
          name: 'listByCreator',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rewardPool'] as _i14.RewardPoolEndpoint)
                  .listByCreator(session),
        ),
        'cancel': _i1.MethodConnector(
          name: 'cancel',
          params: {
            'poolId': _i1.ParameterDescription(
              name: 'poolId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['rewardPool'] as _i14.RewardPoolEndpoint).cancel(
                    session,
                    params['poolId'],
                  ),
        ),
        'getDistributions': _i1.MethodConnector(
          name: 'getDistributions',
          params: {
            'poolId': _i1.ParameterDescription(
              name: 'poolId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['rewardPool'] as _i14.RewardPoolEndpoint)
                  .getDistributions(
                    session,
                    params['poolId'],
                  ),
        ),
      },
    );
    connectors['seed'] = _i1.EndpointConnector(
      name: 'seed',
      endpoint: endpoints['seed']!,
      methodConnectors: {
        'seedDefaultActions': _i1.MethodConnector(
          name: 'seedDefaultActions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['seed'] as _i15.SeedEndpoint)
                  .seedDefaultActions(session),
        ),
      },
    );
    connectors['solana'] = _i1.EndpointConnector(
      name: 'solana',
      endpoint: endpoints['solana']!,
      methodConnectors: {
        'createWallet': _i1.MethodConnector(
          name: 'createWallet',
          params: {
            'label': _i1.ParameterDescription(
              name: 'label',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['solana'] as _i16.SolanaEndpoint).createWallet(
                    session,
                    label: params['label'],
                  ),
        ),
        'linkWallet': _i1.MethodConnector(
          name: 'linkWallet',
          params: {
            'publicKey': _i1.ParameterDescription(
              name: 'publicKey',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'label': _i1.ParameterDescription(
              name: 'label',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['solana'] as _i16.SolanaEndpoint).linkWallet(
                    session,
                    params['publicKey'],
                    label: params['label'],
                  ),
        ),
        'getWallets': _i1.MethodConnector(
          name: 'getWallets',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['solana'] as _i16.SolanaEndpoint)
                  .getWallets(session),
        ),
        'setDefaultWallet': _i1.MethodConnector(
          name: 'setDefaultWallet',
          params: {
            'walletId': _i1.ParameterDescription(
              name: 'walletId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['solana'] as _i16.SolanaEndpoint).setDefaultWallet(
                    session,
                    params['walletId'],
                  ),
        ),
        'getBalance': _i1.MethodConnector(
          name: 'getBalance',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['solana'] as _i16.SolanaEndpoint)
                  .getBalance(session),
        ),
      },
    );
    connectors['submission'] = _i1.EndpointConnector(
      name: 'submission',
      endpoint: endpoints['submission']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'submission': _i1.ParameterDescription(
              name: 'submission',
              type: _i1.getType<_i25.ActionSubmission>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['submission'] as _i17.SubmissionEndpoint).create(
                    session,
                    params['submission'],
                  ),
        ),
        'listByAction': _i1.MethodConnector(
          name: 'listByAction',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['submission'] as _i17.SubmissionEndpoint)
                  .listByAction(
                    session,
                    params['actionId'],
                  ),
        ),
        'listByPerformer': _i1.MethodConnector(
          name: 'listByPerformer',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['submission'] as _i17.SubmissionEndpoint)
                  .listByPerformer(session),
        ),
        'get': _i1.MethodConnector(
          name: 'get',
          params: {
            'id': _i1.ParameterDescription(
              name: 'id',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['submission'] as _i17.SubmissionEndpoint).get(
                    session,
                    params['id'],
                  ),
        ),
        'getSequentialProgress': _i1.MethodConnector(
          name: 'getSequentialProgress',
          params: {
            'actionId': _i1.ParameterDescription(
              name: 'actionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['submission'] as _i17.SubmissionEndpoint)
                  .getSequentialProgress(
                    session,
                    params['actionId'],
                  ),
        ),
      },
    );
    connectors['userFollow'] = _i1.EndpointConnector(
      name: 'userFollow',
      endpoint: endpoints['userFollow']!,
      methodConnectors: {
        'follow': _i1.MethodConnector(
          name: 'follow',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userFollow'] as _i18.UserFollowEndpoint).follow(
                    session,
                    params['userId'],
                  ),
        ),
        'unfollow': _i1.MethodConnector(
          name: 'unfollow',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userFollow'] as _i18.UserFollowEndpoint).unfollow(
                    session,
                    params['userId'],
                  ),
        ),
        'listFollowers': _i1.MethodConnector(
          name: 'listFollowers',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userFollow'] as _i18.UserFollowEndpoint)
                  .listFollowers(
                    session,
                    params['userId'],
                  ),
        ),
        'listFollowing': _i1.MethodConnector(
          name: 'listFollowing',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userFollow'] as _i18.UserFollowEndpoint)
                  .listFollowing(
                    session,
                    params['userId'],
                  ),
        ),
        'isFollowing': _i1.MethodConnector(
          name: 'isFollowing',
          params: {
            'userId': _i1.ParameterDescription(
              name: 'userId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userFollow'] as _i18.UserFollowEndpoint)
                  .isFollowing(
                    session,
                    params['userId'],
                  ),
        ),
      },
    );
    connectors['userProfile'] = _i1.EndpointConnector(
      name: 'userProfile',
      endpoint: endpoints['userProfile']!,
      methodConnectors: {
        'create': _i1.MethodConnector(
          name: 'create',
          params: {
            'profile': _i1.ParameterDescription(
              name: 'profile',
              type: _i1.getType<_i26.UserProfile>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userProfile'] as _i19.UserProfileEndpoint).create(
                    session,
                    params['profile'],
                  ),
        ),
        'get': _i1.MethodConnector(
          name: 'get',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i19.UserProfileEndpoint)
                  .get(session),
        ),
        'getByUsername': _i1.MethodConnector(
          name: 'getByUsername',
          params: {
            'username': _i1.ParameterDescription(
              name: 'username',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['userProfile'] as _i19.UserProfileEndpoint)
                  .getByUsername(
                    session,
                    params['username'],
                  ),
        ),
        'update': _i1.MethodConnector(
          name: 'update',
          params: {
            'profile': _i1.ParameterDescription(
              name: 'profile',
              type: _i1.getType<_i26.UserProfile>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userProfile'] as _i19.UserProfileEndpoint).update(
                    session,
                    params['profile'],
                  ),
        ),
        'search': _i1.MethodConnector(
          name: 'search',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['userProfile'] as _i19.UserProfileEndpoint).search(
                    session,
                    params['query'],
                  ),
        ),
      },
    );
    connectors['verification'] = _i1.EndpointConnector(
      name: 'verification',
      endpoint: endpoints['verification']!,
      methodConnectors: {
        'getBySubmission': _i1.MethodConnector(
          name: 'getBySubmission',
          params: {
            'submissionId': _i1.ParameterDescription(
              name: 'submissionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _i20.VerificationEndpoint)
                      .getBySubmission(
                        session,
                        params['submissionId'],
                      ),
        ),
        'retryVerification': _i1.MethodConnector(
          name: 'retryVerification',
          params: {
            'submissionId': _i1.ParameterDescription(
              name: 'submissionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['verification'] as _i20.VerificationEndpoint)
                      .retryVerification(
                        session,
                        params['submissionId'],
                      ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i27.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i28.Endpoints()
      ..initializeEndpoints(server);
  }
}
