/// Common data models for Bilibili API
library;

/// Generic API response wrapper
class BiliResponse<T> {
  final int code;
  final String message;
  final int ttl;
  final T? data;

  BiliResponse({
    required this.code,
    required this.message,
    required this.ttl,
    this.data,
  });

  bool get isSuccess => code == 0;

  factory BiliResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? dataParser,
  ) {
    return BiliResponse<T>(
      code: json['code'] as int,
      message: json['message'] as String,
      ttl: json['ttl'] as int,
      data: json['data'] != null && dataParser != null
          ? dataParser(json['data'])
          : json['data'] as T?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'ttl': ttl,
      'data': data,
    };
  }
}

/// Custom exception for Bilibili API errors
class BiliException implements Exception {
  final int code;
  final String message;
  final dynamic originalError;

  BiliException({
    required this.code,
    required this.message,
    this.originalError,
  });

  @override
  String toString() {
    return 'BiliException(code: $code, message: $message)';
  }

  /// Common error codes
  static const int codeUnauthorized = -101;
  static const int codeBadRequest = -400;
  static const int codeForbidden = -403;
  static const int codeNotFound = -404;
}
