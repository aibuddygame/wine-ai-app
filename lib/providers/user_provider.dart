import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/repositories/database_helper.dart';

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

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      _user = await _db.getUser();
      _error = null;
    } catch (e) {
      _error = 'Failed to load user data';
      debugPrint('UserProvider.loadUser error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUser({
    required String occupation,
    required int typicalBudget,
  }) async {
    _isLoading = true;
    _error = null;
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
    } catch (e) {
      _error = 'Failed to save user data';
      debugPrint('UserProvider.saveUser error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
