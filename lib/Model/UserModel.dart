import '../ProfileChangeNotifier.dart';
import '../data/User.dart';

class UserModel extends ProfileChangeNotifier {
  User get user => profile.user;

  bool hasToken(){
    if(user != null && user.token != null && user.token.isNotEmpty){
      return true;
    }
    return false;
  }
  bool isAdmin(){
    return user.admin;
  }
  void setToken(String token){
    profile.user.token = token;
    notifyListeners();
  }
  set user(User user){
    profile.user = user;
    notifyListeners();
  }
}
