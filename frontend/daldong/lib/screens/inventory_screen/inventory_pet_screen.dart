import 'package:daldong/widgets/inventory_screen/pet_block.dart';
import 'package:flutter/material.dart';

class InventoryPetScreen extends StatefulWidget {
  final List<dynamic> petList;
  final int mainPetId;
  final void Function(String, int) changeMainItem;
  final void Function(String, int) buySelectItem;

  const InventoryPetScreen({
    required this.petList,
    required this.mainPetId,
    required this.changeMainItem,
    required this.buySelectItem,
    Key? key,
  }) : super(key: key);

  @override
  State<InventoryPetScreen> createState() => _InventoryPetScreenState();
}

class _InventoryPetScreenState extends State<InventoryPetScreen> {
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
          widget.petList.length == 0
              ? Expanded(
                  child: Center(
                    child: Text(
                      '현재 보유 중인 펫이 없습니다',
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
                              PetBlock(
                                petInfo: widget.petList[0],
                                mainPetId: widget.mainPetId,
                                changeMainItem: widget.changeMainItem,
                                buySelectItem: widget.buySelectItem,
                              ),
                              PetBlock(
                                petInfo: widget.petList[1],
                                mainPetId: widget.mainPetId,
                                changeMainItem: widget.changeMainItem,
                                buySelectItem: widget.buySelectItem,
                              ),
                              PetBlock(
                                petInfo: widget.petList[2],
                                mainPetId: widget.mainPetId,
                                changeMainItem: widget.changeMainItem,
                                buySelectItem: widget.buySelectItem,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              PetBlock(
                                petInfo: widget.petList[3],
                                mainPetId: widget.mainPetId,
                                changeMainItem: widget.changeMainItem,
                                buySelectItem: widget.buySelectItem,
                              ),
                              PetBlock(
                                petInfo: widget.petList[4],
                                mainPetId: widget.mainPetId,
                                changeMainItem: widget.changeMainItem,
                                buySelectItem: widget.buySelectItem,
                              ),
                              PetBlock(
                                petInfo: widget.petList[5],
                                mainPetId: widget.mainPetId,
                                changeMainItem: widget.changeMainItem,
                                buySelectItem: widget.buySelectItem,
                              ),
                            ],
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     PetBlock(
                          //       petInfo: widget.petList[3],
                          //       mainPetId: widget.mainPetId,
                          //     ),
                          //     PetBlock(
                          //       petInfo: widget.petList[4],
                          //       mainPetId: widget.mainPetId,
                          //     ),
                          //     PetBlock(
                          //       petInfo: widget.petList[5],
                          //       mainPetId: widget.mainPetId,
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 80,
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
