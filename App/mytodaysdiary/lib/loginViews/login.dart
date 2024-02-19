import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mytodaysdiary/DB/TokenSave.dart';
import 'package:mytodaysdiary/diaryViews/calendar.dart';
import 'package:mytodaysdiary/loginViews/idFind.dart';
import 'package:mytodaysdiary/loginViews/joinPage.dart';
import 'package:mytodaysdiary/loginViews/pwFind.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final dio = Dio();
  bool remember = false;
  bool switchValue = false;
  String ACCESS_TOKEN_KEY = 'accessToken';
  String iosip = 'http://skhugdsc.duckdns.org/user/login';
  String androidip = 'http://skhugdsc.duckdns.org/user/login';

  @override
  void initState() {
    super.initState();
    _loadRemember();
    _autoLoginCheck();
  }

  Future<void> _handleSignIn() async {
    try {
      String email = _emailController.text;
      String password = _passwordController.text;
      final rawString = '$email:$password';

      Codec<String, String> stringToBase64 = utf8.fuse(base64);
      String token = stringToBase64.encode(rawString);

      final response = await dio.post(
        '$iosip',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
        data: {
          'email': email,
          'password': password,
        },
      );

      print('Server Response: ${response.data}');
      print('Response Format: ${response.headers.value('content-type')}');

      final accessToken = response.data['accessToken'];

      // 토큰 저장만 수행하고 자동 로그인 체크 여부와 관계없이 무조건 로그인 시도
      await TokenStorage.saveToken(accessToken);

      print('토큰이 성공적으로 저장되었습니다!');
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Calendar()));
    } catch (e) {
      if (e is DioError) {
        print('DioError: ${e.response?.statusCode}, ${e.message}');
        print('Response data: ${e.response?.data}');
      } else {
        print('Error: $e');
      }
    }
  }

  void _autoLoginCheck() async {
    String? token = await TokenStorage.getToken();

    if (token != null) {
      try {
        // 토큰 저장만 수행하고 자동 로그인 체크 여부와 관계없이 무조건 로그인 시도
        await TokenStorage.saveToken(token);

        // 아래의 Navigator 코드는 _handleSignIn 안에서 이미 처리되므로 주석 처리
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Calendar()));
      } catch (e) {
        print('Auto-login error: $e');_emailController.text = '';
      }
    }
  }

  void _saveRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', remember);
    if (remember) {
      prefs.setString('rememberedEmail', _emailController.text);
    } else {
      prefs.remove('rememberedEmail');
    }
  }

  void _loadRemember() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      remember = prefs.getBool('rememberMe') ?? false;
      if (remember) {
        _emailController.text = prefs.getString('rememberedEmail') ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 70,),
              SizedBox(
                width: 340,
                height: 100,
                child: Text(
                  '로그인하기',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF194062),
                    fontSize: 40,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      child: SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: '이메일',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: '이메일',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || !value.contains('@')) {
                              return ("이메일을 입력해주세요");
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    ),
                    Container(
                      color: Colors.white,
                      child: SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '비밀번호',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            labelText: '비밀번호',
                          ),
                          validator: (value) {
                            if (value == null || value.length <= 8) {
                              return ("비밀번호는 9자 이상이어야 합니다.");
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      width: 370,
                      height: 70,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                          _handleSignIn();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(204, 62, 153, 250),
                        ),
                        child: const Text(
                          '로그인',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: remember,
                          onChanged: (bool? value) {
                            setState(() {
                              remember = value ?? false;
                              _saveRememberMeStatus();
                            });
                          },
                        ),
                        Text("이메일 기억하기",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF194062),
                            fontSize: 18,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),),
                        Checkbox(
                          value: switchValue,
                          activeColor: CupertinoColors.activeBlue,
                          onChanged: (bool? value) {
                            setState(() {
                              switchValue = value ?? false;
                            });
                            
                          },
                        ),
                        Text("자동로그인",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF194062),
                            fontSize: 18,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),),
                      ],
                    ),
                    SizedBox(height:20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("계정이 없으신가요? ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF2D9596),
                              fontSize: 18,
                              fontFamily: 'Gowun Dodum',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => JoinPage()),
                              );
                            },
                            child: Text(
                              '회원가입',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF194062),
                                fontSize: 18,
                                fontFamily: 'Gowun Dodum',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),

                            ),
                          ),
                        ]

                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => IdFindPage()),
                            );
                          },
                          child: Text("이메일 찾기",
                            style: TextStyle(
                              color: Color(0xFF194062),
                              fontSize: 22,
                              fontFamily: 'Gowun Dodum',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),

                          ),
                        ),
                        Text("l",
                          style: TextStyle(
                            color: Color(0xFF194062),
                            fontSize: 25,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => PwFindPage()),
                            );
                          },
                          child: Text("비밀번호 찾기",
                            style: TextStyle(
                              color: Color(0xFF194062),
                              fontSize: 22,
                              fontFamily: 'Gowun Dodum',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}