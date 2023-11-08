
import 'dart:io';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/lookup.dart';
import 'package:beamsbistro/Views/Components/lookup_alert.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Components/alertDialog.dart';
import '../Bill/printerSelection.dart';


class ReportViewer extends StatefulWidget {
  final String? mode;
  final String? bookingNo;
  final String? bookingDoctype;
  final Function? fnCallBack;
  final Function? fnCallBackVoid;
  final datalist;
  final double? advanceAmount;
  const ReportViewer({Key? key, this.mode, this.fnCallBack, this.datalist, this.bookingNo, this.bookingDoctype, this.advanceAmount, this.fnCallBackVoid}) : super(key: key);

  @override
  _ReportViewerState createState() => _ReportViewerState();
}

class _ReportViewerState extends State<ReportViewer> {

  //Page Variable

  //Global
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Global g =  Global();
  ApiCall apiCall  = ApiCall();

  late Future<dynamic>  futureGetReports;
  late Future<dynamic>  futurePrintReport;
  late Future<dynamic>  futureRoom;
  late Future<dynamic>  futureVoid;
  late Future<dynamic>  futureFinancial;

  DateTime currentDate = DateTime.now();
  DateTime?  currentDate_From;
  DateTime?  currentDate_To ;

  var formatDate = new DateFormat('dd MMM yyyy');
  var formatDate2 = new DateFormat('dd-MM-yyyy');
  var formatDate3 = new DateFormat('dd-MM-yyyy hh:mm:ss a');
  var formatDate1 = new DateFormat('yyyy-MM-dd hh:mm:ss');

  var lstrSelectedReports  = 'QR';
  var lstrSelectedFinancial = "TR";

  var lstrQuickReportData  = [];
  var lstrPaymentModeData = [];


  //Quick Report

  var lstrNoOfBills= 0;
  var lstrOpeningCash = 0.0;
  var lstrGrossAmount = 0.0;
  var lstrDiscountAmount = 0.0;
  var lstrAddlAmount = 0.0;
  var lstrVoidAmount = 0.0;
  var lstrTotalSales = 0.0;
  var lstrCash = 0.0;
  var lstrCard = 0.0;
  var lstrCredit = 0.0;

  var lstrGDineCount  = 0;
  var lstrGDineAmt  = 0.0;
  var lstrGTakeCount  = 0;
  var lstrGTakeAmt  = 0.0;
  var lstrGDeliveryCount  = 0;
  var lstrGDeliveryAmt  = 0.0;

  var lstrRDineCount  = 0;
  var lstrRDineAmt  = 0.0;
  var lstrRTakeCount  = 0;
  var lstrRTakeAmt  = 0.0;
  var lstrRDeliveryCount  = 0;
  var lstrRDeliveryAmt  = 0.0;


  var lstrFilterMode = false;

  //Room Report
  var lstrRoomSalesData = [];
  var lstrRoomSaleTotal = 0.0;
  var lstrRoomSummaryYn = false;

  var txtRoomCode =  TextEditingController();
  var lstrToday ;
  var lstrYesterday ;


