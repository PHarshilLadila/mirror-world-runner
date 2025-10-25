// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mirror_world_runner/auth/login_screen.dart';
import 'package:mirror_world_runner/screens/main_menu.dart';
import 'package:mirror_world_runner/widgets/custom_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  static const String userIdKey = "USERID";
  static const String isAnonymousUserKey = "IS_ANONYMOUS_USER";

  String? userUID;
  bool? isAnonymousUser;
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
      final isAnonymous = preferences.getBool(isAnonymousUserKey);

      log("[EntryPoint] User UID => $uid");
      log("[EntryPoint] Is Anonymous User => $isAnonymous");

      if (!mounted) return;
      setState(() {
        userUID = uid;
        isAnonymousUser = isAnonymous;
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
              ? Scaffold(
                body: Center(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: GameLoadingWidget(width: 100, height: 100),
                    ),
                  ),
                ),
              )
              : (userUID?.isNotEmpty ?? false)
              ? MainMenuScreen()
              : const LoginScreen(),
    );
  }
}
