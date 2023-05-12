import 'package:daldong/services/login_api.dart';
import 'package:daldong/utilites/common/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_button/group_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  double imageSize = 60;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  late String _accessToken;
  late String _nickname;
  dynamic _age;
  dynamic _height;
  dynamic _weight;
  dynamic _ability;
  int _currentStep = 0;
  bool _isMale = true;
  bool _isNicknameChecked = false;
  bool _isValidatedNickname = false;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  bool _isSignedIn = false;
  bool _showModal = false;

  final _nicknameController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  void _handleStepContinue() {
    if (_formKey1.currentState!.validate()) {
      _formKey1.currentState!.save();
      setState(() {
        _currentStep += 1;
      });
    }
  }
  void _handleStepCancel() async {
    String? uid = await storage.read(key: 'uid');
    print(uid);

    bool isSignedIn = false;
    bool isLoggedIn = false;
    if (_formKey1.currentState!.validate()) {
      _formKey1.currentState!.save();

      Map<String, dynamic> body = {
        'nickname': _nickname,
      };
      await postUser(
        success: (dynamic response) async {
          // 새로운 유저 생성 성공
          print("성공?!?!?!");
          setState(() {
            isSignedIn = true;

          });
        },
        fail: (error){
          print("회원가입 호출 오류: $error");
        },
        body: body,
        uid: uid!,
      );
      if (isSignedIn == true) {
        isLoggedIn = await login();
        if (isLoggedIn != false){
          setState(() {
            _isLoggedIn = isLoggedIn;
          });
        }
      }

      print("_isLoggedIn: $_isLoggedIn");
      if (_isLoggedIn == true){
        Navigator.pushReplacementNamed(context, '/home');
      } else{
        print("로그인 오류 발생");
        // TODO: 모달 띄우기?
      }
      print("여기 오지 마");

      // Reset form data and current step
      setState(() {
        _currentStep = 0;
        _nickname = "";
        _age = 0;
        _height = 0;
        _weight = 0;
      });
    }
  }

  void _handleComplete() async {
    String? uid = await storage.read(key: 'uid');
    print(uid);

    bool isSignedIn = false;
    bool isLoggedIn = false;
    if (_formKey1.currentState!.validate() && _formKey2.currentState!.validate()) {
      _formKey1.currentState!.save();
      _formKey2.currentState!.save();

      Map<String, dynamic> body = {
        'nickname': _nickname,
        'height': _height,
        'weight': _weight,
        'gender': _isMale,
        'age': _age,
        'ability': _ability,
      };
      await postUser(
        success: (dynamic response) async {
          // 새로운 유저 생성 성공
          print("성공?!?!?!");
          setState(() {
            isSignedIn = true;

          });
        },
        fail: (error){
          print("회원가입 호출 오류: $error");
        },
        body: body,
        uid: uid!,
      );
      if (isSignedIn == true) {
        isLoggedIn = await login();
        if (isLoggedIn != false){
          setState(() {
            _isLoggedIn = isLoggedIn;
          });
        }
      }

      print("_isLoggedIn: $_isLoggedIn");
      if (_isLoggedIn == true){
        Navigator.pushReplacementNamed(context, '/home');
      } else{
        print("로그인 오류 발생");
        // TODO: 모달 띄우기?
      }
      print("여기 오지 마");
    }
  }

  void _checkNickname(){
    setState(() {
      _isLoading = true;
    });
    getNicknameCheck(
      result: (dynamic response) {
        setState(() {
        });
        Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
            _isLoading = false;
            _isNicknameChecked = true;

            if (response.statusCode == 200) {
              _isValidatedNickname = true;
            } else {
              _isValidatedNickname = false;
            }
          });
        });

      },
      fail: (error) {
        print('닉네임 중복 확인 호출 오류: $error');
      },
      nickname: _nickname
    );
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
    super.initState();
    _nicknameController.addListener(() {
      if (_isNicknameChecked == true){
        setState(() {
          _isNicknameChecked = false;
        });
      }
      // Remove any trailing whitespace characters
      String currentValue = _nicknameController.text.trim();
      if (currentValue.length > 6) {
        currentValue = currentValue.substring(0, 7);
      }
      // setState 필요할까?
      setState(() {
        _nickname = currentValue;
      });
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
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 30),
                  child: Image.asset(
                    'lib/assets/images/common/main_logo.png',
                    width: imageSize,
                    height: imageSize,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16, left: 30),
                  child: Text(
                      "달려동물과 함께\n달려볼까요?",
                      style: Theme.of(context).textTheme.titleLarge
                  ),
                ),
                // SizedBox(height: 16),
                Theme(
                  data: ThemeData(
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Theme.of(context).primaryColor,
                      secondary: Theme.of(context).secondaryHeaderColor,

                    ),
                  ),
                  child: Center(
                    child: Stepper(
                      controlsBuilder: (BuildContext ctx, ControlsDetails dtl){
                        return Row(
                          children: [
                            const SizedBox(height: 30,),
                            if (_currentStep == 0) ElevatedButton(
                              style: _isValidatedNickname
                                ? null
                                : TextButton.styleFrom(
                                  foregroundColor: Colors.black54,
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                              onPressed: _isValidatedNickname ? dtl.onStepContinue : null,
                              child: const Text("다음"),
                            ),
                            if (_currentStep == 0) ElevatedButton(
                                style: _isValidatedNickname
                                  ? TextButton.styleFrom(
                                    foregroundColor: Colors.black54,
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    )
                                  : null,
                                onPressed: _checkNickname,
                                child: const Text("닉네임 중복 확인"),
                            ),
                            if (_currentStep == 1) ElevatedButton(
                              onPressed: _handleComplete,
                              child: const Text("완료"),
                            ),
                            if (_currentStep != 0) ElevatedButton(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black54,
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                              ),
                              onPressed: _handleStepCancel,
                              child: const Text("나중에 입력할래요"),
                            ),
                          ],
                        );
                      },
                      currentStep: _currentStep,
                      onStepCancel: _handleStepCancel,
                      onStepContinue: _handleStepContinue,
                      steps: [
                        Step(
                          isActive: _currentStep == 0,
                          title: const Text('필수 정보 입력'),
                          content: Container(
                            alignment: Alignment.centerLeft,
                            child: Form(
                              key: _formKey1,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: TextFormField(
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  controller: _nicknameController,
                                  validator: _validateNickname,
                                  onSaved: (value) {
                                    _nickname = value!.trim();
                                  },
                                  decoration: InputDecoration(
                                    suffixIcon: _isLoading
                                      ? const Icon(Icons.more_horiz, color: Colors.grey)
                                      : _isValidatedNickname
                                        ? const Icon(Icons.check, color: Colors.green)
                                        : null,
                                    labelText: '닉네임',
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Step(
                          isActive: _currentStep == 1,
                          title: const Text('선택 정보 입력'),
                          content: Form(
                            key: _formKey2,
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
                                              if (int.tryParse(value) == null || int.tryParse(value)! > 100) {
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
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return '';
                                              }
                                              if (int.tryParse(value) == null || int.tryParse(value)! > 250) {
                                                return '';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _age = int.tryParse(value!)!;
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
                                              FilteringTextInputFormatter.digitsOnly
                                            ],
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return '';
                                              }
                                              if (int.tryParse(value) == null || int.tryParse(value)! > 200) {
                                                return '';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) {
                                              _age = int.tryParse(value!)!;
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
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
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
                                          controller: GroupButtonController(selectedIndex: 0),
                                          options: GroupButtonOptions(
                                            selectedShadow: const [],
                                            unselectedShadow: const [],
                                            unselectedColor: Colors.grey[300],
                                            unselectedTextStyle: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                          onSelected: (val, i, selected) =>
                                              debugPrint('Button: $val index: $i $selected'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )

      ),
    );
  }
}