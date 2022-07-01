import 'package:admin/tools/CustomDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';
import '../../../responsive.dart';
import 'MerchantInfoCard.dart';

class TableDetails extends StatelessWidget {
  Map<String, dynamic> table;
  Map<String, dynamic>? column;
  String? title;
  Widget? footer;
  TableDetails(this.table,{Key? key,this.title,this.footer,this.column}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          GestureDetector(
            onDoubleTap: (){
              Navigator.pop(context);
            },
            onTap: (){
              Navigator.pop(context);
            },
          ),
          if (Responsive.isDesktop(context))
          SizedBox(
            width: MediaQuery.of(context).size.width /2,
            child:  _dialog(context),
          ) else
          // if (Responsive.isMobile(context))
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child:  _dialog(context),
            ),
        ],
      ),
    );
  }
  _dialog(BuildContext context){
    return Container(
      color: bgColor,
      padding: EdgeInsets.all(defaultPadding),
      // alignment: Alignment.topLeft,
      child:  ListView(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.dangerous_outlined,size: 45,color: Colors.red,)
              ),
            ],
          ),
          SizedBox(height: defaultPadding),
          Text(
            title??"详情",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          _buildMerchantInfoCard(context),
          SizedBox(height: defaultPadding),
          footer??Container(),
          SizedBox(height: defaultPadding),
        ],
      ),
    );
  }
  _buildMerchantInfoCard(BuildContext context){
    List<Widget> list = [];
    if(table.isNotEmpty){
      if(column == null){
        column = {};
        List<String> keys = table.keys.toList();
        keys.sort((a, b) => a.length.compareTo(b.length));
        for(String key in keys){
          column![key] = key;
        }
      }
      column?.forEach((key, value) {
        list.add(Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(color: Colors.white.withOpacity(0.6))
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$value',
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrangeAccent),
                      ),
                      TextButton(
                        onLongPress: ()async{
                          await Clipboard.setData(ClipboardData(text: value));
                          CustomDialog.message("复制成功！");
                        },
                        onPressed: () {  },
                        child: Text(
                          '${table[key]}',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
      });
    }
    // print(column);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }
}
