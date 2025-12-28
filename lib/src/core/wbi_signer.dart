/// WBI signature implementation for Bilibili API
library;

import 'dart:convert';
import 'package:crypto/crypto.dart';

/// WBI signature generator for request authentication
class WbiSigner {
  String? _imgKey;
  String? _subKey;
  String? _mixinKey;
  DateTime? _lastUpdateTime;

  /// Mixin key encoding table for character reordering
  static const List<int> mixinKeyEncTab = [
    46, 47, 18, 2, 53, 8, 23, 32, 15, 50, 10, 31, 58, 3, 45, 35, 27, 43, 5, 49,
    33, 9, 42, 19, 29, 28, 14, 39, 12, 38, 41, 13, 37, 48, 7, 16, 24, 55, 40,
    61, 26, 17, 0, 1, 60, 51, 30, 4, 22, 25, 54, 21, 56, 59, 6, 63, 57, 62, 11,
    36, 20, 34, 44, 52
  ];

  /// Update WBI keys from API response
  void updateKeys(String imgUrl, String subUrl) {
    // Extract key from URL: https://i0.hdslb.com/bfs/wbi/7cd084941338484aae1ad9425b84077c.png
    _imgKey = imgUrl.split('/').last.split('.').first;
    _subKey = subUrl.split('/').last.split('.').first;
    _mixinKey = _generateMixinKey(_imgKey! + _subKey!);
    _lastUpdateTime = DateTime.now();
  }

  /// Check if keys need refresh (older than 1 hour)
  bool get needsRefresh {
    if (_lastUpdateTime == null) return true;
    return DateTime.now().difference(_lastUpdateTime!).inHours >= 1;
  }

  /// Generate mixin key from img_key and sub_key
  String _generateMixinKey(String rawKey) {
    final buffer = StringBuffer();
    for (int i = 0; i < 32; i++) {
      buffer.write(rawKey[mixinKeyEncTab[i]]);
    }
    return buffer.toString();
  }

  /// Sign request parameters
  /// Returns a new map with 'wts' and 'w_rid' added
  Map<String, String> signParams(Map<String, dynamic> params) {
    if (_mixinKey == null) {
      throw StateError('WBI keys not initialized. Call updateKeys first.');
    }

    // Create a copy and add timestamp
    final signedParams = <String, String>{};
    final wts = (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString();

    // Convert all params to strings and filter special characters
    for (final entry in params.entries) {
      final value = entry.value.toString();
      // Filter out !'()* characters as per specification
      final filtered = value.replaceAll(RegExp(r"[!'()*]"), '');
      signedParams[entry.key] = filtered;
    }

    signedParams['wts'] = wts;

    // Sort by key and build query string
    final sortedKeys = signedParams.keys.toList()..sort();
    final queryParts = <String>[];
    
    for (final key in sortedKeys) {
      final value = signedParams[key]!;
      final encodedKey = Uri.encodeComponent(key);
      final encodedValue = Uri.encodeComponent(value);
      queryParts.add('$encodedKey=$encodedValue');
    }

    final query = queryParts.join('&');

    // Calculate MD5 hash
    final toHash = query + _mixinKey!;
    final bytes = utf8.encode(toHash);
    final digest = md5.convert(bytes);
    final wRid = digest.toString();

    // Add w_rid to result
    signedParams['w_rid'] = wRid;

    return signedParams;
  }

  /// Get current mixin key (for debugging)
  String? get mixinKey => _mixinKey;

  @override
  String toString() {
    return 'WbiSigner(hasKeys: ${_mixinKey != null}, lastUpdate: $_lastUpdateTime)';
  }
}
