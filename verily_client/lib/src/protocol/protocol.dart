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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'action.dart' as _i2;
import 'action_category.dart' as _i3;
import 'action_step.dart' as _i4;
import 'action_submission.dart' as _i5;
import 'attestation_challenge.dart' as _i6;
import 'device_attestation.dart' as _i7;
import 'location.dart' as _i8;
import 'place_search_result.dart' as _i9;
import 'reward.dart' as _i10;
import 'reward_distribution.dart' as _i11;
import 'reward_pool.dart' as _i12;
import 'solana_wallet.dart' as _i13;
import 'user_follow.dart' as _i14;
import 'user_profile.dart' as _i15;
import 'user_reward.dart' as _i16;
import 'verification_result.dart' as _i17;
import 'package:verily_client/src/protocol/action_category.dart' as _i18;
import 'package:verily_client/src/protocol/action.dart' as _i19;
import 'package:verily_client/src/protocol/action_step.dart' as _i20;
import 'package:verily_core/src/models/ai_generated_action.dart' as _i21;
import 'package:verily_client/src/protocol/place_search_result.dart' as _i22;
import 'package:verily_client/src/protocol/location.dart' as _i23;
import 'package:verily_client/src/protocol/reward.dart' as _i24;
import 'package:verily_client/src/protocol/user_reward.dart' as _i25;
import 'package:verily_client/src/services/reward_service.dart' as _i26;
import 'package:verily_client/src/protocol/reward_pool.dart' as _i27;
import 'package:verily_client/src/protocol/reward_distribution.dart' as _i28;
import 'package:verily_client/src/protocol/solana_wallet.dart' as _i29;
import 'package:verily_client/src/protocol/action_submission.dart' as _i30;
import 'package:verily_client/src/protocol/user_follow.dart' as _i31;
import 'package:verily_client/src/protocol/user_profile.dart' as _i32;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i33;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i34;
export 'action.dart';
export 'action_category.dart';
export 'action_step.dart';
export 'action_submission.dart';
export 'attestation_challenge.dart';
export 'device_attestation.dart';
export 'location.dart';
export 'place_search_result.dart';
export 'reward.dart';
export 'reward_distribution.dart';
export 'reward_pool.dart';
export 'solana_wallet.dart';
export 'user_follow.dart';
export 'user_profile.dart';
export 'user_reward.dart';
export 'verification_result.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(dynamic data, [Type? t]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Action) {
      return _i2.Action.fromJson(data) as T;
    }
    if (t == _i3.ActionCategory) {
      return _i3.ActionCategory.fromJson(data) as T;
    }
    if (t == _i4.ActionStep) {
      return _i4.ActionStep.fromJson(data) as T;
    }
    if (t == _i5.ActionSubmission) {
      return _i5.ActionSubmission.fromJson(data) as T;
    }
    if (t == _i6.AttestationChallenge) {
      return _i6.AttestationChallenge.fromJson(data) as T;
    }
    if (t == _i7.DeviceAttestation) {
      return _i7.DeviceAttestation.fromJson(data) as T;
    }
    if (t == _i8.Location) {
      return _i8.Location.fromJson(data) as T;
    }
    if (t == _i9.PlaceSearchResult) {
      return _i9.PlaceSearchResult.fromJson(data) as T;
    }
    if (t == _i10.Reward) {
      return _i10.Reward.fromJson(data) as T;
    }
    if (t == _i11.RewardDistribution) {
      return _i11.RewardDistribution.fromJson(data) as T;
    }
    if (t == _i12.RewardPool) {
      return _i12.RewardPool.fromJson(data) as T;
    }
    if (t == _i13.SolanaWallet) {
      return _i13.SolanaWallet.fromJson(data) as T;
    }
    if (t == _i14.UserFollow) {
      return _i14.UserFollow.fromJson(data) as T;
    }
    if (t == _i15.UserProfile) {
      return _i15.UserProfile.fromJson(data) as T;
    }
    if (t == _i16.UserReward) {
      return _i16.UserReward.fromJson(data) as T;
    }
    if (t == _i17.VerificationResult) {
      return _i17.VerificationResult.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Action?>()) {
      return (data != null ? _i2.Action.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.ActionCategory?>()) {
      return (data != null ? _i3.ActionCategory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.ActionStep?>()) {
      return (data != null ? _i4.ActionStep.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.ActionSubmission?>()) {
      return (data != null ? _i5.ActionSubmission.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.AttestationChallenge?>()) {
      return (data != null ? _i6.AttestationChallenge.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.DeviceAttestation?>()) {
      return (data != null ? _i7.DeviceAttestation.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Location?>()) {
      return (data != null ? _i8.Location.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.PlaceSearchResult?>()) {
      return (data != null ? _i9.PlaceSearchResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Reward?>()) {
      return (data != null ? _i10.Reward.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.RewardDistribution?>()) {
      return (data != null ? _i11.RewardDistribution.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.RewardPool?>()) {
      return (data != null ? _i12.RewardPool.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.SolanaWallet?>()) {
      return (data != null ? _i13.SolanaWallet.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.UserFollow?>()) {
      return (data != null ? _i14.UserFollow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.UserProfile?>()) {
      return (data != null ? _i15.UserProfile.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.UserReward?>()) {
      return (data != null ? _i16.UserReward.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.VerificationResult?>()) {
      return (data != null ? _i17.VerificationResult.fromJson(data) : null)
          as T;
    }
    if (t == List<_i18.ActionCategory>) {
      return (data as List)
              .map((e) => deserialize<_i18.ActionCategory>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.Action>) {
      return (data as List).map((e) => deserialize<_i19.Action>(e)).toList()
          as T;
    }
    if (t == List<_i20.ActionStep>) {
      return (data as List).map((e) => deserialize<_i20.ActionStep>(e)).toList()
          as T;
    }
    if (t == List<_i21.AiGeneratedStep>) {
      return (data as List)
              .map((e) => deserialize<_i21.AiGeneratedStep>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i21.AiGeneratedStep>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i21.AiGeneratedStep>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i22.PlaceSearchResult>) {
      return (data as List)
              .map((e) => deserialize<_i22.PlaceSearchResult>(e))
              .toList()
          as T;
    }
    if (t == List<_i23.Location>) {
      return (data as List).map((e) => deserialize<_i23.Location>(e)).toList()
          as T;
    }
    if (t == List<_i24.Reward>) {
      return (data as List).map((e) => deserialize<_i24.Reward>(e)).toList()
          as T;
    }
    if (t == List<_i25.UserReward>) {
      return (data as List).map((e) => deserialize<_i25.UserReward>(e)).toList()
          as T;
    }
    if (t == List<_i26.LeaderboardEntry>) {
      return (data as List)
              .map((e) => deserialize<_i26.LeaderboardEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i27.RewardPool>) {
      return (data as List).map((e) => deserialize<_i27.RewardPool>(e)).toList()
          as T;
    }
    if (t == List<_i28.RewardDistribution>) {
      return (data as List)
              .map((e) => deserialize<_i28.RewardDistribution>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.SolanaWallet>) {
      return (data as List)
              .map((e) => deserialize<_i29.SolanaWallet>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.ActionSubmission>) {
      return (data as List)
              .map((e) => deserialize<_i30.ActionSubmission>(e))
              .toList()
          as T;
    }
    if (t == List<_i31.UserFollow>) {
      return (data as List).map((e) => deserialize<_i31.UserFollow>(e)).toList()
          as T;
    }
    if (t == List<_i32.UserProfile>) {
      return (data as List)
              .map((e) => deserialize<_i32.UserProfile>(e))
              .toList()
          as T;
    }
    try {
      return _i33.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i34.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Action => 'Action',
      _i3.ActionCategory => 'ActionCategory',
      _i4.ActionStep => 'ActionStep',
      _i5.ActionSubmission => 'ActionSubmission',
      _i6.AttestationChallenge => 'AttestationChallenge',
      _i7.DeviceAttestation => 'DeviceAttestation',
      _i8.Location => 'Location',
      _i9.PlaceSearchResult => 'PlaceSearchResult',
      _i10.Reward => 'Reward',
      _i11.RewardDistribution => 'RewardDistribution',
      _i12.RewardPool => 'RewardPool',
      _i13.SolanaWallet => 'SolanaWallet',
      _i14.UserFollow => 'UserFollow',
      _i15.UserProfile => 'UserProfile',
      _i16.UserReward => 'UserReward',
      _i17.VerificationResult => 'VerificationResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('verily.', '');
    }

    switch (data) {
      case _i2.Action():
        return 'Action';
      case _i3.ActionCategory():
        return 'ActionCategory';
      case _i4.ActionStep():
        return 'ActionStep';
      case _i5.ActionSubmission():
        return 'ActionSubmission';
      case _i6.AttestationChallenge():
        return 'AttestationChallenge';
      case _i7.DeviceAttestation():
        return 'DeviceAttestation';
      case _i8.Location():
        return 'Location';
      case _i9.PlaceSearchResult():
        return 'PlaceSearchResult';
      case _i10.Reward():
        return 'Reward';
      case _i11.RewardDistribution():
        return 'RewardDistribution';
      case _i12.RewardPool():
        return 'RewardPool';
      case _i13.SolanaWallet():
        return 'SolanaWallet';
      case _i14.UserFollow():
        return 'UserFollow';
      case _i15.UserProfile():
        return 'UserProfile';
      case _i16.UserReward():
        return 'UserReward';
      case _i17.VerificationResult():
        return 'VerificationResult';
    }
    className = _i33.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i34.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Action') {
      return deserialize<_i2.Action>(data['data']);
    }
    if (dataClassName == 'ActionCategory') {
      return deserialize<_i3.ActionCategory>(data['data']);
    }
    if (dataClassName == 'ActionStep') {
      return deserialize<_i4.ActionStep>(data['data']);
    }
    if (dataClassName == 'ActionSubmission') {
      return deserialize<_i5.ActionSubmission>(data['data']);
    }
    if (dataClassName == 'AttestationChallenge') {
      return deserialize<_i6.AttestationChallenge>(data['data']);
    }
    if (dataClassName == 'DeviceAttestation') {
      return deserialize<_i7.DeviceAttestation>(data['data']);
    }
    if (dataClassName == 'Location') {
      return deserialize<_i8.Location>(data['data']);
    }
    if (dataClassName == 'PlaceSearchResult') {
      return deserialize<_i9.PlaceSearchResult>(data['data']);
    }
    if (dataClassName == 'Reward') {
      return deserialize<_i10.Reward>(data['data']);
    }
    if (dataClassName == 'RewardDistribution') {
      return deserialize<_i11.RewardDistribution>(data['data']);
    }
    if (dataClassName == 'RewardPool') {
      return deserialize<_i12.RewardPool>(data['data']);
    }
    if (dataClassName == 'SolanaWallet') {
      return deserialize<_i13.SolanaWallet>(data['data']);
    }
    if (dataClassName == 'UserFollow') {
      return deserialize<_i14.UserFollow>(data['data']);
    }
    if (dataClassName == 'UserProfile') {
      return deserialize<_i15.UserProfile>(data['data']);
    }
    if (dataClassName == 'UserReward') {
      return deserialize<_i16.UserReward>(data['data']);
    }
    if (dataClassName == 'VerificationResult') {
      return deserialize<_i17.VerificationResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i33.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i34.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i33.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i34.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
