import 'MenuRoute.dart';
import 'package:flutter/cupertino.dart';

class SideMenu {
  SideMenu({required this.routes,required this.currentRoute});
  MenuRoute currentRoute;
  List<MenuRoute> routes = [];
}
