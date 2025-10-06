import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirror_world_runner/auth/login_screen.dart';
import 'package:mirror_world_runner/screens/main_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  static const String userIdKey = "USERID";

  String? userUID;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final uid = preferences.getString(userIdKey);

      log("[EntryPoint] User UID => $uid");

      if (!mounted) return;
      setState(() {
        userUID = uid;
        isLoading = false;
      });
    } catch (e, s) {
      log("[EntryPoint] Failed to load SharedPreferences: $e", stackTrace: s);
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mirror World Runner',
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.pressStart2pTextTheme(
          ThemeData.dark().textTheme,
        ),
      ),
      home:
          isLoading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : (userUID?.isEmpty ?? true)
              ? const LoginScreen()
              : const MainMenuScreen(),
    );
  }
}
