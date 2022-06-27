import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AssetsIcon.dart';
import '../AssetsImage.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Global.dart';
import '../constants.dart';

buildButton(String title, {bool active=false, void Function()? callback}){
  return InkWell(
    onTap: (){
      if(callback != null) callback();
    },
    child: Container(
      child: Container(
        child: Text(title,style: active? TextStyle(color: Colors.white,fontSize: 25):TextStyle(color: Colors.white.withOpacity(0.6)),),
      ),
    ),
  );
}
buildPageButton(int page, int total,{void Function(int value)? callback}){
  if(page==1 && total == 1) return Container();
  List<Widget> list = [];
  if(page>1){
    if(page > 2){
      list.add(buildButton('首页',callback: () {
        page=1;
        if(callback != null) callback(page);
      }));
      list.add(SizedBox(width: defaultPadding));
    }
    list.add(buildButton('上一页',callback: () {
      if(page-1 > 1){
        page--;
      }else{
        page=1;
      }
      if(callback != null) callback(page);
    }));
    list.add(SizedBox(width: defaultPadding));
    if(page > 3){
      list.add(buildButton('${page-2}',callback: () {
        page=page-2;
        if(callback != null) callback(page);
      }));
      list.add(SizedBox(width: defaultPadding));
    }
    if(page > 2){
      list.add(buildButton('${page-1}',callback: () {
        page--;
        if(callback != null) callback(page);
      }));
      list.add(SizedBox(width: defaultPadding));
    }
  }
  for(int i=page;i<page+3;i++){
    // print(i);
    if(i < total){
      list.add(buildButton('$i',active: page == i,callback: () {
        page=i;
        if(callback != null) callback(page);
      }));
      list.add(SizedBox(width: defaultPadding));
    }
  }
  if(total > page){
    list.add(buildButton('$total',callback: () {
      page=total;
      if(callback != null) callback(page);
    }));
    list.add(SizedBox(width: defaultPadding));
  }else if(total == page){
    list.add(buildButton('$total',active: true,callback: () {
      page=total;
      if(callback != null) callback(page);
    }));
    list.add(SizedBox(width: defaultPadding));
  }
  if(page<total){
    list.add(buildButton('下一页',callback: () {
      if(page+1 < total){
        page++;
      }else{
        page=total;
      }
      if(callback != null) callback(page);
    }));
    list.add(SizedBox(width: defaultPadding));
  }
  return Row(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.start,
    children: list,
  );
}
buildHeaderPicture({String? avatar, bool self = false}){
  if(self){
    return buildHeaderPicture(avatar: userModel.user.avatar);
  }else{
    if(avatar == null){
      return AssetsImage.defaultAvatar;
    }else{
      return NetworkImage(avatar);
    }
  }
}
int expansionText(String text,
    {TextStyle? style, double? maxWidth, double? minWidth}){
  int nMaxLines = 1;
  while(isExpansionText(text, style: style, maxWidth: maxWidth, minWidth: minWidth, nMaxLines: nMaxLines) == true){
    nMaxLines++;
  }
  return nMaxLines;
}
bool isExpansionText(String text,{
  int nMaxLines = 1,
  TextStyle? style,
  double? maxWidth,
  double? minWidth}) {
  TextPainter _textPainter = TextPainter(
      maxLines: nMaxLines,
      text: TextSpan(
          text: text, style: style ?? TextStyle(color: Colors.white.withOpacity(0.5))),
      textDirection: TextDirection.ltr)
    ..layout(maxWidth: maxWidth ?? (MediaQuery.of(Global.mainContext).size.width / 1.2), minWidth: minWidth ?? (MediaQuery.of(Global.mainContext).size.width / 2));
  // print(_textPainter.didExceedMaxLines);
  if (_textPainter.didExceedMaxLines) {//判断 文本是否需要截断
    return true;
  } else {
    return false;
  }
}
/**
 * 向上弹出
 */
_showPopWindow() {
  showModalBottomSheet<String>(
      context: Global.mainContext,
      isDismissible: true, //设置点击弹窗外边是否关闭页面
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          // padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(30)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text("Camera"),
                    Icon(Icons.done),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text("Camera"),
                    Icon(Icons.done),
                  ],
                ),
              ),
            ],
          ),
        );
      }).then((value) => print('showModalBottomSheet $value'));
}
buildLevel({int level = 0, bool self = false}){

}
