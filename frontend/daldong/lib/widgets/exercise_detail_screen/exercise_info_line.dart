import 'package:flutter/material.dart';

class ExerciseInfoLine extends StatelessWidget {
  final String infoLineName;
  final Icon infoLineIcon;
  final String infoLineValue;
  final String infoLineUnit;

  const ExerciseInfoLine({
    Key? key,
    required this.infoLineName,
    required this.infoLineIcon,
    required this.infoLineValue,
    required this.infoLineUnit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.center,
        children: [
          infoLineIcon,
          const SizedBox(
            width: 4,
          ),
          Text(
            infoLineName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
          const Text(
            '------------',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Spacer(),
          Text(
            infoLineValue,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            width: 2,
          ),
          Text(
            infoLineUnit,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}