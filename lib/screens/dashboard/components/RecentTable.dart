import 'package:admin/models/RecentFile.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class RecentTable extends StatelessWidget {
  String? title;
  List<Map<String, dynamic>> data;
  Map<String, dynamic>? columns;
  void Function(int value)? callback;
  void Function(List<int> index)? onSelectChanged;
  bool sequence;
  bool clear;
  RecentTable(this.data,{
    this.title,
    this.callback,
    this.onSelectChanged,
    this.clear =false,
    this.sequence = false,
    this.columns,
    Key? key,
  }) : super(key: key);
  List<bool> selected = [];
  int? select;
  Map<String, dynamic> column = {};
  _getColumn(){
    for(int i = selected.length-1; i < data.length; i++) {
      selected.add(false);
    }
    if(sequence){
      column['index'] = '#';
    }
    if(columns != null){
      column.addAll(columns!);
    }else if(data.isNotEmpty){
      List<String> keys = data[0].keys.toList();
      keys.sort((a, b) => a.length.compareTo(b.length));
      for(String key in keys){
        column[key] = key;
      }
    }
  }
  _buildColumns(){
    List<DataColumn> columns = [];
    column.forEach((key, value) {
      columns.add(
          DataColumn(
            label: Text('$value',softWrap: true,maxLines: 3,overflow: TextOverflow.fade,),
          ));
    });
    return columns;
  }
  @override
  Widget build(BuildContext context) {
    _getColumn();
    if(clear){
      for(int i = 0; i < selected.length; i++) {
        selected[i]=false;
      }
    }
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${title ?? ''}",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable2(
              columnSpacing: defaultPadding,
              minWidth: 600,
              columns: _buildColumns(),
              rows: _buildRows(),
            ),
          ),
        ],
      ),
    );
  }
  List<DataRow> _buildRows(){
    List<DataRow> rows = [];
    for(int i = 0; i < data.length; i++) {
      rows.add(recentTableDataRow(data[i],i));
    }
    return rows;
  }
  DataRow recentTableDataRow(Map<String, dynamic> row,int index) {
    // Map<String, dynamic> row = widget.data[index];
    List<DataCell> calls = [];
    column.forEach((key, value) {
      // print('$key == ${row[value]}');
      if(key == 'index'){
        calls.add(DataCell(
          Text('${index+1}'),
            // onTap: widget.callback == null?null:(){
            //   if(widget.callback != null) widget.callback!(index);
            //   select=index;
            //   if(mounted) setState(() {});
            // }
        ));
      } else{
        calls.add(DataCell(
          Text('${row[key]}'),
          onTap: callback == null?null:(){
            if(callback != null) callback!(index);
            select=index;
          }
        ));
      }
    });
    return DataRow(
      color: select==null?null: (select==index?MaterialStateProperty.all(Colors.white.withOpacity(0.3)):null),
      selected: selected[index],
      onSelectChanged: onSelectChanged==null?null:(bool? e){
        select=index;
        if(e != null)selected[index] = e;
        List<int> selects = [];
        for(int i=0; i<selected.length; i++) {
          if(selected[i] == true){
            selects.add(i);
          }
        }
        onSelectChanged!(selects);
      },
      cells: calls,
    );
  }
}


