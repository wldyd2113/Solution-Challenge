import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytodaysdiary/loginViews/login.dart';

class PwFindPage extends StatefulWidget {
  @override
  _PwFindPageState createState() => _PwFindPageState();
}

class _PwFindPageState extends State<PwFindPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _verificationCodeController = TextEditingController();
  String _foundPw = '';
  bool _isVerificationSuccess = false;
  bool _isPasswordSent = false;
  bool _isTimerRunning = false;

  late Timer _countdownTimer;
  int _remainingTime = 180;

  void _sendVerificationEmail() async {
    final String apiUrl = 'http://localhost:8080/mail/auth';

    String email = _emailController.text;

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
          setState(() {
          _isTimerRunning = true; // 타이머 시작
        });

        _showSnackBar('인증 코드가 이메일로 전송되었습니다.');
        _startCountdownTimer();
      } else {
        print('서버 응답 에러: ${response.statusCode}');
        print('에러 내용: ${response.body}');
      }
    } catch (error) {
      print('에러 발생: $error');
    }
  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownTimer != null) {
        setState(() {
          _remainingTime--;
          if (_remainingTime == 0) {
            _countdownTimer.cancel();
            setState(() {
              _isTimerRunning = false; // 타이머 중지
            });
          }
        });
      }
    });
  }

  void _verifyEmail() async {
    final String apiUrl = 'http://localhost:8080/mail/authCheck';

    String email = _emailController.text;
    String verificationCode = _verificationCodeController.text;

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'email': email, 'authNum': verificationCode}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isVerificationSuccess = true;
        });
        _showSnackBar('이메일 인증이 성공적으로 확인되었습니다.');
        _countdownTimer.cancel();
      } else {
        print('서버 응답 에러: ${response.statusCode}');
        print('에러 내용: ${response.body}');
      }
    } catch (error) {
      print('에러 발생: $error');
    }
  }

  void _temporary() async {
    final apiUrl = "http://localhost:8080/user/password/${_emailController.text}";

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        String temporaryPassword = response.body;

        // Show a confirmation dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('임시 비밀번호 전송'),
              content: Text('임시 비밀번호가 이메일로 전송되었습니다.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                    _navigateToLoginScreen(); // Navigate to the login screen
                  },
                  child: Text('완료'),
                ),
              ],
            );
          },
        );
      } else {
        print('서버 응답 에러: ${response.statusCode}');
        print('에러 내용: ${response.body}');
      }
    } catch (error) {
      print('에러 발생: $error');
    }
  }

  void _navigateToLoginScreen() {
    // Navigate to the login screen using Navigator
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Loginpage()), // Replace LoginScreen with your actual login screen class
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9AD0C2),
      appBar: AppBar(
        title: Text('비밀번호 찾기'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 340,
            height: 360,
            decoration: ShapeDecoration(
              color: const Color(0xFFECF4D6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: '이메일',
                  ),
                ),
                  SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: _isTimerRunning ? null : _sendVerificationEmail,
                    child: Text(
                      _isTimerRunning
                          ? '$_remainingTime 초 후에 재시도'
                          : '이메일로 인증 코드 받기',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontFamily: 'Gowun Dodum',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xCC2D9596),
                      elevation: 4,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _verificationCodeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelText: '인증 코드',
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: _isVerificationSuccess ? null : _verifyEmail,
                    child: const Text(
                      '이메일 인증 확인',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontFamily: 'Gowun Dodum',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xCC2D9596),
                      elevation: 4,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: ElevatedButton(
                    onPressed: _isVerificationSuccess && !_isPasswordSent ? _temporary : null,
                    child: const Text(
                      '임시 비밀번호 발급받기',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontFamily: 'Gowun Dodum',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xCC2D9596),
                      elevation: 4,
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
