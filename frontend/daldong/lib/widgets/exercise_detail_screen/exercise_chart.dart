import 'package:daldong/utilites/common/chart_utilite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExerciseChart extends StatefulWidget {
  final int dailyExTime;
  final int dailyKcal;
  final int dailyCount;

  const ExerciseChart({
    Key? key,
    required this.dailyExTime,
    required this.dailyKcal,
    required this.dailyCount,
  }) : super(key: key);

  @override
  State<ExerciseChart> createState() => _ExerciseChartState();
}

class _ExerciseChartState extends State<ExerciseChart> {
  ChartSeriesController? _chartSeriesController;

  int todayPlayerKcal = 123;
  int todayExerciseTime = 60;
  int todayPoint = 76;
  // int changeTime = (todayExerciseTime.inDays * 60 + todayPlayerKcal).toInt());

  List<ChartData> radialChartData = [
    ChartData(
      '포인트',
      0,
      300,
      Color.fromRGBO(75, 135, 185, 1),
    ),
    ChartData(
      '소비시간',
      0,
      90,
      Color.fromRGBO(192, 108, 132, 1),
    ),
    ChartData(
      '칼로리',
      0,
      500,
      Color.fromRGBO(246, 114, 128, 1),
    ),
  ];

  @override
  void initState() {
    radialChartData = [
      ChartData(
        '포인트',
        widget.dailyCount.toDouble(),
        300,
        Color.fromRGBO(75, 135, 185, 1),
      ),
      ChartData(
        '소비시간',
        widget.dailyExTime.toDouble(),
        90,
        Color.fromRGBO(192, 108, 132, 1),
      ),
      ChartData(
        '칼로리',
        widget.dailyKcal.toDouble(),
        500,
        Color.fromRGBO(246, 114, 128, 1),
      ),
    ];
    // _chartSeriesController!.animate();
    super.initState();
  }

  @override
  void dispose() {
    radialChartData!.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 200,
              height: 200,
              child: SfCircularChart(
                margin: EdgeInsets.all(12),
                series: <CircularSeries>[
                  RadialBarSeries<ChartData, String>(
                    dataSource: radialChartData,
                    useSeriesColor: true,
                    trackOpacity: 0.3,
                    xValueMapper: (ChartData data, _) => data.category,
                    yValueMapper: (ChartData data, _) =>
                        (data.nowValue / data.goal),
                    pointColorMapper: (ChartData data, _) =>
                        data.chartColor.withOpacity(0.3),
                    // Corner style of radial bar segment
                    radius: '100%',
                    maximumValue: 1,
                    enableTooltip: true,
                    cornerStyle: CornerStyle.bothCurve,
                  ),
                ],
                annotations: <CircularChartAnnotation>[
                  CircularChartAnnotation(
                    angle: 0,
                    radius: '0%',
                    height: '80%',
                    width: '80%',
                    widget: CircleAvatar(
                      backgroundImage: AssetImage(
                        'lib/assets/images/animals/Dog.PNG',
                      ),
                    ),
                  ),
                ],
                // legend: Legend(isVisible: true, position: LegendPosition.bottom),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '칼로리',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.local_fire_department,
                            size: 24,
                            color: Color.fromRGBO(246, 114, 128, 1),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            '${widget.dailyKcal}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '/ 500 Kcal',
                        style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '소비시간',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.timer,
                            size: 20,
                            color: Color.fromRGBO(192, 108, 132, 1),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            '${widget.dailyExTime}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '/ 90분',
                        style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '포인트',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.flag_circle,
                            size: 22,
                            color: Color.fromRGBO(75, 135, 185, 1),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            '${widget.dailyCount}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              // fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '/ 300 point',
                        style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
