import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mytodaysdiary/DB/tokenData.dart';
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
  final _formKey = GlobalKey<FormState>();
  final dio = Dio();
  bool remember = false;
  bool swithchValue = false;
  //bool isToken = false;
  @override
  void initState(){
    super.initState();
    _loadRemeber();
    //_autoLoginCheck();
  }

  //자동 로그인 설정
  void _setAutoLogin(String token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  //자동 로그인 해제
  void _delAutiLogin() async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }


    _loadRemeber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      remember = prefs.getBool('rememberMe') ?? false;
      if (remember) {
        _emailController.text = prefs.getString('rememberedEmail') ?? '';
      }
    });
  }
    _saveRememberMeStatus() async {
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
      body: SafeArea(
        child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: 
              Text("Login",style: TextStyle(fontSize: 50, color:Colors.black),),
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              ),
              Form(
                key: _formKey,
                child: Column(children: [
                  SizedBox(
                    width: 350,
                child: TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  ),
                validator: (value){
                  if(value == null || value.isEmpty || !value.contains('@')){
                    return("Please enter your email");
                  }
                  return null;
                },
            ),),
            Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
              SizedBox(
                width: 350,
              child: TextFormField(
                controller: _passwordController, // 사용자가 입력한 비밀번호 값을 가져오기 위해 컨트롤러를 할당합니다.
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(),
                  labelText: 'Password',),
                validator: (value){
                  if(value==null || value.length<=9){
                    return("Password must be at least 9 characters");
                  }
                  return null;
                },
            ),),
            SizedBox(
              width: 100,
            child: ElevatedButton(
              onPressed: () async{
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data'),),
                  );
                }
                try{
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  //ID, 비밀번호를 포함한 문자열 생성
                  final rawString = '$email:$password';

                  Codec<String, String> stringTobase64 = utf8.fuse(base64);
                  String token  = stringTobase64.encode(rawString);

                  //dio을 사용하여 서버에서 POST 요청
                  final response = await dio.post(
                    '$iosip',
                    options: Options(
                      headers: {'authorization': 'Basic $token',
                      'Content-Type': 'application/json',},
                    ),
                      data: {
                        'email': email,
                        'password': password,
                      },
                  );
                  //서버에서 refreshToken, accessToken 가져오기
                  final accessToken = response.data['accessToken'];

                  await storage.write(
                    key: ACCESS_TOKEN_KEY,
                    value: accessToken,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Calendar())
                  );
                } catch(e){
                  print(e);
                }
              },
              child: const Text('Sign In',
              style: TextStyle(color:Colors. black),),
            ),
                ),
            InkWell(onTap: ()async{
              final _googlesSignIn = GoogleSignIn();
              final googleAccount = await _googlesSignIn.signIn();

              if (googleAccount != null) {
                final googleAuth = await googleAccount.authentication;

                if (googleAuth != null && googleAuth.accessToken != null && googleAuth.idToken != null) {
                  try {
                    await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(
                      idToken: googleAuth.idToken,
                      accessToken: googleAuth.accessToken,
                    ));
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
            child:Row(
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
                  Checkbox(value: remember, 
                  onChanged: (bool? value){
                    setState(() {
                      remember = value ?? false;
                      _saveRememberMeStatus();
                    });
                  },
                  ),
                  Text("ID REMEBER"),
                  CupertinoSwitch(value: swithchValue, 
                  activeColor: CupertinoColors.activeBlue,
                  onChanged: (bool? value){
                    setState(() {
                      swithchValue = value ?? false;
                    });
                  }),
                  Text("Auto Login"),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: (){
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => JoinPage())
                  );
                  }, 
                  child: Text(
                    "회원가입", 
                    style: TextStyle(color:Colors.black),),),
                    
                  TextButton(onPressed: (){
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => IdFindPage())
                  );
                  }, 
                  child: 
                  Text("ID찾기",style: TextStyle(color: Colors.black),),),
                  TextButton(onPressed:(){
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => PwFindPage())
                  );
                  }, child: 
                  Text("Password찾기", style: TextStyle(color: Colors.black),),),
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
