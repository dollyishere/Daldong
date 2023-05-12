import 'package:daldong/services/login_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

Future<bool> login() async {
  print("login 시작");
  //TODO: statusCode에 따라 결과를 다르게 할 것인가?
  String? idToken = await storage.read(key: "idToken");
  bool isLoggedIn = false;

  await getLoggedIn(
      success: (dynamic response) async {
        if (response.statusCode == 200) {
          print("우리의 유저");
          // 기존 유저
          String accessToken = response.headers['accesstoken'];
          await storage.write(key: 'accessToken', value: accessToken);
          print("accessToken: $accessToken");
          isLoggedIn = true;
          storage.write(key: "isLoggedIn", value: '$isLoggedIn');
          // 로그인 후에는 idToken 삭제
          storage.delete(key: "idToken");
        } else if (response.statusCode == 404) {
          String uid = response.headers['uid'];
          print("uid: $uid");
          await storage.write(key: 'uid', value: uid);
          // 새로운 유저
          print("새로운 유저, 회원가입 필요");
        } else {
          print("getLoggedIn 오류: ${response.statusCode}");
        }
      },
      fail: (error) {
        print("유저 인증 호출 오류: $error");
      },
      idToken: idToken!
  );
  print("login 함수 결과: $isLoggedIn");
  return isLoggedIn;
}