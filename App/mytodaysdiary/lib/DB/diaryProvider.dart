import 'package:flutter/material.dart';

class DiaryProvider extends ChangeNotifier {
  String _emotion= ''; //감정
  String _secretDiary = ''; //수신받는 다이어리
  String _sendDiary =''; //송신하는 다이어리
  String _shareDiary = ''; //나의 다이어리
  String _cheeringMessage =''; //응원 메시지
  late int _id;


  String get emotion => _emotion;
  String get shareDiary => _shareDiary;
  String get secretDiary => _secretDiary;
  String get sendDiary => _sendDiary;
  String get cheeringMessage => _cheeringMessage;
  int get id => _id;

    void set emotion(String input_emotion) {
      _emotion = input_emotion;
    notifyListeners();
  }
    void set shareDiary(String input_shareDiary) {
      _shareDiary = input_shareDiary;
    notifyListeners();
  }
    void set secretDiary(String input_secretDiary) {
      _secretDiary = input_secretDiary;
    notifyListeners();
  }
    void set sendDiary(String input_sendDiary) {
      _sendDiary = input_sendDiary;
    notifyListeners();
  }
    void set cheeringMessage(String input_cheeringMessage) {
      _cheeringMessage = input_cheeringMessage;
    notifyListeners();
  }
  void set id(int input_id) {
      _id = input_id;
    notifyListeners();
  }


}

