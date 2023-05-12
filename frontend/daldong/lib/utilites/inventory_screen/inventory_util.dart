import 'package:daldong/widgets/inventory_screen/inventory_dialog_detail.dart';
import 'package:daldong/widgets/inventory_screen/motion_block.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

void showDetailPet(
  BuildContext context,
  dynamic petInfo,
) {
  FocusNode unUsedFocusNode = FocusNode();
  int selectedMotionId = 1;
  void changeSelectedMotion(int changeId) {
    selectedMotionId = changeId;
  }

  ;

  List<Map<String, dynamic>> motionList = [
    {
      'motionId': 2,
      'motionName': '깡총깡총',
      'unLockExp': 55,
    },
    {
      'motionId': 4,
      'motionName': '죽은척',
      'unLockExp': 107,
    },
    {
      'motionId': 6,
      'motionName': '겁먹음',
      'unLockExp': 190,
    },
    {
      'motionId': 12,
      'motionName': '제자리뛰기',
      'unLockExp': 220,
    },
    {
      'motionId': 13,
      'motionName': '구르기',
      'unLockExp': 310,
    },
    {
      'motionId': 15,
      'motionName': '앉아있기',
      'unLockExp': 1020,
    },
    {
      'motionId': 18,
      'motionName': '걷기',
      'unLockExp': 1040,
    },
    // {
    //   'motionId': 17,
    //   'motionName': '수영',
    //   'unLockExp': 1040,
    // },
    {
      'motionId': 16,
      'motionName': '제자리돌기',
      'unLockExp': 1040,
    },
    {
      'motionId': 7,
      'motionName': '날기',
      'unLockExp': 1040,
    },
  ];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        // backgroundColor: Theme.of(context).primaryColorLight,
        backgroundColor: Theme.of(context).primaryColorLight,
        child: SingleChildScrollView(
          child: InventoryDialogDetail(
            petInfo: petInfo,
            unUsedFocusNode: unUsedFocusNode,
          ),
        ),
      );
    },
  );
}
