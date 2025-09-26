// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final String userIdForPreference = "USERID";

//   Future<void> register(String email, String userName, String password) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     try {
//       final userDoc =
//           await firestore
//               .collection("users")
//               .where("userName", isEqualTo: userName)
//               .get();
//       if (userDoc.docs.isNotEmpty) {
//         throw "Username already exists";
//       }

//       final emailDoc =
//           await firestore
//               .collection("users")
//               .where("email", isEqualTo: email)
//               .get();
//       if (emailDoc.docs.isNotEmpty) {
//         throw "Email already exists";
//       }

//       await auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       final user = auth.currentUser!;
//       await firestore.collection("users").doc(user.uid).set({
//         "userName": userName,
//         "email": email,
//       });

//       preferences.setString(userIdForPreference, user.uid);
//     } catch (e) {
//       log("[AuthService] Register error: ${_extractMessage(e)}");
//       rethrow;
//     }
//   }

//   Future<void> login(String userInput, String password) async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();

//     try {
//       String email;

//       if (userInput.contains("@")) {
//         try {
//           await auth.signInWithEmailAndPassword(
//             email: userInput,
//             password: password,
//           );
//           email = userInput;
//           preferences.setString(userIdForPreference, auth.currentUser!.uid);
//           return;
//         } catch (e) {
//           log("[AuthService] Email login failed: ${_extractMessage(e)}");
//         }
//       }

//       final query =
//           await firestore
//               .collection("users")
//               .where("userName", isEqualTo: userInput)
//               .get();

//       if (query.docs.isEmpty) {
//         throw "Username or Email not found";
//       }

//       email = query.docs.first.data()["email"];

//       await auth.signInWithEmailAndPassword(email: email, password: password);
//       preferences.setString(userIdForPreference, auth.currentUser!.uid);
//     } catch (e) {
//       log("[AuthService] Login error: ${_extractMessage(e)}");
//       rethrow;
//     }
//   }

//   Future<void> logout() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await auth.signOut();
//     await preferences.remove(userIdForPreference);
//   }

//   Future<Map<String, dynamic>?> getCurrentUserData() async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       final uid = preferences.getString(userIdForPreference);

//       if (uid == null) return null;

//       final doc = await firestore.collection("users").doc(uid).get();
//       if (!doc.exists) return null;

//       return doc.data();
//     } catch (e) {
//       log("[AuthService] getCurrentUserData error: ${_extractMessage(e)}");
//       return null;
//     }
//   }

//   String _extractMessage(Object e) {
//     if (e is FirebaseAuthException) return e.message ?? "An error occurred";
//     if (e is String) return e;
//     return e.toString();
//   }
// }

import 'dart:convert';
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
        "highestScore": 0,
        "totalGamesPlayed": 0,
        "totalPlayTime": 0,
        "createdAt": FieldValue.serverTimestamp(),
        "lastPlayed": FieldValue.serverTimestamp(),
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

  // Save game data to Firebase
  Future<void> saveGameData({
    required int score,
    required int timeTaken,
    required int livesLeft,
    required int difficultyLevel,
  }) async {
    try {
      final user = auth.currentUser;
      if (user == null) return;

      final userDoc = await firestore.collection("users").doc(user.uid).get();
      if (!userDoc.exists) return;

      final userData = userDoc.data()!;
      final currentHighestScore = userData["highestScore"] ?? 0;

      // Update user statistics
      await firestore.collection("users").doc(user.uid).update({
        "lastPlayed": FieldValue.serverTimestamp(),
        "totalGamesPlayed": FieldValue.increment(1),
        "totalPlayTime": FieldValue.increment(timeTaken),
        "highestScore":
            score > currentHighestScore ? score : currentHighestScore,
      });

      // Save individual game record
      await firestore.collection("gameSessions").add({
        "userId": user.uid,
        "userName": userData["userName"],
        "score": score,
        "timeTaken": timeTaken,
        "livesLeft": livesLeft,
        "difficultyLevel": difficultyLevel,
        "highestScore": currentHighestScore,
        "playedAt": FieldValue.serverTimestamp(),
        "date": DateTime.now().toIso8601String(),
      });

      log("Game data saved successfully for user: ${user.uid}");
    } catch (e) {
      log("[AuthService] saveGameData error: ${_extractMessage(e)}");
    }
  }

  // Get user's game history
  Future<List<Map<String, dynamic>>> getUserGameHistory() async {
    try {
      final user = auth.currentUser;
      if (user == null) return [];

      final querySnapshot =
          await firestore
              .collection("gameSessions")
              .where("userId", isEqualTo: user.uid)
              .orderBy("playedAt", descending: true)
              .limit(20)
              .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, ...data, 'playedAt': data['playedAt']?.toDate()};
      }).toList();
    } catch (e) {
      log("[AuthService] getUserGameHistory error: ${_extractMessage(e)}");
      return [];
    }
  }

  // Get leaderboard data
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    try {
      final querySnapshot =
          await firestore
              .collection("users")
              .orderBy("highestScore", descending: true)
              .limit(limit)
              .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'userId': doc.id,
          'userName': data['userName'],
          'highestScore': data['highestScore'] ?? 0,
          'totalGamesPlayed': data['totalGamesPlayed'] ?? 0,
        };
      }).toList();
    } catch (e) {
      log("[AuthService] getLeaderboard error: ${_extractMessage(e)}");
      return [];
    }
  }

  // Admin: Get all games data
  Future<List<Map<String, dynamic>>> getAllGamesData({int limit = 100}) async {
    try {
      final querySnapshot =
          await firestore
              .collection("gameSessions")
              .orderBy("playedAt", descending: true)
              .limit(limit)
              .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {'id': doc.id, ...data, 'playedAt': data['playedAt']?.toDate()};
      }).toList();
    } catch (e) {
      log("[AuthService] getAllGamesData error: ${_extractMessage(e)}");
      return [];
    }
  }

  String _extractMessage(Object e) {
    if (e is FirebaseAuthException) return e.message ?? "An error occurred";
    if (e is String) return e;
    return e.toString();
  }
}
