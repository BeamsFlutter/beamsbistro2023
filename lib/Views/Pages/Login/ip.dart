

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Controllers/Services/apiManager.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IpConfig extends StatefulWidget {
  const IpConfig({Key? key}) : super(key: key);

  @override
  _IpConfigState createState() => _IpConfigState();
}

class _IpConfigState extends State<IpConfig> {

  Global g  =  Global();
  ApiCall  apiCall  = ApiCall();
  late Future<dynamic> futureToken;

  var txtIp  = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    txtIp.text = g.wstrIp.toString();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       body: Container(
         padding: EdgeInsets.all(30),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             tc('IP SETUP',Colors.black,20),
             gapH(),
             RoundedInputField(
               hintText: '192.168.0.100:1103',
               txtWidth: 0.4,
               txtRadius: 10,
               txtController: txtIp,
               suffixIcon: Icons.cancel_outlined,
               suffixIconOnclick: (){
                 txtIp.clear();
               },
             ),
             gapHC(10),
             Row(
               children: [
                 GestureDetector(
                   onTap: (){
                     if(txtIp.text.isEmpty){
                       showToast( 'Please enter ip');
                     }else{
                       fnChangeIp();
                     }
                   },
                   child: Container(
                     height: 40,
                     width: 100,
                     decoration: boxGradientDecoration(11, 10),
                     child: Center(
                       child: tc('CHANGE IP', Colors.white, 10),
                     ),
                   ),
                 ),
                 gapWC(10),
                 GestureDetector(
                   onTap: (){
                     fnRemoveIp();
                   },
                   child: Container(
                     height: 40,
                     width: 100,
                     decoration: boxGradientDecoration(12, 10),
                     child: Center(
                       child: tc('REMOVE IP', Colors.white, 10),
                     ),
                   ),
                 ),
                 gapWC(10),
                 GestureDetector(
                   onTap: (){
                     fnPublicIp();
                   },
                   child: Container(
                     height: 40,
                     width: 100,
                     decoration: boxGradientDecoration(10, 10),
                     child: Center(
                       child: tc('PUBLIC', Colors.white, 10),
                     ),
                   ),
                 )
                 ,gapWC(10),
                 GestureDetector(
                   onTap: (){
                     fnClose();
                   },
                   child: Container(
                     height: 40,
                     width: 100,
                     decoration: boxGradientDecoration(9, 10),
                     child: Center(
                       child: tc('CLOSE', Colors.white, 10),
                     ),
                   ),
                 )

               ],
             )
           ],
         ),
       ),
    );
  }

  fnChangeIp() async{
    var ip = 'http://'+txtIp.text+'/';
    final SharedPreferences prefs = await _prefs;
    setState(() {
      g.wstrIp = ip;
      prefs.setString('wstrIP', ip);
    });
    showToast( 'DONE');
    Navigator.pushReplacement(context, NavigationController().fnRoute(11));
  }
  fnRemoveIp() async{
    final SharedPreferences prefs = await _prefs;
    setState(() {
      g.wstrIp = "";
      prefs.setString('wstrIP', "");
    });
    showToast( 'DONE');
    Navigator.pushReplacement(context, NavigationController().fnRoute(11));
  }
  fnPublicIp(){
    setState(() {
      var baseUrl = "ead6-217-165-100-201.ngrok.io";
      txtIp.text = baseUrl.toString();
    });
  }

  fnGetToken(){
    var ip = 'http://'+txtIp.text+'/';
    futureToken =  ApiManager().mfnGetTokenTest(ip);
    try {
      futureToken.then((value) => fnGetTokenSuccess(value));
    }catch(e) {
      //Handle all other exceptions
      showToast( 'Connection Failed!!');
    }
  }
  fnGetTokenSuccess(value){

    if(g.fnValCheck(value)){
      fnChangeIp();
    }else{
      showToast( 'Connection Failed!!');
    }


  }


  fnClose(){
    Navigator.pushReplacement(context, NavigationController().fnRoute(11));
  }

}
