import 'package:admin/constants.dart';
import 'package:admin/tools/CustomDialog.dart';
import 'package:admin/tools/Request.dart';
import 'package:admin/tools/Tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../responsive.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreen createState() =>_PasswordScreen();
}
class _PasswordScreen extends State<PasswordScreen>{
  TextEditingController _controllerOld = TextEditingController();
  TextEditingController _controllerNew = TextEditingController();
  TextEditingController _controllerComfirm = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onDoubleTap: (){
              Navigator.pop(context);
            },
            onTap: (){
              Navigator.pop(context);
            },
          ),
          _dialog(context),
        ],
      ),
    );
  }
  _dialog(BuildContext context){
    return Center(
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            width: Responsive.isDesktop(context)? MediaQuery.of(context).size.width /3:MediaQuery.of(context).size.width,
            height: Responsive.isDesktop(context)? null:MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SizedBox(height: defaultPadding),
                SizedBox(height: defaultPadding),
                buildInput(
                  context,
                  _controllerOld,
                  hintText: '输入原密码',
                  show: false,
                ),
                buildInput(
                  context,
                  _controllerNew,
                  hintText: '输入新密码',
                  show: false,
                ),
                buildInput(
                  context,
                  _controllerComfirm,
                  hintText: '再次输入密码',
                  show: false,
                ),
                SizedBox(height: defaultPadding),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: (){
                        _changePassword(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(left: 12,right: 12,bottom: 6,top: 6),
                          child: Text('确定修改'),
                        ),
                      ),
                    ),
                    SizedBox(width: defaultPadding),
                    InkWell(
                      onTap: ()=>Navigator.pop(context),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Container(
                          margin: const EdgeInsets.only(left: 12,right: 12,bottom: 6,top: 6),
                          child: Text('取消修改'),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: defaultPadding),
              ],
            ),
          ),
        ],
      ),
    );
  }
  _changePassword(BuildContext context)async{
    if(_controllerOld.text.isEmpty) return CustomDialog.message('原密码不能为空！');
    if(_controllerNew.text.isEmpty) return CustomDialog.message('新密码不能为空！');
    if(_controllerComfirm.text.isEmpty) return CustomDialog.message('确认密码不能为空！');
    if(_controllerNew.text != _controllerComfirm.text) return CustomDialog.message('两次密码不一致，请仔细核对！');
    if(_controllerOld.text == _controllerComfirm.text) return CustomDialog.message('旧密码与新密码一致！');
    if(await Request.userPassword(_controllerOld.text, _controllerComfirm.text) == true){
      Navigator.pop(context);
      return CustomDialog.message('密码修改成功!');
    }
    // CustomDialog.message('密码修改失败!');
    _controllerOld.text = '';
  }
}
