import 'package:daldong/services/mission_api.dart';
import 'package:flutter/material.dart';

class MissionBlock extends StatefulWidget {
  final Map<String, dynamic> missionInfo;
  final int blockLine;
  final int blockPosition;

  const MissionBlock({
    Key? key,
    required this.missionInfo,
    required this.blockLine,
    required this.blockPosition,
  }) : super(key: key);

  @override
  State<MissionBlock> createState() => _MissionBlockState();
}

class _MissionBlockState extends State<MissionBlock> {
  int boxLength = 110;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color getBoxColorFunc() {
      if (widget.missionInfo['done']) {
        if ((widget.blockLine == 1 && widget.blockPosition == 1) ||
            (widget.blockLine == 2 && widget.blockPosition == 3) ||
            (widget.blockLine == 3 && widget.blockPosition == 2)) {
          return Theme.of(context).primaryColor;
        } else if ((widget.blockLine == 1 && widget.blockPosition == 2) ||
            (widget.blockLine == 2 && widget.blockPosition == 1) ||
            (widget.blockLine == 3 && widget.blockPosition == 3)) {
          return Theme.of(context).primaryColorLight;
        } else {
          return Theme.of(context).primaryColorDark;
        }
      } else {
        if ((widget.blockLine == 1 && widget.blockPosition == 1) ||
            (widget.blockLine == 2 && widget.blockPosition == 3) ||
            (widget.blockLine == 3 && widget.blockPosition == 2)) {
          return Theme.of(context).disabledColor;
        } else if ((widget.blockLine == 1 && widget.blockPosition == 2) ||
            (widget.blockLine == 2 && widget.blockPosition == 1) ||
            (widget.blockLine == 3 && widget.blockPosition == 3)) {
          return Theme.of(context).shadowColor;
        } else {
          return Theme.of(context).secondaryHeaderColor;
        }
      }
    }

    Color boxColor = getBoxColorFunc();

    return Container(
      width: boxLength.toDouble(),
      height: boxLength.toDouble(),
      decoration: BoxDecoration(
        color: widget.missionInfo['receive'] ? Colors.transparent : boxColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            (widget.blockLine == 1 && widget.blockPosition == 1) ? 10.0 : 0.0,
          ),
          topRight: Radius.circular(
            (widget.blockLine == 1 && widget.blockPosition == 3) ? 10.0 : 0.0,
          ),
          bottomLeft: Radius.circular(
            (widget.blockLine == 3 && widget.blockPosition == 1) ? 10.0 : 0.0,
          ),
          bottomRight: Radius.circular(
            (widget.blockLine == 3 && widget.blockPosition == 3) ? 10.0 : 0.0,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Text(
              widget.missionInfo['mission']['missionName'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.missionInfo['receive']
                    ? Colors.transparent
                    : (boxColor == Theme.of(context).shadowColor ||
                            boxColor == Theme.of(context).primaryColorLight)
                        ? Theme.of(context).secondaryHeaderColor
                        : Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          SizedBox(
            height: 4,
          ),
          InkWell(
            onTap: () {
              if (widget.missionInfo['done'] &&
                  !widget.missionInfo['receive']) {
                putMissionPoint(
                  success: (dynamic response) {
                    setState(() {
                      widget.missionInfo['receive'] = true;
                    });
                  },
                  fail: (error) {
                    print('미션 포인트 받기 오류 : $error');
                  },
                  userMissionId: widget.missionInfo['userMissionId'],
                );
              }
            },
            splashColor: Colors.transparent,
            child: Container(
              alignment: Alignment.center,
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget.missionInfo['done']
                    ? widget.missionInfo['receive']
                        ? Colors.transparent
                        : Theme.of(context).primaryColorDark
                    : Theme.of(context).disabledColor,
                boxShadow: [
                  BoxShadow(
                    color: widget.missionInfo['receive']
                        ? Colors.transparent
                        : Colors.black38,
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                  )
                ],
              ),
              child: Text(
                widget.missionInfo['done']
                    ? widget.missionInfo['receive']
                        ? '완료'
                        : '${widget.missionInfo['mission']['rewardPoint']}P'
                    : '미완',
                style: TextStyle(
                  color: widget.missionInfo['receive']
                      ? Colors.transparent
                      : Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
