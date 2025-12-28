/// Example: User Information Query
/// 
/// This example demonstrates how to get user information with WBI signature.
/// Run this with: flutter run example/user_info_example.dart

import 'package:bilibili_api/bilibili_api.dart';

void main() async {
  // Create HTTP client
  final client = BiliHttpClient();
  final userApi = UserApi(client);
  final loginInfoApi = LoginInfoApi(client);

  try {
    print('=== Bilibili User Info Example ===\n');

    // Step 1: Refresh WBI keys (required for signed requests)
    print('Step 1: Refreshing WBI keys...');
    await loginInfoApi.refreshWbiKeys();
    print('✅ WBI keys updated\n');

    // Step 2: Get user info (using famous bilibili user mid=2 as example)
    const targetMid = 2; // 碧诗 (Bilibili founder)
    print('Step 2: Getting user info for mid=$targetMid...');
    
    final userInfo = await userApi.getUserInfo(targetMid);
    
    print('\n=== User Information ===');
    print('Name: ${userInfo.name}');
    print('Mid: ${userInfo.mid}');
    print('Level: ${userInfo.level}');
    print('Sex: ${userInfo.sex}');
    print('Sign: ${userInfo.sign}');
    print('Face: ${userInfo.face}');

    if (userInfo.vip != null) {
      print('\n=== VIP Info ===');
      print('Is VIP: ${userInfo.vip!.isVip}');
      print('Type: ${userInfo.vip!.isYearly ? "Yearly" : userInfo.vip!.isMonthly ? "Monthly" : "None"}');
      print('Status: ${userInfo.vip!.status}');
    }

    if (userInfo.official != null) {
      print('\n=== Official Verification ===');
      print('Is Verified: ${userInfo.official!.isVerified}');
      print('Title: ${userInfo.official!.title}');
      print('Role: ${userInfo.official!.role}');
    }

    if (userInfo.liveRoom != null) {
      print('\n=== Live Room ===');
      print('Has Room: ${userInfo.liveRoom!.hasRoom}');
      print('Is Living: ${userInfo.liveRoom!.isLiving}');
      print('Room ID: ${userInfo.liveRoom!.roomid}');
      print('Title: ${userInfo.liveRoom!.title}');
    }

    // Step 3: Get user card (alternative, simpler API)
    print('\n\nStep 3: Getting user card...');
    final userCard = await userApi.getUserCard(targetMid);
    
    print('\n=== User Card ===');
    print('Name: ${userCard.name}');
    print('Fans: ${userCard.fans}');
    print('Friends: ${userCard.friend}');
    print('Sign: ${userCard.sign}');

    print('\n✅ All user info retrieved successfully!');
  } on BiliException catch (e) {
    print('❌ Error: ${e.message} (code: ${e.code})');
  } catch (e) {
    print('❌ Unexpected error: $e');
  } finally {
    client.close();
  }
}
