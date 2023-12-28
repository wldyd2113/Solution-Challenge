import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytodaysdiary/diaryViews/mySetting.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

    int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold
  );
  
  final List<Widget> _widgetOptions = <Widget>[
    Calendar(),
    MySetting(),
  ];
 
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
        title: const Text("Calender"),
        actions: <Widget>[
        ]),
      body: SafeArea(
        child: TableCalendar(
          firstDay: DateTime.utc(2023,12,25),
          lastDay: DateTime.utc(2030,12,25),
          focusedDay: DateTime.now(),
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
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home),
          label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people),
          label: 'My'),
          
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen,
        onTap: _onItemTapped,
        )
    );
  }
}