import 'package:daldong/widgets/inventory_screen/room_block.dart';
import 'package:flutter/material.dart';

class InventoryRoomScreen extends StatefulWidget {
  final List<dynamic> roomList;
  final int mainRoomId;
  final int userPoint;
  final void Function(String, int) changeMainItem;
  final void Function(String, int) buySelectItem;

  const InventoryRoomScreen({
    required this.roomList,
    required this.mainRoomId,
    required this.userPoint,
    required this.changeMainItem,
    required this.buySelectItem,
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
                      child: SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            children: [
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 8.0,
                                runSpacing: 0.0,
                                children: List.generate(
                                  20,
                                  (index) => RoomBlock(
                                    roomInfo: widget.roomList[index],
                                    mainRoomId: widget.mainRoomId,
                                    changeMainItem: widget.changeMainItem,
                                    buySelectItem: widget.buySelectItem,
                                    userPoint: widget.userPoint,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 70,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
