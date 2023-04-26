import 'dart:collection';

import 'package:table_calendar/table_calendar.dart';

/// Example event class.
class Event {
  final String title;
  const Event(this.title);

  @override
  String toString() => title;
}

/// Example events.
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
// );
)..addAll(_kEventSource);

/// 나중에 api 요청 받은 후에 데이터 이 형식으로 넣으면 될 듯?
final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event('운동 기록 $item | ${index + 1}')))
  ..addAll({
    kToday: [
      Event('오늘의 운동 기록 1'),
      Event('오늘의 운동 기록 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
// 캘린더 날짜 범위 설정
// 캘린더 시작 날짜는 daldong 프로젝트 시작한 날짜부터
// final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
// final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
final kFirstDay = DateTime(2023, 4, 10);
final kLastDay = kToday;
