import 'package:flutter/material.dart';

class MotionBlock extends StatelessWidget {
  final dynamic motionInfo;
  final int petExp;
  final void Function(int) changeFunc;

  const MotionBlock({
    required this.motionInfo,
    required this.petExp,
    required this.changeFunc,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {},
        child: Container(
          width: 72,
          height: 32,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 3,
                spreadRadius: 0.5,
              ),
            ],
          ),
          child: Center(
            child: Text(
              motionInfo['motionName'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
