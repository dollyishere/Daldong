import 'package:daldong/services/friend_api.dart';
import 'package:daldong/widgets/friend_screen/other_user_block.dart';
import 'package:flutter/material.dart';

class FriendSendScreen extends StatefulWidget {
  const FriendSendScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendSendScreen> createState() => _FriendSendScreenState();
}

class _FriendSendScreenState extends State<FriendSendScreen> {
  List<dynamic> sendUserList = [];
  bool isLoading = true;

  void changeUserState(int targetId) {
    sendUserList.removeWhere((user) => user['friendId'] == targetId);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getSendList(
      success: (dynamic response) {
        setState(() {
          print(response['data']);
          sendUserList = response['data'];
          print(sendUserList);
          isLoading = false;
        });
      },
      fail: (error) {
        print('보낸 요청 목록 호출 오류 : $error');
        // Navigator.pushNamedAndRemoveUntil(
        //   context,
        //   '/error',
        //   arguments: {
        //     'errorText': error,
        //   },
        //   ModalRoute.withName('/home'),
        // );
      },
      userId: 1,
    );
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
          Text('현재 요청한 유저 수: ${sendUserList.length}'),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: RawScrollbar(
              thumbVisibility: true,
              radius: const Radius.circular(10),
              thumbColor: Theme.of(context).primaryColorDark.withOpacity(0.5),
              thickness: 5,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: sendUserList.length == 0
                    ? Expanded(
                        child: Center(
                          child: Text(
                            '현재 보낸 요청이 없습니다',
                          ),
                        ),
                      )
                    : ListView(
                        children: sendUserList
                            .map(
                              (user) => OtherUserBlock(
                                friendId: user['friendId'],
                                friendNickname: user['friendNickname'],
                                friendUserLevel: user['friendUserLevel'],
                                mainPetAssetName: user['mainPetAssetName'],
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
