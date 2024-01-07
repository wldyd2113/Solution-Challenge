import 'dart:convert'; // json 패키지 사용

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mytodaysdiary/DB/diaryProvider.dart';
import 'package:provider/provider.dart';

class RecordDiary extends StatefulWidget {
  final DateTime selectedDate;

  RecordDiary({required this.selectedDate});

  @override
  _RecordDiaryState createState() => _RecordDiaryState();
}

class _RecordDiaryState extends State<RecordDiary> {
  late DiaryProvider _diaryProvider;
  late String send;
  late String myDiary;
  late String cheer;
  String result_cloud_google = '';
  final TextEditingController _myDiaryController = TextEditingController();
  final TextEditingController _sendDiaryController = TextEditingController();
  final TextEditingController _cheeringmessageController = TextEditingController();

  String selectedLanguage = 'en'; // 기본 언어 설정

  List<String> translationLanguages = ['en', 'ko', 'ja', 'zh', 'fr', 'es', 'de', 'it', 'th'];

  @override
  void initState() {
    super.initState();
    _diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    _fetchDiaryInformation(widget.selectedDate);
  }

  Future<void> _fetchDiaryInformation(DateTime selectedDate) async {
    try {
      // 가정: 서버의 API 엔드포인트 URL과 실제 구현에 맞게 수정 필요
      final response = await http.get(
        Uri.parse('https://example.com/api/diary?date=${selectedDate.toIso8601String()}'),
      );

      if (response.statusCode == 200) {
        // 서버에서 받아온 JSON 데이터를 해석하여 DiaryProvider를 업데이트합니다.
        final Map<String, dynamic> data = json.decode(response.body);
        _diaryProvider.emotion = data['emotion'];
        _diaryProvider.myDiary = data['myDiary'];
        _diaryProvider.sendDiary = data['sendDiary'];
        _diaryProvider.cheeringmessage = data['cheeringmessage'];

        setState(() {
          myDiary=_diaryProvider.myDiary ;
          cheer =  _diaryProvider.cheeringmessage;
          send = _diaryProvider.sendDiary;
          // 서버에서 받아온 sendDiary를 TextField에 설정
          _sendDiaryController.text = send;
          _myDiaryController.text = myDiary;
          _cheeringmessageController.text = cheer;
        });
      } else {
        // 서버 응답이 성공하지 않은 경우 에러 처리
        throw Exception('Failed to load diary information');
      }
    } catch (error) {
      // 예외가 발생한 경우 에러 처리
      print('Error fetching diary information: $error');
    }
  }

  Future<void> getTranslation_google_cloud_translation(String targetLanguage) async {
    var _baseUrl = 'https://translation.googleapis.com/language/translate/v2';
    var key = 'AIzaSyB6EHY71E1D1CVUVqy5DpDRJpzNiyaHCsk';
    var to = targetLanguage; // 선택한 언어로 설정
    var text = _cheeringmessageController.text;
    var response = await http.post(
      Uri.parse('$_baseUrl?target=$to&key=$key&q=$text'),
    );

    if (response.statusCode == 200) {
      var dataJson = jsonDecode(response.body);
      result_cloud_google =
          dataJson['data']['translations'][0]['translatedText'];

      // Show the translated text in a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Translated Text'),
            content: Text(result_cloud_google),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Diary"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Text("Selected Date: ${DateFormat.yMd().format(widget.selectedDate)}"),
                Text("이전 나의 감정: ${_diaryProvider.emotion}"),
                Text("My Diary"),
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: _myDiaryController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'My diary',
                    ),
                  ),
                ),
                Text("Send Diary"),
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: _sendDiaryController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Send diary',
                    ),
                  ),
                ),
                Text("Cheering Message"),
                SizedBox(
                  width: 350,
                  child: TextField(
                    controller: _cheeringmessageController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Cheeringmessage',
                    ),
                  ),
                ),
                // 번역 언어 선택 드롭다운
                DropdownButton<String>(
                  value: selectedLanguage,
                  items: translationLanguages.map((String language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedLanguage = newValue;
                      });
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    getTranslation_google_cloud_translation(selectedLanguage);
                  },
                  child: Text("Translation"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
