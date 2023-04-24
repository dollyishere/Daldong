import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:daldong/screens/home_screen/home_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  List<NavbarItem> items = [
    NavbarItem(Icons.home, '홈', backgroundColor: colors[0]),
    NavbarItem(Icons.directions_run_rounded, '운동', backgroundColor: colors[1]),
    NavbarItem(Icons.people_alt_rounded, '친구', backgroundColor: colors[0]),
    NavbarItem(Icons.flag_circle_rounded, '미션', backgroundColor: colors[2]),
    NavbarItem(Icons.person_pin, '마이페이지', backgroundColor: colors[0]),
  ];

  final Map<int, Map<String, Widget>> _routes = {
    0: {
      '/': HomeScreen(),
    },
    1: {
      '/': HomeScreen(),
    },
    2: {
      '/': HomeScreen(),
    },
    3: {
      '/': HomeScreen(),
    },
    4: {
      '/': HomeScreen(),
    },
  };

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 600),
        margin: EdgeInsets.only(
            bottom: kBottomNavigationBarHeight, right: 2, left: 2),
        content: Text('Tap back button again to exit'),
      ),
    );
  }

  void hideSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  DateTime oldTime = DateTime.now();
  DateTime newTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    // simulateTabChange();
    // colors, NavbarNotifier의 경우, package에서 직접 상속받는 듯 함
    NavbarNotifier.addIndexChangeListener((x) {
      print('NavbarNotifier.indexChangeListener: $x');
    });
  }

  @override
  void dispose() {
    NavbarNotifier.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          child: Icon(NavbarNotifier.isNavbarHidden
              ? Icons.toggle_off
              : Icons.toggle_on),
          onPressed: () {
            // Programmatically toggle the Navbar visibility
            if (NavbarNotifier.isNavbarHidden) {
              NavbarNotifier.hideBottomNavBar = false;
            } else {
              NavbarNotifier.hideBottomNavBar = true;
            }
            setState(() {});
          },
        ),
      ),
      body: NavbarRouter(
        errorBuilder: (context) {
          return const Center(child: Text('Error 404'));
        },
        isDesktop: size.width > 600 ? true : false,
        onBackButtonPressed: (isExitingApp) {
          if (isExitingApp) {
            newTime = DateTime.now();
            int difference = newTime.difference(oldTime).inMilliseconds;
            oldTime = newTime;
            if (difference < 1000) {
              hideSnackBar();
              return isExitingApp;
            } else {
              showSnackBar();
              return false;
            }
          } else {
            return isExitingApp;
          }
        },
        initialIndex: 0,
        // footer 형식 지정
        type: NavbarType.material3,
        destinationAnimationCurve: Curves.fastOutSlowIn,
        destinationAnimationDuration: 600,
        decoration: M3NavbarDecoration(
            labelTextStyle: TextStyle(
                color: Theme.of(context).primaryColorLight, fontSize: 12),
            elevation: 3.0,
            backgroundColor: Theme.of(context).primaryColorDark,
            indicatorShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            indicatorColor: Theme.of(context).primaryColorLight,
            // iconTheme: const IconThemeData(color: Colors.indigo),
            /// labelTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow),
        onChanged: (x) {},
        backButtonBehavior: BackButtonBehavior.rememberHistory,
        destinations: [
          for (int i = 0; i < items.length; i++)
            DestinationRouter(
              navbarItem: items[i],
              destinations: [
                for (int j = 0; j < _routes[i]!.keys.length; j++)
                  Destination(
                    route: _routes[i]!.keys.elementAt(j),
                    widget: _routes[i]!.values.elementAt(j),
                  ),
              ],
              initialRoute: _routes[i]!.keys.first,
            ),
        ],
      ),
    );
  }
}

Future<void> navigate(BuildContext context, String route,
        {bool isDialog = false,
        bool isRootNavigator = true,
        Map<String, dynamic>? arguments}) =>
    Navigator.of(context, rootNavigator: isRootNavigator)
        .pushNamed(route, arguments: arguments);
