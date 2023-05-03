import 'package:daldong/widgets/friend_screen/other_user_block.dart';
import 'package:flutter/material.dart';

// 일정 상세보기 (수정, 삭제 기능 추가하기)
void showDetailCalender(
    int id, String title, String memo, bool auto, BuildContext context) {
  FocusNode unUsedFocusNode = FocusNode();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Theme.of(context).primaryColorLight,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: DefaultTabController(
                    length: 3,
                    child: Scaffold(
                      appBar: AppBar(
                        elevation: 0,
                        toolbarOpacity: 0,
                        foregroundColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        toolbarHeight: 1,
                        backgroundColor: Theme.of(context).primaryColorLight,
                        bottom: TabBar(
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
                                "유저 검색",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              child: const Text(
                                "받은 요청",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              child: const Text(
                                "보낸 요청",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                        onTapOutside: (PointerDownEvent event) {
                                          FocusScope.of(context)
                                              .requestFocus(unUsedFocusNode);
                                        },
                                        maxLength: 7,
                                        scrollPadding: EdgeInsets.zero,
                                        cursorColor:
                                            Theme.of(context).primaryColorDark,
                                        style: TextStyle(fontSize: 12),
                                        decoration: InputDecoration(
                                          counterText: '',
                                          filled: true,
                                          fillColor: Colors.white,
                                          isDense: true,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.white,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 6,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      splashColor: Colors.transparent,
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 40,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Theme.of(context).shadowColor,
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
                                Expanded(
                                  child: RawScrollbar(
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
                                          OtherUserBlock(
                                              friendId: 1,
                                              friendNickname: 'jy',
                                              friendUserLevel: 112,
                                              mainPetAssetName: 'Sparrow',
                                              isSting: 0),
                                          OtherUserBlock(
                                              friendId: 1,
                                              friendNickname: 'jy',
                                              friendUserLevel: 112,
                                              mainPetAssetName: 'Sparrow',
                                              isSting: 0),
                                          OtherUserBlock(
                                              friendId: 1,
                                              friendNickname: 'jy',
                                              friendUserLevel: 112,
                                              mainPetAssetName: 'Sparrow',
                                              isSting: 0),
                                          OtherUserBlock(
                                              friendId: 1,
                                              friendNickname: 'jy',
                                              friendUserLevel: 112,
                                              mainPetAssetName: 'Sparrow',
                                              isSting: 0),
                                          OtherUserBlock(
                                              friendId: 1,
                                              friendNickname: 'jy',
                                              friendUserLevel: 112,
                                              mainPetAssetName: 'Sparrow',
                                              isSting: 0),
                                          OtherUserBlock(
                                              friendId: 1,
                                              friendNickname: 'jy',
                                              friendUserLevel: 112,
                                              mainPetAssetName: 'Sparrow',
                                              isSting: 0),
                                          OtherUserBlock(
                                              friendId: 1,
                                              friendNickname: 'jy',
                                              friendUserLevel: 112,
                                              mainPetAssetName: 'Sparrow',
                                              isSting: 0),
                                          OtherUserBlock(
                                              friendId: 1,
                                              friendNickname: 'jy',
                                              friendUserLevel: 112,
                                              mainPetAssetName: 'Sparrow',
                                              isSting: 0),
                                          OtherUserBlock(
                                              friendId: 1,
                                              friendNickname: 'jy',
                                              friendUserLevel: 112,
                                              mainPetAssetName: 'Sparrow',
                                              isSting: 0),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => {
                  Navigator.pop(context),
                },
                splashColor: Colors.transparent,
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(context).primaryColorDark,
                  child: Icon(
                    Icons.highlight_remove_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
