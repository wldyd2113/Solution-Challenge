import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mytodaysdiary/DB/diaryProvider.dart';
import 'package:mytodaysdiary/diaryViews/SendDiary.dart';
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

  void sendUserServer() async {
     final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    try {
      final response = await http.post(
        Uri.parse(''),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'myDiary': diaryProvider.myDiary,
          'snedDiart': diaryProvider.sendDiary,
          'emotion': diaryProvider.emotion,
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
      appBar: AppBar(
        title: const Text("Diary"),
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
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
                ],
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 10.0)),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                          if (value == null || value.isEmpty) {
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
                          if (value == null || value.isEmpty) {
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
                onPressed: () {
                  sendUserServer();
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
    );
  }
}
