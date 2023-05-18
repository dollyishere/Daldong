import 'dart:async';
import 'dart:io';

import 'package:daldong/screens/exercise_detail_screen/exercise_detail_screen.dart';
import 'package:daldong/screens/exercise_screen/youtube_player.dart';
import 'package:daldong/utilites/common/common_util.dart';
import 'package:daldong/widgets/common/exercise_info_block.dart';
import 'package:daldong/widgets/common/footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:geolocator/geolocator.dart' as Geo;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:daldong/services/exercise_api.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseScreen extends StatefulWidget {
  ExerciseScreen({Key? key}) : super(key: key);

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen>
    with WidgetsBindingObserver {
  static const storage = FlutterSecureStorage();

  String uid = '0';
  bool isLoading = true;
  bool isRecommendedLoading = true;
  bool isVideoLoading = true;
  String nowShow = 'pre';
  Uri nowShowVideo =
      Uri.parse("http://openapi.kspo.or.kr/web/video/0AUDLJ08S_00546.mp4");
  String nowYoutubeLink = "https://www.youtube.com/watch?v=s0UjELAUMjE";

  InAppWebViewController? _webViewController;
  YoutubePlayerController? _youtubeController;
  List<String> chartKeys = [];
  int maxKcal = 0;
  List<_ChartData> chartData = [];
  late TooltipBehavior _tooltip;

  Map<String, dynamic> todayExInfo = {};
  Map<String, dynamic> weatherInfo = {
    "weather": [
      {
        "main": "Clear",
        "description": "맑음",
        "icon": "01d",
      },
    ],
    "main": {
      "temp": 20,
    },
  };
  Map<String, dynamic> recommendedExercise = {
    "daily_pre_ex_recommend": "",
    "daily_pre_ex_video": "",
    "daily_main_ex_recommend": "",
    "daily_main_ex_video": "",
    "daily_end_ex_recommend": "",
    "daily_end_ex_video": ""
  };

  void getUid() async {
    String? userId = await storage.read(key: "uid");
    await Future.delayed(const Duration(milliseconds: 10));
    print('유저 아이디: $userId');
    setState(() {
      uid = userId ?? 'user1';
    });
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
        getRecommendExercise(
          success: (dynamic response) {
            setState(() {
              recommendedExercise = response['Exercise'];
              isRecommendedLoading = false;
              nowShowVideo =
                  Uri.parse(recommendedExercise["daily_${nowShow}_ex_video"]);
              _youtubeController = new YoutubePlayerController(
                initialVideoId: YoutubePlayer.convertUrlToId(
                        recommendedExercise["daily_${nowShow}_ex_video"]) ??
                    '',
                flags: YoutubePlayerFlags(
                  mute: false,
                  autoPlay: false,
                  disableDragSeek: false,
                  loop: false,
                  isLive: false,
                  forceHD: false,
                  enableCaption: true,
                ),
              );
              isVideoLoading = false;
            });
          },
          fail: (error) {
            print('오늘의 추천 운동 호출 에러: $error');
          },
          uid: uid,
          weather: weatherInfo["weather"][0]["main"] ?? 'Clear',
          temperature: weatherInfo['main']['temp'] ?? 20,
        );
      },
      fail: (error) {
        print('오늘 날씨 로그 호출 오류: $error');
        getRecommendExercise(
          success: (dynamic response) {
            print(response);
            setState(() {
              print(response['Exercise']);
              recommendedExercise = response['Exercise'];
              isRecommendedLoading = false;
              nowShowVideo =
                  Uri.parse(recommendedExercise["daily_${nowShow}_ex_video"]);
              _youtubeController = new YoutubePlayerController(
                initialVideoId: YoutubePlayer.convertUrlToId(
                        recommendedExercise["daily_${nowShow}_ex_video"]) ??
                    '',
                flags: new YoutubePlayerFlags(
                  mute: false,
                  autoPlay: false,
                  disableDragSeek: false,
                  loop: false,
                  isLive: false,
                  forceHD: false,
                  enableCaption: true,
                  useHybridComposition: false,
                ),
              );
              isVideoLoading = false;
            });
          },
          fail: (error) {
            print('오늘의 추천 운동 호출 에러: $error');
          },
          uid: uid,
          weather: weatherInfo["weather"][0]["main"] ?? 'Clear',
          temperature: weatherInfo['main']['temp'] ?? 20,
        );
      },
      lat: lat,
      lon: lon,
    );
  }

  void changeVideo() async {
    setState(() {
      _youtubeController?.load(
        YoutubePlayer.convertUrlToId(
                recommendedExercise["daily_${nowShow}_ex_video"]) ??
            '',
      );
    });
    await Future.delayed(const Duration(milliseconds: 10));
    setState(() {
      isVideoLoading = false;
    });
    setState(() {});
  }

  int changeTimeMinute(String time) {
    List<String> hourMinuteSecond = time.split(':');
    int minuteTime =
        int.parse(hourMinuteSecond[0]) * 60 + int.parse(hourMinuteSecond[1]);
    return minuteTime;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUid();
      getCurrentLocation();
    });
    getTodayExerciseLog(
      success: (dynamic response) {
        setState(() {
          todayExInfo = response['data'];
          chartKeys = response['data']['chart'].keys.toList() ?? [];
          chartKeys.forEach((date) {
            setState(() {
              chartData.add(_ChartData(date, response['data']['chart'][date]));
              if (response['data']['chart'][date] > maxKcal) {
                maxKcal = response['data']['chart'][date];
              }
            });
          });
          setState(() {
            isLoading = false;
          });
        });
      },
      fail: (error) {
        print('오늘 운동 로그 호출 오류: $error');
      },
    );

    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  void dispose() {
    chartData!.clear();
    _webViewController?.clearCache();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('state = $state');
    if (_webViewController != null) {
      if (state == AppLifecycleState.paused) {
        _webViewController?.pauseTimers();
        if (Platform.isAndroid) {
          _webViewController?.android.pause();
        }
      } else {
        _webViewController?.resumeTimers();
        if (Platform.isAndroid) {
          _webViewController?.android.resume();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Footer(),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: 240,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    Padding(
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
                                      _youtubeController?.pause();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ExerciseDetailScreen(),
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

                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0), // Adjust the radius value as per your preference
                            ),
                            child: Column(
                              children: [
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
                                        infoValue: changeTimeMinute(
                                            todayExInfo['dailyExTime'] ??
                                                '00:00:00') ??
                                            0,
                                        infoUnit: '분',
                                      ),
                                      ExerciseInfoBlock(
                                        infoName: '운동 횟수',
                                        infoIcon: Icon(
                                          Icons.flag_circle,
                                          size: 22,
                                          color: Color.fromRGBO(75, 135, 185, 1),
                                        ),
                                        infoValue: todayExInfo['dailyCount'] ?? 0,
                                        infoUnit: 'Count',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ),
                          // SizedBox(
                          //   width: 10,
                          //   height: 10,
                          // ),
                          // ExerciseChart(dailyExTime: todayExInfo['dailyExTime'] ?? 0, dailyKcal: todayExInfo['dailyKcal'] ?? 0, dailyCount: todayExInfo['dailyCount'] ?? 0,),
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
                                '지난 7일 간 소비 칼로리',
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
                                  primaryXAxis: CategoryAxis(),
                                  primaryYAxis: NumericAxis(
                                      minimum: 0,
                                      maximum: maxKcal.toDouble(),
                                      interval: 10),
                                  tooltipBehavior: _tooltip,
                                  series: <ChartSeries<_ChartData, String>>[
                                    ColumnSeries<_ChartData, String>(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      dataSource: chartData,
                                      xValueMapper: (_ChartData data, _) => data.x,
                                      yValueMapper: (_ChartData data, _) => data.y,
                                      name: '하루 소모 칼로리',
                                      width: 0.3,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ],
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
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Player(
                                          YoutubePlayer.convertUrlToId(
                                                  nowYoutubeLink) ??
                                              ''),
                                    ),
                                  );
                                },
                                splashColor: Colors.transparent,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black, // 테두리 색상
                                      width: 2.0, // 테두리 두께
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.question_mark,
                                    size: 14,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                            height: 10,
                          ),
                          isRecommendedLoading
                              ? Container(
                                  width: double.infinity,
                                  height: 100,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('추천 운동을 불러오는 중입니다.'),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CircularProgressIndicator(
                                        color: Theme.of(context).primaryColor,
                                      )
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width *
                                              0.8,
                                          height: 200,
                                          child: isVideoLoading
                                              ? Center(
                                                  child: CircularProgressIndicator(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                )
                                              : YoutubePlayer(
                                                  // key:
                                                  //     ObjectKey(_youtubeController),
                                                  controller: _youtubeController ??
                                                      new YoutubePlayerController(
                                                          initialVideoId: ''),
                                                  actionsPadding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  bottomActions: [
                                                    CurrentPosition(),
                                                    const SizedBox(width: 10.0),
                                                    ProgressBar(isExpanded: true),
                                                    const SizedBox(width: 10.0),
                                                    RemainingDuration(),
                                                    PlaybackSpeedButton(),
                                                    const SizedBox(width: 10.0),
                                                  ],
                                                ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          '(각 박스를 누르면 영상 변경이 가능합니다)',
                                          style: TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    nowShow = 'pre';
                                                    nowShowVideo = Uri.parse(
                                                        recommendedExercise[
                                                            "daily_${nowShow}_ex_video"]);
                                                  });

                                                  // _webViewController?.loadUrl(
                                                  //     urlRequest: URLRequest(
                                                  //         url: nowShowVideo));
                                                  changeVideo();
                                                },
                                                child: Container(
                                                  width: 90,
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                    color: nowShow == 'pre'
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                            .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    boxShadow: [
                                                      nowShow == 'pre'
                                                          ? BoxShadow(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark,
                                                              spreadRadius: 0.5,
                                                              blurRadius: 14,
                                                            )
                                                          : BoxShadow(
                                                              color: Colors.black45,
                                                              spreadRadius: 0.3,
                                                              blurRadius: 4,
                                                            ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(14.0),
                                                    child: Center(
                                                      child: Text(
                                                        recommendedExercise[
                                                            'daily_pre_ex_recommend'],
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: nowShow == 'pre'
                                                              ? Theme.of(context)
                                                                  .primaryColor
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '몸풀기 운동',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.next_plan,
                                          ),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    nowShow = 'main';
                                                    nowShowVideo = Uri.parse(
                                                        recommendedExercise[
                                                            "daily_${nowShow}_ex_video"]);
                                                  });
                                                  // _webViewController?.loadUrl(
                                                  //     urlRequest: URLRequest(
                                                  //         url: nowShowVideo));
                                                  changeVideo();
                                                },
                                                child: Container(
                                                  width: 90,
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                    color: nowShow == 'main'
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                            .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    boxShadow: [
                                                      nowShow == 'main'
                                                          ? BoxShadow(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark,
                                                              spreadRadius: 0.5,
                                                              blurRadius: 14,
                                                            )
                                                          : BoxShadow(
                                                              color: Colors.black45,
                                                              spreadRadius: 0.3,
                                                              blurRadius: 4,
                                                            ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(14.0),
                                                    child: Center(
                                                      child: Text(
                                                        recommendedExercise[
                                                            'daily_main_ex_recommend'],
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: nowShow == 'main'
                                                              ? Theme.of(context)
                                                                  .primaryColor
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '메인 운동',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Icon(
                                            Icons.next_plan,
                                          ),
                                          Column(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    nowShow = 'end';
                                                    nowShowVideo = Uri.parse(
                                                        recommendedExercise[
                                                            "daily_${nowShow}_ex_video"]);
                                                  });
                                                  // _webViewController?.loadUrl(
                                                  //     urlRequest: URLRequest(
                                                  //         url: nowShowVideo));
                                                  changeVideo();
                                                },
                                                child: Container(
                                                  width: 90,
                                                  height: 90,
                                                  decoration: BoxDecoration(
                                                    color: nowShow == 'end'
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                            .primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    boxShadow: [
                                                      nowShow == 'end'
                                                          ? BoxShadow(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColorDark,
                                                              spreadRadius: 0.5,
                                                              blurRadius: 14,
                                                            )
                                                          : BoxShadow(
                                                              color: Colors.black45,
                                                              spreadRadius: 0.3,
                                                              blurRadius: 4,
                                                            ),
                                                    ],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(14.0),
                                                    child: Center(
                                                      child: Text(
                                                        recommendedExercise[
                                                            'daily_end_ex_recommend'],
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: nowShow == 'end'
                                                              ? Theme.of(context)
                                                                  .primaryColor
                                                              : Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '마무리 운동',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
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

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
