// import 'dart:developer';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthService {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final String userIdForPreference = "USERID";
//   final String isAnonymousUserKey = "IS_ANONYMOUS_USER";

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
//         "highestScore": 0,
//         "totalGamesPlayed": 0,
//         "totalPlayTime": 0,
//         "maxSurvivalTime": 0,
//         "isAnonymous": false,
//         "createdAt": FieldValue.serverTimestamp(),
//         "lastPlayed": FieldValue.serverTimestamp(),
//         "achievementsProgress": {
//           "Power Collector": {"current": 0, "isUnlocked": false},
//           "Invincible": {"current": 0, "isUnlocked": false},
//           "Heart Collector": {"current": 0, "isUnlocked": false},
//           "Maximum Life": {"current": 0, "isUnlocked": false},
//           "Combo Master": {"current": 0, "isUnlocked": false},
//           "20 Games": {"current": 0, "isUnlocked": false},
//           "100 Games": {"current": 0, "isUnlocked": false},
//           "1000 Games": {"current": 0, "isUnlocked": false},
//           "25000 Games": {"current": 0, "isUnlocked": false},
//           "60000 Games": {"current": 0, "isUnlocked": false},
//         },
//       });

//       preferences.setString(userIdForPreference, user.uid);
//       preferences.setBool(isAnonymousUserKey, false);
//     } catch (e) {
//       log("[AuthService] Register error: ${extractMessage(e)}");
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
//           preferences.setBool(isAnonymousUserKey, false);
//           return;
//         } catch (e) {
//           log("[AuthService] Email login failed: ${extractMessage(e)}");
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
//       preferences.setBool(isAnonymousUserKey, false);
//     } catch (e) {
//       log("[AuthService] Login error: ${extractMessage(e)}");
//       rethrow;
//     }
//   }

//   Future<void> signInAnonymously() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     try {
//       final userCredential = await auth.signInAnonymously();
//       final user = userCredential.user!;

//       final userDoc = await firestore.collection("users").doc(user.uid).get();

//       if (!userDoc.exists) {
//         await firestore.collection("users").doc(user.uid).set({
//           "userName": "Guest_${user.uid.substring(0, 8)}",
//           "email": null,
//           "highestScore": 0,
//           "totalGamesPlayed": 0,
//           "totalPlayTime": 0,
//           "maxSurvivalTime": 0,
//           "isAnonymous": true,
//           "createdAt": FieldValue.serverTimestamp(),
//           "lastPlayed": FieldValue.serverTimestamp(),
//           "achievementsProgress": {
//             "Power Collector": {"current": 0, "isUnlocked": false},
//             "Invincible": {"current": 0, "isUnlocked": false},
//             "Heart Collector": {"current": 0, "isUnlocked": false},
//             "Maximum Life": {"current": 0, "isUnlocked": false},
//             "Combo Master": {"current": 0, "isUnlocked": false},
//             "20 Games": {"current": 0, "isUnlocked": false},
//             "100 Games": {"current": 0, "isUnlocked": false},
//             "1000 Games": {"current": 0, "isUnlocked": false},
//             "25000 Games": {"current": 0, "isUnlocked": false},
//             "60000 Games": {"current": 0, "isUnlocked": false},
//           },
//         });
//       }

//       preferences.setString(userIdForPreference, user.uid);
//       preferences.setBool(isAnonymousUserKey, true);

//       log("[AuthService] Anonymous sign-in successful: ${user.uid}");
//     } catch (e) {
//       log("[AuthService] Anonymous sign-in error: ${extractMessage(e)}");
//       rethrow;
//     }
//   }

//   Future<void> logout() async {
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     await auth.signOut();
//     await preferences.remove(userIdForPreference);
//     await preferences.remove(isAnonymousUserKey);
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
//       log("[AuthService] getCurrentUserData error: ${extractMessage(e)}");
//       return null;
//     }
//   }

//   Future<void> saveGameData({
//     required int score,
//     required int timeTaken,
//     required int livesLeft,
//     required int difficultyLevel,
//     int? starPowerUpsCollected,
//     int? heartPowerUpsCollected,
//     int? starActivations,
//     bool? reachedMaxLives,
//     int? consecutivePowerUps,
//   }) async {
//     try {
//       final user = auth.currentUser;
//       if (user == null) return;

//       final userDoc = await firestore.collection("users").doc(user.uid).get();
//       if (!userDoc.exists) return;

//       final userData = userDoc.data()!;
//       final currentHighestScore = userData["highestScore"] ?? 0;
//       final currentTotalGames = userData["totalGamesPlayed"] ?? 0;
//       final newTotalGames = currentTotalGames + 1;

//       Map<String, dynamic> updateData = {
//         "lastPlayed": FieldValue.serverTimestamp(),
//         "totalGamesPlayed": newTotalGames,
//         "totalPlayTime": FieldValue.increment(timeTaken),
//         "highestScore":
//             score > currentHighestScore ? score : currentHighestScore,
//       };

//       Map<String, dynamic> achievementUpdates = {};

//       if (starPowerUpsCollected != null || heartPowerUpsCollected != null) {
//         final totalPowerUps =
//             (starPowerUpsCollected ?? 0) + (heartPowerUpsCollected ?? 0);
//         final currentProgress =
//             userData['achievementsProgress']?['Power Collector']?['current'] ??
//             0;
//         final newTotal = currentProgress + totalPowerUps;

//         achievementUpdates['achievementsProgress.Power Collector.current'] =
//             newTotal;
//         achievementUpdates['achievementsProgress.Power Collector.isUnlocked'] =
//             newTotal >= 10;
//         achievementUpdates['achievementsProgress.Power Collector.updatedAt'] =
//             FieldValue.serverTimestamp();
//       }

//       if (starActivations != null && starActivations >= 3) {
//         achievementUpdates['achievementsProgress.Invincible.current'] =
//             starActivations;
//         achievementUpdates['achievementsProgress.Invincible.isUnlocked'] = true;
//         achievementUpdates['achievementsProgress.Invincible.updatedAt'] =
//             FieldValue.serverTimestamp();
//       }

//       if (heartPowerUpsCollected != null) {
//         final currentHearts =
//             userData['achievementsProgress']?['Heart Collector']?['current'] ??
//             0;
//         final newTotal = currentHearts + heartPowerUpsCollected;

//         achievementUpdates['achievementsProgress.Heart Collector.current'] =
//             newTotal;
//         achievementUpdates['achievementsProgress.Heart Collector.isUnlocked'] =
//             newTotal >= 5;
//         achievementUpdates['achievementsProgress.Heart Collector.updatedAt'] =
//             FieldValue.serverTimestamp();
//       }

