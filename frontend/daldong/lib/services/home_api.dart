import 'package:daldong/services/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? baseUrl = dotenv.env['SPRING_API_URL'];

// 현 상황 받아오기
void getMainStatus({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
}) {
  apiInstance(
    path: '${baseUrl}/main/',
    method: Method.get,
    success: success,
    fail: fail,
  );
}
