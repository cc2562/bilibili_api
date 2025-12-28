/// Example: Video Information Query
/// 
/// This example demonstrates how to get video information.
/// Run this with: flutter run example/video_info_example.dart

import 'package:bilibili_api/bilibili_api.dart';

void main() async {
  // Create HTTP client
  final client = BiliHttpClient();
  final videoApi = VideoApi(client);

  try {
    print('=== Bilibili Video Info Example ===\n');

    // Example 1: Get video by bvid
    const bvid = 'BV1xx411c79H'; // 著名的av1
    print('Example 1: Getting video info by bvid=$bvid...\n');
    
    var videoInfo = await videoApi.getVideoInfoByBvid(bvid);
    printVideoInfo(videoInfo);

    // Example 2: Get video by aid
    print('\n\n');
    const aid = 85440373; // BV117411r7R1
    print('Example 2: Getting video info by aid=$aid...\n');
    
    videoInfo = await videoApi.getVideoInfoByAid(aid);
    printVideoInfo(videoInfo);

    print('\n✅ All video info retrieved successfully!');
  } on BiliException catch (e) {
    print('❌ Error: ${e.message} (code: ${e.code})');
  } catch (e) {
    print('❌ Unexpected error: $e');
  } finally {
    client.close();
  }
}

void printVideoInfo(VideoInfo video) {
  print('=== Video Information ===');
  print('BVID: ${video.bvid}');
  print('AID: ${video.aid}');
  print('Title: ${video.title}');
  print('Type: ${video.isOriginal ? "Original" : "Repost"}');
  print('Category: ${video.tname} (tid: ${video.tid})');
  print('Duration: ${formatDuration(video.duration)}');
  print('Published: ${formatTimestamp(video.pubdate)}');
  print('Description: ${video.desc.substring(0, video.desc.length.clamp(0, 100))}...');

  print('\n=== UP主 Information ===');
  print('Name: ${video.owner.name}');
  print('Mid: ${video.owner.mid}');

  print('\n=== Statistics ===');
  print('Views: ${formatNumber(video.stat.view)}');
  print('Likes: ${formatNumber(video.stat.like)}');
  print('Coins: ${formatNumber(video.stat.coin)}');
  print('Favorites: ${formatNumber(video.stat.favorite)}');
  print('Shares: ${formatNumber(video.stat.share)}');
  print('Comments: ${formatNumber(video.stat.reply)}');
  print('Danmaku: ${formatNumber(video.stat.danmaku)}');

  print('\n=== Parts (${video.videos} total) ===');
  for (var i = 0; i < video.pages.length && i < 3; i++) {
    final page = video.pages[i];
    print('P${page.page}: ${page.part} (${formatDuration(page.duration)})');
  }
  if (video.pages.length > 3) {
    print('... and ${video.pages.length - 3} more parts');
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

String formatTimestamp(int timestamp) {
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String formatNumber(int number) {
  if (number >= 10000) {
    return '${(number / 10000).toStringAsFixed(1)}万';
  }
  return number.toString();
}
