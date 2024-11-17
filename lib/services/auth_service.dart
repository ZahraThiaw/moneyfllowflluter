// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:moneyflow/core/http/http_client_interface.dart';
import 'package:moneyflow/core/http/http_exception.dart';
import 'package:moneyflow/models/transaction.dart';
import 'package:moneyflow/models/user.dart';
import 'package:moneyflow/services/storage_service.dart';

class AuthService {
  // Définir une constante pour l'URL de base
  static const String baseUrl = 'https://mycashjava.onrender.com';

  final IHttpClient _httpClient;
  final StorageService _storageService;

  AuthService({
    required IHttpClient httpClient,
    required StorageService storageService,
  }) : _httpClient = httpClient, 
       _storageService = storageService;

  Future<Map<String, dynamic>> login(String telephone, String password) async {
    try {
      final response = await _httpClient.post(
        '/auth/login', // URL corrigée
        {
          'telephone': telephone,
          'password': password,
        },
      );
      
      if (response == null) {
        throw HttpException(
          statusCode: 500,
          message: 'Aucune réponse du serveur',
        );
      }

      if (response['status'] != 'success') {
        final message = response['message'] ?? 'Erreur de connexion';
        throw HttpException(
          statusCode: 400,
          message: message,
        );
      }

      final token = response['data']['token'] as String?;
      if (token == null) {
        throw HttpException(
          statusCode: 400,
          message: 'Token manquant dans la réponse',
        );
      }

      _httpClient.setAuthToken(token);
      await _storageService.saveAuthToken(token);
      
      return response;
    } catch (e) {
      debugPrint('Login error: ${e.toString()}');
      if (e is HttpException) {
        rethrow;
      }
      throw HttpException(
        statusCode: 500,
        message: 'Erreur de connexion: ${e.toString()}',
      );
    }
  }

  Future<Map<String, dynamic>> getUserProfileWithTransactions() async {
    try {
      final response = await _httpClient.get(
        '/users/profile', // URL corrigée
      );
      
      if (response == null) {
        throw HttpException(
          statusCode: 500,
          message: 'Aucune réponse du serveur',
        );
      }

      if (response['status'] != 'success') {
        final message = response['message'] ?? 'Erreur lors de la récupération du profil';
        throw HttpException(
          statusCode: 400,
          message: message,
        );
      }

      final data = response['data']['data'];
      final userData = data['user'];
      final user = User.fromProfileResponse(userData);
      await _storageService.saveUser(user);

      List<Transaction> transactions = [];
      if (data['transactions'] is List) {
        transactions = (data['transactions'] as List)
            .map((t) => Transaction.fromJson(t))
            .toList();
      }

      return {
        'user': user,
        'transactions': transactions,
      };
    } catch (e) {
      debugPrint('Get user profile error: ${e.toString()}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> signup({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    required String password,
  }) async {
    return await _httpClient.post(
      '/auth/signup', // URL corrigée
      {
        'nom': nom,
        'prenom': prenom,
        'telephone': telephone,
        'email': email,
        'password': password,
      },
    );
  }



  Future<void> logout() async {
    try {
      await _httpClient.post('https://mycashjava.onrender.com/auth/logout', {});
    } finally {
      _httpClient.clearAuthToken();
      await _storageService.clearAll();
    }
  }

  Future<void> restoreSession() async {
    final authToken = _storageService.getAuthToken();
    if (authToken != null) {
      _httpClient.setAuthToken(authToken.token);
    }
  }
  
  // Future<Map<String, dynamic>> signup({
  //   required String nom,
  //   required String prenom,
  //   required String telephone,
  //   required String email,
  //   required String password,
  // }) async {
  //   final response = await _httpClient.post(
  //     'https://mycashjava.onrender.com/auth/signup',
  //     {
  //       'nom': nom,
  //       'prenom': prenom,
  //       'telephone': telephone,
  //       'email': email,
  //       'password': password,
  //     },
  //   );
    
  //   return response;
  // }
}