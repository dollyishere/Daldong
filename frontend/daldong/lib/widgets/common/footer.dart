import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Footer extends StatefulWidget {
  Footer({Key? key}) : super(key: key);

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColorDark,
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, // 패딩 제거
              ),
              onPressed: () {
                if (ModalRoute.of(context)?.settings.name != '/home') {
                  Navigator.pushNamed(context, '/home');
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Container(
                  //   width: 60,
                  //   height: 40,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(
                  //       Radius.circular(20),
                  //     ),
                  //     color: Theme.of(context).primaryColorLight,
                  //   ),
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home,
                        color: ModalRoute.of(context)?.settings.name != '/home'
                            ? Colors.white
                            : Theme.of(context).secondaryHeaderColor,
                        size: 24,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '홈',
                        style: TextStyle(
                          color:
                              ModalRoute.of(context)?.settings.name != '/home'
                                  ? Colors.white
                                  : Theme.of(context).secondaryHeaderColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          TextButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/exercise') {
                Navigator.pushNamed(context, '/exercise');
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.directions_run_rounded,
                  color: (ModalRoute.of(context)?.settings.name == '/exercise_detail' || ModalRoute.of(context)?.settings.name == '/exercise')
                      ? Theme.of(context).secondaryHeaderColor
                      : Colors.white,
                  size: 24,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '운동',
                  style: TextStyle(
                    color: (ModalRoute.of(context)?.settings.name == '/exercise_detail' || ModalRoute.of(context)?.settings.name == '/exercise')
                        ? Theme.of(context).secondaryHeaderColor
                        : Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/friend') {
                Navigator.pushNamed(context, '/friend');
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_alt_rounded,
                  color: ModalRoute.of(context)?.settings.name != '/friend'
                      ? Colors.white
                      : Theme.of(context).secondaryHeaderColor,
                  size: 24,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '친구',
                  style: TextStyle(
                    color: ModalRoute.of(context)?.settings.name != '/friend'
                        ? Colors.white
                        : Theme.of(context).secondaryHeaderColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/mission') {
                Navigator.pushNamed(context, '/mission');
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.flag_circle_rounded,
                  color: ModalRoute.of(context)?.settings.name != '/mission'
                      ? Colors.white
                      : Theme.of(context).secondaryHeaderColor,
                  size: 24,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '미션',
                  style: TextStyle(
                    color: ModalRoute.of(context)?.settings.name != '/mission'
                        ? Colors.white
                        : Theme.of(context).secondaryHeaderColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              if (ModalRoute.of(context)?.settings.name != '/profile') {
                Navigator.pushNamed(context, '/profile');
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_pin,
                  color: ModalRoute.of(context)?.settings.name != '/profile'
                      ? Colors.white
                      : Theme.of(context).secondaryHeaderColor,
                  size: 24,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '마이페이지',
                  style: TextStyle(
                    color: ModalRoute.of(context)?.settings.name != '/profile'
                        ? Colors.white
                        : Theme.of(context).secondaryHeaderColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
