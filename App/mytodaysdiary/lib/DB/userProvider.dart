import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _email = ''; //이메일
  String _name = ''; //닉네임
  String _password = ''; //비밀번호
  String _newpassword = '';//새로운 비밀번호
  late int _age; //나이
  String _sex = ''; //성별
  String _job = ''; //직업
  String _location = ''; //지역
  String _language = ''; //언어


  String get email => _email;
  String get name => _name;
  int get age => _age;
  String get password => _password;
  String get newpassword => _newpassword;
  String get sex => _sex;
  String get job => _job;
  String get location => _location;
  String get language => _language;



  void set email(String input_email) {
    _email = input_email;
    notifyListeners();
  }

  void set name(String input_name) {
    _name = input_name;
    notifyListeners();
  }


  void set age(int input_age) {
    _age = input_age;
    notifyListeners();
  }

  void set password(String input_password) {
    _password = input_password;
    notifyListeners();
  }

  void set newpassword(String input_newpassword) {
    _newpassword = input_newpassword;
    notifyListeners();
  }

  void set sex(String input_sex) {
    _sex = input_sex;
    notifyListeners();
  }

  void set job(String input_job) {
    _job = input_job;
    notifyListeners();
  }

  void set location(String input_location) {
    _location = input_location;
    notifyListeners();
  }

  void set language(String input_language) {
    _language = input_language;
    notifyListeners();
  }
    void logout() {
    email = '';
    name = '';
    notifyListeners();
  }
}