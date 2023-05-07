import 'package:flutter/material.dart';

class ChartData {
  ChartData(this.category, this.nowValue, this.goal, this.chartColor);
  final String category;
  final double nowValue;
  final double goal;
  final Color chartColor;
}