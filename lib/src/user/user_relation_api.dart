/// User relation API - Followers and following lists
library;

import '../core/http_client.dart';
import '../core/models.dart';
import 'user_relation_models.dart';

/// Bilibili user relation API
class UserRelationApi {
  final BiliHttpClient client;

  UserRelationApi(this.client);

  /// Get user's followers list
  /// 
  /// Reference: Bdocs/user/relation.md
  /// API: https://api.bilibili.com/x/relation/fans
  /// 
  /// Requires login (Cookie: SESSDATA)
  /// Requires referer from bilibili.com subdomain
  /// 
  /// **Limitations:**
  /// - Self: Returns top 1000 followers
  /// - Others: Returns top 100 followers
  /// - With `from=main` for self: Smart recommendation, no mtime field
  /// 
  /// [vmid] - Target user mid
  /// [ps] - Page size (default: 50)
  /// [pn] - Page number (default: 1, ignored if offset is provided)
  /// [offset] - Offset from previous response's `data.offset`
  /// [lastAccessTs] - Last access timestamp (for smart recommendation)
  /// [from] - Request source ('main' for smart recommendation when vmid is self)
  Future<FollowersList> getFollowers(
    int vmid, {
    int ps = 50,
    int pn = 1,
    String? offset,
    int? lastAccessTs,
    String? from,
  }) async {
    const url = 'https://api.bilibili.com/x/relation/fans';

    final params = <String, dynamic>{
      'vmid': vmid,
      'ps': ps,
      'pn': pn,
    };

    if (offset != null) params['offset'] = offset;
    if (lastAccessTs != null) params['last_access_ts'] = lastAccessTs;
    if (from != null) params['from'] = from;

    final response = await client.get<FollowersList>(
      url,
      params: params,
      dataParser: (data) => FollowersList.fromJson(data as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to get followers: no data returned',
      );
    }

    return response.data!;
  }

  /// Get user's following list
  /// 
  /// Reference: Bdocs/user/relation.md
  /// API: https://api.bilibili.com/x/relation/followings
  /// 
  /// Requires login (Cookie: SESSDATA)
  /// Requires referer from bilibili.com subdomain
  /// 
  /// **Limitations:**
  /// - Self: Can see all followings
  /// - Others: Can only see top 100 followings
  /// 
  /// [vmid] - Target user mid
  /// [ps] - Page size (default: 50)
  /// [pn] - Page number (default: 1)
  /// [orderType] - Sort order (empty: by follow time, 'attention': by most visited)
  ///               Only effective when vmid is self
  Future<FollowingsList> getFollowings(
    int vmid, {
    int ps = 50,
    int pn = 1,
    String? orderType,
  }) async {
    const url = 'https://api.bilibili.com/x/relation/followings';

    final params = <String, dynamic>{
      'vmid': vmid,
      'ps': ps,
      'pn': pn,
    };

    if (orderType != null) params['order_type'] = orderType;

    final response = await client.get<FollowingsList>(
      url,
      params: params,
      dataParser: (data) => FollowingsList.fromJson(data as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to get followings: no data returned',
      );
    }

    return response.data!;
  }

  /// Get user's followers with pagination support
  /// 
  /// This will automatically handle offset for you
  Future<List<RelationUser>> getAllFollowers(
    int vmid, {
    int maxPages = 20,
    int ps = 50,
  }) async {
    final List<RelationUser> allFollowers = [];
    String? offset;
    int currentPage = 0;

    while (currentPage < maxPages) {
      final result = await getFollowers(
        vmid,
        ps: ps,
        offset: offset,
      );

      allFollowers.addAll(result.list);

      if (result.list.isEmpty || result.offset == null) {
        break;
      }

      offset = result.offset;
      currentPage++;
    }

    return allFollowers;
  }

  /// Get user's followings with pagination support
  Future<List<RelationUser>> getAllFollowings(
    int vmid, {
    int maxPages = 20,
    int ps = 50,
    String? orderType,
  }) async {
    final List<RelationUser> allFollowings = [];
    int currentPage = 1;

    while (currentPage <= maxPages) {
      final result = await getFollowings(
        vmid,
        ps: ps,
        pn: currentPage,
        orderType: orderType,
      );

      allFollowings.addAll(result.list);

      if (result.list.isEmpty || result.list.length < ps) {
        break;
      }

      currentPage++;
    }

    return allFollowings;
  }
}
