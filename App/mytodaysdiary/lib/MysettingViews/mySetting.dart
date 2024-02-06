import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mytodaysdiary/DB/TokenSave.dart';
import 'package:mytodaysdiary/MysettingViews/passwordChange.dart';
import 'package:mytodaysdiary/diaryViews/calendar.dart';
import 'package:mytodaysdiary/loginViews/login.dart';

class MySetting extends StatefulWidget {
  @override
  _MySettingState createState() => _MySettingState();
}

class _MySettingState extends State<MySetting> {
  XFile? _pickedFile;
  int _selectedIndex = 1;
  late String email = '';
  late String name = '';
  late int diaryCount;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

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
Future<void> fetchData() async {
  final token = await TokenStorage.getToken();
 

  if (token != null) {
    decodeToken(token);

    try {
      final getResponse = await http.get(
        Uri.parse('http://localhost:8080/user/info'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Server Response: ${getResponse.statusCode}');
      print('Server Response Body: ${getResponse.body}');

      if (getResponse.statusCode == 200) {
        // 서버에서 JSON으로 반환된 데이터를 디코딩
        final Map<String, dynamic> data = jsonDecode(utf8.decode(getResponse.bodyBytes));

        // 데이터를 추출
        final name = data['name'];
        final email = data['email'];
        final diaryCount = data['diaryCount'];

        setState(() {
          this.name = name;
          this.email = email;
          this.diaryCount = diaryCount;
        });

        print('데이터 가져오기 성공: $name, $email');
      } else if (getResponse.statusCode == 401) {
        // ...
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

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _getCameraImage(),
              child: const Text('Take a picture'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => _getPhotoLibraryImage(),
              child: const Text('Importing from Library'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  void _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  void _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  // 변경 비밀번호 버튼이 눌렸을 때 호출되는 메서드
  void onPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PasswordChangeDialog();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    diaryCount = 0; // 초기값 설정
    fetchData(); // initState에서 fetchData 호출
  }

  @override
  Widget build(BuildContext context) {
    final _imageSize = MediaQuery.of(context).size.width / 4;

    return Scaffold(
      backgroundColor: const Color(0xFFECF4D6),
      body: SafeArea(
        child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(
                "내 정보",
                style: TextStyle(
                color: Color(0xFF194062),
                fontSize: 48,
                fontFamily: 'Noto Sans',
                fontWeight: FontWeight.w400,
                height: 0,
                ),
              ),
            ),
            SizedBox(height: 20,),
            if(_pickedFile == null)
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.width,
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: GestureDetector(
                  onTap: (){
                    _showBottomSheet();
                  },
                  child: Center(
                    child: Icon(
                      Icons.account_circle,
                      size: _imageSize,
                    ),
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  width: _imageSize,
                  height: _imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width:2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    image: DecorationImage(
                      image: FileImage(File(_pickedFile!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("닉네임: ",
                      style: TextStyle(
                      color: Color(0xFF194062),
                      fontSize: 20,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),
                      ),
                      Text("$name",
                      style: TextStyle(
                      color: Color(0xCC2D9596),
                      fontSize: 20,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),
                      ),
                    ],
                  ),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                  Row(
                    children: <Widget>[
                      Text("Email: ",
                      style: TextStyle(
                      color: Color(0xFF194062),
                      fontSize: 20,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),
                      ),
                      Text("$email",
                      style: TextStyle(
                      color: Color(0xCC2D9596),
                      fontSize: 20,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),
                      ),
                    ],
                  ),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                  Row(
                    children: <Widget>[
                      Text("비밀번호: ",
                      style: TextStyle(
                      color: Color(0xFF194062),
                      fontSize: 20,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),),
                      ElevatedButton(
                        onPressed: onPressed,
                        child: Text("비밀번호 변경",
                        style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Gowun Dodum',
                                fontWeight: FontWeight.w400,
                                height: 0,
                                ),
                        ),
                          style: ElevatedButton.styleFrom(
                          primary: Color(0xCC2D9596),
                          elevation: 4, )
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text("내가 기록한 하루 수: ",
                      style: TextStyle(
                      color: Color(0xFF194062),
                      fontSize: 20,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),
                      ),
                      Text("${diaryCount} days",
                      style: TextStyle(
                      color: Color(0xCC2D9596),
                      fontSize: 20,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          // 로그아웃 시 토큰을 삭제합니다.
                          await TokenStorage.deleteToken();
                          
                          // 현재 선택된 인덱스에 따라 다른 페이지로 이동합니다.
                          if (_selectedIndex == 0) {
                            // 캘린더 페이지로 이동
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Calendar()),
                            );
                          } else if (_selectedIndex == 1) {
                            // 로그인 페이지로 이동
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Loginpage()),
                            );
                          }
                        },
                        child: Text("LogOut",
                                style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: 'Gowun Dodum',
                                fontWeight: FontWeight.w400,
                                height: 0,
                                ),
                                ),
                          style: ElevatedButton.styleFrom(
                          primary: Color(0xCC2D9596),
                          elevation: 4, )
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
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
