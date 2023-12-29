import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mytodaysdiary/DB/userProvider.dart';
import 'package:mytodaysdiary/MysettingViews/passwordChange.dart';
import 'package:mytodaysdiary/diaryViews/calendar.dart';
import 'package:provider/provider.dart';

class MySetting extends StatefulWidget {
  @override
  _MySettingState createState() => _MySettingState();
}

class _MySettingState extends State<MySetting> {
  int _selectedIndex = 1;
  late String email = '';
  late String name = '';
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  Future<void> fetchData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await http.get(Uri.parse('')); // TODO: 서버 주소 입력

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        userProvider.email = data['email'];
        userProvider.name = data['name'];
        setState(() {
          email = userProvider.email;
          name = userProvider.name;
        });
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  final List<Widget> _widgetOptions = <Widget>[
    Calendar(),
    MySetting(),
  ];

  File? _image;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  Future _getImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // 변경 비밀번호 버튼이 눌렸을 때 호출되는 메서드
  void onPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PasswordChangeDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(
                "My Info",
                style: TextStyle(fontSize: 30),
              ),
            ),
            _image != null
                ? Image.file(
                    _image!,
                    height: 100,
                    width: 100,
                  )
                : Container(),
            InkWell(
              onTap: () {
                _getImageFromGallery();
              },
              child: Container(
                margin: EdgeInsets.all(60),
                padding: EdgeInsets.all(50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Text("My Photos"),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("Name: $name"),
                    ],
                  ),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                  Row(
                    children: <Widget>[
                      Text("Email: $email"),
                    ],
                  ),
                  Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                  Row(
                    children: <Widget>[
                      Text("Password: "),
                      ElevatedButton(
                        onPressed: onPressed,
                        child: Text("Password Change"),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'My'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped,
      ),
    );
  }
}
