/// Video API - Get video information
library;

import '../core/http_client.dart';
import '../core/models.dart';
import 'video_models.dart';

/// Bilibili video information API
class VideoApi {
  final BiliHttpClient client;

  VideoApi(this.client);

  /// Get video detailed information
  /// 
  /// Reference: Bdocs/video/info.md
  /// API: https://api.bilibili.com/x/web-interface/view
  /// 
  /// Either [bvid] or [aid] must be provided
  Future<VideoInfo> getVideoInfo({
    String? bvid,
    int? aid,
  }) async {
    if (bvid == null && aid == null) {
      throw ArgumentError('Either bvid or aid must be provided');
    }

    const url = 'https://api.bilibili.com/x/web-interface/view';
    
    final params = <String, dynamic>{};
    if (bvid != null) {
      params['bvid'] = bvid;
    } else {
      params['aid'] = aid!;
    }

    final response = await client.get<VideoInfo>(
      url,
      params: params,
      dataParser: (data) => VideoInfo.fromJson(data as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to get video info: no data returned',
      );
    }

    return response.data!;
  }

  /// Get video info by bvid
  Future<VideoInfo> getVideoInfoByBvid(String bvid) {
    return getVideoInfo(bvid: bvid);
  }

  /// Get video info by aid
  Future<VideoInfo> getVideoInfoByAid(int aid) {
    return getVideoInfo(aid: aid);
  }
}
