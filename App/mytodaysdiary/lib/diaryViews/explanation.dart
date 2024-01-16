  import 'package:flutter/material.dart';
import 'package:mytodaysdiary/MysettingViews/mySetting.dart';
import 'package:mytodaysdiary/diaryViews/Mydiary.dart';
import 'package:mytodaysdiary/diaryViews/calendar.dart';

  class Explanation extends StatefulWidget {
    @override
    _ExplanationState createState() => _ExplanationState();
  }
  class _ExplanationState extends State<Explanation> {
    int _selectedIndex = 0;
    DateTime _selectedDate = DateTime.now();
    bool happy = true;
    bool sad = false;
    bool angry = false;
    bool soso = false;
    late List<bool> isSelected;

    final List<Widget> _widgetOptions = <Widget>[
      Calendar(),
      MySetting(),
    ];

    @override
    void initState() {
      isSelected = [happy, sad, angry, soso];
      super.initState();
    }

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
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFECF4D6),
        appBar: AppBar(
          backgroundColor: const Color(0xFFECF4D6),
          title: const Text("설명"),
          actions: <Widget>[],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child:Container(
                alignment: Alignment.center,
                width: 329,
                height: 575.11,
                decoration: ShapeDecoration(
                color: Color(0xFFB19470),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                ),
                ),
                child:Container(
                  alignment: Alignment.topLeft,
                  
                  width: 323,
                  height: 545.11,
                  decoration: ShapeDecoration(
                  color: Color(0xFFD0D4C7),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                  width: 317,
                height: 530.11,
                decoration: ShapeDecoration(
                color: Color(0xFFFAFFEC),
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                ),
                ),
                child :Container(
                  alignment: Alignment.centerRight,
                width: 290,
                height: 480,
                decoration: ShapeDecoration(
                color: Color(0xFFFFFFEC),
                shape: RoundedRectangleBorder(
                side: BorderSide(width: 1),
                borderRadius: BorderRadius.circular(10),
                ),
                shadows: [
                BoxShadow(
                color: Color(0x3F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
                spreadRadius: 0,
                )
                ],
                ),

              child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                  child: Text(
                      "Feelings of The Day:",
                      style: TextStyle(
                      color: Color(0xFF76453B),
                      fontSize: 20,
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),
                    ),
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
                      borderRadius: BorderRadius.circular(10),
                    ),
                    Center(
                    child:Container(
                      alignment: Alignment.center,
                      width: 273,
                      height: 377,
                      decoration: ShapeDecoration(
                      color: Color(0xFFFFECD6),
                      shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(10),
                      ),
                      ),
                      child:Column(children:[
                      Container(
                      child: Text("‘누군가에게 들려주고픈 나의 하루’ 기능은 일기를 공유할 수 있는 기능입니다. 작성하실 경우, 익명성이 유지된 채 다른 사용자들과 일기를 1:1로 공유할 수 있습니다. ’나의 하루’에 작성하는 일기는 공유되지 않으며, ‘누군가에게 들려주고픈 나의 하루’에 작성한 내용만 공유됩니다.",
                      style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),
                      ),
                      ),
                      SizedBox(height: 20,),
                      Container(
                        padding: EdgeInsets.only(left: 16.0),
                        alignment: Alignment.centerLeft,
                        child:Text("기능 활용 방법",
                      style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),)
                      ),
                      SizedBox(height: 20,),
                      Container(
                        child:Text("1.‘누군가에게 들려주고픈 나의 하루’를 작성한다",
                      style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),)
                      ),
                      SizedBox(height: 5,),
                      Container(
                        child:Text("2.전달받은 다른 사용자의 일기에 메시지를 남겨준다.",
                      style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),)
                      ),
                      SizedBox(height: 5,),
                      Container(
                        alignment: Alignment.centerLeft,
                        child:Text("3.메시지를 남겨준 경우, 자신의 일기도 다",
                      style: TextStyle(
                      fontFamily: 'Noto Sans',
                      fontWeight: FontWeight.w400,
                      height: 0,
                      ),)
                      ),
                      SizedBox(height: 40,),
                      ElevatedButton(onPressed: (){

                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => MyDiary(),),);
                      }, child: Text("확인",
                            style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Gowun Dodum',
                            fontWeight: FontWeight.w400,
                            height: 0,
                                ),
                      ),
                      style: ElevatedButton.styleFrom(
                                primary: Color(0x996B3A2F),
                                elevation: 4,),
                      )
                      ]
                      ),
                      
                      
                    
                        
                      ),
                    ),
                ],
              ),
            ),
            ),
          ),
        ),
        ),
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