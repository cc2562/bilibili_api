/// Example: QR Code Login
/// 
/// This example demonstrates how to use the QR code login feature.
/// Run this with: flutter run example/qr_login_example.dart

import 'package:bilibili_api/bilibili_api.dart';

void main() async {
  // Create HTTP client
  final client = BiliHttpClient();
  final loginApi = LoginApi(client);
  final loginInfoApi = LoginInfoApi(client);

  try {
    print('=== Bilibili QR Code Login Example ===\n');

    // Step 1: Generate QR code
    print('Step 1: Generating QR code...');
    final qrcode = await loginApi.generateQRCode();
    print('QR Code generated!');
    print('URL: ${qrcode.url}');
    print('Key: ${qrcode.qrcodeKey}\n');

    print('Please scan the QR code with Bilibili app:');
    print('You can generate a QR code from this URL: ${qrcode.url}\n');

    // Step 2: Wait for login (with status updates)
    print('Step 2: Waiting for scan and confirmation...');
    final pollData = await loginApi.waitForQRLogin(
      qrcode.qrcodeKey,
      onStatusChange: (status) {
        print('Status: ${status.message}');
      },
      pollInterval: 2,
      timeout: 180,
    );

    print('\n✅ Login successful!');
    print('Refresh token: ${pollData.refreshToken}');

    // Step 3: Verify login by getting user info
    print('\nStep 3: Getting user info...');
    final userInfo = await loginInfoApi.getNavInfo();

    if (userInfo.isLogin) {
      print('✅ Logged in as: ${userInfo.uname}');
      print('User ID: ${userInfo.mid}');
      print('Level: ${userInfo.levelInfo?.currentLevel}');
      print('VIP Status: ${userInfo.vipStatus == 1 ? "VIP" : "Normal"}');

      // Get user statistics
      final stats = await loginInfoApi.getNavStat();
      print('\nUser Statistics:');
      print('Following: ${stats.following}');
      print('Followers: ${stats.follower}');
      print('Dynamics: ${stats.dynamicCount}');

      // Show cookies
      print('\nCookies saved:');
      final cookies = client.cookieManager.cookies;
      cookies.forEach((key, value) {
        if (key.length <= 20) {
          // Don't print very long cookie values
          print('  $key: ${value.substring(0, value.length.clamp(0, 30))}...');
        }
      });
    } else {
      print('❌ Login verification failed');
    }
  } on BiliException catch (e) {
    print('❌ Error: ${e.message} (code: ${e.code})');
  } catch (e) {
    print('❌ Unexpected error: $e');
  } finally {
    client.close();
  }
}
