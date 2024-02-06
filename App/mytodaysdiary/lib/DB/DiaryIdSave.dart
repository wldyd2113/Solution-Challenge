import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DidStorage {
  static final FlutterSecureStorage _idstorage = const FlutterSecureStorage();
  static const String idKey = 'id';

  // 다이어리 ID를 저장
  static Future<void> saveDiaryId(int diaryId) async {
    await _idstorage.write(key: idKey, value: diaryId.toString());
  }

  // 저장된 다이어리 ID를 불러오기
  static Future<int?> getDiaryId() async {
    String? diaryIdString = await _idstorage.read(key: idKey);
    return diaryIdString != null ? int.tryParse(diaryIdString) : null;
  }

  // 다이어리 ID 삭제
  static Future<void> deleteDiaryId() async {
    await _idstorage.delete(key: idKey);
  }
}
