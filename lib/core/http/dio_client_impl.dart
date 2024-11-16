import 'package:dio/dio.dart';
import 'package:moneyflow/utils/api_url.dart';
import 'package:moneyflow/core/config/proxy_config.dart';
import 'http_client_interface.dart';
import 'http_exception.dart';

class DioClientImpl implements IHttpClient {
  final Dio _dio;
  String? _authToken;
  static const _timeout = Duration(seconds: 180);

  DioClientImpl() : _dio = _createDio();

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        connectTimeout: _timeout,
        receiveTimeout: _timeout,
        sendTimeout: _timeout,
        validateStatus: (status) => status != null && status < 500,
      ),
    );

    // Configure proxy
    if (ProxyConfig.useProxy) {
      ProxyConfig.configureProxy(dio);
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.path.isEmpty) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Endpoint cannot be empty',
              ),
            );
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (error, handler) {
          return handler.next(error);
        },
      ),
    );

    return dio;
  }

  Map<String, String> _prepareHeaders(Map<String, dynamic>? headers) {
    final Map<String, String> defaultHeaders = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_authToken != null) {
      defaultHeaders['Authorization'] = 'Bearer $_authToken';
    }

    if (headers != null) {
      defaultHeaders.addAll(Map<String, String>.from(headers));
    }

    return defaultHeaders;
  }

  @override
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await _dio.get(
        endpoint,
        options: Options(headers: _prepareHeaders(headers)),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> post(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: body,
        options: Options(headers: _prepareHeaders(headers)),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> put(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: body,
        options: Options(headers: _prepareHeaders(headers)),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint, {Map<String, String>? headers}) async {
    try {
      final response = await _dio.delete(
        endpoint,
        options: Options(headers: _prepareHeaders(headers)),
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  HttpException _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return HttpException(
        statusCode: 408,
        message: 'Request timeout',
      );
    }

    final response = error.response;
    if (response != null) {
      final data = response.data;
      final message = data is Map ? data['message'] ?? error.message : error.message;
      return HttpException(
        statusCode: response.statusCode ?? 500,
        message: message ?? 'Unknown error',
      );
    }

    return HttpException(
      statusCode: 500,
      message: error.message ?? 'Unknown error',
    );
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
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  @override
  void clearAuthToken() {
    _authToken = null;
    _dio.options.headers.remove('Authorization');
  }

  @override
  String? getAuthToken() {
    return _authToken;
  }

  void dispose() {
    _dio.close();
  }
}