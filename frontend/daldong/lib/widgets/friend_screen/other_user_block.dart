import 'package:daldong/services/friend_api.dart';
import 'package:flutter/material.dart';

class OtherUserBlock extends StatefulWidget {
  final int friendId;
  final String friendNickname;
  final int friendUserLevel;
  final String mainPetAssetName;
  final String useCase;
  final void Function(int) stateFunction;
  // final void Function(BuildContext, Function, String, String, String, String,
  //     {dynamic data}) showConfirmationDialog;

  const OtherUserBlock({
    Key? key,
    required this.friendId,
    required this.friendNickname,
    required this.friendUserLevel,
    required this.mainPetAssetName,
    required this.useCase,
    required this.stateFunction,
    // required this.showConfirmationDialog,
  }) : super(key: key);

  @override
  State<OtherUserBlock> createState() => _OtherUserBlockState();
}

class _OtherUserBlockState extends State<OtherUserBlock> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 242,
        height: 70,
        child: Stack(
          children: [
            Positioned(
              top: 7,
              left: 20,
              child: Container(
                width: 242,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      spreadRadius: 0.3,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 34,
                        height: double.infinity,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      Container(
                        width: 92,
                        height: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'LV.${widget.friendUserLevel}',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              widget.friendNickname,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 10,
                                color: Theme.of(context).secondaryHeaderColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 48,
                      //   width: 2,
                      //   color: widget.isSting == 1
                      //       ? Colors.transparent
                      //       : Theme.of(context).primaryColorDark,
                      // ),
                      InkWell(
                        onTap: () {
                          print('하하');
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: 52,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColorLight,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            // crossAxisAlignment: CrossAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.account_box,
                                color: Theme.of(context).secondaryHeaderColor,
                                size: 16,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                '상세보기',
                                style: TextStyle(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Stack(
                          children: [
                            Container(
                              width: 20,
                              height: double.infinity,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorDark,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (widget.useCase == 'search') {
                                    postFriendRequest(
                                        success: (dynamic response) {
                                          print(response);
                                          print('친구 요청 완료');
                                          setState(() {
                                            widget
                                                .stateFunction(widget.friendId);
                                            print(widget.friendId);
                                          });
                                        },
                                        fail: (error) {
                                          print('친구 요청 오류 : $error');
                                          // Navigator.pushNamedAndRemoveUntil(
                                          //   context,
                                          //   '/error',
                                          //   arguments: {
                                          //     'errorText': error,
                                          //   },
                                          //   ModalRoute.withName('/home'),
                                          // );
                                        },
                                        body: {
                                          'receiverId':
                                              widget.friendId.toString(),
                                          'senderId': '1',
                                        });
                                  } else if (widget.useCase == 'send') {
                                  } else {
                                    postFriendRequestResult(
                                        success: (dynamic response) {
                                          print(response);
                                          print('친구 요청 수락 완료');
                                          setState(() {
                                            widget
                                                .stateFunction(widget.friendId);
                                            print(widget.friendId);
                                          });
                                        },
                                        fail: (error) {
                                          print('친구 요청 수락 오류 : $error');
                                          // Navigator.pushNamedAndRemoveUntil(
                                          //   context,
                                          //   '/error',
                                          //   arguments: {
                                          //     'errorText': error,
                                          //   },
                                          //   ModalRoute.withName('/home'),
                                          // );
                                        },
                                        body: {
                                          'accept': true,
                                          'receiverId': 1,
                                          'senderId': widget.friendId,
                                        });
                                  }
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      widget.useCase == 'search'
                                          ? Icons.send
                                          : widget.useCase == 'send'
                                              ? Icons.cut
                                              : Icons.handshake,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      widget.useCase == 'search'
                                          ? '친구 신청'
                                          : widget.useCase == 'send'
                                              ? '요청 취소'
                                              : '요청 수락',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 22,
              child: Container(
                width: 16,
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.5),
                      spreadRadius: 0.3,
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 7,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(
                        "lib/assets/images/animals/${widget.mainPetAssetName}.PNG"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Theme.of(context).secondaryHeaderColor,
                    width: 4,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.5),
                      spreadRadius: 0.5,
                      blurRadius: 6,
                    ),
                  ],
                ),
                // child: Image.asset(
                //   'lib/assets/images/samples/cat5.jpg',
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
