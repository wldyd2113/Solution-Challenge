import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  String _emailId = ''; //id
  String _password = ''; //password
  String _age = ''; //나이
  String _gender = ''; // 성별
  String _occupation = '';//직업
  String _area = ''; //지역
  String _language = ''; //언어

  String get emailId => _emailId;
  String get age => _age;
  String get password => _password;
  String get gender => _gender;
  String get occupation => _occupation;
  String get area => _area;
  String get language => _language;

    void set email(String input_emailId) {
      _emailId = input_emailId;
    notifyListeners();
  }
    void set age(String input_age) {
      _age = input_age;
    notifyListeners();
  }

    void set password(String input_password) {
      _password = input_password;
      notifyListeners();
  }
    void set gender(String input_gender) {
      _gender = input_gender;
      notifyListeners();
  }
    void set occupation(String input_occupation) {
      _occupation = input_occupation;
      notifyListeners();
  }
    void set area(String input_area) {
      _area = input_area;
      notifyListeners();
  }
    void set language(String input_language) {
      _language = input_language;
      notifyListeners();
  }

}

