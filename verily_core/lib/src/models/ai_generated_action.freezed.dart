// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_generated_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiGeneratedAction {

 String get title; String get description;/// One of: "oneOff", "sequential", "habit"
 String get actionType; String get verificationCriteria; String get suggestedCategory; int? get suggestedSteps; int? get suggestedIntervalDays;/// "ordered" or "unordered" for sequential actions.
 String? get stepOrdering;/// For habit actions: total days the habit runs.
 int? get habitDurationDays;/// For habit actions: completions required per week.
 int? get habitFrequencyPerWeek;/// For habit actions: total completions required.
 int? get habitTotalRequired; List<String> get suggestedTags; AiGeneratedLocation? get suggestedLocation;/// Suggested max performers (null = unlimited).
 int? get suggestedMaxPerformers;/// Generated steps for sequential/multi-step actions.
 List<AiGeneratedStep> get steps;
/// Create a copy of AiGeneratedAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiGeneratedActionCopyWith<AiGeneratedAction> get copyWith => _$AiGeneratedActionCopyWithImpl<AiGeneratedAction>(this as AiGeneratedAction, _$identity);

  /// Serializes this AiGeneratedAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiGeneratedAction&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.verificationCriteria, verificationCriteria) || other.verificationCriteria == verificationCriteria)&&(identical(other.suggestedCategory, suggestedCategory) || other.suggestedCategory == suggestedCategory)&&(identical(other.suggestedSteps, suggestedSteps) || other.suggestedSteps == suggestedSteps)&&(identical(other.suggestedIntervalDays, suggestedIntervalDays) || other.suggestedIntervalDays == suggestedIntervalDays)&&(identical(other.stepOrdering, stepOrdering) || other.stepOrdering == stepOrdering)&&(identical(other.habitDurationDays, habitDurationDays) || other.habitDurationDays == habitDurationDays)&&(identical(other.habitFrequencyPerWeek, habitFrequencyPerWeek) || other.habitFrequencyPerWeek == habitFrequencyPerWeek)&&(identical(other.habitTotalRequired, habitTotalRequired) || other.habitTotalRequired == habitTotalRequired)&&const DeepCollectionEquality().equals(other.suggestedTags, suggestedTags)&&(identical(other.suggestedLocation, suggestedLocation) || other.suggestedLocation == suggestedLocation)&&(identical(other.suggestedMaxPerformers, suggestedMaxPerformers) || other.suggestedMaxPerformers == suggestedMaxPerformers)&&const DeepCollectionEquality().equals(other.steps, steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,actionType,verificationCriteria,suggestedCategory,suggestedSteps,suggestedIntervalDays,stepOrdering,habitDurationDays,habitFrequencyPerWeek,habitTotalRequired,const DeepCollectionEquality().hash(suggestedTags),suggestedLocation,suggestedMaxPerformers,const DeepCollectionEquality().hash(steps));

@override
String toString() {
  return 'AiGeneratedAction(title: $title, description: $description, actionType: $actionType, verificationCriteria: $verificationCriteria, suggestedCategory: $suggestedCategory, suggestedSteps: $suggestedSteps, suggestedIntervalDays: $suggestedIntervalDays, stepOrdering: $stepOrdering, habitDurationDays: $habitDurationDays, habitFrequencyPerWeek: $habitFrequencyPerWeek, habitTotalRequired: $habitTotalRequired, suggestedTags: $suggestedTags, suggestedLocation: $suggestedLocation, suggestedMaxPerformers: $suggestedMaxPerformers, steps: $steps)';
}


}

