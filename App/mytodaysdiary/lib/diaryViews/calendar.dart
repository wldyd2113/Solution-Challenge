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
    // 이전 날짜인 경우 RecordDiary 페이지로 이동
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => RecordDiary(selectedDate: selectedDay)),
    );
  } else {
    // 현재 날짜인 경우 MyDiary 페이지로 이동
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
      appBar: AppBar(
        title: const Text("Calendar"),
        actions: <Widget>[],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: TableCalendar(
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
                      Icons.arrow_left,
                      size: 40.0,
                    ),
                    rightChevronIcon: const Icon(
                      Icons.arrow_right,
                      size: 40.0,
                    ),
                  ),
                  onDaySelected: _onDaySelected,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
              ),
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 350,
                  child: ElevatedButton(
                    onPressed: _onLeaveTodayPressed,
                    child: Text('Leave Today'),
                  ),
                ),
              ),
            ],
          ),
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
