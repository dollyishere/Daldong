import 'package:daldong/services/login_api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
Map<String, dynamic> homeStatus = {};
String nickname = '';
int userLevel = 0;
int userExp = 0;
int requiredExp = 0;
int userPoint = 0;
String mainBackName = 'Island_12';
String mainPetName = 'Sparrow';
String petNickName = '짹짹쓰';

saveUserInfo(
    String uid,
    String nickname,
    int userLevel,
    int userExp,
    int requiredExp,
    int userPoint,
    String mainBackName,
    String mainPetName,
    ) async {
  await storage.write(key: "uid", value: uid);
  await storage.write(key: "nickname", value: nickname);
  await storage.write(key: "userLevel", value: userLevel.toString());
  await storage.write(key: "userExp", value: userExp.toString());
  await storage.write(key: "requiredExp", value: requiredExp.toString());
  await storage.write(key: "userPoint", value: userPoint.toString());
  await storage.write(key: "mainBackName", value: mainBackName);
  await storage.write(key: "mainPetName", value: mainPetName);
}

Future<bool> login() async {
  print("login 시작");
  //TODO: statusCode에 따라 결과를 다르게 할 것인가?
  String? idToken = await storage.read(key: "idToken");
  bool isLoggedIn = false;
  String uid = "";

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
          uid = response.headers['uid'];
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
      idToken: idToken!);
  await getUserInfo(success: (dynamic response) async {
    homeStatus = response['data'];
    nickname = homeStatus['nickname'];
    userLevel = homeStatus['userLevel'];
    userExp = homeStatus['userExp'];
    requiredExp = homeStatus['requiredExp'];
    userPoint = homeStatus['userPoint'];
    mainBackName = homeStatus['mainBackName'];
    mainPetName = homeStatus['mainPetName'];
    saveUserInfo(
      uid,
      nickname,
      userLevel,
      userExp,
      requiredExp,
      userPoint,
      mainBackName,
      mainPetName,
    );
  }, fail: (error) {
    print('홈 화면 정보 로드 오류: $error');
  });
  print("login 함수 결과: $isLoggedIn");
  return isLoggedIn;
}
