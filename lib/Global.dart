import 'dart:convert';
import 'package:admin/Model/RouteModel.dart';
import 'package:admin/data/MenuRoute.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'RouteList.dart';
import 'data/SideMenu.dart';
import 'tools/MinioUtil.dart';
import 'Model/ConfigModel.dart';
import 'Model/UserModel.dart';
import 'tools/Request.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

import 'data/Profile.dart';
import 'package:encrypt/encrypt.dart' as XYQ;
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';

final ConfigModel configModel = ConfigModel();
final UserModel userModel = UserModel();
final RouteModel routeModel = RouteModel();
class Global {
  static bool get isRelease => const bool.fromEnvironment("dart.vm.product");
  static late SharedPreferences _prefs;
  static late BuildContext mainContext;
  static late SideMenu sideMenu;

  static Profile profile = Profile();
  static bool initMain = false;
  static const String mykey = 'cPdS+pz9B640l/4VxWuhzQ==';

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    // print(_profile);
    if (_profile != null) {
      profile = Profile.fromJson(jsonDecode(_profile));
    }
    List<MenuRoute> routes = getRoutes();
    sideMenu = SideMenu(
      routes: routes,
      currentRoute: routes.isNotEmpty ? routes[0] : MenuRoute(screen: Container()),
    );
    Request.init();
    if(kIsWeb == false) {
      await requestPhotosPermission();
    }else{
    }
    MinioUtil.init();
    Request.userInfo();
    // print(userModel.user);
  }

  static saveProfile() => _prefs.setString("profile", jsonEncode(profile.toJson()));
  static String encryptCode(String text){
    final key = XYQ.Key.fromUtf8(mykey);
    // final iv = XYQ.IV.fromUtf8(myiv);
    final iv = XYQ.IV.fromSecureRandom(128);
    final encrypter = XYQ.Encrypter(XYQ.AES(key, mode: XYQ.AESMode.ecb));
    final encrypted = encrypter.encrypt(text, iv: iv);
    // return '$mykey#${encrypted.base64}';
    return encrypted.base64;
  }
  static String decryptCode(String text){
    String? ikey;
    if(text.contains('#')) {
      ikey = text.substring(0, text.indexOf('#'));
      // print(ikey);
      text = text.substring(text.indexOf('#')+1);
      // print(text);
    }
    final encrypted = XYQ.Encrypted.fromBase64(text);
    final key = XYQ.Key.fromUtf8(ikey ?? mykey);
    // final iv = XYQ.IV.fromUtf8(myiv);
    final iv = XYQ.IV.fromSecureRandom(128);
    final encrypter = XYQ.Encrypter(XYQ.AES(key, mode: XYQ.AESMode.ecb));
    return encrypter.decrypt(encrypted, iv: iv);
  }
  static Future<String?> getPhoneLocalPath() async {
    // final directory = Theme.of(mainContext).platform == TargetPlatform.android
    //     ? await getExternalStorageDirectory()
    //     : await getApplicationDocumentsDirectory();
    if(Platform.isAndroid){
      final directory=await getExternalStorageDirectory();
      return directory?.path;
    }else if(Platform.isIOS){
      final directory=await getApplicationDocumentsDirectory();
      return directory.path;
    }
    return null;
  }

  static void showWebColoredToast(String msg) {
    print('Toast:$msg}');
  }
  static Future<bool> requestPhotosPermission() async {
    //获取当前的权限
    // var statusInternet = await Permission.interfaces.status;
    var statusPhotos = await Permission.photos.status;
    var statusCamera = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;
    print("Android photos Status: " + statusPhotos.toString());
    if(statusPhotos != PermissionStatus.granted){
      statusPhotos = await Permission.photos.request();
    }
    print("Android camera Status: " + statusCamera.toString());
    if(statusCamera != PermissionStatus.granted){
      statusCamera = await Permission.camera.request();
    }
    print("Android storage Status: " + storageStatus.toString());
    if(storageStatus != PermissionStatus.granted){
      storageStatus = await Permission.storage.request();
    }
    if (statusPhotos == PermissionStatus.granted && statusCamera == PermissionStatus.granted && storageStatus == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      return false;
    }
  }

  static String getDateTime(int date) {
    if(date > 9999999999){
      date = date ~/ 1000;
    }
    int t = ((DateTime.now().millisecondsSinceEpoch ~/ 1000) - date);
    String str = '';
    if (t > 60) {
      t = t ~/ 60;
      if (t > 60) {
        t = t ~/ 60;
        if (t > 24) {
          t = t ~/ 24;
          if (t > 30) {
            t = t ~/ 30;
            if (t > 12) {
              t = t ~/ 12;
              str = '$t年前';
            } else {
              str = '$t月前';
            }
          } else {
            str = '$t天前';
          }
        } else {
          str = '$t小时前';
        }
      } else {
        str = '$t分钟前';
      }
    } else {
      str = '$t秒前';
    }
    return str;
  }
  static String getYearsOld(int date) {

    String str = '';
    if (date> 0) {
      int t = DateTime.now().year - DateTime.fromMillisecondsSinceEpoch(date).year;
      str = '$t岁';
    } else {
      str = '0岁';
    }
    return str;
  }
  static String inSecondsTostring(int seconds) {
    var d = Duration(seconds:seconds);
    List<String> parts = d.toString().split('.');
    return parts[0];
  }
  static String getTimeToString(int t){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(t);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}';
  }
  static String getDateToString(int t){
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(t);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day}';
  }
  static String getNumbersToChinese(int n){
    if(n < 9999){
      return '$n';
    }else{
      double d= n / 10000;
      if(d < 9999){
        return '${d.toStringAsFixed(2)}万';
      }else{
        d= d / 10000;
        return '${d.toStringAsFixed(2)}亿';
      }
    }
  }
  static Future<Map<String, String>> getQueryString(String url)async{
    Map<String, String> map = <String, String>{};
    if(url.contains('?')){
      List<String> urls = url.split('?');
      if(urls.length > 1){
        url = urls[1];
        if(url.contains('&')){
          urls = url.split('&');
          for (int i =0;i< urls.length; i++){
            if(urls[i].contains('=')){
              List<String> temp = url.split('=');
              if(temp.length>1){
                map[temp[0]] = temp[1];
              }
            }
          }
        }else{
          List<String> temp = url.split('=');
          if(temp.length>1){
            map[temp[0]] = temp[1];
          }
        }
      }
    }
    return map;
  }
  static Size boundingTextSize(String text, TextStyle style, {int maxLines = 2 ^ 31, double maxWidth = double.infinity}) {
    if (text.isEmpty) {
      return Size.zero;
    }
    final TextPainter textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(text: text, style: style),
        maxLines: maxLines)
      ..layout(maxWidth: maxWidth);
    return textPainter.size;
  }
  static String generateMd5(String data) {
    var content = Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }
  static Future<double> loadApplicationCache() async {
    /// 获取文件夹
    Directory directory = await getApplicationDocumentsDirectory();

    /// 获取缓存大小
    double value = await getTotalSizeOfFilesInDir(directory);
    return value;
  }
  static Future<double> getTotalSizeOfFilesInDir(final FileSystemEntity file) async {
    if (file is File) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory) {
      final List<FileSystemEntity>? children = file.listSync();
      double total = 0;
      if (children != null)
        for (final FileSystemEntity child in children) {
          total += await getTotalSizeOfFilesInDir(child);
        }
      return total;
    }
    return 0;
  }
  static String formatSize(double? value) {
    if (null == value) {
      return '0';
    }
    List<String> unitArr = ['B', 'K', 'M', 'G'];
    int index = 0;
    while (value! > 1024) {
      index++;
      value = (value / 1024);
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
  static Future<void> clearApplicationCache() async {
    Directory directory = await getApplicationDocumentsDirectory();
    //删除缓存目录
    await deleteDirectory(directory);
  }
  static Future<void> deleteDirectory(FileSystemEntity file) async {
    if (file is Directory) {
      final List<FileSystemEntity> children = file.listSync();
      for (final FileSystemEntity child in children) {
        await deleteDirectory(child);
      }
    }
    await file.delete();
  }
}
class DialogRouter extends PageRouteBuilder{

  final Widget page;

  DialogRouter(this.page)
      : super(
    opaque: false,
    barrierColor: Colors.black54,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
  );
}
