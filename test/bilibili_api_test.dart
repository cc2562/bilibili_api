import 'package:flutter_test/flutter_test.dart';
import 'package:bilibili_api/bilibili_api.dart';

void main() {
  group('Bilibili API Tests', () {
    test('CookieManager basic operations', () {
      final manager = CookieManager();

      // Test setting and getting cookies
      manager.setCookie('test_key', 'test_value');
      expect(manager.getCookie('test_key'), 'test_value');

      // Test authentication status
      expect(manager.isAuthenticated, false);
      manager.setCookie(CookieManager.sessData, 'session_token');
      expect(manager.isAuthenticated, true);

      // Test clear
      manager.clear();
      expect(manager.getCookie('test_key'), null);
      expect(manager.isAuthenticated, false);
    });

    test('WbiSigner mixin key generation', () {
      final signer = WbiSigner();
      
      // Update with test keys
      const imgUrl = 'https://i0.hdslb.com/bfs/wbi/7cd084941338484aae1ad9425b84077c.png';
      const subUrl = 'https://i0.hdslb.com/bfs/wbi/4932caff0ff746eab6f01bf08b70ac45.png';
      
      signer.updateKeys(imgUrl, subUrl);
      
      expect(signer.mixinKey, isNotNull);
      expect(signer.mixinKey!.length, 32);
    });

    test('BiliResponse parsing', () {
      final response = BiliResponse<String>(
        code: 0,
        message: 'success',
        ttl: 1,
        data: 'test_data',
      );

      expect(response.isSuccess, true);
      expect(response.data, 'test_data');
    });

    test('BiliException creation', () {
      final exception = BiliException(
        code: -101,
        message: 'Unauthorized',
      );

      expect(exception.code, -101);
      expect(exception.message, 'Unauthorized');
      expect(exception.toString(), contains('-101'));
    });
  });
}
