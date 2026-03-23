import 'package:flutter/material.dart';
import '../data/models/user_model.dart';
import '../data/repositories/database_helper.dart';

/// User Context Provider
class UserProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUser => _user != null;

  UserProvider() {
    loadUser();
  }

  /// Load user from database
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _db.getUser();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save user context
  Future<void> saveUser({
    required String occupation,
    required int typicalBudget,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final tier = User.calculateTier(typicalBudget);
      final user = User(
        occupation: occupation,
        typicalBudget: typicalBudget,
        consumptionTier: tier,
      );

      await _db.saveUser(user);
      _user = await _db.getUser();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user
  Future<void> updateUser(User updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _db.saveUser(updatedUser);
      _user = await _db.getUser();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
