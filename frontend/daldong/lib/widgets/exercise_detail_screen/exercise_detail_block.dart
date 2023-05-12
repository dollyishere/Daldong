import 'package:daldong/utilites/exercise_detail_screen/calendar_util.dart';
import 'package:daldong/widgets/exercise_detail_screen/exercise_info_line.dart';
import 'package:flutter/material.dart';

class ExerciseDetailBlock extends StatefulWidget {
  final Event exerciseValue;

  const ExerciseDetailBlock({
    required this.exerciseValue,
    super.key,
  });

  @override
  State<ExerciseDetailBlock> createState() => _ExerciseDetailBlockState();
}

class _ExerciseDetailBlockState extends State<ExerciseDetailBlock> {
  bool _isExpanded = false;

  String changeDay(DateTime dayTime) {
    String stringDay =
        '${dayTime.year.toString()}년 ${dayTime.month.toString()}월 ${dayTime.day.toString()}일';
    return stringDay;
  }

  String changeTime(DateTime dayTime) {
    print(dayTime);
    String stringTime;
    if (dayTime.minute >= 10) {
      stringTime = '${dayTime.hour}시 ${dayTime.minute.toString()}분';
    } else {
      stringTime = '${dayTime.hour}시 0${dayTime.minute.toString()}분';
    }
    return stringTime;
  }

  String changeTimeMinute(String time) {
    List<String> hourMinuteSecond = time.split(':');
    String minuteTime =
        '${int.parse(hourMinuteSecond[0]) * 60 + int.parse(hourMinuteSecond[1])}';
    return minuteTime;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    setState(() {
      _isExpanded = false;
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 6,
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 0,
            ),
            decoration: BoxDecoration(
              // border: Border.all(),
              color: Theme.of(context).primaryColorDark,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 1,
                  spreadRadius: 0.3,
                ),
              ],
            ),
            child: ListTile(
              onTap: () {},
              title: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.exerciseValue.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        !_isExpanded
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up,
                        color: Colors.white,
                        // size: 40,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isExpanded)
            Container(
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(0),
                border: Border.all(
                  color: Theme.of(context).primaryColorDark,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF999999).withOpacity(0.5),
                    spreadRadius: 0.3,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      '운동 시간',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '(총 소요 시간: ',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${changeTimeMinute(widget.exerciseValue.exerciseTime)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '분)',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Start',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              changeDay(widget.exerciseValue.exerciseStartTime),
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              changeTime(
                                  widget.exerciseValue.exerciseStartTime),
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(
                              height: 12,
                            ),
                            Text('~'),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'End',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              changeDay(widget.exerciseValue.exerciseEndTime),
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              changeTime(widget.exerciseValue.exerciseEndTime),
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      '상세 정보',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      width: 270,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExerciseInfoLine(
                            infoLineName: '총 소비 칼로리',
                            infoLineIcon: Icon(
                              Icons.local_fire_department,
                              size: 24,
                              color: Color.fromRGBO(246, 114, 128, 1),
                            ),
                            infoLineValue:
                                widget.exerciseValue.exerciseKcal.toString(),
                            infoLineUnit: 'Kcal',
                          ),
                          ExerciseInfoLine(
                            infoLineName: '총 획득 포인트',
                            infoLineIcon: Icon(
                              Icons.flag_circle,
                              size: 22,
                              color: Color.fromRGBO(75, 135, 185, 1),
                            ),
                            infoLineValue:
                                '${changeTimeMinute(widget.exerciseValue.exerciseTime)}',
                            infoLineUnit: 'Point',
                          ),
                          ExerciseInfoLine(
                            infoLineName: '유저 획득 경험치',
                            infoLineIcon: Icon(
                              Icons.person_pin,
                              size: 22,
                              color: Colors.black,
                            ),
                            infoLineValue:
                                widget.exerciseValue.exerciseUserExp.toString(),
                            infoLineUnit: 'Exp',
                          ),
                          ExerciseInfoLine(
                            infoLineName: '펫 획득 경험치',
                            infoLineIcon: Icon(
                              Icons.pets,
                              size: 22,
                              color: Colors.brown,
                            ),
                            infoLineValue:
                                widget.exerciseValue.exercisePetExp.toString(),
                            infoLineUnit: 'Exp',
                          ),
                          ExerciseInfoLine(
                            infoLineName: '평균 심박수',
                            infoLineIcon: Icon(
                              Icons.monitor_heart_outlined,
                              size: 22,
                              color: Colors.red,
                            ),
                            infoLineValue:
                                widget.exerciseValue.averageHeart.toString(),
                            infoLineUnit: 'Bpm',
                          ),
                          ExerciseInfoLine(
                            infoLineName: '최대 심박수',
                            infoLineIcon: Icon(
                              Icons.monitor_heart,
                              size: 22,
                              color: Colors.red,
                            ),
                            infoLineValue:
                                widget.exerciseValue.maxHeart.toString(),
                            infoLineUnit: 'Bpm',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
