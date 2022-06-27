import 'dart:convert';

import 'package:admin/Global.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/my_fields.dart';
import 'package:admin/tools/Request.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/AdminDetails.dart';
import 'components/DashBox.dart';
import 'components/MerchantDetails.dart';
import 'components/RecentTable.dart';
import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreen createState()=>_DashboardScreen();
}
class _DashboardScreen extends State<DashboardScreen> {
  Map<String, dynamic> today = {};
  Map<String, dynamic> yesterday = {};
  @override
  void initState() {
    _getDays();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  _getDays()async{
    Map<String, dynamic> days = await Request.dayData();
    // print(days['yesterday']);
    // print(days['today']);
    if(days['yesterday'] != null) yesterday = jsonDecode(days['yesterday']);
    if(days['today'] != null) today = jsonDecode(days['today']);
    if(mounted) setState(() {});

  }
  _buildDayData(){
    List<Widget> tables = [];
    if(!today.isEmpty){
      tables.add(RecentTable(
        [
          today
        ],
        title: '今日订单数据',
      ));
      tables.add(SizedBox(height: defaultPadding));
    }
    if(!yesterday.isEmpty){
      tables.add(RecentTable(
        [
          yesterday
        ],
        title: '昨日订单数据',
      ));
      tables.add(SizedBox(height: defaultPadding));
    }
     return Column(
       mainAxisSize: MainAxisSize.min,
       children: tables,
     );
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
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
                      DashBox(),
                      SizedBox(height: defaultPadding),
                      _buildDayData(),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) userModel.user.admin?AdminDetails(): MerchantDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                // Padding(padding: EdgeInsets.only(bottom: ))
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 2,
                    child:  userModel.user.admin?AdminDetails():MerchantDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
