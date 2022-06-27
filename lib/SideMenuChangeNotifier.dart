import 'package:admin/Global.dart';
import 'package:admin/data/SideMenu.dart';
import 'package:admin/tools/RouteUtil.dart';
import 'package:flutter/cupertino.dart';

class SideMenuChangeNotifier extends ChangeNotifier {
  SideMenu get sideMenu => RouteUtil.sideMenu;

  @override
  void notifyListeners() {
    super.notifyListeners(); //通知依赖的Widget更新
  }
}
