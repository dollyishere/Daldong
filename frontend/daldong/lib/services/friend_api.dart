import 'package:daldong/services/api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? baseUrl = dotenv.env['SPRING_API_URL'];

// 친구 목록 가져오기
void getMyFriendList({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required int userId,
}) {
  apiInstance(
    path: '${baseUrl}/test/api/friend/${userId}',
    method: Method.get,
    success: success,
    fail: fail,
  );
}

// 친구 찌르기
void putStingFriend({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
  required int userId,
  required int friendId,
}) {
  apiInstance(
    path: '${baseUrl}/test/api/friend/sting/${userId}/${friendId}',
    method: Method.put,
    body: body,
    success: success,
    fail: fail,
  );
}

// 친구 상세 정보 가져오기
void getFriendDetail({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required int friendId,
}) {
  apiInstance(
    path: '${baseUrl}/test/api/friend/${friendId}',
    method: Method.get,
    success: success,
    fail: fail,
  );
}

// 친구 요청하기
void postFriendRequest({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
}) {
  apiInstance(
    path: '${baseUrl}/test/api/friend/request',
    method: Method.post,
    body: body,
    success: success,
    fail: fail,
  );
}

// 친구 요청 처리하기
void postFriendRequestResult({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, dynamic>? body,
}) {
  apiInstance(
    path: '${baseUrl}/test/api/friend/request/result',
    method: Method.post,
    body: body,
    success: success,
    fail: fail,
  );
}

// 받은 친구 목록 가져오기
void getReceivedList({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required int userId,
}) {
  apiInstance(
    path: '${baseUrl}/test/api/friend/request/received/${userId}',
    method: Method.get,
    success: success,
    fail: fail,
  );
}

// 보낸 친구 목록 가져오기
void getSendList({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required int userId,
}) {
  apiInstance(
    path: '${baseUrl}/test/api/friend/request/send/${userId}',
    method: Method.get,
    success: success,
    fail: fail,
  );
}

// 친구 검색하기
void getSearchFriendList({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  required int userId,
}) {
  apiInstance(
    path: '${baseUrl}/test/api/friend/search',
    method: Method.get,
    success: success,
    fail: fail,
  );
}

// 친구 요청 처리하기
void deleteMyFriend({
  required dynamic Function(dynamic) success,
  required Function(String error) fail,
  Map<String, String>? body,
  required int userId,
  required int friendId,
}) {
  apiInstance(
    path: '${baseUrl}/test/api/friend/${userId}/${friendId}',
    method: Method.delete,
    body: body,
    success: success,
    fail: fail,
  );
}
