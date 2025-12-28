/// Login API - QR Code login
library;

import '../core/http_client.dart';
import '../core/models.dart';
import 'login_models.dart';

/// Bilibili login API implementation
class LoginApi {
  final BiliHttpClient client;

  LoginApi(this.client);

  /// Generate QR code for login
  /// 
  /// Reference: Bdocs/login/login_action/QR.md
  /// API: https://passport.bilibili.com/x/passport-login/web/qrcode/generate
  Future<QRCodeData> generateQRCode() async {
    const url = 'https://passport.bilibili.com/x/passport-login/web/qrcode/generate';
    
    final response = await client.get<QRCodeData>(
      url,
      dataParser: (data) => QRCodeData.fromJson(data as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to generate QR code: no data returned',
      );
    }

    return response.data!;
  }

  /// Poll QR code scan status
  /// 
  /// Reference: Bdocs/login/login_action/QR.md
  /// API: https://passport.bilibili.com/x/passport-login/web/qrcode/poll
  /// 
  /// Status codes:
  /// - 86101: Not scanned
  /// - 86090: Scanned but not confirmed
  /// - 86038: QR code expired
  /// - 0: Login success (cookies will be auto-saved)
  Future<QRPollData> pollQRCode(String qrcodeKey) async {
    const url = 'https://passport.bilibili.com/x/passport-login/web/qrcode/poll';
    
    final response = await client.get<QRPollData>(
      url,
      params: {'qrcode_key': qrcodeKey},
      dataParser: (data) => QRPollData.fromJson(data as Map<String, dynamic>),
    );

    if (response.data == null) {
      throw BiliException(
        code: -1,
        message: 'Failed to poll QR code: no data returned',
      );
    }

    return response.data!;
  }

  /// Scan and wait for QR code login
  /// 
  /// This is a convenience method that continuously polls the QR code status
  /// until login succeeds or fails.
  /// 
  /// [qrcodeKey] - The QR code key from generateQRCode()
  /// [onStatusChange] - Optional callback for status updates
  /// [pollInterval] - Polling interval in seconds (default: 2)
  /// [timeout] - Maximum wait time in seconds (default: 180)
  /// 
  /// Returns the final poll data when login succeeds
  /// Throws BiliException if login fails or times out
  Future<QRPollData> waitForQRLogin(
    String qrcodeKey, {
    void Function(QRPollStatus status)? onStatusChange,
    int pollInterval = 2,
    int timeout = 180,
  }) async {
    final startTime = DateTime.now();
    QRPollStatus? lastStatus;

    while (true) {
      // Check timeout
      if (DateTime.now().difference(startTime).inSeconds > timeout) {
        throw BiliException(
          code: -1,
          message: 'QR code login timeout',
        );
      }

      // Poll status
      final pollData = await pollQRCode(qrcodeKey);
      
      // Notify status change
      if (pollData.status != lastStatus) {
        lastStatus = pollData.status;
        onStatusChange?.call(pollData.status);
      }

      // Handle different statuses
      switch (pollData.status) {
        case QRPollStatus.success:
          return pollData;
        
        case QRPollStatus.expired:
          throw BiliException(
            code: pollData.code,
            message: 'QR code expired',
          );
        
        case QRPollStatus.notScanned:
        case QRPollStatus.scanned:
          // Continue polling
          await Future.delayed(Duration(seconds: pollInterval));
          break;
      }
    }
  }
}