  //VOID REPORT
   var lstrVoidData=[];




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var now = DateTime.now();
    var yes = DateTime.now().subtract(Duration(days:1));
    lstrToday = DateTime.parse(formatDate1.format(now));
    lstrYesterday = DateTime.parse(formatDate1.format(yes));
    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    Size size  = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: boxDecoration(Colors.white, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/icons/bislogo.png",
                        width: 80,),
                      gapWC(10),
                      tcn('Reports', Colors.black, 25)
                    ],
                  ),
                  gapWC(10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.person,size: 20,),
                      gapWC(5),
                      tc(g.wstrUserName.toString(), Colors.black, 15),
                      gapWC(15),
                      // Bounce(
                      //   duration: Duration(milliseconds: 110),
                      //   onPressed: (){
                      //     fnGetFinancialReport();
                      //   },
                      //   child: Container(
                      //     height: 40,
                      //     margin: EdgeInsets.symmetric(horizontal: 5),
                      //
                      //     decoration: boxBaseDecoration(Colors.green, 5),
                      //     child: Row(
                      //       children: [
                      //         gapWC(10),
                      //         tcn('Financial', Colors.white, 15),
                      //         gapWC(10),
                      //         Icon(Icons.print,color: Colors.white,size: 18,),
                      //         gapWC(10),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      gapWC(15),
                      Bounce(
                        duration: Duration(milliseconds: 110),
                        onPressed: (){
                          fnChoosePrinter();
                        },
                        child: Container(
                          height: 40,
                          width: 50,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: boxBaseDecoration(Colors.amber, 5),
                          child: Icon(Icons.print,color: Colors.black,size: 20,),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          fnSysytemInfo();
                        },
                        child: Container(
                          height: 40,
                          width: 50,
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          decoration: boxBaseDecoration(Colors.amber, 5),
                          child: Icon(Icons.computer_sharp,color: Colors.black,size: 20,),
                        ),
                      ),
                      gapWC(10),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          width: 50,
                          margin: EdgeInsets.symmetric(horizontal: 1),
                          decoration: boxBaseDecoration(greyLight, 5),
                          child: Icon(Icons.cancel_outlined,color: Colors.black,size: 25,)
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: (){
                      //     Navigator.pop(context);
                      //   },
                      //   child: Icon(Icons.cancel_outlined,color: Colors.black,size: 25,),
                      // ),
                      gapWC(10),
                    ],
                  )
                ],
              ),
            ),
            gapHC(10),
            Expanded(
                child:Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          padding: EdgeInsets.all( 10),
                          height: size.height,
                          width: size.width*0.7,
                          decoration: boxBaseDecoration(greyLight, 0),
                          child: SingleChildScrollView(
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.desktop_mac,size: 16,color: Colors.black,),
                                    gapWC(10),
                                    tc(mfnLng('Counter Reports'), Colors.black, 15),
                                  ],
                                ),
                                gapHC(5),
                                line(),
                                gapHC(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    getReportCards1(size,"assets/icons/wallet.png",'FINANCIAL REPORT','DR'),
                                    getReportCards(size,"assets/icons/quick.png",'QUICK REPORT','QR'),
                                    getReportCards(size,"assets/icons/sales.png",'SALES REPORT','SR'),


                                  ],
                                ),
                                gapHC(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    getReportCards(size,"assets/icons/room.png",'ROOM WISE REPORT','RR'),
                                    getReportCards(size,"assets/icons/ordertype.png",'ORDER TYPE REPORT','OR'),
                                    getReportCards(size,"assets/icons/wallet.png",'PAYMENT MODE REPORT','PR'),

                                  ],
                                ),
                                gapHC(30),
                                Row(
                                  children: [
                                    Icon(Icons.admin_panel_settings,size: 16,color: Colors.black,),
                                    gapWC(10),
                                    tc('Admin Reports', Colors.black, 15),
                                  ],
                                ),
                                gapHC(5),
                                line(),
                                gapHC(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    getReportCards(size,"assets/icons/room.png",'ROOM SALES REPORT','AR'),
                                    getReportCards(size,"assets/icons/room.png",'ROOM SUMMARY REPORT','RS'),
                                    getReportCards(size,"assets/icons/file.png",'VOID REPORT','VR'),

                                  ],
                                ),
                              ],
                            ),
                          )
                      ),
                      Expanded(child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: boxDecoration(Colors.white, 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            
                            lstrFilterMode?
                            Expanded(child:
                              Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      lstrSelectedReports == "AR"?
                                      RoundedInputField(
                                        hintText: mfnLng('Room'),
                                        labelYn: 'Y',
                                        txtRadius: 5,
                                        txtController: txtRoomCode,
                                        txtWidth: 0.25,
                                        suffixIcon: Icons.search ,
                                        suffixIconOnclick: () {
                                          fnLookup('ROOM','');
                                        },
                                        onChanged: (value) {
                                          fnLookup('ROOM','') ;
                                        },
                                      ):gapHC(0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              tcn(mfnLng('Date From'), Colors.black, 12),
                                              gapHC(5),
                                              GestureDetector(
                                                onTap: (){
                                                  _selectDate_Drawer(context,'F');
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  //height: 35,
                                                  width: size.width*0.12,
                                                  //  height: 35,
                                                  decoration: boxDecoration(Colors.white, 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Icon(Icons.event_sharp, size: 20,),
                                                      tcn(currentDate_From == null
                                                          ? ''
                                                          : formatDate2.format(currentDate_From!).toString(),Colors.black,13),

                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          gapWC(10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              tcn(mfnLng('Date To'), Colors.black, 12),
                                              gapHC(5),

                                              GestureDetector(
                                                onTap: (){
                                                  _selectDate_Drawer(context,'T');
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8),
                                                  //height: 35,
                                                  width: size.width*0.12,
                                                  //height: 35,
                                                  decoration: boxDecoration(Colors.white, 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Icon(Icons.event_sharp, size: 20,),
                                                      tcn(currentDate_To == null
                                                          ? ''
                                                          : formatDate2.format(currentDate_To!).toString(),Colors.black,12)
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                              )
                            ):
                            Expanded(
                                child: lstrSelectedReports == "QR"?  QuickOrder():
                                lstrSelectedReports == "SR"?
                                SalesReport():
                                lstrSelectedReports == "PR"?
                                PaymentReport():
                                lstrSelectedReports == "OR"?
                                OrderTypeReport():
                                lstrSelectedReports == "RR"?
                                RoomWiseReport():
                                lstrSelectedReports == "AR"?
                                RoomSalesReport():
                                lstrSelectedReports == "VR"?
                                VoidReport():
                                lstrSelectedReports == "DR"?
                                FinancialReport():
                                Container()

                            ),
                            lstrFilterMode?
                            Bounce(
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.all(5),
                                decoration: boxGradientDecoration(16, 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.filter_alt_rounded,color: Colors.white,size: 20,),
                                    gapWC(10),
                                    tcn(mfnLng('APPLY'), Colors.white, 18)
                                  ],
                                ),
                              ),
                              duration: Duration(milliseconds: 110),
                              onPressed: (){

                                if(lstrSelectedReports == "AR"){
                                  setState((){
                                    lstrFilterMode =false;
                                  });
                                  fnGetRoomReport();
                                } if(lstrSelectedReports == "VR"){
                                  setState((){
                                    lstrFilterMode =false;
                                  });
                                  fnGetVoidReport();

                                }else{
                                  setState((){
                                    lstrFilterMode =false;
                                  });
                                }
                              },
                            ):
                            Row(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Bounce(
                                      onPressed: (){
                                        setState((){

                                          if(lstrFilterMode){
                                            lstrFilterMode = false;
                                          }else{
                                            lstrFilterMode = true;
                                          }
                                        });
                                      },
                                      duration: Duration(milliseconds: 110),
                                      child: Container(
                                        height: 50,
                                        width: 100,
                                        decoration: boxDecoration(Colors.white, 30),
                                        child: Icon(Icons.filter_alt,color: Colors.black,size: 20,),
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(child: Bounce(
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.all(5),
                                    decoration: boxGradientDecoration(16, 30),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.print,color: Colors.white,size: 20,),
                                        gapWC(10),
                                        tcn(mfnLng('PRINT'), Colors.white, 18)
                                      ],
                                    ),
                                  ),
                                  duration: Duration(milliseconds: 110),
                                  onPressed: (){
                                    fnPrint(lstrSelectedReports);
                                  },
                                ))
                              ],
                            )

                          ],
                        ),
                      ))
                    ],
                  ),
                )
            )

          ],
        ),
      ),
    );
  }

  //==========================WIDGET==========================

  Widget getReportCards(size,icon,title,mode){
    return Bounce(
      child: Container(
        height: 100,
        width:  size.width*0.22,
        decoration: boxDecoration( lstrSelectedReports == mode?Colors.amber  : Colors.white, 10),
        child: Column(
          children: [
            gapHC(15),
            Image.asset(icon,
              width: 30,),
            gapHC(15),
            Container(
              height: 5,
              decoration: boxBaseDecoration(greyLight, 0),
            ),

            Expanded(
              child: Container(
                  height: 10,
                  child: Center(
                    child: tcn(title, Colors.black, 13),
                  )
              ),)

          ],
        ),
      ),
      duration: Duration(milliseconds: 110),
      onPressed: (){
          setState((){
            lstrFilterMode =false;
           lstrSelectedReports = mode;
          });
          if(mode == "QR" || mode == "SR" || mode == "PR" || mode == "OR"|| mode == "RR"){
            fnGetQuickReports();
          }else if(mode == "AR"){
            fnGetRoomReport();
          }else if(mode == "VR"){
            fnGetVoidReport();
          }
      },
    );
  }
  Widget getReportCards1(size,icon,title,mode){
    return Bounce(
      child: Container(
        height: 100,
        width:  size.width*0.22,
        decoration: boxDecoration( Colors.green, 10),
        child: Column(
          children: [
            gapHC(15),
            Icon(Icons.account_balance_rounded,size: 30,color: Colors.white,),
            gapHC(15),
            Container(
              height: 5,
              decoration: boxBaseDecoration(Colors.white, 0),
            ),

            Expanded(
              child: Container(
                  height: 10,
                  child: Center(
                    child: tcn(mfnLng(title), Colors.white, 13),
                  )
              ),)

          ],
        ),
      ),
      duration: Duration(milliseconds: 110),
      onPressed: (){
        setState((){
          lstrFilterMode =false;
          lstrSelectedReports = mode;
        });
        if(mode == "QR" || mode == "SR" || mode == "PR" || mode == "OR"|| mode == "RR"){
          fnGetQuickReports();
        }else if(mode == "AR"){
          fnGetRoomReport();
        }else if(mode == "VR"){
          fnGetVoidReport();
        }
      },
    );
  }
  Widget getRow(icon,text){
    return Row(
      children: [
        Icon(icon,size: 15,),
        gapWC(5),
        tcn(text, Colors.black, 13)
      ],
    );
  }
  List<Widget> getQuickPaymentDet(){
    List<Widget> resultData = [];
    lstrPaymentModeData.forEach((e) {
      resultData.add(
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                tcn(e["PAYMODE"], Colors.black, 13),
                tc(e["AMT"].toString(), Colors.black, 13),
              ],
            ),
            gapHC(5),
          ],
        )
      );
    });

    return resultData;

  }

  Widget QuickOrder(){
    return Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapHC(10),
              Row(
                children: [
                  Icon(Icons.notes_outlined,size: 18,),
                  gapWC(5),
                  tc(mfnLng('QUICK REPORT'), Colors.black, 15),
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              getRow(Icons.person,g.wstrUserName.toString()),
              gapHC(5),
              getRow(Icons.laptop,g.wstrDeviceName.toString().toString()),
              gapHC(5),
              getRow(Icons.access_time_outlined ,formatDate3.format(DateTime.parse(g.wstrClockInDate )).toString().toString()),
              gapHC(5),
              line(),
              gapHC(5),
              tc(mfnLng('SALES SUMMARY'), Colors.black, 14),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('NO OF BILLS'), Colors.black, 13),
                  tc(lstrNoOfBills.toString(), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('GROSS AMOUNT'), Colors.black, 13),
                  tc(lstrGrossAmount.toStringAsFixed(2), Colors.black, 13)
                ],
              ),

              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DISCOUNT AMOUNT'), Colors.black, 13),
                  tc(lstrDiscountAmount.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('ADDL. AMOUNT'), Colors.black, 13),
                  tc(lstrAddlAmount.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('VOID AMOUNT'), Colors.black, 13),
                  tc(lstrVoidAmount.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('TOTAL SALES'), Colors.black, 13),
                  tc(lstrTotalSales.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('SALES CASH'), Colors.black, 13),
                  tc((lstrCash).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('OPENING CASH'), Colors.black, 13),
                  tc(lstrOpeningCash.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('CASH IN HAND'), Colors.black, 13),
                  tc((lstrOpeningCash+lstrCash).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(10),
              tc(mfnLng('PAYMENT DETAILS'), Colors.black, 14),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('CASH'), Colors.black, 13),
                  tc((lstrCash).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('CREDIT'), Colors.black, 13),
                  tc(lstrCredit.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('CARD'), Colors.black, 13),
                  tc(lstrCard.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              line(),
              gapHC(10),
              tc(mfnLng('CARD DETAILS'), Colors.black, 14),
              gapHC(5),
              line(),
              gapHC(5),

              Column(
                children: getQuickPaymentDet(),
              ),
              gapHC(5),
              line(),
              gapHC(5),
            ],
          ),
        )
    );
  }
  Widget SalesReport(){
    return Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapHC(10),
              Row(
                children: [
                  Icon(Icons.notes_outlined,size: 18,),
                  gapWC(5),
                  tc(mfnLng('SALES REPORT'), Colors.black, 15),
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              getRow(Icons.person,g.wstrUserName.toString()),
              gapHC(5),
              getRow(Icons.laptop,g.wstrDeviceName.toString().toString()),
              gapHC(5),
              getRow(Icons.access_time_outlined ,formatDate3.format(DateTime.parse(g.wstrClockInDate )).toString().toString()),
              gapHC(5),
              line(),
              gapHC(5),
              tc(mfnLng('SALES SUMMARY'), Colors.black, 14),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('NO OF BILLS'), Colors.black, 13),
                  tc(lstrNoOfBills.toString(), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('GROSS AMOUNT'), Colors.black, 13),
                  tc(lstrGrossAmount.toStringAsFixed(2), Colors.black, 13)
                ],
              ),

              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DISCOUNT AMOUNT'), Colors.black, 13),
                  tc(lstrDiscountAmount.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('ADDL. AMOUNT'), Colors.black, 13),
                  tc(lstrAddlAmount.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('VOID AMOUNT'), Colors.black, 13),
                  tc(lstrVoidAmount.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('TOTAL SALES'), Colors.black, 13),
                  tc(lstrTotalSales.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
            ],
          ),
        )
    );
  }
  Widget PaymentReport(){
    return Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapHC(10),
              Row(
                children: [
                  Icon(Icons.notes_outlined,size: 18,),
                  gapWC(5),
                  tc(mfnLng('PAYMENT REPORT'), Colors.black, 15),
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              getRow(Icons.person,g.wstrUserName.toString()),
              gapHC(5),
              getRow(Icons.laptop,g.wstrDeviceName.toString().toString()),
              gapHC(5),
              getRow(Icons.access_time_outlined ,formatDate3.format(DateTime.parse(g.wstrClockInDate )).toString().toString()),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('TOTAL SALES'), Colors.black, 13),
                  tc(lstrTotalSales.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('SALES CASH'), Colors.black, 13),
                  tc((lstrCash).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('OPENING CASH'), Colors.black, 13),
                  tc(lstrOpeningCash.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('CASH IN HAND'), Colors.black, 13),
                  tc((lstrOpeningCash+lstrCash).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(10),
              tc(mfnLng('PAYMENT DETAILS'), Colors.black, 14),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('PAYMENT DETAILS'), Colors.black, 13),
                  tc((lstrCash).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('CREDIT'), Colors.black, 13),
                  tc(lstrCredit.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('CARD'), Colors.black, 13),
                  tc(lstrCard.toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              line(),
              gapHC(10),
              tc(mfnLng('CARD DETAILS'), Colors.black, 14),
              gapHC(5),
              line(),
              gapHC(5),

              Column(
                children: getQuickPaymentDet(),
              ),
              gapHC(5),
              line(),
              gapHC(5),
            ],
          ),
        )
    );
  }
  Widget OrderTypeReport(){
    return Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapHC(10),
              Row(
                children: [
                  Icon(Icons.notes_outlined,size: 18,),
                  gapWC(5),
                  tc(mfnLng('ORDER TYPE REPORT'), Colors.black, 15),
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              getRow(Icons.person,g.wstrUserName.toString()),
              gapHC(5),
              getRow(Icons.laptop,g.wstrDeviceName.toString().toString()),
              gapHC(5),
              getRow(Icons.access_time_outlined ,formatDate3.format(DateTime.parse(g.wstrClockInDate )).toString().toString()),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('GENERAL ORDER'), Colors.black, 13),
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('ORDER COUNT'), Colors.black, 13),
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DINE IN'), Colors.black, 13),
                  tc((lstrGDineCount).toString(), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('TAKEAWAY'), Colors.black, 13),
                  tc((lstrGTakeCount).toString(), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DELIVERY'), Colors.black, 13),
                  tc((lstrGDeliveryCount).toString(), Colors.black, 13)
                ],
              ),

              gapHC(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('ORDER AMOUNT'), Colors.black, 13),
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DINE IN'), Colors.black, 13),
                  tc((lstrGDineAmt).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('TAKEAWAY'), Colors.black, 13),
                  tc((lstrGTakeAmt).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DELIVERY'), Colors.black, 13),
                  tc((lstrGDeliveryAmt).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('ROOM SERVICE ORDER'), Colors.black, 13),
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('ORDER COUNT'), Colors.black, 13),
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DINE IN'), Colors.black, 13),
                  tc((lstrRDineCount).toString(), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('TAKEAWAY'), Colors.black, 13),
                  tc((lstrRTakeCount).toString(), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DELIVERY'), Colors.black, 13),
                  tc((lstrRDeliveryCount).toString(), Colors.black, 13)
                ],
              ),
              gapHC(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('ORDER AMOUNT'), Colors.black, 13),
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DINE IN'), Colors.black, 13),
                  tc((lstrRDineAmt).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('TAKEAWAY'), Colors.black, 13),
                  tc((lstrRTakeAmt).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DELIVERY'), Colors.black, 13),
                  tc((lstrRDeliveryAmt).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('TOTAL ORDER'), Colors.black, 13),
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('NO OF BILLS'), Colors.black, 13),
                  tc((lstrNoOfBills).toString(), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('TOTAL AMOUNT'), Colors.black, 13),
                  tc((lstrTotalSales).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
            ],
          ),
        )
    );
  }
  Widget RoomWiseReport(){
    return Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapHC(10),
              Row(
                children: [
                  Icon(Icons.notes_outlined,size: 18,),
                  gapWC(5),
                  tc(mfnLng('ROOM SERVICE REPORT'), Colors.black, 15),
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              getRow(Icons.person,g.wstrUserName.toString()),
              gapHC(5),
              getRow(Icons.laptop,g.wstrDeviceName.toString().toString()),
              gapHC(5),
              getRow(Icons.access_time_outlined ,formatDate3.format(DateTime.parse(g.wstrClockInDate )).toString().toString()),

              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('ROOM SERVICE ORDER'), Colors.black, 13),
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('ORDER COUNT'), Colors.black, 13),
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DINE IN'), Colors.black, 13),
                  tc((lstrRDineCount).toString(), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('TAKEAWAY'), Colors.black, 13),
                  tc((lstrRTakeCount).toString(), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DELIVERY'), Colors.black, 13),
                  tc((lstrRDeliveryCount).toString(), Colors.black, 13)
                ],
              ),
              gapHC(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('ORDER AMOUNT'), Colors.black, 13),
                ],
              ),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DINE IN'), Colors.black, 13),
                  tc((lstrRDineAmt).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('TAKEAWAY'), Colors.black, 13),
                  tc((lstrRTakeAmt).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('DELIVERY'), Colors.black, 13),
                  tc((lstrRDeliveryAmt).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tc(mfnLng('TOTAL ORDER'), Colors.black, 13),
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('NO OF BILLS'), Colors.black, 13),
                  tc((lstrRDineCount+lstrRTakeCount+lstrRDeliveryCount).toString(), Colors.black, 13)
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children: [
                  tcn(mfnLng('TOTAL AMOUNT'), Colors.black, 13),
                  tc((lstrRDineAmt+lstrRTakeAmt+lstrRDeliveryAmt).toStringAsFixed(2), Colors.black, 13)
                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),
            ],
          ),
        )
    );
  }

  Widget RoomSalesReport(){
    return Container(
        padding: EdgeInsets.all(10),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapHC(10),
            Row(
              children: [
                Icon(Icons.notes_outlined,size: 18,),
                gapWC(5),
                tc(mfnLng('ROOM SALES REPORT'), Colors.black, 15),
              ],
            ),
            gapHC(5),
            line(),
            gapHC(5),
            getRow(Icons.person,g.wstrUserName.toString()),
            gapHC(5),
            getRow(Icons.laptop,g.wstrDeviceName.toString().toString()),
            gapHC(5),
            getRow(Icons.access_time_outlined ,formatDate3.format(DateTime.parse(g.wstrClockInDate )).toString().toString()),

            gapHC(5),
            line(),
            gapHC(5),
            Expanded(child: SingleChildScrollView(child: Column(
              children: getRoomCard(),
            ),)),
            gapHC(5),
            line(),
            gapHC(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
              children: [
                tcn(mfnLng('TOTAL AMOUNT'), Colors.black, 13),
                tc((lstrRoomSaleTotal).toStringAsFixed(2), Colors.black, 13)
              ],
            ),
            gapHC(5),
            line(),
            gapHC(5),
            Row(
              children: [
                Checkbox(
                    activeColor: Colors.green,
                    value: lstrRoomSummaryYn,
                    onChanged: (value) {
                      setState((){
                        lstrRoomSummaryYn =lstrRoomSummaryYn?false:true;
                      });
                    }),
                tcn(mfnLng("SUMMARY REPORT"), Colors.black, 12)
              ],
            ),
            gapHC(5),
            line(),
            gapHC(5),
          ],
        )
    );
  }
  Widget VoidReport(){
    return Container(
        padding: EdgeInsets.all(10),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapHC(10),
            Row(
              children: [
                Icon(Icons.notes_outlined,size: 18,),
                gapWC(5),
                tc(mfnLng('VOID REPORT'), Colors.black, 15),
              ],
            ),
            gapHC(5),
            line(),
            gapHC(5),
            getRow(Icons.person,g.wstrUserName.toString()),
            gapHC(5),
            getRow(Icons.laptop,g.wstrDeviceName.toString().toString()),
            gapHC(5),
            getRow(Icons.access_time_outlined ,formatDate3.format(DateTime.parse(g.wstrClockInDate )).toString().toString()),

            gapHC(5),
            line(),
            gapHC(5),
            Expanded(child: SingleChildScrollView(child: Column(
              children: getVoidCard(),
            ),)),
            gapHC(5),
            line(),
            gapHC(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
              children: [
                tcn(mfnLng('TOTAL AMOUNT'), Colors.black, 13),
                tc((lstrRoomSaleTotal).toStringAsFixed(2), Colors.black, 13)
              ],
            ),
            gapHC(5),
            line(),
            gapHC(5),
          ],
        )
    );
  }
  Widget FinancialReport(){
    return Container(
        padding: EdgeInsets.all(10),
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapHC(10),
            Row(
              children: [
                Icon(Icons.notes_outlined,size: 18,),
                gapWC(5),
                tc(mfnLng('FINANCIAL REPORT'), Colors.black, 15),
              ],
            ),
            gapHC(5),
            line(),
            gapHC(5),
            getRow(Icons.person,g.wstrUserName.toString()),
            gapHC(5),
            getRow(Icons.laptop,g.wstrDeviceName.toString().toString()),
            gapHC(5),
            getRow(Icons.access_time_outlined ,formatDate3.format(DateTime.parse(g.wstrClockInDate )).toString()),

            gapHC(5),
            line(),
            gapHC(5),
            Expanded(child: Column(
              children: [
                financialCard('Current Shift Report',"CR"),
                financialCard('Today Report',"TR"),
                financialCard('Date wise Report',"DR"),
                lstrSelectedFinancial == "DR"?
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tcn(mfnLng('Select Date'), Colors.black, 12),
                    gapHC(5),

                    GestureDetector(
                      onTap: (){
                        _selectDate_Drawer(context,'T');
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        //height: 35,
                        decoration: boxDecoration(Colors.white, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.event_sharp, size: 20,),
                            tcn(currentDate_To == null
                                ? ''
                                : formatDate2.format(currentDate_To!).toString(),Colors.black,12)
                          ],
                        ),
                      ),
                    )
                  ],
                ):gapHC(0),


              ],
            )),


          ],
        )
    );
  }

  Widget financialCard(text,mode){
    return Bounce(
      onPressed: (){
        if(mounted){
          setState(() {
            lstrSelectedFinancial = mode;
          });
        }
      },
      duration: Duration(milliseconds: 110),
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: boxDecoration(lstrSelectedFinancial == mode?Colors.amber: Colors.white, 10),
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(),
            tcn(mfnLng(text), Colors.black, 10),
          ],
        ),

      ),
    );
  }

  List<Widget> getRoomCard(){
    List<Widget> returnList = [];

    var amount = 0.0;
    lstrRoomSalesData.forEach((e) {
      returnList.add(
        Container(
          decoration: boxDecoration(Colors.white, 0),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            children: [
              Row(
                children: [

                  tc("#"+e["DOCNO"].toString(), Colors.black, 12)
                ],
              ),
              Row(
                children: [
                  Icon(Icons.meeting_room_rounded,size: 13,),
                  gapWC(10),
                  tcn("ROOM "+ e["ORDER_ROOM"].toString() , Colors.black, 12)
                ],
              ),
              e["ORDER_REF"].toString() != ""?
              Row(
                children: [
                  Icon(Icons.credit_card,size: 13,),
                  gapWC(10),
                  tcn(e["ORDER_REF"].toString() , Colors.black, 12)
                ],
              ):gapHC(0),
              Row(
                children: [
                  Icon(Icons.date_range,size: 13,),
                  gapWC(10),
                  tcn(formatDate3.format(DateTime.parse(e["CREATE_DATE"].toString())), Colors.black, 12)
                ],
              ),
              gapHC(10),
              Row(
                children: [
                  Icon(Icons.food_bank_outlined,size: 13,),
                  gapWC(10),
                  Expanded(child: tcn(e["STKDESCP"].toString() + "  x  "+e["QTY1"].toString(), Colors.black, 12),)
                ],
              ),
              Row(
                children: [
                  Icon(Icons.money,size: 13,),
                  gapWC(10),
                  Expanded(child: tcn(e["AMOUNT"].toString(), Colors.red, 12),)
                ],
              ),

            ],
          ),
        )
      );
      amount = amount+g.mfnDbl(e["AMOUNT"]);
    });
    lstrRoomSaleTotal = amount;
    return returnList;
  }
  List<Widget> getVoidCard(){
    List<Widget> returnList = [];

    var amount = 0.0;
    lstrVoidData.forEach((e) {
      returnList.add(
        Container(
          decoration: boxDecoration(Colors.white, 0),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 5),
          child: Column(
            children: [
              Row(
                children: [

                  tc("#"+e["DOCNO"].toString(), Colors.black, 12)
                ],
              ),
              Row(
                children: [
                  Icon(Icons.date_range,size: 13,),
                  gapWC(10),
                  tcn(formatDate3.format(DateTime.parse(e["DOCDATE"].toString())), Colors.black, 12)
                ],
              ),
              gapHC(10),
              Row(
                children: [
                  Icon(Icons.food_bank_outlined,size: 13,),
                  gapWC(10),
                  Expanded(child: tcn(e["STKDESCP"].toString() , Colors.black, 12),)
                ],
              ),
              Row(
                children: [
                  Icon(Icons.delete_sweep_outlined,size: 13,),
                  gapWC(10),
                  Expanded(child: tcn("${mfnLng("VOID QTY")} : "+e["VOID_QTY"].toString(), Colors.red, 12),)
                ],
              ),
              Row(
                children: [
                  Icon(Icons.speaker_notes,size: 13,),
                  gapWC(10),
                  Expanded(child: tcn("${mfnLng("VOID REASON")} : "+(e["VOID_REASON_DESCP"]??"").toString(), Colors.red, 12),)
                ],
              ),
              Row(
                children: [
                  Icon(Icons.person,size: 13,),
                  gapWC(10),
                  Expanded(child: tcn(e["VOID_USER"].toString(), Colors.black, 12),)
                ],
              ),

            ],
          ),
        )
      );
      amount = amount+g.mfnDbl(e["AMOUNT"]);
    });
    lstrRoomSaleTotal = amount;
    return returnList;
  }

  //=======================PAGE FN====================================
  Future<void> _selectDate_Drawer(BuildContext context,var tag) async {

    if(tag=='F'){
      final DateTime? pickedDate = await showDatePicker(
          context: context,
          // initialDate:currentDate_From!,
          initialDate:DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2050));
      if (pickedDate != null && pickedDate != currentDate_From ) {
        var sts ;
        var cmpDate = pickedDate;
        cmpDate = DateTime.parse(formatDate1.format(cmpDate));

        setState(() {
          currentDate_From = pickedDate;
        });


      }
    }else if(tag == 'T'){
      final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate:DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2050));
      if (pickedDate != null && pickedDate !=currentDate_To) {
        var sts ;
        var cmpDate = pickedDate;
        cmpDate = DateTime.parse(formatDate1.format(cmpDate));
        setState(() {
          currentDate_To = pickedDate;
        });
      }
    }
  }
  fnGetPageData(){
    setState((){
      currentDate_From = lstrYesterday;
      currentDate_To = lstrToday;
    });
    fnGetQuickReports();
  }
  fnFillData(mode){

    if(mode == "QR"){
      if(g.fnValCheck(lstrQuickReportData)){
        setState((){
          var data =  lstrQuickReportData[0];
          lstrNoOfBills =  g.mfnInt(data["COUNT_BILL"].toString())??0;
          lstrOpeningCash =  data["STARTING_AMT"]??0.0;
          lstrGrossAmount =  data["GROSS_AMT"]??0.0;
          lstrDiscountAmount =  data["DISCOUNT_AMT"]??0.0;
          lstrAddlAmount =  data["ADDL_AMT"]??0.0;
          lstrVoidAmount =  data["VOID_AMT"]??0.0;
          lstrTotalSales =  data["NET_AMT"]??0.0;

          lstrCash =  data["CASH_AMT"]??0.0;
          lstrCard =  data["CARD_AMT"]??0.0;
          lstrCredit =  data["CREDIT_AMT"]??0.0;

          lstrGDineCount  = g.mfnInt(data["G_DINE_COUNT"].toString())??0;
          lstrGDineAmt  = g.mfnDbl(data["G_DINE_AMT"].toString())??0.0;
          lstrGTakeCount  = g.mfnInt(data["G_TAKE_COUNT"].toString())??0;
          lstrGTakeAmt  = g.mfnDbl(data["G_TAKE_AMT"].toString())??0.0;
          lstrGDeliveryCount  = g.mfnInt(data["G_DELIVERY_COUNT"].toString())??0;
          lstrGDeliveryAmt  = g.mfnDbl(data["G_DELIVERY_AMT"].toString())??0.0;
          lstrRDineCount  = g.mfnInt(data["R_DINE_COUNT"].toString())??0;
          lstrRDineAmt  = g.mfnDbl(data["R_DINE_AMT"].toString())??0.0;
          lstrRTakeCount  = g.mfnInt(data["R_TAKE_COUNT"].toString())??0;
          lstrRTakeAmt  = g.mfnDbl(data["R_TAKE_AMT"].toString())??0.0;
          lstrRDeliveryCount  = g.mfnInt(data["R_DELIVERY_COUNT"].toString())??0;
          lstrRDeliveryAmt  = g.mfnDbl(data["R_DELIVERY_AMT"].toString())??0.0;

        });
      }

    }

  }
  fnPrint(mode){
    if(mode  ==  "QR"){
      fnQuickReportPrint();
    }else if(mode  ==  "AR"){
      if(lstrRoomSummaryYn){
        fnPrintRoomReportSum();
      }else{
        fnPrintRoomReport();
      }

    }else if(mode  ==  "VR"){
      fnGetVoidReportPrint();
    }else if(mode  ==  "DR"){
      if(lstrSelectedFinancial == "CR"){
        fnGetFinancialReport();
      }else if(lstrSelectedFinancial == "TR"){
        fnGetFinancialReportDay();
      }else if(lstrSelectedFinancial == "DR"){
        fnGetFinancialReportDate();
      }
    }else{
      fnQuickReportPrint();
      //_showMessage("");
      //context.showToast('You have 10 minutes left in the meeting.');

    }
  }
  fnLookup(mode,lookupMode) {
    if (mode == 'ROOM') {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Room'}
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {'sourceColumn': 'CODE','contextField': txtRoomCode,'context': 'window'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtRoomCode,
        oldValue: txtRoomCode.text,
        lstrTable: 'ROOMMASTER',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100000',
        lstrFilter: [],
        keyColumn: 'CODE',
        layoutName: "B",
        mode: lookupMode,
        callback: fnLookupRoomCallBack,
      ), 'ROOM ');
    }
  }
  fnLookupRoomCallBack(value){

  }

  //==========================API CALL=================================

  fnGetQuickReports(){
    setState((){
      lstrNoOfBills= 0;
      lstrOpeningCash = 0.0;
      lstrGrossAmount = 0.0;
      lstrDiscountAmount = 0.0;
      lstrAddlAmount = 0.0;
      lstrVoidAmount = 0.0;
      lstrTotalSales = 0.0;
      lstrCash = 0.0;
      lstrCard = 0.0;
      lstrCredit = 0.0;
      lstrGDineCount  = 0;
      lstrGDineAmt  = 0.0;
      lstrGTakeCount  = 0;
      lstrGTakeAmt  = 0.0;
      lstrGDeliveryCount  = 0;
      lstrGDeliveryAmt  = 0.0;
      lstrRDineCount  = 0;
      lstrRDineAmt  = 0.0;
      lstrRTakeCount  = 0;
      lstrRTakeAmt  = 0.0;
      lstrRDeliveryCount  = 0;
      lstrRDeliveryAmt  = 0.0;

      lstrQuickReportData = [] ;
      lstrPaymentModeData = [] ;
    });
    futureGetReports =  apiCall.getPosReport(g.wstrCompany, g.wstrYearcode, g.wstrDeivceId, g.wstrUserCd);
    futureGetReports.then((value) => fnGetQuickReportsSuccess(value));
  }
  fnGetQuickReportsSuccess(value){
    print(value);
    if(g.fnValCheck(value)){
      lstrQuickReportData =  value["Table1"];
      lstrPaymentModeData =  value["Table2"];

      fnFillData("QR");
    }
  }

  fnQuickReportPrint(){
    futurePrintReport = apiCall.getPrintQuickReport(g.wstrCompany, g.wstrYearcode, g.wstrDeivceId, g.wstrUserCd, g.wstrPrinterPath);
    futurePrintReport.then((value) => fnQuickReportPrintSuccess(value));
  }
  fnQuickReportPrintSuccess(value){
    showToast( 'SUCCESS');
  }

  fnGetRoomReport(){
    //dateFrom, dateTo, mode, orderRoom,orderRef
    futureRoom =  apiCall.getRoomSalesReport(g.wstrCompany, g.wstrYearcode, formatDate1.format(currentDate_From!), formatDate1.format(currentDate_To!).toString(), "", txtRoomCode.text, "", g.wstrUserCd, g.wstrDeivceId);
    futureRoom.then((value) => fnGetRoomReportSuccess(value));
  }
  fnGetRoomReportSuccess(value){
    print(value);
    setState((){
      lstrRoomSalesData = [];
      if(g.fnValCheck(value)){
        lstrRoomSalesData = value;
      }

    });
  }

  fnPrintRoomReport(){
    //dateFrom, dateTo, mode, orderRoom,orderRef
    futureRoom =  apiCall.printRoomSalesReport(g.wstrCompany, g.wstrYearcode, formatDate1.format(currentDate_From!), formatDate1.format(currentDate_To!).toString(), "", txtRoomCode.text, "", g.wstrUserCd, g.wstrDeivceId);
    futureRoom.then((value) => fnPrintRoomReportSuccess(value));
  }
  fnPrintRoomReportSuccess(value){
    print(value);
    showToast( 'Success');
  }
  fnPrintRoomReportSum(){
    //dateFrom, dateTo, mode, orderRoom,orderRef
    futureRoom =  apiCall.printRoomSummaryReport(g.wstrCompany, g.wstrYearcode, formatDate1.format(currentDate_From!), formatDate1.format(currentDate_To!).toString(), "", txtRoomCode.text, "", g.wstrUserCd, g.wstrDeivceId);
    futureRoom.then((value) => fnPrintRoomReportSuccess(value));
  }

  fnGetVoidReport(){
    futureVoid = apiCall.getVoidReport(g.wstrCompany, g.wstrYearcode, formatDate1.format(currentDate_From!), formatDate1.format(currentDate_To!).toString(), g.wstrUserCd, g.wstrDeivceId);
    futureVoid.then((value) => fnGetVoidReportSuccess(value));
  }
  fnGetVoidReportSuccess(value){
    print(value);
    setState((){
      lstrVoidData= [];
      if(g.fnValCheck(value)){
        lstrVoidData = value;
      }
    });
  }

  fnGetVoidReportPrint(){
    futureVoid = apiCall.printVoidReport(g.wstrCompany, g.wstrYearcode, formatDate1.format(currentDate_From!), formatDate1.format(currentDate_To!).toString(), g.wstrUserCd, g.wstrDeivceId);
    futureVoid.then((value) => fnGetVoidReportPrintSuccess(value));
  }
  fnGetVoidReportPrintSuccess(value){
    print(value);
    showToast( 'Success');
  }

  fnGetFinancialReport(){
    futureFinancial = apiCall.printFinancial(g.wstrCompany, g.wstrYearcode,g.wstrPrinterPath);
    futureFinancial.then((value) => fnGetFinancialReportRes(value));
  }
  fnGetFinancialReportDay(){
    futureFinancial = apiCall.printFinancialDay(g.wstrCompany, g.wstrYearcode,g.wstrPrinterPath, formatDate1.format(DateTime.now()).toString());
    futureFinancial.then((value) => fnGetFinancialReportRes(value));
  }
  fnGetFinancialReportDate(){
    futureFinancial = apiCall.printFinancialDay(g.wstrCompany, g.wstrYearcode,g.wstrPrinterPath, formatDate1.format(currentDate_To!).toString());
    futureFinancial.then((value) => fnGetFinancialReportRes(value));
  }
  fnGetFinancialReportRes(value){
    showToast('Done');
  }


  //=====================================================================

  fnSysytemInfo(){
    PageDialog().showSysytemInfo(context, Container(
      child: Column(

        children: [
          Row(
            children: [
              Icon(Icons.date_range_rounded,size: 20,color: Colors.black,),
              gapWC(10),
              tc(formatDate2.format(DateTime.parse(g.wstrClockInDate)).toString(),Colors.black,20)
            ],
          ),
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
              Expanded(child: tc((g.wstrPrinterName + " | " +g.wstrPrinterPath).toString(),Colors.black,20))
            ],
          )
        ],
      ),
    ), mfnLng('System Info'));
  }
  fnChoosePrinter(){
    PageDialog().showS(context, PrinterSelection(
    ), mfnLng('Choose Printer'));
  }
  void _showMessage(String message) {
    if (!mounted) return;
    showFlash(
        context: context,
        duration: Duration(seconds: 3),
        builder: (_, controller) {
          return Flash(
            controller: controller,
            position: FlashPosition.bottom,
            behavior: FlashBehavior.fixed,
            child: FlashBar(
              icon: Icon(
                Icons.face,
                size: 36.0,
                color: Colors.black,
              ),
              content: Text(message),
            ),
          );
        });
  }
}



