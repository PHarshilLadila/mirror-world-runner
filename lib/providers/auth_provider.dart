import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mirror_world_runner/service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _currentUser;
  Map<String, dynamic>? get currentUser => _currentUser;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> register(String email, String userName, String password) async {
    _setLoading(true);
    try {
      await _authService.register(email, userName, password);
      await fetchCurrentUser();
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
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _currentUser = null;
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
      notifyListeners();
    } catch (e) {
      log("[AuthProvider] Error fetching current user: $e");
    } finally {
      _setLoading(false);
    }
  }
}
