import 'package:daldong/services/mission_api.dart';
import 'package:daldong/widgets/common/footer.dart';
import 'package:daldong/widgets/mission_block/mission_block.dart';
import 'package:flutter/material.dart';

class MissionScreen extends StatefulWidget {
  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  int doneMissionCnt = 0;
  int boxLength = 110;
  bool isLoading = true;
  List<dynamic> missionList = [];

  @override
  void initState() {
    getMissionStatus(
      success: (dynamic response) {
        setState(() {
          missionList = response['data'];
          print(response['data']);
          print(missionList.length);
          missionList.map((mission) {
            if (mission['done'] == true) {
              setState(() {
                doneMissionCnt += 1;
              });
            }
          });
          isLoading = false;
        });
      },
      fail: (error) {
        print('미션 상황 호출 오류 : $error');
      },
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: Footer(),
        body: isLoading ? Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColor,),): Padding(
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
              Text(
                '(매일 12시에 초기화 됩니다.)',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 42,
                      ),
                      Text(
                        doneMissionCnt == 10
                            ? '모든 미션을 완료했습니다!'
                            : '오늘 완료한 미션: $doneMissionCnt개 (남은 미션 ${9 - doneMissionCnt}개)',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 330,
                            height: 330,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitHeight,
                                image: AssetImage(
                                    'lib/assets/images/animals/Duck.png'),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MissionBlock(
                                    missionInfo: missionList[0],
                                    blockLine: 1,
                                    blockPosition: 1,
                                  ),
                                  MissionBlock(
                                    missionInfo: missionList[1],
                                    blockLine: 1,
                                    blockPosition: 2,
                                  ),
                                  MissionBlock(
                                    missionInfo: missionList[2],
                                    blockLine: 1,
                                    blockPosition: 3,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MissionBlock(
                                    missionInfo: missionList[3],
                                    blockLine: 2,
                                    blockPosition: 1,
                                  ),
                                  MissionBlock(
                                    missionInfo: missionList[4],
                                    blockLine: 2,
                                    blockPosition: 2,
                                  ),
                                  MissionBlock(
                                    missionInfo: missionList[5],
                                    blockLine: 2,
                                    blockPosition: 3,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MissionBlock(
                                    missionInfo: missionList[6],
                                    blockLine: 3,
                                    blockPosition: 1,
                                  ),
                                  MissionBlock(
                                    missionInfo: missionList[7],
                                    blockLine: 3,
                                    blockPosition: 2,
                                  ),
                                  MissionBlock(
                                    missionInfo: missionList[8],
                                    blockLine: 3,
                                    blockPosition: 3,
                                  ),
                                ],
                              ),
                            ],
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
