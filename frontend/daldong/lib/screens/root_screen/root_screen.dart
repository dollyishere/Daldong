import 'package:daldong/screens/exercise_screen/exercise_screen.dart';
import 'package:daldong/screens/exercise_detail_screen/exercise_detail_screen.dart';
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
  // 하단에 보여줄 이모티콘 및 이동할 스크린 이름 지정
  // colors의 경우 navbar package에서 직접 상속받는 듯 함(무슨 일이 벌어질 지 몰라서 건드리지는 않음!)
  List<NavbarItem> items = [
    NavbarItem(Icons.home, '홈', backgroundColor: colors[0]),
    NavbarItem(Icons.directions_run_rounded, '운동', backgroundColor: colors[1]),
    NavbarItem(Icons.people_alt_rounded, '친구', backgroundColor: colors[0]),
    NavbarItem(Icons.flag_circle_rounded, '미션', backgroundColor: colors[2]),
    NavbarItem(Icons.person_pin, '마이페이지', backgroundColor: colors[0]),
  ];

  // 네브바의 각 버튼을 누를 시, 이동할 스크린 지정
  final Map<int, Map<String, Widget>> _routes = {
    0: {
      '/': HomeScreen(),
    },
    1: {
      '/': ExerciseScreen(),
      // ExerciseDetailScreen.route: ExerciseDetailScreen(),
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

  // back button 누를 시(즉, 사용자가 종료하고 싶어하는 것 같을 때), 경고 메세지 출력
  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 600),
        margin: EdgeInsets.only(
            bottom: kBottomNavigationBarHeight, right: 2, left: 2),
        content: Text('두 번 연속으로 누를 시 앱이 종료됩니다.'),
      ),
    );
  }

  // 일정 시간 이후, snackbar 숨김
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
    final size = MediaQuery.of(context).size * 0.8;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
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
        // 에러가 발생했거나, 해당 주소가 없을 때, 에러 발생문 출력
        errorBuilder: (context) {
          return const Center(child: Text('에러가 발생했습니다.'));
        },
        // 데스크톱 모드인지 아닌지 검사한 후 만약 데스크탑 모드라면 변경
        isDesktop: size.width > 600 ? true : false,
        // 만약 routing이 stack에 남은 요소가 없는데, 사용자가 back button을 누를 시, 종료 메시지 출력
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
        // 네브바 형식 지정
        type: NavbarType.material3,
        // 현재 해당하는 페이지에 머무르고 있을 시, navbar 형식 지정
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
