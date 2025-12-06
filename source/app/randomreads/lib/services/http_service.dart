import 'package:http/http.dart' as http;
import 'dart:math';

class HttpService {
  static const int defaultMaxRetries = 3;
  static const Duration baseDelay = Duration(milliseconds: 1000);
  static const Map<String, String> defaultHeaders = {
    "Content-Type": "application/json; charset=UTF-8",
  };

  /// Performs an HTTP GET request to the given [url] with optional [headers].
  /// Retries up to [maxRetries] times on failure (non-200 status or exceptions)
  /// using exponential backoff.
  /// Throws an [Exception] if all retries fail.
  static Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    int maxRetries = defaultMaxRetries,
  }) async {
    Exception? lastException;
    http.Response? lastResponse;

    for (int attempt = 1; attempt <= maxRetries + 1; attempt++) {
      try {
        final response = await http.get(
          Uri.parse(url),
          headers: headers ?? defaultHeaders,
        );
        lastResponse = response;

        if (response.statusCode == 200) {
          return response;
        } else {
          lastException = Exception('HTTP ${response.statusCode}: ${response.body}');
        }
      } catch (e) {
        lastException = Exception('Request failed on attempt $attempt: $e');
      }

      if (attempt < maxRetries + 1) {
        // Exponential backoff: 1s, 2s, 4s, etc.
        final multiplier = pow(2, attempt - 1).toInt();
        final delay = baseDelay * multiplier;
        await Future.delayed(delay);
      }
    }

    // If we reach here, all attempts failed
    throw lastException ?? Exception('Unknown failure after $maxRetries retries');
  }
}