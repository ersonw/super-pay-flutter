import 'package:admin/tools/CustomDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class MerchantInfoCard extends StatelessWidget {
  const MerchantInfoCard({
    Key? key,
    required this.title,
    required this.text,
  }) : super(key: key);

  final String title, text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$text',
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                  ),
                  Text(
                    '$title',
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
              onPressed: ()async{
                await Clipboard.setData(ClipboardData(text: text));
                CustomDialog.message("复制成功！");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Container(
                  margin: const EdgeInsets.only(left: 10,right: 10,bottom: 3),
                  child: Text('复制',style: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: Colors.white70),),
                ),
              ),
          ),
        ],
      ),
    );
  }
}
