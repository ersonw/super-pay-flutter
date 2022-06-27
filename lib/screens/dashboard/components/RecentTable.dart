import 'package:admin/models/RecentFile.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class RecentTable extends StatefulWidget {
  String? title;
  List<Map<String, dynamic>> data;
  void Function(Map<String, dynamic> row)? callback;
  void Function(List<int> index)? onSelectChanged;
  bool clear;
  RecentTable(this.data,{
    this.title,
    this.callback,
    this.onSelectChanged,
    this.clear =false,
    Key? key,
  }) : super(key: key);
  @override
  _RecentTable createState() =>_RecentTable();
}
class _RecentTable extends State<RecentTable> {
  List<bool> selected = [];
  List<String> column = [];
  @override
  void initState() {
    if(widget.data.isNotEmpty) {
      column = widget.data[widget.data.length-1].keys.toList();
    }
    // print(column);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  _buildColumns(){
    List<DataColumn> columns = [];
    for(int i=0;i < widget.data.length;i++){
      if(selected.length < i+1){
        selected.add(false);
      }
    }
    column.sort((a, b) => a.length.compareTo(b.length));
    // print(column);
    for(int i = 0; i < column.length; i++){
        columns.add(
            DataColumn(
              label: Text('${column[i]}',softWrap: true,maxLines: 3,overflow: TextOverflow.fade,),
            ));
    }
    return columns;
  }
  @override
  Widget build(BuildContext context) {
    if(widget.clear){
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
            "${widget.title ?? ''}",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable2(
              columnSpacing: defaultPadding,
              minWidth: 600,
              columns: _buildColumns(),
              rows: List.generate(
                widget.data.length,
                    (index) => recentTableDataRow(index),
              ),
            ),
          ),
        ],
      ),
    );
  }
  DataRow recentTableDataRow(int index) {
    Map<String, dynamic> row = widget.data[index];
    List<DataCell> calls = [];
    for (int i = 0; i < column.length; i++) {
      calls.add(DataCell(
        Text('${row[column[i]]}'),
        // onTap: (){
        // if(widget.callback != null) widget.callback!(row);
        // },
      ));
    }
    return DataRow(
      onLongPress: widget.callback == null?null:(){
        if(widget.callback != null) widget.callback!(row);
      },
      selected: selected[index],
      onSelectChanged: widget.onSelectChanged==null?null:(bool? e){
        if(e != null)selected[index] = e;
        List<int> selects = [];
        for(int i=0; i<selected.length; i++) {
          if(selected[i] == true){
            selects.add(i);
          }
        }
        widget.onSelectChanged!(selects);
        if(mounted) setState(() {});
      },
      cells: calls,
    );
  }
}


