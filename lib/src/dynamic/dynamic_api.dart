/// Simplified dynamic feed API - Returns raw JSON data
library;

import '../core/http_client.dart';
import '../core/models.dart';

/// Bilibili dynamic feed API (Simplified)
/// 
/// This is a simplified implementation that returns raw JSON data.
/// Users can parse the specific fields they need from the response.
/// 
/// For full data structure reference, see:
/// - Bdocs/dynamic/all.md
/// - Bdocs/dynamic/space.md
class DynamicApi {
  final BiliHttpClient client;

  DynamicApi(this.client);

  /// Get all dynamic feed
  /// 
  /// Reference: Bdocs/dynamic/all.md
  /// API: https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/all
  /// 
  /// Requires login (Cookie: SESSDATA)
  /// 
  /// [type] - Feed type: 'all' (default), 'video', 'pgc', 'article'
  /// [offset] - Pagination offset (from previous response's offset field)
  /// [updateBaseline] - Update baseline for getting new dynamics
  /// 
  /// Returns raw JSON Map with structure:
  /// - has_more: bool
  /// - items: array of dynamic items
  /// - offset: string (for next page)
  /// - update_baseline: string
  /// - update_num: int
  Future<Map<String, dynamic>> getAllDynamics({
    String type = 'all',
    String? offset,
    String? updateBaseline,
  }) async {
    const url = 'https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/all';

    final params = <String, dynamic>{
      'type': type,
    };

    if (offset != null) params['offset'] = offset;
    if (updateBaseline != null) params['update_baseline'] = updateBaseline;

    final response = await client.get<Map<String, dynamic>>(
      url,
      params: params,
      dataParser: (data) => data as Map<String, dynamic>,
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to get dynamics: no data returned',
      );
    }

    return response.data!;
  }

  /// Get user space dynamics
  /// 
  /// Reference: Bdocs/dynamic/space.md
  /// API: https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/space
  /// 
  /// Can work without login (with WBI signature) or with login (Cookie)
  /// 
  /// [hostMid] - Target user mid
  /// [offset] - Pagination offset
  /// [useWbiSign] - Whether to use WBI signature (for unauthenticated requests)
  /// 
  /// Returns raw JSON Map with same structure as getAllDynamics
  Future<Map<String, dynamic>> getUserSpaceDynamics(
    int hostMid, {
    String? offset,
    bool useWbiSign = false,
  }) async {
    const url = 'https://api.bilibili.com/x/polymer/web-dynamic/v1/feed/space';

    final params = <String, dynamic>{
      'host_mid': hostMid,
    };

    if (offset != null) params['offset'] = offset;

    final response = await client.get<Map<String, dynamic>>(
      url,
      params: params,
      useWbiSign: useWbiSign,
      dataParser: (data) => data as Map<String, dynamic>,
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to get user space dynamics: no data returned',
      );
    }

    return response.data!;
  }

  /// Get dynamic detail by ID
  /// 
  /// Reference: Bdocs/dynamic/get_dynamic_detail.md
  /// API: https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail
  /// 
  /// [dynamicId] - Dynamic ID
  /// 
  /// Returns raw JSON Map with dynamic card information
  Future<Map<String, dynamic>> getDynamicDetail(String dynamicId) async {
    const url = 'https://api.vc.bilibili.com/dynamic_svr/v1/dynamic_svr/get_dynamic_detail';

    final params = <String, dynamic>{
      'dynamic_id': dynamicId,
    };

    final response = await client.get<Map<String, dynamic>>(
      url,
      params: params,
      dataParser: (data) => data as Map<String, dynamic>,
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to get dynamic detail: no data returned',
      );
    }

    return response.data!;
  }

  /// Helper: Extract common fields from dynamic items
  /// 
  /// This helper extracts frequently used fields from a dynamic item.
  /// Returns null if the field doesn't exist.
  static Map<String, dynamic>? extractBasicInfo(Map<String, dynamic> item) {
    try {
      final modules = item['modules'] as Map<String, dynamic>?;
      if (modules == null) return null;

      final author = modules['module_author'] as Map<String, dynamic>?;
      final dynamicModule = modules['module_dynamic'] as Map<String, dynamic>?;
      final stat = modules['module_stat'] as Map<String, dynamic>?;

      return {
        'id_str': item['id_str'],
        'type': item['type'],
        'author_mid': author?['mid'],
        'author_name': author?['name'],
        'author_face': author?['face'],
        'pub_time': author?['pub_time'],
        'pub_ts': author?['pub_ts'],
        'like_count': stat?['like']?['count'],
        'comment_count': stat?['comment']?['count'],
        'forward_count': stat?['forward']?['count'],
        'has_major': dynamicModule?['major'] != null,
        'major_type': dynamicModule?['major']?['type'],
      };
    } catch (e) {
      return null;
    }
  }
}
