import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mytodaysdiary/DB/userProvider.dart';
import 'package:mytodaysdiary/MysettingViews/passwordChange.dart';
import 'package:mytodaysdiary/diaryViews/calendar.dart';
import 'package:mytodaysdiary/loginViews/login.dart';
import 'package:provider/provider.dart';

class MySetting extends StatefulWidget {
  @override
  _MySettingState createState() => _MySettingState();
}

class _MySettingState extends State<MySetting> {
  XFile? _pickedFile;
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
    final response = await http.get(
      Uri.parse('http://localhost:8080/user2'),
      headers: {'Authorization': 'Bearer ${userProvider.accessToken}'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('Server Response: $data');

      // 서버 응답 데이터의 예상 형식에 따라 필요한 로직 추가
      if (data.containsKey('email') && data.containsKey('name')) {
        userProvider.email = data['email'];
        userProvider.name = data['name'];

        setState(() {
          email = userProvider.email;
          name = userProvider.name;
        });

        print('Fetch data successful: $email, $name');
      } else {
        print('Unexpected format in server response');
        // 예상 형식이 아닌 경우 사용자에게 메시지 표시 등의 로직 추가
      }
    } else {
      print('Failed to load data: ${response.statusCode}');
      // 서버 응답이 200이 아닌 경우 사용자에게 메시지 표시 등의 로직 추가
    }
  } catch (error) {
    print('Error: $error');
    // 에러 발생 시에 사용자에게 메시지 표시 등의 로직 추가
  }
}






  final List<Widget> _widgetOptions = <Widget>[
    Calendar(),
    MySetting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _getCameraImage(),
              child: const Text('Take a picture'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 3,
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => _getPhotoLibraryImage(),
              child: const Text('Importing from Library'),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }

  void _getCameraImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
  }

  void _getPhotoLibraryImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    } else {
      if (kDebugMode) {
        print('이미지 선택안함');
      }
    }
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
  void initState() {
    super.initState();
    fetchData(); // initState에서 fetchData 호출
  }

  @override
  Widget build(BuildContext context) {
    final _imageSize = MediaQuery.of(context).size.width / 4;

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
            SizedBox(height: 20,),
            if(_pickedFile == null)
              Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.width,
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: GestureDetector(
                  onTap: (){
                    _showBottomSheet();
                  },
                  child: Center(
                    child: Icon(
                      Icons.account_circle,
                      size: _imageSize,
                    ),
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  width: _imageSize,
                  height: _imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width:2,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    image: DecorationImage(
                      image: FileImage(File(_pickedFile!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
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
                                    Row(
                    children: <Widget>[
                      Text("The number of diaries I've recorded:"),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      ElevatedButton(onPressed: (){
                            Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Loginpage()),
                            );
                      }, child: Text("LogOut"))
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
