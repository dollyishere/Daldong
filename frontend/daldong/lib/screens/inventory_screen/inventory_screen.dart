import 'package:daldong/screens/inventory_screen/inventory_pet_screen.dart';
import 'package:daldong/screens/inventory_screen/inventory_room_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:daldong/services/inventory_api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InventoryScreen extends StatefulWidget {
  final String mainPetAssetName;
  final String mainRoomAssetName;
  final void Function(String, String) changeMainAsset;
  final void Function(int) changeUserPoint;

  const InventoryScreen({
    required this.mainPetAssetName,
    required this.mainRoomAssetName,
    required this.changeMainAsset,
    required this.changeUserPoint,
    Key? key,
  }) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with SingleTickerProviderStateMixin {
  static const storage = FlutterSecureStorage();
  late TabController _tabController;
  bool isLoading = true;
  bool isPetView = true;

  int userPoint = 100;
  int mainPetId = 10;
  int mainRoomId = 1005;

  String mainPetAssetName = 'Sparrow';
  String mainRoomAssetName = 'Island_20';

  void changeMainItem(String itemCase, int assetId) {
    if (itemCase == 'pet') {
      setState(() {
        mainPetId = assetId;
      });
      widget.changeMainAsset('pet', petList[assetId - 1]['assetName']);
    } else {
      setState(() {
        mainRoomId = assetId;
      });
      widget.changeMainAsset('room', roomList[assetId - 1001]['assetName']);
    }
    setState(() {});
  }

  void buySelectItem(String itemCase, int assetId) async {
    if (itemCase == 'pet') {
      setState(() {
        petList[assetId - 1]['assetStatus'] = 2;
        print(assetId);
        print(petList[assetId - 1]['assetStatus']);
        userPoint = (userPoint - petList[assetId - 1]['assetPrice']).toInt();
      });
      widget.changeUserPoint(petList[assetId - 1]['assetPrice']);
    } else {
      setState(() {
        roomList[assetId - 1001]['assetStatus'] = 2;
        print(assetId);
        userPoint = (userPoint - roomList[assetId - 1001]['assetPrice']).toInt();
      });
      widget.changeUserPoint(roomList[assetId - 1001]['assetPrice']);
    }
    await storage.write(key: "userPoint", value: userPoint.toString());
    setState(() {});
  }

  List<dynamic> assetList = [];

  /// assetStatus 2: 구매, 1: 해금 o 구매 x, 0: 해금 x
  List<dynamic> petList = [];
  List<dynamic> roomList = [];

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // 선택된 탭이 변경되었을 때 실행될 코드 작성
      isPetView = !isPetView;
    }
  }

  void changeMainAsset(int assetId, String assetType) async {
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

  void changeAssetName(String changeName, int assetId) {
    setState(() {
      petList[assetId - 1]['assetCustomName'] = changeName;
    });
  }

  checkMainState() async {
    var myPoint = await storage.read(key: 'userPoint');
    var mainBackName = await storage.read(key: 'mainBackName');
    var mainPetName = await storage.read(key: 'mainPetName');
    setState(() {
      userPoint = int.parse(myPoint ?? '0');
      mainRoomAssetName = mainBackName ?? 'Island_13';
      mainPetAssetName = mainPetName ?? 'Sparrow';
    });
    await Future.delayed(const Duration(milliseconds: 10));
    assetList.forEach((asset) {
      if (asset['pet']) {
        petList.add(asset);
        if (asset['assetName'] == mainPetAssetName) {
          setState(() {
            mainPetId = asset['assetId'];
          });
        }
      } else {
        roomList.add(asset);
        if (asset['assetName'] == mainRoomAssetName) {
          setState(() {
            mainRoomId = asset['assetId'];
          });
        }
      }
    });
    print(roomList);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    setState(() {
      mainPetAssetName = widget.mainPetAssetName;
      mainRoomAssetName = widget.mainRoomAssetName;
    });
    getInvenStatus(
      success: (dynamic response) {
        assetList = response['data'];
        checkMainState();
      },
      fail: (error) {
        print('인벤토리 호출 오류 : $error');
      },
    );
    _tabController = TabController(vsync: this, length: 2);

    int selectedTabIndex = 0; // 기본값은 첫 번째 탭

    _tabController.addListener(() {
      final newIndex = _tabController.index;
      if (newIndex != selectedTabIndex) {
        setState(() {
          selectedTabIndex = newIndex;
          isPetView = !isPetView;
        });
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: isLoading
          ? Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            )
          : Scaffold(
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
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              body: Column(
                children: [
                  Stack(
                    children: [
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
                                    : 'lib/assets/images/rooms/${roomList[mainRoomId - 1001]['assetName']}.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 140,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: Container(
                                width: 76,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 10,
                                      width: 5,
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      '$userPoint PT',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                            unselectedLabelColor:
                                Theme.of(context).disabledColor,
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
                              changeAssetName: changeAssetName,
                              userPoint: userPoint,
                            ),
                            InventoryRoomScreen(
                              roomList: roomList,
                              mainRoomId: mainRoomId,
                              changeMainItem: changeMainItem,
                              buySelectItem: buySelectItem,
                              userPoint: userPoint,
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
