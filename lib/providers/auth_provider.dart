import 'package:flutter/material.dart';
import 'package:moneyflow/core/http/http_client_interface.dart';
import 'package:moneyflow/core/http/http_exception.dart';
import 'package:moneyflow/models/user.dart';
import 'package:moneyflow/models/transaction.dart';
import 'package:moneyflow/services/auth_service.dart';
import 'package:moneyflow/services/transaction_service.dart';


// lib/providers/auth_provider.dart
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final TransactionService _transactionService;
  final IHttpClient _httpClient;

  User? _user;
  bool _isLoading = false;
  List<Transaction> _transactions = [];
  String? _error;

  AuthProvider({
    required AuthService authService,
    required TransactionService transactionService,
    required IHttpClient httpClient,
  })  : _authService = authService,
        _transactionService = transactionService,
        _httpClient = httpClient;

  User? get user => _user;
  bool get isLoading => _isLoading;
  List<Transaction> get transactions => _transactions;
  String? get error => _error;

  // Future<void> login(String telephone, String password) async {
  //   _setLoading(true);
  //   _error = null;
    
  //   try {
  //     await _authService.login(telephone, password);
  //     await loadUserProfile();
  //     //await fetchTransactions();
  //   } catch (e) {
  //     _error = e.toString();
  //     rethrow;
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  Future<bool> login(String telephone, String password) async {
    _setLoading(true);
    _error = null;
    
    try {
      // Tentative de connexion
      await _authService.login(telephone, password);
      
      // Chargement du profil utilisateur et des transactions
      final profileData = await _authService.getUserProfileWithTransactions();
      
      _user = profileData['user'] as User;
      _transactions = (profileData['transactions'] as List<Transaction>);

      print('Profile response: $profileData');

      notifyListeners();
      return true;
    } on HttpException catch (e) {
      _error = e.message;
      debugPrint('Login error (HTTP): ${e.message}');
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Une erreur inattendue est survenue: ${e.toString()}';
      debugPrint('Login error (Unknown): ${e.toString()}');
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshUserData() async {
    try {
      final profileData = await _authService.getUserProfileWithTransactions();
      
      _user = profileData['user'] as User?;
      _transactions = (profileData['transactions'] as List<Transaction>? ?? []);
      
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> fetchTransactions() async {
    if (_isLoading) return;

    _setLoading(true);
    _error = null;

    try {
      // Si vous avez besoin de récupérer plus de transactions ou de les actualiser
      final newTransactions = await _transactionService.getTransactions();
      _transactions = newTransactions;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Méthode utilitaire pour accéder aux transactions d'un certain type
  List<Transaction> getTransactionsByType(String type) {
    return _transactions.where((t) => t.type == type).toList();
  }

  // Méthode utilitaire pour obtenir le total des transactions
  double getTotalTransactionAmount(String type) {
    return _transactions
        .where((t) => t.type == type)
        .fold(0.0, (sum, t) => sum + t.montantTotal);
  }

  Future<void> loadUserProfile() async {
    try {
      final response = await _httpClient.get(
        'https://mycashjava.onrender.com/users/profile',
      );
      
      if (response == null || 
          response['status'] != 'success' || 
          !response.containsKey('data') ||
          !response['data'].containsKey('data')) {
        throw HttpException(
          statusCode: 404,
          message: 'Profil utilisateur non trouvé',
        );
      }

      final userData = response['data']['data']['user'];
      _user = User.fromProfileResponse(userData);
      print(_user!.toJson());

      // Update transactions if available
      if (response['data']['data'].containsKey('transactions')) {
        final transactionsList = response['data']['data']['transactions'] as List;
        _transactions = transactionsList
            .map((transactionData) => Transaction.fromJson(transactionData))
            .toList();
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }


  // Future<void> fetchTransactions() async {
  //   if (_isLoading) return;

  //   _setLoading(true);
  //   _error = null;

  //   try {
  //     _transactions = await _transactionService.getTransactions();
  //     notifyListeners();
  //   } catch (e) {
  //     _error = e.toString();
  //     _transactions = [];
  //     notifyListeners();
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

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

  // void _setLoading(bool value) {
  //   _isLoading = value;
  //   notifyListeners();
  // }

  // Future<void> refreshData() async {
  //   _error = null;
  //   await loadUserProfile();
  //   //await fetchTransactions();
  // }
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
