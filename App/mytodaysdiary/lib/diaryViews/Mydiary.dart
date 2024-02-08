import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mytodaysdiary/DB/TokenSave.dart';
import 'package:mytodaysdiary/DB/diaryProvider.dart';
import 'package:mytodaysdiary/MysettingViews/mySetting.dart';
import 'package:mytodaysdiary/diaryViews/SendDiary.dart';
import 'package:mytodaysdiary/diaryViews/calendar.dart';
import 'package:mytodaysdiary/diaryViews/explanation.dart';
import 'package:provider/provider.dart';


class MyDiary extends StatefulWidget {
  final DateTime? selectedDate;

  const MyDiary({Key? key, this.selectedDate}) : super(key: key);

  @override
  _MyDiaryState createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  bool happy = true;
  bool sad = false;
  bool angry = false;
  bool soso = false;
  bool loneliness = false;
  bool hungry = false;

  late List<bool> isSelected;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _secretDiaryController = TextEditingController();
  final TextEditingController _shareDiaryController = TextEditingController();
  
  
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
    isSelected = [happy, sad, angry, soso,loneliness,hungry];
    super.initState();
  }

  //토글 버튼
  void toggleSelect(int value) {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = (i == value);
      }
    });
    switch (value) {
      case 0:
        diaryProvider.emotion = '행복';
        break;
      case 1:
        diaryProvider.emotion = '슬픔';
        break;
      case 2:
        diaryProvider.emotion = '화남';
        break;
      case 3:
        diaryProvider.emotion = '그저그럼';
        break;
      case 4:
        diaryProvider.emotion = '외로움';
        break;
      case 5:
        diaryProvider.emotion = "배고픔";
        break;

    }
  }

  void decodeToken(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      print('토큰 구조가 잘못되었습니다.');
      return;
    }

    final payload = parts[1];
    final decoded = json.decode(utf8.decode(base64Url.decode(base64Url.normalize(payload))));
    print('디코딩된 토큰 페이로드: $decoded');
  }

// 서버에 나의일기, 공유일기, 감정 선택한 날짜를 전송하는
//동시에 서버에서 일기의 아이디 값을 전송해줌  아이디 값을 프로바이더에 저장
Future<void> sendUserServer(DateTime selectedDate) async {
  final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);

  String? token = await TokenStorage.getToken();
  if (token != null) {
    decodeToken(token);

    try {
      String shareDiaryValue = _shareDiaryController.text.trim();
      
      // 선택한 날짜를 "yyyy-MM-dd" 형식으로 문자열로 형식화
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      final response = await http.post(
        Uri.parse('http://skhugdsc.duckdns.org/diary/save'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'secretDiary': diaryProvider.secretDiary,
          'shareDiary': shareDiaryValue,
          'emotion': diaryProvider.emotion,
          'date': formattedDate,
        }),
      );

      print('응답: ${response.statusCode}');
      print('응답 본문: ${response.body}');
      
      // shareDiary 값 확인 로그 추가
      print('shareDiary 값 확인: $shareDiaryValue');

      if (response.statusCode == 201) {
        print('성공: ${response.body}');

        try {
          final responseData = jsonDecode(response.body);
          print('응답 본문 디코딩 결과: $responseData');

          final int? diaryId = responseData['id'];
          if (diaryId != null) {
            // 다이어리 ID를 DiaryProvider에 저장
            diaryProvider.id = diaryId;
            print('다이어리 ID: $diaryId');

            // 프로바이더에 저장되었음을 알리는 문구 출력
            print('프로바이더에 다이어리 ID가 저장되었습니다.');

            // 다이어리 ID를 확인하는 부분
            // 이곳에서 diaryProvider.id 값을 사용하거나 출력할 수 있습니다.
          } else {
            print('응답에서 다이어리 ID를 찾을 수 없습니다.');
          }
        } catch (error) {
          print('JSON 디코딩 에러: $error');
        }
      } else {
        print('상태 코드 ${response.statusCode}로 실패했습니다.');
      }
    } catch (error) {
      print('에러: $error');
    }
  } else {
    print("토큰이 없습니다");
  }
}




  @override
  Widget build(BuildContext context) {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFECF4D6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF4D6),
        title: const Text("나의 일기"),
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
          child:Row(children: [
            Container(
              width: 45,
              height: 635.33,
              decoration: ShapeDecoration(
                color: Color(0xFFB9C784B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                  ),
                  ),
                  ),
            Container(
              alignment: Alignment.center,
              width: 329,
              height: 680.11,
              decoration: ShapeDecoration(
                color: Color(0xFFB19470),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Container(
                alignment: Alignment.topLeft,
                width: 323,
                height: 660.11,
                decoration: ShapeDecoration(
                  color: Color(0xFFD0D4C7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Container(
                  alignment: Alignment.center,
                  width: 317,
                  height: 645.11,
                  decoration: ShapeDecoration(
                    color: Color(0xFFFAFFEC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.centerRight,
                    width: 300,
                    height: 595,
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
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "오늘의 감정",
                              style: TextStyle(
                                color: Color(0xFF76453B),
                                fontSize: 20,
                                fontFamily: 'Noto Sans',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                          ToggleButtons(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text('기쁨',
                                style: TextStyle(fontSize: 10),),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text('슬픔',
                                style: TextStyle(fontSize: 10)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text('화남',
                                style: TextStyle(fontSize: 10)),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Text('그저그럼',
                                style: TextStyle(fontSize: 10)),
                              ),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text("외로움",
                              style: TextStyle(fontSize: 10)),),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Text("배고픔",style: TextStyle(fontSize: 10)),
                              ),

                            ],
                            isSelected: isSelected,
                            onPressed: (int index) {
                              toggleSelect(index);
                            },
                            color: Colors.black,
                            fillColor: isSelected[0]
                                ? Colors.yellow
                                : isSelected[1]
                                    ? Colors.blue
                                    : isSelected[2]
                                        ? Colors.red
                                        : isSelected[3]
                                            ? Colors.green
                                            : isSelected[4]
                                            ? Colors.grey
                                            :isSelected[5]
                                            ?Colors.purple
                                            : Colors.white,
                            selectedColor: Colors.black,
                            selectedBorderColor: Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                  width: 350,
                                  child: TextFormField(
                                    controller: _secretDiaryController,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      hintText: '나의 하루',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      diaryProvider.secretDiary = value;
                                    },
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return ("Please enter your My day");
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                                Row(
                                  children: [
                                    Text(
                                      "누군가에게 들려주고픈 나의 하루",
                                      style: TextStyle(
                                        color: Color(0xFF76453B),
                                        fontSize: 18,
                                        fontFamily: 'Noto Sans',
                                        fontWeight: FontWeight.w400,
                                        height: 0,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) => Explanation()),
                                        );
                                      },
                                      icon: Icon(Icons.info),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 350,
                                  child: TextFormField(
                                    controller: _shareDiaryController,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                      hintText: '당신의 하루를 공유해주세요!',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return ("Please enter");
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(padding: const EdgeInsets.symmetric(vertical: 30.0)),
                          ElevatedButton(
                            onPressed: () {
                              if (_shareDiaryController.text == null || _shareDiaryController.text.trim().isEmpty) {
                                sendUserServer(widget.selectedDate ?? DateTime.now());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Calendar()),
                                );
                              } else {
                                sendUserServer(widget.selectedDate ?? DateTime.now());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SendDiaryScreen()),
                                );
                              }
                            },
                            child: Text(
                              "완료",
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],)
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF9AD0C2),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'My'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}