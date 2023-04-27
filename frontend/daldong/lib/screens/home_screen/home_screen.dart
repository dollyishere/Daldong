import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:daldong/widgets/home_screen/info_block.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InfoBlock(
              petNumber: 5,
              nickName: 'jy',
              playerLevel: 10,
              playerExp: 1100,
              playerKcal: 2540,
            ),
          ],
        ),
      ),
    );
  }
}
