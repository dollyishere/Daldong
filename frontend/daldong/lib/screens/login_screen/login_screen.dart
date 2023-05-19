import 'package:daldong/utilites/common/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  dynamic _isLoggedIn = false;
  Map<String, dynamic> userInfo = {};
  bool isUserInDatabase = false;
  bool _isLoading = false;
  double _opacityLevel = 1.0;

  void _changeOpacity() {
    setState(() {
      _isLoading = true;
    });
  }

  Future<void> logInWithGoogle() async {
    print("Start");
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    print("credential $credential");

    // Once signed in, return the UserCredential
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    print("userCredential ${userCredential.user?.uid}");
    await storage.write(key: "uid", value: userCredential.user?.uid);

    final idTokenResult = await userCredential.user!.getIdToken();
    print("idTokenResult $idTokenResult");
    await storage.write(key: "idToken", value: idTokenResult);
    print("middle");
    print(googleUser);
    // Try logging in
    bool isLoggedIn = await login();
    String? nickname = await storage.read(key: "nickname");
    print(nickname);
    print(isLoggedIn);
    print("end");
    // print(isLoggedIn);
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = true;
    });
  }

  void _checkLoginStatus() async {
    String? isLoggedInStr = await storage.read(key: 'isLoggedIn');
    bool isLoggedIn = isLoggedInStr == 'true';
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
    if (_isLoggedIn == true) {
      print("이전에 로그인 기록이 있는 유저");
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print("이전에 로그인 기록이 없는 유저");
    }
  }

  void signOut() async {
    // storage의 정보 날린 뒤 로그아웃 시킨다.
    await storage.deleteAll();
    await GoogleSignIn().disconnect();
    Navigator.pushReplacementNamed(context, '/login');
  }

  //flutter_secure_storage 사용을 위한 초기화 작업
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);

  late final Animation<double> _animation =
      CurvedAnimation(parent: _controller, curve: Curves.easeInToLinear);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'lib/assets/images/common/title.png',
                  width: 300,
                  height: 120,
                ),
                SizedBox(height: 10,),
                Image.asset(
                  'lib/assets/images/common/main_logo.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(height: 30,),
                Text('혼자 운동하기 적적한', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,),),
                SizedBox(height: 10,),
                Text('당신을 위해', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,),),
                SizedBox(height: 90,),
                TextButton(
                  onPressed: () async {
                    await logInWithGoogle();
                    if (_isLoggedIn == true) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      Navigator.pushReplacementNamed(context, '/signin');
                    }
                  },
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
              ],
            )
          ),
          Center(
            child: Visibility(
              visible: _isLoading,
              child: Container(
                color: Colors.black26,
                child: FadeTransition(
                  opacity: _animation,
                  child: Center(
                    child: Image.asset(
                      'lib/assets/images/common/main_logo.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
