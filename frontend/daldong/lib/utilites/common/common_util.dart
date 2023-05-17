import 'package:daldong/services/friend_api.dart';
import 'package:flutter/material.dart';

void showConfirmationDialog(BuildContext context, void func, String title,
    String content, String yesText, String noText, String confirmCase,
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
              print('gd');
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: Text(
              noText,
              style: TextStyle(
                  fontSize: 14, color: Theme.of(context).primaryColor),
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
      print('하하');
      if (data != null) {
        if (confirmCase == 'deleteMyFriendApi') {
          deleteMyFriend(
            success: (dynamic response) {
              data['success'](data['friendId']);
            },
            fail: (error) {
              print('친구 삭제 오류 : $error');
            },
            friendId: data['friendId'],
          );
        }
      } else {}
    } else if (value == false) {
      // No 버튼을 눌렀을 때 수행할 작업
    }
  });
}