//       if (reachedMaxLives == true) {
//         achievementUpdates['achievementsProgress.Maximum Life.current'] = 5;
//         achievementUpdates['achievementsProgress.Maximum Life.isUnlocked'] =
//             true;
//         achievementUpdates['achievementsProgress.Maximum Life.updatedAt'] =
//             FieldValue.serverTimestamp();
//       }

//       if (consecutivePowerUps != null && consecutivePowerUps >= 3) {
//         achievementUpdates['achievementsProgress.Combo Master.current'] =
//             consecutivePowerUps;
//         achievementUpdates['achievementsProgress.Combo Master.isUnlocked'] =
//             true;
//         achievementUpdates['achievementsProgress.Combo Master.updatedAt'] =
//             FieldValue.serverTimestamp();
//       }

//       achievementUpdates['achievementsProgress.20 Games.current'] =
//           newTotalGames;
//       achievementUpdates['achievementsProgress.20 Games.isUnlocked'] =
//           newTotalGames >= 20;
//       achievementUpdates['achievementsProgress.20 Games.updatedAt'] =
//           FieldValue.serverTimestamp();

//       achievementUpdates['achievementsProgress.100 Games.current'] =
//           newTotalGames;
//       achievementUpdates['achievementsProgress.100 Games.isUnlocked'] =
//           newTotalGames >= 100;
//       achievementUpdates['achievementsProgress.100 Games.updatedAt'] =
//           FieldValue.serverTimestamp();

//       achievementUpdates['achievementsProgress.1000 Games.current'] =
//           newTotalGames;
//       achievementUpdates['achievementsProgress.1000 Games.isUnlocked'] =
//           newTotalGames >= 1000;
//       achievementUpdates['achievementsProgress.1000 Games.updatedAt'] =
//           FieldValue.serverTimestamp();

//       achievementUpdates['achievementsProgress.25000 Games.current'] =
//           newTotalGames;
//       achievementUpdates['achievementsProgress.25000 Games.isUnlocked'] =
//           newTotalGames >= 25000;
//       achievementUpdates['achievementsProgress.25000 Games.updatedAt'] =
//           FieldValue.serverTimestamp();

//       achievementUpdates['achievementsProgress.60000 Games.current'] =
//           newTotalGames;
//       achievementUpdates['achievementsProgress.60000 Games.isUnlocked'] =
//           newTotalGames >= 60000;
//       achievementUpdates['achievementsProgress.60000 Games.updatedAt'] =
//           FieldValue.serverTimestamp();

//       updateData.addAll(achievementUpdates);
//       await firestore.collection("users").doc(user.uid).update(updateData);

//       await firestore.collection("gameSessions").add({
//         "userId": user.uid,
//         "userName": userData["userName"],
//         "score": score,
//         "timeTaken": timeTaken,
//         "livesLeft": livesLeft,
//         "difficultyLevel": difficultyLevel,
//         "starPowerUpsCollected": starPowerUpsCollected ?? 0,
//         "heartPowerUpsCollected": heartPowerUpsCollected ?? 0,
//         "starActivations": starActivations ?? 0,
//         "reachedMaxLives": reachedMaxLives ?? false,
//         "consecutivePowerUps": consecutivePowerUps ?? 0,
//         "playedAt": FieldValue.serverTimestamp(),
//         "date": DateTime.now().toIso8601String(),
//       });

//       log("Game data saved successfully for user: ${user.uid}");
//       log("Total games played: $newTotalGames");
//     } catch (e) {
//       log("[AuthService] saveGameData error: ${extractMessage(e)}");
//     }
//   }

//   Future<void> updateAddictedRunnerAchievements() async {
//     log(
//       "updateAddictedRunnerAchievements is no longer needed - achievements updated in saveGameData",
//     );
//   }

//   Future<List<Map<String, dynamic>>> getUserGameHistory(bool isLimited) async {
//     try {
//       final user = auth.currentUser;
//       if (user == null) return <Map<String, dynamic>>[];

//       Query query = firestore
//           .collection("gameSessions")
//           .where("userId", isEqualTo: user.uid)
//           .orderBy("playedAt", descending: true);

//       if (isLimited) {
//         query = query.limit(20);
//       }

//       final querySnapshot = await query.get();

//       return querySnapshot.docs.map((doc) {
//         final data = doc.data();
//         if (data == null) return <String, dynamic>{};

//         final Map<String, dynamic> mapData = Map<String, dynamic>.from(
//           data as Map<String, dynamic>,
//         );

//         return {
//           'id': doc.id,
//           ...mapData,
//           'playedAt':
//               mapData['playedAt'] != null
//                   ? (mapData['playedAt'] as Timestamp).toDate()
//                   : null,
//         };
//       }).toList();
//     } catch (e) {
//       log("[AuthService] getUserGameHistory error: ${extractMessage(e)}");
//       return <Map<String, dynamic>>[];
//     }
//   }

//   Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
//     try {
//       final querySnapshot =
//           await firestore
//               .collection("users")
//               .orderBy("highestScore", descending: true)
//               .limit(limit)
//               .get();

//       return querySnapshot.docs.map((doc) {
//         final data = doc.data();
//         return {
//           'userId': doc.id,
//           'userName': data['userName'],
//           'highestScore': data['highestScore'] ?? 0,
//           'totalGamesPlayed': data['totalGamesPlayed'] ?? 0,
//         };
//       }).toList();
//     } catch (e) {
//       log("[AuthService] getLeaderboard error: ${extractMessage(e)}");
//       return [];
//     }
//   }

//   Future<Map<String, dynamic>> getUserPersonalBests() async {
//     try {
//       final user = auth.currentUser;
//       if (user == null) return {};

//       final userDoc = await firestore.collection("users").doc(user.uid).get();
//       if (!userDoc.exists) return {};

//       final userData = userDoc.data()!;

//       final bestGameQuery =
//           await firestore
//               .collection("gameSessions")
//               .where("userId", isEqualTo: user.uid)
//               .orderBy("score", descending: true)
//               .limit(1)
//               .get();

//       Map<String, dynamic>? bestGame;
//       if (bestGameQuery.docs.isNotEmpty) {
//         final data = bestGameQuery.docs.first.data();
//         bestGame = {
//           'score': data['score'],
//           'timeTaken': data['timeTaken'],
//           'date': data['date'],
//         };
//       }

//       return {
//         'highestScore': userData['highestScore'] ?? 0,
//         'totalGamesPlayed': userData['totalGamesPlayed'] ?? 0,
//         'totalPlayTime': userData['totalPlayTime'] ?? 0,
//         'bestGame': bestGame,
//       };
//     } catch (e) {
//       log("[AuthService] getUserPersonalBests error: ${extractMessage(e)}");
//       return {};
//     }
//   }

