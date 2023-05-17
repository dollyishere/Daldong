import 'package:daldong/services/inventory_api.dart';
import 'package:daldong/widgets/inventory_screen/motion_block.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class InventoryDialogDetail extends StatefulWidget {
  final dynamic petInfo;
  final FocusNode unUsedFocusNode;
  final void Function(String, int) changeAssetName;

  const InventoryDialogDetail({
    required this.petInfo,
    required this.unUsedFocusNode,
    required this.changeAssetName,
    Key? key,
  }) : super(key: key);

  @override
  State<InventoryDialogDetail> createState() => _InventoryDialogDetailState();
}

class _InventoryDialogDetailState extends State<InventoryDialogDetail> {
  late var _controller;
  final ValueNotifier<int> selectedMotionId = ValueNotifier(1);
  final ValueNotifier<String> selectedMotionName = ValueNotifier('Idle_A');
  GroupButtonController buttonController = GroupButtonController();

  bool nickNameEdit = false;
  late String _nickname;
  bool _isNicknameChecked = false;
  TextEditingController _nicknameController = TextEditingController();

  void changeSelectedMotion(int changeId) {
    setState(() {
      selectedMotionId.value = changeId;
    });
  }

  List<Map<String, dynamic>> motionList = [
    {
      'motionId': 0,
      'motionAssetId': 2,
      'motionName': 'Bounce',
      'motionKRName': '깡총깡총',
      'unLockExp': 10,
    },
    {
      'motionId': 1,
      'motionAssetId': 4,
      'motionName': 'Death',
      'motionKRName': '죽은척',
      'unLockExp': 20,
    },
    {
      'motionId': 2,
      'motionAssetId': 6,
      'motionName': 'Fear',
      'motionKRName': '겁먹음',
      'unLockExp': 30,
    },
    {
      'motionId': 3,
      'motionAssetId': 12,
      'motionName': 'Jump',
      'motionKRName': '제자리뛰기',
      'unLockExp': 40,
    },
    {
      'motionId': 4,
      'motionAssetId': 13,
      'motionName': 'Roll',
      'motionKRName': '구르기',
      'unLockExp': 50,
    },
    {
      'motionId': 5,
      'motionAssetId': 15,
      'motionName': 'Sit',
      'motionKRName': '앉아있기',
      'unLockExp': 60,
    },
    {
      'motionId': 6,
      'motionAssetId': 18,
      'motionName': 'Walk',
      'motionKRName': '걷기',
      'unLockExp': 70,
    },
    {
      'motionId': 7,
      'motionAssetId': 17,
      'motionName': 'Swim',
      'motionKRName': '수영',
      'unLockExp': 80,
    },
    {
      'motionId': 8,
      'motionAssetId': 16,
      'motionName': 'Spin',
      'motionKRName': '제자리돌기',
      'unLockExp': 90,
    },
    {
      'motionId': 9,
      'motionAssetId': 7,
      'motionName': 'Fly',
      'motionKRName': '날기',
      'unLockExp': 100,
    },
  ];

