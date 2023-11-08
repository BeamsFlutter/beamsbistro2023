
import 'dart:async';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Pages/Bill/open_drawer.dart';
import 'package:beamsbistro/Views/Pages/Bill/openingCash.dart';
import 'package:beamsbistro/Views/Pages/Bill/printerSelection.dart';
import 'package:beamsbistro/Views/Pages/Bill/salesSummary.dart';
import 'package:beamsbistro/Views/Pages/Bill/shiftClosing.dart';
import 'package:beamsbistro/Views/Pages/Bill/tapDevices.dart';
import 'package:beamsbistro/Views/Pages/Booking/booking.dart';
import 'package:beamsbistro/Views/Pages/Login/userLogin.dart';
import 'package:beamsbistro/Views/Pages/QuickBill/CouponIssue.dart';
import 'package:beamsbistro/Views/Pages/QuickBill/quicksale.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'invoice.dart';
import 'invoice_status.dart';

class QuickHome extends StatefulWidget {
  const QuickHome({Key? key}) : super(key: key);

  @override
  _QuickHomeState createState() => _QuickHomeState();
}

class _QuickHomeState extends State<QuickHome> {
  //Global
  Global g = Global();
  ApiCall apiCall = ApiCall();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<dynamic> futureDrawer;
  var formatTimeSecond = new DateFormat('hh:mm:ss a');
  var formatDate = new DateFormat('yyyy-MM-dd hh:mm:ss');
  var formatDate1 = new DateFormat('yyyy-MM-dd');


