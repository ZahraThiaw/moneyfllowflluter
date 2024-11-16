// transaction_service.dart
import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../core/http/http_client_interface.dart';
import '../core/http/http_exception.dart';

class TransactionService {
  final IHttpClient _httpClient;

  TransactionService({required IHttpClient httpClient}) : _httpClient = httpClient;

  Future<List<Transaction>> getTransactions() async {
    try {
      if (!await _verifyAuthToken()) {
        throw HttpException(
          statusCode: 401,
          message: 'Non authentifié',
        );
      }

      final response = await _httpClient.get(
        'https://mycashjava.onrender.com/user/transactions',
      );

      if (response == null) {
        throw HttpException(
          statusCode: 500,
          message: 'Erreur de connexion au serveur',
        );
      }

      // Vérification du status de la réponse
      if (response['status'] != 'success') {
        throw HttpException(
          statusCode: 500,
          message: response['message'] ?? 'Erreur lors de la récupération des transactions',
        );
      }

      // Extraction des données
      final data = response['data'];
      if (data == null) return [];

      // Vérification de la structure des données
      if (data is! Map || !data.containsKey('data')) {
        throw HttpException(
          statusCode: 500,
          message: 'Format de réponse invalide',
        );
      }

      final transactionsData = data['data'];
      if (transactionsData == null) return [];
      if (transactionsData is! List) return [];

      // Conversion des données en objets Transaction
      return transactionsData
          .whereType<Map<String, dynamic>>()
          .map((data) {
            try {
              return Transaction.fromJson(data);
            } catch (e) {
              debugPrint('Erreur de parsing pour la transaction: $e');
              debugPrint('Données problématiques: $data');
              return null;
            }
          })
          .whereType<Transaction>()
          .toList();

    } on HttpException {
      rethrow;
    } catch (e) {
      throw HttpException(
        statusCode: 500,
        message: 'Erreur inattendue: $e',
      );
    }
  }

  Future<bool> _verifyAuthToken() async {
    final token = _httpClient.getAuthToken();
    return token != null && token.isNotEmpty;
  }
  
}