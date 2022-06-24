import 'package:flutter/cupertino.dart';

class MenuRoute {
  MenuRoute({this.title,this.icon,required this.screen,this.callback});
  String? title;
  String? icon;
  Widget screen ;
  void Function()? callback;
}
