import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9AD0C2),
      appBar: AppBar(
        title: Text('Password 찾기'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 500,
            height: 500,
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
                    onPressed: () {
                      _sendVerificationEmail();
                    },
                    child: Text(
                      '이메일로 인증 코드 받기',
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
                    onPressed: _isVerificationSuccess && !_isPasswordSent ?  _temporary: null,
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

  void _sendVerificationEmail() async {
    final String apiUrl = 'http://localhost:8080/mail/auth';

    String email = _emailController.text;

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
       
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        // 인증 코드를 성공적으로 보냈을 때의 로직 추가
      } else {
        print('서버 응답 에러: ${response.statusCode}');
        print('에러 내용: ${response.body}');
      }
    } catch (error) {
      print('에러 발생: $error');
    }
  }

  void _verifyEmail() async {
    final String apiUrl = 'http://localhost:8080/mail/authCheck';

    String email = _emailController.text;
    String verificationCode = _verificationCodeController.text;

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'authNum': verificationCode}),
      );

      if (response.statusCode == 200) {
        // 이메일 인증이 성공적으로 확인되었을 때의 로직 추가
        setState(() {
          _isVerificationSuccess = true;
        });
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
      // 서버에서 임시 비밀번호를 성공적으로 가져왔을 때의 로직 추가
      String temporaryPassword = jsonDecode(response.body)['temporaryPassword'];
      
      // 임시 비밀번호를 서버로 전송
      _sendTemporaryPassword(temporaryPassword);
    } else {
      print('서버 응답 에러: ${response.statusCode}');
      print('에러 내용: ${response.body}');
    }
  } catch (error) {
    print('에러 발생: $error');
  }
}

void _sendTemporaryPassword(String temporaryPassword) async {
  final String apiUrl = 'http://localhost:8080/mail/temporaryPassword';

  String email = _emailController.text;

  try {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'temporaryPassword': temporaryPassword}),
    );

    if (response.statusCode == 200) {
      // 임시 비밀번호를 성공적으로 이메일로 보냈을 때의 로직 추가
      setState(() {
        _isPasswordSent = true;
      });
    } else {
      print('서버 응답 에러: ${response.statusCode}');
      print('에러 내용: ${response.body}');
    }
  } catch (error) {
    print('에러 발생: $error');
  }
}


}
