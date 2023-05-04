import 'package:daldong/screens/home_screen/home_screen.dart';
import 'package:daldong/screens/profile_screen/profile_screen.dart';
import 'package:daldong/screens/root_screen/root_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const storage =
      FlutterSecureStorage(); // FlutterSecureStorage를 storage로 저장
  // dynamic userName = ''; // storage에 있는 유저 정보를 저장
  Map<String, dynamic> userInfo = {};

  //flutter_secure_storage 사용을 위한 초기화 작업
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool nowLogin = false;
    late String displayName;
    late String email;
    late String photoUrl;

    Future signInWithGoogle() async {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = googleAuth.accessToken;
      print('token: ${googleUser.hashCode}');
      print('token: ${googleUser.authentication}');
      print('token: ${googleUser.serverAuthCode}');
      print('token: ${googleUser.authHeaders}');
      print('구분선');
      print(googleUser.authHeaders.toString());
      // print('hash: ${googleAuth.hashCode}');
      // print('access: ${googleAuth.accessToken}');
      print(googleAuth?.idToken);
      // print(googleUser.id);

      final googleCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      print(googleCredential);
      // // Once signed in, return the UserCredential
      // await FirebaseAuth.instance.signInWithCredential(googleCredential);

      if (googleUser != null) {
        print(googleUser.photoUrl);
        await storage.write(
          key: "accessToken",
          value: credential,
        );
        setState(() {
          displayName = googleUser.displayName!;
          email = googleUser.email;
          photoUrl = googleUser.photoUrl!;
          nowLogin = true;
        });
        await storage.write(key: "nickName", value: googleUser.displayName);
        await storage.write(key: "picture", value: googleUser.photoUrl);
        await storage.write(key: "googleEmail", value: googleUser.email);
        setState(() {});
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => HomeScreen(),
        //   ),
        // );

        Navigator.pushReplacementNamed(context, '/home');
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: nowLogin
            ? Column(
                children: [
                  CircleAvatar(
                    radius: 50, // 원의 반지름 설정
                    backgroundImage: NetworkImage(photoUrl), // 이미지 가져오기
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
                    child: Text(
                      displayName,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )
            : TextButton(
                onPressed: signInWithGoogle,
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
                        "구글로 시작하기",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
