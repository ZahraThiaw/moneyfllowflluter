// lib/services/auth_service.dart
import 'package:flutter/material.dart';
import 'package:moneyflow/core/http/http_client_interface.dart';
import 'package:moneyflow/core/http/http_exception.dart';
import 'package:moneyflow/models/user.dart';
import 'package:moneyflow/services/storage_service.dart';

class AuthService {
  final IHttpClient _httpClient;
  final StorageService _storageService;

  AuthService({
    required IHttpClient httpClient,
    required StorageService storageService,
  }) : _httpClient = httpClient, _storageService = storageService;

  Future<Map<String, dynamic>> login(String telephone, String password) async {
    try {
      final response = await _httpClient.post(
        'https://mycashjava.onrender.com/auth/login',
        {
          'telephone': telephone,
          'password': password,
        },
      );
      
      if (response == null || 
          !response.containsKey('status') || 
          response['status'] != 'success' ||
          !response.containsKey('data')) {
        throw HttpException(
          statusCode: 400,
          message: 'Erreur de connexion',
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
      return response;
    } catch (e) {
      throw HttpException(
        statusCode: 500,
        message: 'Erreur de connexion: ${e.toString()}',
      );
    }
  }

  Future<User?> getUserProfile() async {
    try {
      final response = await _httpClient.get(
        'https://mycashjava.onrender.com/users/profile',
      );
      
      if (response == null || 
          response['status'] != 'success' || 
          !response.containsKey('data') ||
          !response['data'].containsKey('data')) {
        return null;
      }

      final userData = response['data']['data'];
      final user = User.fromProfileResponse(userData);
      await _storageService.saveUser(user);
      return user;
    } catch (e) {
      debugPrint('Get user profile error: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _httpClient.post('https://mycashjava.onrender.com/auth/logout', {});
    } finally {
      _httpClient.clearAuthToken();
      await _storageService.deleteUser();
    }
  }
  Future<Map<String, dynamic>> signup({
    required String nom,
    required String prenom,
    required String telephone,
    required String email,
    required String password,
  }) async {
    final response = await _httpClient.post(
      'https://mycashjava.onrender.com/auth/signup',
      {
        'nom': nom,
        'prenom': prenom,
        'telephone': telephone,
        'email': email,
        'password': password,
      },
    );
    
    return response;
  }
}