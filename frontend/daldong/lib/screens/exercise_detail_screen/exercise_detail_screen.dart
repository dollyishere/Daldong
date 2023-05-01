import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:daldong/utilites/exercise_detail_screen/calendar_utilite.dart';
import 'package:daldong/widgets/exercise_detail_screen/calendar_header.dart';

class ExerciseDetailScreen extends StatefulWidget {
  // static const String route = '/';
  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
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
                    },
                    onRightArrowTap: () {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
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
                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ListTile(
                            onTap: () {},
                            title: Text('${value[index]}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