  void changeAnimation(String changeName) {
    setState(() {
      selectedMotionName.value = changeName;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    print(widget.petInfo['exp']);
    buttonController = GroupButtonController(
      disabledIndexes: motionList.map((motion) {
        if (motion['unLockExp'] > widget.petInfo['exp']) {
          return int.tryParse(motion['motionId'].toString() ?? '99') ?? 99;
        } else {
          return 99;
        }
      }).toList(),
    );
    print(buttonController.disabledIndexes);
    buttonController.addListener(() {
      setState(() {});
    });
    _nickname = widget.petInfo['assetCustomName'];
    _nicknameController = TextEditingController(text: _nickname);
    super.initState();
  }

  ValueNotifier<double> animationSpeed = ValueNotifier<double>(1.0);

  @override
  void dispose() {
    // TODO: implement dispose
    buttonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 560,
      width: 380,
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                Container(
                  width: 124,
                  height: 124,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // image: DecorationImage(
                    //   image: AssetImage(
                    //       'lib/assets/images/animals/${widget.petInfo['assetName']}.png'),
                    //   fit: BoxFit.cover,
                    // ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColorDark,
                      width: 14,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        spreadRadius: 0.3,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 64,
                    // 원래는 이 자리에 3D 에셋이 들어가야 함 ~~~
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: Colors.transparent,
                      // backgroundImage: AssetImage(
                      //   'lib/assets/images/animals/${widget.petInfo['assetName']}.png',
                      // ),
                      child: ModelViewer(
                        key: ValueKey(selectedMotionName.value),
                        animationCrossfadeDuration: 0,
                        loading: Loading.auto,
                        src:
                            'lib/assets/models/animals/${widget.petInfo['assetName']}.glb', // a bundled asset file
                        alt: "pet model",
                        ar: false,
                        arModes: ['scene-viewer', 'webxr', 'quick-look'],
                        autoRotate: false,
                        cameraControls: true,
                        scale: '0.1 0.1 0.1',
                        cameraOrbit: '40deg 55deg 100m',
                        fieldOfView: "30deg",
                        // iosSrc: 'https://modelviewer.dev/shared-assets/models/Astronaut.usdz',
                        disableZoom: true,
                        animationName: selectedMotionName.value,
                        autoPlay: true,
                        exposure: 0.75,
                        onWebViewCreated: (controller) => {
                          _controller = controller, //Set the controller up
                        },
                        // poster:

                        relatedJs: """
                      function setAnimationName(animation) {
                        const modelViewer = document.querySelector('#<ID>');
                        modelViewer.animationName = animation;
                      }
                      """,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 140,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.75),
              borderRadius: BorderRadius.circular(
                20,
              ),
              // border: Border.all(color: Colors.white, width: 2,)
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 4,
              ),
              child: nickNameEdit
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 30,
                          width: 76,
                          child: TextFormField(
                            onTapOutside: (PointerDownEvent event) {
                              FocusScope.of(context)
                                  .requestFocus(widget.unUsedFocusNode);
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: _nicknameController,
                            maxLength: 6,
                            scrollPadding: EdgeInsets.zero,
                            cursorColor: Theme.of(context).primaryColorDark,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                            // validator: _validateNickname,
                            // onSaved: (value) {
                            //   _nickname = value!.trim();
                            // },
                            onChanged: (value) {
                              setState(() {
                                _nickname = value!.trim();
                              });
                            },
                            decoration: InputDecoration(
                              counterText: '',
                              // suffixIcon: Icon(
                              //   Icons.check,
                              //   color: Theme.of(context).primaryColor,
                              //   size: 16,
                              // ),
                              labelText: '',
                              border: const UnderlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        InkWell(
                          onTap: () {
                            putChangePetNickname(
                                success: (dynamic response) {
                                  setState(() {
                                    print(response);
                                    widget.changeAssetName(_nickname, widget.petInfo['assetId']);
                                    widget.petInfo['assetCustomName'] = _nickname;
                                    nickNameEdit = !nickNameEdit;
                                  });
                                },
                                fail: (error) {
                                  print('펫 이름 변경 호출 오류 : $error');
                                  },
                                body: {
                                  "assetId" : widget.petInfo['assetId'],
                                  "setAssetName": _nickname,
                                }
                            );
                          },
                          child: Icon(
                            Icons.save_as,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _nickname = widget.petInfo['assetCustomName'];
                              _nicknameController = TextEditingController(text: _nickname);
                              nickNameEdit = !nickNameEdit;
                            });
                          },
                          child: Icon(
                            Icons.cancel,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.petInfo['assetCustomName'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              nickNameEdit = !nickNameEdit;
                            });
                          },
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '현재 친밀도',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.petInfo['exp']} Exp',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          width: 150,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xFFEFEFEF),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                          ),
                          width: (1.5 * widget.petInfo['exp'])
                              .clamp(0, 200)
                              .toDouble(),
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: widget.petInfo['exp'] >= 100
                                ? BorderRadius.circular(5)
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Text(
                //   '${widget.petInfo['exp']} Exp',
                //   style: TextStyle(
                //     fontSize: 12,
                //   ),
                // ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  '모션',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                GroupButton(
                  maxSelected: 1,
                  buttons: motionList.map((motion) {
                    if (motion['unLockExp'] > widget.petInfo['exp']) {
                      return '${motion['unLockExp']} Exp';
                    } else {
                      return motion['motionKRName'];
                    }
                  }).toList(),
                  controller: buttonController,
                  options: GroupButtonOptions(
                    buttonHeight: 32,
                    buttonWidth: 72,
                    spacing: 6,
                    runSpacing: 6,
                    selectedColor: Theme.of(context).primaryColorDark,
                    selectedShadow: const [],
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    unselectedShadow: const [],
                    unselectedColor: Colors.grey[300],
                    unselectedTextStyle: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  onSelected: (val, i, selected) {
                    // debugPrint('$i');
                    selectedMotionId.value = i;
                    selectedMotionName.value = motionList[i]['motionName'];
                    print(selectedMotionName.value);
                  },
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => {
              Navigator.pop(context),
            },
            splashColor: Colors.transparent,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).primaryColorDark,
              child: Icon(
                Icons.highlight_remove_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
