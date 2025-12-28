/// Cookie manager for handling Bilibili authentication cookies
library;

import 'dart:collection';

/// Manages Bilibili authentication cookies
class CookieManager {
  final Map<String, String> _cookies = {};

  /// Important cookie names
  static const String sessData = 'SESSDATA';
  static const String biliJct = 'bili_jct';
  static const String dedeUserId = 'DedeUserID';
  static const String dedeUserIdMd5 = 'DedeUserID__ckMd5';
  static const String sid = 'sid';

  /// Get a cookie by name
  String? getCookie(String name) {
    return _cookies[name];
  }

  /// Set a cookie
  void setCookie(String name, String value) {
    _cookies[name] = value;
  }

  /// Set multiple cookies
  void setCookies(Map<String, String> cookies) {
    _cookies.addAll(cookies);
  }

  /// Clear all cookies
  void clear() {
    _cookies.clear();
  }

  /// Check if authenticated (has SESSDATA)
  bool get isAuthenticated => _cookies.containsKey(sessData);

  /// Get all cookies as an unmodifiable map
  Map<String, String> get cookies => UnmodifiableMapView(_cookies);

  /// Convert cookies to Cookie header string
  String toCookieHeader() {
    return _cookies.entries
        .map((e) => '${e.key}=${e.value}')
        .join('; ');
  }

  /// Parse Set-Cookie headers and store cookies
  void parseSetCookieHeaders(List<String> setCookieHeaders) {
    for (final header in setCookieHeaders) {
      final parts = header.split(';');
      if (parts.isEmpty) continue;

      final cookiePair = parts[0].split('=');
      if (cookiePair.length == 2) {
        final name = cookiePair[0].trim();
        final value = cookiePair[1].trim();
        setCookie(name, value);
      }
    }
  }

  /// Serialize cookies to JSON
  Map<String, dynamic> toJson() {
    return Map<String, dynamic>.from(_cookies);
  }

  /// Create CookieManager from JSON
  static CookieManager fromJson(Map<String, dynamic> json) {
    final manager = CookieManager();
    manager.setCookies(json.map((key, value) => MapEntry(key, value.toString())));
    return manager;
  }

  @override
  String toString() {
    return 'CookieManager(cookies: ${_cookies.length}, authenticated: $isAuthenticated)';
  }
}
