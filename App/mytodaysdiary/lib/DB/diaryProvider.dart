import 'package:flutter/material.dart';

class DiaryProvider extends ChangeNotifier {
  String _emotion= ''; //감정
  String _receiverDiary = ''; //수신받는 다이어리
  String _sendDiary =''; //송신하는 다이어리
  String _myDiary = ''; //나의 다이어리
  String _cheeringmessage =''; //응원 메시지


  String get emotion => _emotion;
  String get receiverDiary => _receiverDiary;
  String get myDiary => _myDiary;
  String get sendDiary => _sendDiary;
  String get cheeringmessage => _cheeringmessage;

    void set emotion(String input_emotion) {
      _emotion = input_emotion;
    notifyListeners();
  }
    void set receiverDiary(String input_receiverDiary) {
      _receiverDiary = input_receiverDiary;
    notifyListeners();
  }
    void set myDiary(String input_myDiary) {
      _myDiary = input_myDiary;
    notifyListeners();
  }
    void set sendDiary(String input_sendDiary) {
      _sendDiary = input_sendDiary;
    notifyListeners();
  }
    void set cheeringmessage(String input_cheeringmessage) {
      _cheeringmessage = input_cheeringmessage;
    notifyListeners();
  }


}

