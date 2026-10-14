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

import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:orbit_scheduler_client/src/protocol/benchmark_run.dart' as _i5;
import 'package:orbit_scheduler_client/src/protocol/constellation_state.dart'
    as _i6;
import 'package:orbit_scheduler_client/src/protocol/telemetry_forecast.dart'
    as _i7;
import 'package:orbit_scheduler_client/src/protocol/decision_log_entry.dart'
    as _i8;
import 'package:orbit_scheduler_client/src/protocol/fault_event.dart' as _i9;
import 'package:orbit_scheduler_client/src/protocol/job.dart' as _i10;
import 'package:orbit_scheduler_client/src/protocol/checkpoint.dart' as _i11;
import 'package:orbit_scheduler_client/src/protocol/policy.dart' as _i12;
import 'package:orbit_scheduler_client/src/protocol/assistant_interaction.dart'
    as _i13;
import 'package:orbit_scheduler_client/src/protocol/greetings/greeting.dart'
    as _i14;
import 'protocol.dart' as _i15;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _i3.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointBenchmark extends _i2.EndpointRef {
  EndpointBenchmark(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'benchmark';

  /// Runs the comparative benchmark suite across seeded fault sequences.
  _i3.Future<List<_i5.BenchmarkRun>> runBenchmarks(List<int>? seeds) =>
      caller.callServerEndpoint<List<_i5.BenchmarkRun>>(
        'benchmark',
        'runBenchmarks',
        {'seeds': seeds},
      );
}

/// {@category Endpoint}
class EndpointConstellation extends _i2.EndpointRef {
  EndpointConstellation(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'constellation';

  /// Fetches the latest snapshot of the entire constellation.
  _i3.Future<_i6.ConstellationState> getState() =>
      caller.callServerEndpoint<_i6.ConstellationState>(
        'constellation',
        'getState',
        {},
      );

  /// Real-time Serverpod streaming endpoint delivering live constellation updates.
  _i3.Stream<_i6.ConstellationState> streamState() =>
      caller.callStreamingServerEndpoint<
        _i3.Stream<_i6.ConstellationState>,
        _i6.ConstellationState
      >(
        'constellation',
        'streamState',
        {},
        {},
      );

  /// Generates multi-hour lookahead forecast for a specific satellite.
  _i3.Future<_i7.TelemetryForecast> getSatelliteForecast(String satelliteId) =>
      caller.callServerEndpoint<_i7.TelemetryForecast>(
        'constellation',
        'getSatelliteForecast',
        {'satelliteId': satelliteId},
      );

  /// Adjusts simulation time warp multiplier.
  _i3.Future<double> setSimSpeed(double multiplier) =>
      caller.callServerEndpoint<double>(
        'constellation',
        'setSimSpeed',
        {'multiplier': multiplier},
      );
}

/// {@category Endpoint}
class EndpointDecisionLog extends _i2.EndpointRef {
  EndpointDecisionLog(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'decisionLog';

  /// Searches and filters the append-only cryptographic decision log.
  _i3.Future<List<_i8.DecisionLogEntry>> search({
    String? query,
    String? actionType,
    String? satelliteId,
    String? jobId,
  }) => caller.callServerEndpoint<List<_i8.DecisionLogEntry>>(
    'decisionLog',
    'search',
    {
      'query': query,
      'actionType': actionType,
      'satelliteId': satelliteId,
      'jobId': jobId,
    },
  );

  /// Cryptographically audits and verifies the SHA-256 hash chain from genesis to tail.
  _i3.Future<String> verifyHashChain() => caller.callServerEndpoint<String>(
    'decisionLog',
    'verifyHashChain',
    {},
  );

  /// Real-time stream of newly appended decision entries.
  _i3.Stream<_i8.DecisionLogEntry> streamDecisions() =>
      caller.callStreamingServerEndpoint<
        _i3.Stream<_i8.DecisionLogEntry>,
        _i8.DecisionLogEntry
      >(
        'decisionLog',
        'streamDecisions',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointFault extends _i2.EndpointRef {
  EndpointFault(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'fault';

  /// Manually triggers a fault event on demand.
  _i3.Future<_i9.FaultEvent> triggerFault({
    required String faultType,
    String? targetSatelliteId,
  }) => caller.callServerEndpoint<_i9.FaultEvent>(
    'fault',
    'triggerFault',
    {
      'faultType': faultType,
      'targetSatelliteId': targetSatelliteId,
    },
  );

  /// Lists recent fault injection history.
  _i3.Future<List<_i9.FaultEvent>> listRecentFaults() =>
      caller.callServerEndpoint<List<_i9.FaultEvent>>(
        'fault',
        'listRecentFaults',
        {},
      );

  /// Real-time stream of newly triggered fault events.
  _i3.Stream<_i9.FaultEvent> streamFaults() => caller
      .callStreamingServerEndpoint<_i3.Stream<_i9.FaultEvent>, _i9.FaultEvent>(
        'fault',
        'streamFaults',
        {},
        {},
      );
}

/// {@category Endpoint}
class EndpointJob extends _i2.EndpointRef {
  EndpointJob(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'job';

  /// Lists all submitted, active, and completed jobs.
  _i3.Future<List<_i10.Job>> listJobs() =>
      caller.callServerEndpoint<List<_i10.Job>>(
        'job',
        'listJobs',
        {},
      );

  /// Submits a new AI workload to the platform.
  _i3.Future<_i10.Job> submitJob({
    required String name,
    required String priority,
    required double totalRuntimeSeconds,
    required double requiredComputeTFlops,
    required double checkpointIntervalSeconds,
  }) => caller.callServerEndpoint<_i10.Job>(
    'job',
    'submitJob',
    {
      'name': name,
      'priority': priority,
      'totalRuntimeSeconds': totalRuntimeSeconds,
      'requiredComputeTFlops': requiredComputeTFlops,
      'checkpointIntervalSeconds': checkpointIntervalSeconds,
    },
  );

  /// Lists checkpoints for inspection.
  _i3.Future<List<_i11.Checkpoint>> listCheckpoints(String? jobId) =>
      caller.callServerEndpoint<List<_i11.Checkpoint>>(
        'job',
        'listCheckpoints',
        {'jobId': jobId},
      );
}

/// {@category Endpoint}
class EndpointPolicy extends _i2.EndpointRef {
  EndpointPolicy(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'policy';

  /// Lists all active and configured operator policies.
  _i3.Future<List<_i12.Policy>> listPolicies() =>
      caller.callServerEndpoint<List<_i12.Policy>>(
        'policy',
        'listPolicies',
        {},
      );

  /// Sends a natural language policy query to the Gemini Assistant.
  _i3.Future<_i13.AssistantInteraction> askAssistant({
    required String prompt,
    String? apiKey,
  }) => caller.callServerEndpoint<_i13.AssistantInteraction>(
    'policy',
    'askAssistant',
    {
      'prompt': prompt,
      'apiKey': apiKey,
    },
  );

  /// Operator explicitly confirms and activates a parsed policy.
  _i3.Future<_i12.Policy> confirmPolicy(_i12.Policy policy) =>
      caller.callServerEndpoint<_i12.Policy>(
        'policy',
        'confirmPolicy',
        {'policy': policy},
      );

  /// Toggles an existing policy active/inactive.
  _i3.Future<bool> togglePolicy(
    String policyId,
    bool isActive,
  ) => caller.callServerEndpoint<bool>(
    'policy',
    'togglePolicy',
    {
      'policyId': policyId,
      'isActive': isActive,
    },
  );

  /// Explains a decision log entry in plain language.
  _i3.Future<String> explainDecision(String entryId) =>
      caller.callServerEndpoint<String>(
        'policy',
        'explainDecision',
        {'entryId': entryId},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i14.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i14.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i15.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    benchmark = EndpointBenchmark(this);
    constellation = EndpointConstellation(this);
    decisionLog = EndpointDecisionLog(this);
    fault = EndpointFault(this);
    job = EndpointJob(this);
    policy = EndpointPolicy(this);
    greeting = EndpointGreeting(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointBenchmark benchmark;

  late final EndpointConstellation constellation;

  late final EndpointDecisionLog decisionLog;

  late final EndpointFault fault;

  late final EndpointJob job;

  late final EndpointPolicy policy;

  late final EndpointGreeting greeting;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'benchmark': benchmark,
    'constellation': constellation,
    'decisionLog': decisionLog,
    'fault': fault,
    'job': job,
    'policy': policy,
    'greeting': greeting,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
