import 'dart:convert';

import 'package:admin/data/DashBoxInfo.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../data/User.dart';
import '../tools/CustomDialog.dart';
import '../tools/RequestApi.dart';
import '../Global.dart';
import 'Loading.dart';
import 'MinioUtil.dart';
import 'RouteUtil.dart';
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
    if(kIsWeb && Global.isRelease){
      return "";
    }
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
      // connectTimeout: 3000,
      receiveTimeout: 30000,
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
        // responseType: ResponseType.json,
        // receiveDataWhenStatusError: false,
        // receiveTimeout: 30000,
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
          "Content-Type": "application/json",
          'Token': userModel.hasToken() ? userModel.user.token : '',
        },
        // responseType: ResponseType.json,
        // receiveDataWhenStatusError: false,
        // receiveTimeout: 30000,
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
    RouteUtil.load();
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
  static Future<bool> userPassword(String oldValue, String newValue)async{
    Loading.show();
    Map<String, dynamic> data = {
      "oldValue": Global.generateMd5(oldValue),
      "newValue": Global.generateMd5(newValue),
    };
    String? result = await _post(RequestApi.userPassword, data);
    if(result ==null || jsonDecode(result)['state'] == null || jsonDecode(result)['state'] == false) return false;
    return true;
  }
  static Future<List<DashBoxInfo>> dashboard()async{
    // Loading.show();
    String? result = await _get(RequestApi.dashboard, {});
    if(result==null){
      return [];
    }
    // print(result);
    return (jsonDecode(result)['list'] as List).map((e) => DashBoxInfo.fromJson(e)).toList();
  }
  static Future<Map<String, dynamic>> dayData()async{
    // Loading.show();
    String? result = await _get(RequestApi.dayData, {});
    // print(result);
    // List<Map<String, String>> e = (jsonDecode(result)['list'] as List<Map<String, String>>);
    if(result==null) return {};
    return jsonDecode(result);
  }
  static Future<Map<String, dynamic>> userDetails()async{
    // Loading.show();
    String? result = await _get(RequestApi.userDetails, {});
    // print(result);
    if(result==null) return {};
    return jsonDecode(result);
  }
  static Future<bool> userDetailsChange(String callbackUrl, String notifyUrl)async{
    Loading.show();
    Map<String, dynamic> data = {
      "callbackUrl": callbackUrl,
      "notifyUrl": notifyUrl,
    };
    String? result = await _post(RequestApi.userDetailsChange, data);
    if(result ==null || jsonDecode(result)['state'] == null || jsonDecode(result)['state'] == false) return false;
    return true;
  }
  static Future<Map<String, dynamic>> merchantDetails()async{
    // Loading.show();
    String? result = await _get(RequestApi.merchantDetails, {});
    // print(result);
    if(result==null) return {};
    return jsonDecode(result);
  }
  static Future<Map<String, dynamic>> orders({int page=0, String id=''})async{
    String uri = '/$page';
    if(id != null && id.isNotEmpty){
      uri += '/$id';
      // Loading.show();
    }
    String? result = await _get(RequestApi.orders+uri, {});
    // print(result);
    if(result==null) return {};
    return jsonDecode(result);
  }
  static Future<Map<String, dynamic>> loging({int page=0})async{
    String? result = await _get(RequestApi.loging+'/$page', {});
    // print(result);
    if(result==null) return {};
    return jsonDecode(result);
  }
  static Future<Map<String, dynamic>> ipList({int page=0, String id=''})async{
    String uri = '/$page';
    if(id != null && id.isNotEmpty){
      uri += '/$id';
      // Loading.show();
    }
    String? result = await _get(RequestApi.ipList+uri, {});
    // print(result);
    if(result==null) return {};
    return jsonDecode(result);
  }
  static Future<bool> ipListAdd(String address)async{
    Loading.show();
    String? result = await _get(RequestApi.ipListAdd, { 'address': address });
    // print(result);
    if(result==null|| jsonDecode(result)['add'] == null || jsonDecode(result)['add'] == false) return false;
    return true;
  }
  static Future<bool> ipListDel(List<String> selected)async{
    Loading.show();
    Map<String, dynamic> data = {
      "selected": selected,
    };
    String? result = await _post(RequestApi.ipListDel, data);
    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['state'] != null) {
        return map['state'];
      }
    }
    return false;
  }
  static Future<bool> ipListClear()async{
    Loading.show();
    String? result = await _get(RequestApi.ipListClear, {});
    // print(result);
    if(result==null|| jsonDecode(result)['clear'] == null || jsonDecode(result)['clear'] == false) return false;
    return true;
  }
  static Future<Map<String, dynamic>> orderDetails(String id)async{
    String? result = await _get(RequestApi.orderDetails.replaceAll('{id}', id), {});
    // print(result);
    if(result==null) return {};
    return jsonDecode(result);
  }
  static Future<bool> orderNotify(List<String> selected)async{
    Loading.show();
    Map<String, dynamic> data = {
      "selected": selected,
    };
    String? result = await _post(RequestApi.orderNotify, data);
    if(result!=null){
      // print(result);
      Map<String, dynamic> map = jsonDecode(result);
      if(map['state'] != null) {
        return map['state'];
      }
    }
    return false;
  }
  static Future<bool> orderDelete(List<String> selected)async{
    Loading.show();
    Map<String, dynamic> data = {
      "selected": selected,
    };
    String? result = await _post(RequestApi.orderDelete, data);
    if(result!=null){
      Map<String, dynamic> map = jsonDecode(result);
      if(map['state'] != null) {
        return map['state'];
      }
    }
    return false;
  }

}
