import 'package:daldong/widgets/friend_screen/other_user_block.dart';
import 'package:flutter/material.dart';

class FriendSearchScreen extends StatefulWidget {
  final FocusNode unUsedFocusNode;

  const FriendSearchScreen({
    Key? key,
    required this.unUsedFocusNode,
  }) : super(key: key);

  @override
  State<FriendSearchScreen> createState() => _FriendSearchScreenState();
}

class _FriendSearchScreenState extends State<FriendSearchScreen> {
  bool isLoading = false;
  late TextEditingController inputController;
  String searchInput = '';
  List<dynamic> searchUserList = [];

  void changeUserState(int targetId) {
    searchUserList.removeWhere((user) => user['friendId'] == targetId);
    setState(() {});
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
                        searchInput = text;
                      },
                    );
                  },
                  maxLength: 7,
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
                    searchInput = '';
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
              : searchUserList.length == 0
                  ? Expanded(
                      child: Center(
                        child: Text(
                          '현재 검색된 유저가 없습니다',
                        ),
                      ),
                    )
                  : Expanded(
                      child: RawScrollbar(
                        thumbVisibility: true,
                        radius: const Radius.circular(10),
                        thumbColor:
                            Theme.of(context).primaryColorDark.withOpacity(0.5),
                        thickness: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                          ),
                          child: ListView(
                            children: searchUserList.length == 0
                                ? [
                                    Center(
                                      child: Text('검색한 유저가 없습니다.'),
                                    )
                                  ]
                                : searchUserList
                                    .map(
                                      (user) => OtherUserBlock(
                                        friendId: user['friendId'],
                                        friendNickname: user['friendNickname'],
                                        friendUserLevel:
                                            user['friendUserLevel'],
                                        mainPetAssetName:
                                            user['mainPetAssetName'],
                                        useCase: 'send',
                                        stateFunction: changeUserState,
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}