//   Future<void> updateMaxSurvivalTime(int currentGameTime) async {
//     try {
//       final user = auth.currentUser;
//       if (user == null) return;

//       final userDoc = await firestore.collection('users').doc(user.uid).get();
//       final currentMax = userDoc.data()?['maxSurvivalTime'] ?? 0;

//       if (currentGameTime > currentMax) {
//         await firestore.collection('users').doc(user.uid).set({
//           'maxSurvivalTime': currentGameTime,
//           'lastUpdated': FieldValue.serverTimestamp(),
//         }, SetOptions(merge: true));

//         print('New max survival time recorded: $currentGameTime seconds');
//       }
//     } catch (e) {
//       print('Error updating max survival time: $e');
//       rethrow;
//     }
//   }

//   String extractMessage(Object e) {
//     if (e is FirebaseAuthException) return e.message ?? "An error occurred";
//     if (e is String) return e;
//     return e.toString();
//   }

//   Future<void> saveRewardPoints(int points) async {
//     try {
//       final user = auth.currentUser;
//       if (user == null) return;

//       await firestore.collection("users").doc(user.uid).set({
//         'rewardPoints': FieldValue.increment(points),
//         'totalRewardPointsEarned': FieldValue.increment(points),
//         'lastRewardEarned': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));

//       log("Reward points saved: $points points for user: ${user.uid}");
//     } catch (e) {
//       log("[AuthService] saveRewardPoints error: ${extractMessage(e)}");
//       rethrow;
//     }
//   }

//   Future<int> getRewardPoints() async {
//     try {
//       final user = auth.currentUser;
//       if (user == null) return 0;

//       final doc = await firestore.collection("users").doc(user.uid).get();
//       if (!doc.exists) return 0;

//       return (doc.data()?['rewardPoints'] ?? 0) as int;
//     } catch (e) {
//       log("[AuthService] getRewardPoints error: ${extractMessage(e)}");
//       return 0;
//     }
//   }

//   Future<Map<String, dynamic>> getRewardStats() async {
//     try {
//       final user = auth.currentUser;
//       if (user == null) return {};

//       final doc = await firestore.collection("users").doc(user.uid).get();
//       if (!doc.exists) return {};

