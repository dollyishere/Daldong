import 'package:daldong/screens/exercise_detail_screen/exercise_detail_part.dart';
import 'package:daldong/widgets/common/footer.dart';
import 'package:daldong/widgets/exercise_detail_screen/exercise_detail_block.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:daldong/services/exercise_api.dart';
import 'package:daldong/utilites/exercise_detail_screen/calendar_util.dart';
import 'package:daldong/widgets/exercise_detail_screen/calendar_header.dart';

class ExerciseDetailScreen extends StatefulWidget {
  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int nowYearMonth = 202305;
  List<Map<String, dynamic>> exerciseLogList = [];
  List<int> yearMonthList = [];
  dynamic events = [];
  Map<DateTime, List<Event>> kEvents = {};
  late final ValueNotifier<List<Event>> _selectedEvents;
  // 처음 본 페이지 들어왔을 때 focused 날짜를 지정함(이후 사용자 선택 따라 변경)
  final ValueNotifier<DateTime> _focusedDay = ValueNotifier(DateTime.now());
  late PageController _pageController;

  // 캘린더 보이는 형식 지정
  CalendarFormat _calendarFormat = CalendarFormat.week;
  String nowCalendarFormat = '주';

  @override
  void initState() {
    super.initState();
    _selectedEvents = ValueNotifier(
      _getEventsForDay(_focusedDay.value),
    );
    getYearMonthValue();
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay.value = focusedDay;
    });
    _selectedEvents.value = _getEventsForDay(_focusedDay.value);
  }

  void changeFormat() {
    setState(() {
      if (_calendarFormat == CalendarFormat.week) {
        _calendarFormat = CalendarFormat.twoWeeks;
        nowCalendarFormat = '2주';
      } else if (_calendarFormat == CalendarFormat.twoWeeks) {
        _calendarFormat = CalendarFormat.month;
        nowCalendarFormat = '달';
      } else {
        _calendarFormat = CalendarFormat.week;
        nowCalendarFormat = '주';
      }
    });
  }

  void changeToday() {
    setState(() {
      _focusedDay.value = DateTime.now();
    });
    _selectedEvents.value = _getEventsForDay(_focusedDay.value);
  }

  void getYearMonthValue() {
    late int changeYearMonth;
    if (_focusedDay.value.month < 10) {
      changeYearMonth =
          int.parse('${_focusedDay.value.year}0${_focusedDay.value.month}');
    } else {
      changeYearMonth =
          int.parse('${_focusedDay.value.year}${_focusedDay.value.month}');
    }
    print(changeYearMonth);
    if (!yearMonthList.contains(changeYearMonth)) {
      yearMonthList.add(changeYearMonth);
      setState(() {
        nowYearMonth = changeYearMonth;
      });
      getMonthlyExerciseLog(
        success: (dynamic response) {
          setState(() {
            events = response['data'];
            print(events);
            for (int i = 0; i < events.length; i++) {
              var temp =
                  "${(DateTime.parse(events[i]['date']).add(const Duration(hours: 9))).toString().substring(0, 11)}00:00:00.000Z";
              var eventDate = DateTime.parse(temp);
              var event = events[i]['exercise'];
              print(event);

              for (int j = 0; j < event.length; j++) {
                print(event[j]);
                var haha = DateTime.parse(event[j]['exerciseStartTime'])
                        .add(const Duration(hours: 9)) ??
                    'string';
                print(haha);
                if (kEvents.containsKey(eventDate)) {
                  kEvents[eventDate]!.add(
                    Event(
                      '${eventDate.toString().substring(0, 4)}년 ${eventDate.toString().substring(5, 7)}월 ${eventDate.toString().substring(8, 10)}일 / ${j + 1}번째 운동 기록',
                      DateTime.parse(event[j]['exerciseStartTime'])
                          .add(const Duration(hours: 9)),
                      DateTime.parse(event[j]['exerciseEndTime'])
                          .add(const Duration(hours: 9)),
                      event[j]['exerciseTime'],
                      event[j]['exerciseKcal'],
                      event[j]['exercisePoint'],
                      event[j]['averageHeart'],
                      event[j]['exercisePetExp'],
                      event[j]['exerciseUserExp'],
                      event[j]['maxHeart'],
                    ),
                  );
                } else {
                  kEvents.addAll({
                    eventDate: [
                      Event(
                        '${eventDate.toString().substring(0, 4)}년 ${eventDate.toString().substring(5, 7)}월 ${eventDate.toString().substring(8, 10)}일 / ${j + 1}번째 운동 기록',
                        DateTime.parse(event[j]['exerciseStartTime'])
                            .add(const Duration(hours: 9)),
                        DateTime.parse(event[j]['exerciseEndTime'])
                            .add(const Duration(hours: 9)),
                        event[j]['exerciseTime'],
                        event[j]['exerciseKcal'],
                        event[j]['exercisePoint'],
                        event[j]['averageHeart'],
                        event[j]['exercisePetExp'],
                        event[j]['exerciseUserExp'],
                        event[j]['maxHeart'],
                      ),
                    ]
                  });
                }
              }
            }
          });
        },
        fail: (error) {
          print('이번 달 운동 로그 호출 오류: $error');
        },
        yearMonth: changeYearMonth,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Footer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // 이때 값 받아오면 될 듯?
              ValueListenableBuilder<DateTime>(
                valueListenable: _focusedDay,
                builder: (context, value, _) {
                  return CalendarHeader(
                    focusedDay: value,
                    onTodayButtonTap: changeToday,
                    onLeftArrowTap: () {
                      _pageController.previousPage(
                        duration: Duration(
                          milliseconds: 300,
                        ),
                        curve: Curves.easeOut,
                      );
                      getYearMonthValue();
                    },
                    onRightArrowTap: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                      getYearMonthValue();
                    },
                    nowCalendarFormat: nowCalendarFormat,
                    onFormatSelecter: () {
                      setState(() {
                        if (_calendarFormat == CalendarFormat.week) {
                          _calendarFormat = CalendarFormat.twoWeeks;
                          nowCalendarFormat = '2주';
                        } else if (_calendarFormat == CalendarFormat.twoWeeks) {
                          _calendarFormat = CalendarFormat.month;
                          nowCalendarFormat = '월';
                        } else {
                          _calendarFormat = CalendarFormat.week;
                          nowCalendarFormat = '주';
                        }
                      });
                    },
                  );
                },
              ),
              TableCalendar<Event>(
                firstDay: kFirstDay,
                lastDay: kLastDay,
                // 현재 한국 버전은 지원하지 않는 듯 함...
                locale: 'en_US',
                focusedDay: _focusedDay.value,
                headerVisible: false,
                selectedDayPredicate: (day) => _focusedDay.value == day,
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay,
                onDaySelected: _onDaySelected,
                onCalendarCreated: (controller) => _pageController = controller,
                onPageChanged: (focusedDay) => _focusedDay.value = focusedDay,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                      if (format == CalendarFormat.week) {
                        nowCalendarFormat = '주';
                      } else if (_calendarFormat == CalendarFormat.twoWeeks) {
                        nowCalendarFormat = '2주';
                      } else {
                        nowCalendarFormat = '월';
                      }
                    });
                  }
                },
                calendarStyle: CalendarStyle(
                  canMarkersOverflow: false,
                  markersAutoAligned: true,
                  markerSize: 6,
                  markerMargin: const EdgeInsets.symmetric(horizontal: 0.5),
                  markersAlignment: Alignment.bottomCenter,
                  markersMaxCount: 4,
                  selectedDecoration: ShapeDecoration(
                      shape: const CircleBorder(side: BorderSide.none),
                      color: Theme.of(context).primaryColor),
                  markerDecoration: ShapeDecoration(
                      shape: const CircleBorder(side: BorderSide.none),
                      color: Theme.of(context).primaryColorDark),
                  todayDecoration: ShapeDecoration(
                      shape: const CircleBorder(side: BorderSide.none),
                      color: Theme.of(context).primaryColorLight),
                  // holidayTextStyle: TextStyle(color: Colors.red,),
                  weekendTextStyle: const TextStyle(
                    color: Colors.red,
                  ),
                  outsideDaysVisible: true,
                  rangeHighlightColor: Theme.of(context).primaryColor,
                  rangeHighlightScale: 1,
                  rangeStartTextStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                  ),
                  rangeStartDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  rangeEndTextStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16.0,
                  ),
                  rangeEndDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  withinRangeDecoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    return ListView.builder(
                      itemCount: value.length,
                      itemBuilder: (context, index) {
                        return ExerciseDetailBlock(
                          exerciseValue: value[index],
                        );
                      },
                    );
                  },
                ),
              ),
              // const SizedBox(
              //  height: 80,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
