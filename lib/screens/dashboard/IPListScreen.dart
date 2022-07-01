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
  final TextEditingController _controller = TextEditingController();
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
    Map<String, dynamic> map = await Request.ipList(page: page,id: text??'');
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(defaultPadding),
                  width: Responsive.isDesktop(context) ? MediaQuery.of(context).size.width / 3 : MediaQuery.of(context).size.width / 1.5,
                  child: Container(
                      margin: const EdgeInsets.all(15),
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: TextField(
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        controller: _controller,
                        autofocus: true,
                        // style: TextStyle(color: Colors.white38),
                        onSubmitted: (String text) {
                        },
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration:  InputDecoration(
                          hintText: '添加IP白名单地址',
                          hintStyle: const TextStyle(color: Colors.white30,fontSize: 13,fontWeight: FontWeight.bold),
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.only(top: 10,bottom: 10),
                          isDense: true,
                        ),
                      )
                  ),
                ),
                InkWell(
                  onTap: (){
                    _add();
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(top: 6,bottom: 6,left: 12,right: 12),
                      child: Text('添加'),
                    ),
                  ),
                ),
              ],
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
                        sequence: true,
                        title: '登录IP白名单',
                        clear:clear,
                        // onSelectChanged: userModel.isAdmin() == false?null: (List<int> value){
                          onSelectChanged: (List<int> value){
                          selected = value;
                          clear = false;
                          if(mounted) setState(() {});
                        },
                        columns: {
                          'address':'IP',
                          'addTime':'添加时间',
                          // 'updateTime':'更新时间',
                        },
                        callback: (value){

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
  _add()async{
    if(_controller.text.isNotEmpty){
      if(await Request.ipListAdd(_controller.text)){
        _getData();
        _controller.text = '';
        CustomDialog.message('添加成功!');
      }else{
        CustomDialog.message('添加失败!');
      }
    }
  }
  _delete()async{
    if(selected.isEmpty) return;
    List<String> selectList = [];
    for(int i = 0; i < selected.length; i++){
      if(selected[i] < data.length){
        selectList.add(data[selected[i]]['id']);
      }
    }
    if(await Request.ipListDel(selectList) == true){
      _getData();
      clear = true;
      CustomDialog.message('批量删除成功!');
    }else{
      CustomDialog.message('批量删除失败!');
    }
    if(mounted) setState(() {});

  }
  _clear()async{
    if(await Request.ipListClear() == true){
      _getData();
      CustomDialog.message('清除成功!');
    }
  }
  _buildSelectButton(){
    List<Widget> list = [];
    if(selected.isNotEmpty){
      list.add(TextButton(onPressed: (){
        _delete();
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
    }
    list.add(TextButton(onPressed: _clear, child: Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 12,right: 12,top: 6,bottom: 6),
        child: Text('清空所有',style: TextStyle(color: Colors.white),),
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
