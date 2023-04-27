import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:daldong/widgets/home_screen/info_block.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<NavbarItem> items = [
      NavbarItem(Icons.home, 'Home', backgroundColor: colors[0]),
      NavbarItem(Icons.shopping_bag, 'Products', backgroundColor: colors[1]),
      NavbarItem(Icons.person, 'Me', backgroundColor: colors[2]),
    ];

    final Map<int, Map<String, Widget>> routes = {
      0: {
        '/': HomeScreen(),
      },
    };

    return const Scaffold(
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
