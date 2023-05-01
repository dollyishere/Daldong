import 'package:daldong/widgets/common/footer.dart';
import 'package:flutter/material.dart';

class MissionScreen extends StatefulWidget {
  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Footer(),
      ),
    );
  }
}
