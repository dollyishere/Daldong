import 'package:daldong/services/user_api.dart';
import 'package:flutter/material.dart';

class UpdateUserInfoDialog extends StatefulWidget {
  final Function updateNickname;
  const UpdateUserInfoDialog({Key? key, required this.updateNickname}) : super(key: key);
  @override
  State<UpdateUserInfoDialog> createState() => _UpdateUserInfoDialogState();
}

class _UpdateUserInfoDialogState extends State<UpdateUserInfoDialog> {

  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();

  bool _isNicknameChecked = false;
  bool _isValidatedNickname = false;
  String _nickname = '';

  Future<bool> _checkNickname() async {
    await updateUserNickname(
        success: (dynamic response) async{
          setState(() {
            _isNicknameChecked = true;
          });
          if (response.statusCode == 200){
            _isValidatedNickname = true;
          } else if (response.statusCode == 409){
            _isValidatedNickname = false;
          } else {
            print("닉네임 확인 오류 발생: ${response.statusCode}");
            _isValidatedNickname = false;
          }
        },
        fail: (error){
          print("닉네임 확인 통신 실패: $error");
        },
        body: {"nickname": _nickname}
    );
    return _isValidatedNickname;
  }

  String? _validateNickname(String? value) {
    if (value == null || value.isEmpty || value.trim().isEmpty) {
      return '닉네임을 입력해주세요.';
    }
    if (value.length < 2 || value.length > 6){
      return '닉네임은 2~6자여야합니다';
    }
    if (_isNicknameChecked == true && _isValidatedNickname == false){
      return "중복 닉네임입니다.";
    }
    return null;
  }

  @override
  void initState() {
    final RegExp nicknameRegex = RegExp(r'^[a-zA-Zㄱ-ㅎ가-힣0-9\s]+$');

    super.initState();
    _nicknameController.addListener(() {

      if (_isNicknameChecked == true){
        setState(() {
          _isNicknameChecked = false;
          _isValidatedNickname = false;
        });
      }

      // Remove any trailing whitespace characters
      String currentValue = _nicknameController.text.trim();
      if (currentValue.length > 6) {
        currentValue = currentValue.substring(0, 7);
      }
      if (!nicknameRegex.hasMatch(currentValue[currentValue.length - 1])) {
        currentValue = currentValue.substring(0, currentValue.length - 1);
      }
      // Set the value of the controller to the trimmed value
      _nicknameController.value = _nicknameController.value.copyWith(
        text: currentValue,
        selection: TextSelection.collapsed(offset: currentValue.length),
      );
    });
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

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
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nicknameController,
                  decoration: InputDecoration(labelText: '닉네임'),
                  validator: _validateNickname,
                  onSaved: (value){
                    _nickname = value!.trim();
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                setState(() {
                  _nickname = _nicknameController.text;
                });
                bool isChanged = await _checkNickname();
                if(isChanged == true){
                  widget.updateNickname();
                  Navigator.of(context).pop();
                }
              }
            },
            child: Text(
              '변경',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              '취소',
              style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).primaryColor
              ),
            ),
          ),
        ],
      ),
    );
  }
}

