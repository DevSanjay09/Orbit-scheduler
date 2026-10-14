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
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../endpoints/benchmark_endpoint.dart' as _i4;
import '../endpoints/constellation_endpoint.dart' as _i5;
import '../endpoints/decision_log_endpoint.dart' as _i6;
import '../endpoints/fault_endpoint.dart' as _i7;
import '../endpoints/job_endpoint.dart' as _i8;
import '../endpoints/policy_endpoint.dart' as _i9;
import '../greetings/greeting_endpoint.dart' as _i10;
import 'package:orbit_scheduler_server/src/generated/policy.dart' as _i11;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i12;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i13;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'benchmark': _i4.BenchmarkEndpoint()
        ..initialize(
          server,
          'benchmark',
          null,
        ),
      'constellation': _i5.ConstellationEndpoint()
        ..initialize(
          server,
          'constellation',
          null,
        ),
      'decisionLog': _i6.DecisionLogEndpoint()
        ..initialize(
          server,
          'decisionLog',
          null,
        ),
      'fault': _i7.FaultEndpoint()
        ..initialize(
          server,
          'fault',
          null,
        ),
      'job': _i8.JobEndpoint()
        ..initialize(
          server,
          'job',
          null,
        ),
      'policy': _i9.PolicyEndpoint()
        ..initialize(
          server,
          'policy',
          null,
        ),
      'greeting': _i10.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
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
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
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
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
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
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['benchmark'] = _i1.EndpointConnector(
      name: 'benchmark',
      endpoint: endpoints['benchmark']!,
      methodConnectors: {
        'runBenchmarks': _i1.MethodConnector(
          name: 'runBenchmarks',
          params: {
            'seeds': _i1.ParameterDescription(
              name: 'seeds',
              type: _i1.getType<List<int>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['benchmark'] as _i4.BenchmarkEndpoint)
                  .runBenchmarks(
                    session,
                    params['seeds'],
                  ),
        ),
      },
    );
    connectors['constellation'] = _i1.EndpointConnector(
      name: 'constellation',
      endpoint: endpoints['constellation']!,
      methodConnectors: {
        'getState': _i1.MethodConnector(
          name: 'getState',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['constellation'] as _i5.ConstellationEndpoint)
                      .getState(session),
        ),
        'getSatelliteForecast': _i1.MethodConnector(
          name: 'getSatelliteForecast',
          params: {
            'satelliteId': _i1.ParameterDescription(
              name: 'satelliteId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['constellation'] as _i5.ConstellationEndpoint)
                      .getSatelliteForecast(
                        session,
                        params['satelliteId'],
                      ),
        ),
        'setSimSpeed': _i1.MethodConnector(
          name: 'setSimSpeed',
          params: {
            'multiplier': _i1.ParameterDescription(
              name: 'multiplier',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['constellation'] as _i5.ConstellationEndpoint)
                      .setSimSpeed(
                        session,
                        params['multiplier'],
                      ),
        ),
        'streamState': _i1.MethodStreamConnector(
          name: 'streamState',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['constellation'] as _i5.ConstellationEndpoint)
                  .streamState(session),
        ),
      },
    );
    connectors['decisionLog'] = _i1.EndpointConnector(
      name: 'decisionLog',
      endpoint: endpoints['decisionLog']!,
      methodConnectors: {
        'search': _i1.MethodConnector(
          name: 'search',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'actionType': _i1.ParameterDescription(
              name: 'actionType',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'satelliteId': _i1.ParameterDescription(
              name: 'satelliteId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'jobId': _i1.ParameterDescription(
              name: 'jobId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['decisionLog'] as _i6.DecisionLogEndpoint).search(
                    session,
                    query: params['query'],
                    actionType: params['actionType'],
                    satelliteId: params['satelliteId'],
                    jobId: params['jobId'],
                  ),
        ),
        'verifyHashChain': _i1.MethodConnector(
          name: 'verifyHashChain',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['decisionLog'] as _i6.DecisionLogEndpoint)
                  .verifyHashChain(session),
        ),
        'streamDecisions': _i1.MethodStreamConnector(
          name: 'streamDecisions',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['decisionLog'] as _i6.DecisionLogEndpoint)
                  .streamDecisions(session),
        ),
      },
    );
    connectors['fault'] = _i1.EndpointConnector(
      name: 'fault',
      endpoint: endpoints['fault']!,
      methodConnectors: {
        'triggerFault': _i1.MethodConnector(
          name: 'triggerFault',
          params: {
            'faultType': _i1.ParameterDescription(
              name: 'faultType',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'targetSatelliteId': _i1.ParameterDescription(
              name: 'targetSatelliteId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['fault'] as _i7.FaultEndpoint).triggerFault(
                session,
                faultType: params['faultType'],
                targetSatelliteId: params['targetSatelliteId'],
              ),
        ),
        'listRecentFaults': _i1.MethodConnector(
          name: 'listRecentFaults',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['fault'] as _i7.FaultEndpoint)
                  .listRecentFaults(session),
        ),
        'streamFaults': _i1.MethodStreamConnector(
          name: 'streamFaults',
          params: {},
          streamParams: {},
          returnType: _i1.MethodStreamReturnType.streamType,
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
                Map<String, Stream> streamParams,
              ) => (endpoints['fault'] as _i7.FaultEndpoint).streamFaults(
                session,
              ),
        ),
      },
    );
    connectors['job'] = _i1.EndpointConnector(
      name: 'job',
      endpoint: endpoints['job']!,
      methodConnectors: {
        'listJobs': _i1.MethodConnector(
          name: 'listJobs',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['job'] as _i8.JobEndpoint).listJobs(session),
        ),
        'submitJob': _i1.MethodConnector(
          name: 'submitJob',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'priority': _i1.ParameterDescription(
              name: 'priority',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'totalRuntimeSeconds': _i1.ParameterDescription(
              name: 'totalRuntimeSeconds',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'requiredComputeTFlops': _i1.ParameterDescription(
              name: 'requiredComputeTFlops',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'checkpointIntervalSeconds': _i1.ParameterDescription(
              name: 'checkpointIntervalSeconds',
              type: _i1.getType<double>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['job'] as _i8.JobEndpoint).submitJob(
                session,
                name: params['name'],
                priority: params['priority'],
                totalRuntimeSeconds: params['totalRuntimeSeconds'],
                requiredComputeTFlops: params['requiredComputeTFlops'],
                checkpointIntervalSeconds: params['checkpointIntervalSeconds'],
              ),
        ),
        'listCheckpoints': _i1.MethodConnector(
          name: 'listCheckpoints',
          params: {
            'jobId': _i1.ParameterDescription(
              name: 'jobId',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['job'] as _i8.JobEndpoint).listCheckpoints(
                session,
                params['jobId'],
              ),
        ),
      },
    );
    connectors['policy'] = _i1.EndpointConnector(
      name: 'policy',
      endpoint: endpoints['policy']!,
      methodConnectors: {
        'listPolicies': _i1.MethodConnector(
          name: 'listPolicies',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['policy'] as _i9.PolicyEndpoint)
                  .listPolicies(session),
        ),
        'askAssistant': _i1.MethodConnector(
          name: 'askAssistant',
          params: {
            'prompt': _i1.ParameterDescription(
              name: 'prompt',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'apiKey': _i1.ParameterDescription(
              name: 'apiKey',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['policy'] as _i9.PolicyEndpoint).askAssistant(
                    session,
                    prompt: params['prompt'],
                    apiKey: params['apiKey'],
                  ),
        ),
        'confirmPolicy': _i1.MethodConnector(
          name: 'confirmPolicy',
          params: {
            'policy': _i1.ParameterDescription(
              name: 'policy',
              type: _i1.getType<_i11.Policy>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['policy'] as _i9.PolicyEndpoint).confirmPolicy(
                    session,
                    params['policy'],
                  ),
        ),
        'togglePolicy': _i1.MethodConnector(
          name: 'togglePolicy',
          params: {
            'policyId': _i1.ParameterDescription(
              name: 'policyId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['policy'] as _i9.PolicyEndpoint).togglePolicy(
                    session,
                    params['policyId'],
                    params['isActive'],
                  ),
        ),
        'explainDecision': _i1.MethodConnector(
          name: 'explainDecision',
          params: {
            'entryId': _i1.ParameterDescription(
              name: 'entryId',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['policy'] as _i9.PolicyEndpoint).explainDecision(
                    session,
                    params['entryId'],
                  ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i10.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i12.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i13.Endpoints()
      ..initializeEndpoints(server);
  }
}
