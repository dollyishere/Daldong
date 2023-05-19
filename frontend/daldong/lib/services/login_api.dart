import 'package:daldong/services/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final String? baseUrl = dotenv.env['SPRING_API_URL'];

Future<dynamic> getLoggedIn({
  required String idToken,
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required Map<String, String> body

}) async{
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/user/signin"),
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "idToken": idToken,
      },
      body: json.encode(body)
    );
    print("getLoggedIn 결과: ${response.statusCode}\n${response.headers}");
    return success(response);
  } catch (error) {
    fail('HTTP 요청 처리 중 오류 발생: $error');
  }

}

Future<dynamic> getSignedIn({
  required String uid,
  required dynamic Function(dynamic) result,
  required Function(String error) fail,
}) async{
  try {
    final response = await http.post(
        Uri.parse("$baseUrl/api/user/signup"),
        headers: {'uid': uid}
    );
    print("getSignedIn 결과: ");
    print(response.statusCode);
    return result(response);
  } catch (error) {
    fail('HTTP 요청 처리 중 오류 발생: $error');
  }
}

Future<dynamic> getNicknameCheck({
  required String nickname,
  required dynamic Function(dynamic) result,
  required Function(String error) fail,
}) async{
  try {
    final response = await http.get(
      Uri.parse("$baseUrl/user/nameCheck?nickname=$nickname"),
    );
    print("getNicknameCheck2 결과: ${response.statusCode}");
    return result(response);
  } catch (error) {
    fail('HTTP 요청 처리 중 오류 발생: $error');
  }
}

Future<dynamic> postUser({
  required String uid,
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required Map<String, dynamic> body,
}) async{
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/user/signup"),
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "uid": uid,
      },
      body: json.encode(body),
    );
    print("postUser 결과: ");
    print(response.statusCode);
    await storage.write(key: 'uid', value: uid);
    return success(response);
  } catch (error) {
    fail('HTTP 요청 처리 중 오류 발생: $error');
  }
}

Future<dynamic> getUserInfo({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
}) async {
  try {
    Future<String?> futureString = storage.read(key: "accessToken");
    String? accessToken = await futureString;
    final jsonResponse = await http.get(
      Uri.parse("$baseUrl/main/"),
      headers: {
        "Content-Type": "application/json;charset=utf-8",
        "accessToken": "$accessToken",
      }
    );
    dynamic response = await jsonDecode(utf8.decode(jsonResponse.bodyBytes));
    return success(response);
  } catch (error) {
    fail('HTTP 요청 처리 중 오류 발생: $error');
  }
}

