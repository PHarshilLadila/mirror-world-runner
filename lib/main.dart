import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirror_world_runner/entry_point.dart';
import 'package:mirror_world_runner/providers/achievements_provider.dart';
import 'package:mirror_world_runner/providers/auth_provider.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = ClarityConfig(
    projectId: "todn8zvdkq",
    logLevel: LogLevel.Error,
  );

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyA7hz4MIrO9ynTtC-IRUijuqKXQ6kuDk0Y",
        authDomain: "mirror-world-runner.firebaseapp.com",
        projectId: "mirror-world-runner",
        storageBucket: "mirror-world-runner.firebasestorage.app",
        messagingSenderId: "307164978142",
        appId: "1:307164978142:web:3f31f5c65fa7d8c8809b4f",
        measurementId: "G-5PT2NCVZH2",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final authProvider = AuthProvider();
  await authProvider.fetchCurrentUser();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => AchievementsProvider()),
      ],
      child: ClarityWidget(app: const EntryPoint(), clarityConfig: config),
    ),
  );
}
