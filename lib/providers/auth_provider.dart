// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:mirror_world_runner/service/auth_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthProvider extends ChangeNotifier {
//   final AuthService _authService = AuthService();

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   Map<String, dynamic>? _currentUser;
//   Map<String, dynamic>? get currentUser => _currentUser;

//   void _setLoading(bool value) {
//     _isLoading = value;
//     notifyListeners();
//   }

//   Future<void> register(String email, String userName, String password) async {
//     _setLoading(true);
//     try {
//       await _authService.register(email, userName, password);
//       await fetchCurrentUser();
//     } catch (e) {
//       rethrow;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> login(String userName, String password) async {
//     _setLoading(true);
//     try {
//       await _authService.login(userName, password);
//       await fetchCurrentUser();
//     } catch (e) {
//       rethrow;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> signInAnonymously() async {
//     _setLoading(true);
//     try {
//       await _authService.signInAnonymously();
//       await fetchCurrentUser();
//     } catch (e) {
//       rethrow;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> logout() async {
//     _setLoading(true);
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     Set<String> keys = preferences.getKeys();

//     try {
//       debugPrint("Keys in SharedPreferences before clearing:");
//       for (var key in keys) {
//         debugPrint(key);
//       }
//       await preferences.clear();
//       await _authService.logout();
//       _currentUser = null;
//       notifyListeners();
//     } catch (e) {
//       rethrow;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> fetchCurrentUser() async {
//     _setLoading(true);
//     try {
//       _currentUser = await _authService.getCurrentUserData();
//       notifyListeners();
//     } catch (e) {
//       log("[AuthProvider] Error fetching current user: $e");
//     } finally {
//       _setLoading(false);
//     }
//   }
// }

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mirror_world_runner/service/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _currentUser;
  Map<String, dynamic>? get currentUser => _currentUser;

  bool _isOnline = true;
  bool get isOnline => _isOnline;

  bool _hasPendingSync = false;
  bool get hasPendingSync => _hasPendingSync;

  bool _hasPendingAuthSync = false;
  bool get hasPendingAuthSync => _hasPendingAuthSync;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Check online status and sync status
  Future<void> checkConnectionStatus() async {
    try {
      _isOnline = await _authService.isOnline;
      final syncStatus = await _authService.getSyncStatus();
      _hasPendingSync = syncStatus['hasPendingSync'] ?? false;
      _hasPendingAuthSync = syncStatus['hasPendingAuthSync'] ?? false;
      notifyListeners();
    } catch (e) {
      log("[AuthProvider] Error checking connection status: $e");
    }
  }

  // Manual sync trigger with enhanced feedback
  Future<void> manualSync() async {
    _setLoading(true);
    try {
      await _authService.manualSync();
      await checkConnectionStatus();
      await fetchCurrentUser();

      // Check if sync was successful
      final syncStatus = await _authService.getSyncStatus();
      if (!syncStatus['hasPendingSync'] && !syncStatus['hasPendingAuthSync']) {
        log("[AuthProvider] Manual sync completed successfully");
      } else {
        log("[AuthProvider] Manual sync completed with pending items");
      }
    } catch (e) {
      log("[AuthProvider] Manual sync error: $e");
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(String email, String userName, String password) async {
    _setLoading(true);
    try {
      await _authService.register(email, userName, password);
      await fetchCurrentUser();
      await checkConnectionStatus();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> login(String userName, String password) async {
    _setLoading(true);
    try {
      await _authService.login(userName, password);
      await fetchCurrentUser();
      await checkConnectionStatus();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInAnonymously() async {
    _setLoading(true);
    try {
      await _authService.signInAnonymously();
      await fetchCurrentUser();
      await checkConnectionStatus();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Set<String> keys = preferences.getKeys();

    try {
      debugPrint("Keys in SharedPreferences before clearing:");
      for (var key in keys) {
        debugPrint(key);
      }
      await preferences.clear();
      await _authService.logout();
      _currentUser = null;
      _hasPendingSync = false;
      _hasPendingAuthSync = false;
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCurrentUser() async {
    _setLoading(true);
    try {
      _currentUser = await _authService.getCurrentUserData();
      await checkConnectionStatus();
      notifyListeners();
    } catch (e) {
      log("[AuthProvider] Error fetching current user: $e");
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> getSyncStatus() async {
    return await _authService.getSyncStatus();
  }
}
