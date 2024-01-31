  import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mytodaysdiary/DB/TokenSave.dart';
import 'package:mytodaysdiary/DB/diaryProvider.dart';
import 'package:mytodaysdiary/MysettingViews/mySetting.dart';
import 'package:mytodaysdiary/diaryViews/calendar.dart';
import 'package:provider/provider.dart';

  class RecordDiary extends StatefulWidget {
    final DateTime selectedDate;

    RecordDiary({required this.selectedDate});

    @override
    _RecordDiaryState createState() => _RecordDiaryState();
  }

  class _RecordDiaryState extends State<RecordDiary> {
    late DiaryProvider _diaryProvider;
    String result_cloud_google = '';
    String emotion = '';
    String secretDiary = '';
    String shareDiary = '';
    String cheeringMessage = '';
    String date = '';
    late String messageLocation='';

    String selectedLanguage = 'en'; // 기본 언어 설정

    
  //번역
    List<String> translationLanguages = [
      'en',
      'ko',
      'ja',
      'zh',
      'fr',
      'es',
      'de',
      'it',
      'th'
    ];
    int _selectedIndex = 0;

    final List<Widget> _widgetOptions = <Widget>[
      Calendar(),
      MySetting(),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => _widgetOptions[index]),
      );
    }

    @override
    void initState() {
      super.initState();
      _diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
      final formattedDate = formatDateForServer(widget.selectedDate);
      getDiary(formattedDate);
    }

    String formatDateForServer(DateTime date) {
      final formatter = DateFormat('yyyy-MM-dd');
      return formatter.format(date);
    }

  //토큰 디코딩
    void decodeToken(String token) {
      final parts = token.split('.');
      if (parts.length != 3) {
        print('토큰 구조가 잘못되었습니다.');
        return;
      }

      final payload = parts[1];
      final decoded = json
          .decode(utf8.decode(base64Url.decode(base64Url.normalize(payload))));
      print('디코딩된 토큰 페이로드: $decoded');
    }

    //서버에서 나의 일기, 공유일기, 응원에 메시지를 받아오는 함수
    Future<void> getDiary(String formattedDate) async {
      final token = await TokenStorage.getToken();

      if (token != null) {
        // 토큰 디코딩 및 확인 로직 추가
        decodeToken(token);

        try {
          final getResponse = await http.get(
            Uri.parse('http://localhost:8080/diary/$formattedDate'),
            headers: {
              'Authorization': 'Bearer $token',
            },
          );

          print('Server Response: ${getResponse.statusCode}');
          print('Server Response Body: ${getResponse.body}');
          if (getResponse.statusCode == 200) {
            // 서버에서 JSON 형식으로 반환된 데이터를 파싱
            try {
              final dynamic jsonData = jsonDecode(utf8.decode(getResponse.bodyBytes));
              this.emotion = jsonData['emotion'];
              this.secretDiary = jsonData['secretDiary'];
              this.shareDiary = jsonData['shareDiary']??'';
              this.cheeringMessage =
                  jsonData['cheeringMessage'] ?? ''; // null일 경우 빈 문자열로 처리
              this.date = jsonData['date'];
              this.messageLocation = jsonData['messageLocation'] ?? '';

              setState(() {
                this.emotion = emotion;
                this.secretDiary = secretDiary;
                this.shareDiary = shareDiary;
                this.cheeringMessage = cheeringMessage;
                this.date = date;
                this.messageLocation = messageLocation;
              });

              print('데이터 가져오기 성공: $emotion, $shareDiary, $cheeringMessage, $messageLocation');
            } catch (e) {
              print('데이터 파싱 중 오류 발생: $e');
            }
          } else if (getResponse.statusCode == 401) {
            // 인증 실패 처리
            print('토큰이 유효하지 않습니다. 또는 권한이 없습니다.');
          } else if (getResponse.statusCode == 400) {
            // 서버에서 해당 날짜에 대한 데이터를 찾을 수 없을 때
            print('해당하는 날짜의 일기를 찾을 수 없습니다.');
          } else {
            print('데이터 로드 실패: ${getResponse.statusCode}');
          }
        } catch (error, stackTrace) {
          print('에러: $error');
          print('스택 트레이스: $stackTrace');
        }
      } else {
        print('토큰이 없습니다.');
      }
    }
  //번역하는 함수 구글 번역기 API 받아와서 사용
    Future<void> getTranslation_google_cloud_translation(
        String targetLanguage) async {
      var _baseUrl = 'https://translation.googleapis.com/language/translate/v2';
      var key = 'AIzaSyB6EHY71E1D1CVUVqy5DpDRJpzNiyaHCsk';
      var to = targetLanguage; // 선택한 언어로 설정
      var text = cheeringMessage;
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
        backgroundColor: const Color(0xFFECF4D6),
        appBar: AppBar(
          backgroundColor: const Color(0xFFECF4D6),
          title: const Text("My Diary"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                alignment: Alignment.center,
                width: 329,
                height: 575.11,
                decoration: ShapeDecoration(
                  color: Color(0xFFB19470),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  alignment: Alignment.topLeft,
                  width: 323,
                  height: 545.11,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD0D4C7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: 317,
                    height: 530.11,
                    decoration: ShapeDecoration(
                      color: Color(0xFFFAFFEC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Container(
                      alignment: Alignment.centerRight,
                      width: 290,
                      height: 480,
                      decoration: ShapeDecoration(
                        color: Color(0xFFFFFFEC),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "기록한 날짜: ${date}",
                              style: TextStyle(
                                color: Color(0xFF76453B),
                                fontSize: 18,
                                fontFamily: 'Noto Sans',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "이전 나의 감정: ${emotion}",
                              style: TextStyle(
                                color: Color(0xFF76453B),
                                fontSize: 18,
                                fontFamily: 'Noto Sans',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "나의 하루",
                              style: TextStyle(
                                color: Color(0xFF76453B),
                                fontSize: 20,
                                fontFamily: 'Noto Sans',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    width: 250,
                                    height: 120,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFFFFFEC),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    child: Text(
                                      '${secretDiary}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: 'Noto Sans',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "공유 일기",
                                    style: TextStyle(
                                      color: Color(0xFF76453B),
                                      fontSize: 20,
                                      fontFamily: 'Noto Sans',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    width: 250,
                                    height: 120,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFFFFFEC),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    child: Text(
                                      '${shareDiary}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: 'Noto Sans',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${messageLocation}에 사는 누군가의 위로의 편지",
                                    style: TextStyle(
                                      color: Color(0xFF76453B),
                                      fontSize: 20,
                                      fontFamily: 'Noto Sans',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    width: 250,
                                    height: 120,
                                    decoration: ShapeDecoration(
                                      color: Color(0xFFFFFFEC),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      shadows: [
                                        BoxShadow(
                                          color: Color(0x3F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 4),
                                          spreadRadius: 0,
                                        )
                                      ],
                                    ),
                                    child: Text(
                                      '${cheeringMessage}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: 'Noto Sans',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                ],
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
                            SizedBox(
                              child: ElevatedButton(
                                  onPressed: () {
                                    getTranslation_google_cloud_translation(
                                        selectedLanguage);
                                  },
                                  child: const Text(
                                    "번역",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontFamily: 'Gowun Dodum',
                                      fontWeight: FontWeight.w400,
                                      height: 0,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0x996B3A2F),
                                    elevation: 4,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF9AD0C2),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'My'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      );
    }
  }
