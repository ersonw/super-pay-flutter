import 'package:admin/screens/dashboard/IPListScreen.dart';
import 'package:admin/screens/dashboard/LogingScreen.dart';
import 'package:admin/screens/dashboard/order_screen.dart';

import 'screens/dashboard/dashboard_screen.dart';
import 'package:flutter/cupertino.dart';

import 'data/MenuRoute.dart';

List<MenuRoute> getRoutes() {
  return [
    MenuRoute(
      title: '仪表盘',
      icon: "assets/icons/menu_dashbord.svg",
      screen: DashboardScreen(),
      // screen: IPListScreen(),
    ),
    MenuRoute(
      title: '渠道总览',
      icon: "assets/icons/menu_tran.svg",
      screen: DashboardScreen(),
      // admin: true,
    ),
    MenuRoute(
      title: '渠道管理',
      icon: "assets/icons/menu_task.svg",
      screen: DashboardScreen(),
      admin: true,
    ),
    MenuRoute(
      title: '用户管理',
      icon: "assets/icons/menu_task.svg",
      screen: DashboardScreen(),
      admin: true,
    ),
    MenuRoute(
      title: '提现管理',
      icon: "assets/icons/menu_task.svg",
      screen: DashboardScreen(),
      admin: true,
    ),
    MenuRoute(
      title: '提现方式',
      icon: "assets/icons/menu_task.svg",
      screen: DashboardScreen(),
      admin: true,
    ),
    MenuRoute(
      title: '商户订单',
      icon: "assets/icons/menu_task.svg",
      screen: OrderScreen(),
    ),
    MenuRoute(
      title: 'IP白名单',
      icon: "assets/icons/menu_task.svg",
      screen: IPListScreen(),
    ),
    MenuRoute(
      title: '登录日志',
      icon: "assets/icons/menu_task.svg",
      screen: LogingScreen(),
    ),
  ];
}
