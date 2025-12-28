/// Video action API - Like, coin, favorite operations
library;

import '../core/http_client.dart';
import '../core/models.dart';

/// Bilibili video action API
class VideoActionApi {
  final BiliHttpClient client;

  VideoActionApi(this.client);

  /// Like a video  ///
  /// Reference: Bdocs/video/action.md
  /// API: https://api.bilibili.com/x/web-interface/archive/like
  /// 
  /// Requires login (Cookie: SESSDATA, bili_jct)
  /// [like] - 1: like, 2: unlike
  Future<void> likeVideo({
    String? bvid,
    int? aid,
    required int like,
  }) async {
    if (bvid == null && aid == null) {
      throw ArgumentError('Either bvid or aid must be provided');
    }
    if (like != 1 && like != 2) {
      throw ArgumentError('like must be 1 (like) or 2 (unlike)');
    }

    const url = 'https://api.bilibili.com/x/web-interface/archive/like';

    final biliJct = client.cookieManager.getCookie('bili_jct');
    if (biliJct == null) {
      throw BiliException(
        code: -111,
        message: 'CSRF token (bili_jct) not found',
      );
    }

    final body = <String, dynamic>{
      'like': like,
      'csrf': biliJct,
    };

    if (bvid != null) {
      body['bvid'] = bvid;
    } else {
      body['aid'] = aid!;
    }

    await client.post(url, body: body);
  }

  /// Coin a video (投币)
  /// 
  /// Reference: Bdocs/video/action.md
  /// API: https://api.bilibili.com/x/web-interface/coin/add
  /// 
  /// Requires login (Cookie: SESSDATA, bili_jct)
  /// [multiply] - Number of coins (1 or 2)
  /// [selectLike] - Also like the video (default: false)
  /// 
  /// Returns whether the like operation succeeded
  Future<bool> coinVideo({
    String? bvid,
    int? aid,
    required int multiply,
    bool selectLike = false,
  }) async {
    if (bvid == null && aid == null) {
      throw ArgumentError('Either bvid or aid must be provided');
    }
    if (multiply < 1 || multiply > 2) {
      throw ArgumentError('multiply must be 1 or 2');
    }

    const url = 'https://api.bilibili.com/x/web-interface/coin/add';

    final biliJct = client.cookieManager.getCookie('bili_jct');
    if (biliJct == null) {
      throw BiliException(
        code: -111,
        message: 'CSRF token (bili_jct) not found',
      );
    }

    final body = <String, dynamic>{
      'multiply': multiply,
      'select_like': selectLike ? 1 : 0,
      'csrf': biliJct,
    };

    if (bvid != null) {
      body['bvid'] = bvid;
    } else {
      body['aid'] = aid!;
    }

    final response = await client.post<Map<String, dynamic>>(
      url,
      body: body,
      dataParser: (data) => data as Map<String, dynamic>,
    );

    return response.data?['like'] as bool? ?? false;
  }

  /// Favorite a video (收藏)
  /// 
  /// Reference: Bdocs/video/action.md
  /// API: https://api.bilibili.com/x/v3/fav/resource/deal
  /// 
  /// Requires login (Cookie: SESSDATA, bili_jct)
  /// [aid] - Video aid (note: bvid not supported for this API)
  /// [addMediaIds] - Favorite folder IDs to add (comma-separated)
  /// [delMediaIds] - Favorite folder IDs to remove (comma-separated)
  Future<void> favoriteVideo({
    required int aid,
    String? addMediaIds,
    String? delMediaIds,
  }) async {
    if (addMediaIds == null && delMediaIds == null) {
      throw ArgumentError(
          'Either addMediaIds or delMediaIds must be provided');
    }

    const url = 'https://api.bilibili.com/x/v3/fav/resource/deal';

    final biliJct = client.cookieManager.getCookie('bili_jct');
    if (biliJct == null) {
      throw BiliException(
        code: -111,
        message: 'CSRF token (bili_jct) not found',
      );
    }

    final body = <String, dynamic>{
      'rid': aid,
      'type': 2,
      'csrf': biliJct,
      if (addMediaIds != null) 'add_media_ids': addMediaIds,
      if (delMediaIds != null) 'del_media_ids': delMediaIds,
    };

    await client.post(url, body: body);
  }

  /// Triple combo (一键三连): like + coin + favorite
  /// 
  /// Reference: Bdocs/video/action.md
  /// API: https://api.bilibili.com/x/web-interface/archive/like/triple
  /// 
  /// Automatically likes, coins (2), and favorites video to default folder
  /// Requires login (Cookie: SESSDATA, bili_jct)
  /// 
  /// Returns status of each action
  Future<TripleActionResult> tripleAction({
    String? bvid,
    int? aid,
  }) async {
    if (bvid == null && aid == null) {
      throw ArgumentError('Either bvid or aid must be provided');
    }

    const url = 'https://api.bilibili.com/x/web-interface/archive/like/triple';

    final biliJct = client.cookieManager.getCookie('bili_jct');
    if (biliJct == null) {
      throw BiliException(
        code: -111,
        message: 'CSRF token (bili_jct) not found',
      );
    }

    final body = <String, dynamic>{
      'csrf': biliJct,
    };

    if (bvid != null) {
      body['bvid'] = bvid;
    } else {
      body['aid'] = aid!;
    }

    final response = await client.post<Map<String, dynamic>>(
      url,
      body: body,
      dataParser: (data) => data as Map<String, dynamic>,
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to triple action: no data returned',
      );
    }

    return TripleActionResult.fromJson(response.data!);
  }
}

/// Triple action result
class TripleActionResult {
  final bool like;
  final bool coin;
  final bool fav;
  final int multiply;

  TripleActionResult({
    required this.like,
    required this.coin,
    required this.fav,
    required this.multiply,
  });

  factory TripleActionResult.fromJson(Map<String, dynamic> json) {
    return TripleActionResult(
      like: json['like'] as bool,
      coin: json['coin'] as bool,
      fav: json['fav'] as bool,
      multiply: json['multiply'] as int,
    );
  }
}
