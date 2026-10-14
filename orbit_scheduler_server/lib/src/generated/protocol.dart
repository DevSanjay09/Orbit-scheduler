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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i3;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i4;
import 'assistant_interaction.dart' as _i5;
import 'benchmark_run.dart' as _i6;
import 'checkpoint.dart' as _i7;
import 'constellation_state.dart' as _i8;
import 'decision_log_entry.dart' as _i9;
import 'fault_event.dart' as _i10;
import 'greetings/greeting.dart' as _i11;
import 'job.dart' as _i12;
import 'link_window.dart' as _i13;
import 'placement.dart' as _i14;
import 'policy.dart' as _i15;
import 'satellite.dart' as _i16;
import 'telemetry_forecast.dart' as _i17;
import 'package:orbit_scheduler_server/src/generated/benchmark_run.dart'
    as _i18;
import 'package:orbit_scheduler_server/src/generated/decision_log_entry.dart'
    as _i19;
import 'package:orbit_scheduler_server/src/generated/fault_event.dart' as _i20;
import 'package:orbit_scheduler_server/src/generated/job.dart' as _i21;
import 'package:orbit_scheduler_server/src/generated/checkpoint.dart' as _i22;
import 'package:orbit_scheduler_server/src/generated/policy.dart' as _i23;
export 'assistant_interaction.dart';
export 'benchmark_run.dart';
export 'checkpoint.dart';
export 'constellation_state.dart';
export 'decision_log_entry.dart';
export 'fault_event.dart';
export 'greetings/greeting.dart';
export 'job.dart';
export 'link_window.dart';
export 'placement.dart';
export 'policy.dart';
export 'satellite.dart';
export 'telemetry_forecast.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
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

    if (t == _i5.AssistantInteraction) {
      return _i5.AssistantInteraction.fromJson(data) as T;
    }
    if (t == _i6.BenchmarkRun) {
      return _i6.BenchmarkRun.fromJson(data) as T;
    }
    if (t == _i7.Checkpoint) {
      return _i7.Checkpoint.fromJson(data) as T;
    }
    if (t == _i8.ConstellationState) {
      return _i8.ConstellationState.fromJson(data) as T;
    }
    if (t == _i9.DecisionLogEntry) {
      return _i9.DecisionLogEntry.fromJson(data) as T;
    }
    if (t == _i10.FaultEvent) {
      return _i10.FaultEvent.fromJson(data) as T;
    }
    if (t == _i11.Greeting) {
      return _i11.Greeting.fromJson(data) as T;
    }
    if (t == _i12.Job) {
      return _i12.Job.fromJson(data) as T;
    }
    if (t == _i13.LinkWindow) {
      return _i13.LinkWindow.fromJson(data) as T;
    }
    if (t == _i14.Placement) {
      return _i14.Placement.fromJson(data) as T;
    }
    if (t == _i15.Policy) {
      return _i15.Policy.fromJson(data) as T;
    }
    if (t == _i16.Satellite) {
      return _i16.Satellite.fromJson(data) as T;
    }
    if (t == _i17.TelemetryForecast) {
      return _i17.TelemetryForecast.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.AssistantInteraction?>()) {
      return (data != null ? _i5.AssistantInteraction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.BenchmarkRun?>()) {
      return (data != null ? _i6.BenchmarkRun.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Checkpoint?>()) {
      return (data != null ? _i7.Checkpoint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ConstellationState?>()) {
      return (data != null ? _i8.ConstellationState.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.DecisionLogEntry?>()) {
      return (data != null ? _i9.DecisionLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.FaultEvent?>()) {
      return (data != null ? _i10.FaultEvent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Greeting?>()) {
      return (data != null ? _i11.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Job?>()) {
      return (data != null ? _i12.Job.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.LinkWindow?>()) {
      return (data != null ? _i13.LinkWindow.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.Placement?>()) {
      return (data != null ? _i14.Placement.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Policy?>()) {
      return (data != null ? _i15.Policy.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.Satellite?>()) {
      return (data != null ? _i16.Satellite.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.TelemetryForecast?>()) {
      return (data != null ? _i17.TelemetryForecast.fromJson(data) : null) as T;
    }
    if (t == List<_i16.Satellite>) {
      return (data as List).map((e) => deserialize<_i16.Satellite>(e)).toList()
          as T;
    }
    if (t == List<_i12.Job>) {
      return (data as List).map((e) => deserialize<_i12.Job>(e)).toList() as T;
    }
    if (t == List<_i13.LinkWindow>) {
      return (data as List).map((e) => deserialize<_i13.LinkWindow>(e)).toList()
          as T;
    }
    if (t == List<_i10.FaultEvent>) {
      return (data as List).map((e) => deserialize<_i10.FaultEvent>(e)).toList()
          as T;
    }
    if (t == List<_i9.DecisionLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i9.DecisionLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList() as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == List<bool>) {
      return (data as List).map((e) => deserialize<bool>(e)).toList() as T;
    }
    if (t == List<_i18.BenchmarkRun>) {
      return (data as List)
              .map((e) => deserialize<_i18.BenchmarkRun>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i19.DecisionLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i19.DecisionLogEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i20.FaultEvent>) {
      return (data as List).map((e) => deserialize<_i20.FaultEvent>(e)).toList()
          as T;
    }
    if (t == List<_i21.Job>) {
      return (data as List).map((e) => deserialize<_i21.Job>(e)).toList() as T;
    }
    if (t == List<_i22.Checkpoint>) {
      return (data as List).map((e) => deserialize<_i22.Checkpoint>(e)).toList()
          as T;
    }
    if (t == List<_i23.Policy>) {
      return (data as List).map((e) => deserialize<_i23.Policy>(e)).toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.AssistantInteraction => 'AssistantInteraction',
      _i6.BenchmarkRun => 'BenchmarkRun',
      _i7.Checkpoint => 'Checkpoint',
      _i8.ConstellationState => 'ConstellationState',
      _i9.DecisionLogEntry => 'DecisionLogEntry',
      _i10.FaultEvent => 'FaultEvent',
      _i11.Greeting => 'Greeting',
      _i12.Job => 'Job',
      _i13.LinkWindow => 'LinkWindow',
      _i14.Placement => 'Placement',
      _i15.Policy => 'Policy',
      _i16.Satellite => 'Satellite',
      _i17.TelemetryForecast => 'TelemetryForecast',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'orbit_scheduler.',
        '',
      );
    }

    switch (data) {
      case _i5.AssistantInteraction():
        return 'AssistantInteraction';
      case _i6.BenchmarkRun():
        return 'BenchmarkRun';
      case _i7.Checkpoint():
        return 'Checkpoint';
      case _i8.ConstellationState():
        return 'ConstellationState';
      case _i9.DecisionLogEntry():
        return 'DecisionLogEntry';
      case _i10.FaultEvent():
        return 'FaultEvent';
      case _i11.Greeting():
        return 'Greeting';
      case _i12.Job():
        return 'Job';
      case _i13.LinkWindow():
        return 'LinkWindow';
      case _i14.Placement():
        return 'Placement';
      case _i15.Policy():
        return 'Policy';
      case _i16.Satellite():
        return 'Satellite';
      case _i17.TelemetryForecast():
        return 'TelemetryForecast';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_idp.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'AssistantInteraction') {
      return deserialize<_i5.AssistantInteraction>(data['data']);
    }
    if (dataClassName == 'BenchmarkRun') {
      return deserialize<_i6.BenchmarkRun>(data['data']);
    }
    if (dataClassName == 'Checkpoint') {
      return deserialize<_i7.Checkpoint>(data['data']);
    }
    if (dataClassName == 'ConstellationState') {
      return deserialize<_i8.ConstellationState>(data['data']);
    }
    if (dataClassName == 'DecisionLogEntry') {
      return deserialize<_i9.DecisionLogEntry>(data['data']);
    }
    if (dataClassName == 'FaultEvent') {
      return deserialize<_i10.FaultEvent>(data['data']);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i11.Greeting>(data['data']);
    }
    if (dataClassName == 'Job') {
      return deserialize<_i12.Job>(data['data']);
    }
    if (dataClassName == 'LinkWindow') {
      return deserialize<_i13.LinkWindow>(data['data']);
    }
    if (dataClassName == 'Placement') {
      return deserialize<_i14.Placement>(data['data']);
    }
    if (dataClassName == 'Policy') {
      return deserialize<_i15.Policy>(data['data']);
    }
    if (dataClassName == 'Satellite') {
      return deserialize<_i16.Satellite>(data['data']);
    }
    if (dataClassName == 'TelemetryForecast') {
      return deserialize<_i17.TelemetryForecast>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i4.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'orbit_scheduler';

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
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
