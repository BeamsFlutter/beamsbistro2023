import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:oktoast/oktoast.dart';

class OpenDrawer extends StatefulWidget {


  final Function fnCallBack;

  const OpenDrawer({Key? key,required this.fnCallBack}) : super(key: key);

  @override
  _OpenDrawerState createState() => _OpenDrawerState();
}

class _OpenDrawerState extends State<OpenDrawer> {

  late Future<dynamic> futureAdmin;
  Global g = Global();
  ApiCall apiCall = ApiCall();

  bool p1 = false;
  bool p2 = false;
  bool p3 = false;
  bool p4 = false;

  var passCode ='';
  var numberSize = 50.0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    return Container(
      padding: const EdgeInsets.only(left: 15.0,right: 15.0),
     //   height: size.height ,
       child: SingleChildScrollView(
          child: Column(
            children: [
              gapHC(20),
              tc(mfnLng('ENTER ADMIN PASSCODE'), Colors.black, 18),
              gapHC(25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    width:  40,
                    decoration: boxDecoration(p1?Colors.amber : Colors.white, 60),
                  ),
                  gapW(),
                  Container(
                    height: 40,
                    width:  40,
                    decoration: boxDecoration(p2?Colors.amber : Colors.white, 60),
                  ),
                  gapW(),
                  Container(
                    height: 40,
                    width:  40,
                    decoration: boxDecoration(p3?Colors.amber : Colors.white, 60),
                  ),
                  gapW(),
                  Container(
                    height: 40,
                    width:  40,
                    decoration: boxDecoration(p4?Colors.amber : Colors.white, 60),
                  ),
                  gapW(),
                ],
              ),
              gapHC(20),
              Center(
                child: Container(
                /*  width: size.width,
                  height:  size.height,*/
                  margin: const EdgeInsets.only(left: 0.0,right: 0.0,top: 5.0,bottom: 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          numberPressMobile('1'),
                          gapWC(20),
                          numberPressMobile('2'),
                          gapWC(20),
                          numberPressMobile('3'),
                        ],
                      ),
                      gapHC(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          numberPressMobile('4'),
                          gapWC(20),
                          numberPressMobile('5'),
                          gapWC(20),
                          numberPressMobile('6'),
                        ],
                      ),
                      gapHC(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          numberPressMobile('7'),
                          gapWC(20),
                          numberPressMobile('8'),
                          gapWC(20),
                          numberPressMobile('9'),
                        ],
                      ),
                      gapHC(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 80,
                              height: 50,
                              decoration: boxDecoration(Colors.white,10),
                              child: Center(child: Icon(Icons.cancel,size: 30,color: Colors.black,)),
                            ),
                          ),
                          gapWC(20),

                          numberPressMobile('0'),
                          gapWC(20),
                          GestureDetector(
                            onTap: (){
                              fnOnPressClear();
                            },
                            child: Container(
                              width: 80,
                              height: 50,
                              decoration: boxDecoration(Colors.white,10),
                              child: Center(child: Icon(Icons.backspace,size: 25,color: Colors.black,)),
                            ),
                          ),





                        ],
                      ),
                      gapHC(10),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  fnDone();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 10.0,right: 20.0,top: 15.0),
                  height: 50,
                  decoration: boxDecoration(Colors.green,30),
                  child: Center(child: tc(mfnLng('DONE'), Colors.white, 15)),
                ),
              ),



            ],
          ),
        ),

      );

  }


  Widget numberPressMobile(text) => Bounce(
    duration: Duration(milliseconds: 110),
    onPressed: (){
      fnOnPress(text);
    },
    child: Container(
      height: 50,
      width: 80,
      decoration: boxDecoration(Colors.amber, 10),
      child: Center(
        child: tc(text, Colors.black, 20),
      ),
    ),
  );

  fnOnPress(mode){

    if(p4){
     // showToast( 'API CALL' +passCode);
      // API CALL
    }else if(p3){
      p4 = true;
      passCode = passCode + mode;
      //showToast( 'API CALL' +passCode);
    }else if(p2){
      p3 = true;
      passCode = passCode+ mode;

    }else if(p1){
      p2 = true;
      passCode = passCode + mode;

    }else{
      p1 = true;
      passCode = passCode + mode;
    }

    setState(() {
      passCode = passCode;
    });

  }
  fnOnPressClear(){

    if(p4){
      p4 = false;
    }else if(p3){
      p3 = false;
    }else if(p2){
      p2 = false;
    }else if(p1){
      p1 = false;
    }else{
      passCode = '';
    }

    if(passCode.isNotEmpty){
      passCode = passCode.substring(0, passCode.length - 1);
    }

    setState(() {

      passCode =passCode;
    });
  }

  fnDone(){
    if(p4){
      fnAdminPermission();
    }else{
      showToast( mfnLng('Please check your passcode!'));
    }
  }

  fnAdminPermission(){
    futureAdmin =  apiCall.adminPermission(passCode);
    futureAdmin.then((value) => fnAdminPermissionSuccess(value));
  }
  fnAdminPermissionSuccess(value){
    print(value);
    if(g.fnValCheck(value)){
      var sts = value[0]['STATUS'];
      var msg = value[0]['MSG'];
      var userCd  = value[0]['USERCD'];
      //showToast( msg);
      Navigator.pop(context);
      widget.fnCallBack(sts,userCd);

    }

  }

}
