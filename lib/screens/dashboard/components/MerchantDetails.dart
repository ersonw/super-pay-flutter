import 'package:admin/tools/Request.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'MerchantInfoCard.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class MerchantDetails extends StatefulWidget {
  const MerchantDetails({
    Key? key,
  }) : super(key: key);
  @override
  _MerchantDetails createState() =>_MerchantDetails();
}
class _MerchantDetails extends State<MerchantDetails> {
  Map<String, dynamic> _map = {};
  @override
  void initState() {
    _getDetails();
    super.initState();
  }
  _getDetails()async{
    _map = await Request.merchantDetails();
    if(mounted) setState(() {});
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  _buildMerchantInfoCard(){
    List<Widget> list = [];
    if(_map.isNotEmpty){
      _map.forEach((key, value) {
        list.add(MerchantInfoCard(
          text: '$value',
          title: '$key',
        ));
      });
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: list,
    );
  }
  @override
  Widget build(BuildContext context) {
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
            "对接信息管理",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          _buildMerchantInfoCard(),
        ],
      ),
    );
  }
}
