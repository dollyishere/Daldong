import 'dart:math';
import 'package:daldong/widgets/common/footer.dart';
import 'package:daldong/widgets/friend_screen/friend_block.dart';
import 'package:daldong/widgets/friend_screen/my_progress_bar.dart';
import 'package:daldong/utilites/friend_screen/friend_utilite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendScreen extends StatefulWidget {
  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  void showConfirmationDialog(BuildContext context, Function func, String title,
      String content, String yesText, String noText,
      {dynamic data}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text(
                yesText,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                // Yes 버튼을 눌렀을 때 수행할 작업
                Navigator.of(context).pop(true);
              },
            ),
            TextButton(
              child: Text(
                noText,
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                // No 버튼을 눌렀을 때 수행할 작업
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        if (data != null) {
          func(data);
        } else {
          // Navigator.pushNamed(context, routeName);
        }
      } else if (value == false) {
        // No 버튼을 눌렀을 때 수행할 작업
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> friendList = [
      {
        "friendId": 1,
        "friendNickname": '팩ㄺ팍페규ㅖ',
        "friendUserLevel": 12,
        "mainPetAssetName": 'Dog',
        "isSting": 0,
      },
      {
        "friendId": 1,
        "friendNickname": 'YouKno',
        "friendUserLevel": 12,
        "mainPetAssetName": 'Frog',
        "isSting": 0,
      },
      {
        "friendId": 1,
        "friendNickname": '핡핡핡핵핽핽',
        "friendUserLevel": 12,
        "mainPetAssetName": 'Snow_Weasel',
        "isSting": 0,
      },
      {
        "friendId": 1,
        "friendNickname": 'Naver',
        "friendUserLevel": 12,
        "mainPetAssetName": 'Crocodile',
        "isSting": 1,
      },
      {
        "friendId": 1,
        "friendNickname": '판다조하조하',
        "friendUserLevel": 12,
        "mainPetAssetName": 'Red_Panda',
        "isSting": 0,
      },
      {
        "friendId": 1,
        "friendNickname": '짹쨰그거ㅏㅣ',
        "friendUserLevel": 12,
        "mainPetAssetName": 'Bat',
        "isSting": 0,
      },
    ];
    print(friendList.length);
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Footer(),
      body: Padding(
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
                      showDetailCalender(1, 'gg', 'gg', false, context);
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: RawScrollbar(
                  thumbVisibility: true,
                  radius: const Radius.circular(10),
                  thumbColor:
                      Theme.of(context).primaryColorDark.withOpacity(0.5),
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
                              friendNickname: friend["friendNickname"],
                              friendUserLevel: friend["friendUserLevel"],
                              mainPetAssetName: friend["mainPetAssetName"],
                              isSting: friend["isSting"],
                              showConfirmationDialog: showConfirmationDialog,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
