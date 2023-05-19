import 'package:daldong/services/inventory_api.dart';
import 'package:flutter/material.dart';

class BuyConfirmDialog extends StatefulWidget {
  final String assetType;
  final dynamic assetInfo;
  final void Function(String, int) buySelectItem;

  const BuyConfirmDialog({
    Key? key,
    required this.assetType,
    this.assetInfo,
    required this.buySelectItem,
  }) : super(key: key);

  @override
  State<BuyConfirmDialog> createState() => _BuyConfirmDialogState();
}

class _BuyConfirmDialogState extends State<BuyConfirmDialog> {
  bool _isWaiting = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
          primary: Theme.of(context).primaryColor,
          secondary: Theme.of(context).secondaryHeaderColor,
        ),
      ),
      child: AlertDialog(
        title: Text(
          _isWaiting ? "${widget.assetType} 구매" : "${widget.assetType} 구매 완료",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          ElevatedButton(
            child: Text(
              _isWaiting ? "구매" : "닫기",
              // style:
              //     TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              if (_isWaiting == true) {
                postBuyAsset(
                    success: (dynamic response) {
                      print('에셋 구매 완료');
                      setState(() {
                        _isWaiting = false;
                      });
                    },
                    fail: (error) {
                      print('에셋 구매 에러: $error');
                    },
                    body: {'assetId': widget.assetInfo['assetId']});
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          if (_isWaiting)
            TextButton(
              child: Text(
                "취소",
                style: TextStyle(
                    fontSize: 14, color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                // No 버튼을 눌렀을 때 수행할 작업
                Navigator.of(context).pop();
              },
            ),
        ],
        content: Text(
          _isWaiting ? "구매를 진행하시겠습니까?" : "${widget.assetInfo['assetKRName']}  구매 완료!"
        ),
      ),
    );
  }
}
