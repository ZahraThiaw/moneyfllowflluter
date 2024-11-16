// lib/core/config/proxy_config.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class ProxyConfig {
  static bool useProxy = false; // Default to false for production
  static bool isDevMode = false; // Default to false for production
  static String proxyUrl = 'https://mycashjava.onrender.com';
  
  static void configureProxy(Dio dio) {
    if (useProxy) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.findProxy = (uri) => 'PROXY $proxyUrl';
        // Only enable in development mode
        client.badCertificateCallback = isDevMode ? (_, __, ___) => true : null;
        return client;
      };
    }
  }
}