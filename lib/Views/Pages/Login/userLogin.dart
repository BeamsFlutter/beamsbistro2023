

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Controllers/Services/apiManager.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/responsiveHelper.dart';
import 'package:beamsbistro/Views/Pages/Loading/loadingPage.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}
enum lngMenu { itemOne, itemTwo, itemThree, itemFour }
class _LoginState extends State<Login> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var numberSize = 50.0;
  bool p1 =false;
  bool p2 =false;
  bool p3 =false;
  bool p4 =false;
  var  passCode  ='';
  var  apiCall = ApiCall();
  var lstrRoleCode = '';

  var company = "";
  var yearcode = "";

  var formatDate = new DateFormat('dd MMMM yyyy');
  var formatDate1 = new DateFormat('yyyy-MM-dd hh:mm:ss');

  Global g =  Global();

  late Future<dynamic> futureLogin;
  late Future<dynamic> futureToken;
  late Future<dynamic> futureClockOut;

  bool loginStatus =  true;
  bool clockoutStatus =  true;

  late Timer timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnSetCompany();
    fnGetToken();
    fnClearDualDisplay();
   // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fnGetAvailablePorts());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    g.wstrContext = this.context;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left:10),
          child: GestureDetector(
            onTap: () async{
              SystemNavigator.pop();
             //window.close();
              //openExeFile();
              //openExeOnDisplay("C:/Users/user/Desktop/dual/123.exe", 0);

            },
            child: Icon(Icons.cancel_outlined,color: PrimaryText,size: 35,),
          ),
        ),
        actions: [
          PopupMenuButton<lngMenu>(
            position: PopupMenuPosition.under,
            tooltip: "",
            onSelected: (lngMenu item) {
              print("Hello");
            },
            shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<lngMenu>>[

              PopupMenuItem<lngMenu>(
                value: lngMenu.itemOne,
                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                child: wGamePopup(),
              ),
            ],
            child:   Container(
                margin: EdgeInsets.only(right:20),
                child:  Row(
                  children: [
                    Icon(Icons.language,color: Colors.black,size: 20,),
                    gapWC(5),
                    tcn(g.wstrBistroLng.toString(), Colors.black  , 15)
                  ],
                )
            ),
          ),
          Container(
              margin: EdgeInsets.only(right:20),
              child:  IconButton(onPressed: (){
                Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => Loading()), ).then((value) => (){
                  if(mounted){
                    setState(() {});
                  }
                });
              }, icon: Icon(Icons.refresh,color: Colors.red,size: 35,))
          ),
          Container(
              margin: EdgeInsets.only(right:20),
              child:  IconButton(onPressed: (){
                fnGetIp();
              }, icon: Icon(Icons.wifi,color: Colors.black,size: 35,))
          ),
          Container(
              margin: EdgeInsets.only(right:20),
              child:  IconButton(onPressed: (){
                 //fnSysytemInfo();
                _printPdf();
              }, icon: Icon(Icons.settings,color: SecondaryColor,size: 35,))
          )

        ],
      ),
      body:  SafeArea(
          child: Container(
            height: size.height,
            width: size.width,
            margin: pageMargin(),

            child: SingleChildScrollView(
              child: ResponsiveWidget(
                mobile: mobileScreen(size), tab: tabScreen(size),windows: windowScreen(size),
              ),
            ),
          )
      ),
    ), onWillPop: () async{
      SystemNavigator.pop();
      return true;
    });
  }


  //widgets
  Column mobileScreen(Size size) {
    return Column(
        children: [
          Container(
            height: size.height * 0.85,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10,left: 30,right: 30),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("assets/icons/bislogo.png",
                          width: 160,),
                      ],
                    ),

                  ),

                  tc('Enter your passcode.',PrimaryText,25),
                  gapHC(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: boxDecoration(p1 ?Colors.amber:Colors.white, 50),
                        child: Center(
                        ),
                      ),
                      gapW(),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: boxDecoration(p2 ?Colors.amber:Colors.white, 50),
                        child: Center(
                        ),
                      ),
                      gapW(),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: boxDecoration(p3 ?Colors.amber:Colors.white, 50),
                        child: Center(
                        ),
                      ),
                      gapW(),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: boxDecoration(p4 ? Colors.amber:Colors.white, 50),
                        child: Center(
                        ),

                      )
                    ],
                  ),

                  gapHC(60),
                  Container(

                    width: size.width * 0.7,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            numberPressMobile('1'),
                            numberPressMobile('2'),
                            numberPressMobile('3'),
                          ],
                        ),
                        gapHC(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            numberPressMobile('4'),
                            numberPressMobile('5'),
                            numberPressMobile('6'),
                          ],
                        ),
                        gapHC(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            numberPressMobile('7'),
                            numberPressMobile('8'),
                            numberPressMobile('9'),
                          ],
                        ),
                        gapHC(30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.fingerprint,size: numberSize,color: Colors.white,),
                            numberPressMobile('0'),
                            IconButton(onPressed: (){
                              fnOnPressClear();
                            }, icon:  Icon(Icons.backspace,size: 30,),)

                          ],
                        ),
                        gapHC(10),

                      ],
                    ),

                  ),


                ],
              ),
            ),
          ),
          Container(
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tc('BEAMS ',PrimaryText,10),
                tc('',PrimaryText,10),

              ],
            ),
          )
        ],
      );
  }
  Column tabScreen(Size size) {
    return Column(
      children: [
        Container(
          height: size.height * 0.9,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                gapHC(100),
                Container(
                  margin: const EdgeInsets.only(bottom: 15,left: 30,right: 30),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/icons/bislogo.png",
                        width: 250,),
                    ],
                  ),

                ),

                tc('Enter your passcode.',PrimaryText,25),
                gapHC(50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: boxDecoration(p1 ?Colors.amber:Colors.white, 60),
                      child: Center(
                      ),
                    ),
                    gapW(),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: boxDecoration(p2 ?Colors.amber:Colors.white, 60),
                      child: Center(
                      ),
                    ),
                    gapW(),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: boxDecoration(p3 ?Colors.amber:Colors.white, 60),
                      child: Center(
                      ),
                    ),
                    gapW(),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: boxDecoration(p4 ? Colors.amber:Colors.white, 60),
                      child: Center(
                      ),

                    )
                  ],
                ),

                gapHC(100),
                Container(

                  width: size.width * 0.5,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          numberPressTab('1'),
                          numberPressTab('2'),
                          numberPressTab('3'),
                        ],
                      ),
                      gapHC(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          numberPressTab('4'),
                          numberPressTab('5'),
                          numberPressTab('6'),
                        ],
                      ),
                      gapHC(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          numberPressTab('7'),
                          numberPressTab('8'),
                          numberPressTab('9'),
                        ],
                      ),
                      gapHC(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.fingerprint,size: numberSize,color: Colors.white,),
                          numberPress('0'),
                          IconButton(onPressed: (){
                            fnOnPressClear();
                          }, icon:  Icon(Icons.backspace,size: 30,),)

                        ],
                      ),
                      gapHC(10),

                    ],
                  ),

                ),


              ],
            ),
          ),
        ),
        Container(
          child:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tc('BEAMS ',PrimaryText,10),
              tc('RESTAURANT ',PrimaryText,10),

            ],
          ),
        )
      ],
    );
  }
  Row windowScreen(Size size) {
    return Row(
      children: [
        Container(
          width: size.width*0.45,
          height: size.height * 0.9,
          // decoration: BoxDecoration(
          //     image: DecorationImage(
          //         image: AssetImage("assets/images/bg1.jpg"),
          //         fit: BoxFit.cover
          //     )
          // ),
          child: Container(
            // decoration: boxGradientDecoration(16, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 15,left: 30,right: 30),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30, vertical: 16),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("assets/icons/bislogo.png",
                        width: 300,),

                    ],
                  ),

                ),
              ],
            ),
          ),
        ),
        Container(
          width: size.width*0.45,
          height: size.height * 0.9,
          child: SingleChildScrollView(
            child: Container(
              height: size.height * .9,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tc(mfnLng("Enter your passcode").toString(),PrimaryText,20),
                    gapHC(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height:40,
                          width: 40,
                          decoration: boxDecoration(p1 ?Colors.amber:Colors.white, 60),
                          child: Center(
                          ),
                        ),
                        gapW(),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: boxDecoration(p2 ?Colors.amber:Colors.white, 60),
                          child: Center(
                          ),
                        ),
                        gapW(),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: boxDecoration(p3 ?Colors.amber:Colors.white, 60),
                          child: Center(
                          ),
                        ),
                        gapW(),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: boxDecoration(p4 ? Colors.amber:Colors.white, 60),
                          child: Center(
                          ),

                        )
                      ],
                    ),

                    gapHC(40),
                    Container(
                      width: size.width * 0.3,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              numberPress('1'),
                              numberPress('2'),
                              numberPress('3'),
                            ],
                          ),
                          gapHC(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              numberPress('4'),
                              numberPress('5'),
                              numberPress('6'),
                            ],
                          ),
                          gapHC(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              numberPress('7'),
                              numberPress('8'),
                              numberPress('9'),
                            ],
                          ),
                          gapHC(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.fingerprint,size: numberSize,color: Colors.white,),
                              numberPress('0'),
                              IconButton(onPressed: (){
                                fnOnPressClear();
                              }, icon:  Icon(Icons.backspace,size: 30,),)

                            ],
                          ),
                          gapHC(20),

                        ],
                      ),

                    ),
                  ],
                ),
              ),
            ),
          )
        )
      ],
    );
  }

  //other functions
  fnOnPress(mode){
    if(p4){
      fnLogin();
    }else if(p3){
      p4 = true;
      passCode = passCode+mode;
      fnLogin();
    }else if(p2){
      p3 = true;
      passCode = passCode+mode;
    }else if(p1){
      p2 = true;
      passCode = passCode+mode;
    }else{
      p1 = true;
      passCode = passCode+mode;
    }

    setState(() {
      passCode =passCode;
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
  Widget numberPress(text) => Bounce(
    duration: Duration(milliseconds: 110),
    onPressed: (){
      fnOnPress(text);
    },
    child: Container(
      height: 70,
      width: 80,
      margin: EdgeInsets.all(5),
      decoration: boxDecoration(Colors.white, 10),
        child: Center(
          child: tc(text,Colors.black,40),
        ),
    ),
  );
  Widget numberPressTab(text) => Bounce(
    duration: Duration(milliseconds: 110),
    onPressed: (){
      fnOnPress(text);
    },
    child: Container(
      height: 75,
      width: 100,
      margin: EdgeInsets.all(2),
      decoration: boxDecoration(Colors.white, 10),
      child: Center(
        child: tc(text,titleSubText,40),
      ),
    ),
  );
  Widget numberPressMobile(text) => Bounce(
    duration: Duration(milliseconds: 110),
    onPressed: (){
      fnOnPress(text);
    },
    child: Container(
      height: 50,
      width: 80,
      decoration: boxDecoration(Colors.white, 10),
      child: Center(
        child: tc(text,titleSubText,20),
      ),
    ),
  );

  Widget wGamePopup(){

    return Container(
      width: 100,
      decoration: boxBaseDecoration(Colors.white, 0),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: wBranchCard(),
      ),
    );
  }
  List<Widget> wBranchCard(){
    List<Widget> rtnList  =  [];

    for(var e in g.wstrLanguageList){
      rtnList.add(GestureDetector(
        onTap: (){

          Navigator.pop(context);
          setState(() {
           g.wstrBistroLng = (e["CODE"]??"ENGLISH");
          });
        },
        child: Container(
          decoration: boxBaseDecoration(greyLight, 5),
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
          margin: const EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              const Icon(Icons.language,color:Colors.black,size: 15,),
              gapWC(5),
              Expanded(child: tcn((e["CODE"]??"").toString(), Colors.black, 12))
            ],
          ),
        ),
      ));
    }

    return rtnList;
  }

  //api call
  fnLogin() async{

      if(loginStatus){
        setState(() {
          loginStatus = false;
        });
        futureLogin = apiCall.userLogin(passCode,g.wstrCompany);
        futureLogin.then((value) =>
            fnLoginSuccess(value)
        );
      }

  }
  fnLoginSuccess(value) async{
    setState(() {
      loginStatus = true;
    });
    var msg = '';
    var status = '0';
    var userCd = '';
    var userName  = '';
    var userBrnCode  = '';
    var roleCode = '';
    var clockInCount = 0;
    var clockInDate = '';
    var shiftNo = '';
    var shiftDescp = '';
    var discCode = '';
    var discYn = '';
    var discType = '';
    var discMaxPerc = 0.0;
    var clockInTime= 0;

    if(value == null){

      showToast( "Login failed");
    }else{
      if(value.length > 0){


        debugPrint("LOGIN======================================================");
        debugPrint(value.toString());

        msg = value[0]["MSG"].toString();
        status =  value[0]["STATUS"].toString();
        if(status == '1'){
          final SharedPreferences prefs = await _prefs;

          userCd = (value[0]["USER_CD"]??"").toString();
          if(userCd.isEmpty){
            userCd = (value[0]["USERCD"]??"").toString();
          }
          userName = (value[0]["USER_NAME"]??"").toString();
          if(userName.isEmpty){
            userName = (value[0]["USERDESCP"]??"").toString();
          }
          roleCode = (value[0]["ROLE_CODE"]??"").toString();
          clockInCount = value[0]["CLOCKIN_COUNT"]??0;
          clockInDate = value[0]["CLOCKIN_DATE"].toString();
          shiftNo = value[0]["SHIFT"]??"";
          shiftDescp = value[0]["SHIFT_DESCP"]??"";
          userBrnCode = (value[0]["BRNCODE"]??"").toString();
          var cTime  =   value[0]["AUTOCLOSE_TIME"]??"";
          var time =  cTime.toString().split(":");
          try{
            clockInTime =  g.mfnInt(time[0]);
          }catch(e){
            clockInTime = 4;
          }

          discCode = value[0]["DISC_GROUP"].toString();
          discYn = value[0]["ALLOW_TO_DISCOUNT"].toString();
          discType = value[0]["PRC_TYPE"].toString();
          discMaxPerc = g.mfnDbl(value[0]["MAX_PERC_DISC"]);


          lstrRoleCode = roleCode;
          company =   value[0]["COMPANY"].toString();
          yearcode =   value[0]["YEARCODE"].toString();
          var now = DateTime.now();
          var lstrLoginDate = formatDate1.format(now);

          prefs.setString('wstrUserCd', userCd);
          prefs.setString('wstrUserName', userName);
          prefs.setString('wstrUserRole', roleCode);
          prefs.setString('wstrUserBrnCode', userBrnCode);
          prefs.setString('wstrCompany', company);
          prefs.setString('wstrYearcode', yearcode);
          prefs.setString('wstrLoginSts', 'Y');
          prefs.setString('wstrLoginDate', lstrLoginDate);
          prefs.setString('wstrTableView','1');
          prefs.setString('wstrShift',shiftNo);
          prefs.setString('wstrShiftDescp',shiftDescp);
          prefs.setString('wstrClockInDate',clockInDate);
          prefs.setString('wstrTableView','1');
          prefs.setString('wstrClockInSts','IN');

          prefs.setString('wstrDiscYn',discYn);
          prefs.setString('wstrDiscGroup',discCode);
          prefs.setString('wstrDiscType',discType);
          prefs.setDouble('wstrDiscMaxPerc',discMaxPerc);
          prefs.setInt('wstrAutoClockOutTime',clockInTime);
          prefs.setString('wstrBistroLng',g.wstrBistroLng.toString());


          g.wstrSPLIT_YN =    (value[0]["SPLIT_YN"]??"").toString();
          g.wstrMERGE_YN = (value[0]["MERGE_YN"]??"").toString();
          g.wstrE86ITEM_YN = (value[0]["E86ITEM_YN"]??"").toString();
          g.wstrDINE_IN_YN = (value[0]["DINE_IN_YN"]??"").toString();
          g.wstrTAKEAWAY_YN = (value[0]["TAKEAWAY_YN"]??"").toString();
          g.wstrTABLE_YN = (value[0]["TABLE_YN"]??"").toString();
          g.wstrFLOOR_YN = (value[0]["FLOOR_YN"]??"").toString();
          g.wstrDELIVERY_YN = (value[0]["DELIVERY_YN"]??"").toString();
          g.wstrHIDE_CLOSING_YN = (value[0]["HIDE_DAILYCASH_CLOSING_YN"]??"").toString();

          g.wstrUserName = userName;
          g.wstrUserCd = userCd;
          g.wstrUserBrnCode = userBrnCode;
          g.wstrCompany = company;
          g.wstrYearcode = yearcode;
          g.wstrRoleCode = roleCode;
          g.wstrTableView = '1';
          g.wstrShifNo = shiftNo;
          g.wstrShifDescp = shiftDescp;
          g.wstrClockInDate = clockInDate;

          g.wstrDiscountYn = discYn == "Y"?true:false;
          g.wstrDiscountType = discType;
          g.wstrDiscountMaxPerc = discMaxPerc;
          g.wstrDiscountGroup = discCode;
          g.wstrAutoClockOutTime = clockInTime;

          if(clockInCount == 0){
            prefs.setString('wstrClockInSts','OUT');
            Navigator.pushReplacement(context, NavigationController().fnRoute(12));
          }else{
            var cd= formatDate.format(DateTime.parse(clockInDate));
            //fnRoleWiseLogin();
            PageDialog().clockinDialog(context, fnClockOut, fnRoleWiseLogin, shiftDescp, cd);
          }

          showToast( mfnLng(value[0]["MSG"].toString()));
        }else {

          showToast( value[0]["MSG"]);
        }

      }
    }

    setState(() {
      p1=false;
      p2=false;
      p3=false;
      p4=false;
      passCode = '';
    });

  }

  fnRoleWiseLogin() async{
    final SharedPreferences prefs = await _prefs;
    if(lstrRoleCode == 'WAITER'){
      prefs.setString('wstrOrderScreenMode',"W");
      g.wstrOrderScreenMode = "W";
      Navigator.pushReplacement(context, NavigationController().fnRoute(14));

    }else if(lstrRoleCode == 'CHEF'){
      Navigator.pushReplacement(context, NavigationController().fnRoute(10));
    }else if(lstrRoleCode == 'ADMIN'){
      prefs.setString('wstrOrderScreenMode',"P");
      g.wstrOrderScreenMode = "P";
      Navigator.pushReplacement(context, NavigationController().fnRoute(9));
    }else if(lstrRoleCode == 'QUICK' || lstrRoleCode == 'QADMIN'){
      Navigator.pushReplacement(context, NavigationController().fnRoute(16));
    }else if(lstrRoleCode == 'CASHIER'){
      prefs.setString('wstrOrderScreenMode',"P");
      g.wstrOrderScreenMode = "P";
      Navigator.pushReplacement(context, NavigationController().fnRoute(9));

    }else{
      //Navigator.pushReplacement(context, NavigationController().fnRoute(16));
    }
  }
  fnClockOut(){
    if(clockoutStatus){
      setState(() {
        clockoutStatus = false;
      });
      futureClockOut =  apiCall.colckInOut('OUT', g.wstrUserCd, g.wstrCompany, g.wstrShifNo,g.wstrYearcode);
      futureClockOut.then((value) => fnClockInSuccess(value));
    }

  }
  fnClockInSuccess(value) async{
    setState(() {
      clockoutStatus = true;
    });
    if(g.fnValCheck(value)){
      var dataList  =  value['Table1'][0];
      var sts = dataList["STATUS"].toString();
      var msg = dataList["MSG"];
      Navigator.pop(context);
      if(sts == "0"){
        var pendingList = value['Table2'];
        PageDialog().showSysytemInfo(context,
            Container(
              height: 200,
              child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: pendingList.length,
                  itemBuilder: (context, index) {
                    var dataList = pendingList[index];
                    var id = dataList["COUNTER_NO"]??"";
                    var name = dataList["MACHINENAME"]??"";
                    return GestureDetector(
                      onTap: (){

                      },
                      child : Container(
                        height: 40,
                        margin: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
                        decoration: boxDecoration(Colors.amber, 10),
                        child: Center(
                          child :tc(name.toString(),Colors.black,18),
                        ),
                      ),

                    );
                  }),
            )
            , 'DAILY CLOSING IS PENDING');
      }
      showToast( msg);
    }
  }

  fnSetCompany()  async{
    final SharedPreferences prefs = await _prefs;

    prefs.setString('wstrCompany', company);
    prefs.setString('wstrYearcode', yearcode);

    g.wstrCompany = company;
    g.wstrYearcode = yearcode;
  }

  fnSysytemInfo(){
    PageDialog().showSysytemInfo(context, Container(
      child: Column(

        children: [
          // gapHC(10),
          // Row(
          //   children: [
          //     Icon(Icons.access_time_outlined,size: 20,color: Colors.black,),
          //     gapWC(10),
          //     tc(g.wstrShifDescp.toString(),Colors.black,20)
          //   ],
          // ),
          // gapHC(10),

          Row(
            children: [
              Icon(Icons.laptop,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrDeviceName.toString(),Colors.black,18)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.confirmation_number_outlined,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrDeivceId.toString(),Colors.black,20)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.mobile_friendly,size: 20,color: Colors.black,),
              gapWC(10),
              tc('V 2.3',Colors.black,20)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.today,size: 20,color: Colors.black,),
              gapWC(10),
              tc('11 NOV 2022',Colors.black,20)
            ],
          )
        ],
      ),
    ), 'System Info');
  }


  //Token
  fnGetToken(){
    futureToken =  ApiManager().mfnGetToken();
    futureToken.then((value) => fnGetTokenSuccess(value));
  }
  fnGetTokenSuccess(value) async{
    final SharedPreferences prefs = await _prefs;
   // print(value);
    prefs.setString('wstrToken', value["access_token"]);
    g.wstrToken =  value["access_token"];
  }

  //ip
  fnGetIp(){
    Navigator.pushReplacement(context, NavigationController().fnRoute(17));
  }

  void openExeFile() async {
    try {
      final filePath = '123.exe';
      await Process.run(filePath, []);
    } catch (e) {
      print('Error opening file: $e');
    }
  }

  void openExeOnDisplay(String exePath, int displayIndex) {
    if (!kIsWeb && Platform.isWindows) {
      final command = 'start "" /d/move/monitor:${displayIndex} "$exePath"';
      Process.run('cmd.exe', ['/c', command]);
    }
  }


  fnClearDualDisplay() async{
    var data =  {
      "STS":"0",
      "COMPANY_DATA":{
        "NAME":"JASMINE TIME",
        "ADD":"DUBAI",
        "MOBILE":"0526912325",
      },
      "BILL_DETAILS":{
        "BILLNO":"NEW",
        "DOCDATE":"",
        "USER":g.wstrUserName,
        "DEVICE":"Device",
      },
      "ITEM_LIST":[],
      "TOTAL":{
        "NET_TOTAL":""
      },
      "MESSAGE":{
        "BOTTOM_MESSAGE":"THANK YOU"
      },
    };

    await writeJsonDataToFile(data);
  }
  writeJsonDataToFile(var jsonData) async {
    try {
      String jsonString = jsonEncode(jsonData);
      File file = File("C:/BEAMS/data.json");
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error writing JSON file: $e');
    }
  }



  Future<void> _printPdf() async {
    var pdf ;
    await ApiManager().getFileFromUrl("http://beamsprogrammer-001-site24.itempurl.com/PDF/GasContractNo_EG-37182.PDF").then(
          (value) => {
        setState(() {
          if (value != null) {
            pdf = value;
          } else {
          }
        })
      },
    );


  }





}
