import 'package:admin/tools/CustomDialog.dart';
import 'package:admin/tools/Request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget{
  @override
  _LoginScreen createState() =>_LoginScreen();
}
class _LoginScreen extends State<LoginScreen>{
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool eyes = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: const Color(0xff181921),
      body: Center(child: Container(
        margin: const EdgeInsets.all(30),
        // width: ((MediaQuery.of(context).size.width) / 1),
        // alignment: Alignment.center,
        width: 500,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white.withOpacity(0.6), // 底色
          boxShadow: [
            BoxShadow(
              blurRadius: 10, //阴影范围
              spreadRadius: 0.1, //阴影浓度
              color: Colors.grey.withOpacity(0.2), //阴影颜色
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top:10,bottom: 20),
                  child: const Text('后台登录', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ),
                Container(
                  height: 45,
                  // width: ((MediaQuery.of(context).size.width) / 1.6),
                  margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
                  decoration: const BoxDecoration(
                    border:
                    Border(bottom: BorderSide(color: Colors.black12, width: 2)),
                  ),
                  child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: usernameController,
                            // style: TextStyle(color: Colors.white38),
                            onEditingComplete: () {
                            },
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: '请输入账号',
                              hintStyle: TextStyle(color: Colors.black26,fontSize: 14),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.transparent,
                            ),
                          ),
                        ),
                      ]
                  ),
                ),
                Container(
                  height: 45,
                  // width: ((MediaQuery.of(context).size.width) / 1.6),
                  margin: const EdgeInsets.only(top:10,bottom: 20, left: 25, right: 25),
                  decoration: const BoxDecoration(
                    border:
                    Border(bottom: BorderSide(color: Colors.black12, width: 2)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: passwordController,
                          // style: TextStyle(color: Colors.white38),
                          onEditingComplete: () {
                            _login();
                          },
                          obscureText: !eyes,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: const InputDecoration(
                            hintText: '请输入密码',
                            hintStyle: TextStyle(color: Colors.black26,fontSize: 14),
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.transparent,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          setState(() {
                            eyes = !eyes;
                          });
                        },
                        child: Icon(eyes ? Icons.remove_red_eye : Icons.visibility_off_outlined,size: 30,color: Colors.grey,),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    _login();
                  },
                  child: Container(
                    // width: 120,
                    height: 45,
                    margin: const EdgeInsets.all(30),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(left: 60, right: 60),
                      child: Text('立即登录'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),)
    );
  }
  _login()async{
    if(usernameController.text.isEmpty){
      return CustomDialog.message('账号不能为空！');
    }
    if(passwordController.text.isEmpty){
      return CustomDialog.message('密码不能为空！');
    }
    if(await Request.userLogin(usernameController.text, passwordController.text)){
      //
    }
  }
}
