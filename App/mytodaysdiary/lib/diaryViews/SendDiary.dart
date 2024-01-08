import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytodaysdiary/DB/diaryProvider.dart';
import 'package:mytodaysdiary/DB/userProvider.dart';
import 'package:mytodaysdiary/diaryViews/calendar.dart';
import 'package:provider/provider.dart';

class SendDiaryScreen extends StatefulWidget {
  @override
  _SendDiaryScreenState createState() => _SendDiaryScreenState();
}

class _SendDiaryScreenState extends State<SendDiaryScreen> {
  late String location;
  late String send;
  String result_cloud_google = '';
  final TextEditingController _receiverDiaryController = TextEditingController();
  final TextEditingController _sendDiaryController = TextEditingController();
  final TextEditingController _cheeringmessageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData(); // 앱 시작 시 데이터 가져오기
    fetchDataDiary();
  }

  Future<void> fetchData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    try {
      // 서버로부터 위치 정보를 가져오는 요청
      final response = await http.get(Uri.parse(''));

      if (response.statusCode == 200) {
        // 서버 응답이 성공이면 데이터 업데이트
        final Map<String, dynamic> data = json.decode(response.body);
        userProvider.location = data['location'];
        setState(() {
          location = userProvider.location;
        });
      } else {
        // 서버 응답이 실패일 경우 에러 처리
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchDataDiary() async {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    
    try {
      // 서버로부터 위치 정보를 가져오는 요청
      final response = await http.get(Uri.parse(''));

      if (response.statusCode == 200) {
        // 서버 응답이 성공이면 데이터 업데이트
        final Map<String, dynamic> data = json.decode(response.body);
        diaryProvider.sendDiary = data['sendDiary'];
        setState(() {
          send = diaryProvider.sendDiary;
          // 서버에서 받아온 sendDiary를 TextField에 설정
          _sendDiaryController.text = send;
        });
      } else {
        // 서버 응답이 실패일 경우 에러 처리
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
    void sendUserServer() async {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    try {
      final response = await http.post(
        Uri.parse(''),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cheeringmessage': diaryProvider.cheeringmessage,
        }),
      );

      if (response.statusCode == 200) {
        print('Success: ${response.body}');
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

Future<void> getTranslation_google_cloud_translation() async {
  var _baseUrl = 'https://translation.googleapis.com/language/translate/v2';
  var key = 'AIzaSyB6EHY71E1D1CVUVqy5DpDRJpzNiyaHCsk';
  // 영어, 한국어, 일본어, 중국어(간체), 중국어(번체), 프랑스어, 스페인어, 독일, 이탈리아, 태국
  var to = "en,ko,ja,zh-chs,zh-cht, fr, es, de, it, th";
  var text = _sendDiaryController.text;
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
        title: const Text("Diary"),
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                 //Text(location ?? 'Loading...'), // location가 null이면 'Loading...'을 표시
                Text("폴란드에 사는 누군가의 하루가 도착했어요."),
                Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                // TextField에 서버에서 받아온 sendDiary를 설정
                SizedBox(
                  width: 350,
                child: TextField(
                  controller: _sendDiaryController,
                  readOnly: true, // 읽기 전용으로 설정하여 사용자의 입력을 막음
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Send Diary',
                  ),
                ),
                ),
                ElevatedButton(onPressed: (){
                  getTranslation_google_cloud_translation();
                }, child: Text("Translation")),
                Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                Text("A message of support that I would like to convey"),
                Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                      SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _cheeringmessageController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'Message',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return ("Please enter");
                          }
                          return null;
                        },
                      ),
                    ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 30.0)),
              ElevatedButton(
                onPressed: () {
                  sendUserServer();
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Calendar())
                  );
                },
                child: Text("Send"),
              ),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}

