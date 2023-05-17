import 'package:daldong/services/user_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_button/group_button.dart';



class UpdateUserInfoDialog extends StatefulWidget {
  final Function updateInfo;
  final dynamic originalAge;
  final dynamic originalHeight;
  final dynamic originalWeight;
  final dynamic originalGender;
  final dynamic originalAbility;
  const UpdateUserInfoDialog({Key? key,
    required this.updateInfo, this.originalHeight, this.originalWeight, this.originalGender, this.originalAge, this.originalAbility,
  }) : super(key: key);
  @override
  State<UpdateUserInfoDialog> createState() => _UpdateUserInfoDialogState();
}

class _UpdateUserInfoDialogState extends State<UpdateUserInfoDialog> {

  final _formKey = GlobalKey<FormState>();

  dynamic _age = 0;
  dynamic _height = 0;
  dynamic _weight = 0;
  dynamic _isMale = true;
  dynamic _ability = 0;

  late TextEditingController _ageController;
  late TextEditingController _heightController;
  late TextEditingController _weightController;

  @override
  void initState() {
    _ageController = TextEditingController(text: "${widget.originalAge}");
    _heightController = TextEditingController(text: "${widget.originalHeight}");
    _weightController = TextEditingController(text: "${widget.originalWeight}");
    _age = widget.originalAge;
    _height = widget.originalHeight;
    _weight = widget.originalWeight;
    _isMale = widget.originalGender;
    _ability = widget.originalAbility;

  }

  void changeInfo(){
    print("$_height, $_weight, $_age");
    Map<String, dynamic> body = {
      'age': _age,
      'height': _height,
      'weight': _weight,
      'gender': _isMale,
      'ability': _ability,
    };
    updateUserInfo(
      success: (dynamic response){
        print("user info update success");
      },
      fail: (error){
        print("유저 정보 업데이트 실패: $error");
      },
      body: body
    );
  }

  String? _validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    final doubleVal = double.tryParse(value);
    if (doubleVal == null || doubleVal < 80 || doubleVal > 250) {
      return '';
    }
    return null;
  }
  String? _validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    final doubleVal = double.tryParse(value);
    if (doubleVal == null || doubleVal < 30 || doubleVal > 200) {
      return '';
    }
    return null;
  }

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
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
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return '';
                              }
                              if (int.tryParse(value) == null || int.tryParse(value)! < 5 || int.tryParse(value)! > 100) {
                                return '';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _age = int.tryParse(value!)!;
                            },
                            decoration: const InputDecoration(
                              labelText: '나이',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _heightController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}?$')),
                            ],
                            validator: _validateHeight,
                            onSaved: (value) {
                              print("????? $value");
                              _height = int.tryParse(value!);
                            },
                            decoration: const InputDecoration(
                              labelText: '키',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}?$')),
                            ],
                            validator: _validateWeight,
                            onSaved: (value) {
                              _weight = double.tryParse(value!);
                            },
                            decoration: const InputDecoration(
                              labelText: '몸무게',
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('성별'),
                    Expanded(
                      child: RadioListTile<bool>(
                        activeColor: Theme.of(context).primaryColor,
                        title: const Text('남성'),
                        value: true,
                        groupValue: _isMale,
                        onChanged: (bool? value) {
                          setState(() {
                            _isMale = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        activeColor: Theme.of(context).primaryColor,
                        title: const Text('여성'),
                        value: false,
                        groupValue: _isMale,
                        onChanged: (bool? value) {
                          setState(() {
                            _isMale = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("운동 수준"),
                      Container(
                        padding: const EdgeInsets.only(top: 4),
                        child: GroupButton(
                            buttons: const [
                              '입문자',
                              '초심자',
                              '중급자',
                              '고급자'
                            ],
                            controller: GroupButtonController(selectedIndex: _ability),
                            options: GroupButtonOptions(
                              spacing: 5,
                              buttonWidth: MediaQuery.of(context).size.width * 0.15,
                              selectedShadow: const [],
                              unselectedShadow: const [],
                              unselectedColor: Colors.grey[300],
                              unselectedTextStyle: TextStyle(
                                color: Colors.grey[600],
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onSelected: (val, i, selected) {
                              debugPrint('Button: $val index: $i $selected');
                              _ability = i;
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                setState(() {
                  _height = _heightController.text;
                  _weight = _weightController.text;
                  _height = _heightController.text;
                });
                changeInfo();
                setState(() {
                  widget.updateInfo();
                });
                Navigator.of(context).pop();
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

