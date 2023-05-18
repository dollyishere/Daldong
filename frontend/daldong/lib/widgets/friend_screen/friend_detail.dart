import 'dart:io';
import 'package:daldong/services/home_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/services.dart';

class FriendDetail extends StatefulWidget {
  final String friendNickname;
  final String mainPetAssetName;
  final String mainBackAssetName;
  final int friendUserLevel;

  const FriendDetail({
    Key? key,
    required this.friendNickname,
    required this.mainPetAssetName,
    required this.mainBackAssetName,
    required this.friendUserLevel,
  }) : super(key: key);

  @override
  State<FriendDetail> createState() => _FriendDetailState();
}

class _FriendDetailState extends State<FriendDetail> {
  // final InAppLocalhostServer localhostServer = new InAppLocalhostServer();
  InAppWebViewController? _webViewController;

  bool isLoading = false;

  // Future<void> getLocalHost() async {
  //   // start the localhost server
  //   await localhostServer.start();
  //
  //   if (Platform.isAndroid) {
  //     await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  //   }
  //   await Future.delayed(const Duration(milliseconds: 10));
  //   setState(() {
  //     isLoading = false;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    // getLocalHost();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _webViewController!.clearCache();
    // localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      floatingActionButton: InkWell(
        onTap: () => {
          Navigator.pop(context),
        },
        splashColor: Colors.transparent,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).primaryColorDark,
          child: Icon(
            Icons.highlight_remove_outlined,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '친구 상세',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    width: 64,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        '닉네임',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.friendNickname,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
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
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: DecorationImage(
                        image: AssetImage(
                            "lib/assets/images/animals/${widget.mainPetAssetName}.png"),
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
                          color: Theme.of(context).shadowColor.withOpacity(0.5),
                          spreadRadius: 0.3,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 64,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        '레벨',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.friendUserLevel.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            width: double.infinity,
            height: 240,
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: InAppWebView(
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
                              'setVariable( "${widget.mainBackAssetName}", "${widget.mainPetAssetName}")',
                        );
                      },
                      onConsoleMessage: (controller, consoleMessage) {
                        print('나 여기 있어');
                        print(consoleMessage.message);
                      },
                    ),
                  ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
