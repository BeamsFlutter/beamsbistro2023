import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Pages/Bill/printerSelection.dart';
import 'package:beamsbistro/Views/Pages/Kitchen/kitchenSelection.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceStatus extends StatefulWidget {
  const InvoiceStatus({Key? key}) : super(key: key);

  @override
  _InvoiceStatusState createState() => _InvoiceStatusState();
}

class _InvoiceStatusState extends State<InvoiceStatus> {
  //Global
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var g = Global();
  var apiCall = ApiCall();
  late Future<dynamic> futureRslSts;
  late Future<dynamic> futureRslFinish;
  late Future<dynamic> futureKitchen;
  late Future<dynamic> futureRefresh;

  var formatDate = new DateFormat('dd-MM-yyyy hh:mm');
  var formatTime = new DateFormat('hh:mm a');
  var formatTimeSecond = new DateFormat('hh:mm:ss a');


  // ARRAY AND VARIABLES
  var lstrSelectedRslItems = [];
  var lstrSelectedRsl = [];
  var lastOrder = [];
  var lstrRsl = [];
  var lstrRslDet = [];



  var lstrRslVoid = [];
  var lstrRslVoidDet = [];

  //O- ORDERVIEW |
  var sidePageView = "I";
  var lstrTime;

  var lstrSelectedDocno = '';
  var lstrSelectedUser = '';
  var lstrSelectedDate = '';
  var lstrSelectedOrderType = "A";
  var lstrKitchenCode ;
  var lstrKitchenDescp ='' ;
  var pageCount = 0;
  var refreshTime = '';

  late AudioCache _audioCache;
  late Timer timer;
  late Timer timerTime;


  String audioasset = "assets/audio/mytune.mp3";
  bool isplaying = false;
  bool audioplayed = false;
  late Uint8List audiobytes;
  AudioPlayer player = AudioPlayer();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
    sidePageView = "H";
    setState(() {
      lstrSelectedRslItems = [];
      lstrSelectedRsl = [];
      lstrSelectedDocno = '';
      lastOrder = [];
      sidePageView = "I";
    });
    // _audioCache = AudioCache(
    //     prefix: "assets/audio/",
    //     fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));


    Future.delayed(Duration.zero, () async {

      ByteData bytes = await rootBundle.load(audioasset); //load audio from assets
      audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

    });


