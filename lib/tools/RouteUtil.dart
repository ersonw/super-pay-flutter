import 'package:admin/Global.dart';
import 'package:admin/data/MenuRoute.dart';
import 'package:admin/data/SideMenu.dart';
import 'package:admin/data/User.dart';
import 'package:flutter/cupertino.dart';

import '../RouteList.dart';

class RouteUtil {
  static late SideMenu sideMenu;
  static User _user = userModel.user;
  static init(){
    load();
    userModel.addListener(() {
      _user = userModel.user;
      load();
    });
  }
  static load(){
    List<MenuRoute> routes = [];
    for(MenuRoute route in getRoutes()){
      if(route.admin == true){
        if(_user.admin == true) routes.add(route);
      }else{
        routes.add(route);
      }
    }
    sideMenu = SideMenu(
      routes: routes,
      currentRoute: routes.isNotEmpty ? routes[0] : MenuRoute(screen: Container()),
    );
  }
}
