import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PwFindPage extends StatefulWidget {
  @override
  _PwFindPageState createState() => _PwFindPageState();
}

class _PwFindPageState extends State<PwFindPage> {
  final TextEditingController _emailController = TextEditingController();
  String _foundPw = ''; // 찾아진 password를 저장할 변수
  String _verificationCode = ''; // 이메일에서 받아온 인증 코드

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password 찾기'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: '이메일',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendVerificationEmail();
              },
              child: Text('이메일로 인증 코드 받기'),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: '인증 코드',
              ),
              onChanged: (value) {
                _verificationCode = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _verifyEmail();
              },
              child: Text('이메일 인증 확인'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _findPw();
              },
              child: Text('비밀번호 찾기'),
            ),
            SizedBox(height: 20),
            Text('찾아진 비밀번호: $_foundPw'),
          ],
        ),
      ),
    );
  }

  // 이메일로 인증 코드 보내기
  void _sendVerificationEmail() async {
    final String apiUrl = 'https://example.com/api/send_verification_email';

    String email = _emailController.text;

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {'email': email},
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

  // 이메일 인증 확인
  void _verifyEmail() async {
    final String apiUrl = 'https://example.com/api/verify_email';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {'email': _emailController.text, 'code': _verificationCode},
      );

      if (response.statusCode == 200) {
        // 이메일 인증이 성공적으로 확인되었을 때의 로직 추가
      } else {
        print('서버 응답 에러: ${response.statusCode}');
        print('에러 내용: ${response.body}');
      }
    } catch (error) {
      print('에러 발생: $error');
    }
  }

  // 비밀번호 찾기 로직
  void _findPw() async {
    final String apiUrl = 'https://example.com/api/find_password';

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: {'email': _emailController.text},
      );

      if (response.statusCode == 200) {
        // 비밀번호를 성공적으로 찾았을 때의 로직 추가
        setState(() {
          _foundPw = response.body;
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
