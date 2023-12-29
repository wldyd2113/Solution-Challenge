import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytodaysdiary/DB/diaryProvider.dart';
import 'package:mytodaysdiary/DB/userProvider.dart';
import 'package:provider/provider.dart';

class SendDiaryScreen extends StatefulWidget {
  @override
  _SendDiaryScreenState createState() => _SendDiaryScreenState();
}

class _SendDiaryScreenState extends State<SendDiaryScreen> {
  late String country;
  late String send;
  final TextEditingController _receiverDiaryController = TextEditingController();
  final TextEditingController _sendDiaryController = TextEditingController();

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
          country = userProvider.location;
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
                Text("폴란드에 사는 누군가의 하루가 도착했어요."),
                Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                // TextField에 서버에서 받아온 sendDiary를 설정
                TextField(
                  controller: _sendDiaryController,
                  readOnly: true, // 읽기 전용으로 설정하여 사용자의 입력을 막음
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Send Diary',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

