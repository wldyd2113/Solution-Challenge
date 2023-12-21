import 'package:flutter/material.dart';
import 'package:mytodaysdiary/loginViews/login.dart';
import 'package:provider/provider.dart';
import 'package:mytodaysdiary/DB/userProvider.dart';
import 'package:http/http.dart' as http;

/// 회원가입 화면
class JoinPage extends StatefulWidget {
  @override
  _JoinPageState createState() => _JoinPageState();
}
 
class _JoinPageState extends State<JoinPage> {

  final TextEditingController _emailIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _sendUserServer(){
    
  }


  @override
    Widget build(BuildContext context) {
      final userProvider =  Provider.of<UserProvider>(context, listen: false);

      void _sendUserServer(){
        /*
        서버 받아서 서버에 전송
        http.post('', body: {
        'emailId': userProvider.emailId,
        'password': userProvider.password,
        'age': userProvider.age,
        'gender': userProvider.gender,
        'occupation': userProvider.occupation,
        'area': userProvider.area,
        'language': userProvider.language,
        
      });
      */
      }

    return Scaffold(
      body: SafeArea(
        child: Column(children: <Widget>[
          Container(
            alignment: Alignment.center,
            child:Text('Join',style: TextStyle(fontSize: 30),),
          ),
                        Padding(padding: const EdgeInsets.symmetric(vertical: 30.0),),
            Form(
                  key: _formKey,
                  child: Column(children: [
                  TextFormField(
                  controller: _emailIdController,
                  decoration: const InputDecoration(
                    hintText: 'Email',),
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
                decoration: const InputDecoration(
                  hintText: 'Password',),
                validator: (value){
                  if(value==null || value.length<=9){
                    return("Password must be at least 9 characters");
                  }
                  return null;
                },
            ),
          Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
            TextFormField(
              controller: _ageController,
              obscureText: true,
              decoration: const InputDecoration(
                  hintText: 'Age',)
            ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
            TextFormField(
                  controller: _genderController,
                  decoration: const InputDecoration(
                    hintText: 'Gender',),
              ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
            TextFormField(
                  controller: _occupationController,
                  decoration: const InputDecoration(
                    hintText: 'Occupation',),
              ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
            TextFormField(
                  controller: _areaController,
                  decoration: const InputDecoration(
                    hintText: 'Area',),
              ),
            Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
            TextFormField(
                  controller: _languageController,
                  decoration: const InputDecoration(
                    hintText: 'Language',),
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 30.0),
              ),
              ElevatedButton(onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        userProvider.email= _emailIdController.text;
                        userProvider.password = _passwordController.text;
                        userProvider.age = _ageController.text;
                        userProvider.gender = _genderController.text;
                        userProvider.occupation = _occupationController.text;
                        userProvider.area = _areaController.text;
                        userProvider.language = _languageController.text;

                        _sendUserServer();
                      }
                    Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => Loginpage())
                  );
              }, child: Text("Join")),
              ],
              ),
            ),
        ])
        ),
    );
    }

}