import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytodaysdiary/DB/userProvider.dart';
import 'package:mytodaysdiary/loginViews/email_au.dart';
import 'package:mytodaysdiary/loginViews/login.dart';
import 'package:provider/provider.dart';

class JoinPage extends StatefulWidget {
  final bool isEmailVerified;

  JoinPage({required this.isEmailVerified});
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();

  String? _sex; // 추가: 선택된 성별을 저장하는 변수
  String? _location;//사는 나라
  String? _language;// 언어


  final _formKey = GlobalKey<FormState>();

      // 닉네임 중복 확인 다이얼로그
    void _showNicknameDialog(String message) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Nickname Check'),
            content: Text(message),
            actions: <Widget>[
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
    }
        void _checkNicknameUniqueness() async {
      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/user/signup'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'nickname': _nameController.text,
          }),
        );

        if (response.statusCode == 200) {
          // 성공적으로 응답을 받으면 결과를 변수에 저장
          String message = response.body;

          // 결과에 따라 경고 다이얼로그 표시
          _showNicknameDialog(message);
        } else {
          // 서버 응답이 실패인 경우 에러 메시지를 출력
          print('서버 응답 에러: ${response.statusCode}');
          print('에러 내용: ${response.body}');
        }
      } catch (error) {
        // 예외가 발생한 경우 에러 메시지를 출력
        print('에러 발생: $error');
      }
    }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    void sendUserServer() async {
      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/user/signup'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            'email': userProvider.email,
            'name': userProvider.name,
            'password': userProvider.password,
            'age': userProvider.age.toString(),
            'sex': userProvider.sex,
            'job': userProvider.job,
            'location': userProvider.location,
            'language': userProvider.language,
          }),
        );

        if (response.statusCode == 200) {
          // 성공적으로 서버에 전송됨
          print('Success: ${response.body}');
          // 여기서 사용자에게 회원가입이 성공했다는 메시지를 보여줄 수 있습니다.
        } else {
          // 서버 응답 실패
          print('Failed with status code: ${response.statusCode}  ');
          // 여기서 사용자에게 회원가입 실패 메시지를 보여줄 수 있습니다.
        }
      } catch (error) {
        // 예외 발생 시 처리
        print('Error: $error');
        // 여기서 사용자에게 오류 메시지를 보여줄 수 있습니다.
      }
    }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

    return Scaffold(
      backgroundColor: const Color(0xFF9AD0C2),
      appBar: AppBar(
        title: const Text("가입하기"),
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  '편지 공유에 필요해요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF194062),
                    fontSize: 36,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                Container(
                  width: 342,
                  height: 600,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFECF4D6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16.0),
                          child:const Text("Email",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),
                          ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Email',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@')) {
                                  return ("Email을 입력해주세요");
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: (){
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EmailAu(),
                                  ),
                                );
                              },
                              child: Text('이메일 인증',
                              style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontFamily: 'Gowun Dodum',
                              fontWeight: FontWeight.w400,),),
                              style: ElevatedButton.styleFrom(
                              primary:  Color(0xCC2D9596),
                              elevation: 4, ),
                            ),
                          ),
                          Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16.0),
                          child: const Text("닉네임",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),
                          ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: '닉네임',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ("닉네임을 입력해주세요");
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: (){
                                _checkNicknameUniqueness();
                              },
                              child: Text('Check',
                              style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontFamily: 'Gowun Dodum',
                              fontWeight: FontWeight.w400,),),
                              style: ElevatedButton.styleFrom(
                              primary:  Color(0xCC2D9596),
                              elevation: 4, ),
                            ),
                          ),
                          
                          
                          Container(
                            alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16.0),
                          child: const Text("비밀번호",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),
                          ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: '비밀번호',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length <= 9) {
                                  return ("비밀번호는 9자 이상이어야 합니다");
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16.0),
                          child: const Text("나이",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),
                          ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _ageController,
                              decoration: InputDecoration(
                                hintText: '나이',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ("나이를 입력해주세요");
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16.0),
                          child: const Text("성별",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),
                          ),
                          ),
                          SizedBox(
                            width: 300,
                            child: DropdownButtonFormField<String?>(
                                decoration: InputDecoration(
                                labelText: '성별',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onChanged: (String? gender) {
                                _sex = gender;
                              },
                              items: [null, "남", "여", "중"].map<DropdownMenuItem<String?>>((String? sex) {
                                return DropdownMenuItem<String?>(
                                  value: sex,
                                  child: Text({"남": "남자", "여": "여자", "중": "중성"}[sex] ?? "비공개"),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "성별을 선택해주세요";
                                }
                                return null;
                              },
                            ),

                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16.0),
                          child: const Text("직업",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),
                          ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _jobController,
                              decoration: InputDecoration(
                                hintText: '직업',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ("직업을 입력해주세요");
                                }
                                return null;
                              },
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16.0),
                          child: const Text("나라",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),
                          ),
                          ),
                          SizedBox(
                            width: 300,
                            child: DropdownButtonFormField<String?>(
                                decoration: InputDecoration(
                                labelText: '나라',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onChanged: (String? country) {
                                _location = country;
                              },
                              items: [
                                null,
                                "USA",
                                "Korea",
                                "Japan",
                                "Vietnam",
                                "China",
                                "France",
                                "Spain",
                                "Germany",
                                "Italy",
                                "Thailand",
                                ].map<DropdownMenuItem<String?>>((String? location) {
                                return DropdownMenuItem<String?>(
                                  value: location,
                                  child: Text({
                                    "USA": "USA",
                                    "Korea": "Republic of Korea",
                                    "Japan": "Japan",
                                    "Vietnam":"Vietnam",
                                    "China":"China",
                                    "France":"France",
                                    "Spain":"Spain",
                                    "Germany":"Germany",
                                    "Italy":"Italy",
                                    "Thailand":"Thailand",
                                    }[location] ?? "비공개"),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "나라를 선택해주세요";
                                }
                                return null;
                              },
                            ),

                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 16.0),
                          child: const Text("Language",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),
                          ),
                          ),
                          SizedBox(
                            width: 300,
                            child: DropdownButtonFormField<String?>(
                                decoration: InputDecoration(
                                labelText: '언어',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onChanged: (String? languages) {
                                _language = languages;
                              },
                              items: [
                                null,
                                "English",
                                "Korean",
                                "Japanese",
                                "Vietnamese",
                                "Chinese1",//번체
                                "Chinese2",//간체
                                "French",
                                "Spanish",
                                "German",
                                "Italian",
                                "Thai",
                                ].map<DropdownMenuItem<String?>>((String? language) {
                                return DropdownMenuItem<String?>(
                                  value: language,
                                  child: Text({
                                    "English": "English",
                                    "Korean": "한국어",
                                    "Japanese": "日本語",
                                    "Vietnamese":"Tiếng Việt",
                                    "Chinese1":"漢文",
                                    "Chinese2":"汉文",
                                    "French":"Français",
                                    "Spanish":"Español",
                                    "German":"Deutsch",
                                    "Italian":"Italiano",
                                    "Thai":"แบบไทย",
                                    }[language] ?? "비공개"),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "언어를 선택해주세요";
                                }
                                return null;
                              },
                            ),

                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 300,
                  child: ElevatedButton(
                            onPressed: () {
                              if(widget.isEmailVerified){
                                if (_formKey.currentState!.validate()) {
                                  userProvider.email = _emailController.text;
                                  userProvider.name = _nameController.text;
                                  userProvider.password =
                                      _passwordController.text;

                                  String ageText = _ageController.text;
                                  if (ageText.isNotEmpty) {
                                    int? age = int.tryParse(ageText);
                                    if (age != null) {
                                      userProvider.age = age;
                                    } else {
                                      print('Invalid age format');
                                    }
                                  } else {
                                    print('Age is required');
                                  }

                                  userProvider.sex = _sex ?? "";
                                  userProvider.job = _jobController.text;
                                  userProvider.location =
                                      _location ?? "";
                                  userProvider.language =
                                      _language ?? "";

                                sendUserServer();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Loginpage(),
                                  ),
                                );
                              }
                              }else{
                                _showSnackBar('이메일 인증을 먼저 완료해주세요.');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary:  Color(0xCC2D9596),
                              elevation: 4, // 그림자 설정
                            ),
                            child: const Text("회원가입",
                                style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontFamily: 'Gowun Dodum',
                                fontWeight: FontWeight.w400,),
                          ),
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
