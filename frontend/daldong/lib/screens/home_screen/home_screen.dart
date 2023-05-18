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

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  InAppLocalhostServer? localhostServer;
  InAppWebViewController? _webViewController;

  bool apiLoading = true;
  bool isLoading = true;

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
    if (localhostServer == null) {
      localhostServer = new InAppLocalhostServer();
      await localhostServer?.start();

      if (Platform.isAndroid) {
        await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(
            true);
      }
    }
    await Future.delayed(const Duration(milliseconds: 10));
  }

  Future<void> sendToKotlin() async {
    // MethodChannel을 초기화합니다.
    const platform = MethodChannel('login.method.channel');

    print('method channel 들어옴');

    try {
      // Kotlin에서 처리할 메소드 이름을 지정합니다.
      String methodName = 'loginMethod';

      // Kotlin으로 메시지를 보냅니다.
      await platform.invokeMethod(methodName, {
        'uid': await storage.read(key: 'uid'),
        'mainPetCustomName': await storage.read(key: 'mainPetCustomName'),
        'mainPetName': await storage.read(key: 'mainPetName'),
      }).then((result) {
        // Kotlin에서의 처리가 성공적으로 완료되었을 때 실행될 코드
        print('method channel 열어서 전달 성공');
      }).catchError((error) {
        // Kotlin에서의 처리가 실패했을 때 실행될 코드
        print('method channel 열어서 전달 실패: $error');
      });
    } catch (e) {
      print('method channel 기타 에러: $e');
    }
  }

  static const storage = FlutterSecureStorage();

  void changeMainAsset(String itemCase, String assetName) async {
    if (itemCase == 'pet') {
      await storage.write(key: "mainPetName", value: assetName);
      setState(() {
        mainPetName = assetName;
      });
    } else {
      setState(() {
        mainBackName = assetName;
      });
      await storage.write(key: "mainBackName", value: assetName);
    }
    _webViewController?.reload();
    setState(() {});
  }

  void changeUserPoint(int minusPoint) async {
    setState(() {
      userPoint -= minusPoint;
    });
    await storage.write(key: "userPoint", value: userPoint.toString());
    setState(() {});
  }

  saveHomeInfo(
    String nickname,
    String mainPetCustomName,
    int userLevel,
    int userExp,
    int requiredExp,
    int userPoint,
    String mainBackName,
    String mainPetName,
  ) async {
    await storage.write(key: "nickname", value: nickname);
    await storage.write(key: "mainPetCustomName", value: mainPetCustomName);
    await storage.write(key: "userLevel", value: userLevel.toString());
    await storage.write(key: "userExp", value: userExp.toString());
    await storage.write(key: "requiredExp", value: userExp.toString());
    await storage.write(key: "userPoint", value: userPoint.toString());
    await storage.write(key: "mainBackName", value: mainBackName);
    await storage.write(key: "mainPetName", value: mainPetName);
    await Future.delayed(const Duration(milliseconds: 20));
    setState(() {
      apiLoading = false;
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
        saveHomeInfo(
          nickname,
          mainPetCustomName,
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
      getLocalHost();
    });
    // sendToKotlin 함수 호출
    sendToKotlin();
    setState(() {
      isLoading = false;
    });
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
      child: Scaffold(
        bottomNavigationBar: Footer(),
        body: apiLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InfoBlock(
                    petName: mainPetName,
                    nickName: nickname,
                    playerLevel: userLevel,
                    playerExp: userExp,
                    requiredExp: requiredExp,
                    playerPoint: userPoint,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width,
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                        : InAppWebView(
                            initialUrlRequest: URLRequest(
                              url: Uri.parse(
                                  "http://localhost:8080/lib/assets/models/daldong_webview.html"),
                            ),
                            onWebViewCreated: (controller) {
                              _webViewController = controller;
                              _webViewController!.evaluateJavascript(
                                source: 'setVariable("hello!")',
                              );
                            },
                            onLoadStart: (controller, url) async {},
                            onLoadStop: (controller, url) {
                              _webViewController!.evaluateJavascript(
                                source:
                                    'setVariable( "${mainBackName}", "${mainPetName}")',
                              );
                            },
                            onConsoleMessage: (controller, consoleMessage) {
                              print('나 여기 있어');
                              print(consoleMessage.message);
                            },
                          ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(180, 30),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InventoryScreen(
                                    mainPetAssetName: mainPetName,
                                    mainRoomAssetName: mainBackName,
                                    changeMainAsset: changeMainAsset,
                                    changeUserPoint: changeUserPoint,
                                  )),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '인벤토리',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
