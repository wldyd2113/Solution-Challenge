import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class IdFindPage extends StatefulWidget {
  @override
  _IdFindPageState createState() => _IdFindPageState();
}

class _IdFindPageState extends State<IdFindPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _foundId = ''; // 찾아진 아이디를 저장할 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9AD0C2),
      appBar: AppBar(
        title: Text('이메일 찾기'),
      ),
      body:
      Center(
        child:Container(
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
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'NickName',
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),)
              ),
            ),

            ElevatedButton(
              onPressed: () {
                _findId();
              },
              
              child: 
              const Text('이메일 찾기',
              style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontFamily: 'Gowun Dodum',
              fontWeight: FontWeight.w400,),
              ),
              style: ElevatedButton.styleFrom(
              primary:  Color(0xCC2D9596),
              elevation: 4,)
            ),
            const SizedBox(height: 20),
            Text('찾아진 이메일: $_foundId',
              style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Gowun Dodum',),),
          ],
        ),
      ),
      ),
    );
  }

void _findId() async {
  // TODO: 실제 서버 엔드포인트 및 로직에 맞게 수정하세요
  final String apiUrl = 'http://localhost:8080/signup/user';

  // 이름과 전화번호 값을 가져옴
  String name = _nameController.text;
  String phone = _phoneController.text;

  try {
    // 서버로 POST 요청을 보내 아이디를 찾음
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'name': name, 'phone': phone}),
    );

    if (response.statusCode == 200) {
      // 성공적으로 응답을 받으면 찾아진 아이디를 변수에 저장
      setState(() {
        _foundId = response.body;
      });
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
}

