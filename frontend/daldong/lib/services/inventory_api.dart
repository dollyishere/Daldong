import 'package:daldong/services/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? baseUrl = dotenv.env['SPRING_API_URL'];

// 인벤토리 현 상황 받아오기
void getInvenStatus({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
}) {
  apiInstance(
    path: '${baseUrl}/main/inven/',
    method: Method.get,
    success: success,
    fail: fail,
  );
}

// 펫 이름 변경하기
void putChangePetNickname(
    {required dynamic Function(dynamic) success,
    required Function(String error) fail,
    required dynamic body}) {
  apiInstance(
    path: '${baseUrl}/main/inven/setPetName/',
    method: Method.put,
    success: success,
    fail: fail,
    body: body,
  );
}

// 에셋 구매하기
void postBuyAsset(
    {required dynamic Function(dynamic) success,
    required Function(String error) fail,
    required dynamic body}) {
  apiInstance(
    path: '${baseUrl}/main/inven/buy/',
    method: Method.post,
    success: success,
    fail: fail,
    body: body,
  );
}

// 메인으로 설정하기
void putChangeMainAsset(
    {required dynamic Function(dynamic) success,
    required Function(String error) fail,
    required dynamic body}) {
  apiInstance(
    path: '${baseUrl}/main/inven/set/',
    method: Method.put,
    success: success,
    fail: fail,
    body: body,
  );
}
