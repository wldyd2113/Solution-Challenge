import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mytodaysdiary/DB/TokenSave.dart';
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
  late String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate); // Initialize here


@override
void initState() {
  super.initState();
  final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
  _checkDataExist(formattedDate);
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

//미래 날짜를 클릭하면 기록할수 없는 창이 뜨고 해당 날짜를 클릭하면 formattedDate에 저장됨
//해당 날짜에 데이터가 있으면 Mydiary페이지로 이동
//없으면 RecordDiary페이지로 이동
Future<void> _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
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
  } else {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    bool hasData = await _checkDataExist(formattedDate);

    if (hasData) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => RecordDiary(selectedDate: selectedDay)),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MyDiary(selectedDate: selectedDay)),
      );
    }
  }
}



//해당 날짜에 데이터가 있는지 없는지 검사해줌
Future<bool> _checkDataExist(String formattedDate) async {
  final token = await TokenStorage.getToken();

  if (token != null) {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/diary/$formattedDate'), // 실제 서버의 엔드포인트로 수정
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // 서버 응답이 성공적으로 왔을 때
        return true; // 데이터가 있음을 나타냄
      } else if (response.statusCode == 404) {
        // 서버 응답이 404일 때 (데이터가 없을 때)
        return false; // 데이터가 없음을 나타냄
      } else {
        // 다른 상태 코드에 대한 처리 (예: 401은 권한 없음)
        print('서버 응답 오류: ${response.statusCode}');
        return false; // 일단 실패로 처리
      }
    } catch (error) {
      // 통신 중 에러 발생
      print('통신 중 에러: $error');
      return false; // 일단 실패로 처리
    }
  } else {
    // 토큰이 없을 때
    print('토큰이 없습니다.');
    return false; // 일단 실패로 처리
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
                            weekendDays: [DateTime.saturday, DateTime.sunday],
                            calendarStyle: const CalendarStyle(
                              weekendTextStyle: TextStyle(color: Colors.red),
                              weekendDecoration: BoxDecoration(color: Colors.transparent),
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
                              ),
                            ),
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 300,
                              child: ElevatedButton(
                                onPressed: _onLeaveTodayPressed,
                                child: Text(
                                  'Leave Today',
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
                                  elevation: 4,
                                ),
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