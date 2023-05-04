import 'package:daldong/widgets/common/footer.dart';
import 'package:daldong/widgets/mission_block/mission_block.dart';
import 'package:flutter/material.dart';

class MissionScreen extends StatefulWidget {
  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  int doneMissionCnt = 9;
  int boxLength = 110;
  List<Map<String, dynamic>> missionList = [
    {
      "missionId": 1,
      "missionName": "친구 10명에게 운동 독려하기",
      "missionContent": "content",
      "qualificationName": "name",
      "qualificationNum": 1,
      "rewardPoint": 10,
      "done": false,
      "receive": false,
    },
    {
      "missionId": 2,
      "missionName": "친구 20명에게 운동 독려하기",
      "missionContent": "content",
      "qualificationName": "name",
      "qualificationNum": 1,
      "rewardPoint": 20,
      "done": true,
      "receive": false,
    },
    {
      "missionId": 3,
      "missionName": "친구 30명에게 운동 독려하기",
      "missionContent": "content",
      "qualificationName": "name",
      "qualificationNum": 1,
      "rewardPoint": 30,
      "done": true,
      "receive": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: Footer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  '미션',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 42,
                      ),
                      Text(
                        doneMissionCnt == 10
                            ? '모든 미션을 완료했습니다!'
                            : '오늘 완료한 미션: ${doneMissionCnt}개 (남은 미션 ${10 - doneMissionCnt}개)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 42,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MissionBlock(
                            missionId: missionList[0]['missionId'],
                            missionName: missionList[0]['missionName'],
                            missionContent: missionList[0]['missionContent'],
                            qualificationName: missionList[0]
                                ['qualificationName'],
                            qualificationNum: missionList[0]
                                ['qualificationNum'],
                            rewardPoint: missionList[0]['rewardPoint'],
                            done: missionList[0]['done'],
                            receive: missionList[0]['receive'],
                            blockLine: 1,
                            blockPosition: 1,
                          ),
                          MissionBlock(
                            missionId: missionList[1]['missionId'],
                            missionName: missionList[1]['missionName'],
                            missionContent: missionList[1]['missionContent'],
                            qualificationName: missionList[1]
                                ['qualificationName'],
                            qualificationNum: missionList[1]
                                ['qualificationNum'],
                            rewardPoint: missionList[1]['rewardPoint'],
                            done: missionList[1]['done'],
                            receive: missionList[1]['receive'],
                            blockLine: 1,
                            blockPosition: 2,
                          ),
                          MissionBlock(
                            missionId: missionList[2]['missionId'],
                            missionName: missionList[2]['missionName'],
                            missionContent: missionList[2]['missionContent'],
                            qualificationName: missionList[2]
                                ['qualificationName'],
                            qualificationNum: missionList[2]
                                ['qualificationNum'],
                            rewardPoint: missionList[2]['rewardPoint'],
                            done: missionList[2]['done'],
                            receive: missionList[2]['receive'],
                            blockLine: 1,
                            blockPosition: 3,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MissionBlock(
                            missionId: missionList[0]['missionId'],
                            missionName: missionList[0]['missionName'],
                            missionContent: missionList[0]['missionContent'],
                            qualificationName: missionList[0]
                                ['qualificationName'],
                            qualificationNum: missionList[0]
                                ['qualificationNum'],
                            rewardPoint: missionList[0]['rewardPoint'],
                            done: missionList[0]['done'],
                            receive: missionList[0]['receive'],
                            blockLine: 2,
                            blockPosition: 1,
                          ),
                          MissionBlock(
                            missionId: missionList[1]['missionId'],
                            missionName: missionList[1]['missionName'],
                            missionContent: missionList[1]['missionContent'],
                            qualificationName: missionList[1]
                                ['qualificationName'],
                            qualificationNum: missionList[1]
                                ['qualificationNum'],
                            rewardPoint: missionList[1]['rewardPoint'],
                            done: missionList[1]['done'],
                            receive: missionList[1]['receive'],
                            blockLine: 2,
                            blockPosition: 2,
                          ),
                          MissionBlock(
                            missionId: missionList[2]['missionId'],
                            missionName: missionList[2]['missionName'],
                            missionContent: missionList[2]['missionContent'],
                            qualificationName: missionList[2]
                                ['qualificationName'],
                            qualificationNum: missionList[2]
                                ['qualificationNum'],
                            rewardPoint: missionList[2]['rewardPoint'],
                            done: missionList[2]['done'],
                            receive: missionList[2]['receive'],
                            blockLine: 2,
                            blockPosition: 3,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MissionBlock(
                            missionId: missionList[0]['missionId'],
                            missionName: missionList[0]['missionName'],
                            missionContent: missionList[0]['missionContent'],
                            qualificationName: missionList[0]
                                ['qualificationName'],
                            qualificationNum: missionList[0]
                                ['qualificationNum'],
                            rewardPoint: missionList[0]['rewardPoint'],
                            done: missionList[0]['done'],
                            receive: missionList[0]['receive'],
                            blockLine: 3,
                            blockPosition: 1,
                          ),
                          MissionBlock(
                            missionId: missionList[1]['missionId'],
                            missionName: missionList[1]['missionName'],
                            missionContent: missionList[1]['missionContent'],
                            qualificationName: missionList[1]
                                ['qualificationName'],
                            qualificationNum: missionList[1]
                                ['qualificationNum'],
                            rewardPoint: missionList[1]['rewardPoint'],
                            done: missionList[1]['done'],
                            receive: missionList[1]['receive'],
                            blockLine: 3,
                            blockPosition: 2,
                          ),
                          MissionBlock(
                            missionId: missionList[2]['missionId'],
                            missionName: missionList[2]['missionName'],
                            missionContent: missionList[2]['missionContent'],
                            qualificationName: missionList[2]
                                ['qualificationName'],
                            qualificationNum: missionList[2]
                                ['qualificationNum'],
                            rewardPoint: missionList[2]['rewardPoint'],
                            done: missionList[2]['done'],
                            receive: missionList[2]['receive'],
                            blockLine: 3,
                            blockPosition: 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
