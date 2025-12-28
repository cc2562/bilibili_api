/// User API - Get user information
library;

import '../core/http_client.dart';
import '../core/models.dart';
import 'user_models.dart';

/// Bilibili user information API
class UserApi {
  final BiliHttpClient client;

  UserApi(this.client);

  /// Get user detailed information
  /// 
  /// Reference: Bdocs/user/info.md
  /// API: https://api.bilibili.com/x/space/wbi/acc/info
  /// 
  /// Requires WBI signature
  /// [mid] - User ID
  Future<UserInfo> getUserInfo(int mid) async {
    const url = 'https://api.bilibili.com/x/space/wbi/acc/info';
    
    final response = await client.get<UserInfo>(
      url,
      params: {'mid': mid},
      useWbiSign: true,
      dataParser: (data) => UserInfo.fromJson(data as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to get user info: no data returned',
      );
    }

    return response.data!;
  }

  /// Get user card (simplified info)
  /// 
  /// Reference: Bdocs/user/info.md
  /// API: https://api.bilibili.com/x/web-interface/card
  /// 
  /// [mid] - User ID
  /// [photo] - Whether to include user space header image
  Future<UserCard> getUserCard(int mid, {bool photo = false}) async {
    const url = 'https://api.bilibili.com/x/web-interface/card';
    
    final response = await client.get<Map<String, dynamic>>(
      url,
      params: {
        'mid': mid,
        if (photo) 'photo': 'true',
      },
      dataParser: (data) => data as Map<String, dynamic>,
    );

    if (response.data == null || response.data!['card'] == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to get user card: no data returned',
      );
    }

    return UserCard.fromJson(response.data!['card'] as Map<String, dynamic>);
  }
}
