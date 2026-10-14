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
import 'policy.dart' as _i2;
import 'package:orbit_scheduler_client/src/protocol/protocol.dart' as _i3;

abstract class AssistantInteraction implements _i1.SerializableModel {
  AssistantInteraction._({
    required this.userPrompt,
    required this.parsedConstraintType,
    required this.parsedParamValue,
    required this.naturalLanguageExplanation,
    this.generatedPolicy,
    required this.requiresConfirmation,
  });

  factory AssistantInteraction({
    required String userPrompt,
    required String parsedConstraintType,
    required double parsedParamValue,
    required String naturalLanguageExplanation,
    _i2.Policy? generatedPolicy,
    required bool requiresConfirmation,
  }) = _AssistantInteractionImpl;

  factory AssistantInteraction.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AssistantInteraction(
      userPrompt: jsonSerialization['userPrompt'] as String,
      parsedConstraintType: jsonSerialization['parsedConstraintType'] as String,
      parsedParamValue: (jsonSerialization['parsedParamValue'] as num)
          .toDouble(),
      naturalLanguageExplanation:
          jsonSerialization['naturalLanguageExplanation'] as String,
      generatedPolicy: jsonSerialization['generatedPolicy'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Policy>(
              jsonSerialization['generatedPolicy'],
            ),
      requiresConfirmation: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['requiresConfirmation'],
      ),
    );
  }

  String userPrompt;

  String parsedConstraintType;

  double parsedParamValue;

  String naturalLanguageExplanation;

  _i2.Policy? generatedPolicy;

  bool requiresConfirmation;

  /// Returns a shallow copy of this [AssistantInteraction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AssistantInteraction copyWith({
    String? userPrompt,
    String? parsedConstraintType,
    double? parsedParamValue,
    String? naturalLanguageExplanation,
    _i2.Policy? generatedPolicy,
    bool? requiresConfirmation,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AssistantInteraction',
      'userPrompt': userPrompt,
      'parsedConstraintType': parsedConstraintType,
      'parsedParamValue': parsedParamValue,
      'naturalLanguageExplanation': naturalLanguageExplanation,
      if (generatedPolicy != null) 'generatedPolicy': generatedPolicy?.toJson(),
      'requiresConfirmation': requiresConfirmation,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AssistantInteractionImpl extends AssistantInteraction {
  _AssistantInteractionImpl({
    required String userPrompt,
    required String parsedConstraintType,
    required double parsedParamValue,
    required String naturalLanguageExplanation,
    _i2.Policy? generatedPolicy,
    required bool requiresConfirmation,
  }) : super._(
         userPrompt: userPrompt,
         parsedConstraintType: parsedConstraintType,
         parsedParamValue: parsedParamValue,
         naturalLanguageExplanation: naturalLanguageExplanation,
         generatedPolicy: generatedPolicy,
         requiresConfirmation: requiresConfirmation,
       );

  /// Returns a shallow copy of this [AssistantInteraction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AssistantInteraction copyWith({
    String? userPrompt,
    String? parsedConstraintType,
    double? parsedParamValue,
    String? naturalLanguageExplanation,
    Object? generatedPolicy = _Undefined,
    bool? requiresConfirmation,
  }) {
    return AssistantInteraction(
      userPrompt: userPrompt ?? this.userPrompt,
      parsedConstraintType: parsedConstraintType ?? this.parsedConstraintType,
      parsedParamValue: parsedParamValue ?? this.parsedParamValue,
      naturalLanguageExplanation:
          naturalLanguageExplanation ?? this.naturalLanguageExplanation,
      generatedPolicy: generatedPolicy is _i2.Policy?
          ? generatedPolicy
          : this.generatedPolicy?.copyWith(),
      requiresConfirmation: requiresConfirmation ?? this.requiresConfirmation,
    );
  }
}
