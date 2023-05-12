import 'package:daldong/widgets/inventory_screen/room_block.dart';
import 'package:flutter/material.dart';

class InventoryRoomScreen extends StatefulWidget {
  final List<dynamic> roomList;
  final int mainRoomId;

  const InventoryRoomScreen({
    required this.roomList,
    required this.mainRoomId,
    Key? key,
  }) : super(key: key);

  @override
  State<InventoryRoomScreen> createState() => _InventoryRoomScreenState();
}

class _InventoryRoomScreenState extends State<InventoryRoomScreen> {
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
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
        color: Colors.white,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          widget.roomList.length == 0
              ? Expanded(
                  child: Center(
                    child: Text(
                      '현재 보유 중인 룸이 없습니다',
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
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              RoomBlock(
                                roomInfo: widget.roomList[0],
                                mainRoomId: widget.mainRoomId,
                              ),
                              RoomBlock(
                                roomInfo: widget.roomList[1],
                                mainRoomId: widget.mainRoomId,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
