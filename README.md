# bilibili_api

A Flutter package for interacting with Bilibili Web API.

## Features

- ✅ **QR Code Login** - Web端二维码登录
- ✅ **User Information** - 用户信息查询（支持 WBI 签名）
- ✅ **Video Information** - 视频信息查询
- ✅ **Cookie Management** - 自动管理登录凭证
- ✅ **WBI Signature** - 自动处理 WBI 签名鉴权

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  bilibili_api: ^0.0.1
```

## Usage

### QR Code Login

```dart
import 'package:bilibili_api/bilibili_api.dart';

final client = BiliHttpClient();
final loginApi = LoginApi(client);

// Generate QR code
final qrcode = await loginApi.generateQRCode();
print('Scan QR code: ${qrcode.url}');

// Wait for login
final pollData = await loginApi.waitForQRLogin(
  qrcode.qrcodeKey,
  onStatusChange: (status) {
    print('Status: ${status.message}');
  },
);

print('Login successful!');
```

### Get User Information

```dart
final client = BiliHttpClient();
final userApi = UserApi(client);
final loginInfoApi = LoginInfoApi(client);

// Refresh WBI keys (required for signed requests)
await loginInfoApi.refreshWbiKeys();

// Get user info
final userInfo = await userApi.getUserInfo(2); // mid=2
print('User: ${userInfo.name}');
print('Level: ${userInfo.level}');
```

### Get Video Information

```dart
final client = BiliHttpClient();
final videoApi = VideoApi(client);

// Get video by bvid
final video = await videoApi.getVideoInfoByBvid('BV1xx411c79H');
print('Title: ${video.title}');
print('Views: ${video.stat.view}');
print('UP主: ${video.owner.name}');
```

## Examples

See the `example` folder for complete examples:

- `qr_login_example.dart` - QR code login demo
- `user_info_example.dart` - User information query demo
- `video_info_example.dart` - Video information query demo

Run examples with:
```bash
flutter run example/qr_login_example.dart
```

## API Reference

### Core Classes

- `BiliHttpClient` - HTTP client with cookie and WBI signature support
- `CookieManager` - Manages authentication cookies
- `WbiSigner` - Handles WBI signature generation

### Login APIs

- `LoginApi` - QR code login functionality
- `LoginInfoApi` - User login information queries

### User APIs

- `UserApi` - User information queries (requires WBI signature)

### Video APIs

- `VideoApi` - Video information queries

## Documentation

This package is based on the third-party Bilibili API documentation. The API endpoints are subject to change by Bilibili.

**Important Notes:**
- This is an unofficial package for educational purposes
- Respect Bilibili's rate limits and terms of service
- Do not use for commercial purposes without proper authorization

## License

See LICENSE file for details.
