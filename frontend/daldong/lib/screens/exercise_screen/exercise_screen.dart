import 'dart:async';

import 'package:daldong/screens/exercise_detail_screen/exercise_detail_screen.dart';
import 'package:daldong/utilites/common/common_util.dart';
import 'package:daldong/widgets/exercise_detail_screen/exercise_chart.dart';
import 'package:daldong/widgets/common/exercise_info_block.dart';
import 'package:daldong/widgets/common/footer.dart';
import 'package:daldong/utilites/common/chart_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:geolocator/geolocator.dart' as Geo;
import 'package:daldong/services/exercise_api.dart';
import 'package:daldong/services/exercise_api.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class ExerciseScreen extends StatefulWidget {
  ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  Map<String, dynamic> todayExInfo = {};
  Map<String, dynamic> weatherInfo = {};
  List<_SplineAreaData>? chartData;
  ChartSeriesController? _chartSeriesController1;

  String _durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours.remainder(60));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds";
  }

  Future<void> getCurrentLocation() async {
    Geo.LocationPermission permission =
        await Geo.Geolocator.requestPermission();
    Geo.Position position = await Geo.Geolocator.getCurrentPosition(
        desiredAccuracy: Geo.LocationAccuracy.high);
    var lat = position.latitude;
    var lon = position.longitude;
    getWeatherInfo(
      success: (dynamic response) {
        setState(() {
          weatherInfo = response;
        });
        print(weatherInfo);
      },
      fail: (error) {
        print('오늘 날씨 로그 호출 오류: $error');
      },
      lat: lat,
      lon: lon,
    );
  }

  @override
  void initState() {
    getCurrentLocation();
    getTodayExerciseLog(
      success: (dynamic response) {
        setState(() {
          todayExInfo = response['data'];
        });
      },
      fail: (error) {
        print('오늘 운동 로그 호출 오류: $error');
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   '/error',
        //   arguments: {
        //     'errorText': error,
        //   },
        //   ModalRoute.withName('/home'),
        // );
      },
      userId: 1,
    );
    chartData = <_SplineAreaData>[
      _SplineAreaData(0, 20),
      _SplineAreaData(1, 0),
      _SplineAreaData(2, 0),
      _SplineAreaData(3, 0),
      _SplineAreaData(4, 0),
      _SplineAreaData(5, 0),
      _SplineAreaData(6, 0),
      _SplineAreaData(7, 150),
      _SplineAreaData(8, 210),
      _SplineAreaData(9, 10),
      _SplineAreaData(10, 20),
      _SplineAreaData(11, 0),
      _SplineAreaData(12, 120),
      _SplineAreaData(13, 1150),
      _SplineAreaData(14, 0),
      _SplineAreaData(15, 0),
      _SplineAreaData(16, 0),
      _SplineAreaData(17, 0),
      _SplineAreaData(18, 0),
      _SplineAreaData(19, 113),
      _SplineAreaData(20, 218),
      _SplineAreaData(21, 0),
      _SplineAreaData(22, 0),
      _SplineAreaData(23, 0),
      _SplineAreaData(24, 0),
    ];
    _chartSeriesController1?.animate();
    super.initState();
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }

  List<ChartSeries<_SplineAreaData, double>> _getSplieAreaSeries() {
    return <ChartSeries<_SplineAreaData, double>>[
      SplineAreaSeries<_SplineAreaData, double>(
        dataSource: chartData!,
        color: Theme.of(context).primaryColorLight.withOpacity(0.6),
        borderColor: Theme.of(context).primaryColorDark,
        borderWidth: 2,
        name: '소비 칼로리',
        xValueMapper: (_SplineAreaData sales, _) => sales.time,
        yValueMapper: (_SplineAreaData sales, _) => sales.kcal,
        animationDuration: 2000,
        onRendererCreated: (ChartSeriesController controller) {
          _chartSeriesController1 = controller;
        },
        markerSettings: MarkerSettings(isVisible: true),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Footer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      '운동',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '오늘의 기록',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ExerciseDetailScreen(),
                              ),
                            );
                          },
                          icon: Icon(
                            Icons.calendar_month_rounded,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  ],
                ),
                // SizedBox(
                //   width: 10,
                //   height: 10,
                // ),
                // ExerciseChart(dailyExTime: todayExInfo['dailyExTime'] ?? 0, dailyKcal: todayExInfo['dailyKcal'] ?? 0, dailyCount: todayExInfo['dailyCount'] ?? 0,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ExerciseInfoBlock(
                        infoName: '칼로리',
                        infoIcon: Icon(
                          Icons.local_fire_department,
                          size: 24,
                          color: Color.fromRGBO(246, 114, 128, 1),
                        ),
                        infoValue: todayExInfo['dailyKcal'] ?? 0,
                        infoUnit: 'Kcal',
                      ),
                      ExerciseInfoBlock(
                        infoName: '소비시간',
                        infoIcon: Icon(
                          Icons.timer,
                          size: 20,
                          color: Color.fromRGBO(192, 108, 132, 1),
                        ),
                        infoValue: todayExInfo['dailyExTime'] ?? 0,
                        infoUnit: '분',
                      ),
                      ExerciseInfoBlock(
                        infoName: '포인트',
                        infoIcon: Icon(
                          Icons.flag_circle,
                          size: 22,
                          color: Color.fromRGBO(75, 135, 185, 1),
                        ),
                        infoValue: todayExInfo['dailyCount'] ?? 0,
                        infoUnit: 'Point',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10,
                  height: 32,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '오늘의 시간 당 칼로리',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: 370,
                      height: 260,
                      child: SfCartesianChart(
                        // legend: Legend(isVisible: true, opacity: 0.7),
                        // title: ChartTitle(text: 'Inflation rate'),
                        primaryXAxis: NumericAxis(
                            interval: 1,
                            majorGridLines: const MajorGridLines(width: 0),
                            edgeLabelPlacement: EdgeLabelPlacement.shift),
                        primaryYAxis: NumericAxis(
                            labelFormat: '{value}Kcal',
                            axisLine: const AxisLine(width: 0),
                            majorTickLines: const MajorTickLines(size: 0)),
                        series: _getSplieAreaSeries(),
                        tooltipBehavior: TooltipBehavior(enable: true),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                  height: 32,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      '오늘의 추천 운동',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 10,
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.5),
                              spreadRadius: 0.3,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.5),
                              spreadRadius: 0.3,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .shadowColor
                                  .withOpacity(0.5),
                              spreadRadius: 0.3,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 100,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SplineAreaData {
  _SplineAreaData(this.time, this.kcal);
  final double time;
  final double kcal;
}
