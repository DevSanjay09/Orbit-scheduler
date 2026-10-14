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

abstract class Policy implements _i1.SerializableModel {
  Policy._({
    required this.policyId,
    required this.name,
    required this.naturalLanguagePrompt,
    required this.constraintType,
    required this.parameterValue,
    required this.rawJsonRules,
    required this.isActive,
    required this.operatorConfirmed,
    required this.createdAt,
  });

  factory Policy({
    required String policyId,
    required String name,
    required String naturalLanguagePrompt,
    required String constraintType,
    required double parameterValue,
    required String rawJsonRules,
    required bool isActive,
    required bool operatorConfirmed,
    required DateTime createdAt,
  }) = _PolicyImpl;

  factory Policy.fromJson(Map<String, dynamic> jsonSerialization) {
    return Policy(
      policyId: jsonSerialization['policyId'] as String,
      name: jsonSerialization['name'] as String,
      naturalLanguagePrompt:
          jsonSerialization['naturalLanguagePrompt'] as String,
      constraintType: jsonSerialization['constraintType'] as String,
      parameterValue: (jsonSerialization['parameterValue'] as num).toDouble(),
      rawJsonRules: jsonSerialization['rawJsonRules'] as String,
      isActive: _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      operatorConfirmed: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['operatorConfirmed'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  String policyId;

  String name;

  String naturalLanguagePrompt;

  String constraintType;

  double parameterValue;

  String rawJsonRules;

  bool isActive;

  bool operatorConfirmed;

  DateTime createdAt;

  /// Returns a shallow copy of this [Policy]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Policy copyWith({
    String? policyId,
    String? name,
    String? naturalLanguagePrompt,
    String? constraintType,
    double? parameterValue,
    String? rawJsonRules,
    bool? isActive,
    bool? operatorConfirmed,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Policy',
      'policyId': policyId,
      'name': name,
      'naturalLanguagePrompt': naturalLanguagePrompt,
      'constraintType': constraintType,
      'parameterValue': parameterValue,
      'rawJsonRules': rawJsonRules,
      'isActive': isActive,
      'operatorConfirmed': operatorConfirmed,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PolicyImpl extends Policy {
  _PolicyImpl({
    required String policyId,
    required String name,
    required String naturalLanguagePrompt,
    required String constraintType,
    required double parameterValue,
    required String rawJsonRules,
    required bool isActive,
    required bool operatorConfirmed,
    required DateTime createdAt,
  }) : super._(
         policyId: policyId,
         name: name,
         naturalLanguagePrompt: naturalLanguagePrompt,
         constraintType: constraintType,
         parameterValue: parameterValue,
         rawJsonRules: rawJsonRules,
         isActive: isActive,
         operatorConfirmed: operatorConfirmed,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Policy]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Policy copyWith({
    String? policyId,
    String? name,
    String? naturalLanguagePrompt,
    String? constraintType,
    double? parameterValue,
    String? rawJsonRules,
    bool? isActive,
    bool? operatorConfirmed,
    DateTime? createdAt,
  }) {
    return Policy(
      policyId: policyId ?? this.policyId,
      name: name ?? this.name,
      naturalLanguagePrompt:
          naturalLanguagePrompt ?? this.naturalLanguagePrompt,
      constraintType: constraintType ?? this.constraintType,
      parameterValue: parameterValue ?? this.parameterValue,
      rawJsonRules: rawJsonRules ?? this.rawJsonRules,
      isActive: isActive ?? this.isActive,
      operatorConfirmed: operatorConfirmed ?? this.operatorConfirmed,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
