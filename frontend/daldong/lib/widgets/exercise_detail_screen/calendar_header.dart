import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarHeader extends StatelessWidget {
  final DateTime focusedDay;
  final String nowCalendarFormat;
  final VoidCallback onLeftArrowTap;
  final VoidCallback onRightArrowTap;
  final VoidCallback onTodayButtonTap;
  final VoidCallback onFormatSelecter;

  const CalendarHeader({
    Key? key,
    required this.focusedDay,
    required this.nowCalendarFormat,
    required this.onLeftArrowTap,
    required this.onRightArrowTap,
    required this.onTodayButtonTap,
    required this.onFormatSelecter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerText = DateFormat.yMMM().format(focusedDay);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const SizedBox(width: 16.0),
          SizedBox(
            width: 124.0,
            child: Text(
              headerText,
              style: TextStyle(
                fontSize: 26.0,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          InkWell(
            onTap: onTodayButtonTap,
            child: Container(
              width: 48,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.5),
                    spreadRadius: 0.3,
                    blurRadius: 6,
                  )
                ],
              ),
              child: Center(
                child: Text(
                  '오늘',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          InkWell(
            onTap: onFormatSelecter,
            child: Container(
              width: 48,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.black,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.5),
                    spreadRadius: 0.3,
                    blurRadius: 6,
                  )
                ],
              ),
              child: Center(
                child: Text(
                  nowCalendarFormat,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: onLeftArrowTap,
          ),
          IconButton(
            icon: Icon(Icons.chevron_right),
            onPressed: onRightArrowTap,
          ),
        ],
      ),
    );
  }
}