    timer = Timer.periodic(Duration(seconds: 4), (Timer t) => fnRefresh());
    timerTime =
        Timer.periodic(Duration(seconds: 1), (Timer t) => fnUpdateTime());
    fnGetRslSts(null, null, null, null);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    timerTime.cancel();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    g.wstrContext = this.context;
    return WillPopScope(
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.only(top: 16),
            width: size.width,
            child: Column(
              children: [
                Container(
                  height: size.height * 0.1,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: boxBaseDecoration(Colors.white, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            "assets/icons/bislogo.png",
                            width: 100,
                          ),
                          gapWC(10),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          tc(g.wstrUserName.toString().toUpperCase(), Colors.blue, 16),
                          //gapW(),
                          //tc(lstrTime ?? '', Colors.blueGrey, 16),
                          gapWC(20),
                          tc('KITCHEN DISPLAY | '+ g.wstrShifDescp.toString().toUpperCase(), Colors.blue, 16),
                          gapWC(20),
                          tc(lstrTime??'',Colors.blue,16),
                          gapWC(20),
                          GestureDetector(
                            onTap: (){
                              fnChooseKitchen();
                            },
                            child:  Container(
                              decoration: boxBaseDecoration(PrimaryColor, 60),
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              height: 35,
                              child: Center(
                                  child: Row(
                                    children: [
                                      tc(lstrKitchenDescp,Colors.white,14),
                                      Icon(Icons.arrow_drop_down_outlined,color: Colors.white,)
                                    ],
                                  )
                              ),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     fnChoosePrinter();
                          //   },
                          //   child: Container(
                          //     height: 40,
                          //     width: 50,
                          //     margin: EdgeInsets.symmetric(horizontal: 5),
                          //     decoration: boxBaseDecoration(Colors.amber, 10),
                          //     child: Icon(
                          //       Icons.print,
                          //       color: Colors.black,
                          //       size: 20,
                          //     ),
                          //   ),
                          // ),
                          GestureDetector(
                            onTap: () {
                              fnSysytemInfo();
                            },
                            child: Container(
                              height: 40,
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: boxBaseDecoration(Colors.amber, 10),
                              child: Icon(
                                Icons.computer_sharp,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              fnLogout();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: boxBaseDecoration(greyLight, 10),
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                gapHC(8),
                Container(
                  height: size.height * 0.86,
                  color: Colors.blueGrey,
                  child: Row(
                    children: [
                      // UI Design for card showing order ---> and finish button ====
                      Container(
                        padding: EdgeInsets.all(5),
                        height: size.height * 0.86,
                        width: size.width ,
                        color: Colors.white,
                        child: Container(
                          decoration: boxBaseDecoration(greyLight, 0),
                          width: size.width ,
                          padding: EdgeInsets.all(10),
                          child: FutureBuilder<dynamic>(
                            future: futureRslSts,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return rslStsView(snapshot,size);
                              } else if (snapshot.hasError) {
                                return Container();
                              }
                              // By default, show a loading spinner.
                              return Center(
                                child: Container(),
                              );
                            },
                          ),
                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return true;
        });
  }

  // ========================================= UI WIDGE ============================================================

  Widget rslStsView(snapshot,Size size) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data[index];
          var rsl = dataList['RSL'];
          var rslDet = dataList['RSLDET'];
          var rslVoid = dataList['RSL_VOID'];
          var rslVoidDet = dataList['RSL_VOIDDET'];
          var rslDocNo = '';
          var lstrRslType = '';
          var lstrRslDoctype = '';
          var lstrRslYearcode = '';
          var lstrCreateUser = '';
          var lstrCreateDate = '';
          var lstrNetAmount = '';
          var lstrCustomerName = '';
          var lstrCustomerMob = '';
          var ref1 = '';
          var machine_name = '';
          var orderTime ;
          var createDate;
          if (g.fnValCheck(rsl)) {
            rslDocNo = rsl[0]["DOCNO"];
            lstrRslType = rsl[0]["DOCNO"];
            lstrRslDoctype = rsl[0]["DOCTYPE"];
            lstrRslYearcode = rsl[0]["YEARCODE"];
            lstrCreateUser = rsl[0]["CREATE_USER"]??'';
            lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
            createDate = rsl[0]["CREATE_DATE"]??'';
            lstrNetAmount = rsl[0]["NETAMT"].toString();
            lstrCustomerName = rsl[0]["PARTYNAME"]??'';
            orderTime =formatTime.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
            machine_name = rsl[0]["COUNTER_NO"]??'';
          }


          var timeStatus = fnGetTime(createDate);
          var colorValue= Colors.green;
          var splittime = timeStatus.toString().split(':');
          var min = g.mfnInt(splittime[0]);
           if(min > 30){
            colorValue= Colors.red;
          }else if(min > 15){
            colorValue= Colors.orange;
          }else{
            colorValue= Colors.green;
          }

          var lstrTableNo = '';
          return GestureDetector(
            onTap: () {
              fnRslClick(dataList, rslDocNo);
            },
            child: Container(
              width: 300,
              margin: EdgeInsets.only(right: 5),
              decoration: boxDecoration(lstrSelectedDocno == rslDocNo ? blueLight : Colors.white, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),

                    decoration: boxBaseDecoration(colorValue, 0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            tc('#'+rslDocNo, Colors.white, 15),

                            /* tc(lstrRslType == 'T' ? 'Table   ' + lstrTableNo :
                         lstrRslType == 'A' ? 'Takeaway' :
                         lstrRslType == 'D' ? 'Delivery' : '', Colors.black, 12),*/

                            ts(orderTime.toString(), Colors.white, 12),
                          ],
                        ),
                        gapHC(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_rounded,
                                  size: 13,color: Colors.white,
                                ),
                                gapWC(5),
                                ts(lstrCreateUser, Colors.white, 12),
                                ts(' | ', Colors.white, 12),
                                ts(machine_name, Colors.white, 12),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.access_time_sharp,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                gapWC(5),
                                tc(fnGetTime(createDate).toString(), Colors.white,
                                    15),
                              ],
                            ),
                          ],
                        ),
                        gapHC(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_pin,
                                  size: 13,color: Colors.white,
                                ),
                                gapWC(5),
                                ts(lstrCustomerName.toString(), Colors.white, 11),
                              ],
                            ),
                          ],
                        )


                      ],
                    ),
                  ),

                  // listing of items ---------------- LIST
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 4,vertical: 0),
                      height: size.height*0.6,
                      child: _itemViewList(rslDet)
                  ),
                  GestureDetector(
                    onTap: () {
                      fnFinishRsl(
                          rslDocNo, lstrRslDoctype, lstrRslYearcode);
                    },
                    child: Container(
                      height: 45,
                      decoration: boxGradientDecorationBase(12, 0),
                      child: Center(
                        child: tc('FINISH', Colors.white, 15),
                      ),
                    ),
                  )


                ],
              ),
            ),
          );
        });
  }



  _itemViewList(rslDet) {

    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: rslDet.length,
        itemBuilder: (context, index) {
          var dataList = rslDet[index];
          var lstrOrderNo = dataList["DOCNO"];
          var itemCode = dataList['STKCODE'];
          var itemName = dataList['STKDESCP'];
          var itemQty = dataList['QTY1'].toString();
          var itemStatus = dataList['STATUS'].toString();
          var itemRate = dataList['RATE'].toString();
          var itemTotal = double.parse(itemQty) * double.parse(itemRate);
          var returnSts = dataList['RETURNED_YN'].toString();
          var voidQty = dataList['VOID_QTY'].toString();
          var ref1 = dataList["REF1"];
          return GestureDetector(
            onTap: () {},
            child: itemStatus == 'C'
                ? Container()
                : Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              margin: EdgeInsets.only(bottom: 2),
              decoration: boxBaseDecoration(returnSts == "Y" ? Colors.red : greyLight, 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: tc(
                            (index + 1).toString() + '. ' + itemName.toString(), returnSts == "Y" ? Colors.white : Colors.black, 13),
                      ),
                      Row(
                        children: [
                          /*tc(itemRate.toString(), returnSts == "Y" ? Colors.white : Colors.black, 12),
                          gapW(),*/
                          tc('x   ' + (returnSts == "Y"?voidQty.toString(): itemQty.toString()), returnSts == "Y" ? Colors.white : Colors.black, 13),
                          /*gapW(),
                          gapW(),
                          tc(itemTotal.toString(), returnSts == "Y" ? Colors.white : PrimaryColor, 10),*/
                        ],
                      )
                    ],
                  ),
                  gapHC(2),
                  ref1 == null || ref1 == ""? gapHC(0):
                  ts('Note : '+ref1,returnSts == "Y" ? Colors.white : Colors.black,12),
                ],
              ),
            ),
          );
        });
  }

  // =========================================== PAGE FUNCTION ===========================================================
  fnChoosePrinter() {
    PageDialog().showS(context, PrinterSelection(), 'Choose Printer');
  }

  fnSysytemInfo() {
    PageDialog().showSysytemInfo(
        context,
        Container(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 20,
                    color: Colors.black,
                  ),
                  gapWC(10),
                  tc(g.wstrUserName.toString(), Colors.black, 20)
                ],
              ),
              gapHC(10),
              Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                  gapWC(10),
                  tc(g.wstrShifDescp.toString(), Colors.black, 20)
                ],
              ),
              gapHC(10),
              Row(
                children: [
                  Icon(
                    Icons.laptop,
                    size: 20,
                    color: Colors.black,
                  ),
                  gapWC(10),
                  tc(g.wstrDeviceName.toString(), Colors.black, 20)
                ],
              ),
              gapHC(10),
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                  gapWC(10),
                  tc(g.wstrDeivceId.toString(), Colors.black, 20)
                ],
              ),
              gapHC(10),
              Row(
                children: [
                  Icon(
                    Icons.print,
                    size: 20,
                    color: Colors.black,
                  ),
                  gapWC(10),
                  Expanded(
                      child: tc(
                          (g.wstrPrinterName + " | " + g.wstrPrinterPath)
                              .toString(),
                          Colors.black,
                          20))
                ],
              )
            ],
          ),
        ),
        'System Info');
  }

  fnLogout() async {
    Navigator.pop(context);
    /*   final SharedPreferences prefs = await _prefs;

    prefs.setString('wstrUserCd', '');
    prefs.setString('wstrUserName', '');
    prefs.setString('wstrUserRole', '');
    prefs.setString('wstrCompany', g.wstrCompany);
    prefs.setString('wstrYearcode', g.wstrYearcode);
    prefs.setString('wstrLoginSts', 'N');
    prefs.setString('wstrTableView', '');
    prefs.setString('wstrOrderScreenMode', "");

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));*/
  }

  fnRslClick(dataList, code) {
    setState(() {
      lastOrder = [];
    });

    fnClear();
    var rsl = dataList['RSL'];
    var rslDet = dataList['RSLDET'];
    var lstrCreateUser = rsl[0]["CREATE_USER"];

    setState(() {
      lstrSelectedDocno = code ?? '';
      lstrSelectedRsl = rsl;
      lstrSelectedRslItems = rslDet;
      lstrSelectedUser = lstrCreateUser ?? '';
      lstrSelectedDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"].toString()));
    });
  }

  fnClear() {
    setState(() {
      lastOrder = [];
      lstrSelectedRslItems = [];
      lstrSelectedDocno = '';
      lstrSelectedDate = '';
    });
  }

  fnGetPageData(){

    setState(() {
      lstrKitchenCode =  g.wstrSelectedkitchen;
      lstrKitchenDescp =  g.wstrSelectedkitchenDescp;
    });

  }

  fnGetTime(time) {
    //print(time);
    var billTime = DateTime.parse(time);
    var now = DateTime.now();
    var diffrence = now.difference(billTime).inSeconds;
    // var minutes = diffrence / 60;
    double minutes = (diffrence / 60);
    double minutesStr = ((minutes % 1) * 60);
    String mmss =
        minutes.toInt().toString() + ':' + minutesStr.toInt().toString();
    return mmss;
  }
  fnRefresh() {
    fnPageRefresh();
  }

  fnUpdateTime() {
    if (mounted) {
      setState(() {
        var now = DateTime.now();
        lstrTime = formatTimeSecond.format(now);
      });
    }

  }


  // =========================================== API CALL ==============================================================
  fnGetRslSts(code, type, dateFrom, dateTo) async {
    futureRslSts = apiCall.getInvoice(g.wstrCompany, g.wstrYearcode, code, type,
        dateFrom, dateTo, g.wstrUserCd, 'Y',lstrKitchenCode,'',"",1);
    futureRslSts.then((value) => fnGetRslStsSuccess(value));
  }

  fnGetRslStsSuccess(value) {
    setState(() {
    });
  }

  fnFinishRsl(docno, doctype, yearcode) {
    futureRslFinish =
        apiCall.rslFinishSts(docno, doctype, yearcode, g.wstrCompany);
    futureRslFinish.then((value) => fnFinishRslSuccess(value));
  }

  fnFinishRslSuccess(value) {
    fnGetRslSts(null, null, null, null);
  }



  fnChooseKitchen(){
    PageDialog().showS(context, KitchenSelection(
      fnCallBack: fnUpdateKitchen,
    ), 'Choose Kitchen');
  }
  fnUpdateKitchen(){
    setState(() {
      lstrKitchenCode = g.wstrSelectedkitchen;
      lstrKitchenDescp = g.wstrSelectedkitchenDescp;
    });
    fnGetRslSts(null, null, null, null);

  }


  fnPageRefresh() {
    futureRefresh = apiCall.pageRefresh(
        g.wstrCompany, g.wstrYearcode, "CASHIER", refreshTime);
    futureRefresh.then((value) => fnPageRefreshSuccess(value));
  }

  fnPageRefreshSuccess(value) {
    var count = 0;
    var timeK = '';
    if (g.fnValCheck(value)) {
      count = value[0]["COUNT"];
      timeK = (value[0]["TIME"]??"");
    } else {
      timeK = refreshTime;
      count = pageCount;
    }

    if (pageCount != count && count !=0) {
      //_audioCache.play('mytune.mp3');
      player.setSourceBytes(audiobytes);
    }
    if (pageCount != count) {
      fnGetRslSts(null, null, null, null);
    }


    if(mounted){
      setState(() {
        refreshTime = timeK;
        pageCount = count;
      });
    }

  }


}
