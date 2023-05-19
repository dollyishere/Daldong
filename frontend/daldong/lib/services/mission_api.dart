import 'package:daldong/services/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? baseUrl = dotenv.env['SPRING_API_URL'];

// 미션 현 상황 받아오기
void getMissionStatus({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
}) {
  apiInstance(
    path: '${baseUrl}/mission/',
    method: Method.get,
    success: success,
    fail: fail,
  );
}

// 미션 포인트 받기
void putMissionPoint({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required int userMissionId,
}) {
  apiInstance(
    path: '${baseUrl}/mission/$userMissionId',
    method: Method.put,
    success: success,
    fail: fail,
  );
}
