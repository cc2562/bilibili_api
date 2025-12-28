/// HTTP client wrapper for Bilibili API
library;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cookie_manager.dart';
import 'models.dart';
import 'wbi_signer.dart';

/// HTTP client for Bilibili API requests
class BiliHttpClient {
  final CookieManager cookieManager;
  final WbiSigner wbiSigner;
  final http.Client _client;

  static const String userAgent =
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
      '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36';
  static const String referer = 'https://www.bilibili.com/';

  BiliHttpClient({
    CookieManager? cookieManager,
    WbiSigner? wbiSigner,
    http.Client? client,
  })  : cookieManager = cookieManager ?? CookieManager(),
        wbiSigner = wbiSigner ?? WbiSigner(),
        _client = client ?? http.Client();

  /// Build common headers
  Map<String, String> _buildHeaders({bool includeCookie = true}) {
    final headers = {
      'User-Agent': userAgent,
      'Referer': referer,
    };

    if (includeCookie && cookieManager.isAuthenticated) {
      headers['Cookie'] = cookieManager.toCookieHeader();
    }

    return headers;
  }

  /// Parse response and handle errors
  BiliResponse<T> _parseResponse<T>(
    http.Response response,
    T Function(dynamic)? dataParser,
  ) {
    // Parse Set-Cookie headers if present
    final setCookieHeaders = response.headers['set-cookie'];
    if (setCookieHeaders != null) {
      cookieManager.parseSetCookieHeaders([setCookieHeaders]);
    }

    // Parse JSON body
    final jsonBody = json.decode(response.body) as Map<String, dynamic>;
    final biliResponse = BiliResponse<T>.fromJson(jsonBody, dataParser);

    // Throw exception if API returned error
    if (!biliResponse.isSuccess) {
      throw BiliException(
        code: biliResponse.code,
        message: biliResponse.message,
      );
    }

    return biliResponse;
  }

  /// Perform GET request
  Future<BiliResponse<T>> get<T>(
    String url, {
    Map<String, dynamic>? params,
    T Function(dynamic)? dataParser,
    bool useWbiSign = false,
  }) async {
    try {
      // Apply WBI signature if needed
      Map<String, String> queryParams = {};
      if (params != null) {
        if (useWbiSign) {
          queryParams = wbiSigner.signParams(params);
        } else {
          queryParams = params.map((k, v) => MapEntry(k, v.toString()));
        }
      }

      // Build URL with query parameters
      final uri = Uri.parse(url).replace(queryParameters: queryParams);

      final response = await _client.get(
        uri,
        headers: _buildHeaders(),
      );

      return _parseResponse<T>(response, dataParser);
    } on BiliException {
      rethrow;
    } catch (e) {
      throw BiliException(
        code: -1,
        message: 'Request failed: $e',
        originalError: e,
      );
    }
  }

  /// Perform POST request
  Future<BiliResponse<T>> post<T>(
    String url, {
    Map<String, dynamic>? body,
    T Function(dynamic)? dataParser,
  }) async {
    try {
      final response = await _client.post(
        Uri.parse(url),
        headers: {
          ..._buildHeaders(),
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body?.map((k, v) => MapEntry(k, v.toString())),
      );

      return _parseResponse<T>(response, dataParser);
    } on BiliException {
      rethrow;
    } catch (e) {
      throw BiliException(
        code: -1,
        message: 'Request failed: $e',
        originalError: e,
      );
    }
  }

  /// Close the client
  void close() {
    _client.close();
  }
}
