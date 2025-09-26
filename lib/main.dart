import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mirror_world_runner/auth/login_screen.dart';
import 'package:mirror_world_runner/providers/auth_provider.dart';
import 'package:mirror_world_runner/screens/main_menu.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirror_world_runner/providers/game_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final String? apiKey = dotenv.env['APIKEY'];
  final String? authDomain = dotenv.env['AUTHDOMAIN'];
  final String? projectId = dotenv.env['PROJECTID'];
  final String? storageBucket = dotenv.env['STORAGEBUCKET'];
  final String? messagingSenderId = dotenv.env['MESSAGINGSENDERID'];
  final String? appId = dotenv.env['APPID'];
  final String? measurementId = dotenv.env['MEASUREMENTID'];

  await Firebase.initializeApp(
    // add your firebase details
    options: FirebaseOptions(
      apiKey: apiKey ?? "",
      authDomain: authDomain ?? "",
      projectId: projectId ?? "",
      storageBucket: storageBucket ?? "",
      messagingSenderId: messagingSenderId ?? "",
      appId: appId ?? "",
      measurementId: measurementId ?? "",
    ),
  );

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameState()),
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..fetchCurrentUser(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String userIdForPreference = "USERID";

  String userUID = "";
  bool isLoading = true;

  Future<void> getUserIdFromPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    final result = preferences.getString(userIdForPreference);
    setState(() {
      userUID = result ?? "";
      isLoading = false;
    });

    log("[main.dart] User UID => $result");
    log("[main.dart] User UID - userUID => $result");
  }

  @override
  void initState() {
    super.initState();
    getUserIdFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mirror World Runner',
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.pressStart2pTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,

      home:
          isLoading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : userUID.isEmpty
              ? const LoginScreen()
              : const MainMenuScreen(),
    );
  }
}