/// @nodoc
abstract mixin class $AiGeneratedActionCopyWith<$Res>  {
  factory $AiGeneratedActionCopyWith(AiGeneratedAction value, $Res Function(AiGeneratedAction) _then) = _$AiGeneratedActionCopyWithImpl;
@useResult
$Res call({
 String title, String description, String actionType, String verificationCriteria, String suggestedCategory, int? suggestedSteps, int? suggestedIntervalDays, String? stepOrdering, int? habitDurationDays, int? habitFrequencyPerWeek, int? habitTotalRequired, List<String> suggestedTags, AiGeneratedLocation? suggestedLocation, int? suggestedMaxPerformers, List<AiGeneratedStep> steps
});


$AiGeneratedLocationCopyWith<$Res>? get suggestedLocation;

}
/// @nodoc
class _$AiGeneratedActionCopyWithImpl<$Res>
    implements $AiGeneratedActionCopyWith<$Res> {
  _$AiGeneratedActionCopyWithImpl(this._self, this._then);

  final AiGeneratedAction _self;
  final $Res Function(AiGeneratedAction) _then;

/// Create a copy of AiGeneratedAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = null,Object? actionType = null,Object? verificationCriteria = null,Object? suggestedCategory = null,Object? suggestedSteps = freezed,Object? suggestedIntervalDays = freezed,Object? stepOrdering = freezed,Object? habitDurationDays = freezed,Object? habitFrequencyPerWeek = freezed,Object? habitTotalRequired = freezed,Object? suggestedTags = null,Object? suggestedLocation = freezed,Object? suggestedMaxPerformers = freezed,Object? steps = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String,verificationCriteria: null == verificationCriteria ? _self.verificationCriteria : verificationCriteria // ignore: cast_nullable_to_non_nullable
as String,suggestedCategory: null == suggestedCategory ? _self.suggestedCategory : suggestedCategory // ignore: cast_nullable_to_non_nullable
as String,suggestedSteps: freezed == suggestedSteps ? _self.suggestedSteps : suggestedSteps // ignore: cast_nullable_to_non_nullable
as int?,suggestedIntervalDays: freezed == suggestedIntervalDays ? _self.suggestedIntervalDays : suggestedIntervalDays // ignore: cast_nullable_to_non_nullable
as int?,stepOrdering: freezed == stepOrdering ? _self.stepOrdering : stepOrdering // ignore: cast_nullable_to_non_nullable
as String?,habitDurationDays: freezed == habitDurationDays ? _self.habitDurationDays : habitDurationDays // ignore: cast_nullable_to_non_nullable
as int?,habitFrequencyPerWeek: freezed == habitFrequencyPerWeek ? _self.habitFrequencyPerWeek : habitFrequencyPerWeek // ignore: cast_nullable_to_non_nullable
as int?,habitTotalRequired: freezed == habitTotalRequired ? _self.habitTotalRequired : habitTotalRequired // ignore: cast_nullable_to_non_nullable
as int?,suggestedTags: null == suggestedTags ? _self.suggestedTags : suggestedTags // ignore: cast_nullable_to_non_nullable
as List<String>,suggestedLocation: freezed == suggestedLocation ? _self.suggestedLocation : suggestedLocation // ignore: cast_nullable_to_non_nullable
as AiGeneratedLocation?,suggestedMaxPerformers: freezed == suggestedMaxPerformers ? _self.suggestedMaxPerformers : suggestedMaxPerformers // ignore: cast_nullable_to_non_nullable
as int?,steps: null == steps ? _self.steps : steps // ignore: cast_nullable_to_non_nullable
as List<AiGeneratedStep>,
  ));
}
/// Create a copy of AiGeneratedAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiGeneratedLocationCopyWith<$Res>? get suggestedLocation {
    if (_self.suggestedLocation == null) {
    return null;
  }

  return $AiGeneratedLocationCopyWith<$Res>(_self.suggestedLocation!, (value) {
    return _then(_self.copyWith(suggestedLocation: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiGeneratedAction].
extension AiGeneratedActionPatterns on AiGeneratedAction {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiGeneratedAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiGeneratedAction() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiGeneratedAction value)  $default,){
final _that = this;
switch (_that) {
case _AiGeneratedAction():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiGeneratedAction value)?  $default,){
final _that = this;
switch (_that) {
case _AiGeneratedAction() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String description,  String actionType,  String verificationCriteria,  String suggestedCategory,  int? suggestedSteps,  int? suggestedIntervalDays,  String? stepOrdering,  int? habitDurationDays,  int? habitFrequencyPerWeek,  int? habitTotalRequired,  List<String> suggestedTags,  AiGeneratedLocation? suggestedLocation,  int? suggestedMaxPerformers,  List<AiGeneratedStep> steps)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiGeneratedAction() when $default != null:
return $default(_that.title,_that.description,_that.actionType,_that.verificationCriteria,_that.suggestedCategory,_that.suggestedSteps,_that.suggestedIntervalDays,_that.stepOrdering,_that.habitDurationDays,_that.habitFrequencyPerWeek,_that.habitTotalRequired,_that.suggestedTags,_that.suggestedLocation,_that.suggestedMaxPerformers,_that.steps);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String description,  String actionType,  String verificationCriteria,  String suggestedCategory,  int? suggestedSteps,  int? suggestedIntervalDays,  String? stepOrdering,  int? habitDurationDays,  int? habitFrequencyPerWeek,  int? habitTotalRequired,  List<String> suggestedTags,  AiGeneratedLocation? suggestedLocation,  int? suggestedMaxPerformers,  List<AiGeneratedStep> steps)  $default,) {final _that = this;
switch (_that) {
case _AiGeneratedAction():
return $default(_that.title,_that.description,_that.actionType,_that.verificationCriteria,_that.suggestedCategory,_that.suggestedSteps,_that.suggestedIntervalDays,_that.stepOrdering,_that.habitDurationDays,_that.habitFrequencyPerWeek,_that.habitTotalRequired,_that.suggestedTags,_that.suggestedLocation,_that.suggestedMaxPerformers,_that.steps);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String description,  String actionType,  String verificationCriteria,  String suggestedCategory,  int? suggestedSteps,  int? suggestedIntervalDays,  String? stepOrdering,  int? habitDurationDays,  int? habitFrequencyPerWeek,  int? habitTotalRequired,  List<String> suggestedTags,  AiGeneratedLocation? suggestedLocation,  int? suggestedMaxPerformers,  List<AiGeneratedStep> steps)?  $default,) {final _that = this;
switch (_that) {
case _AiGeneratedAction() when $default != null:
return $default(_that.title,_that.description,_that.actionType,_that.verificationCriteria,_that.suggestedCategory,_that.suggestedSteps,_that.suggestedIntervalDays,_that.stepOrdering,_that.habitDurationDays,_that.habitFrequencyPerWeek,_that.habitTotalRequired,_that.suggestedTags,_that.suggestedLocation,_that.suggestedMaxPerformers,_that.steps);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiGeneratedAction implements AiGeneratedAction {
  const _AiGeneratedAction({required this.title, required this.description, required this.actionType, required this.verificationCriteria, required this.suggestedCategory, this.suggestedSteps, this.suggestedIntervalDays, this.stepOrdering, this.habitDurationDays, this.habitFrequencyPerWeek, this.habitTotalRequired, final  List<String> suggestedTags = const [], this.suggestedLocation, this.suggestedMaxPerformers, final  List<AiGeneratedStep> steps = const []}): _suggestedTags = suggestedTags,_steps = steps;
  factory _AiGeneratedAction.fromJson(Map<String, dynamic> json) => _$AiGeneratedActionFromJson(json);

@override final  String title;
@override final  String description;
/// One of: "oneOff", "sequential", "habit"
@override final  String actionType;
@override final  String verificationCriteria;
@override final  String suggestedCategory;
@override final  int? suggestedSteps;
@override final  int? suggestedIntervalDays;
/// "ordered" or "unordered" for sequential actions.
@override final  String? stepOrdering;
/// For habit actions: total days the habit runs.
@override final  int? habitDurationDays;
/// For habit actions: completions required per week.
@override final  int? habitFrequencyPerWeek;
/// For habit actions: total completions required.
@override final  int? habitTotalRequired;
 final  List<String> _suggestedTags;
@override@JsonKey() List<String> get suggestedTags {
  if (_suggestedTags is EqualUnmodifiableListView) return _suggestedTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggestedTags);
}

@override final  AiGeneratedLocation? suggestedLocation;
/// Suggested max performers (null = unlimited).
@override final  int? suggestedMaxPerformers;
/// Generated steps for sequential/multi-step actions.
 final  List<AiGeneratedStep> _steps;
/// Generated steps for sequential/multi-step actions.
@override@JsonKey() List<AiGeneratedStep> get steps {
  if (_steps is EqualUnmodifiableListView) return _steps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_steps);
}


/// Create a copy of AiGeneratedAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiGeneratedActionCopyWith<_AiGeneratedAction> get copyWith => __$AiGeneratedActionCopyWithImpl<_AiGeneratedAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiGeneratedActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiGeneratedAction&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.actionType, actionType) || other.actionType == actionType)&&(identical(other.verificationCriteria, verificationCriteria) || other.verificationCriteria == verificationCriteria)&&(identical(other.suggestedCategory, suggestedCategory) || other.suggestedCategory == suggestedCategory)&&(identical(other.suggestedSteps, suggestedSteps) || other.suggestedSteps == suggestedSteps)&&(identical(other.suggestedIntervalDays, suggestedIntervalDays) || other.suggestedIntervalDays == suggestedIntervalDays)&&(identical(other.stepOrdering, stepOrdering) || other.stepOrdering == stepOrdering)&&(identical(other.habitDurationDays, habitDurationDays) || other.habitDurationDays == habitDurationDays)&&(identical(other.habitFrequencyPerWeek, habitFrequencyPerWeek) || other.habitFrequencyPerWeek == habitFrequencyPerWeek)&&(identical(other.habitTotalRequired, habitTotalRequired) || other.habitTotalRequired == habitTotalRequired)&&const DeepCollectionEquality().equals(other._suggestedTags, _suggestedTags)&&(identical(other.suggestedLocation, suggestedLocation) || other.suggestedLocation == suggestedLocation)&&(identical(other.suggestedMaxPerformers, suggestedMaxPerformers) || other.suggestedMaxPerformers == suggestedMaxPerformers)&&const DeepCollectionEquality().equals(other._steps, _steps));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,actionType,verificationCriteria,suggestedCategory,suggestedSteps,suggestedIntervalDays,stepOrdering,habitDurationDays,habitFrequencyPerWeek,habitTotalRequired,const DeepCollectionEquality().hash(_suggestedTags),suggestedLocation,suggestedMaxPerformers,const DeepCollectionEquality().hash(_steps));

@override
String toString() {
  return 'AiGeneratedAction(title: $title, description: $description, actionType: $actionType, verificationCriteria: $verificationCriteria, suggestedCategory: $suggestedCategory, suggestedSteps: $suggestedSteps, suggestedIntervalDays: $suggestedIntervalDays, stepOrdering: $stepOrdering, habitDurationDays: $habitDurationDays, habitFrequencyPerWeek: $habitFrequencyPerWeek, habitTotalRequired: $habitTotalRequired, suggestedTags: $suggestedTags, suggestedLocation: $suggestedLocation, suggestedMaxPerformers: $suggestedMaxPerformers, steps: $steps)';
}


}

/// @nodoc
abstract mixin class _$AiGeneratedActionCopyWith<$Res> implements $AiGeneratedActionCopyWith<$Res> {
  factory _$AiGeneratedActionCopyWith(_AiGeneratedAction value, $Res Function(_AiGeneratedAction) _then) = __$AiGeneratedActionCopyWithImpl;
@override @useResult
$Res call({
 String title, String description, String actionType, String verificationCriteria, String suggestedCategory, int? suggestedSteps, int? suggestedIntervalDays, String? stepOrdering, int? habitDurationDays, int? habitFrequencyPerWeek, int? habitTotalRequired, List<String> suggestedTags, AiGeneratedLocation? suggestedLocation, int? suggestedMaxPerformers, List<AiGeneratedStep> steps
});


@override $AiGeneratedLocationCopyWith<$Res>? get suggestedLocation;

}
/// @nodoc
class __$AiGeneratedActionCopyWithImpl<$Res>
    implements _$AiGeneratedActionCopyWith<$Res> {
  __$AiGeneratedActionCopyWithImpl(this._self, this._then);

  final _AiGeneratedAction _self;
  final $Res Function(_AiGeneratedAction) _then;

/// Create a copy of AiGeneratedAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = null,Object? actionType = null,Object? verificationCriteria = null,Object? suggestedCategory = null,Object? suggestedSteps = freezed,Object? suggestedIntervalDays = freezed,Object? stepOrdering = freezed,Object? habitDurationDays = freezed,Object? habitFrequencyPerWeek = freezed,Object? habitTotalRequired = freezed,Object? suggestedTags = null,Object? suggestedLocation = freezed,Object? suggestedMaxPerformers = freezed,Object? steps = null,}) {
  return _then(_AiGeneratedAction(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,actionType: null == actionType ? _self.actionType : actionType // ignore: cast_nullable_to_non_nullable
as String,verificationCriteria: null == verificationCriteria ? _self.verificationCriteria : verificationCriteria // ignore: cast_nullable_to_non_nullable
as String,suggestedCategory: null == suggestedCategory ? _self.suggestedCategory : suggestedCategory // ignore: cast_nullable_to_non_nullable
as String,suggestedSteps: freezed == suggestedSteps ? _self.suggestedSteps : suggestedSteps // ignore: cast_nullable_to_non_nullable
as int?,suggestedIntervalDays: freezed == suggestedIntervalDays ? _self.suggestedIntervalDays : suggestedIntervalDays // ignore: cast_nullable_to_non_nullable
as int?,stepOrdering: freezed == stepOrdering ? _self.stepOrdering : stepOrdering // ignore: cast_nullable_to_non_nullable
as String?,habitDurationDays: freezed == habitDurationDays ? _self.habitDurationDays : habitDurationDays // ignore: cast_nullable_to_non_nullable
as int?,habitFrequencyPerWeek: freezed == habitFrequencyPerWeek ? _self.habitFrequencyPerWeek : habitFrequencyPerWeek // ignore: cast_nullable_to_non_nullable
as int?,habitTotalRequired: freezed == habitTotalRequired ? _self.habitTotalRequired : habitTotalRequired // ignore: cast_nullable_to_non_nullable
as int?,suggestedTags: null == suggestedTags ? _self._suggestedTags : suggestedTags // ignore: cast_nullable_to_non_nullable
as List<String>,suggestedLocation: freezed == suggestedLocation ? _self.suggestedLocation : suggestedLocation // ignore: cast_nullable_to_non_nullable
as AiGeneratedLocation?,suggestedMaxPerformers: freezed == suggestedMaxPerformers ? _self.suggestedMaxPerformers : suggestedMaxPerformers // ignore: cast_nullable_to_non_nullable
as int?,steps: null == steps ? _self._steps : steps // ignore: cast_nullable_to_non_nullable
as List<AiGeneratedStep>,
  ));
}

/// Create a copy of AiGeneratedAction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiGeneratedLocationCopyWith<$Res>? get suggestedLocation {
    if (_self.suggestedLocation == null) {
    return null;
  }

  return $AiGeneratedLocationCopyWith<$Res>(_self.suggestedLocation!, (value) {
    return _then(_self.copyWith(suggestedLocation: value));
  });
}
}


