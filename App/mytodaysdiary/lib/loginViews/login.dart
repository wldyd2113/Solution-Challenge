import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mytodaysdiary/DB/tokenData.dart';
import 'package:mytodaysdiary/DB/userProvider.dart';
import 'package:mytodaysdiary/diaryViews/calendar.dart';
import 'package:mytodaysdiary/loginViews/idFind.dart';
import 'package:mytodaysdiary/loginViews/joinPage.dart';
import 'package:mytodaysdiary/loginViews/pwFind.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final dio = Dio();
  bool remember = false;
  bool switchValue = false;

  @override
  void initState() {
    super.initState();
    _loadRemember();
    _autoLoginCheck();
  }

  void _autoLoginCheck() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      try {
        Provider.of<UserProvider>(context, listen: false).accessToken = token;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Calendar()));
      } catch (e) {
        print('Auto-login error: $e');
      }
    }
  }

  void _setAutoLogin(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  void _delAutoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
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

  void _saveRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberMe', remember);
    if (remember) {
      prefs.setString('rememberedEmail', _emailController.text);
    } else {
      prefs.remove('rememberedEmail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF4D6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  "반갑습니다!",
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.black,
                    fontFamily: 'Gowun Dodum',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 30.0),
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
                      child: SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty || !value.contains('@')) {
                              return ("Please enter your email");
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
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: SizedBox(
                        width: 350,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                          ),
                          validator: (value) {
                            if (value == null || value.length <= 9) {
                              return ("Password must be at least 9 characters");
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                    SizedBox(
                      width: 300,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
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
                                  'authorization': 'Basic $token',
                                  'Content-Type': 'application/json',
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

                            // 토큰을 UserProvider에 저장
                            Provider.of<UserProvider>(context, listen: false).accessToken = accessToken;

                            // 자동 로그인 여부에 따라 토큰 저장
                            if (switchValue) {
                              _setAutoLogin(accessToken);
                            } else {
                              _delAutoLogin();
                            }

                            // 이동할 페이지 (예: Calendar 페이지)
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Calendar()));
                          } catch (e) {
                            if(e is DioError){
                            print('DioError: ${e.response?.statusCode}, ${e.message}');
                            print('Response data: ${e.response?.data}');
                            }
                            else{

                            }print('Error: $e');

                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xCC2D9596),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                    InkWell(
                      onTap: () async {
                        final _googleSignIn = GoogleSignIn();
                        final googleAccount = await _googleSignIn.signIn();

                        if (googleAccount != null) {
                          final googleAuth = await googleAccount.authentication;

                          if (googleAuth != null &&
                              googleAuth.accessToken != null &&
                              googleAuth.idToken != null) {
                            try {
                              await FirebaseAuth.instance.signInWithCredential(
                                GoogleAuthProvider.credential(
                                  idToken: googleAuth.idToken,
                                  accessToken: googleAuth.accessToken,
                                ),
                              );
                              print("success");
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Calendar()));
                            } on FirebaseException catch (e) {
                              print('Firebase 에러: $e');
                            } catch (e) {
                              print('일반 에러: $e');
                            }
                          } else {
                            print('에러가 발생했습니다.');
                          }
                        } else {
                          print('Google 계정이 null입니다.');
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/google_logo.png', width: 300,),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
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
                        Text("ID REMEBER"),
                        CupertinoSwitch(
                          value: switchValue,
                          activeColor: CupertinoColors.activeBlue,
                          onChanged: (bool? value) {
                            setState(() {
                              switchValue = value ?? false;
                            });
                          },
                        ),
                        Text("Auto Login"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => JoinPage()),
                            );
                          },
                          child: Text(
                            "회원가입",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => IdFindPage()),
                            );
                          },
                          child: Text("ID찾기", style: TextStyle(color: Colors.black)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => PwFindPage()),
                            );
                          },
                          child: Text("Password찾기", style: TextStyle(color: Colors.black)),
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
