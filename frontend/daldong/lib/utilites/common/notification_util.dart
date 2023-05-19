import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationUtil {
  static Future<void> setupInteractedMessage(BuildContext context) async {
    // Get any messages which caused the application to open from a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(context, initialMessage);
    }

    // Also handle any interaction when the app is in the background via a Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(context, message);
    });

    FirebaseMessaging.onMessage.listen((message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print("eeee");
        _showNotificationDialog(context, message);
      }
    });
  }

  static void _handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'sting') {
      print("ZZZ");
      // Navigator.pushNamedAndRemoveUntil(context, '/exercise', (route) => false);
      // Navigator.pushNamedAndRemoveUntil(context, '/friend', (route) => false);
    } else if (message.data['type'] == 'exercise') {
      Navigator.pushNamedAndRemoveUntil(context, '/exercise', (route) => false);
    } else if (message.data['type'] == 'test') {
      print("wa!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
  }

  static void _showNotificationDialog(
      BuildContext context, RemoteMessage message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            message.notification!.title!,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),
          ),
          content: Text(message.notification!.body!),
          actions: <Widget>[
            ElevatedButton(
              child: Text('닫기'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
