import 'package:daldong/services/friend_api.dart';
import 'package:daldong/widgets/friend_screen/other_user_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FriendSearchScreen extends StatefulWidget {
  final FocusNode unUsedFocusNode;
  final void Function(dynamic) changeUserState;

  const FriendSearchScreen({
    Key? key,
    required this.unUsedFocusNode,
    required this.changeUserState,
  }) : super(key: key);

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  static const storage = FlutterSecureStorage();
  String uid = '0';

  bool isLoading = false;
  bool isSearched = false;
  bool isRecommend = false;
  bool hasRecommendedFriend = false;
  bool noUser = false;
  late TextEditingController inputController;
  String searchInput = '';
  List<dynamic> searchUserList = [];
  Map<String, dynamic> searchUser = {};
  Map<String, dynamic> recommendedUser = {};

  void changeUserState(int targetId) {
    if (searchUser['isFriend'] == 0) {
      setState(() {
        searchUser['isFriend'] == 1;
      });
    } else if (searchUser['isFriend'] == 2) {
      setState(() {
        searchUser['isFriend'] == 3;
      });
    } else if (searchUser['isFriend'] == 3) {
      widget.changeUserState(searchUser['userId']);
      setState(() {
        searchUser['isFriend'] == 0;
      });
    }
  }

  void getUid() async {
    String? userId = await storage.read(key: "uid");

    print('유저 아이디: $userId');
    setState(() {
      uid = userId ?? 'user1';
    });
    await Future.delayed(const Duration(milliseconds: 10));
    getRecommendFriend(
      success: (dynamic response) {
        recommendedUser = response;
        print(response);
        setState(() {
          hasRecommendedFriend = true;
        });
      },
      fail: (error) {
        print('추천 친구 받아오기 에러: $error');
      },
      uid: uid,
    );
    setState(() {
      isRecommend = true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUid();
    });

    inputController = TextEditingController(text: searchInput);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Theme.of(context).primaryColorLight,
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.search_rounded,
                color: Theme.of(context).primaryColorDark,
                size: 24,
              ),
              Container(
                width: 160,
                child: TextField(
                  controller: inputController,
                  onTapOutside: (PointerDownEvent event) {
                    FocusScope.of(context).requestFocus(widget.unUsedFocusNode);
                  },
                  onChanged: (text) {
                    setState(
                      () {
                        searchInput = text.trim();
                      },
                    );
                  },
                  maxLength: 6,
                  scrollPadding: EdgeInsets.zero,
                  cursorColor: Theme.of(context).primaryColorDark,
                  style: TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    counterText: '',
                    filled: true,
                    fillColor: Colors.white,
                    isDense: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColorDark,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColorLight,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  setState(() {
                    getSearchFriendList(
                      success: (dynamic response) {
                        setState(() {
                          searchUser = response['data'];
                          print('유저 데이터');
                          print(searchUser);
                          setState(() {
                            noUser = false;
                            isSearched = true;
                          });
                        });
                      },
                      fail: (error) {
                        print('친구 검색 결과 호출 오류 : $error');
                        setState(() {
                          noUser = true;
                        });
                        // Navigator.pushNamedAndRemoveUntil(
                        //   context,
                        //   '/error',
                        //   arguments: {
                        //     'errorText': error,
                        //   },
                        //   ModalRoute.withName('/home'),
                        // );
                      },
                      friendNickname: searchInput,
                    );
                    searchInput = '';
                    inputController = TextEditingController(text: searchInput);
                  });
                  setState(() {
                    isLoading = false;
                  });
                },
                splashColor: Colors.transparent,
                child: Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 24,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColorDark,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                      )
                    ],
                  ),
                  child: Text(
                    "검색",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          isLoading
              ? Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : Expanded(
                  child: !isSearched
                      ? Center(
                          child: Text(
                            '현재 검색된 유저가 없습니다',
                          ),
                        )
                      : noUser
                          ? Center(
                              child: Text('해당하는 유저가 없습니다.'),
                            )
                          : Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: OtherUserBlock(
                                friendId: searchUser['userId'],
                                friendNickname: searchUser['nickname'],
                                friendUserLevel: searchUser['userLevel'],
                                mainPetAssetName: searchUser['mainPetName'],
                                mainBackAssetName:
                                    searchUser['mainBackAssetName'],
                                useCase: 'search',
                                stateFunction: changeUserState,
                                isFriend: searchUser['isFriend'],
                              ),
                            ),
                ),
          Container(
            height: 180,
            width: double.infinity,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                    ),
                    Text(
                      '추천 유저',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isRecommend = false;
                          });
                          getRecommendFriend(
                            success: (dynamic response) {
                              recommendedUser = response;
                              print(response);
                              setState(() {
                                hasRecommendedFriend = true;
                              });
                            },
                            fail: (error) {
                              print('추천 친구 받아오기 에러: $error');
                            },
                            uid: uid,
                          );
                          setState(() {
                            isRecommend = true;
                          });
                        },
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColorDark,
                          radius: 12,
                          child: Icon(
                            Icons.restart_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: isRecommend
                      ? hasRecommendedFriend
                          ? OtherUserBlock(
                              friendId: recommendedUser['friendId'],
                              friendNickname: recommendedUser['friendNickname'],
                              friendUserLevel:
                                  recommendedUser['friendUserLevel'],
                              mainPetAssetName:
                                  recommendedUser['mainPetAssetName'],
                              mainBackAssetName:
                                  recommendedUser['mainBackAssetName'] ??
                                      'Island_20',
                              useCase: 'search',
                              stateFunction: changeUserState,
                              isFriend: 0,
                            )
                          : Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text(
                                  '추천된 유저가 없습니다',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                      : Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
