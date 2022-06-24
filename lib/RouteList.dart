import 'screens/dashboard/dashboard_screen.dart';
import 'package:flutter/cupertino.dart';

import 'data/MenuRoute.dart';

List<MenuRoute> getRoutes() {
  return [
    MenuRoute(
      title: '总览',
      icon: "assets/icons/menu_dashbord.svg",
      screen: DashboardScreen(),
    ),
    MenuRoute(
      title: 'Transaction',
      icon: "assets/icons/menu_tran.svg",
      screen: Container(),
    ),
    MenuRoute(
      title: 'Task',
      icon: "assets/icons/menu_task.svg",
      screen: DashboardScreen(),
    ),
  ];
}
