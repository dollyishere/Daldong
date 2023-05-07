import 'package:flutter/material.dart';

class ExerciseInfoBlock extends StatelessWidget {
  final String infoName;
  final Icon infoIcon;
  final int infoValue;
  final String infoUnit;

  const ExerciseInfoBlock({
    Key? key,
    required this.infoName,
    required this.infoIcon,
    required this.infoValue,
    required this.infoUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Container(
      width: 80,
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            infoName,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              infoIcon,
              SizedBox(
                width: 2,
              ),
              Text(
                infoValue.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  // fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Text(
            infoUnit,
            style: TextStyle(
              fontSize: 14,
              // fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}