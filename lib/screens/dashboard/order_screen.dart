import 'dart:convert';

import 'package:admin/Global.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:admin/tools/CustomDialog.dart';
import 'package:admin/tools/Loading.dart';
import 'package:admin/tools/Request.dart';
import 'package:admin/tools/Tools.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/AdminDetails.dart';
import 'components/DashBox.dart';
import 'components/MerchantDetails.dart';
import 'components/RecentTable.dart';
import 'components/TableDetails.dart';
import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreen createState()=>_OrderScreen();
}
class _OrderScreen extends State<OrderScreen> {
  List<Map<String, dynamic>> data = [];
  Map<String, dynamic>? columns;
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
    if(map['columns'] != null) columns = map['columns'];
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
              Loading.show();
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
                        columns: columns??{
                          'id':'平台订单',
                          'outTradeNo':'商户订单号',
                          'type':'支付方式',
                          'money':'订单金额',
                          'totalFee':'实付金额',
                          'fee':'手续费',
                          'notifyState':'订单通知状态',
                          'tradeNo':'交易订单号',
                          'state':'订单交易状态',
                          'addTime':'创建时间',
                          'updateTime':'更新时间',
                        },
                        sequence: true,
                        title: '订单数据',
                        clear:clear,
                        onSelectChanged: userModel.isAdmin() == false?null: (List<int> value){
                        // onSelectChanged: (List<int> value){
                          selected = value;
                          clear = false;
                          if(mounted) setState(() {});
                        },
                        callback: _callback,
                      ),
                      SizedBox(height: defaultPadding),
                      buildPageButton(page,total,callback: (int value){
                        page = value;
                        Loading.show();
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
  _callback(int value)async{
    if(value < 0 || value >= data.length) return;
    String id = data[value]['id'];
    if(id == null || id.isEmpty) return;
    Loading.show();
    Map<String, dynamic> map = await Request.orderDetails(id);
    if(map!=null&&map.isNotEmpty){
      Map<String, dynamic> column = {};
      if(userModel.isAdmin()){
        column = {
          'Id':'平台订单',
          'OutTradeNo': '商户订单号' ,
          'ThirdParty':'三方渠道' ,
          'Type':'支付方式',
          'Money':'订单金额',
          'TotalFee':'实付金额',
          'Fee':'手续费',
          'NotifyState':'订单通知状态' ,
          'State':'订单交易状态',
          'TradeNo':'交易订单号' ,
          'Username':'商户',
          'ReturnUrl':'同步通知链接',
          'NotifyUrl':'异步通知链接',
          'AddTime':'创建时间',
          'UpdateTime':'更新时间',
        };
      }else{
        column = {
          'Id':'平台订单',
          'OutTradeNo': '商户订单号' ,
          'ThirdParty':'三方渠道' ,
          'Type':'支付方式',
          'Money':'订单金额',
          'TotalFee':'实付金额',
          'Fee':'手续费',
          'NotifyState':'订单通知状态' ,
          'State':'订单交易状态',
          'TradeNo':'交易订单号' ,
          'AddTime':'创建时间',
          'UpdateTime':'更新时间',
        };
      }
      Navigator.push(context, DialogRouter(TableDetails(
        map,
        title: '订单详情',
        column: column,
        footer: userModel.isAdmin()? Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              onTap: (){
                // Navigator.pop(context);
                selected = [value];
                _orderNotify();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 15,right: 15,bottom: 6,top: 6),
                  child: Text('异步通知'),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.pop(context);
                selected = [value];
                _orderDelete();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 15,right: 15,bottom: 6,top: 6),
                  child: Text('删除订单'),
                ),
              ),
            ),
          ],
        ):null,
      )));
    }
  }
  _orderNotify()async{
    if(selected.isEmpty) return;
    List<String> selectList = [];
    for(int i = 0; i < selected.length; i++){
      if(selected[i] < data.length){
        selectList.add(data[selected[i]]['id']);
      }
    }
    if(await Request.orderNotify(selectList) == true){
      _getData();
      clear = true;
      CustomDialog.message('通知成功!');
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
        selectList.add(data[selected[i]]['id']);
      }
    }
    if(await Request.orderDelete(selectList) == true){
      _getData();
      clear = true;
      CustomDialog.message('删除成功!');
    }else{
      CustomDialog.message('删除失败!');
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