  //Page Variable
  var lstrTime ;
  late Timer timerTime;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timerTime =
        Timer.periodic(Duration(seconds: 1), (Timer t) => fnUpdateTime());
  }


  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height*0.1,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: boxBaseDecoration(Colors.white, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset("assets/icons/bislogo.png",
                          width: 100,),
                        gapWC(20),
                      ],
                    ),


                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        th(g.wstrUserName.toString(), Colors.blueGrey, 18),
                        gapW(),
                        tcn(lstrTime??'',Colors.blueGrey,18),
                        gapWC(20),
                        tcn(g.wstrShifDescp.toString().toUpperCase(),Colors.blueGrey,18),
                        gapWC(20),

                        GestureDetector(
                          onTap: (){
                            fnOpenClosing();
                          },
                          child: Container(
                            height: 30,
                            width: 80,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(PrimaryColor, 30),
                            child: Icon(Icons.access_time_outlined,color: Colors.white,size: 20,),
                          ),
                        ),

                        Bounce(
                          duration: Duration(milliseconds: 110),
                          onPressed: (){
                            fnOpeningCash();
                            //fnPrintTest();
                          },
                          child: Container(
                            height: 30,
                            width: 80,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(Colors.green, 30),
                            child: Icon(Icons.payments_outlined,color: Colors.white,size: 20,),
                          ),
                        ),

                        Bounce(
                          duration: Duration(milliseconds: 110),
                          onPressed: (){
                            fnChoosePrinter();
                          },
                          child: Container(
                            height: 40,
                            width: 50,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(Colors.amber, 10),
                            child: Icon(Icons.print,color: Colors.black,size: 20,),
                          ),
                        ),
                        Bounce(
                          duration: Duration(milliseconds: 110),
                          onPressed: (){
                            fnChooseTapDevice();
                          },
                          child: Container(
                            height: 40,
                            width: 50,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(Colors.amber, 10),
                            child: Icon(Icons.tap_and_play,color: Colors.black,size: 20,),
                          ),
                        ),
                        Bounce(
                          duration: Duration(milliseconds: 110),
                          onPressed: (){
                            fnOpenDrawer();
                          },
                          child: Container(
                            height: 40,
                            width: 50,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(Colors.amber, 10),
                            child: Icon(Icons.open_in_browser_outlined,color: Colors.black,size: 20,),
                          ),
                        ),
                        Bounce(
                          duration: Duration(milliseconds: 110),
                          onPressed: (){
                            fnSysytemInfo();
                          },
                          child: Container(
                            height: 40,
                            width: 50,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(Colors.amber, 10),
                            child: Icon(Icons.computer_sharp,color: Colors.black,size: 20,),
                          ),
                        ),
                        Bounce(
                          duration: Duration(milliseconds: 110),
                          onPressed: (){
                            fnOpenCouponIssue();
                          },
                          child: Container(
                            height: 40,
                            width: 100,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(Colors.amber, 10),
                            child: Icon(Icons.confirmation_number,color: Colors.black,size: 20,),
                          ),
                        ),
                        Bounce(
                          duration: Duration(milliseconds: 110),
                          onPressed: (){
                            fnLogout();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(greyLight, 10),
                            child: Icon(Icons.power_settings_new,color: Colors.red,size: 30,),
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                height: size.height*0.8,
                width: size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              if(fnCheckDocDate()){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => QuickSale()
                                ));
                              }else{
                                showToast( "Clock-in not valid!!");
                              }

                            },
                            child: Container(
                              height: size.height*0.35,
                              width: size.width*0.3,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/takeorder.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(40))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width*0.15,
                                  ),
                                  Container(
                                    width: size.width*0.15,
                                    decoration: boxGradientDecorationS(17, 40),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        iconImage(Icons.add_circle_outline_sharp,PrimaryColor),
                                        tcn('Take Order', Colors.white, 18)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              if(fnCheckDocDate()){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => InvoiceHistory()
                                ));
                              }else{
                                showToast( "Clock-in not valid!!");
                              }

                            },
                            child: Container(
                              height: size.height*0.35,
                              width: size.width*0.3,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/bill.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(40))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width*0.15,
                                  ),
                                  Container(
                                    width: size.width*0.15,
                                    decoration: boxGradientDecorationS(18, 40),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        iconImage(Icons.sticky_note_2_outlined,Colors.amber),
                                        tcn('Invoice', Colors.white, 18)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              if(fnCheckDocDate()){
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => InvoiceStatus()
                                ));
                              }else{
                                showToast( "Clock-in not valid!!");
                              }

                              // Navigator.push(context, MaterialPageRoute(
                              //     builder: (context) => KitchenDisplay()
                              // ));
                            },
                            child: Container(
                              height: size.height*0.35,
                              width: size.width*0.3,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/kds.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(40))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width*0.15,
                                  ),
                                  Container(
                                    width: size.width*0.15,
                                    decoration: boxGradientDecorationS(17, 40),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        iconImage(Icons.desktop_mac_sharp,PrimaryColor),
                                        tcn('KDS', Colors.white, 18)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      gapHC(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){

                              if(fnCheckDocDate()){
                                fnOpenBooking();

                              }else{
                                showToast( "Clock-in not valid!!");
                              }

                            },
                            child: Container(
                              height: size.height*0.35,
                              width: size.width*0.3,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/booking.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(40))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width*0.15,


                                  ),
                                  Container(
                                    width: size.width*0.15,
                                    decoration: boxGradientDecorationS(17, 40),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        iconImage(Icons.date_range_sharp,PrimaryColor),
                                        tcn('Booking', Colors.white, 18)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              fnOpenClosing();
                            },
                            child: Container(
                              height: size.height*0.35,
                              width: size.width*0.3,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/dailyclosing.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(40))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width*0.15,
                                  ),
                                  Container(
                                    width: size.width*0.15,
                                    decoration: boxGradientDecorationS(18, 40),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        iconImage(Icons.calculate,Colors.amber),
                                        tcn('Daily Closing', Colors.white, 18)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              fnSalesSummary();
                            },
                            child: Container(
                              height: size.height*0.35,
                              width: size.width*0.3,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/openingcash.jpg"),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(40))
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: size.width*0.15,
                                  ),
                                  Container(
                                    width: size.width*0.15,
                                    decoration: boxGradientDecorationS(17, 40),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        iconImage(Icons.payments_outlined,PrimaryColor),
                                        tcn('Sales Summary', Colors.white, 18)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )

                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  //============================Widget Ui ===================

  Container iconImage(icon,color) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      height: 60,
      width: 60,
      decoration: boxDecoration(Colors.white, 60),
      child: Icon(icon,color: color,size: 30,),
    );
  }

  //============================PAGE FUNCTIONS ========================

  //===========================Other Functions ======================

  //=========================Api Call ====================

  //==========================Navigation ==================

  fnClockOut(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ShiftClosing()
    ));
  }
  fnOpenCoupon(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => CouponIssue()
    ));
  }
  fnSalesSummary(){

    if(g.wstrRoleCode == "QADMIN"){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => SalesSummary()
      ));
    }else{
      // showToast( 'Contact your admin!!');
      PageDialog().show_(context, OpenDrawer(
          fnCallBack:fnSalesSummarySuccess
      ), '');

    }

  }

  fnOpenBooking(){

    if(g.wstrRoleCode == "QADMIN"){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => Booking()
      ));
    }else{
      // showToast( 'Contact your admin!!');
      PageDialog().show_(context, OpenDrawer(
          fnCallBack:fnOpenbookingSuccess
      ), '');

    }

  }

  fnSalesSummarySuccess(data,user){
    if(data == '1'){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => SalesSummary()
      ));
    }else{
      showToast( 'PERMISSION DENIED');
    }
  }
  fnOpenbookingSuccess(data,user){
    if(data == '1'){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => Booking()
      ));
    }else{
      showToast( 'PERMISSION DENIED');
    }
  }

  fnOpeningCash(){

    if(g.wstrRoleCode == "QADMIN"){
      PageDialog().showL(context, OpeningCash(
        fnCallBack: fnOpeningCashCallBack,
      ), 'Opening Cash');
    }else{
      // showToast( 'Contact your admin!!');
      PageDialog().show_(context, OpenDrawer(
          fnCallBack:fnOpeningCashOpenSucces
      ), '');

    }

  }
  fnOpeningCashOpenSucces(data,user){
    if(data == '1'){
      PageDialog().showL(context, OpeningCash(
        fnCallBack: fnOpeningCashCallBack,
      ), 'Opening Cash');
    }else{
      showToast( 'PERMISSION DENIED');
    }
  }

  fnOpeningCashCallBack(){

  }

  fnOpenDrawer(){
    if(g.wstrRoleCode == "QADMIN"){
      futureDrawer = apiCall.openDrawer(g.wstrPrinterPath);
    }else{
     // showToast( 'Contact your admin!!');
      PageDialog().show_(context, OpenDrawer(
          fnCallBack:fnSuccess
      ), '');

    }
  }
  fnSuccess(data,user){
    if(data == '1'){
      futureDrawer = apiCall.openDrawer(g.wstrPrinterPath);
    }else{
      showToast( 'PERMISSION DENIED');
    }
  }

  fnOpenClosing(){
    if(g.wstrRoleCode == "QADMIN"){
      fnClockOut();
    }else{
      // showToast( 'Contact your admin!!');
      PageDialog().show_(context, OpenDrawer(
          fnCallBack:fnClosingSuccess
      ), '');

    }
  }
  fnClosingSuccess(data,user){
    if(data == '1'){
      fnClockOut();
    }else{
      showToast( 'PERMISSION DENIED');
    }
  }

  fnOpenCouponIssue(){
    if(g.wstrRoleCode == "QADMIN"){
      fnOpenCoupon();
    }else{
      // showToast( 'Contact your admin!!');
      PageDialog().show_(context, OpenDrawer(
          fnCallBack:fnOpenCouponSuccess
      ), '');

    }
  }
  fnOpenCouponSuccess(data,user){
    if(data == '1'){
      fnOpenCoupon();
    }else{
      showToast( 'PERMISSION DENIED');
    }
  }


  fnChoosePrinter(){
    if(g.wstrRoleCode == "QADMIN"){
      PageDialog().showS(context, PrinterSelection(
      ), 'Choose Printer');
    }else{
      // showToast( 'Contact your admin!!');
      PageDialog().show_(context, OpenDrawer(
          fnCallBack:fnChoosePrinterRes
      ), '');

    }
  }
  fnChoosePrinterRes(data,user){

    if(data == '1'){

      PageDialog().showS(context, PrinterSelection(
      ), 'Choose Printer');
    }else{
      showToast( 'PERMISSION DENIED');
    }
  }

  fnChooseTapDevice(){
    if(g.wstrRoleCode == "QADMIN"){
      PageDialog().showS(context, TapDevices(
      ), 'Choose Device');
    }else{
      // showToast( 'Contact your admin!!');
      PageDialog().show_(context, OpenDrawer(
          fnCallBack:fnChooseTapDeviceRes
      ), '');

    }

  }
  fnChooseTapDeviceRes(data,user){
    if(data == '1'){

      PageDialog().showS(context, TapDevices(
      ), 'Choose Device');
    }else{
      showToast( 'PERMISSION DENIED');
    }
  }
  fnSysytemInfo(){
    PageDialog().showSysytemInfo(context, Container(
      child: Column(

        children: [

          Row(
            children: [
              Icon(Icons.person_outline,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrUserName.toString(),Colors.black,20)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.access_time_outlined,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrShifDescp.toString(),Colors.black,20)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.laptop,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrDeviceName.toString(),Colors.black,20)
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
              Icon(Icons.print,size: 20,color: Colors.black,),
              gapWC(10),
              tc((g.wstrPrinterName + " | " +g.wstrPrinterPath).toString(),Colors.black,20)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.tap_and_play,size: 20,color: Colors.black,),
              gapWC(10),
              tc((g.wstrTapDeviceId + " | " +g.wstrTapDeviceName).toString(),Colors.black,20)
            ],
          )
        ],
      ),
    ), 'System Info');
  }
  fnLogout() async{
    final SharedPreferences prefs = await _prefs;

    prefs.setString('wstrUserCd', '');
    prefs.setString('wstrUserName', '');
    prefs.setString('wstrUserRole', '');
    prefs.setString('wstrCompany', g.wstrCompany);
    prefs.setString('wstrYearcode', g.wstrYearcode);
    prefs.setString('wstrLoginSts', 'N');
    prefs.setString('wstrTableView','');
    prefs.setString('wstrOrderScreenMode',"");

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Login()
    ));
  }
  fnUpdateTime() {
    if (mounted) {
      setState(() {
        var now = DateTime.now();
        lstrTime = formatTimeSecond.format(now);
      });
    }

  }

  fnCheckDocDate(){
    var rtnSts = false;
    var lstrToday;
    var formatClockDate =  DateFormat('yyyy-MM-dd HH:mm:ss');
    if(g.wstrClockInDate != null){
      var checkDate = DateTime.parse(formatClockDate.format(DateTime.parse(g.wstrClockInDate).add(Duration(days:1))));
      //var checkDate = DateTime.parse(formatDate2.format(DateTime.parse(g.wstrClockInDate)));
      var checkDateTime  =  DateTime(checkDate.year,checkDate.month,checkDate.day,4,0,0);
      var now = DateTime.now();
      lstrToday = DateTime.parse(formatClockDate.format(now));
      rtnSts  =  lstrToday.isBefore(checkDateTime);
    }
    return rtnSts;
  }
}
