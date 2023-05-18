import 'dart:io';
import 'package:daldong/screens/inventory_screen/inventory_screen.dart';
import 'package:daldong/services/home_api.dart';
import 'package:daldong/widgets/common/footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:daldong/widgets/home_screen/info_block.dart';
import 'package:flutter/services.dart';

class FriendDetail extends StatefulWidget {
  FriendDetail({Key? key}) : super(key: key);

  @override
  State<FriendDetail> createState() => _FriendDetailState();
}

class _FriendDetailState extends State<FriendDetail> {
  final InAppLocalhostServer localhostServer = new InAppLocalhostServer();
  InAppWebViewController? _webViewController;

  bool apiLoading = false;
  bool isLoading = false;

  Map<String, dynamic> homeStatus = {};
  String nickname = '';

  int userLevel = 0;
  int userExp = 0;
  int requiredExp = 0;
  int userPoint = 0;

  String mainBackName = '';
  String mainPetName = '';
  String mainPetCustomName = '';

  Future<void> getLocalHost() async {
    // start the localhost server
    await localhostServer.start();

    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    await Future.delayed(const Duration(milliseconds: 10));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getMainStatus(success: (dynamic response) {
        setState(() {
          homeStatus = response['data'];
          nickname = homeStatus['nickname'];
          mainPetCustomName = homeStatus['mainPetCustomName'];
          userLevel = homeStatus['userLevel'];
          userExp = homeStatus['userExp'];
          requiredExp = homeStatus['requiredExp'];
          userPoint = homeStatus['userPoint'];
          mainBackName = homeStatus['mainBackName'];
          mainPetName = homeStatus['mainPetName'];
        });
        print(homeStatus['mainPetCustomName']);
      }, fail: (error) {
        print('홈 화면 정보 로드 오류: $error');
      });
    });
    getLocalHost();
    // sendToKotlin 함수 호출
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _webViewController!.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: apiLoading
          ? Container(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
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
                    width: 132,
                    height: 132,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage(
                              "lib/assets/images/animals/${'Dog'}.png"),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).secondaryHeaderColor,
                          width: 10,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Theme.of(context).shadowColor.withOpacity(0.5),
                            spreadRadius: 0.3,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 42,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Text(
                                  'LV.${50}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 10,
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 36,
                            ),
                            Container(
                              width: 72,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.75),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InfoBlock(
                    petName: mainPetName,
                    nickName: nickname,
                    playerLevel: userLevel,
                    playerExp: userExp,
                    requiredExp: requiredExp,
                    playerPoint: userPoint,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //   ),
                  //   width: double.infinity,
                  //   height: MediaQuery.of(context).size.width,
                  //   child: isLoading
                  //       ? CircularProgressIndicator(
                  //           color: Theme.of(context).primaryColor,
                  //         )
                  //       : InAppWebView(
                  //           initialUrlRequest: URLRequest(
                  //             url: Uri.parse(
                  //                 "http://localhost:8080/lib/assets/models/daldong_webview.html"),
                  //           ),
                  //           onWebViewCreated: (controller) {
                  //             _webViewController = controller;
                  //             _webViewController!.evaluateJavascript(
                  //               source: 'setVariable("hello!")',
                  //             );
                  //           },
                  //           onLoadStart: (controller, url) async {},
                  //           onLoadStop: (controller, url) {
                  //             _webViewController!.evaluateJavascript(
                  //               source:
                  //                   'setVariable( "${mainBackName}", "${mainPetName}")',
                  //             );
                  //           },
                  //           onConsoleMessage: (controller, consoleMessage) {
                  //             print('나 여기 있어');
                  //             print(consoleMessage.message);
                  //           },
                  //         ),
                  // ),
                ],
              ),
            ),
    );
  }
}
