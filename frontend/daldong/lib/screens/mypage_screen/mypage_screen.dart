import 'package:daldong/services/user_api.dart';
import 'package:daldong/utilites/common/notification_util.dart';
import 'package:daldong/widgets/common/button.dart';
import 'package:daldong/widgets/common/footer.dart';
import 'package:daldong/widgets/mypage_screen/update_nickname_dialog.dart';
import 'package:daldong/widgets/mypage_screen/update_userinfo_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({Key? key}) : super(key: key);

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  static const storage = FlutterSecureStorage();
  Map<String, dynamic> userInfo = {};

  bool isLoading = true;

  dynamic _nickname = '';
  dynamic _height = 0;
  dynamic _weight = 0;
  dynamic _gender = false;
  dynamic _age = 0;
  dynamic _ability = 0;
  dynamic _userLevel = 0;
  dynamic _userPoint = 0;
  dynamic _mainPetName = "Sparrow";

  @override
  void initState() {
    super.initState();
    NotificationUtil.setupInteractedMessage(context);
    // 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMypageInfo();
    });
  }

  void getMypageInfo() async {
    String? mainPetName = await storage.read(key: "mainPetName");
    getUserMypage(success: (dynamic response) {
      setState(() {
        userInfo = response['data'];
        _nickname = userInfo['nickname'];
        _height = userInfo['height'];
        _weight = userInfo['weight'];
        _gender = userInfo['gender'];
        _age = userInfo['age'];
        _ability = userInfo['ability'];
        _userLevel = userInfo['userLevel'];
        _userPoint = userInfo['userPoint'];
        _mainPetName = mainPetName;
        print(_mainPetName);
        isLoading = false;
      });
    }, fail: (error) {
      print("마이페이지 정보 로드 오류: $error");
    });
  }

  String getUserAbility(int ability) {
    switch (ability) {
      case 0:
        return "입문자";
      case 1:
        return "초심자";
      case 2:
        return "중급자";
      case 3:
        return "상급자";
      default:
        return "오류";
    }
  }

  void signOut() async {
    // storage의 정보 날린 뒤 로그아웃 시킨다.
    await storage.deleteAll();
    await GoogleSignIn().disconnect();
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (context) => LoginScreen(),
    //   ),
    // );
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    bool nowLogin = false;
    late String displayName;
    late String email;
    late String photoUrl;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Footer(),
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      height: 220,
                      color: Theme.of(context).primaryColorLight,
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFFF4F5E5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.5),
                                      spreadRadius: 0.3,
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 80,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "lib/assets/images/animals/${_mainPetName}.png"),
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    width: 10,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context)
                                          .shadowColor
                                          .withOpacity(0.5),
                                      spreadRadius: 0.3,
                                      blurRadius: 6,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit,
                                      color: Colors.transparent),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 17),
                                  child: Text(
                                    '$_nickname',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return UpdateNicknameDialog(
                                            updateNickname: getMypageInfo,
                                            originalNickname: _nickname,
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.edit)),
                              ],
                            ),
                          ),
                          WhiteBox(
                            widget: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "$_userLevel",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      "Level",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 2, // Width of the vertical line
                                  height: 35,
                                  color: Colors.grey
                                      .shade300, // Color of the vertical line
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "$_userPoint",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      "Points",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          WhiteBox(
                              widget: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "나이",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    GreenButton(title: "$_age세")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "키",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    GreenButton(title: "${_height}cm")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "몸무게",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    GreenButton(title: "${_weight}kg")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "성별",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    GreenButton(title: _gender ? "남성" : "여성")
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "운동 수준",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    GreenButton(title: getUserAbility(_ability))
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return UpdateUserInfoDialog(
                                        updateInfo: getMypageInfo,
                                        originalAge: _age,
                                        originalHeight: _height,
                                        originalWeight: _weight,
                                        originalAbility: _ability,
                                        originalGender: _gender,
                                      );
                                    },
                                  );
                                },
                                child: const GreenButton(title: "나의 정보 수정"),
                              ),
                            ],
                          )),
                          SizedBox(
                            height: 10,
                          ),
                          WhiteBox(
                              widget: Column(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    signOut();
                                  },
                                  child: GreenButton(title: "로그아웃")),
                              SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "회원 탈퇴",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              )
                            ],
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class WhiteBox extends StatelessWidget {
  final Widget widget;

  const WhiteBox({
    required this.widget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 3.0,
            spreadRadius: 1.0,
          )
        ],
      ),
      child: widget,
    );
  }
}
