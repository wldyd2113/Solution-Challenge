import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String accessTokenKey = 'accessToken';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: accessTokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: accessTokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: accessTokenKey);
  }

  static Future<void> setAutoLogin(bool switchValue) async {
    // Auto Login 설정 여부에 따라 처리할 부분 추가
    if (switchValue) {
      // Auto Login을 활성화한 경우, 토큰을 저장
      String? token = await getToken();
      if (token != null) {
        await saveToken(token);
      }
    } else {
      // Auto Login을 비활성화한 경우, 토큰 삭제
      await deleteToken();
    }
  }
}
