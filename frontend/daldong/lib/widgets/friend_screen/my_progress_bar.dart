import 'dart:math';
import 'package:flutter/material.dart';

class MyProgressBar extends StatefulWidget {
  final int progressNum;

  const MyProgressBar({
    Key? key,
    required this.progressNum,
  }) : super(key: key);

  @override
  State<MyProgressBar> createState() => _MyProgressBarState();
}

class _MyProgressBarState extends State<MyProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 4,
              ),
              Text(
                '1',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 70,
              ),
              Text(
                '5',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 60,
              ),
              Text(
                '10',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 60,
              ),
              Text(
                '15',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                width: 60,
              ),
              Text(
                '20',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Stack(
            children: [
              Positioned(
                top: 4,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  width: 320,
                  height: 14,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).shadowColor,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20, // 원의 반지름 설정
                        backgroundColor:
                            Theme.of(context).shadowColor, // 이미지 가져오기
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: CircleAvatar(
                          radius: 12, //의 반지름 설정
                          backgroundColor: widget.progressNum >= 1
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).shadowColor, // 이미지 가져오기
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20, // 원의 반지름 설정
                        backgroundColor:
                            Theme.of(context).shadowColor, // 이미지 가져오기
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: CircleAvatar(
                          radius: 12, // 원의 반지름 설정
                          backgroundColor: widget.progressNum >= 5
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).shadowColor, // 이미지 가져오기
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20, // 원의 반지름 설정
                        backgroundColor:
                            Theme.of(context).shadowColor, // 이미지 가져오기
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: CircleAvatar(
                          radius: 12, // 원의 반지름 설정
                          backgroundColor: widget.progressNum >= 10
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).shadowColor, // 이미지 가져오기
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20, // 원의 반지름 설정
                        backgroundColor:
                            Theme.of(context).shadowColor, // 이미지 가져오기
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: CircleAvatar(
                          radius: 12, //// 원의 반지름 설정
                          backgroundColor: widget.progressNum >= 15
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).shadowColor, // 이미지 가져오기
                        ),
                      ),
                    ],
                  ),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20, // 원의 반지름 설정
                        backgroundColor:
                            Theme.of(context).shadowColor, // 이미지 가져오기
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: CircleAvatar(
                          radius: 12,

                          backgroundColor: widget.progressNum >= 20
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).shadowColor, // 이미지 가져오기
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 7,
                left: 12,
                child: Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  width: (300 * min((widget.progressNum / 20), 1)).toDouble(),
                  height: 7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
