import 'package:daldong/services/api.dart';

// 렌트 내역
void getSimpleRentInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) {
  apiInstance(
    path: '/car/history',
    method: Method.get,
    body: body,
    success: success,
    fail: fail,
  );
}
