// import 'package:clarity_flutter/clarity_flutter.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flame_audio/flame_audio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:mirror_world_runner/entry_point.dart';
// import 'package:mirror_world_runner/providers/achievements_provider.dart';
// import 'package:mirror_world_runner/providers/auth_provider.dart';
// import 'package:mirror_world_runner/providers/game_state.dart';
// import 'package:motion/motion.dart';
// import 'package:provider/provider.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   if (!kIsWeb) {
//     await MobileAds.instance.initialize();
//   }
//   final config = ClarityConfig(
//     projectId: "todn8zvdkq",
//     logLevel: LogLevel.Error,
//   );
//   await Motion.instance.initialize();
//   Motion.instance.setUpdateInterval(60.fps);

//   await FlameAudio.audioCache.loadAll(['bomb.mp3', 'game_background.mp3']);
//   if (!FlameAudio.bgm.isPlaying) {
//     FlameAudio.bgm.play('game_background.mp3', volume: 0.5);
//   }

//   if (kIsWeb) {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: "AIzaSyA7hz4MIrO9ynTtC-IRUijuqKXQ6kuDk0Y",
//         authDomain: "mirror-world-runner.firebaseapp.com",
//         projectId: "mirror-world-runner",
//         storageBucket: "mirror-world-runner.firebasestorage.app",
//         messagingSenderId: "307164978142",
//         appId: "1:307164978142:web:3f31f5c65fa7d8c8809b4f",
//         measurementId: "G-5PT2NCVZH2",
//       ),
//     );
//   } else {
//     await Firebase.initializeApp();
//   }

//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);

//   final authProvider = AuthProvider();
//   await authProvider.fetchCurrentUser();

//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => GameState()),
//         ChangeNotifierProvider.value(value: authProvider),
//         ChangeNotifierProvider(create: (_) => AchievementsProvider()),
//       ],
//       child: ClarityWidget(app: const EntryPoint(), clarityConfig: config),
//     ),
//   );
// }

import 'package:clarity_flutter/clarity_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mirror_world_runner/entry_point.dart';
import 'package:mirror_world_runner/providers/achievements_provider.dart';
import 'package:mirror_world_runner/providers/auth_provider.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:motion/motion.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Clarity with better error handling
  // await _initializeClarity();

  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }

  await Motion.instance.initialize();
  Motion.instance.setUpdateInterval(60.fps);

  await FlameAudio.audioCache.loadAll(['bomb.mp3', 'game_background.mp3']);
  if (!FlameAudio.bgm.isPlaying) {
    FlameAudio.bgm.play('game_background.mp3', volume: 0.5);
  }

  // Firebase initialization
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
      child: const EntryPoint(),
    ),
  );
}

// Initialize Clarity with proper error handling
// Future<void> _initializeClarity() async {
//   try {
//     final config = ClarityConfig(
//       projectId: "todn8zvdkq",
//       logLevel: kReleaseMode ? LogLevel.Error : LogLevel.Verbose,
//       // Add additional configuration for better stability
//       enableInBackground: false, // Disable when app is in background
//       cacheSize: 100, // Limit cache size
//     );
    
//     // Only initialize Clarity in release mode or when explicitly needed
//     if (kReleaseMode) {
//       await Clarity.initialize(config);
//     } else {
//       // In debug mode, you might want to skip Clarity initialization
//       // or use a mock implementation
//       debugPrint("Clarity initialization skipped in debug mode");
//     }
//   } catch (e, stackTrace) {
//     // Handle Clarity initialization errors gracefully
//     debugPrint("Clarity initialization failed: $e");
//     debugPrint("Stack trace: $stackTrace");
    
//     // You can choose to:
//     // 1. Continue without analytics (recommended for development)
//     // 2. Use a fallback analytics service
//     // 3. Retry initialization
    
//     if (kReleaseMode) {
//       // In production, you might want to retry or use fallback
//       debugPrint("Clarity failed in production - consider fallback");
//     }
//   }
// }