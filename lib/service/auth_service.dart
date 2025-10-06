import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        "maxSurvivalTime": 0,
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
      final user = auth.currentUser;
      if (user == null) return;

      final userDoc = await firestore.collection("users").doc(user.uid).get();
      if (!userDoc.exists) return;

      final userData = userDoc.data()!;
      final currentHighestScore = userData["highestScore"] ?? 0;

      Map<String, dynamic> updateData = {
        "lastPlayed": FieldValue.serverTimestamp(),
        "totalGamesPlayed": FieldValue.increment(1),
        "totalPlayTime": FieldValue.increment(timeTaken),
        "highestScore":
            score > currentHighestScore ? score : currentHighestScore,
      };

      Map<String, dynamic> achievementUpdates = {};

      // Power Collector achievements
      if (starPowerUpsCollected != null || heartPowerUpsCollected != null) {
        final totalPowerUps =
            (starPowerUpsCollected ?? 0) + (heartPowerUpsCollected ?? 0);
        final currentProgress =
            userData['achievementsProgress']?['Power Collector']?['current'] ??
            0;
        final newTotal = currentProgress + totalPowerUps;

        achievementUpdates['achievementsProgress.Power Collector.current'] =
            newTotal;
        achievementUpdates['achievementsProgress.Power Collector.isUnlocked'] =
            newTotal >= 10;
        achievementUpdates['achievementsProgress.Power Collector.updatedAt'] =
            FieldValue.serverTimestamp();
      }

      if (starActivations != null && starActivations >= 3) {
        achievementUpdates['achievementsProgress.Invincible.current'] =
            starActivations;
        achievementUpdates['achievementsProgress.Invincible.isUnlocked'] = true;
        achievementUpdates['achievementsProgress.Invincible.updatedAt'] =
            FieldValue.serverTimestamp();
      }

      if (heartPowerUpsCollected != null) {
        final currentHearts =
            userData['achievementsProgress']?['Heart Collector']?['current'] ??
            0;
        final newTotal = currentHearts + heartPowerUpsCollected;

        achievementUpdates['achievementsProgress.Heart Collector.current'] =
            newTotal;
        achievementUpdates['achievementsProgress.Heart Collector.isUnlocked'] =
            newTotal >= 5;
        achievementUpdates['achievementsProgress.Heart Collector.updatedAt'] =
            FieldValue.serverTimestamp();
      }

      if (reachedMaxLives == true) {
        achievementUpdates['achievementsProgress.Maximum Life.current'] = 5;
        achievementUpdates['achievementsProgress.Maximum Life.isUnlocked'] =
            true;
        achievementUpdates['achievementsProgress.Maximum Life.updatedAt'] =
            FieldValue.serverTimestamp();
      }

      if (consecutivePowerUps != null && consecutivePowerUps >= 3) {
        achievementUpdates['achievementsProgress.Combo Master.current'] =
            consecutivePowerUps;
        achievementUpdates['achievementsProgress.Combo Master.isUnlocked'] =
            true;
        achievementUpdates['achievementsProgress.Combo Master.updatedAt'] =
            FieldValue.serverTimestamp();
      }

      updateData.addAll(achievementUpdates);
      await firestore.collection("users").doc(user.uid).update(updateData);

      // Save game session with timestamp
      await firestore.collection("gameSessions").add({
        "userId": user.uid,
        "userName": userData["userName"],
        "score": score,
        "timeTaken": timeTaken,
        "livesLeft": livesLeft,
        "difficultyLevel": difficultyLevel,
        "starPowerUpsCollected": starPowerUpsCollected ?? 0,
        "heartPowerUpsCollected": heartPowerUpsCollected ?? 0,
        "starActivations": starActivations ?? 0,
        "reachedMaxLives": reachedMaxLives ?? false,
        "consecutivePowerUps": consecutivePowerUps ?? 0,
        "playedAt": FieldValue.serverTimestamp(),
        "date": DateTime.now().toIso8601String(),
      });

      log("Game data saved successfully for user: ${user.uid}");

      // Update Addicted Runner achievements after saving game data
      await updateAddictedRunnerAchievements();
    } catch (e) {
      log("[AuthService] saveGameData error: ${_extractMessage(e)}");
    }
  }

  Future<Map<String, int>> calculateGamesInTimeframes(String userId) async {
    try {
      final now = DateTime.now();

      // Calculate exact timeframes from current time
      final oneHourAgo = now.subtract(const Duration(hours: 1));
      final oneDayAgo = now.subtract(const Duration(days: 1));
      final oneWeekAgo = now.subtract(const Duration(days: 7));
      final threeWeeksAgo = now.subtract(const Duration(days: 21));
      final oneMonthAgo = now.subtract(const Duration(days: 30));

      log('Timeframes calculated:');
      log('Now: $now');
      log('1 hour ago: $oneHourAgo');
      log('1 day ago: $oneDayAgo');
      log('1 week ago: $oneWeekAgo');
      log('3 weeks ago: $threeWeeksAgo');
      log('1 month ago: $oneMonthAgo');

      // Query all sessions within the last month
      final sessionsQuery =
          await firestore
              .collection("gameSessions")
              .where("userId", isEqualTo: userId)
              .where("playedAt", isGreaterThan: Timestamp.fromDate(oneMonthAgo))
              .orderBy("playedAt", descending: true)
              .get();

      log('Total sessions found in last month: ${sessionsQuery.docs.length}');

      int gamesInLastHour = 0;
      int gamesInLastDay = 0;
      int gamesInLastWeek = 0;
      int gamesInLast3Weeks = 0;
      int gamesInLastMonth =
          sessionsQuery.docs.length; // All queried games are within last month

      for (var doc in sessionsQuery.docs) {
        final data = doc.data();
        final playedAtTimestamp = data['playedAt'] as Timestamp?;

        if (playedAtTimestamp != null) {
          final playedAt = playedAtTimestamp.toDate();

          if (playedAt.isAfter(oneHourAgo)) {
            gamesInLastHour++;
            log('Game in last hour: $playedAt');
          }
          if (playedAt.isAfter(oneDayAgo)) gamesInLastDay++;
          if (playedAt.isAfter(oneWeekAgo)) gamesInLastWeek++;
          if (playedAt.isAfter(threeWeeksAgo)) gamesInLast3Weeks++;
        }
      }

      log('Games calculated from current time:');
      log('In last hour: $gamesInLastHour');
      log('In last day: $gamesInLastDay');
      log('In last week: $gamesInLastWeek');
      log('In last 3 weeks: $gamesInLast3Weeks');
      log('In last month: $gamesInLastMonth');

      return {
        'hour': gamesInLastHour,
        'day': gamesInLastDay,
        'week': gamesInLastWeek,
        'threeWeeks': gamesInLast3Weeks,
        'month': gamesInLastMonth,
      };
    } catch (e) {
      log("[AuthService] calculateGamesInTimeframes error: $e");
      return {'hour': 0, 'day': 0, 'week': 0, 'threeWeeks': 0, 'month': 0};
    }
  }

  Future<void> updateAddictedRunnerAchievements() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        log("No user logged in");
        return;
      }

      log("Updating Addicted Runner achievements for user: ${user.uid}");
      final gameStats = await calculateGamesInTimeframes(user.uid);

      Map<String, dynamic> achievementUpdates = {};

      // 20 Games in 1 hour
      achievementUpdates['achievementsProgress.20 Games.current'] =
          gameStats['hour'] ?? 0;
      achievementUpdates['achievementsProgress.20 Games.isUnlocked'] =
          (gameStats['hour'] ?? 0) >= 20;
      achievementUpdates['achievementsProgress.20 Games.updatedAt'] =
          FieldValue.serverTimestamp();

      // 100 Games in 1 day
      achievementUpdates['achievementsProgress.100 Games.current'] =
          gameStats['day'] ?? 0;
      achievementUpdates['achievementsProgress.100 Games.isUnlocked'] =
          (gameStats['day'] ?? 0) >= 100;
      achievementUpdates['achievementsProgress.100 Games.updatedAt'] =
          FieldValue.serverTimestamp();

      // 1000 Games in 1 week
      achievementUpdates['achievementsProgress.1000 Games.current'] =
          gameStats['week'] ?? 0;
      achievementUpdates['achievementsProgress.1000 Games.isUnlocked'] =
          (gameStats['week'] ?? 0) >= 1000;
      achievementUpdates['achievementsProgress.1000 Games.updatedAt'] =
          FieldValue.serverTimestamp();

      // 25000 Games in 3 weeks
      achievementUpdates['achievementsProgress.25000 Games.current'] =
          gameStats['threeWeeks'] ?? 0;
      achievementUpdates['achievementsProgress.25000 Games.isUnlocked'] =
          (gameStats['threeWeeks'] ?? 0) >= 25000;
      achievementUpdates['achievementsProgress.25000 Games.updatedAt'] =
          FieldValue.serverTimestamp();

      // 60000 Games in 1 month
      achievementUpdates['achievementsProgress.60000 Games.current'] =
          gameStats['month'] ?? 0;
      achievementUpdates['achievementsProgress.60000 Games.isUnlocked'] =
          (gameStats['month'] ?? 0) >= 60000;
      achievementUpdates['achievementsProgress.60000 Games.updatedAt'] =
          FieldValue.serverTimestamp();

      log("Achievement updates: $achievementUpdates");

      await firestore
          .collection("users")
          .doc(user.uid)
          .update(achievementUpdates);

      log("Addicted Runner achievements updated successfully");
    } catch (e) {
      log("[AuthService] updateAddictedRunnerAchievements error: $e");
    }
  }

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

  Future<Map<String, dynamic>> getUserPersonalBests() async {
    try {
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
      log("[AuthService] getUserPersonalBests error: ${_extractMessage(e)}");
      return {};
    }
  }

  Future<void> updateMaxSurvivalTime(int currentGameTime) async {
    try {
      final user = auth.currentUser;
      if (user == null) return;

      final userDoc = await firestore.collection('users').doc(user.uid).get();
      final currentMax = userDoc.data()?['maxSurvivalTime'] ?? 0;

      if (currentGameTime > currentMax) {
        await firestore.collection('users').doc(user.uid).set({
          'maxSurvivalTime': currentGameTime,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        debugPrint('New max survival time recorded: $currentGameTime seconds');
      }
    } catch (e) {
      debugPrint('Error updating max survival time: $e');
      rethrow;
    }
  }

  String _extractMessage(Object e) {
    if (e is FirebaseAuthException) return e.message ?? "An error occurred";
    if (e is String) return e;
    return e.toString();
  }
}