//       final data = doc.data()!;
//       return {
//         'currentPoints': data['rewardPoints'] ?? 0,
//         'totalEarned': data['totalRewardPointsEarned'] ?? 0,
//         'lastReward':
//             data['lastRewardEarned'] != null
//                 ? (data['lastRewardEarned'] as Timestamp).toDate()
//                 : null,
//       };
//     } catch (e) {
//       log("[AuthService] getRewardStats error: ${extractMessage(e)}");
//       return {};
//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';
import 'dart:io' if (dart.library.io) 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String userIdForPreference = "USERID";
  final String isAnonymousUserKey = "IS_ANONYMOUS_USER";
  final String offlineUserDataKey = "OFFLINE_USER_DATA";
  final String pendingSyncKey = "PENDING_SYNC";
  final String offlineGameDataKey = "OFFLINE_GAME_DATA";
  final String lastSyncTimeKey = "LAST_SYNC_TIME";
  final String pendingAuthSyncKey = "PENDING_AUTH_SYNC";
  final String localUserCredentialsKey = "LOCAL_USER_CREDENTIALS";

  // Check internet connectivity
  Future<bool> get isOnline async {
    try {
      if (kIsWeb) {
        // Web does not support InternetAddress.lookup
        return await InternetConnection().hasInternetAccess;
      } else {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      }
    } catch (_) {
      return false;
    }
  }

  // Save user data locally for offline use
  // Future<void> _saveUserDataLocally(Map<String, dynamic> userData) async {
  //   try {
  //     SharedPreferences preferences = await SharedPreferences.getInstance();
  //     await preferences.setString(offlineUserDataKey, json.encode(userData));
  //     await preferences.setString(
  //       lastSyncTimeKey,
  //       DateTime.now().toIso8601String(),
  //     );
  //     log("[AuthService] User data saved locally");
  //   } catch (e) {
  //     log("[AuthService] Error saving user data locally: $e");
  //   }
  // }

  Future<void> _saveUserDataLocally(Map<String, dynamic> userData) async {
    try {
      // Convert Firestore Timestamp objects to ISO8601 strings
      final convertedData = userData.map((key, value) {
        if (value is Timestamp) {
          return MapEntry(key, value.toDate().toIso8601String());
        }
        return MapEntry(key, value);
      });

      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString(
        offlineUserDataKey,
        json.encode(convertedData),
      );
      await preferences.setString(
        lastSyncTimeKey,
        DateTime.now().toIso8601String(),
      );

      debugPrint("[AuthService] User data saved locally");
    } catch (e) {
      debugPrint("[AuthService] Error saving user data locally: $e");
    }
  }

  // Get locally saved user data
  Future<Map<String, dynamic>?> _getLocalUserData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final localData = preferences.getString(offlineUserDataKey);
      if (localData != null) {
        return Map<String, dynamic>.from(json.decode(localData));
      }
    } catch (e) {
      log("[AuthService] Error reading local user data: $e");
    }
    return null;
  }

  // Save pending sync data
  Future<void> _setPendingSync(bool value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(pendingSyncKey, value);
  }

  // Check if there's pending sync
  Future<bool> _hasPendingSync() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(pendingSyncKey) ?? false;
  }

  // Save game data locally for offline
  Future<void> _saveGameDataLocally(Map<String, dynamic> gameData) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      List<String> offlineGames = [];
      final existingData = preferences.getString(offlineGameDataKey);
      if (existingData != null) {
        offlineGames = List<String>.from(json.decode(existingData));
      }
      offlineGames.add(json.encode(gameData));
      await preferences.setString(
        offlineGameDataKey,
        json.encode(offlineGames),
      );
      await _setPendingSync(true);
      log("[AuthService] Game data saved locally for sync");
    } catch (e) {
      log("[AuthService] Error saving game data locally: $e");
    }
  }

  // Get offline game data
  Future<List<Map<String, dynamic>>> _getOfflineGameData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final localData = preferences.getString(offlineGameDataKey);
      if (localData != null) {
        final gamesList = List<String>.from(json.decode(localData));
        return gamesList
            .map((game) => Map<String, dynamic>.from(json.decode(game)))
            .toList();
      }
    } catch (e) {
      log("[AuthService] Error reading offline game data: $e");
    }
    return [];
  }

  // Clear offline game data after sync
  Future<void> _clearOfflineGameData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(offlineGameDataKey);
    await _setPendingSync(false);
  }

  // Save local user credentials for auth sync
  Future<void> _saveLocalUserCredentials(
    String email,
    String password,
    String userName,
  ) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final credentials = {
        'email': email,
        'password': password,
        'userName': userName,
        'timestamp': DateTime.now().toIso8601String(),
      };
      await preferences.setString(
        localUserCredentialsKey,
        json.encode(credentials),
      );
      await preferences.setBool(pendingAuthSyncKey, true);
      log("[AuthService] Local user credentials saved for sync");
    } catch (e) {
      log("[AuthService] Error saving local credentials: $e");
    }
  }

  // Get local user credentials
  Future<Map<String, dynamic>?> _getLocalUserCredentials() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final credentials = preferences.getString(localUserCredentialsKey);
      if (credentials != null) {
        return Map<String, dynamic>.from(json.decode(credentials));
      }
    } catch (e) {
      log("[AuthService] Error reading local credentials: $e");
    }
    return null;
  }

  // Clear local credentials after sync
  Future<void> _clearLocalCredentials() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(localUserCredentialsKey);
    await preferences.setBool(pendingAuthSyncKey, false);
  }

  // Check if there's pending auth sync
  Future<bool> _hasPendingAuthSync() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(pendingAuthSyncKey) ?? false;
  }

  Future<void> register(String email, String userName, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      if (await isOnline) {
        // Online registration
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
        final userData = {
          "userName": userName,
          "email": email,
          "highestScore": 0,
          "totalGamesPlayed": 0,
          "totalPlayTime": 0,
          "maxSurvivalTime": 0,
          "isAnonymous": false,
          "createdAt": FieldValue.serverTimestamp(),
          "lastPlayed": FieldValue.serverTimestamp(),
          "achievementsProgress": {
            "Power Collector": {"current": 0, "isUnlocked": false},
            "Invincible": {"current": 0, "isUnlocked": false},
            "Heart Collector": {"current": 0, "isUnlocked": false},
            "Maximum Life": {"current": 0, "isUnlocked": false},
            "Combo Master": {"current": 0, "isUnlocked": false},
            "20 Games": {"current": 0, "isUnlocked": false},
            "100 Games": {"current": 0, "isUnlocked": false},
            "1000 Games": {"current": 0, "isUnlocked": false},
            "25000 Games": {"current": 0, "isUnlocked": false},
            "60000 Games": {"current": 0, "isUnlocked": false},
          },
        };

        await firestore.collection("users").doc(user.uid).set(userData);

        // Save locally for offline access
        await _saveUserDataLocally({...userData, 'uid': user.uid});
        preferences.setString(userIdForPreference, user.uid);
        preferences.setBool(isAnonymousUserKey, false);

        log("[AuthService] Online registration successful");
      } else {
        // Offline registration - create local user only
        final localUserId = 'local_${DateTime.now().millisecondsSinceEpoch}';
        final userData = {
          "userName": userName,
          "email": email,
          "highestScore": 0,
          "totalGamesPlayed": 0,
          "totalPlayTime": 0,
          "maxSurvivalTime": 0,
          "isAnonymous": false,
          "isLocalUser": true, // Mark as local user
          "createdAt": DateTime.now().toIso8601String(),
          "lastPlayed": DateTime.now().toIso8601String(),
          "uid": localUserId,
          "achievementsProgress": {
            "Power Collector": {"current": 0, "isUnlocked": false},
            "Invincible": {"current": 0, "isUnlocked": false},
            "Heart Collector": {"current": 0, "isUnlocked": false},
            "Maximum Life": {"current": 0, "isUnlocked": false},
            "Combo Master": {"current": 0, "isUnlocked": false},
            "20 Games": {"current": 0, "isUnlocked": false},
            "100 Games": {"current": 0, "isUnlocked": false},
            "1000 Games": {"current": 0, "isUnlocked": false},
            "25000 Games": {"current": 0, "isUnlocked": false},
            "60000 Games": {"current": 0, "isUnlocked": false},
          },
        };

        await _saveUserDataLocally(userData);
        await _saveLocalUserCredentials(
          email,
          password,
          userName,
        ); // Save credentials for auth sync
        preferences.setString(userIdForPreference, localUserId);
        preferences.setBool(isAnonymousUserKey, false);
        await _setPendingSync(true); // Mark for sync when online

        log(
          "[AuthService] Offline registration - user created locally with credentials saved",
        );
      }
    } catch (e) {
      log("[AuthService] Register error: ${extractMessage(e)}");
      rethrow;
    }
  }

  Future<void> login(String userInput, String password) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    try {
      if (await isOnline) {
        // Online login - try Firebase Auth first
        log("[AuthService] Starting online login...");

        String email;

        if (userInput.contains("@")) {
          // Direct email login
          try {
            await auth.signInWithEmailAndPassword(
              email: userInput,
              password: password,
            );
            email = userInput;

            // Fetch and save user data locally
            final userData = await getCurrentUserData();
            if (userData != null) {
              await _saveUserDataLocally({
                ...userData,
                'uid': auth.currentUser!.uid,
              });
            }

            preferences.setString(userIdForPreference, auth.currentUser!.uid);
            preferences.setBool(isAnonymousUserKey, false);

            // Sync any pending data
            await _syncPendingData();
            log("[AuthService] Online email login successful");
            return;
          } catch (e) {
            log("[AuthService] Email login failed: ${extractMessage(e)}");
            // Continue to username login
          }
        }

        // Username login - find email from Firestore
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

        // Fetch and save user data locally
        final userData = await getCurrentUserData();
        if (userData != null) {
          await _saveUserDataLocally({
            ...userData,
            'uid': auth.currentUser!.uid,
          });
        }

        preferences.setString(userIdForPreference, auth.currentUser!.uid);
        preferences.setBool(isAnonymousUserKey, false);

        // Sync any pending data
        await _syncPendingData();
        log("[AuthService] Online username login successful");
      } else {
        // Offline login - check local storage
        log("[AuthService] Starting offline login...");

        final localUserData = await _getLocalUserData();
        if (localUserData != null) {
          final localEmail = localUserData['email'];
          final localUserName = localUserData['userName'];

          // Check if credentials match (in production, use proper password hashing)
          if ((userInput.contains('@') && localEmail == userInput) ||
              localUserName == userInput) {
            // For demo purposes, we're not verifying password offline
            // In production, you'd use secure local authentication
            preferences.setString(userIdForPreference, localUserData['uid']);
            preferences.setBool(isAnonymousUserKey, false);

            log("[AuthService] Offline login successful");
            return;
          }
        }
        throw "Invalid credentials or no local user data found";
      }
    } catch (e) {
      log("[AuthService] Login error: ${extractMessage(e)}");
      rethrow;
    }
  }

  Future<void> signInAnonymously() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      if (await isOnline) {
        // Online anonymous sign-in
        final userCredential = await auth.signInAnonymously();
        final user = userCredential.user!;

        final userDoc = await firestore.collection("users").doc(user.uid).get();

        if (!userDoc.exists) {
          final userData = {
            "userName": "Guest_${user.uid.substring(0, 8)}",
            "email": null,
            "highestScore": 0,
            "totalGamesPlayed": 0,
            "totalPlayTime": 0,
            "maxSurvivalTime": 0,
            "isAnonymous": true,
            "createdAt": FieldValue.serverTimestamp(),
            "lastPlayed": FieldValue.serverTimestamp(),
            "achievementsProgress": {
              "Power Collector": {"current": 0, "isUnlocked": false},
              "Invincible": {"current": 0, "isUnlocked": false},
              "Heart Collector": {"current": 0, "isUnlocked": false},
              "Maximum Life": {"current": 0, "isUnlocked": false},
              "Combo Master": {"current": 0, "isUnlocked": false},
              "20 Games": {"current": 0, "isUnlocked": false},
              "100 Games": {"current": 0, "isUnlocked": false},
              "1000 Games": {"current": 0, "isUnlocked": false},
              "25000 Games": {"current": 0, "isUnlocked": false},
              "60000 Games": {"current": 0, "isUnlocked": false},
            },
          };
          await firestore.collection("users").doc(user.uid).set(userData);
          await _saveUserDataLocally({...userData, 'uid': user.uid});
        } else {
          await _saveUserDataLocally({...userDoc.data()!, 'uid': user.uid});
        }

        preferences.setString(userIdForPreference, user.uid);
        preferences.setBool(isAnonymousUserKey, true);

        log("[AuthService] Online anonymous sign-in successful: ${user.uid}");
      } else {
        // Offline anonymous sign-in
        final localUserId = 'anon_${DateTime.now().millisecondsSinceEpoch}';
        final userData = {
          "userName": "Guest_${localUserId.substring(0, 8)}",
          "email": null,
          "highestScore": 0,
          "totalGamesPlayed": 0,
          "totalPlayTime": 0,
          "maxSurvivalTime": 0,
          "isAnonymous": true,
          "isLocalUser": true,
          "createdAt": DateTime.now().toIso8601String(),
          "lastPlayed": DateTime.now().toIso8601String(),
          "uid": localUserId,
          "achievementsProgress": {
            "Power Collector": {"current": 0, "isUnlocked": false},
            "Invincible": {"current": 0, "isUnlocked": false},
            "Heart Collector": {"current": 0, "isUnlocked": false},
            "Maximum Life": {"current": 0, "isUnlocked": false},
            "Combo Master": {"current": 0, "isUnlocked": false},
            "20 Games": {"current": 0, "isUnlocked": false},
            "100 Games": {"current": 0, "isUnlocked": false},
            "1000 Games": {"current": 0, "isUnlocked": false},
            "25000 Games": {"current": 0, "isUnlocked": false},
            "60000 Games": {"current": 0, "isUnlocked": false},
          },
        };

        await _saveUserDataLocally(userData);
        preferences.setString(userIdForPreference, localUserId);
        preferences.setBool(isAnonymousUserKey, true);
        await _setPendingSync(true);

        log("[AuthService] Offline anonymous sign-in successful");
      }
    } catch (e) {
      log("[AuthService] Anonymous sign-in error: ${extractMessage(e)}");
      rethrow;
    }
  }

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      if (await isOnline) {
        await auth.signOut();
      }
      // Clear local data but keep offline game data for potential future sync
      await preferences.remove(userIdForPreference);
      await preferences.remove(isAnonymousUserKey);
      await preferences.remove(offlineUserDataKey);
      log("[AuthService] Logout successful");
    } catch (e) {
      log("[AuthService] Logout error: ${extractMessage(e)}");
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final uid = preferences.getString(userIdForPreference);

      if (uid == null) return null;

      if (await isOnline) {
        // Try to get fresh data from Firebase
        try {
          final doc = await firestore.collection("users").doc(uid).get();
          if (doc.exists) {
            final userData = doc.data()!;
            await _saveUserDataLocally({...userData, 'uid': uid});
            return userData;
          }
        } catch (e) {
          log("[AuthService] Online fetch failed, using local data: $e");
        }
      }

      // Fallback to local data
      final localData = await _getLocalUserData();
      if (localData != null) {
        return localData;
      }

      return null;
    } catch (e) {
      log("[AuthService] getCurrentUserData error: ${extractMessage(e)}");
      return null;
    }
  }

  // Get offline game data for display
  Future<List<Map<String, dynamic>>> getOfflineGameData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      final localData = preferences.getString(offlineGameDataKey);
      if (localData != null) {
        final gamesList = List<String>.from(json.decode(localData));
        return gamesList
            .map((game) => Map<String, dynamic>.from(json.decode(game)))
            .toList();
      }
    } catch (e) {
      log("[AuthService] Error reading offline game data: $e");
    }
    return [];
  }

  // Enhanced sync method that includes auth creation
  Future<void> _syncPendingData() async {
    if (!await isOnline) return;

    try {
      final hasPendingSync = await _hasPendingSync();
      final hasPendingAuthSync = await _hasPendingAuthSync();

      if (!hasPendingSync && !hasPendingAuthSync) return;

      log("[AuthService] Starting comprehensive data synchronization...");

      // Sync local user authentication first
      if (hasPendingAuthSync) {
        await _syncLocalUserToFirebaseAuth();
      }

      // Sync local user data to Firestore
      final localUserData = await _getLocalUserData();
      if (localUserData != null && localUserData['isLocalUser'] == true) {
        await _syncLocalUserToFirestore(localUserData);
      }

      // Sync offline game data
      await _syncOfflineGameData();

      log("[AuthService] Data synchronization completed successfully");
    } catch (e) {
      log("[AuthService] Sync error: $e");
      rethrow;
    }
  }

  // Sync local user to Firebase Auth (create proper auth account)
  Future<void> _syncLocalUserToFirebaseAuth() async {
    try {
      log("[AuthService] Syncing local user to Firebase Auth...");

      final credentials = await _getLocalUserCredentials();
      if (credentials == null) {
        log("[AuthService] No local credentials found for auth sync");
        return;
      }

      final email = credentials['email'];
      final password = credentials['password'];

      // Check if user already exists in Firebase Auth by trying to sign in
      try {
        // Try to sign in first (user might already exist)
        await auth.signInWithEmailAndPassword(email: email, password: password);
        log(
          "[AuthService] User already exists in Firebase Auth - signed in successfully",
        );
      } catch (signInError) {
        // If sign in fails, create new user
        if (signInError is FirebaseAuthException) {
          if (signInError.code == 'user-not-found' ||
              signInError.code == 'invalid-credential') {
            // Create new Firebase Auth user
            final userCredential = await auth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );

            // Update SharedPreferences with real Firebase UID
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            await preferences.setString(
              userIdForPreference,
              userCredential.user!.uid,
            );
            await preferences.setBool(isAnonymousUserKey, false);

            log(
              "[AuthService] New Firebase Auth user created: ${userCredential.user!.uid}",
            );
          } else {
            log(
              "[AuthService] Firebase Auth error during sync: ${signInError.code} - ${signInError.message}",
            );
            rethrow;
          }
        } else {
          rethrow;
        }
      }

      // Clear local credentials after successful sync
      await _clearLocalCredentials();
      log("[AuthService] Firebase Auth sync completed");
    } catch (e) {
      log("[AuthService] Error syncing to Firebase Auth: $e");
      rethrow;
    }
  }

  // Enhanced sync local user to Firestore
  Future<void> _syncLocalUserToFirestore(
    Map<String, dynamic> localUserData,
  ) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        log("[AuthService] No authenticated user for Firestore sync");
        return;
      }

      // Check if user already exists in Firestore
      final existingDoc =
          await firestore.collection("users").doc(user.uid).get();
      if (!existingDoc.exists) {
        // Create user in Firestore with proper data
        final userData = Map<String, dynamic>.from(localUserData);
        userData.remove('isLocalUser');
        userData.remove('uid');
        userData['createdAt'] = FieldValue.serverTimestamp();
        userData['lastPlayed'] = FieldValue.serverTimestamp();
        userData['isAnonymous'] = false;

        await firestore.collection("users").doc(user.uid).set(userData);
        log("[AuthService] Local user synced to Firestore: ${user.uid}");
      } else {
        log("[AuthService] User already exists in Firestore: ${user.uid}");
      }

      // Update local storage to remove local user flag and update with real UID
      final updatedData = Map<String, dynamic>.from(localUserData);
      updatedData.remove('isLocalUser');
      updatedData['uid'] = user.uid; // Update with real Firebase UID
      await _saveUserDataLocally(updatedData);

      await _setPendingSync(false);
      log("[AuthService] Firestore sync completed");
    } catch (e) {
      log("[AuthService] Error syncing local user to Firestore: $e");
      rethrow;
    }
  }

  // Sync offline game data to Firebase
  Future<void> _syncOfflineGameData() async {
    try {
      final offlineGames = await _getOfflineGameData();
      if (offlineGames.isEmpty) return;

      final user = auth.currentUser;
      if (user == null) return;

      for (final gameData in offlineGames) {
        await _saveGameDataToFirebase(gameData);
      }

      await _clearOfflineGameData();
      log("[AuthService] Synced ${offlineGames.length} offline games");
    } catch (e) {
      log("[AuthService] Error syncing offline games: $e");
    }
  }

  // Save game data with offline/online support
  Future<void> saveGameData({
    required int score,
    required int timeTaken,
    required int livesLeft,
    required int difficultyLevel,
    int? starPowerUpsCollected,
    int? heartPowerUpsCollected,
    int? starActivations,
    bool? reachedMaxLives,
    int? consecutivePowerUps,
  }) async {
    try {
      final gameData = {
        "score": score,
        "timeTaken": timeTaken,
        "livesLeft": livesLeft,
        "difficultyLevel": difficultyLevel,
        "starPowerUpsCollected": starPowerUpsCollected ?? 0,
        "heartPowerUpsCollected": heartPowerUpsCollected ?? 0,
        "starActivations": starActivations ?? 0,
        "reachedMaxLives": reachedMaxLives ?? false,
        "consecutivePowerUps": consecutivePowerUps ?? 0,
        "playedAt": DateTime.now().toIso8601String(),
        "date": DateTime.now().toIso8601String(),
      };

      if (await isOnline) {
        await _saveGameDataToFirebase(gameData);
        // Also sync any pending offline data
        await _syncPendingData();
      } else {
        // Save locally for later sync
        await _saveGameDataLocally(gameData);
        await _updateLocalUserStats(gameData);
        log("[AuthService] Game data saved locally (offline mode)");
      }
    } catch (e) {
      log("[AuthService] saveGameData error: ${extractMessage(e)}");
    }
  }

  // Save game data to Firebase
  Future<void> _saveGameDataToFirebase(Map<String, dynamic> gameData) async {
    final user = auth.currentUser;
    if (user == null) return;

    final userDoc = await firestore.collection("users").doc(user.uid).get();
    if (!userDoc.exists) return;

    final userData = userDoc.data()!;
    final currentHighestScore = userData["highestScore"] ?? 0;
    final currentTotalGames = userData["totalGamesPlayed"] ?? 0;
    final newTotalGames = currentTotalGames + 1;

    Map<String, dynamic> updateData = {
      "lastPlayed": FieldValue.serverTimestamp(),
      "totalGamesPlayed": newTotalGames,
      "totalPlayTime": FieldValue.increment(gameData["timeTaken"]),
      "highestScore":
          gameData["score"] > currentHighestScore
              ? gameData["score"]
              : currentHighestScore,
    };

    // Achievement updates (same as your existing code)
    Map<String, dynamic> achievementUpdates = {};

    final starPowerUpsCollected = gameData["starPowerUpsCollected"] ?? 0;
    final heartPowerUpsCollected = gameData["heartPowerUpsCollected"] ?? 0;

    if (starPowerUpsCollected > 0 || heartPowerUpsCollected > 0) {
      final totalPowerUps = starPowerUpsCollected + heartPowerUpsCollected;
      final currentProgress =
          userData['achievementsProgress']?['Power Collector']?['current'] ?? 0;
      final newTotal = currentProgress + totalPowerUps;

      achievementUpdates['achievementsProgress.Power Collector.current'] =
          newTotal;
      achievementUpdates['achievementsProgress.Power Collector.isUnlocked'] =
          newTotal >= 10;
      achievementUpdates['achievementsProgress.Power Collector.updatedAt'] =
          FieldValue.serverTimestamp();
    }

    if (gameData["starActivations"] != null &&
        gameData["starActivations"] >= 3) {
      achievementUpdates['achievementsProgress.Invincible.current'] =
          gameData["starActivations"];
      achievementUpdates['achievementsProgress.Invincible.isUnlocked'] = true;
      achievementUpdates['achievementsProgress.Invincible.updatedAt'] =
          FieldValue.serverTimestamp();
    }

    if (heartPowerUpsCollected > 0) {
      final currentHearts =
          userData['achievementsProgress']?['Heart Collector']?['current'] ?? 0;
      final newTotal = currentHearts + heartPowerUpsCollected;

      achievementUpdates['achievementsProgress.Heart Collector.current'] =
          newTotal;
      achievementUpdates['achievementsProgress.Heart Collector.isUnlocked'] =
          newTotal >= 5;
      achievementUpdates['achievementsProgress.Heart Collector.updatedAt'] =
          FieldValue.serverTimestamp();
    }

    if (gameData["reachedMaxLives"] == true) {
      achievementUpdates['achievementsProgress.Maximum Life.current'] = 5;
      achievementUpdates['achievementsProgress.Maximum Life.isUnlocked'] = true;
      achievementUpdates['achievementsProgress.Maximum Life.updatedAt'] =
          FieldValue.serverTimestamp();
    }

    if (gameData["consecutivePowerUps"] != null &&
        gameData["consecutivePowerUps"] >= 3) {
      achievementUpdates['achievementsProgress.Combo Master.current'] =
          gameData["consecutivePowerUps"];
      achievementUpdates['achievementsProgress.Combo Master.isUnlocked'] = true;
      achievementUpdates['achievementsProgress.Combo Master.updatedAt'] =
          FieldValue.serverTimestamp();
    }

    achievementUpdates['achievementsProgress.20 Games.current'] = newTotalGames;
    achievementUpdates['achievementsProgress.20 Games.isUnlocked'] =
        newTotalGames >= 20;
    achievementUpdates['achievementsProgress.20 Games.updatedAt'] =
        FieldValue.serverTimestamp();

    achievementUpdates['achievementsProgress.100 Games.current'] =
        newTotalGames;
    achievementUpdates['achievementsProgress.100 Games.isUnlocked'] =
        newTotalGames >= 100;
    achievementUpdates['achievementsProgress.100 Games.updatedAt'] =
        FieldValue.serverTimestamp();

    achievementUpdates['achievementsProgress.1000 Games.current'] =
        newTotalGames;
    achievementUpdates['achievementsProgress.1000 Games.isUnlocked'] =
        newTotalGames >= 1000;
    achievementUpdates['achievementsProgress.1000 Games.updatedAt'] =
        FieldValue.serverTimestamp();

    achievementUpdates['achievementsProgress.25000 Games.current'] =
        newTotalGames;
    achievementUpdates['achievementsProgress.25000 Games.isUnlocked'] =
        newTotalGames >= 25000;
    achievementUpdates['achievementsProgress.25000 Games.updatedAt'] =
        FieldValue.serverTimestamp();

    achievementUpdates['achievementsProgress.60000 Games.current'] =
        newTotalGames;
    achievementUpdates['achievementsProgress.60000 Games.isUnlocked'] =
        newTotalGames >= 60000;
    achievementUpdates['achievementsProgress.60000 Games.updatedAt'] =
        FieldValue.serverTimestamp();

    updateData.addAll(achievementUpdates);
    await firestore.collection("users").doc(user.uid).update(updateData);

    await firestore.collection("gameSessions").add({
      "userId": user.uid,
      "userName": userData["userName"],
      "score": gameData["score"],
      "timeTaken": gameData["timeTaken"],
      "livesLeft": gameData["livesLeft"],
      "difficultyLevel": gameData["difficultyLevel"],
      "starPowerUpsCollected": gameData["starPowerUpsCollected"],
      "heartPowerUpsCollected": gameData["heartPowerUpsCollected"],
      "starActivations": gameData["starActivations"],
      "reachedMaxLives": gameData["reachedMaxLives"],
      "consecutivePowerUps": gameData["consecutivePowerUps"],
      "playedAt": FieldValue.serverTimestamp(),
      "date": DateTime.now().toIso8601String(),
    });

    // Update local storage with new data
    final updatedUserData = {...userData, ...updateData};
    await _saveUserDataLocally({...updatedUserData, 'uid': user.uid});

    log("Game data saved successfully to Firebase for user: ${user.uid}");
  }

  // Update local user stats when offline
  Future<void> _updateLocalUserStats(Map<String, dynamic> gameData) async {
    try {
      final localUserData = await _getLocalUserData();
      if (localUserData == null) return;

      final currentHighestScore = localUserData["highestScore"] ?? 0;
      final currentTotalGames = localUserData["totalGamesPlayed"] ?? 0;
      final newTotalGames = currentTotalGames + 1;

      final updatedData = Map<String, dynamic>.from(localUserData);
      updatedData["lastPlayed"] = DateTime.now().toIso8601String();
      updatedData["totalGamesPlayed"] = newTotalGames;
      updatedData["totalPlayTime"] =
          (localUserData["totalPlayTime"] ?? 0) + gameData["timeTaken"];
      updatedData["highestScore"] =
          gameData["score"] > currentHighestScore
              ? gameData["score"]
              : currentHighestScore;

      // Update local achievements (simplified)
      final achievements = Map<String, dynamic>.from(
        updatedData["achievementsProgress"] ?? {},
      );

      // Update games played achievements
      achievements['20 Games'] = {
        'current': newTotalGames,
        'isUnlocked': newTotalGames >= 20,
      };
      achievements['100 Games'] = {
        'current': newTotalGames,
        'isUnlocked': newTotalGames >= 100,
      };
      // ... other achievements

      updatedData["achievementsProgress"] = achievements;
      await _saveUserDataLocally(updatedData);
    } catch (e) {
      log("[AuthService] Error updating local user stats: $e");
    }
  }

  // Enhanced manual sync trigger
  Future<void> manualSync() async {
    try {
      if (!await isOnline) {
        throw "No internet connection. Please check your connection and try again.";
      }

      log("[AuthService] Starting manual synchronization...");
      await _syncPendingData();

      // Verify sync was successful
      final hasPendingSync = await _hasPendingSync();
      final hasPendingAuthSync = await _hasPendingAuthSync();

      if (!hasPendingSync && !hasPendingAuthSync) {
        log("[AuthService] Manual sync completed successfully");
      } else {
        log("[AuthService] Manual sync completed but some items still pending");
      }
    } catch (e) {
      log("[AuthService] Manual sync error: $e");
      rethrow;
    }
  }

  // Enhanced sync status check
  Future<Map<String, dynamic>> getSyncStatus() async {
    final hasPendingSync = await _hasPendingSync();
    final hasPendingAuthSync = await _hasPendingAuthSync();
    final offlineGames = await _getOfflineGameData();
    final lastSync = await _getLastSyncTime();

    return {
      'hasPendingSync': hasPendingSync,
      'hasPendingAuthSync': hasPendingAuthSync,
      'offlineGamesCount': offlineGames.length,
      'lastSyncTime': lastSync,
      'isOnline': await isOnline,
    };
  }

  Future<DateTime?> _getLastSyncTime() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final lastSync = preferences.getString(lastSyncTimeKey);
    return lastSync != null ? DateTime.parse(lastSync) : null;
  }

  // Existing methods remain the same...
  Future<void> updateAddictedRunnerAchievements() async {
    log(
      "updateAddictedRunnerAchievements is no longer needed - achievements updated in saveGameData",
    );
  }

  Future<List<Map<String, dynamic>>> getUserGameHistory(bool isLimited) async {
    try {
      if (!await isOnline) {
        // Return local game data when offline
        final offlineGames = await _getOfflineGameData();
        if (isLimited && offlineGames.length > 20) {
          return offlineGames.sublist(0, 20);
        }
        return offlineGames;
      }

      final user = auth.currentUser;
      if (user == null) return <Map<String, dynamic>>[];

      Query query = firestore
          .collection("gameSessions")
          .where("userId", isEqualTo: user.uid)
          .orderBy("playedAt", descending: true);

      if (isLimited) {
        query = query.limit(20);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        if (data == null) return <String, dynamic>{};

        final Map<String, dynamic> mapData = Map<String, dynamic>.from(
          data as Map<String, dynamic>,
        );

        return {
          'id': doc.id,
          ...mapData,
          'playedAt':
              mapData['playedAt'] != null
                  ? (mapData['playedAt'] as Timestamp).toDate()
                  : null,
        };
      }).toList();
    } catch (e) {
      log("[AuthService] getUserGameHistory error: ${extractMessage(e)}");
      return <Map<String, dynamic>>[];
    }
  }

  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    try {
      if (!await isOnline) {
        // Return empty leaderboard when offline
        return [];
      }

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
      log("[AuthService] getLeaderboard error: ${extractMessage(e)}");
      return [];
    }
  }

  Future<Map<String, dynamic>> getUserPersonalBests() async {
    try {
      final localUserData = await _getLocalUserData();
      if (localUserData == null) return {};

      if (!await isOnline) {
        // Return local data when offline
        return {
          'highestScore': localUserData['highestScore'] ?? 0,
          'totalGamesPlayed': localUserData['totalGamesPlayed'] ?? 0,
          'totalPlayTime': localUserData['totalPlayTime'] ?? 0,
          'bestGame': null, // Simplified for offline
        };
      }

      final user = auth.currentUser;
      if (user == null) return {};

      final userDoc = await firestore.collection("users").doc(user.uid).get();
      if (!userDoc.exists) return {};

      final userData = userDoc.data()!;

      final bestGameQuery =
          await firestore
              .collection("gameSessions")
              .where("userId", isEqualTo: user.uid)
              .orderBy("score", descending: true)
              .limit(1)
              .get();

      Map<String, dynamic>? bestGame;
      if (bestGameQuery.docs.isNotEmpty) {
        final data = bestGameQuery.docs.first.data();
        bestGame = {
          'score': data['score'],
          'timeTaken': data['timeTaken'],
          'date': data['date'],
        };
      }

      return {
        'highestScore': userData['highestScore'] ?? 0,
        'totalGamesPlayed': userData['totalGamesPlayed'] ?? 0,
        'totalPlayTime': userData['totalPlayTime'] ?? 0,
        'bestGame': bestGame,
      };
    } catch (e) {
      log("[AuthService] getUserPersonalBests error: ${extractMessage(e)}");
      return {};
    }
  }

  Future<void> updateMaxSurvivalTime(int currentGameTime) async {
    try {
      final localUserData = await _getLocalUserData();
      if (localUserData == null) return;

      final currentMax = localUserData['maxSurvivalTime'] ?? 0;

      if (currentGameTime > currentMax) {
        if (await isOnline) {
          final user = auth.currentUser;
          if (user == null) return;

          await firestore.collection('users').doc(user.uid).set({
            'maxSurvivalTime': currentGameTime,
            'lastUpdated': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }

        // Update locally regardless of online status
        final updatedData = Map<String, dynamic>.from(localUserData);
        updatedData['maxSurvivalTime'] = currentGameTime;
        updatedData['lastUpdated'] = DateTime.now().toIso8601String();
        await _saveUserDataLocally(updatedData);

        debugPrint('New max survival time recorded: $currentGameTime seconds');
      }
    } catch (e) {
      debugPrint('Error updating max survival time: $e');
      rethrow;
    }
  }

  String extractMessage(Object e) {
    if (e is FirebaseAuthException) return e.message ?? "An error occurred";
    if (e is String) return e;
    return e.toString();
  }

  Future<void> saveRewardPoints(int points) async {
    try {
      final localUserData = await _getLocalUserData();
      if (localUserData == null) return;

      if (await isOnline) {
        final user = auth.currentUser;
        if (user == null) return;

        await firestore.collection("users").doc(user.uid).set({
          'rewardPoints': FieldValue.increment(points),
          'totalRewardPointsEarned': FieldValue.increment(points),
          'lastRewardEarned': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      // Update locally
      final updatedData = Map<String, dynamic>.from(localUserData);
      updatedData['rewardPoints'] =
          (localUserData['rewardPoints'] ?? 0) + points;
      updatedData['totalRewardPointsEarned'] =
          (localUserData['totalRewardPointsEarned'] ?? 0) + points;
      updatedData['lastRewardEarned'] = DateTime.now().toIso8601String();
      await _saveUserDataLocally(updatedData);

      log("Reward points saved: $points points");
    } catch (e) {
      log("[AuthService] saveRewardPoints error: ${extractMessage(e)}");
      rethrow;
    }
  }

  Future<int> getRewardPoints() async {
    try {
      final localUserData = await _getLocalUserData();
      if (localUserData == null) return 0;

      return (localUserData['rewardPoints'] ?? 0) as int;
    } catch (e) {
      log("[AuthService] getRewardPoints error: ${extractMessage(e)}");
      return 0;
    }
  }

  Future<Map<String, dynamic>> getRewardStats() async {
    try {
      final localUserData = await _getLocalUserData();
      if (localUserData == null) return {};

      return {
        'currentPoints': localUserData['rewardPoints'] ?? 0,
        'totalEarned': localUserData['totalRewardPointsEarned'] ?? 0,
        'lastReward':
            localUserData['lastRewardEarned'] != null
                ? DateTime.parse(localUserData['lastRewardEarned'])
                : null,
      };
    } catch (e) {
      log("[AuthService] getRewardStats error: ${extractMessage(e)}");
      return {};
    }
  }
}
