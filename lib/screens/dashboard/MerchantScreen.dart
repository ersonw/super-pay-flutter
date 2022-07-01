import 'package:admin/constants.dart';
import 'package:admin/tools/CustomDialog.dart';
import 'package:admin/tools/Request.dart';
import 'package:admin/tools/Tools.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../responsive.dart';

class MerchantScreen extends StatefulWidget {
  @override
  _MerchantScreen createState() =>_MerchantScreen();
}
class _MerchantScreen extends State<MerchantScreen>{
  TextEditingController CallbackUrl = TextEditingController();
  TextEditingController NotifyUrl = TextEditingController();
  Map<String, dynamic> _map = {};
  @override
  void initState() {
    _getDetails();
    super.initState();
  }
  _getDetails()async{
    _map = await Request.userDetails();
    if(mounted) setState(() {});
  }
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
                Container(
                  margin: EdgeInsets.all( defaultPadding),
                  child: Text('对接信息'),
                ),
                buildCopyColum('商户ID', _map['Pid']),
                buildCopyColum('商户秘钥', _map['SecretKey']),
                buildCopyColum('对接文档', _map['Documentation']),
                buildCopyColum('易支付接口', _map['EPayUrl']),
                buildInput(
                  context,
                  CallbackUrl,
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  hintText: '默认同步回调地址',
                  text: _map['CallbackUrl'],
                  // width: Responsive.isDesktop(context)? MediaQuery.of(context).size.width /3:MediaQuery.of(context).size.width,
                ),
                buildInput(
                  context,
                  NotifyUrl,
                  maxLines: 3,
                  textAlign: TextAlign.left,
                  hintText: '默认异步回调地址',
                  text: _map['NotifyUrl'],
                  // width: Responsive.isDesktop(context)? MediaQuery.of(context).size.width /3:MediaQuery.of(context).size.width,
                ),
                SizedBox(height: defaultPadding),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: (){
                        _change(context);
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
  _change(BuildContext context)async{
    if(await Request.userDetailsChange(CallbackUrl.text, NotifyUrl.text)){
      Navigator.pop(context);
      return CustomDialog.message('修改成功!');
    }
  }
}
