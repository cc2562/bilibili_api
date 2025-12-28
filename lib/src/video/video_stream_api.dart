/// Video stream API - Get video playback URLs
library;

import '../core/http_client.dart';
import '../core/models.dart';
import 'video_stream_models.dart';

/// Bilibili video stream API
class VideoStreamApi {
  final BiliHttpClient client;

  VideoStreamApi(this.client);

  /// Get video stream URL  /// 
  /// Reference: Bdocs/video/videostream_url.md
  /// API: https://api.bilibili.com/x/player/wbi/playurl
  /// 
  /// Requires WBI signature
  /// For 720P and above, login (Cookie) is required
  /// For high frame rate/HDR/Dolby, VIP account is required
  /// 
  /// [bvid] or [aid] - Video ID
  /// [cid] - Video CID (required for multi-part videos)
  /// [qn] - Quality (default: 64 for 720P)
  /// [fnval] - Format flag (default: 16 for  DASH, 1 for MP4)
  /// [fourk] - Allow 4K (default: false)
  Future<VideoStreamUrl> getVideoStream({
    String? bvid,
    int? aid,
    required int cid,
    int qn = 64,
    int fnval = 16,
    bool fourk = false,
  }) async {
    if (bvid == null && aid == null) {
      throw ArgumentError('Either bvid or aid must be provided');
    }

    const url = 'https://api.bilibili.com/x/player/wbi/playurl';
    
    final params = <String, dynamic>{
      'cid': cid,
      'qn': qn,
      'fnval': fnval,
      'fnver': 0,
      if (fourk) 'fourk': 1,
    };

    if (bvid != null) {
      params['bvid'] = bvid;
    } else {
      params['avid'] = aid!;
    }

    final response = await client.get<VideoStreamUrl>(
      url,
      params: params,
      useWbiSign: true,
      dataParser: (data) =>
          VideoStreamUrl.fromJson(data as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to get video stream: no data returned',
      );
    }

    return response.data!;
  }

  /// Get video stream by bvid
  Future<VideoStreamUrl> getVideoStreamByBvid(
    String bvid,
    int cid, {
    int qn = 64,
    int fnval = 16,
    bool fourk = false,
  }) {
    return getVideoStream(
      bvid: bvid,
      cid: cid,
      qn: qn,
      fnval: fnval,
      fourk: fourk,
    );
  }

  /// Get video stream by aid
  Future<VideoStreamUrl> getVideoStreamByAid(
    int aid,
    int cid, {
    int qn = 64,
    int fnval = 16,
    bool fourk = false,
  }) {
    return getVideoStream(
      aid: aid,
      cid: cid,
      qn: qn,
      fnval: fnval,
      fourk: fourk,
    );
  }

  /// Get DASH format stream  /// Convenience method that sets fnval to get all DASH streams
  Future<VideoStreamUrl> getDashStream({
    String? bvid,
    int? aid,
    required int cid,
    int qn = 64,
    bool fourk = false,
  }) {
    return getVideoStream(
      bvid: bvid,
      aid: aid,
      cid: cid,
      qn: qn,
      fnval: 4048, // Request all available DASH streams
      fourk: fourk,
    );
  }

  /// Get MP4 format stream
  Future<VideoStreamUrl> getMp4Stream({
    String? bvid,
    int? aid,
    required int cid,
    int qn = 64,
  }) {
    return getVideoStream(
      bvid: bvid,
      aid: aid,
      cid: cid,
      qn: qn,
      fnval: 1, // MP4 format
      fourk: false,
    );
  }
}
