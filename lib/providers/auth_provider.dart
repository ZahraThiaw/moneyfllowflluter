import 'package:flutter/material.dart';
import 'package:moneyflow/core/http/http_exception.dart';
import 'package:moneyflow/models/user.dart';
import 'package:moneyflow/models/transaction.dart';
import 'package:moneyflow/services/auth_service.dart';
import 'package:moneyflow/services/transaction_service.dart';


// lib/providers/auth_provider.dart
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final TransactionService _transactionService;

  User? _user;
  bool _isLoading = false;
  List<Transaction> _transactions = [];
  String? _error;

  AuthProvider({
    required AuthService authService,
    required TransactionService transactionService,
  })  : _authService = authService,
        _transactionService = transactionService;

  User? get user => _user;
  bool get isLoading => _isLoading;
  List<Transaction> get transactions => _transactions;
  String? get error => _error;

  Future<void> login(String telephone, String password) async {
    _setLoading(true);
    _error = null;
    
    try {
      await _authService.login(telephone, password);
      await loadUserProfile();
      await fetchTransactions();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadUserProfile() async {
    try {
      final user = await _authService.getUserProfile();
      if (user == null) {
        throw HttpException(
          statusCode: 404,
          message: 'Profil utilisateur non trouvé',
        );
      }
      _user = user;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> fetchTransactions() async {
    if (_isLoading) return;

    _setLoading(true);
    _error = null;

    try {
      _transactions = await _transactionService.getTransactions();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _transactions = [];
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _user = null;
      _transactions.clear();
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> refreshData() async {
    _error = null;
    await loadUserProfile();
    await fetchTransactions();
  }
  Future<bool> signup({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _authService.signup(
        nom: nom,
        prenom: prenom,
        telephone: telephone,
        email: email,
        password: password,
      );
      return true; // Si l'inscription réussit
    } catch (e) {
      return false; // Si l'inscription échoue
    } finally {
      _setLoading(false);
    }
  }
}