/// @nodoc
mixin _$AiGeneratedLocation {

 String get name; String get address; double get latitude; double get longitude; double get suggestedRadiusMeters;
/// Create a copy of AiGeneratedLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiGeneratedLocationCopyWith<AiGeneratedLocation> get copyWith => _$AiGeneratedLocationCopyWithImpl<AiGeneratedLocation>(this as AiGeneratedLocation, _$identity);

  /// Serializes this AiGeneratedLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiGeneratedLocation&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.suggestedRadiusMeters, suggestedRadiusMeters) || other.suggestedRadiusMeters == suggestedRadiusMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,latitude,longitude,suggestedRadiusMeters);

@override
String toString() {
  return 'AiGeneratedLocation(name: $name, address: $address, latitude: $latitude, longitude: $longitude, suggestedRadiusMeters: $suggestedRadiusMeters)';
}


}

/// @nodoc
abstract mixin class $AiGeneratedLocationCopyWith<$Res>  {
  factory $AiGeneratedLocationCopyWith(AiGeneratedLocation value, $Res Function(AiGeneratedLocation) _then) = _$AiGeneratedLocationCopyWithImpl;
@useResult
$Res call({
 String name, String address, double latitude, double longitude, double suggestedRadiusMeters
});




}
/// @nodoc
class _$AiGeneratedLocationCopyWithImpl<$Res>
    implements $AiGeneratedLocationCopyWith<$Res> {
  _$AiGeneratedLocationCopyWithImpl(this._self, this._then);

  final AiGeneratedLocation _self;
  final $Res Function(AiGeneratedLocation) _then;

/// Create a copy of AiGeneratedLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? address = null,Object? latitude = null,Object? longitude = null,Object? suggestedRadiusMeters = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,suggestedRadiusMeters: null == suggestedRadiusMeters ? _self.suggestedRadiusMeters : suggestedRadiusMeters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AiGeneratedLocation].
extension AiGeneratedLocationPatterns on AiGeneratedLocation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiGeneratedLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiGeneratedLocation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiGeneratedLocation value)  $default,){
final _that = this;
switch (_that) {
case _AiGeneratedLocation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiGeneratedLocation value)?  $default,){
final _that = this;
switch (_that) {
case _AiGeneratedLocation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String address,  double latitude,  double longitude,  double suggestedRadiusMeters)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiGeneratedLocation() when $default != null:
return $default(_that.name,_that.address,_that.latitude,_that.longitude,_that.suggestedRadiusMeters);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String address,  double latitude,  double longitude,  double suggestedRadiusMeters)  $default,) {final _that = this;
switch (_that) {
case _AiGeneratedLocation():
return $default(_that.name,_that.address,_that.latitude,_that.longitude,_that.suggestedRadiusMeters);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String address,  double latitude,  double longitude,  double suggestedRadiusMeters)?  $default,) {final _that = this;
switch (_that) {
case _AiGeneratedLocation() when $default != null:
return $default(_that.name,_that.address,_that.latitude,_that.longitude,_that.suggestedRadiusMeters);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiGeneratedLocation implements AiGeneratedLocation {
  const _AiGeneratedLocation({required this.name, required this.address, required this.latitude, required this.longitude, this.suggestedRadiusMeters = 100.0});
  factory _AiGeneratedLocation.fromJson(Map<String, dynamic> json) => _$AiGeneratedLocationFromJson(json);

@override final  String name;
@override final  String address;
@override final  double latitude;
@override final  double longitude;
@override@JsonKey() final  double suggestedRadiusMeters;

/// Create a copy of AiGeneratedLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiGeneratedLocationCopyWith<_AiGeneratedLocation> get copyWith => __$AiGeneratedLocationCopyWithImpl<_AiGeneratedLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiGeneratedLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiGeneratedLocation&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.suggestedRadiusMeters, suggestedRadiusMeters) || other.suggestedRadiusMeters == suggestedRadiusMeters));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,latitude,longitude,suggestedRadiusMeters);

@override
String toString() {
  return 'AiGeneratedLocation(name: $name, address: $address, latitude: $latitude, longitude: $longitude, suggestedRadiusMeters: $suggestedRadiusMeters)';
}


}

/// @nodoc
abstract mixin class _$AiGeneratedLocationCopyWith<$Res> implements $AiGeneratedLocationCopyWith<$Res> {
  factory _$AiGeneratedLocationCopyWith(_AiGeneratedLocation value, $Res Function(_AiGeneratedLocation) _then) = __$AiGeneratedLocationCopyWithImpl;
@override @useResult
$Res call({
 String name, String address, double latitude, double longitude, double suggestedRadiusMeters
});




}
/// @nodoc
class __$AiGeneratedLocationCopyWithImpl<$Res>
    implements _$AiGeneratedLocationCopyWith<$Res> {
  __$AiGeneratedLocationCopyWithImpl(this._self, this._then);

  final _AiGeneratedLocation _self;
  final $Res Function(_AiGeneratedLocation) _then;

/// Create a copy of AiGeneratedLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = null,Object? latitude = null,Object? longitude = null,Object? suggestedRadiusMeters = null,}) {
  return _then(_AiGeneratedLocation(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,latitude: null == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double,longitude: null == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double,suggestedRadiusMeters: null == suggestedRadiusMeters ? _self.suggestedRadiusMeters : suggestedRadiusMeters // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$AiGeneratedStep {

 int get stepNumber; String get title; String get description; String get verificationCriteria;
/// Create a copy of AiGeneratedStep
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiGeneratedStepCopyWith<AiGeneratedStep> get copyWith => _$AiGeneratedStepCopyWithImpl<AiGeneratedStep>(this as AiGeneratedStep, _$identity);

  /// Serializes this AiGeneratedStep to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiGeneratedStep&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.verificationCriteria, verificationCriteria) || other.verificationCriteria == verificationCriteria));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepNumber,title,description,verificationCriteria);

@override
String toString() {
  return 'AiGeneratedStep(stepNumber: $stepNumber, title: $title, description: $description, verificationCriteria: $verificationCriteria)';
}


}

/// @nodoc
abstract mixin class $AiGeneratedStepCopyWith<$Res>  {
  factory $AiGeneratedStepCopyWith(AiGeneratedStep value, $Res Function(AiGeneratedStep) _then) = _$AiGeneratedStepCopyWithImpl;
@useResult
$Res call({
 int stepNumber, String title, String description, String verificationCriteria
});




}
/// @nodoc
class _$AiGeneratedStepCopyWithImpl<$Res>
    implements $AiGeneratedStepCopyWith<$Res> {
  _$AiGeneratedStepCopyWithImpl(this._self, this._then);

  final AiGeneratedStep _self;
  final $Res Function(AiGeneratedStep) _then;

/// Create a copy of AiGeneratedStep
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stepNumber = null,Object? title = null,Object? description = null,Object? verificationCriteria = null,}) {
  return _then(_self.copyWith(
stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,verificationCriteria: null == verificationCriteria ? _self.verificationCriteria : verificationCriteria // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AiGeneratedStep].
extension AiGeneratedStepPatterns on AiGeneratedStep {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiGeneratedStep value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiGeneratedStep() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiGeneratedStep value)  $default,){
final _that = this;
switch (_that) {
case _AiGeneratedStep():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiGeneratedStep value)?  $default,){
final _that = this;
switch (_that) {
case _AiGeneratedStep() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int stepNumber,  String title,  String description,  String verificationCriteria)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiGeneratedStep() when $default != null:
return $default(_that.stepNumber,_that.title,_that.description,_that.verificationCriteria);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int stepNumber,  String title,  String description,  String verificationCriteria)  $default,) {final _that = this;
switch (_that) {
case _AiGeneratedStep():
return $default(_that.stepNumber,_that.title,_that.description,_that.verificationCriteria);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int stepNumber,  String title,  String description,  String verificationCriteria)?  $default,) {final _that = this;
switch (_that) {
case _AiGeneratedStep() when $default != null:
return $default(_that.stepNumber,_that.title,_that.description,_that.verificationCriteria);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiGeneratedStep implements AiGeneratedStep {
  const _AiGeneratedStep({required this.stepNumber, required this.title, required this.description, required this.verificationCriteria});
  factory _AiGeneratedStep.fromJson(Map<String, dynamic> json) => _$AiGeneratedStepFromJson(json);

@override final  int stepNumber;
@override final  String title;
@override final  String description;
@override final  String verificationCriteria;

/// Create a copy of AiGeneratedStep
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiGeneratedStepCopyWith<_AiGeneratedStep> get copyWith => __$AiGeneratedStepCopyWithImpl<_AiGeneratedStep>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiGeneratedStepToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiGeneratedStep&&(identical(other.stepNumber, stepNumber) || other.stepNumber == stepNumber)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.verificationCriteria, verificationCriteria) || other.verificationCriteria == verificationCriteria));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stepNumber,title,description,verificationCriteria);

@override
String toString() {
  return 'AiGeneratedStep(stepNumber: $stepNumber, title: $title, description: $description, verificationCriteria: $verificationCriteria)';
}


}

/// @nodoc
abstract mixin class _$AiGeneratedStepCopyWith<$Res> implements $AiGeneratedStepCopyWith<$Res> {
  factory _$AiGeneratedStepCopyWith(_AiGeneratedStep value, $Res Function(_AiGeneratedStep) _then) = __$AiGeneratedStepCopyWithImpl;
@override @useResult
$Res call({
 int stepNumber, String title, String description, String verificationCriteria
});




}
/// @nodoc
class __$AiGeneratedStepCopyWithImpl<$Res>
    implements _$AiGeneratedStepCopyWith<$Res> {
  __$AiGeneratedStepCopyWithImpl(this._self, this._then);

  final _AiGeneratedStep _self;
  final $Res Function(_AiGeneratedStep) _then;

/// Create a copy of AiGeneratedStep
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stepNumber = null,Object? title = null,Object? description = null,Object? verificationCriteria = null,}) {
  return _then(_AiGeneratedStep(
stepNumber: null == stepNumber ? _self.stepNumber : stepNumber // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,verificationCriteria: null == verificationCriteria ? _self.verificationCriteria : verificationCriteria // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
