import 'package:daldong/services/friend_api.dart';
import 'package:daldong/utilites/common/common_utilite.dart';
import 'package:flutter/material.dart';

class FriendBlock extends StatefulWidget {
  final int friendId;
  final String friendNickname;
  final int friendUserLevel;
  final String mainPetAssetName;
  final bool isSting;
  final void Function(dynamic) stateFunction;

  const FriendBlock({
    Key? key,
    required this.friendId,
    required this.friendNickname,
    required this.friendUserLevel,
    required this.mainPetAssetName,
    required this.isSting,
    required this.stateFunction,
  }) : super(key: key);

  @override
  State<FriendBlock> createState() => _FriendBlockState();
}

class _FriendBlockState extends State<FriendBlock> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 4,
      ),
      child: Container(
        width: 350,
        height: 118,
        child: Stack(
          children: [
            Positioned(
              left: 30,
              top: 22,
              child: Container(
                width: 314,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      spreadRadius: 0.5,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(44, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: double.infinity,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      InkWell(
                        onTap: () {},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: 77,
                          height: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_box,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                '상세정보',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 52,
                        width: 2,
                        color: widget.isSting
                            ? Colors.transparent
                            : Theme.of(context).primaryColorDark,
                      ),
                      InkWell(
                        onTap: () {
                          print('하하');
                        },
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Container(
                          width: 77,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: widget.isSting
                                ? Theme.of(context).shadowColor
                                : Colors.transparent,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.push_pin,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                '찌르기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Stack(
                          children: [
                            Container(
                              width: 20,
                              height: double.infinity,
                              color: Theme.of(context).disabledColor,
                            ),
                            Container(
                              height: double.infinity,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Theme.of(context).disabledColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: InkWell(
                                onTap: () {
                                  showConfirmationDialog(
                                    context,
                                    print('api 실행'),
                                    '이별하기',
                                    '정말 이별하시겠습니까?',
                                    '예',
                                    '아니오',
                                      'deleteMyFriendApi',
                                    data: {
                                      'userId': 1,
                                      "friendId": widget.friendId,
                                      'success': widget.stateFunction,
                                      'fail': (error) {
                                        print('친구 삭제 오류: $error');
                                      },
                                    }
                                  );
                                },
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.waving_hand,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      '이별하기',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
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
                ),
              ),
            ),
            Positioned(
              left: 40,
              child: Container(
                width: 30,
                height: 80,
                decoration: BoxDecoration(
                  color: Theme.of(context).disabledColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.5),
                      spreadRadius: 0.3,
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 6,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF4F5E5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 0.3,
                      blurRadius: 6,
                    ),
                  ],
                ),
                width: 110,
                height: 110,
              ),
            ),
            Positioned(
              top: 21,
              left: 15,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(
                        "lib/assets/images/animals/${widget.mainPetAssetName}.PNG"),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).secondaryHeaderColor,
                    width: 10,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.5),
                      spreadRadius: 0.3,
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 64,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 1,
                            vertical: 2,
                          ),
                          child: Text(
                            widget.friendNickname,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
