/// User space API - uploaded videos
library;

import '../core/http_client.dart';
import '../core/models.dart';
import 'user_space_models.dart';

/// Bilibili user space API
class UserSpaceApi {
  final BiliHttpClient client;

  UserSpaceApi(this.client);

  /// Get user's uploaded videos
  /// 
  /// Reference: Bdocs/user/space.md#查询用户投稿视频明细
  /// API: https://api.bilibili.com/x/space/wbi/arc/search
  /// 
  /// Requires WBI signature
  /// 
  /// [mid] - Target user mid
  /// [order] - Sort order (see UserVideoOrder)
  ///   - 'pubdate': Latest published (default)
  ///   - 'click': Most views
  ///   - 'stow': Most favorites
  /// [tid] - Filter by category (0 = no filter)
  /// [keyword] - Search keyword within user's videos
  /// [pn] - Page number (default: 1)
  /// [ps] - Items per page (default: 30)
  Future<UserUploadVideos> getUserVideos(
    int mid, {
    String order = UserVideoOrder.pubdate,
    int tid = 0,
    String? keyword,
    int pn = 1,
    int ps = 30,
  }) async {
    const url = 'https://api.bilibili.com/x/space/wbi/arc/search';

    final params = <String, dynamic>{
      'mid': mid,
      'order': order,
      'tid': tid,
      'pn': pn,
      'ps': ps,
    };

    if (keyword != null && keyword.isNotEmpty) {
      params['keyword'] = keyword;
    }

    final response = await client.get<UserUploadVideos>(
      url,
      params: params,
      useWbiSign: true,
      dataParser: (data) =>
          UserUploadVideos.fromJson(data as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to get user videos: no data returned',
      );
    }

    return response.data!;
  }

  /// Search user's uploaded videos
  /// 
  /// Convenience method for searching within a user's videos
  Future<UserUploadVideos> searchUserVideos(
    int mid,
    String keyword, {
    String order = UserVideoOrder.pubdate,
    int pn = 1,
    int ps = 30,
  }) async {
    return getUserVideos(
      mid,
      keyword: keyword,
      order: order,
      pn: pn,
      ps: ps,
    );
  }

  /// Get user videos by category
  /// 
  /// [mid] - Target user mid
  /// [tid] - Category tid (must be > 0)
  /// [order] - Sort order
  /// [pn] - Page number
  /// [ps] - Items per page
  Future<UserUploadVideos> getUserVideosByCategory(
    int mid,
    int tid, {
    String order = UserVideoOrder.pubdate,
    int pn = 1,
    int ps = 30,
  }) async {
    if (tid <= 0) {
      throw ArgumentError('tid must be greater than 0 for category filter');
    }

    return getUserVideos(
      mid,
      tid: tid,
      order: order,
      pn: pn,
      ps: ps,
    );
  }

  /// Get all user videos with pagination
  /// 
  /// Automatically fetches all pages up to [maxPages]
  Future<List<UploadedVideo>> getAllUserVideos(
    int mid, {
    String order = UserVideoOrder.pubdate,
    int maxPages = 100,
    int ps = 30,
  }) async {
    final List<UploadedVideo> allVideos = [];
    int currentPage = 1;

    while (currentPage <= maxPages) {
      final result = await getUserVideos(
        mid,
        order: order,
        pn: currentPage,
        ps: ps,
      );

      allVideos.addAll(result.videos);

      if (!result.pageInfo.hasNextPage || result.videos.isEmpty) {
        break;
      }

      currentPage++;
    }

    return allVideos;
  }
}
