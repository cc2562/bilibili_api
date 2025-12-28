/// Example: Video Stream and Actions
/// 
/// This example demonstrates how to get video stream URLs and perform actions
/// Run this with: flutter run example/video_stream_example.dart

import 'package:bilibili_api/bilibili_api.dart';

void main() async {
  // Create HTTP client
  final client = BiliHttpClient();
  final videoApi = VideoApi(client);
  final streamApi = VideoStreamApi(client);
  final actionApi = VideoActionApi(client);
  final loginInfoApi = LoginInfoApi(client);

  try {
    print('=== Bilibili Video Stream & Actions Example ===\n');

    // Step 1: Refresh WBI keys
    print('Step 1: Refreshing WBI keys...');
    await loginInfoApi.refreshWbiKeys();
    print('✅ WBI keys updated\n');

    // Step 2: Get video info
    const bvid = 'BV1xx411c79H'; // Famous video av1
    print('Step 2: Getting video info for $bvid...');
    final videoInfo = await videoApi.getVideoInfoByBvid(bvid);
    
    print('\n=== Video Information ===');
    print('Title: ${videoInfo.title}');
    print('BVid: ${videoInfo.bvid}');
    print('UP主: ${videoInfo.owner.name}');
    print('Views: ${formatNumber(videoInfo.stat.view)}');
    print('Parts: ${videoInfo.pages.length}');

    // Step 3: Get video stream URL
    if (videoInfo.pages.isNotEmpty) {
      final firstPage = videoInfo.pages[0];
      print('\n\nStep 3: Getting stream URL for P1 (cid: ${firstPage.cid})...');
      
      try {
        final stream = await streamApi.getVideoStreamByBvid(
          bvid,
          firstPage.cid,
          qn: 64, // 720P
          fnval: 16, // DASH format
        );

        print('\n=== Stream Information ===');
        print('Quality: ${stream.quality}');
        print('Format: ${stream.format}');
        print('Duration: ${formatDuration(stream.timelength ~/ 1000)}');
        print('Available qualities: ${stream.acceptDescription.join(", ")}');

        if (stream.isDash) {
          print('\nDASH Format:');
          print('Video streams: ${stream.dash!.video.length}');
          if (stream.dash!.audio != null) {
            print('Audio streams: ${stream.dash!.audio!.length}');
          }
          
          // Show first video stream
          if (stream.dash!.video.isNotEmpty) {
            final firstVideo = stream.dash!.video[0];
            print('\nFirst video stream:');
            print('  Quality ID: ${firstVideo.id}');
            print('  Codec: ${firstVideo.codecs}');
            print('  Resolution: ${firstVideo.width}x${firstVideo.height}');
            print('  Frame rate: ${firstVideo.frameRate}');
            print('  URL: ${firstVideo.baseUrl.substring(0, 80)}...');
          }
        } else if (stream.isMp4) {
          print('\nMP4 Format:');
          print('Segments: ${stream.durl!.length}');
          if (stream.durl!.isNotEmpty) {
            final firstSegment = stream.durl![0];
            print('  Size: ${(firstSegment.size / 1024 / 1024).toStringAsFixed(2)} MB');
            print('  URL: ${firstSegment.url.substring(0, 80)}...');
          }
        }

        print('\n✅ Stream URL retrieved successfully!');
      } catch (e) {
        print('ℹ️ Note: Getting stream URL might require login for this video');
        print('Error: $e');
      }
    }

    // Step 4: Video actions (requires login)
    print('\n\nStep 4: Video Actions Demo');
    print('ℹ️ Note: Video actions require login (SESSDATA cookie)');
    
    if (client.cookieManager.isAuthenticated) {
      print('\n✅ Authenticated! You can perform actions like:');
      print('  - actionApi.likeVideo(bvid: bvid, like: 1)');
      print('  - actionApi.coinVideo(bvid: bvid, multiply: 2)');
      print('  - actionApi.favoriteVideo(aid: aid, addMediaIds: "...")');
      print('  - actionApi.tripleAction(bvid: bvid)');
    } else {
      print('\n❌ Not authenticated. Please login first to perform actions.');
      print('Run qr_login_example.dart to login.');
    }

  } on BiliException catch (e) {
    print('❌ Error: ${e.message} (code: ${e.code})');
  } catch (e) {
    print('❌ Unexpected error: $e');
  } finally {
    client.close();
  }
}

String formatDuration(int seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final secs = seconds % 60;
  
  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  } else {
    return '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }
}

String formatNumber(int number) {
  if (number >= 10000) {
    return '${(number / 10000).toStringAsFixed(1)}万';
  }
  return number.toString();
}
