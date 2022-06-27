import 'dart:convert';

import 'package:admin/Global.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:admin/tools/CustomDialog.dart';
import 'package:admin/tools/Request.dart';
import 'package:admin/tools/Tools.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/AdminDetails.dart';
import 'components/DashBox.dart';
import 'components/MerchantDetails.dart';
import 'components/RecentTable.dart';
import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';

class IPListScreen extends StatefulWidget {
  @override
  _IPListScreen createState()=>_IPListScreen();
}
class _IPListScreen extends State<IPListScreen> {
  List<Map<String, dynamic>> data = [];
  int total = 1;
  int page = 1;
  String? text;

  List<int> selected =[];
  bool clear = false;
  @override
  void initState() {
    _getData();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  _getData()async{
    if(page>total){
      page--;
      return;
    }
    Map<String, dynamic> map = await Request.orders(page: page,id: text??'');
    if(map['total'] != null) total = map['total'];
    if(map['list'] != null) data = (map['list'] as List).map((e) => (e as Map<String,dynamic>)).toList();
    if(mounted) setState(() {});

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(callback: (value){
              text = value;
              _getData();
            },
              text: text,
            ),
            SizedBox(height: defaultPadding),
            _buildSelectButton(),
            // SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(height: defaultPadding),
                      data.isEmpty?Container():RecentTable(
                        data,
                        title: '订单数据',
                        clear:clear,
                        onSelectChanged: userModel.isAdmin() == false?null: (List<int> value){
                          // onSelectChanged: (List<int> value){
                          selected = value;
                          clear = false;
                          if(mounted) setState(() {});
                        },
                      ),
                      SizedBox(height: defaultPadding),
                      buildPageButton(page,total,callback: (int value){
                        page = value;
                        _getData();
                      }),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  _orderNotify()async{
    if(selected.isEmpty) return;
    List<String> selectList = [];
    for(int i = 0; i < selected.length; i++){
      if(selected[i] < data.length){
        selectList.add(data[selected[i]]['ID']);
      }
    }
    if(await Request.orderNotify(selectList) == true){
      _getData();
      clear = true;
      CustomDialog.message('批量通知成功!');
    }else{
      CustomDialog.message('通知失败!');
    }
    if(mounted) setState(() {});

  }
  _orderDelete()async{
    if(selected.isEmpty) return;
    List<String> selectList = [];
    for(int i = 0; i < selected.length; i++){
      if(selected[i] < data.length){
        selectList.add(data[selected[i]]['ID']);
      }
    }
    if(await Request.orderDelete(selectList) == true){
      _getData();
      clear = true;
      CustomDialog.message('批量删除成功!');
    }else{
      CustomDialog.message('批量删除!');
    }
    if(mounted) setState(() {});

  }
  _buildSelectButton(){
    if(selected.isEmpty) return Container();
    List<Widget> list = [];
    list.add(TextButton(onPressed: (){
      _orderDelete();
    }, child: Container(
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 12,right: 12,top: 6,bottom: 6),
        child: Text('批量删除(${selected.length}项)',style: TextStyle(color: Colors.white),),
      ),
    )));
    list.add(SizedBox(width: defaultPadding));
    list.add(TextButton(onPressed: _orderNotify, child: Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 12,right: 12,top: 6,bottom: 6),
        child: Text('批量通知(${selected.length}项)',style: TextStyle(color: Colors.white),),
      ),
    )));
    list.add(SizedBox(width: defaultPadding));

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }
}
