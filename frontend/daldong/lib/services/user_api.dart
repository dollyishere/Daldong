import 'package:daldong/services/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String? baseUrl = dotenv.env['SPRING_API_URL'];


void getUserMypage({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
}) {
  apiInstance(
    path: '$baseUrl/user/mypage',
    method: Method.get,
    success: success,
    fail: fail,
  );
}

Future<dynamic> updateUserNickname({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required Map<String, dynamic> body,
}) async {
  try {
    Future<String?> futureString = storage.read(key: "accessToken");
    String? accessToken = await futureString;
    final response = await http.put(
      Uri.parse("$baseUrl/user/mypage/nickname"),
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "accessToken": "$accessToken",
      },
      body: json.encode(body),
    );

    print("updateUserNickname 결과: ${response.statusCode}");
    return success(response);
  } catch (error) {
    fail('HTTP 요청 처리 중 오류 발생: $error');
  }
}

void updateUserInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required Map<String, dynamic> body,
}) {
  apiInstance(
    path: '$baseUrl/user/mypage',
    method: Method.put,
    success: success,
    fail: fail,
    body: body,
  );
}
