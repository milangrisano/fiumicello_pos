import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:responsive_app/models/user.dart';
import 'package:responsive_app/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  static final AuthProvider instance = AuthProvider._internal();

  final AuthService _authService = AuthService();

  AuthProvider._internal() {
    _checkAuthStatus();
  }

  User? _currentUser;
  String? _jwtToken;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  String? get token => _jwtToken;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get isAuthenticated => _jwtToken != null;
  String? get userName => _currentUser?.name;
  String? get userPhoto =>
      null; // To-Do: add to User model if backend supports it

  Future<void> _checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedToken = prefs.getString('token');
      final savedUserJson = prefs.getString('user');

      if (savedToken != null && savedUserJson != null) {
        _jwtToken = savedToken;
        _currentUser = User.fromJson(json.decode(savedUserJson));
        log('AuthProvider: Sesión recuperada para ${_currentUser!.email}');
      }
    } catch (e) {
      log('AuthProvider: Error al recuperar la sesión -> $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.login(email, password);
      _currentUser = response.user;
      _jwtToken = response.token;

      await _persistSession();

      log('AuthProvider: Login exitoso para ${_currentUser!.email}');
      return true;
    } catch (e) {
      log('AuthProvider: Login falló -> $e');
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _authService.register(name, email, password);
      _currentUser = response.user;
      _jwtToken = response.token;

      await _persistSession();

      log('AuthProvider: Registro exitoso para ${_currentUser!.email}');
      return true;
    } catch (e) {
      log('AuthProvider: Registro falló -> $e');
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');

      _currentUser = null;
      _jwtToken = null;

      log('AuthProvider: Logout exitoso');
    } catch (e) {
      log('AuthProvider: Error durante logout -> $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> sendVerificationCode(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.sendVerificationCode(email);
      return true;
    } catch (e) {
      log('AuthProvider: Error al enviar código -> $e');
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyEmailCode(String email, String code) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.verifyEmailCode(email, code);
      if (_currentUser != null) {
        // Update the local instance as verified
        _currentUser = User(
          id: _currentUser!.id,
          email: _currentUser!.email,
          name: _currentUser!.name,
          isActive: _currentUser!.isActive,
          isEmailVerified: true,
          roles: _currentUser!.roles,
        );
        await _persistSession();
      }
      return true;
    } catch (e) {
      log('AuthProvider: Error al verificar código -> $e');
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _persistSession() async {
    if (_jwtToken == null || _currentUser == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _jwtToken!);
    await prefs.setString('user', json.encode(_currentUser!.toJson()));
  }

  Future<bool> sendPasswordResetCode(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.sendPasswordResetCode(email);
      return true;
    } catch (e) {
      log('AuthProvider: Error al enviar código de recuperación -> $e');
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email, String code, String newPassword) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.resetPassword(email, code, newPassword);
      return true;
    } catch (e) {
      log('AuthProvider: Error al restablecer contraseña -> $e');
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

