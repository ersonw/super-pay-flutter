import 'dart:convert';

import 'package:dio/dio.dart';
import '../data/User.dart';
import '../tools/CustomDialog.dart';
import '../tools/RequestApi.dart';
import '../Global.dart';
import 'Loading.dart';
import 'MinioUtil.dart';
class Request {
  static late Dio _dio;
  static init() {
    // print(_getDomain());
    _dio = Dio(_getOptions());
    configModel.addListener(() {
      _dio.options.baseUrl = _getDomain();
    });
    userModel.addListener(() {
      _dio.options.headers['Token'] = userModel.hasToken() ? userModel.user.token : '';
    });
  }
  static _getDomain(){
    String domain = configModel.config.mainDomain;
    if(!domain.startsWith("http")){
      domain = 'http://$domain';
    }
    return domain;
  }
  static _getOptions(){
    /// 自定义Header
    Map<String, dynamic> httpHeaders = {
      'Token': userModel.hasToken() ? userModel.user.token : '',
    };
    return BaseOptions(
      baseUrl: _getDomain(),
      headers: httpHeaders,
      // contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      receiveDataWhenStatusError: false,
      connectTimeout: 30000,
      receiveTimeout: 3000,
    );
  }

  static Future<String?> _get(String path,Map<String, dynamic> params)async{
    // if(Global.initMain == true) Loading.show(Global.mainContext);
    try{
      Response response = await _dio.get(path,queryParameters: params, options: Options(
        headers: {
          'Token': userModel.hasToken() ? userModel.user.token : '',
          "Content-Type": "application/x-www-form-urlencoded",
        },
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        receiveTimeout: 30000,
      ));
      Loading.dismiss();
      if(response.statusCode == 200 && response.data != null){
        // print(response.data);
        Map<String, dynamic> data = response.data;
        if(data['message'] != null) CustomDialog.message(data['message']);
        if(data['code'] == 200 && data['data'] != null){
          return Global.decryptCode(data['data']);
        }
      }
    } on DioError catch(e) {
      Loading.dismiss();
      print(e.message);
    }
  }
  static Future<String?> _post(String path,Map<String, dynamic> data)async{
    try{
      Response response = await _dio.post(path,data: Global.encryptCode(jsonEncode(data)), options: Options(
      // Response response = await _dio.post(path,data: data, options: Options(
        headers: {
          // "Content-Type": "application/json",
          'Token': userModel.hasToken() ? userModel.user.token : '',
        },
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        receiveTimeout: 30000,
      ));
      Loading.dismiss();
      if(response.statusCode == 200 && response.data != null){
        Map<String, dynamic> data = response.data;
        // print(data);
        if(data['message'] != null) CustomDialog.message(data['message']);
        if(data['code'] == 200 && data['data'] != null){
          return Global.decryptCode(data['data']);
        }
      }
    } on DioError catch(e) {
      Loading.dismiss();
      print(e.message);
    }
  }
  static Future<void> userInfo()async{
    if(userModel.hasToken() == false) return;
    String? result = await _get(RequestApi.userInfo, {});
    if(result==null){
      userModel.setToken('');
      return;
    }
    userModel.user = User.formJson(jsonDecode(result));
  }
  static Future<void> userLogout()async{
    await _get(RequestApi.userLogout, {});
    userModel.setToken('');
  }
  static Future<bool> userLogin(String username, String password)async{
    Loading.show();
    Map<String, dynamic> data = {
      "username": username,
      "password": Global.generateMd5(password),
    };
    String? result = await _post(RequestApi.userLogin, data);
    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['token'] != null) {
        userModel.setToken(map['token']);
        userInfo();
        return true;
      }
    }
    return false;
  }
}
