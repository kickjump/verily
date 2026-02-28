// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_generated_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiGeneratedAction _$AiGeneratedActionFromJson(Map<String, dynamic> json) =>
    _AiGeneratedAction(
      title: json['title'] as String,
      description: json['description'] as String,
      actionType: json['actionType'] as String,
      verificationCriteria: json['verificationCriteria'] as String,
      suggestedCategory: json['suggestedCategory'] as String,
      suggestedSteps: (json['suggestedSteps'] as num?)?.toInt(),
      suggestedIntervalDays: (json['suggestedIntervalDays'] as num?)?.toInt(),
      stepOrdering: json['stepOrdering'] as String?,
      habitDurationDays: (json['habitDurationDays'] as num?)?.toInt(),
      habitFrequencyPerWeek: (json['habitFrequencyPerWeek'] as num?)?.toInt(),
      habitTotalRequired: (json['habitTotalRequired'] as num?)?.toInt(),
      suggestedTags:
          (json['suggestedTags'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      suggestedLocation: json['suggestedLocation'] == null
          ? null
          : AiGeneratedLocation.fromJson(
              json['suggestedLocation'] as Map<String, dynamic>,
            ),
      suggestedMaxPerformers: (json['suggestedMaxPerformers'] as num?)?.toInt(),
      steps:
          (json['steps'] as List<dynamic>?)
              ?.map((e) => AiGeneratedStep.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AiGeneratedActionToJson(_AiGeneratedAction instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'actionType': instance.actionType,
      'verificationCriteria': instance.verificationCriteria,
      'suggestedCategory': instance.suggestedCategory,
      'suggestedSteps': instance.suggestedSteps,
      'suggestedIntervalDays': instance.suggestedIntervalDays,
      'stepOrdering': instance.stepOrdering,
      'habitDurationDays': instance.habitDurationDays,
      'habitFrequencyPerWeek': instance.habitFrequencyPerWeek,
      'habitTotalRequired': instance.habitTotalRequired,
      'suggestedTags': instance.suggestedTags,
      'suggestedLocation': instance.suggestedLocation,
      'suggestedMaxPerformers': instance.suggestedMaxPerformers,
      'steps': instance.steps,
    };

_AiGeneratedLocation _$AiGeneratedLocationFromJson(Map<String, dynamic> json) =>
    _AiGeneratedLocation(
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      suggestedRadiusMeters:
          (json['suggestedRadiusMeters'] as num?)?.toDouble() ?? 100.0,
    );

Map<String, dynamic> _$AiGeneratedLocationToJson(
  _AiGeneratedLocation instance,
) => <String, dynamic>{
  'name': instance.name,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'suggestedRadiusMeters': instance.suggestedRadiusMeters,
};

_AiGeneratedStep _$AiGeneratedStepFromJson(Map<String, dynamic> json) =>
    _AiGeneratedStep(
      stepNumber: (json['stepNumber'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      verificationCriteria: json['verificationCriteria'] as String,
    );

Map<String, dynamic> _$AiGeneratedStepToJson(_AiGeneratedStep instance) =>
    <String, dynamic>{
      'stepNumber': instance.stepNumber,
      'title': instance.title,
      'description': instance.description,
      'verificationCriteria': instance.verificationCriteria,
    };
