import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytodaysdiary/MysettingViews/mySetting.dart';
import 'package:mytodaysdiary/diaryViews/Mydiary.dart';
import 'package:mytodaysdiary/diaryViews/RecordDiary.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  int _selectedIndex = 0;
  DateTime _selectedDate = DateTime.now();

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

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });

    if (selectedDay.isAfter(DateTime.now())) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('미래 날짜는 기록할 수 없습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('확인'),
              ),
            ],
          );
        },
      );
    } else if (selectedDay.isBefore(DateTime.now())) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RecordDiary(selectedDate: selectedDay)),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MyDiary()),
      );
    }
  }

  void _onLeaveTodayPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MyDiary(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECF4D6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFECF4D6),
        title: const Text("Calendar"),
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: 329,
                height: 575.11,
                decoration: ShapeDecoration(
                  color: Color(0xFFB19470),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.topLeft,
                  width: 323,
                  height: 550.59,
                  decoration: ShapeDecoration(
                    color: Color(0xFFD0D4C7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Container(
                    width: 316,
                    height: 543.44,
                    decoration: ShapeDecoration(
                      color: Color(0xFFFAFFEC),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        TableCalendar(
                          firstDay: DateTime.utc(2023, 12, 25),
                          lastDay: DateTime.utc(2030, 12, 25),
                          focusedDay: DateTime.now(),
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDate, day);
                          },
                          headerStyle: HeaderStyle(
                            titleCentered: true,
                            titleTextFormatter: (date, locale) =>
                                DateFormat.yMMMMd(locale).format(date),
                            formatButtonVisible: false,
                            titleTextStyle: const TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                            headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
                            leftChevronIcon: const Icon(
                              color: Color(0xFF8A9FA7),
                              Icons.arrow_back_ios_new_outlined,
                              size: 20.0,
                            ),
                            rightChevronIcon: const Icon(
                              color: Color(0xFF8A9FA7),
                              Icons.arrow_forward_ios_outlined,
                              size: 20.0,
                            ),
                          ),
                          onDaySelected: _onDaySelected,
                          weekendDays: [DateTime.saturday, DateTime.sunday], // 토요일과 일요일을 주말로 설정
                          calendarStyle: const CalendarStyle(
                            weekendTextStyle: TextStyle(color: Colors.red), // 주말 텍스트 스타일
                            weekendDecoration: BoxDecoration(color: Colors.transparent), // 주말 배경 설정
                            selectedTextStyle: TextStyle(color: Colors.white),
                            todayTextStyle: TextStyle(color: Colors.blue),
                          ),
                        ),
                        SizedBox(height: 90,),
                        Container(
                          width: 296,
                          height: 43,
                          decoration: ShapeDecoration(
                          color: Color(0xCC6B3A2F),
                          shape: RoundedRectangleBorder(
                          side: BorderSide(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                          ),),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: _onLeaveTodayPressed,

                              child: Text('Leave Today',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Gowun Dodum',
                                fontWeight: FontWeight.w400,
                                height: 0,
                                ),
                                ),
                                style: ElevatedButton.styleFrom(
                                primary: Color(0xCC6B3A2F),
                                elevation: 4, )
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
              ),
            ],
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
