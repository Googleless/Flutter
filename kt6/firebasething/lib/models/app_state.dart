import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/auth_service.dart';

class AppState extends ChangeNotifier {
  final AuthService authService;
  bool _isLoggedIn = false;
  User? _currentUser;

  AppState(this.authService) {
    _init();
  }

  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;

  Future<void> _init() async {
    _isLoggedIn = await authService.isLoggedIn();
    if (_isLoggedIn) {
      _currentUser = FirebaseAuth.instance.currentUser;
    }
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    try {
      _currentUser = await authService.registerWithEmailAndPassword(email, password);
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _currentUser = await authService.signInWithEmailAndPassword(email, password);
      _isLoggedIn = true;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await authService.signOut();
      _isLoggedIn = false;
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}