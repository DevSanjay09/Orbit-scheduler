import 'package:orbit_scheduler_client/orbit_scheduler_client.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'theme/orbit_theme.dart';
import 'screens/home_screen.dart';

/// Sets up a global client object that can be used to talk to the Serverpod server.
late final Client client;
late String serverUrl;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fetches server URL from assets/config.json (defaults to http://localhost:8088/)
  final url = await getServerUrl();
  serverUrl = url;

  client = Client(serverUrl)
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = FlutterAuthSessionManager();

  client.auth.initialize();

  runApp(const OrbitSchedulerApp());
}

class OrbitSchedulerApp extends StatelessWidget {
  const OrbitSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Orbit Scheduler • Orbital Compute Workload Orchestrator',
      debugShowCheckedModeBanner: false,
      theme: OrbitTheme.darkTheme,
      darkTheme: OrbitTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
    );
  }
}
