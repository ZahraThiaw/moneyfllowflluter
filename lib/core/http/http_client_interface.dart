// lib/core/http/http_client_interface.dart
abstract class IHttpClient {
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers});
  Future<Map<String, dynamic>> post(String endpoint, dynamic body, {Map<String, String>? headers});
  Future<Map<String, dynamic>> put(String endpoint, dynamic body, {Map<String, String>? headers});
  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, String>? headers});
  void setAuthToken(String token);
  void clearAuthToken();
  String? getAuthToken();
}
