import 'package:daldong/screens/inventory_screen/inventory_pet_screen.dart';
import 'package:daldong/screens/inventory_screen/inventory_room_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isPetView = true;
  int userPoing = 100;
  int mainPetId = 1;
  int mainRoomId = 1;
  String mainPetAssetName = 'Sparrow';
  String mainRoomAssetName = 'bg1';

  void changeMainItem(String itemCase, int assetId) {
    if (itemCase == 'pet') {
      setState(() {
        mainPetId = assetId;
      });
      setState(() {});
    } else {
      setState(() {
        mainRoomId = assetId;
      });
      setState(() {});
    }
  }

  void buySelectItem(String itemCase, int assetId) {
    if (itemCase == 'pet') {
      setState(() {
        petList[assetId - 1]['assetStatus'] = 2;
      });
      setState(() {});
    } else {
      setState(() {
        roomList[assetId - 1]['assetStatus'] = 2;
      });
      setState(() {});
    }
  }

  /// assetStatus 2: 구매, 1: 해금 o 구매 x, 0: 해금 x
  List<dynamic> petList = [
    {
      'assetId': 1,
      'assetType': 0, // 펫
      'assetName': 'Sparrow',
      'assetPrice': 0,
      'assetUnlockLevel': 1,
      'assetStatus': 2, // 구매
      'petName': "짹짹이가간다",
      'petExp': 100,
    },
    {
      'assetId': 2,
      'assetType': 0, // 펫
      'assetName': 'Dog',
      'assetPrice': 20,
      'assetUnlockLevel': 2,
      'assetStatus': 2,
      'petName': "강쥐",
      'petExp': 80,
    },
    {
      'assetId': 3,
      'assetType': 0, // 펫
      'assetName': 'Tortoise',
      'assetPrice': 130,
      'assetUnlockLevel': 3,
      'assetStatus': 2,
      'petName': "터툴유",
      'petExp': 70,
    },
    {
      'assetId': 4,
      'assetType': 0, // 펫
      'assetName': 'Frog',
      'assetPrice': 1462,
      'assetUnlockLevel': 10,
      'assetStatus': 2,
      'petName': "IamFro",
      'petExp': 20,
    },
    {
      'assetId': 5,
      'assetType': 0, // 펫
      'assetName': 'RedPanda',
      'assetPrice': 462,
      'assetUnlockLevel': 10,
      'assetStatus': 1,
      'petName': "귀요미",
      'petExp': 0,
    },
    {
      'assetId': 6,
      'assetType': 0, // 펫
      'assetName': 'SeaOtter',
      'assetPrice': 1462,
      'assetUnlockLevel': 10,
      'assetStatus': 0,
      'petName': "귀요미",
      'petExp': 0,
    },
    {
      'assetId': 7,
      'assetType': 0, // 펫
      'assetName': 'SnowWeasel',
      'assetPrice': 4680,
      'assetUnlockLevel': 10,
      'assetStatus': 0,
      'petName': "귀요미",
      'petExp': 0,
    },
  ];

  List<dynamic> roomList = [
    {
      'assetId': 1,
      'assetType': 1, // 룸
      'assetName': 'Island_1',
      'assetPrice': 100,
      'assetUnlockLevel': 1,
      'assetStatus': 2,
      'petName': "bg1",
      'petExp': 0,
    },
    {
      'assetId': 2,
      'assetType': 1, // 룸
      'assetName': 'Island_2',
      'assetPrice': 100,
      'assetUnlockLevel': 5,
      'assetStatus': 0,
      'petName': "bg2",
      'petExp': 0,
    },
  ];

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // 선택된 탭이 변경되었을 때 실행될 코드 작성
      isPetView = !isPetView;
    }
  }

  void changeAssetName(int assetId, String assetType) {
    if (assetType == 'pet') {
      setState(() {
        mainPetAssetName = petList[assetId]['assetName'];
      });
    } else {
      setState(() {
        mainRoomAssetName = roomList[assetId]['assetName'];
      });
    }
  }

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);

    int selectedTabIndex = 0; // 기본값은 첫 번째 탭

    _tabController.addListener(() {
      final newIndex = _tabController.index;
      if (newIndex != selectedTabIndex) {
        setState(() {
          selectedTabIndex = newIndex;
          isPetView = !isPetView;
          print(isPetView);
        });
      }
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '인벤토리',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          elevation: 0,
          // backgroundColor: Color(0xFFFF3F3F),
          backgroundColor: Theme.of(context).primaryColorDark,
          foregroundColor: Colors.white,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          backgroundColor: Theme.of(context).primaryColor,
          tooltip: '인벤토리를 나갈 수 있습니다.',
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.highlight_remove_outlined,
                size: 42,
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          children: [
            Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(
                  //     10.0,
                  //   ),
                  //   child: Text(
                  //     '미리보기',
                  //     style: TextStyle(
                  //       color: Theme.of(context)
                  //           .secondaryHeaderColor
                  //           .withOpacity(0.75),
                  //       fontSize: 14,
                  //       fontWeight: FontWeight.w700,
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Center(
                    /// 임시
                    child: Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          fit: BoxFit.fitHeight,
                          image: AssetImage(
                            /// 나중에 3D Asset으로 바꾸기
                            isPetView
                                ? 'lib/assets/images/animals/${petList[mainPetId - 1]['assetName']}.png'
                                : 'lib/assets/images/rooms/${roomList[mainRoomId - 1]['assetName']}.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 1,
                    backgroundColor: Colors.white,
                    bottom: TabBar(
                      controller: _tabController,
                      labelColor: Theme.of(context).primaryColorDark,
                      unselectedLabelColor: Theme.of(context).disabledColor,
                      indicatorColor: Theme.of(context).primaryColorDark,
                      indicatorWeight: 3,
                      tabs: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          child: const Text(
                            "동물",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          child: const Text(
                            "배경",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      InventoryPetScreen(
                        petList: petList,
                        mainPetId: mainPetId,
                        changeMainItem: changeMainItem,
                        buySelectItem: buySelectItem,
                      ),
                      InventoryRoomScreen(
                        roomList: roomList,
                        mainRoomId: mainRoomId,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
