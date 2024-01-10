import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytodaysdiary/DB/diaryProvider.dart';
import 'package:mytodaysdiary/DB/userProvider.dart';
import 'package:mytodaysdiary/MysettingViews/mySetting.dart';
import 'package:mytodaysdiary/diaryViews/SendDiary.dart';
import 'package:mytodaysdiary/diaryViews/calendar.dart';
import 'package:provider/provider.dart';


class MyDiary extends StatefulWidget {
  @override
  _MyDiaryState createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  bool happy = true;
  bool sad = false;
  bool angry = false;
  bool soso = false;
  late List<bool> isSelected;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _myDiaryController = TextEditingController();
  final TextEditingController _receiverDiaryController = TextEditingController();
  int _selectedIndex = 0;

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
  @override
  void initState() {
    isSelected = [happy, sad, angry, soso];
    super.initState();
  }

  void toggleSelect(int value) {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    setState(() {
      for (int i = 0; i < isSelected.length; i++) {
        isSelected[i] = (i == value);
      }
    });
    switch (value) {
      case 0:
        diaryProvider.emotion = 'Happy';
        break;
      case 1:
        diaryProvider.emotion = 'Sad';
        break;
      case 2:
        diaryProvider.emotion = 'Angry';
        break;
      case 3:
        diaryProvider.emotion = 'So-so';
        break;
    }
  }

Future<void> sendUserServer() async {
  final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  


  try {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/posts/save'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'myDiary': diaryProvider.myDiary,
        'emotion': diaryProvider.emotion,
        'currentDate': DateTime.now().toString(),
      }),
    );

    if (response.statusCode == 200) {
      print('Success: ${response.body}');
    } else {
      print('Failed with status code: ${response.statusCode}');
    }
  } catch (error) {
    print('Error: $error');
  }
}



  @override
  Widget build(BuildContext context) {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFECF4D6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF4D6),
        title: const Text("Diary"),
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                  const Text(
                    "Feelings of The Day:",
                    style: TextStyle(fontSize: 13),
                  ),
                  ToggleButtons(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Happy'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Sad'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Angry'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('So-so'),
                      ),
                    ],
                    isSelected: isSelected,
                    onPressed: (int index) {
                      toggleSelect(index);
                    },
                    color: Colors.black,
                    fillColor: isSelected[0]
                        ? Colors.yellow
                        : isSelected[1]
                            ? Colors.blue
                            : isSelected[2]
                                ? Colors.red
                                : isSelected[3]
                                    ? Colors.grey
                                    : Colors.white,
                    selectedColor: Colors.black,
                    selectedBorderColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(30),
                  ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("My day", style: TextStyle(fontSize: 20)),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _myDiaryController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'My day',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return ("Please enter your My day");
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
                    Text("My day that I want to tell someone about",
                        style: TextStyle(fontSize: 15)),
                    SizedBox(
                      width: 350,
                      child: TextFormField(
                        controller: _receiverDiaryController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText: 'My day',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return ("Please enter");
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 30.0)),
              ElevatedButton(
                onPressed: () async{
                await sendUserServer();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => SendDiaryScreen())
                  );
                },
                child: Text("Finish"),
              ),
            ],
          ),
        ),
      ),
            bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF9AD0C2),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'My'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
