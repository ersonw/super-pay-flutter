import 'package:admin/Global.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/data/MenuRoute.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/main/login_screen.dart';
import 'package:admin/tools/Request.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Global.dart';
import 'components/side_menu.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}
class _MainScreen extends State<MainScreen>{
  bool alive = true;
  bool isLogin = userModel.hasToken();
  MenuRoute currentRoute = routeModel.currentRoute;
  @override
  void initState() {
    // Request.userInfo();
    routeModel.addListener(() {
      if (alive) currentRoute = routeModel.currentRoute;
      if(mounted) setState(() {});
    });
    userModel.addListener(() {
      if (alive) isLogin = userModel.hasToken();
      // Request.userInfo();
      if(mounted) setState(() {});
    });
    super.initState();
  }
  @override
  void dispose() {
    alive = false;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Global.mainContext = context;
    Global.initMain = true;
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: _buildRow(),
      ),
    );
  }
  _buildRow(){
    if(isLogin){
      return  Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: SideMenu(),
            ),
          Expanded(
            // It takes 5/6 part of the screen
            flex: 5,
            child: currentRoute.screen,
          ),
        ],
      );
    }
    return LoginScreen();
  }
}
