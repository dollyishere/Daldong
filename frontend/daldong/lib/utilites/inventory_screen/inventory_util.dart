import 'package:daldong/widgets/inventory_screen/inventory_dialog_detail.dart';
import 'package:daldong/widgets/inventory_screen/motion_block.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

void showDetailPet(
  BuildContext context,
  dynamic petInfo,
void Function(String, int) changeAssetName,
) {
  FocusNode unUsedFocusNode = FocusNode();

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
            changeAssetName: changeAssetName,
          ),
        ),
      );
    },
  );
}
