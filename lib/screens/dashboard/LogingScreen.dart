
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

class LogingScreen extends StatefulWidget {
  @override
  _LogingScreen createState()=>_LogingScreen();
}
class _LogingScreen extends State<LogingScreen> {
  List<Map<String, dynamic>> data = [];
  int total = 1;
  int page = 1;

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
    Map<String, dynamic> map = await Request.loging(page: page);
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
            Header(),
            SizedBox(height: defaultPadding),
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
                        title: '后台登录日志',
                        columns: {
                          'ip':'IP',
                          'addTime':'登录时间',
                          // 'updateTime':'更新时间',
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
}
