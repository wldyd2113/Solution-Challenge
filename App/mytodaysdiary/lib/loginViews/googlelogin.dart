/*
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Loginpage extends StatefulWidget {
  // ...

  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  // ... (기존 코드 유지)

  Future<void> _handleGoogleSignIn(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('$googleSignInUrl/googleSignIn'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        // 서버에서 반환한 토큰을 처리합니다.
        Map<String, dynamic> tokenData = jsonDecode(response.body);
        String accessToken = tokenData['accessToken'];
        String refreshToken = tokenData['refreshToken'];

        // TODO: 토큰을 저장하거나 다른 작업을 수행하세요.
        await TokenStorage.saveToken(accessToken);

        print('토큰이 성공적으로 저장되었습니다!');
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Calendar()));
      } else {
        // 서버에서 오류가 발생한 경우 처리
        print('Failed to sign in with Google. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during Google sign-in: $e');
    }
  }

  Future<String?> performGoogleSignIn() async {
    // TODO: 구글 로그인 로직 구현 및 ID Token 획득
    // 예를 들면, 구글 로그인 패키지 사용 등
    // ...

    // 가상의 ID Token을 반환합니다. 실제로는 로그인 패키지를 사용하여 획득해야 합니다.
    return 'YOUR_GOOGLE_ID_TOKEN';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // ... (기존 코드 유지)

              InkWell(
                onTap: () async {
                  String googleIdToken = await performGoogleSignIn();
                  if (googleIdToken != null) {
                    // 서버에 ID Token 전송 및 토큰 처리
                    await _handleGoogleSignIn(googleIdToken);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/google_logo.png', width: 370,),
                    const SizedBox(width: 10),
                  ],
                ),
              ),

              // ... (기존 코드 유지)
            ],
          ),
        ),
      ),
    );
  }
}
*/