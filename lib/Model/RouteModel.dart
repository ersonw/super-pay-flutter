import '../data/MenuRoute.dart';

import '../SideMenuChangeNotifier.dart';

class RouteModel extends SideMenuChangeNotifier {
  MenuRoute get currentRoute => sideMenu.currentRoute;
  List<MenuRoute> get routes => sideMenu.routes;

  set currentRoute(MenuRoute route) {
    sideMenu.currentRoute = route;
    notifyListeners();
  }
}
