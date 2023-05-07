import 'package:flutter/material.dart';

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
                  fontSize: 14, color: Theme.of(context).primaryColor),
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
      if (data != null) {
        func(data);
      } else {
        //
      }
    } else if (value == false) {
      // No 버튼을 눌렀을 때 수행할 작업
    }
  });
}