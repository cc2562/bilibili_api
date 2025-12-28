/// Login info API - Get user login information
library;

import '../core/http_client.dart';
import '../core/models.dart';
import 'login_models.dart';

/// Bilibili login information API
class LoginInfoApi {
  final BiliHttpClient client;

  LoginInfoApi(this.client);

  /// Get navigation bar user info
  /// 
  /// Reference: Bdocs/login/login_info.md
  /// API: https://api.bilibili.com/x/web-interface/nav
  /// 
  /// Returns user info and WBI keys (wbi_img)
  /// Can be called without login (will return isLogin: false)
  Future<NavInfo> getNavInfo() async {
    const url = 'https://api.bilibili.com/x/web-interface/nav';
    
    try {
      final response = await client.get<NavInfo>(
        url,
        dataParser: (data) => NavInfo.fromJson(data as Map<String, dynamic>),
      );

      if (response.data == null) {
        throw BiliException(
          code: -1,
          message: 'Failed to get nav info: no data returned',
        );
      }

      // Update WBI keys if available
      final wbiImg = response.data!.wbiImg;
      if (wbiImg != null) {
        client.wbiSigner.updateKeys(wbiImg.imgUrl, wbiImg.subUrl);
      }

      return response.data!;
    } on BiliException catch (e) {
      // -101 means not logged in, which is acceptable
      if (e.code == BiliException.codeUnauthorized) {
        // Still try to parse the response for wbi_img
        rethrow;
      }
      rethrow;
    }
  }

  /// Get user status statistics
  /// 
  /// Reference: Bdocs/login/login_info.md
  /// API: https://api.bilibili.com/x/web-interface/nav/stat
  /// 
  /// Requires login (Cookie: SESSDATA)
  Future<NavStat> getNavStat() async {
    const url = 'https://api.bilibili.com/x/web-interface/nav/stat';
    
    final response = await client.get<NavStat>(
      url,
      dataParser: (data) => NavStat.fromJson(data as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to get nav stat: no data returned',
      );
    }

    return response.data!;
  }

  /// Refresh WBI keys from nav endpoint
  /// 
  /// This is a convenience method to update WBI signature keys
  Future<void> refreshWbiKeys() async {
    await getNavInfo();
  }
}
