import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mytodaysdiary/loginViews/home_sreen.dart';
import 'package:mytodaysdiary/loginViews/joinPage.dart';

FlutterSecureStorage storage = const FlutterSecureStorage();
String REFRESH_TOKEN_KEY = 'refreshToken';
String ACCESS_TOKEN_KEY = 'accessToken';
String iosip = 'http://127.0.0.1:3000/auth/login';
String androidip = 'http://10.0.2.2:3000/auth/login';




class Loginpage extends StatefulWidget {
  @override
  _LoginpageState createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final dio = Dio();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(hintText: 'Email'),
                validator: (value){
                  if(value == null || value.isEmpty || !value.contains('@')){
                    return("Please enter your email");
                  }
                  return null;
                },
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
              TextFormField(
                controller: _passwordController, // 사용자가 입력한 비밀번호 값을 가져오기 위해 컨트롤러를 할당합니다.
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
                validator: (value){
                  if(value==null || value.length<=9){
                    return("Password must be at least 9 characters");
                  }
                  return null;
                },
            ),
            ElevatedButton(
              onPressed: () async{
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data'),),
                  );
                }
                try{
                  String user_id = _emailController.text;
                  String user_pw = _passwordController.text;
                  //ID, 비밀번호를 포함한 문자열 생성
                  final rawString = '$user_id:$user_pw';

                  Codec<String, String> stringTobase64 = utf8.fuse(base64);
                  String token  = stringTobase64.encode(rawString);

                  //dio을 사용하여 서버에서 POST 요청
                  final response = await dio.post(
                    '$iosip',
                    options: Options(
                      headers: {'authorization': 'Basic $token',},
                    ),
                  );
                  //서버에서 refreshToken, accessToken 가져오기
                  final refreshToken = response.data['refreshToken'];
                  final accessToken = response.data['accessToken'];
                  await storage.write(
                    key: REFRESH_TOKEN_KEY,
                    value: refreshToken,
                  );
                  await storage.write(
                    key: ACCESS_TOKEN_KEY,
                    value: accessToken,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Loginpage())
                  );
                } catch(e){
                  print(e);
                }
              },
              child: const Text('Sign In'),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
                  TextButton(onPressed: (){
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => JoinPage())
                  );
                  }, 
                  child: Text(
                    "회원가입", 
                    style: TextStyle(color:Colors.black),),),
                  TextButton(onPressed: (){
                    
                  }, 
                  child: 
                  Text("ID찾기",style: TextStyle(color: Colors.black),),),
                  TextButton(onPressed:(){

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
    );
  }
}
