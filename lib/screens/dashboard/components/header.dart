import 'package:admin/Global.dart';
import 'package:admin/controllers/MenuController.dart';
import 'package:admin/data/User.dart';
import 'package:admin/data/Word.dart';
import 'package:admin/responsive.dart';
import 'package:admin/tools/Request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class Header extends StatefulWidget {
  const Header({
    Key? key,
  }) :super(key: key);

  @override
  _Header createState() => _Header();
}
class _Header extends State<Header> {
  User _user = userModel.user;
  @override
  void initState() {
    userModel.addListener(() {
      _user = userModel.user;
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: context.read<MenuController>().controlMenu,
          ),
        if (!Responsive.isMobile(context))
          Text(
            routeModel.currentRoute.title??'',
            style: Theme.of(context).textTheme.headline6,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        // Expanded(child: SearchField()),
        ProfileCard(_user),
      ],
    );
  }
}

class ProfileCard extends StatelessWidget {
  User user;
  List<Word> _list = [
    Word(words: "修改密码"),
    Word(id: 1,words: "退出用户"),
  ];
  ProfileCard(this.user,{
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: defaultPadding),
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: defaultPadding / 2,
      ),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Image.asset(
            user.avatar??"assets/images/profile_pic.png",
            height: 38,
          ),
          if (!Responsive.isMobile(context))
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              child: Text(user.username??"未知用户"),
            ),
          // Icon(Icons.keyboard_arrow_down),
          _buildDropdown(_list,callback: _handlerDropdown),
        ],
      ),
    );
  }
  _handlerDropdown(Word word){
    switch(word.id){
      case 0:
        print("修改密码");
        break;
      case 1:
        Request.userLogout();
        break;
    }
  }
  _buildDropdown(List<Word> list,{void Function(Word word)? callback}){
    return PopupMenuButton<Word>(
      itemBuilder: (BuildContext _context){
        // PopupMenuEntry<String> entry =
        return list.map<PopupMenuEntry<Word>>((model) {
          return PopupMenuItem<Word>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Icon(model.icon),
                // const SizedBox(
                //   width: 4,
                // ),
                Text(
                  model.words,
                )
              ],
            ),
            value: model,
          );
        }).toList();
      },
      onSelected: (Word value) {
        if(callback != null){
          callback(value);
        }
      },
      icon: Icon(Icons.arrow_drop_down_outlined,
        // color: Colors.white,
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}
