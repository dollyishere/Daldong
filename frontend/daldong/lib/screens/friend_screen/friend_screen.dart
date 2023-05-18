import 'dart:math';
import 'package:daldong/services/friend_api.dart';
import 'package:daldong/widgets/common/footer.dart';
import 'package:daldong/widgets/friend_screen/friend_block.dart';
import 'package:daldong/widgets/friend_screen/my_progress_bar.dart';
import 'package:daldong/utilites/friend_screen/friend_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendScreen extends StatefulWidget {
  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  bool isLoading = true;
  List<dynamic> friendList = [
    {
      'friendId': 1,
      'friendNickname': 'user1',
      'friendUserLevel': 21,
      'mainPetAssetName': 'Pigeon',
      'sting': false
    }
  ];

  void changeUserState(dynamic targetId) {
    friendList.removeWhere((user) => user['friendId'] == targetId);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getMyFriendList(
      success: (dynamic response) {
        setState(() {
          friendList = response['data'];
          print(friendList);
          isLoading = false;
        });
      },
      fail: (error) {
        print('친구 목록 호출 오류 : $error');
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   '/error',
        //   arguments: {
        //     'errorText': error,
        //   },
        //   ModalRoute.withName('/home'),
        // );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Footer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      '친구',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  MyProgressBar(progressNum: friendList.length),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "현재 친구 수: ${friendList.length}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDetailModalFriend(context, changeUserState);
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Icon(
                            Icons.add_circle,
                            size: 24,
                            color: Theme.of(context).primaryColorDark,
                          ),
                        )
                      ],
                    ),
                  ),
                  friendList.length > 0
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: RawScrollbar(
                              thumbVisibility: true,
                              radius: const Radius.circular(10),
                              thumbColor: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.5),
                              thickness: 5,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: ListView(
                                  children: friendList
                                      .map(
                                        (friend) => FriendBlock(
                                          friendId: friend["friendId"],
                                          friendNickname:
                                              friend["friendNickname"],
                                          friendUserLevel:
                                              friend["friendUserLevel"],
                                          mainPetAssetName:
                                              friend["mainPetAssetName"],
                                          mainBackAssetName:
                                              friend["mainBackAssetName"],
                                          isSting: friend["sting"],
                                          stateFunction: changeUserState,
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        )
                      : Expanded(
                          child: Center(
                            child: Text('현재 친구가 없습니다.'),
                          ),
                        )
                ],
              ),
            ),
    ));
  }
}
