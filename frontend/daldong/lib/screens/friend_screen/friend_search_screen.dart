import 'package:daldong/services/friend_api.dart';
import 'package:daldong/widgets/friend_screen/other_user_block.dart';
import 'package:flutter/material.dart';

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
  bool isLoading = false;
  bool isSearched = false;
  bool noUser = false;
  late TextEditingController inputController;
  String searchInput = '';
  List<dynamic> searchUserList = [];
  Map<String, dynamic> searchUser = {};

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

  @override
  void initState() {
    // TODO: implement initState
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
                      : RawScrollbar(
                          thumbVisibility: true,
                          radius: const Radius.circular(10),
                          thumbColor: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.5),
                          thickness: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            child: ListView(
                              children: [
                                noUser
                                    ? Center(
                                        child: Text('해당하는 유저가 없습니다.'),
                                      )
                                    : OtherUserBlock(
                                        friendId: searchUser['userId'],
                                        friendNickname: searchUser['nickname'],
                                        friendUserLevel:
                                            searchUser['userLevel'],
                                        mainPetAssetName:
                                            searchUser['mainPetName'],
                                        useCase: 'search',
                                        stateFunction: changeUserState,
                                        isFriend: searchUser['isFriend'],
                                      ),
                              ],
                            ),
                          ),
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
