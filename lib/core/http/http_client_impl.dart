// lib/core/http/http_client_impl.dart
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:convert';
import 'package:moneyflow/utils/api_url.dart';
import 'package:moneyflow/core/config/proxy_config.dart';
import 'http_client_interface.dart';
import 'http_exception.dart';

class HttpClientImpl implements IHttpClient {
   final http.Client _client;
  String? _authToken;
  static const _timeout = Duration(seconds: 180);

  HttpClientImpl() : _client = _createClient();

  static http.Client _createClient() {
    if (!ProxyConfig.useProxy) {
      return http.Client();
    }

    final httpClient = HttpClient()
      ..findProxy = (uri) => ProxyConfig.useProxy ? 'PROXY ${ProxyConfig.proxyUrl}' : 'DIRECT';
      
    if (ProxyConfig.isDevMode) {
      httpClient.badCertificateCallback = (cert, host, port) => true;
    }
    
    return IOClient(httpClient);
  }

  Map<String, String> _prepareHeaders(Map<String, String>? headers) {
    final Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      defaultHeaders['Authorization'] = 'Bearer $_authToken';
    }

    if (headers != null) {
      defaultHeaders.addAll(headers);
    }

    return defaultHeaders;
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    if (endpoint.isEmpty) {
      throw HttpException(
        statusCode: 400,
        message: 'Endpoint cannot be empty',
      );
    }

    final url = Uri.parse('$apiUrl$endpoint');
    try {
      final response = await _client.get(
        url,
        headers: _prepareHeaders(headers),
      ).timeout(_timeout);
      return _handleResponse(response);
    } 
    on TimeoutException {
      throw HttpException(
        statusCode: 408,
        message: 'Request timeout',
      );
    } 
    catch (e) {
      throw HttpException(
        statusCode: 500,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    if (endpoint.isEmpty) {
      throw HttpException(
        statusCode: 400,
        message: 'Endpoint cannot be empty',
      );
    }

    final url = Uri.parse('$apiUrl$endpoint');
    try {
      final response = await _client.post(
        url,
        body: jsonEncode(body),
        headers: _prepareHeaders(headers),
      ).timeout(_timeout);
      return _handleResponse(response);
    } 
    on TimeoutException {
      throw HttpException(
        statusCode: 408,
        message: 'Request timeout',
      );
    } 
    catch (e) {
      throw HttpException(
        statusCode: 500,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> put(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    if (endpoint.isEmpty) {
      throw HttpException(
        statusCode: 400,
        message: 'Endpoint cannot be empty',
      );
    }

    final url = Uri.parse('$apiUrl$endpoint');
    try {
      final response = await _client.put(
        url,
        body: jsonEncode(body),
        headers: _prepareHeaders(headers),
      ).timeout(_timeout);
      return _handleResponse(response);
    } 
    on TimeoutException {
      throw HttpException(
        statusCode: 408,
        message: 'Request timeout',
      );
    } 
    catch (e) {
      throw HttpException(
        statusCode: 500,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, String>? headers}) async {
    if (endpoint.isEmpty) {
      throw HttpException(
        statusCode: 400,
        message: 'Endpoint cannot be empty',
      );
    }

    final url = Uri.parse('$apiUrl$endpoint');
    try {
      final response = await _client.delete(
        url,
        headers: _prepareHeaders(headers),
      ).timeout(_timeout);
      return _handleResponse(response);
    } 
    on TimeoutException {
      throw HttpException(
        statusCode: 408,
        message: 'Request timeout',
      );
    }
     catch (e) {
      throw HttpException(
        statusCode: 500,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    
    if (response.body.isEmpty) {
      if (statusCode >= 200 && statusCode < 300) {
        return null;
      } else {
        throw HttpException(
          statusCode: statusCode,
          message: 'Empty response with status code: $statusCode',
        );
      }
    }

    try {
      final body = jsonDecode(response.body);
      if (statusCode >= 200 && statusCode < 300) {
        return body;
      } else {
        final message = body is Map ? body['message'] ?? 'Unknown error' : 'Invalid response format';
        throw HttpException(
          statusCode: statusCode,
          message: message,
        );
      }
    } 
    on FormatException {
      throw HttpException(
        statusCode: statusCode,
        message: 'Invalid JSON response',
      );
    }
    catch (e) {
      throw HttpException(
        statusCode: statusCode,
        message: 'Connection error: ${e.toString()}',
      );
    }
  }

  @override
  void setAuthToken(String token) {
    if (token.isEmpty) {
      throw HttpException(
        statusCode: 400,
        message: 'Token cannot be empty',
      );
    }
    _authToken = token;
  }

  @override
  void clearAuthToken() {
    _authToken = null;
  }
  
  @override
  String? getAuthToken() {
    return _authToken;
  }

  void dispose() {
    _client.close();
  }
  
}
