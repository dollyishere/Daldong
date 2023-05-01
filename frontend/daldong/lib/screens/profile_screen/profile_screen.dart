import 'package:daldong/screens/login_screen/login_screen.dart';
import 'package:daldong/widgets/common/footer.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const storage = FlutterSecureStorage();
  dynamic userName = '';
  dynamic userProfileImg = '';
  dynamic userEmail = '';

  checkUserState() async {
    var name = await storage.read(key: 'nickName');
    var img = await storage.read(key: 'picture');
    var email = await storage.read(key: 'googleEmail');
    setState(() {
      userName = name;
      userProfileImg = img;
      userEmail = email;
    });
    if (userName == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      ); // 로그인 페이지로 이동
    }
  }

  @override
  void initState() {
    super.initState();
// 비동기로 flutter secure storage 정보를 불러오는 작업
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
    print('haha');
  }

  void signOut() async {
    await GoogleSignIn().signOut();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50, // 원의 반지름 설정
                backgroundImage: NetworkImage(userProfileImg ?? ""), // 이미지 가져오기
              ),
              Container(
                width: 240,
                height: 40,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 3.0,
                      spreadRadius: 1.0,
                    )
                  ],
                ),
                child: Center(
                    child: Text(
                  userName ?? "기본값",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
              ),
              TextButton(
                onPressed: signOut,
                child: Container(
                  width: 240,
                  height: 40,
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: const DecorationImage(
                            image: AssetImage(
                                'lib/assets/images/common/google_logo.png'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        "로그아웃하기",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
