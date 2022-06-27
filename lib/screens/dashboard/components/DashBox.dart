import 'package:admin/data/DashBoxInfo.dart';
import 'package:admin/models/MyFiles.dart';
import 'package:admin/responsive.dart';
import 'package:admin/tools/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';
import 'DashInfo.dart';
import 'file_info_card.dart';

class DashBox extends StatelessWidget {
  const DashBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "My Files",
        //       style: Theme.of(context).textTheme.subtitle1,
        //     ),
        //     ElevatedButton.icon(
        //       style: TextButton.styleFrom(
        //         padding: EdgeInsets.symmetric(
        //           horizontal: defaultPadding * 1.5,
        //           vertical:
        //           defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
        //         ),
        //       ),
        //       onPressed: () {},
        //       icon: Icon(Icons.add),
        //       label: Text("Add New"),
        //     ),
        //   ],
        // ),
        // SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatefulWidget {
  final int crossAxisCount;
  final double childAspectRatio;
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);
  @override
  _FileInfoCardGridView createState() =>_FileInfoCardGridView();

}
class _FileInfoCardGridView extends State<FileInfoCardGridView> {
  List<DashBoxInfo> infos = [];
  @override
  void initState() {
    // infos = [
    //   DashBoxInfo(
    //       svgSrc: SvgPicture.asset(
    //         "assets/icons/moneybg.svg",
    //         color: Colors.blue,),
    //       title: '今日收款',
    //       context: '9999.00元',
    //       bottomLeft: '昨日收款',
    //       bottomRight: '10000.00元',
    //       percentage: 10),
    // ];
    _buildBoxInfo();
    super.initState();
  }
  _buildBoxInfo()async{
    infos = await Request.dashboard();
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: infos.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) => DashInfo(info: infos[index]),
    );
  }
}
