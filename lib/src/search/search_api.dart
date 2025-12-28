/// Search API - Search for videos, users, and more
library;

import '../core/http_client.dart';
import '../core/models.dart';
import 'search_models.dart';

/// Bilibili search API
class SearchApi {
  final BiliHttpClient client;

  SearchApi(this.client);

  /// Comprehensive search (all types)
  /// 
  /// Reference: Bdocs/search/search_request.md
  /// API: https://api.bilibili.com/x/web-interface/wbi/search/all/v2
  /// 
  /// Requires WBI signature
  /// Returns 20 items with mixed types (videos, users, etc.)
  Future<BiliResponse<Map<String, dynamic>>> searchAll(
    String keyword,
  ) async {
    const url = 'https://api.bilibili.com/x/web-interface/wbi/search/all/v2';

    return await client.get<Map<String, dynamic>>(
      url,
      params: {'keyword': keyword},
      useWbiSign: true,
      dataParser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Search videos
  /// 
  /// Reference: Bdocs/search/search_request.md
  /// API: https://api.bilibili.com/x/web-interface/wbi/search/type
  /// 
  /// Requires WBI signature
  /// [keyword] - Search keyword
  /// [page] - Page number (default: 1)
  /// [order] - Sort order (default: totalrank)
  /// [duration] - Video duration filter (0: all, 1: <10min, 2: 10-30min, 3: 30-60min, 4: >60min)
  /// [tids] - Category filter (0: all categories)
  Future<List<VideoSearchResult>> searchVideos(
    String keyword, {
    int page = 1,
    SearchOrder order = SearchOrder.totalrank,
    int duration = 0,
    int tids = 0,
  }) async {
    const url = 'https://api.bilibili.com/x/web-interface/wbi/search/type';

    final response = await client.get<Map<String, dynamic>>(
      url,
      params: {
        'search_type': 'video',
        'keyword': keyword,
        'page': page,
        'order': order.value,
        'duration': duration,
        'tids': tids,
      },
      useWbiSign: true,
      dataParser: (data) => data as Map<String, dynamic>,
    );

    if (response.data == null || response.data!['result'] == null) {
      return [];
    }

    final results = response.data!['result'] as List;
    return results
        .map((e) => VideoSearchResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Search users
  /// 
  /// Reference: Bdocs/search/search_request.md
  /// API: https://api.bilibili.com/x/web-interface/wbi/search/type
  ///  
  /// Requires WBI signature
  /// [keyword] - Search keyword
  /// [page] - Page number (default: 1)
  /// [order] - Sort order (0: default, 'fans': by fans, 'level': by level)
  /// [orderSort] - Sort direction (0: desc, 1: asc)
  /// [userType] - User type filter (0: all, 1: UP主, 2: normal users, 3: verified)
  Future<List<UserSearchResult>> searchUsers(
    String keyword, {
    int page = 1,
    String order = '0',
    int orderSort = 0,
    int userType = 0,
  }) async {
    const url = 'https://api.bilibili.com/x/web-interface/wbi/search/type';

    final response = await client.get<Map<String, dynamic>>(
      url,
      params: {
        'search_type': 'bili_user',
        'keyword': keyword,
        'page': page,
        'order': order,
        'order_sort': orderSort,
        'user_type': userType,
      },
      useWbiSign: true,
      dataParser: (data) => data as Map<String, dynamic>,
    );

    if (response.data == null || response.data!['result'] == null) {
      return [];
    }

    final results = response.data!['result'] as List;
    return results
        .map((e) => UserSearchResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Generic type search
  /// 
  /// Reference: Bdocs/search/search_request.md
  /// API: https://api.bilibili.com/x/web-interface/wbi/search/type
  /// 
  /// Requires WBI signature
  /// [searchType] - Search type (video, bili_user, article, etc.)
  /// [keyword] - Search keyword
  /// [page] - Page number
  /// [extraParams] - Additional parameters based on search type
  Future<BiliResponse<Map<String, dynamic>>> searchByType(
    SearchType searchType,
    String keyword, {
    int page = 1,
    Map<String, dynamic>? extraParams,
  }) async {
    const url = 'https://api.bilibili.com/x/web-interface/wbi/search/type';

    final params = <String, dynamic>{
      'search_type': searchType.value,
      'keyword': keyword,
      'page': page,
    };

    if (extraParams != null) {
      params.addAll(extraParams);
    }

    return await client.get<Map<String, dynamic>>(
      url,
      params: params,
      useWbiSign: true,
      dataParser: (data) => data as Map<String, dynamic>,
    );
  }

  /// Get search suggestions
  /// 
  /// Reference: Bdocs/search/suggest.md
  /// API: https://s.search.bilibili.com/main/suggest
  /// 
  /// No authentication required
  /// Returns up to 10 suggested keywords
  /// Supports Chinese pinyin
  /// 
  /// [term] - Input text to get suggestions for
  Future<List<SearchSuggestion>> getSuggestions(String term) async {
    const url = 'https://s.search.bilibili.com/main/suggest';

    final response = await client.get<Map<String, dynamic>>(
      url,
      params: {
        'term': term,
        'main_ver': 'v1',
      },
      dataParser: (data) => data as Map<String, dynamic>,
      useWbiSign: false, // This API doesn't require WBI signing
    );

    if (response.data == null || response.data!['result'] == null) {
      return [];
    }

    final result = response.data!['result'] as Map<String, dynamic>;
    if (result['tag'] == null) {
      return [];
    }

    final suggestions = (result['tag'] as List)
        .map((e) => SearchSuggestion.fromJson(e as Map<String, dynamic>))
        .toList();

    return suggestions;
  }
}
