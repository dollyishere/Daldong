import 'package:daldong/services/friend_api.dart';
import 'package:daldong/widgets/friend_screen/other_user_block.dart';
import 'package:flutter/material.dart';

class FriendReceivedScreen extends StatefulWidget {
  const FriendReceivedScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendReceivedScreen> createState() => _FriendReceivedScreenState();
}

class _FriendReceivedScreenState extends State<FriendReceivedScreen> {
  List<dynamic> receivedUserList = [];
  bool isLoading = true;

  void changeUserState(int targetId) {
    receivedUserList.removeWhere((user) => user['friendId'] == targetId);
    print('이건 삭제된 데이터다');
    setState(() {});
    print(receivedUserList);
  }

  @override
  void initState() {
    // TODO: implement initState
    getReceivedList(
      success: (dynamic response) {
        setState(() {
          print(response['data']);
          receivedUserList = response['data'];
          print(receivedUserList);
          isLoading = false;
        });
      },
      fail: (error) {
        print('받은 요청 호출 오류 : $error');
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
          Text('현재 받은 요청 수: ${receivedUserList.length}'),
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
                child: receivedUserList.length == 0
                    ? Expanded(
                        child: Center(
                          child: Text(
                            '현재 받은 요청이 없습니다',
                          ),
                        ),
                      )
                    : ListView(
                        children: receivedUserList
                            .map(
                              (user) => OtherUserBlock(
                                friendId: user['friendId'],
                                friendNickname: user['friendNickname'],
                                friendUserLevel: user['friendUserLevel'],
                                mainPetAssetName: user['mainPetAssetName'],
                                useCase: 'received',
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
