import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytodaysdiary/DB/TokenSave.dart';
import 'package:mytodaysdiary/DB/diaryProvider.dart';
import 'package:mytodaysdiary/MysettingViews/mySetting.dart';
import 'package:mytodaysdiary/diaryViews/SendDiary.dart';
import 'package:mytodaysdiary/diaryViews/calendar.dart';
import 'package:mytodaysdiary/diaryViews/explanation.dart';
import 'package:provider/provider.dart';

//나만 볼수 있거나 누군가에게 전송할수 있는 페이지
class MyDiary extends StatefulWidget {
  @override
  _MyDiaryState createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  bool happy = true;
  bool sad = false;
  bool angry = false;
  bool soso = false;
  late List<bool> isSelected;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _myDiaryController = TextEditingController();
  final TextEditingController _receiverDiaryController = TextEditingController();
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
    isSelected = [happy, sad, angry, soso];
    super.initState();
  }

  void toggleSelect(int value) {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = (i == value);
      }
    });
    switch (value) {
      case 0:
        diaryProvider.emotion = 'Happy';
        break;
      case 1:
        diaryProvider.emotion = 'Sad';
        break;
      case 2:
        diaryProvider.emotion = 'Angry';
        break;
      case 3:
        diaryProvider.emotion = 'So-so';
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

  
//서버로 현재 날짜와 일기 작성 감정 보냄
Future<void> sendUserServer() async {
  final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);

  // 저장된 토큰을 저장소에서 가져옵니다.
  String? token = await TokenStorage.getToken();
    if (token != null) {
      decodeToken(token);

  try {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/posts/save'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // 헤더에 토큰을 포함
      },
      body: jsonEncode({
        'myDiary': diaryProvider.myDiary,
        'emotion': diaryProvider.emotion,
        'currentDate': DateTime.now().toString(),
      }),
      
    );

    // 서버 응답 출력
    print('응답: ${response.statusCode}');
    print('응답 본문: ${response.body}');

    if (response.statusCode == 201) {
      print('성공: ${response.body}');

      // 서버 응답 데이터 디코딩 및 출력
      try {
        final responseData = jsonDecode(response.body);
        print('응답 본문 디코딩 결과: $responseData');
      } catch (error) {
        print('JSON 디코딩 에러: $error');
      }
    } else {
      print('상태 코드 ${response.statusCode}로 실패했습니다.');
    }
  } catch (error) {
    print('에러: $error');
  }
}else {
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
        title: const Text("Diary"),
        actions: <Widget>[],
      ),
        body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child:Container(
              alignment: Alignment.center,
              width: 329,
              height: 575.11,
              decoration: ShapeDecoration(
              color: Color(0xFFB19470),
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              ),
              ),
              child:Container(
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
              child :Container(
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
              Container(
                alignment: Alignment.centerLeft,
                  child: Text(
                    "Feelings of The Day",
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
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Happy'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Sad'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Angry'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('So-so'),
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
                                    ? Colors.grey
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
                    Text("나의 하루", style: TextStyle(
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
                        controller: _myDiaryController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration:  InputDecoration(
                          hintText: '나의 하루',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                        ),
                            onChanged: (value) {
                            // 텍스트가 변경될 때마다 프로바이더에서 값을 업데이트
                            diaryProvider.myDiary = value;
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
                    Row(children:[
                    Text("누군가에게 들려주고픈 나의 하루",
                        style: TextStyle(
                        color: Color(0xFF76453B),
                        fontSize: 18,
                        fontFamily: 'Noto Sans',
                        fontWeight: FontWeight.w400,
                        height: 0,
                        ),
                        ),
                            IconButton(
                            onPressed: (){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => Explanation(),),);
                            } ,
                            
                            
                            icon: Icon(Icons.info),
                          ),
                    ],
                    ),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _receiverDiaryController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration:  InputDecoration(
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
                onPressed: () async{
                await sendUserServer();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => SendDiaryScreen())
                  );
                },
                child: Text("Finish",
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
                                elevation: 4, )
                                
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
