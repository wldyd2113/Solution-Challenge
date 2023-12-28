import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytodaysdiary/DB/userProvider.dart';
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
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
      appBar: AppBar(
        title: const Text("Join"),
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return ("Please enter your email");
                        }
                        return null;
                      },
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ("Please enter your Name");
                        }
                        return null;
                      },
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ("Please enter your Phone Number");
                        }
                        return null;
                      },
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.length <= 9) {
                          return ("Password must be at least 9 characters");
                        }
                        return null;
                      },
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        hintText: 'Age',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ("Please enter your Age");
                        }
                        return null;
                      },
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                    TextFormField(
                      controller: _sexController,
                      decoration: const InputDecoration(
                        hintText: 'Sex',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ("Please enter your Gender");
                        }
                        return null;
                      },
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                    TextFormField(
                      controller: _jobController,
                      decoration: const InputDecoration(
                        hintText: 'Job',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ("Please enter your Occupation");
                        }
                        return null;
                      },
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                    TextFormField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        hintText: 'Location',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ("Please enter your Location");
                        }
                        return null;
                      },
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                    TextFormField(
                      controller: _languageController,
                      decoration: const InputDecoration(
                        hintText: 'Language',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return ("Please enter your Language");
                        }
                        return null;
                      },
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 30.0)),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          userProvider.email = _emailController.text;
                          userProvider.name = _nameController.text;
                          userProvider.phone = int.tryParse(_phoneController.text) ?? 0; // Convert phone to int
                          userProvider.password = _passwordController.text;

                          // Additional checks for parsing age
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

                          userProvider.sex = _sexController.text;
                          userProvider.job = _jobController.text;
                          userProvider.location = _locationController.text;
                          userProvider.language = _languageController.text;

                          sendUserServer();
                        }
                      },
                      child: Text("Join"),
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
