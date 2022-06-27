import 'package:admin/Global.dart';
import 'package:admin/data/MenuRoute.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  _SideMenu createState() =>_SideMenu();
}
class _SideMenu extends State<SideMenu> {
  List<MenuRoute> _routes = routeModel.routes;
  MenuRoute _currentRoute = routeModel.currentRoute;
  bool alive = true;
  @override
  void initState() {
    routeModel.addListener(() {
      _routes = routeModel.routes;
      _currentRoute = routeModel.currentRoute;
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
    return Drawer(
      child: ListView(
        children: _buildMenu(context),
      ),
    );
  }
  _buildMenu(BuildContext context) {
    List<Widget> widgets =[];
    widgets.add(DrawerHeader(
      child: Image.asset("assets/images/logo.png"),
    ));
    for(MenuRoute route in _routes) {
      widgets.add(DrawerListTile(
        current: route == _currentRoute,
        title: route.title??'unknown route',
        svgSrc: route.icon??"assets/icons/menu_dashbord.svg",
        press: () {
          routeModel.currentRoute = route;
          if(route.callback != null){
            route.callback!();
          }
        },
      ));
    }
    return widgets;
  }
}

class DrawerListTile extends StatelessWidget {
  DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
    this.current = false,
  }) : super(key: key);
  bool current;
  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(color: current?Colors.white: Colors.white54),
      ),
    );
  }
}
