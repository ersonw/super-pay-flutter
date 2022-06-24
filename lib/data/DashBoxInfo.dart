import 'dart:ui';

class DashBoxInfo {
  DashBoxInfo({this.svgSrc,this.title, this.color, this.percentage,this.bottomLeft,this.bottomRight,this.context});
  String? title;
  String? context;
  String? svgSrc;
  Color? color;
  int? percentage;
  String? bottomLeft;
  String? bottomRight;
}