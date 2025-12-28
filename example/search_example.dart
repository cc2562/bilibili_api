/// Example: Search
/// 
/// This example demonstrates how to search for videos and users
/// Run this with: flutter run example/search_example.dart

import 'package:bilibili_api/bilibili_api.dart';

void main() async {
  // Create HTTP client
  final client = BiliHttpClient();
  final searchApi = SearchApi(client);
  final loginInfoApi = LoginInfoApi(client);

  try {
    print('=== Bilibili Search Example ===\n');

    // Step 1: Refresh WBI keys (required for search)
    print('Step 1: Refreshing WBI keys...');
    await loginInfoApi.refreshWbiKeys();
    print('✅ WBI keys updated\n');

    // Step 2: Search videos
    const keyword = '洛天依';
    print('Step 2: Searching videos for "$keyword"...\n');
    
    final videoResults = await searchApi.searchVideos(
      keyword,
      page: 1,
      order: SearchOrder.totalrank,
    );

    print('=== Video Search Results (${videoResults.length} items) ===');
    for (var i = 0; i < videoResults.length && i < 5; i++) {
      final video = videoResults[i];
      print('\n${i + 1}. ${video.title}');
      print('   BVid: ${video.bvid}');
      print('   UP主: ${video.author}');
      print('   Views: ${formatNumber(video.play)}');
      print('   Favorites: ${formatNumber(video.favorites)}');
      print('   URL: ${video.arcurl}');
    }
    
    if (videoResults.length > 5) {
      print('\n... and ${videoResults.length - 5} more results');
    }

    // Step 3: Search users
    print('\n\nStep 3: Searching users for "$keyword"...\n');
    
    final userResults = await searchApi.searchUsers(
      keyword,
      page: 1,
      order: 'fans', // Sort by fans
    );

    print('=== User Search Results (${userResults.length} items) ===');
    for (var i = 0; i < userResults.length && i < 5; i++) {
      final user = userResults[i];
      print('\n${i + 1}. ${user.uname}');
      print('   Mid: ${user.mid}');
      print('   Level: ${user.level}');
      print('   Fans: ${formatNumber(user.fans)}');
      print('   Videos: ${user.videos}');
      print('   Sign: ${user.usign.substring(0, user.usign.length.clamp(0, 50))}${user.usign.length > 50 ? "..." : ""}');
    }

    if (userResults.length > 5) {
      print('\n... and ${userResults.length - 5} more results');
    }

    // Step 4: Comprehensive search
    print('\n\nStep 4: Comprehensive search for "$keyword"...');
    
    final allResults = await searchApi.searchAll(keyword);
    
    print('\n=== Comprehensive Search Results ===');
    print('Response contains mixed results (videos, users, etc.)');
    print('Total result types: ${allResults.data?['result']?.length ?? 0}');
    
    if (allResults.data?['top_tlist'] != null) {
      final topList = allResults.data!['top_tlist'] as Map<String, dynamic>;
      print('\nResult counts by type:');
      topList.forEach((key, value) {
        if (value > 0) {
          print('  $key: $value');
        }
      });
    }

    print('\n✅ All searches completed successfully!');
    
    print('\n\nℹ️ Note: Search APIs require WBI signature and cookies.');
    print('If you encounter -412 error, try visiting https://bilibili.com first.');

  } on BiliException catch (e) {
    print('❌ Error: ${e.message} (code: ${e.code})');
    if (e.code == -412) {
      print('\nℹ️ Search was blocked. This might be due to:');
      print('  1. Missing or invalid cookies');
      print('  2. Too many requests');
      print('  3. Need to visit bilibili.com first to get cookies');
    }
  } catch (e) {
    print('❌ Unexpected error: $e');
  } finally {
    client.close();
  }
}

String formatNumber(int number) {
  if (number >= 10000) {
    return '${(number / 10000).toStringAsFixed(1)}万';
  }
  return number.toString();
}
