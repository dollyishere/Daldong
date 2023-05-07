import 'package:daldong/services/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? baseUrl = dotenv.env['SPRING_API_URL'];
String? weatherUrl = dotenv.env['WEATHER_API_URL'];
String? weatherApiKey = dotenv.env['WEATHER_API_KEY'];

// 운동 메인 페이지(오늘 운동 로그) 조회
void getTodayExerciseLog({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
  required int userId,
}) {
  apiInstance(
    path: '${baseUrl}/test/api/exercise/${userId}',
    method: Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}

// 1개월 치 운동 기록 조회
void getMonthlyExerciseLog({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
  required int userId,
  required int month,
}) {
  apiInstance(
    path: '${baseUrl}/test/api/exercise/monthly/${userId}/${month}',
    method: Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}

// 날씨 정보 조회
void getWeatherInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
  required double lat,
  required double lon,
}) {
  apiInstance(
    path: '${weatherUrl}?lat=${lat}&lon=${lon}&appid=${weatherApiKey}&units=metric&lang=kr',
    method: Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}

