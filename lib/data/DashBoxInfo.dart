import 'dart:ui';

import 'package:flutter/cupertino.dart';

class DashBoxInfo {
  DashBoxInfo(
      {this.svgSrc,
      this.title,
      this.topRight,
      this.context,
      this.percentage,
      this.bottomLeft,
      this.bottomRight});

  Widget? svgSrc;
  Widget? topRight;
  String? title;
  String? context;
  int? percentage;
  String? bottomLeft;
  String? bottomRight;

  DashBoxInfo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        context = json['context'],
        percentage = json['percentage'],
        bottomLeft = json['bottomLeft'],
        bottomRight = json['bottomRight'];
}
