import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytodaysdiary/DB/userProvider.dart';
import 'package:mytodaysdiary/loginViews/login.dart';
import 'package:provider/provider.dart';

class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  String? _sex; // 추가: 선택된 성별을 저장하는 변수

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
          Uri.parse('http://localhost:8080/signup/user'), // 서버의 실제 엔드포인트로 수정
          headers: {
            'Content-Type': 'application/json',
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
          Uri.parse('http://localhost:8080/signup/user'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': userProvider.email,
            'name': userProvider.name,
            'phone': userProvider.phone.toString(),
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
          print('Failed with status code: ${response.statusCode}');
          // 여기서 사용자에게 회원가입 실패 메시지를 보여줄 수 있습니다.
        }
      } catch (error) {
        // 예외 발생 시 처리
        print('Error: $error');
        // 여기서 사용자에게 오류 메시지를 보여줄 수 있습니다.
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFF9AD0C2),
      appBar: AppBar(
        title: const Text("Join"),
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
                          
                          const Text("Email",
                          style: TextStyle(  
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
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
                                  return ("Please enter your email");
                                }
                                return null;
                              },
                            ),
                          ),
                          
                          const Text("NickName",
                          style: TextStyle(  
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                hintText: 'NickName',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ("Please enter your NickName");
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
                          const Text("Phone Number",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                hintText: 'Phone Number',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ("Please enter your Phone Number");
                                }
                                return null;
                              },
                            ),
                          ),
                          const Text("Password",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.length <= 9) {
                                  return ("Password must be at least 9 characters");
                                }
                                return null;
                              },
                            ),
                          ),
                          const Text("Age",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _ageController,
                              decoration: InputDecoration(
                                hintText: 'Age',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ("Please enter your Age");
                                }
                                return null;
                              },
                            ),
                          ),
                          const Text("Gender",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),),
                          SizedBox(
                            width: 300,
                            child: DropdownButtonFormField<String?>(
                                decoration: InputDecoration(
                                labelText: 'Gender',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onChanged: (String? gender) {
                                _sex = gender;
                              },
                              items: [null, "M", "F", "T"].map<DropdownMenuItem<String?>>((String? sex) {
                                return DropdownMenuItem<String?>(
                                  value: sex,
                                  child: Text({"M": "Male", "F": "Female", "T": "Transgender"}[sex] ?? "비공개"),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your Gender";
                                }
                                return null;
                              },
                            ),

                          ),
                          const Text("Job",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _jobController,
                              decoration: InputDecoration(
                                hintText: 'Job',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ("Please enter your Job");
                                }
                                return null;
                              },
                            ),
                          ),
                          const Text("Country",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _locationController,
                              decoration: InputDecoration(
                                hintText: 'Country',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ("Please enter your Country");
                                }
                                return null;
                              },
                            ),
                          ),
                          const Text("Language",
                          style: TextStyle(
                          color: Color(0xFF194062),
                          fontSize: 20,
                          fontFamily: 'Gowun Dodum',
                          fontWeight: FontWeight.w400,
                          ),),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              controller: _languageController,
                              decoration: InputDecoration(
                                hintText: 'Language',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return ("Please enter your Language");
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
                              if (_formKey.currentState!.validate()) {
                                userProvider.email = _emailController.text;
                                userProvider.name = _nameController.text;
                                userProvider.phone = _phoneController.text;
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
                                    _locationController.text;
                                userProvider.language =
                                    _languageController.text;

                                sendUserServer();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Loginpage(),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary:  Color(0xCC2D9596),
                              elevation: 4, // 그림자 설정
                            ),
                            child: const Text("Join",
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
