import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String userIdForPreference = "USERID";

  Future<void> register(String email, String userName, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      final userDoc =
          await firestore
              .collection("users")
              .where("userName", isEqualTo: userName)
              .get();
      if (userDoc.docs.isNotEmpty) {
        throw "Username already exists";
      }

      final emailDoc =
          await firestore
              .collection("users")
              .where("email", isEqualTo: email)
              .get();
      if (emailDoc.docs.isNotEmpty) {
        throw "Email already exists";
      }

      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = auth.currentUser!;
      await firestore.collection("users").doc(user.uid).set({
        "userName": userName,
        "email": email,
      });

      preferences.setString(userIdForPreference, user.uid);
    } catch (e) {
      log("[AuthService] Register error: ${_extractMessage(e)}");
      rethrow;
    }
  }

  Future<void> login(String userInput, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    try {
      String email;

      if (userInput.contains("@")) {
        try {
          await auth.signInWithEmailAndPassword(
            email: userInput,
            password: password,
          );
          email = userInput;
          preferences.setString(userIdForPreference, auth.currentUser!.uid);
          return;
        } catch (e) {
          log("[AuthService] Email login failed: ${_extractMessage(e)}");
        }
      }

      final query =
          await firestore
              .collection("users")
              .where("userName", isEqualTo: userInput)
              .get();

      if (query.docs.isEmpty) {
        throw "Username or Email not found";
      }

      email = query.docs.first.data()["email"];

      await auth.signInWithEmailAndPassword(email: email, password: password);
      preferences.setString(userIdForPreference, auth.currentUser!.uid);
    } catch (e) {
      log("[AuthService] Login error: ${_extractMessage(e)}");
      rethrow;
    }
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await auth.signOut();
    await preferences.remove(userIdForPreference);
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final uid = preferences.getString(userIdForPreference);

      if (uid == null) return null;

      final doc = await firestore.collection("users").doc(uid).get();
      if (!doc.exists) return null;

      return doc.data();
    } catch (e) {
      log("[AuthService] getCurrentUserData error: ${_extractMessage(e)}");
      return null;
    }
  }

  String _extractMessage(Object e) {
    if (e is FirebaseAuthException) return e.message ?? "An error occurred";
    if (e is String) return e;
    return e.toString();
  }
}
