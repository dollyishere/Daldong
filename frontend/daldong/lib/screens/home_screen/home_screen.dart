import 'dart:io';
import 'package:daldong/screens/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:daldong/widgets/home_screen/info_block.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final InAppLocalhostServer localhostServer = new InAppLocalhostServer();
  bool loading = true;

  // final controller = WebViewController()
  //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //   ..setBackgroundColor(const Color(0x00000000))
  //   ..setNavigationDelegate(
  //     NavigationDelegate(
  //       onProgress: (int progress) {
  //         // Update loading bar.
  //       },
  //       onPageStarted: (String url) {},
  //       onPageFinished: (String url) {},
  //       onWebResourceError: (WebResourceError error) {},
  //       onNavigationRequest: (NavigationRequest request) {
  //         if (request.url.startsWith('https://www.youtube.com/')) {
  //           return NavigationDecision.prevent;
  //         }
  //         return NavigationDecision.navigate;
  //       },
  //     ),
  //   )
  //   ..loadRequest(Uri.parse(
  //       'http://192.168.137.1:3000/create-react-app-typescript-babylonjs'));

  Future<void> getLocalHost() async {
    // start the localhost server
    await localhostServer.start();

    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    print('gkgkgkgkgk');
    await Future.delayed(const Duration(milliseconds: 10));
    setState(() {
      loading = false;
      print(loading);
    });
  }

  static const storage = FlutterSecureStorage();
  dynamic userName = '';
  dynamic userProfileImg = '';
  dynamic userEmail = '';

  checkUserState() async {
    var name = await storage.read(key: 'nickName');
    var img = await storage.read(key: 'picture');
    var email = await storage.read(key: 'googleEmail');
    print(userName);
    setState(() {
      userName = name;
      userProfileImg = img;
      userEmail = email;
    });
    if (name == null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      ); // 로그인 페이지로 이동
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    // getLocalHost();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkUserState();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InfoBlock(
              petNumber: 5,
              nickName: 'jy',
              playerLevel: 10,
              playerExp: 1100,
              playerKcal: 2540,
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              width: double.infinity,
              height: 420,
              child: loading
                  ? Center(
                      child: Text(
                        'Welcome!',
                      ),
                    )
                  : Center(
                      child: Text(
                        'Welcome!',
                      ),
                    ),
              // : InAppWebView(
              //     initialUrlRequest: URLRequest(
              //       url: Uri.parse(
              //           "http://localhost:8080/lib/assets/htmls/index.html"),
              //     ),
              //     onWebViewCreated: (controller) {},
              //     onLoadStart: (controller, url) {},
              //     onLoadStop: (controller, url) {},
              //   ),
              // WebViewWidget(
              //   controller: controller,
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
