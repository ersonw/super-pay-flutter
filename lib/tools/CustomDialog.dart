import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Global.dart';

typedef ClickCallbackBool = void Function(bool action);
class CustomDialog {
  static TextStyle style =TextStyle(color: Colors.black,fontSize: 25,fontStyle: FontStyle.normal, decoration: TextDecoration.none);
  static Future<void> message(String text,{String title = '提示信息', String cancel = '取消', String sure = '确认', ClickCallbackBool? callback, bool left = false, BuildContext? context})async{
    await showDialog<void>(
        context: context?? Global.mainContext,
        builder: (_context) {
          return Material(
            color: Colors.transparent,
            child: Container(
              child: Center(
                child: Container(
                  width: 450,
                  margin: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.orange,
                        Colors.deepOrangeAccent,
                        Colors.deepOrange,
                        Colors.red,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(top: 6,bottom: 6),
                            decoration: BoxDecoration(
                              border:
                              Border(bottom: BorderSide(color: Colors.black12, width: 2)),
                            ),
                            child: Text(title,style: style,softWrap: false,overflow: TextOverflow.ellipsis,),
                          ),
                          InkWell(onTap: ()=>Navigator.pop(_context), child: Icon(Icons.clear,size: 45,),)
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.all(15),
                        child: Text(text,style: style,softWrap: true,maxLines: 6,),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          callback!=null?
                          InkWell(
                            onTap: (){
                              Navigator.pop(_context);
                              callback(false);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 15,right: 15),
                              width: 400/2,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Center(
                                child: Text(cancel,style: style,),
                              ),
                            ),
                          ):Container(),
                          InkWell(
                            onTap: (){
                              Navigator.pop(_context);
                              if(callback != null) callback(true);
                            },
                            child: Container(
                              width: 400/2,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              child: Center(
                                child: Text(sure,style: style,),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 15)),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}