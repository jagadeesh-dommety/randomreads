import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:randomreads/services/auth_storage_service.dart';

class HttpService {
  static const int defaultMaxRetries = 1;
  static const Duration baseDelay = Duration(milliseconds: 1000);

  static const Map<String, String> _defaultHeaders = {
    "Content-Type": "application/json; charset=UTF-8",
  };

  /* ------------------------- PUBLIC METHODS ------------------------- */

  static Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    bool authRequired = true,
    int maxRetries = defaultMaxRetries,
  }) {
    return _request(
      method: _HttpMethod.get,
      url: url,
      headers: headers,
      authRequired: authRequired,
      maxRetries: maxRetries,
    );
  }

  static Future<http.Response> post(
    String url, {
    String? body,
    Map<String, String>? headers,
    bool authRequired = true,
    int maxRetries = defaultMaxRetries,
  }) {
    return _request(
      method: _HttpMethod.post,
      url: url,
      body: body,
      headers: headers,
      authRequired: authRequired,
      maxRetries: maxRetries,
    );
  }

  /* ------------------------- CORE REQUEST HANDLER ------------------------- */

  static Future<http.Response> _request({
    required _HttpMethod method,
    required String url,
    String? body,
    Map<String, String>? headers,
    required bool authRequired,
    required int maxRetries,
  }) async {
    Exception? lastException;

    final requestHeaders =
        await _buildHeaders(headers, authRequired: authRequired);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final response = await _execute(
          method: method,
          url: url,
          body: body,
          headers: requestHeaders,
        );

        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }

        lastException = Exception(
          'HTTP ${response.statusCode}: ${response.body}',
        );
      } catch (e) {
        lastException = Exception(
          'Request failed on attempt $attempt: $e',
        );
      }

      if (attempt <= maxRetries) {
        await Future.delayed(_calculateBackoff(attempt));
      }
    }

    throw lastException ??
        Exception('Request failed after $maxRetries retries');
  }

  /* ------------------------- HELPERS ------------------------- */

  static Future<Map<String, String>> _buildHeaders(
    Map<String, String>? headers, {
    required bool authRequired,
  }) async {
    final result = <String, String>{
      ..._defaultHeaders,
      ...?headers,
    };

    if (authRequired) {
      final token = await AuthStorageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        result['Authorization'] = 'Bearer $token';
      }
    }

    return result;
  }

  static Future<http.Response> _execute({
    required _HttpMethod method,
    required String url,
    String? body,
    required Map<String, String> headers,
  }) {
    final uri = Uri.parse(url);

    switch (method) {
      case _HttpMethod.get:
        return http.get(uri, headers: headers);
      case _HttpMethod.post:
        return http.post(uri, headers: headers, body: body);
    }
  }

  static Duration _calculateBackoff(int attempt) {
    final multiplier = pow(2, attempt - 1).toInt();
    return baseDelay * multiplier;
  }
}

/* ------------------------- ENUM ------------------------- */

enum _HttpMethod { get, post }
