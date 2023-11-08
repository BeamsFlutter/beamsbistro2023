
import 'dart:async';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/responsiveHelper.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:beamsbistro/Views/Pages/Bill/addlAmount.dart';
import 'package:beamsbistro/Views/Pages/Bill/discount.dart';
import 'package:beamsbistro/Views/Pages/Bill/discountReciept.dart';
import 'package:beamsbistro/Views/Pages/Bill/openingCash.dart';
import 'package:beamsbistro/Views/Pages/Bill/payment.dart';
import 'package:beamsbistro/Views/Pages/Bill/printerSelection.dart';
import 'package:beamsbistro/Views/Pages/Bill/return.dart';
import 'package:beamsbistro/Views/Pages/Bill/salesSummary.dart';
import 'package:beamsbistro/Views/Pages/Bill/shiftClosing.dart';
import 'package:beamsbistro/Views/Pages/Login/userLogin.dart';
import 'package:beamsbistro/Views/Pages/ReportView/ReportViewer.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:beamsbistro/main.dart';
import 'package:blinking_text/blinking_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'PaymentCredit.dart';
import 'open_drawer.dart';

class Pos extends StatefulWidget {
  const Pos({Key? key}) : super(key: key);

  @override
  _PosState createState() => _PosState();
}

class _PosState extends State<Pos> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //api
  Global g = Global();
  late Future<dynamic> futureOrders;
  late Future<dynamic> futureOrderDet;
  late Future<dynamic> futureOrderSave;
  late Future<dynamic> futureRsl;
  late Future<dynamic> futurePrint;
  late Future<dynamic> futurePrintKot;
  late Future<dynamic> futureRefresh;
  late Future<dynamic> futureDiscount;
  late Future<dynamic> futureOrder;
  late Future<dynamic> futureOther;
  var pageCount  = 0 ;
  var refreshTime  = '';

  ApiCall apiCall = ApiCall();
  var wstrPageMode = "ADD";

  var txtCash = TextEditingController();
  var txtCard = TextEditingController();
  var txtKotSearch  = TextEditingController();
  var txtRslSearch  = TextEditingController();

  var formatDate = new DateFormat('dd-MM-yyyy hh:mm');
  var formatTime = new DateFormat('hh:mm a');
  var formatTimeSecond = new DateFormat('hh:mm:ss a');
  var formatDate1 = new DateFormat('dd MMMM yyyy');
  var formatDate2 = new DateFormat('yyyy-MM-dd hh:mm:ss');


  var lstrSelectedDocno = '' ;
  var lstrSelectedDocType = '' ;
  var lstrSelectedType = '' ;
  var lstrSelectedUser = '' ;
  var lstrSelectedName = '' ;
  var lstrSelectedDate = '' ;
  var lstrSelectedPhone = '' ;
  var lstrPosSelection = 'All' ;
  var lstrSelectedOrderType = '';
  var _radioValue = 0 ;
  var lstrDeliveryMode = '' ;

  //print
  var lstrPrintKotDocno = '';
  var lstrPrintKotDoctype = '';
  var lstrPrintKotYearcode = '';

  var lstrLastGross = 0.00;
  var lstrLastVat = 0.00;
  var lstrLastOtherAmount = 0.00;
  var lstrLastTotal = 0.00;
  var lstrLastDiscount = 0.00;
  var lstrLastAddlAmount = 0.00;

  var lstrTaxable = 0.00;
  var lstrPaidAmt = 0.00;
  var lstrBalanceAmt = 0.00;


  //cashEntry
  var lstrPaymentList = [];
  var lstrSelectedBill =[];
  var lstrSelectedCharges  = [];


  var lstrSelectedkot = [];
  var lstrSelectedkotDet = [];
  var lstrSelectedKotTables = [];
  var lstrSelectedAddress = [];
  var lstrOtherAmountList  = [];

  var lstrPayMode  = '';

  //openingCash
  var lstrOpeningCash  = 0.00;
  var lstrShifno  = '';
  var lstrShifDate  = '';


  var lstrRsl = [];
  var lstrRslDet=[];
  var lstrRslVoid = [];
  var lstrRslVoidDet = [];
  var lstrRetailPay = [];
  var lstrRslAddlCharge = [];
  var lstrTime ;


  //VOID
  var returnRsl = [];
  var returnRslDet = [];
  var returnRslVoidHistory = [];
  var returnRslVoidHistoryDet = [];
  var returnRetailPay = [];
  var returnOtherAmount = [];
  var lstrVoidApprovedUser = '';
  var lstrSelectedRsl = [];
  var lstrSelectedDocDate = '';


  //AddlAmount
  var lstrAddlAmount = [];
  var lstrSelectedAddlList  = [];

  //print
  var lstrPrintDocno = '';

  bool saveSts = true;
  bool printKot = true;
  bool printRsl = true;
  bool printRslHistory = true;

  //rsl
  var lstrSelectedRslItems = [];
  var lstrSideOrderMode  = "";

  var lstrPartyCode="";
  var lstrPartyDescp="";
  var lstrCashCredit="";
  var lstrAddress4="";
  var lstrRef="";

  //Discount##
  var lstrDiscountScreen = false;
  var lstrSelectedDiscount = "ITEM";
  var lstrItemDiscountList = [];
  var lstrSelectedRecpDisc = [];
  var lstrItemWiseDiscList = [];
  var lstrSelectedItemDisc = [];
  var lstrDiscountItems = [];
  var lstrAppliedDisc = [];


  //Bottom Options
  var lstrBottomOption = '';

  //MERGE#
  var lstrMergeKotDet = [];
  var lstrMergeKotDocno = [];

  //SPLIT#
  var lstrSplitScreen = false;
  var lstrSplitOption = '';
  var lstrSplitBills = [];
  var lstrSplitBillAmt = 0.0;
  var lstrSplitBillQty = 0.0;
  var lstrSplitQtyBill = '';
  var lstrNewSplitBill = [];
  var lstrOldSplitBill = [];
  var lstrSelectedSplitItem = [];


  late Timer timer;
  late Timer timerTime;
  int counter = 0;

  @override
  void dispose() {
    timer.cancel();
    timerTime.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lstrSelectedkot = [];
    lstrSelectedkotDet = [];
    lstrSelectedKotTables = [];
    lstrSelectedAddress = [];
    txtCash.text = '0';
    txtCard.text = '0';
    lstrShifDate = g.wstrClockInDate != null || g.wstrClockInDate != '' ? formatDate1.format(DateTime.parse(g.wstrClockInDate.toString())):"";
    lstrShifno = g.wstrShifNo;
    fnGetOrders(null,null,"");
    fnGetOrderDetails('');
    timer = Timer.periodic(Duration(seconds: 4), (Timer t) => fnRefresh());
    timerTime = Timer.periodic(Duration(seconds: 1), (Timer t) => fnUpdateTime());
    lstrSideOrderMode = "ROOM";
    apiGetOtherAmount();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    g.wstrContext = this.context;
    return WillPopScope(child: Scaffold(

      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
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
                          gapWC(10),


                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          th(g.wstrUserName.toString(), Colors.blueGrey, 16),
                          gapW(),
                          tcn(lstrTime??'',Colors.blueGrey,16),
                          gapWC(20),
                          tcn(g.wstrShifDescp.toString().toUpperCase(),Colors.blueGrey,16),
                          gapWC(20),
                          GestureDetector(
                            onTap: (){
                              fnReports();
                            },
                            child: Container(
                              height: 30,
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 1),
                              decoration: boxBaseDecoration(PrimaryColor, 5),
                              child: Icon(Icons.bar_chart,color: Colors.white,size: 15,),
                            ),
                          ),

                          GestureDetector(
                            onTap: (){
                              fnClockOut();
                            },
                            child: Container(
                              height: 30,
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: boxBaseDecoration(PrimaryColor, 5),
                              child: Icon(Icons.access_time_outlined,color: Colors.white,size: 15,),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              fnSalesSummary();
                            },
                            child: Container(
                              height: 30,
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: boxBaseDecoration(PrimaryColor, 5),
                              child: Icon(Icons.calendar_month_sharp,color: Colors.white,size: 15,),
                            ),
                          ),

                          GestureDetector(
                            onTap: (){
                              fnOpeningCash();
                            },
                            child: Container(
                              height: 30,
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 1),
                              decoration: boxBaseDecoration(Colors.green, 5),
                              child: Icon(Icons.payments_outlined,color: Colors.white,size: 15,),
                            ),
                          ),
                          //g.wstrRoleCode == "QADMIN" || g.wstrRoleCode == "ADMIN" || g.wstrRoleCode == "CASHIER"?
                          Bounce(
                            duration: Duration(milliseconds: 110),
                            onPressed: (){
                              fnChoosePrinter();
                            },
                            child: Container(
                              height: 30,
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: boxBaseDecoration(Colors.amber, 5),
                              child: Icon(Icons.print,color: Colors.black,size: 15,),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              fnSysytemInfo();
                            },
                            child: Container(
                              height: 30,
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 1),
                              decoration: boxBaseDecoration(Colors.amber, 5),
                              child: Icon(Icons.computer_sharp,color: Colors.black,size: 15,),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              fnLogout();
                            },
                            child: Container(
                              height: 30,
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: boxBaseDecoration(greyLight, 5),
                              child: Icon(Icons.power_settings_new,color: Colors.red,size: 15,),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                fnCheckDocDate()?
                Container(
                  height: size.height * 0.86,
                  child: Row(
                    children: [
                      Container(
                        decoration: boxBaseDecoration(Colors.white, 0  ),
                        width: size.width*0.15,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            gapHC(5),
                            Row(
                              children: [
                                Icon(Icons.food_bank_outlined,size: 16,),
                                gapWC(5),
                                th('Open Checks', Colors.black, 14),
                              ],
                            ),
                            gapHC(5),
                            line(),
                            gapHC(5),
                            GestureDetector(
                              onTap: (){
                                fnPosCardClick('All');
                                apiGetOtherAmount();
                              },
                              child: posCard(lstrPosSelection == 'All'?'Y':'N','All'),
                            ),
                            gapHC(5),
                            GestureDetector(
                              onTap: (){
                                fnPosCardClick('T');
                              },
                              child: posCard(lstrPosSelection == 'T'?'Y':'N','Dine In'),
                            ),
                            gapHC(5),
                            GestureDetector(
                              onTap: (){
                                fnPosCardClick('A');
                              },
                              child:  posCard(lstrPosSelection == 'A'?'Y':'N','Takeaway'),
                            ),
                            gapHC(5),
                            GestureDetector(
                              onTap: (){
                                fnPosCardClick('D');
                              },
                              child:   posCard(lstrPosSelection == 'D'?'Y':'N','Delivery'),
                            ),
                            gapHC(5),
                            g.wstrRoomMode == "Y"?
                            GestureDetector(
                              onTap: (){
                                fnPosCardClick('RS');
                              },
                              child:   posCard(lstrPosSelection == 'RS'?'Y':'N','Room Service'),
                            ):gapHC(0),
                            gapHC(10),
                            gapHC(5),
                            Row(
                              children: [
                                Icon(Icons.sticky_note_2_outlined,size: 16,),
                                gapWC(5),
                                th('Closed Checks', Colors.black, 14),
                              ],
                            ),
                            gapHC(5),
                            line(),
                            gapHC(5),

                            GestureDetector(
                              onTap: (){
                                fnPosCardClick('H');
                              },
                              child:   posCard(lstrPosSelection == 'H'?'Y':'N','All Checks'),
                            ),
                            gapHC(5),
                            g.wstrRoomMode == "Y"?
                            GestureDetector(
                              onTap: (){
                                fnPosCardClick('R');
                              },
                              child:   posCard(lstrPosSelection == 'R'?'Y':'N','Room Service'),
                            ):gapHC(0),
                            gapHC(10),
                            line(),
                            gapHC(10),
                            GestureDetector(
                              onTap: (){
                                fnPosCardClick('N');
                              },
                              child:   Container(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                decoration: boxDecoration(PrimaryColor, 5),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.fastfood,color: Colors.white,size: 16,),
                                      tc("Take Order",Colors.white,14)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            gapHC(10),

                            // GestureDetector(
                            //   onTap: (){
                            //     Navigator.push(context, MaterialPageRoute(
                            //         builder: (context) => QuickSale()
                            //     ));
                            //   },
                            //   child:   Container(
                            //     height: 60,
                            //     padding: EdgeInsets.symmetric(vertical: 5),
                            //     decoration: boxDecoration(Colors.amber, 5),
                            //     child: Center(
                            //       child: Column(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           Icon(Icons.breakfast_dining,color: Colors.black,size: 16,),
                            //           tc("Quick Order",Colors.black,15)
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // ),


                          ],
                        ),
                      ),
                      //SPLIT#
                      lstrBottomOption == "SP" && g.fnValCheck(lstrSelectedkot) ?
                       Expanded(child: Container(
                         padding: EdgeInsets.all(10),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [

                             gapHC(10),
                             Container(
                               padding: EdgeInsets.all(10),
                               decoration: boxDecoration(Colors.white, 5),
                               child: Column(
                                 children: [
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       Row(
                                           children: [
                                             Icon(Icons.horizontal_split_outlined,color: Colors.black,size: 15,),
                                             gapWC(5),
                                             tc('SPLIT BILL', Colors.red, 14),
                                             gapWC(10),
                                             lstrSplitOption == "QU"?
                                             tcn((lstrSplitBillQty > 1?"":"Quantity split not possible, only have one item."), Colors.red, 10):gapWC(0),
                                           ],
                                       ),

                                       Row(
                                         mainAxisAlignment: MainAxisAlignment.center,
                                         children: [
                                           GestureDetector(
                                             onLongPress: (){
                                               fnSplitBillEqually("CLEAR");
                                             },
                                             child: Bounce(
                                               onPressed: () {
                                                 fnSplitBillEqually("SUB");

                                               },
                                               duration: Duration(milliseconds: 110),
                                               child: Container(
                                                 height: 30,
                                                 width: 40,
                                                 decoration: boxDecoration(Colors.white, 5),
                                                 child: Center(
                                                     child: tc('-', Colors.black, 13)
                                                 ),
                                               ),
                                             ),
                                           ),
                                           gapWC(5),
                                           Container(
                                             height: 30,
                                             width: 100,
                                             decoration: boxDecoration(Colors.white, 5),
                                             child: Center(
                                               child: tc(lstrSplitBills.length.toString(), Colors.black, 15),
                                             ),

                                           ),
                                           gapWC(5),
                                           Bounce(
                                             onPressed: () {
                                               fnSplitBillEqually("ADD");

                                             },
                                             duration: Duration(milliseconds: 110),
                                             child: Container(
                                               height: 30,
                                               width: 40,
                                               decoration: boxDecoration(Colors.white, 5),
                                               child: Center(
                                                   child: tc('+', Colors.black, 13)
                                               ),
                                             ),
                                           ),


                                         ],
                                       )

                                     ],
                                   ),

                                   gapHC(5),
                                   line(),
                                   gapHC(5),
                                   Row(
                                     children: [
                                       gapWC(5),
                                       splitMenuCard('EQUALLY',"","EQ"),
                                       gapWC(5),
                                       // splitMenuCard('AMOUNT',"","AM"),
                                       // gapWC(5),
                                       splitMenuCard('QUANTITY',"","QU"),
                                       gapWC(5),

                                     ],
                                   )

                                 ],
                               ),
                             ),
                             gapHC(10),
                             Flexible(
                                 flex: 7,
                                 child: Container(
                                   padding: EdgeInsets.all(10),
                                   width: size.width*0.55,
                                   decoration: boxDecoration(Colors.white, 5),
                                   child: lstrSplitOption == 'EQ'? GridView.builder(
                                       gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                           maxCrossAxisExtent: 200,
                                           childAspectRatio: 2,
                                           crossAxisSpacing: 20,
                                           mainAxisSpacing: 20),
                                       itemCount:  lstrSplitBills.length,
                                       itemBuilder: (BuildContext ctx, index) {
                                         var e = lstrSplitBills[index];
                                         var code = e ??'';

                                         return ClipPath(
                                           clipper: MovieTicketClipper(),
                                           child: Container(
                                             padding: EdgeInsets.all(10),
                                             decoration: boxDecoration(blueLight, 5),
                                             child: Column(
                                               mainAxisAlignment: MainAxisAlignment.center,
                                               children: [
                                                 tc("#"+code.toString(), Colors.black, 13),
                                                 lstrSplitOption == 'EQ'?tc(lstrSplitBillAmt.toStringAsFixed(2), PrimaryColor, 15):gapHC(0)
                                               ],
                                             ),
                                           ),
                                         );
                                       }):Row(
                                       children: [
                                         Flexible(
                                           flex: 1,
                                           child: Container(
                                             padding: EdgeInsets.all(10),
                                             decoration: boxBaseDecoration(blueLight, 5),
                                             child: Column(
                                                 children: [
                                                   Row(
                                                       children: [
                                                         gapHC(10),
                                                         tc("#SLIPS", Colors.black, 12),
                                                       ],
                                                   ),
                                                   gapHC(5),
                                                   Container(
                                                      height: 30,
                                                      padding: EdgeInsets.all(0),
                                                      child: ScrollConfiguration(
                                                        behavior: MyCustomScrollBehavior(),
                                                        child: ListView.builder(
                                                            scrollDirection: Axis.horizontal,
                                                            physics: AlwaysScrollableScrollPhysics(),
                                                            itemCount: lstrSplitBills.length,
                                                            itemBuilder: (context, index) {
                                                              var dataList = lstrSplitBills[index];
                                                              var code = dataList;
                                                              return Bounce(
                                                                onPressed: (){
                                                                  setState((){
                                                                    lstrSplitQtyBill = dataList;
                                                                  });
                                                                },
                                                                duration: Duration(milliseconds: 110),
                                                                child:  Container(

                                                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                                                  margin: EdgeInsets.only(right: 10),
                                                                  decoration: boxBaseDecoration( lstrSplitQtyBill == code?Colors.amber: Colors.white, 5),
                                                                  child: Center(
                                                                    child: tcn(code, Colors.black,12),
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                                   ),
                                                   gapHC(5),
                                                   Expanded(child: splitNewBillItems())
                                                 ],
                                             ),
                                           )),
                                         gapWC(5),
                                         Container(
                                           child: Column(
                                             mainAxisAlignment: MainAxisAlignment.center,
                                             children: [

                                               Bounce(
                                                 duration: Duration(milliseconds: 110),
                                                 onPressed: (){
                                                   fnSplitAddOldToNew();
                                                 },
                                                 child: Container(
                                                   height: 100,
                                                   width: 40,
                                                   decoration: boxBaseDecoration(greyLight, 5),
                                                   child: Center(
                                                     child: Icon(Icons.arrow_back_ios_new_rounded,size: 15,),
                                                   ),
                                                 ),
                                               ),

                                             ],
                                           ),
                                         ),
                                         gapWC(5),
                                         Flexible(
                                             flex: 1,
                                             child: Container(
                                               padding: EdgeInsets.all(10),
                                               decoration: boxBaseDecoration(redLight, 5),
                                               child: Column(
                                                   children: [
                                                     Row(
                                                         children: [
                                                           tc('BILL ITEMS',Colors.black,12)
                                                         ],
                                                     ),
                                                     gapHC(10),
                                                     Expanded(
                                                       child: splitOldBillItems(),
                                                     )
                                                   ],
                                               ),
                                             )),
                                       ],
                                   ),

                                 )),
                             gapHC(10),
                             Container(
                               padding: EdgeInsets.all(10),
                               decoration: boxDecoration(Colors.white, 5),
                               child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                   children: [
                                     Bounce(child: Container(
                                       padding: EdgeInsets.symmetric(horizontal: 50,vertical: 12),
                                       decoration: boxDecoration(PrimaryColor, 30),
                                       child: Center(
                                         child: tc('SPLIT BILL ', Colors.white, 10),
                                       ),
                                     ),
                                     duration: Duration(milliseconds: 110),
                                     onPressed: (){
                                       fnSaveSplitKot();
                                     }),
                                     gapWC(10),
                                     Bounce(
                                       duration: Duration(milliseconds: 110),
                                       onPressed: (){
                                         fnClear();
                                       },
                                       child: Container(
                                         padding: EdgeInsets.symmetric(horizontal: 50,vertical: 10),
                                         decoration: boxOutlineDecoration(Colors.white, 30),
                                         child: Center(
                                           child: tc('CLOSE', Colors.black, 10),
                                         ),
                                       ),

                                     )
                                   ],
                               ),
                             ),
                           ],
                         ),
                       )):
                      //DISCOUNT##
                      lstrDiscountScreen && g.fnValCheck(lstrSelectedkot) ?
                      Expanded(child: Container(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center ,
                              children: [
                                discountCard(size,'Discount On Item','ITEM'),
                                discountCard(size,'Discount On Receipt','RECP')
                              ],
                            ),
                            Expanded(
                                child: lstrSelectedDiscount == "ITEM" ?
                                getDiscForItem():fnReceiptDiscount()
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              height: 60,
                              decoration: boxBaseDecoration(Colors.white, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  Bounce(
                                      child: Container(
                                        width: size.width*0.1,
                                        height: 40,
                                        decoration: boxOutlineDecoration(Colors.white, 30),
                                        child: Center(
                                          child: tcn('Close', Colors.black, 15),
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 110),
                                      onPressed: (){
                                        setState((){
                                          lstrDiscountScreen = false;
                                        });
                                      }),
                                  gapWC(10),
                                  lstrSelectedDiscount == "ITEM"?
                                  Bounce(
                                      child: Container(
                                        width: size.width*0.12,
                                        height: 40,
                                        decoration: boxDecoration(PrimaryColor, 30),
                                        child: Center(
                                          child: tcn('Remove', Colors.white, 15),
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 110),
                                      onPressed: (){
                                        fnRemoveDiscount();
                                      }):gapWC(10),
                                  gapWC(10),
                                  lstrSelectedDiscount == "ITEM"?
                                  Bounce(
                                      child: Container(
                                        width: size.width*0.1,
                                        height: 40,
                                        decoration: boxDecoration(Colors.green, 30),
                                        child: Center(
                                          child: tcn('Done', Colors.white, 15),
                                        ),
                                      ),
                                      duration: Duration(milliseconds: 110),
                                      onPressed: (){
                                        fnUpdateKotDiscount(lstrSelectedDocno, lstrSelectedDocType, lstrLastDiscount);
                                      }):gapHC(0),

                                ],
                              ),
                            )
                          ],
                        ),
                      )):
                      lstrPosSelection != 'H' &&  lstrPosSelection != 'R' ?
                      Container(
                        decoration: boxBaseDecoration(greyLight, 0  ),
                        width: size.width*0.55,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            RoundedInputField(
                                hintText: 'Search',
                                txtRadius: 0,
                                txtController: txtKotSearch,
                                suffixIcon: Icons.cancel,
                                suffixIconOnclick: (){
                                 setState((){
                                   txtKotSearch.text = "";
                                 });
                                },
                                onChanged: (value){
                                  if(lstrPosSelection =='All'){
                                    fnGetOrders(null, null,"");
                                  }else if(lstrPosSelection =='RS'){
                                    fnGetOrders(null, null,lstrSideOrderMode);
                                  }else{
                                    fnGetOrders(lstrPosSelection, null,"");
                                  }
                                },
                            ),
                            gapHC(5),
                            lstrBottomOption == "ME"?
                                Row(
                                    children: [
                                      tc('MERGE | PLEASE CHOOSE ORDERS', Colors.red, 12)
                                    ],
                                ):gapHC(0),

                            gapHC(10),
                            Expanded(child: FutureBuilder<dynamic>(
                              future:  futureOrders ,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return  orderView(snapshot)  ;
                                } else if (snapshot.hasError) {
                                  return Container();
                                }
                                // By default, show a loading spinner.
                                return Center(
                                  child: Container(),
                                );
                              },
                            )),

                            gapHC(10),
                            bottomOptions()

                          ],
                        ),

                      ):
                      Container(
                        decoration: boxBaseDecoration(greyLight, 0  ),
                        width: size.width*0.55,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Expanded(child: FutureBuilder<dynamic>(
                              future: futureRsl,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return   rslView(snapshot) ;
                                } else if (snapshot.hasError) {
                                  return Container();
                                }
                                // By default, show a loading spinner.
                                return Center(
                                  child: Container(),
                                );
                              },
                            )),
                            gapHC(10),
                            bottomOptions()
                          ],
                        ),
                      ),
                      Container(
                        decoration: boxBaseDecoration(Colors.white, 0  ),
                        width: size.width*0.3,
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                th('Order #' +lstrSelectedDocno , Colors.black, 15),
                                tc(lstrSelectedType+' '+lstrDeliveryMode , PrimaryColor, 15),
                              ],
                            ),
                            gapHC(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person,size: 13,),
                                    gapWC(5),
                                    ts(lstrSelectedUser,Colors.black,12),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.access_time_sharp,size: 13,),
                                    gapWC(5),
                                    ts(lstrSelectedDate,Colors.black,12),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.sticky_note_2_outlined,size: 13,),
                                    gapWC(5),
                                    ts(lstrSelectedName,Colors.black,12),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.phone,size: 13,),
                                    gapWC(5),
                                    ts(lstrSelectedPhone,Colors.black,12),
                                  ],
                                ),
                              ],
                            ),
                            gapHC(10),
                            line(),
                            gapHC(10),
                            g.fnValCheck(lstrSelectedkot) ?
                            Expanded(child: Container(
                              child: new FutureBuilder<dynamic>(
                                future: futureOrderDet,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return itemView(snapshot);
                                  } else if (snapshot.hasError) {
                                    return Container();
                                  }

                                  // By default, show a loading spinner.
                                  return Center(
                                    child: Container(),
                                  );
                                },
                              ),
                            ),) :
                            Expanded(child: Container(
                              child: lstrPosSelection == "H" || lstrPosSelection == "R" ?rslItemView():Center(),
                            )),
                            line(),
                            gapHC(10),
                            (lstrLastDiscount >0 || lstrLastAddlAmount > 0)?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                tcn('Bill Amount', Colors.black, 15),
                                tcn(((lstrLastTotal+lstrLastDiscount)-lstrLastAddlAmount).toStringAsFixed(2), Colors.black, 15)
                              ],
                            ):gapHC(0),
                            g.wstrDiscountYn?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                tcn('Discount', Colors.black, 15),
                                GestureDetector(
                                  onTap: (){
                                    fnDiscount();
                                  },
                                  child: Container(
                                    height: 30,
                                    width: size.width*0.15,
                                    decoration: boxBaseDecoration(greyLight,5),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          tc(lstrLastDiscount.toStringAsFixed(3),Colors.black,15)
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ):gapHC(0),
                            gapHC(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: tcn('Additional Amount', Colors.black, 15),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    fnAddlAmount();
                                  },
                                  child: Container(
                                    height: 30,
                                    width: size.width*0.15,
                                    decoration: boxBaseDecoration(greyLight,5),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        tc(lstrLastAddlAmount.toStringAsFixed(3),Colors.black,15)
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            gapHC(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                tcn('Taxable Amount', Colors.black, 15),
                                ts(lstrTaxable.toStringAsFixed(3), Colors.black, 16)
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                tcn('Vat Amount', Colors.black, 15),
                                ts(lstrLastVat.toStringAsFixed(3), Colors.black, 16)
                              ],
                            ),
                            GestureDetector(
                              onTap: (){
                                if(lstrLastOtherAmount >  0 ){
                                  PageDialog().showNoteS(context, Container(
                                    child: Column(
                                      children: wOtherChargeList(),
                                    ),
                                  ), "OTHER CHARGES    "+lstrLastOtherAmount.toStringAsFixed(3));
                                }

                              },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    tcn('Other Charges', Colors.black, 15),
                                    ts(lstrLastOtherAmount.toStringAsFixed(3), Colors.black, 16)
                                  ],
                                ),
                            ),

                            gapHC(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                th('Net Amount', Colors.black, 17),
                                tc(lstrLastTotal.toStringAsFixed(3), PrimaryColor, 18)
                              ],
                            ),
                            gapHC(5),
                            lstrPosSelection == "H"?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                tcn('Paid Amount', Colors.black, 15),
                                tcn(lstrPaidAmt.toStringAsFixed(3), Colors.black, 16)
                              ],
                            ):gapHC(0),
                            lstrPosSelection == "H"?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                tcn('Change to', Colors.black, 15),
                                tcn(lstrBalanceAmt.toStringAsFixed(3), Colors.black, 16)
                              ],
                            ):gapHC(0),
                            gapHC(5),
                            lstrBottomOption == "ME"?
                            Container(
                              child: Column(
                                children: [
                                  gapHC(5),
                                  GestureDetector(
                                    onTap: (){
                                      fnSaveMergeKot();
                                    },
                                    child:Container(
                                      height: 40,
                                      decoration: boxGradientDecoration(16, 30),
                                      child: Center(
                                        child: th('MERGE BILL',Colors.white,16),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ):
                            lstrBottomOption == "SP"?
                            Container(

                            ):
                            Container(
                              child: Container(
                                child:
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    gapHC(5), lstrPosSelection == "H"?
                                    lstrSelectedDocDate == formatDate.format(DateTime.parse(g.wstrClockInDate.toString()))?
                                    GestureDetector(
                                      onTap: (){
                                        fnReturnBill();
                                      },
                                      child:Container(
                                        height: 40,
                                        decoration: boxGradientDecoration(16, 30),
                                        child: Center(
                                          child: th('Reopen Bill',Colors.white,16),
                                        ),
                                      ),
                                    ):gapHC(0):
                                    lstrSelectedDocno != "" ?
                                    GestureDetector(
                                      onTap: (){
                                        //fnSave();
                                        fnPayPopup();
                                      },
                                      child:Container(
                                        height: 40,
                                        decoration: boxGradientDecoration(16, 30),
                                        child: Center(
                                          child: tc('PAY',Colors.white,15),
                                        ),
                                      ),
                                    ) :
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     GestureDetector(
                                    //       onTap: (){
                                    //         fnPayPopup();
                                    //       },
                                    //       child:Container(
                                    //         width: size.width*0.08,
                                    //         height: 50,
                                    //         decoration: boxDecoration(PrimaryColor, 10),
                                    //         child: Center(
                                    //           child:Icon(Icons.payments_outlined,color: Colors.white,),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     GestureDetector(
                                    //       onTap: (){
                                    //         saveSts? fnSave():'';
                                    //       },
                                    //       child:Container(
                                    //         height: 50,
                                    //         width: size.width*0.18,
                                    //         decoration: boxDecoration(Colors.green, 10),
                                    //         child: Center(
                                    //           child: tc('SAVE',Colors.white,18),
                                    //         ),
                                    //       ),
                                    //     )
                                    //   ],
                                    // )
                                    Container()
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ): Container(
                  width: 400,
                  height: size.height * 0.86,
                  padding: EdgeInsets.all(50),
                  child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.punch_clock,size: 60,),
                          gapHC(10),
                          tc('CLOCK-IN NOT VALID',Colors.black,30),
                          tcn('LAST CLOCK-IN',Colors.black,20),
                          tcn(formatDate.format(DateTime.parse(g.wstrClockInDate.toString())).toString(),Colors.red,20),
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ), onWillPop: () async{
      return false;
    });
  }

  //===========================WIDGET===================================================================

  //OTHERCHARGES#
  List<Widget> wOtherChargeList(){
    List<Widget>  rtnWidget  =  [];
    var OTHER_AMT = [];
    var srnoOther  = 1;
    for(var e in lstrOtherAmountList){
      var perc  =  g.mfnDbl(e["PERC"]);
      var amt =  (g.mfnDbl(lstrTaxable) *  perc)/100;
      //COMPANY,DOCNO,DOCTYPE,YEARCODE,SRNO,CODE,DESCP,PERC,AMTFC,AMT,ACCODE,CURR,CURRATE
      OTHER_AMT.add({
        "COMPANY":g.wstrCompany,
        "DOCNO":"",
        "DOCTYPE":"RSL",
        "YEARCODE":g.wstrYearcode,
        "SRNO":srnoOther,
        "CODE":e["CODE"],
        "DESCP":e["DESCP"],
        "PERC":e["PERC"],
        "AMTFC":amt.toStringAsFixed(3),
        "AMT":g.mfnDbl(amt).toStringAsFixed(3) * g.wstrCurrencyRate,
        "ACCODE":e["ACCODE"],
        "CURR":1,
        "CURRATE":"AED"
      });
      srnoOther = srnoOther+1;
    }
    for(var e in OTHER_AMT){
      rtnWidget.add(
        Container(
          decoration: boxDecoration(Colors.white, 10),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Expanded(child: th(e["DESCP"]+"  ("+g.mfnDbl(e["PERC"]).toString() + "%" +")", Colors.black, 12)),
              gapWC(10),
              th(g.mfnDbl(e["AMTFC"]).toString(),Colors.red,13)
            ],
          ),
        )
      );
    }
    return rtnWidget;
  }



  //MERGE#
  Widget bottomOptions(){
    return  Container(
      padding: EdgeInsets.all(5),
      decoration: boxDecoration(Colors.white, 5),
      child: Row(
        children: [
          //bottomMenuCard('PRINT CHECK',Icons.print,"PC"),
          bottomMenuCard('PRINT DRAFT',Icons.print,"PK"),
          bottomMenuCard('DISCOUNT',Icons.percent_rounded,"DI"),
          bottomMenuCard('SPLIT',Icons.horizontal_split_outlined,"SP"),
          bottomMenuCard('MERGE',Icons.join_left_outlined,"ME"),
          //bottomMenuCard('VOID',Icons.settings_backup_restore,"VO"),
          bottomMenuCard('ADDL AMOUNT',Icons.money,"RE"),

        ],
      ),
    );
  }
  Widget bottomMenuCard(title,icons,mode){
    return Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: Bounce(
          onPressed: () {
            lstrSplitScreen = false;
            if(lstrBottomOption == "ME"){
              fnClear();
            }
            if(mode == "ME"){
              fnClear();
            }else if(mode == "DI"){
              fnDiscount();
            }else if(mode == "SP"){
              if(g.fnValCheck(lstrSelectedkot)){
                  fnSplit();
              }else{
                showToast( 'Please Select Order');
              }
            }else if(mode == "PK"){
              if(g.fnValCheck(lstrSelectedkot)){
                fnPrintKotCall(lstrSelectedkot);
              }else{
                showToast( 'Please Select Order');
              }
            }else if(mode == "RE"){
              if(g.fnValCheck(lstrSelectedkot)){
                fnAddlAmount();
              }else{
                showToast( 'Please Select Order');
              }
            }
            setState((){
              lstrBottomOption = mode;
            });
          },
          duration: Duration(milliseconds: 110),
          child: Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal:lstrBottomOption == mode ? 10:5,vertical: lstrBottomOption == mode ? 0:2),
            decoration: boxDecoration(lstrBottomOption == "mode" ? PrimaryColor:PrimaryColor, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: tcn(title, lstrBottomOption == "mode"?Colors.white: Colors.white, 10),),gapWC(5),
                Icon(icons,size: 12,color: lstrBottomOption == "mode"?Colors.white: Colors.white,)
              ],
            ),
          ),
        ));
  }

  //SPLIT#
  Widget splitMenuCard(title,icons,mode){
    return Flexible(
        flex:1,
        fit: FlexFit.tight,
        child:
        Bounce(
          onPressed: () {
            setState((){
              if(mode == "QU"){
                lstrSplitQtyBill = "SLIP1";
              }
              lstrSplitOption = mode;
            });
          },
          duration: Duration(milliseconds: 110),
          child: Container(
            height: 35,
            decoration: boxBaseDecoration(lstrSplitOption == mode?PrimaryColor:greyLight, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                tc(title.toString(),lstrSplitOption == mode?Colors.white: Colors.black, 12)
              ],
            ),
          ),
        ));


  }
  Widget splitOldBillItems(){
    var srno = 0;
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: lstrOldSplitBill.length,
        itemBuilder: (context, index) {
          var dataList = lstrOldSplitBill[index];
          var lstrOrderNo  =  dataList["DOCNO"];

          var itemCode = dataList['STKCODE'];
          var itemName = dataList['STKDESCP'];
          var itemQty = g.mfnDbl(dataList['QTY1']);
          var itemStatus = dataList['STATUS'].toString();
          var itemRate = dataList['RATE'].toString();
          var discAmt = g.mfnDbl(dataList['DISC_AMT'].toString());
          var discCode = dataList['DISC_CODE']??"";
          var discDescp = dataList['DISC_DESCP']??"";
          var itemTotal = (itemQty * double.parse(itemRate))-discAmt;
          if( itemStatus != 'C'){
            srno = srno+1;
          }

          return GestureDetector(
            onTap: (){

            },
            child: itemStatus == 'C' ? Container():   Container(
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                margin: EdgeInsets.only(bottom: 5),
                decoration: boxBaseDecoration(Colors.white, 3),
                child:  Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          //DISCOUNT##
                          child: Checkbox(
                              activeColor: Colors.green,
                              value: lstrSelectedSplitItem.contains(dataList) ,
                              onChanged: (value) {
                                print(value);
                                fnSplitItemSelection(dataList,value);
                              }),
                        ),
                        Expanded(child: tcn((srno).toString() +'. '+itemName,Colors.black,13),),

                        Container(
                          width: 50,
                          child: th('x '+itemQty.toStringAsFixed(2),Colors.black,12),
                        ),
                      ],
                    ),
                  ],
                )
            ),
          );
        });
  }
  Widget splitNewBillItems(){
    var srno = 0;
    var selectedData = [];

     if(g.fnValCheck(lstrNewSplitBill)){
       selectedData = g.mfnJson(lstrNewSplitBill);
       selectedData.retainWhere((i){
         return i["SPLIT_NO"] == lstrSplitQtyBill;
       });
     }

    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: selectedData.length,
        itemBuilder: (context, index) {
          var dataList = selectedData[index];
          var lstrOrderNo  =  dataList["DOCNO"];

          var itemCode = dataList['STKCODE'];
          var itemName = dataList['STKDESCP'];
          var itemQty = g.mfnDbl(dataList['QTY1']);
          var itemStatus = dataList['STATUS'].toString();
          var itemRate = dataList['RATE'].toString();
          var discAmt = g.mfnDbl(dataList['DISC_AMT'].toString());
          var discCode = dataList['DISC_CODE']??"";
          var discDescp = dataList['DISC_DESCP']??"";
          var itemTotal = (itemQty * double.parse(itemRate))-discAmt;
          if( itemStatus != 'C'){
            srno = srno+1;
          }

          return GestureDetector(
            onTap: (){

            },
            child: itemStatus == 'C' ? Container():   Bounce(child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                margin: EdgeInsets.only(bottom: 5),
                decoration: boxBaseDecoration(Colors.white, 3),
                child:  Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Expanded(child: tcn((srno).toString() +'. '+itemName,Colors.black,13),),

                        Container(
                          width: 50,
                          child: th('x '+itemQty.toStringAsFixed(2),Colors.black,12),
                        ),
                        GestureDetector(
                          onTap: (){
                            fnSplitAddNewToOld("SUB",dataList);
                          },
                          child: Container(
                            width: 50,
                            height: 35,
                            decoration: boxGradientDecoration(16, 5),
                            child: Center(
                              child: Icon(Icons.remove_circle_outline_outlined,color: Colors.white,size: 15,),
                            ),
                          ),
                        )

                      ],
                    ),
                  ],
                )
            ), duration: Duration(milliseconds: 110), onPressed: (){
              fnSplitAddNewToOld("ADD",dataList);
            }),
          );
        });
  }
  Widget getDiscForItem(){
    //Discount##
    var sortDiscList = [];
    var addedDiscCode = [];
    var appliedList = [];
    if(g.fnValCheck(lstrSelectedItemDisc)){
      lstrSelectedItemDisc.forEach((e) {
        var selectedData = g.mfnJson(lstrItemWiseDiscList);
        selectedData.retainWhere((i){
          return i["STKCODE"] == e;
        });
        if(g.fnValCheck(selectedData)){
          for(var f in selectedData){
            if(!addedDiscCode.contains(f["CODE"])){
              addedDiscCode.add(f["CODE"]);
              lstrItemDiscountList.forEach((g) {
                if(g["CODE"] == f["CODE"]){
                  sortDiscList.add(g);
                  if(lstrAppliedDisc.contains(g["CODE"])){
                    appliedList.add(g["CODE"]);
                  }

                }
              });
            }

          }
        }
      });
      lstrAppliedDisc = appliedList;
    }else{
      sortDiscList = lstrItemDiscountList;
    }

    return Container(
      padding: EdgeInsets.all(20),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio:  2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20),
          itemCount:  sortDiscList.length,
          itemBuilder: (BuildContext ctx, index) {
            var dataList = sortDiscList[index];
            var code = dataList['CODE'] ??'';
            var descp = dataList['DESCP']??'';
            return Bounce(child: Container(
              height: 100,
              decoration: boxDecoration(lstrAppliedDisc.contains(code)?Colors.blue: Colors.white, 5),
              padding: EdgeInsets.all(5),
              child: Center(
                child: tc(descp.toString(),lstrAppliedDisc.contains(code)?Colors.white:Colors.blue,13),
              ),
            ), duration: Duration(milliseconds: 110),
                onPressed: (){
                      fnApplyDiscount(dataList, code);
                }) ;
          }),
    );
  }
  Widget orderView(snapshot){

    return ResponsiveWidget(
        mobile: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio:.8,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data[index];
          var kot  = dataList['KOT'];
          var kotDet  = dataList['KOTDET'];
          var kotTables  = dataList['KOT_TABLEDET'];
          var kotAddress  = dataList['KOT_ADDRESS'];


          var lstrOrderNo  = '';
          var lstrOrderType  =  '';
          var lstrCreateUser  =  '';
          var lstrNetAmount  =  '';
          var lstrCustomerName  = '';
          var lstrCustomerMob  = '';
          var lstrDeliveryMode  = '';
          var lstrDeliveryRef  = '';
          var lstrOrderRoom  = '';
          var mergeDocno  = '';
          var splitDocno  = '';

          if(g.fnValCheck(kot)){
            lstrOrderNo  =  kot[0]["DOCNO"];
            lstrOrderType  =  kot[0]["ORDER_TYPE"];
            lstrCreateUser  =  kot[0]["CREATE_USER"];
            lstrNetAmount  =  kot[0]["NETAMT"].toString();
            lstrDeliveryMode  =  (kot[0]["ORDER_MODE"]??"").toString();
            lstrDeliveryRef  =  (kot[0]["ORDER_REF"]??"").toString();
            lstrOrderRoom  =  (kot[0]["ORDER_ROOM"]??"").toString();
            mergeDocno  =  (kot[0]["MERGE_NO"]??"").toString();
            splitDocno  =  (kot[0]["PRVDOCNO"]??"").toString();
            lstrDeliveryRef = lstrOrderRoom.toString()+ ' '+lstrDeliveryRef.toString();
          }
          if(g.fnValCheck(kotAddress)){
            lstrCustomerName  =  kotAddress[0]["FNAME"].toString();
            lstrCustomerMob  =  kotAddress[0]["PHONE1"].toString();
          }


          var lstrTableNo = '';
          if(g.fnValCheck(kotTables)){
            lstrTableNo  =  fnGetTableName(kotTables);
          }


          return orderCardView(dataList, lstrOrderNo, lstrOrderType, lstrTableNo, lstrNetAmount, lstrCreateUser, lstrCustomerName, lstrCustomerMob,lstrDeliveryMode,lstrDeliveryRef,mergeDocno,splitDocno);
        }),
        tab: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio:1.2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data[index];
          var kot  = dataList['KOT'];
          var kotDet  = dataList['KOTDET'];
          var kotTables  = dataList['KOT_TABLEDET'];
          var kotAddress  = dataList['KOT_ADDRESS'];


          var lstrOrderNo  = '';
          var lstrOrderType  =  '';
          var lstrCreateUser  =  '';
          var lstrNetAmount  =  '';
          var lstrCustomerName  = '';
          var lstrCustomerMob  = '';
          var lstrDeliveryMode  = '';
          var lstrDeliveryRef  = '';
          var lstrOrderRoom  = '';
          var mergeDocno  = '';
          var splitDocno  = '';

          if(g.fnValCheck(kot)){
            lstrOrderNo  =  kot[0]["DOCNO"];
            lstrOrderType  =  kot[0]["ORDER_TYPE"];
            lstrCreateUser  =  kot[0]["CREATE_USER"];
            lstrNetAmount  =  kot[0]["NETAMT"].toString();
            lstrDeliveryMode  =  (kot[0]["ORDER_MODE"]??"").toString();
            lstrDeliveryRef  =  (kot[0]["ORDER_REF"]??"").toString();
            lstrOrderRoom  =  (kot[0]["ORDER_ROOM"]??"").toString();
            mergeDocno  =  (kot[0]["MERGE_NO"]??"").toString();
            splitDocno  =  (kot[0]["PRVDOCNO"]??"").toString();
            lstrDeliveryRef = lstrOrderRoom.toString()+ ' '+lstrDeliveryRef.toString();
          }
          if(g.fnValCheck(kotAddress)){
            lstrCustomerName  =  kotAddress[0]["FNAME"].toString();
            lstrCustomerMob  =  kotAddress[0]["PHONE1"].toString();
          }


          var lstrTableNo = '';
          if(g.fnValCheck(kotTables)){
            lstrTableNo  =  fnGetTableName(kotTables);
          }

          return orderCardView(dataList, lstrOrderNo, lstrOrderType, lstrTableNo, lstrNetAmount, lstrCreateUser, lstrCustomerName, lstrCustomerMob,lstrDeliveryMode,lstrDeliveryRef,mergeDocno,splitDocno);
        }),
        windows: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio:1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data[index];
          var kot  = dataList['KOT'];
          var kotDet  = dataList['KOTDET'];
          var kotTables  = dataList['KOT_TABLEDET'];
          var kotAddress  = dataList['KOT_ADDRESS'];


          var lstrOrderNo  = '';
          var lstrOrderType  =  '';
          var lstrCreateUser  =  '';
          var lstrNetAmount  =  '';
          var lstrCustomerName  = '';
          var lstrCustomerMob  = '';
          var lstrDeliveryMode  = '';
          var lstrDeliveryRef  = '';
          var lstrOrderRoom  = '';
          var mergeDocno  = '';
          var splitDocno  = '';

          if(g.fnValCheck(kot)){
            lstrOrderNo  =  kot[0]["DOCNO"];
            lstrOrderType  =  kot[0]["ORDER_TYPE"];
            lstrCreateUser  =  kot[0]["CREATE_USER"];
            lstrNetAmount  =  kot[0]["NETAMT"].toString();
            lstrDeliveryMode  =  (kot[0]["ORDER_MODE"]??"").toString();
            lstrDeliveryRef  =  (kot[0]["ORDER_REF"]??"").toString();
            lstrOrderRoom  =  (kot[0]["ORDER_ROOM"]??"").toString();
            mergeDocno  =  (kot[0]["MERGE_NO"]??"").toString();
            splitDocno  =  (kot[0]["PRVDOCNO"]??"").toString();
            lstrDeliveryRef = lstrOrderRoom.toString()+ ' '+lstrDeliveryRef.toString();

          }
          if(g.fnValCheck(kotAddress)){
            lstrCustomerName  =  kotAddress[0]["FNAME"].toString();
            lstrCustomerMob  =  kotAddress[0]["PHONE1"].toString();
          }


          var lstrTableNo = '';
          if(g.fnValCheck(kotTables)){
            lstrTableNo  =  fnGetTableName(kotTables);
          }

          return orderCardView(dataList, lstrOrderNo, lstrOrderType, lstrTableNo, lstrNetAmount, lstrCreateUser, lstrCustomerName, lstrCustomerMob,lstrDeliveryMode,lstrDeliveryRef,mergeDocno,splitDocno);
        }));
  }
  GestureDetector orderCardView(dataList, String lstrOrderNo, String lstrOrderType, String lstrTableNo, String lstrNetAmount, String lstrCreateUser, String lstrCustomerName, String lstrCustomerMob,String lstrDeliveryMode,String lstrDeliveryRef,String mergeDocno,String splitDocno) {
    return GestureDetector(
          onTap: (){
            if(lstrBottomOption == "ME"){
              fnOrderClickMerge(lstrOrderNo,dataList);
            }else{
              fnOrderClick(dataList,lstrOrderNo);
            }
          },
          child: ClipPath(
            clipper: MovieTicketClipper(),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: lstrBottomOption == "ME"? boxDecoration(lstrMergeKotDocno.contains(lstrOrderNo)?yellowLight: Colors.white, 5):boxDecoration(lstrSelectedDocno == lstrOrderNo?yellowLight: Colors.white, 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          tc('Order ' +  lstrOrderNo,Colors.black,15),

                        ],
                      ),
                      gapHC(5),
                      Row(
                        children: [
                          mergeDocno != ""? Row(
                            children: [
                              Icon(Icons.join_left_outlined,color: Colors.black,size: 13,),
                              gapWC(5),
                              tc('MERGE', Colors.blue, 12)
                              // BlinkText(
                              //   'MERGE',
                              //   style: TextStyle(fontSize: 12.0, color: Colors.red),
                              //   endColor: Colors.amber,
                              // )
                            ],
                          )  :
                          splitDocno != ""? Row(
                            children: [
                              Icon(Icons.splitscreen,color: Colors.black,size: 13,),
                              gapWC(5),
                              tc('SPLIT' + " | "+splitDocno.toString(), Colors.indigo, 12)
                              // BlinkText(
                              //   'MERGE',
                              //   style: TextStyle(fontSize: 12.0, color: Colors.red),
                              //   endColor: Colors.amber,
                              // )
                            ],
                          ):
                          Expanded(child:tc(lstrOrderType == 'T' ?'Table   ' + lstrTableNo +' | '+ lstrDeliveryMode +' - '+lstrDeliveryRef  : lstrOrderType == 'A' ? 'Takeaway ' + lstrDeliveryMode +' - '+lstrDeliveryRef  : lstrOrderType == 'D' ? 'Delivery : '+lstrDeliveryMode +' - '+lstrDeliveryRef : '',PrimaryColor,12),
                          )
                        ],
                      ),
                      gapHC(5),
                      ts( 'AED '+ lstrNetAmount,PrimaryColor,12),
                      gapHC(5),
                      Row(
                        children: [
                          Icon(Icons.sticky_note_2_outlined,size: 12,),
                          gapWC(5),
                          ts(lstrCreateUser,Colors.black,12),
                        ],
                      ),
                      gapHC(5),
                      line(),
                      gapHC(5),
                      Row(
                        children: [
                          Icon(Icons.person,size: 13,),
                          gapWC(5),
                          ts(lstrCustomerName,Colors.black,12),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.phone,size: 13,),
                          gapWC(5),
                          ts(lstrCustomerMob,Colors.black,12),
                        ],
                      ),
                      gapHC(5),
                      line(),
                      gapHC(5),
                    ],
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: (){
                  //         fnPrintKotCall(dataList['KOT']);
                  //       },
                  //       child: Container(
                  //         width: 100,
                  //         height: 35,
                  //         decoration: boxBaseDecoration(Colors.amber, 5),
                  //         child: Center(
                  //           child: Icon(Icons.print,color: Colors.black,size: 20,),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  gapHC(5),


                ],
              ),
            ),
          ),
        );
  }
  Widget rslView(snapshot){
    return ResponsiveWidget(
        mobile: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 350,
            childAspectRatio:1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data[index];
          var rsl = dataList['RSL'];
          var rslDet = dataList['RSLDET'];
          var rslVoid = dataList['RSL_VOID'];
          var rslVoidDet = dataList['RSL_VOIDDET'];

          var rslDocNo = '';
          var lstrRslType = '' ;
          var lstrCreateUser ='' ;
          var lstrCreateDate  = '';
          var lstrNetAmount  = '';
          var lstrCustomerName = '' ;
          var lstrCustomerMob  = '';
          var lstrRoomRef  = '';
          var lstrOrderRef  = '';

          if(g.fnValCheck(rsl)){
            rslDocNo = rsl[0]["DOCNO"];
            lstrRslType = rsl[0]["DOCNO"];
            lstrCreateUser = rsl[0]["CREATE_USER"];
            lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
            lstrNetAmount = rsl[0]["NETAMT"].toString();
            lstrCustomerName = rsl[0]["DOCNO"];
            lstrCustomerMob = rsl[0]["DOCNO"];
            lstrOrderRef = rsl[0]["ORDER_REF"]??"";
            lstrRoomRef =  (rsl[0]["ORDER_MODE"]??"").toString() + "  "+ (rsl[0]["ORDER_ROOM"]??"").toString();
          }

          var lstrTableNo = '';

          return rslCardView(dataList, rslDocNo, lstrRslType, lstrTableNo, lstrNetAmount, lstrCreateUser,lstrRoomRef,lstrOrderRef);
        }),
        tab: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 280,
            childAspectRatio:1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data[index];
          var rsl = dataList['RSL'];
          var rslDet = dataList['RSLDET'];
          var rslVoid = dataList['RSL_VOID'];
          var rslVoidDet = dataList['RSL_VOIDDET'];

          var rslDocNo = '';
          var lstrRslType = '' ;
          var lstrCreateUser ='' ;
          var lstrCreateDate  = '';
          var lstrNetAmount  = '';
          var lstrCustomerName = '' ;
          var lstrCustomerMob  = '';
          var lstrRoomRef  = '';
          var lstrOrderRef  = '';

          if(g.fnValCheck(rsl)){
            rslDocNo = rsl[0]["DOCNO"];
            lstrRslType = rsl[0]["DOCNO"];
            lstrCreateUser = rsl[0]["CREATE_USER"];
            lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
            lstrNetAmount = rsl[0]["NETAMT"].toString();
            lstrCustomerName = rsl[0]["DOCNO"];
            lstrCustomerMob = rsl[0]["DOCNO"];
            lstrOrderRef = rsl[0]["ORDER_REF"]??"";
            lstrRoomRef =  (rsl[0]["ORDER_MODE"]??"").toString() + "  "+ (rsl[0]["ORDER_ROOM"]??"").toString();
          }

          var lstrTableNo = '';

          return  rslCardView(dataList,rslDocNo, lstrRslType, lstrTableNo, lstrNetAmount, lstrCreateUser,lstrRoomRef,lstrOrderRef);
        }),
        windows: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 350,
            childAspectRatio:1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data[index];
          var rsl = dataList['RSL'];
          var rslDet = dataList['RSLDET'];
          var rslVoid = dataList['RSL_VOID'];
          var rslVoidDet = dataList['RSL_VOIDDET'];

          var rslDocNo = '';
          var lstrRslType = '' ;
          var lstrCreateUser ='' ;
          var lstrCreateDate  = '';
          var lstrNetAmount  = '';
          var lstrCustomerName = '' ;
          var lstrCustomerMob  = '';
          var lstrRoomRef  = '';
          var lstrOrderRef  = '';

          if(g.fnValCheck(rsl)){
            rslDocNo = rsl[0]["DOCNO"];
            lstrRslType = rsl[0]["DOCNO"];
            lstrCreateUser = rsl[0]["CREATE_USER"];
            lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
            lstrNetAmount = rsl[0]["NETAMT"].toString();
            lstrCustomerName = rsl[0]["DOCNO"];
            lstrCustomerMob = rsl[0]["DOCNO"];
            lstrOrderRef = rsl[0]["ORDER_REF"]??"";
            lstrRoomRef =  (rsl[0]["ORDER_MODE"]??"").toString() + "  "+ (rsl[0]["ORDER_ROOM"]??"").toString();
          }

          var lstrTableNo = '';

          return rslCardView(dataList,rslDocNo, lstrRslType, lstrTableNo, lstrNetAmount, lstrCreateUser,lstrRoomRef,lstrOrderRef);
        }));
  }
  GestureDetector rslCardView(dataList,String rslDocNo, String lstrRslType, String lstrTableNo, String lstrNetAmount, String lstrCreateUser,String orderMode,String orderRef) {
    return GestureDetector(
      onTap: (){
        fnRslClick(dataList,rslDocNo);
      },
          child: ClipPath(
            clipper: MovieTicketClipper(),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: boxDecoration(lstrSelectedDocno ==rslDocNo? blueLight : Colors.white, 5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        th('Order ' +  rslDocNo,Colors.black,15),
                        tc(lstrRslType == 'T' ?'Table   ' + lstrTableNo : lstrRslType == 'A' ? 'Takeaway' : lstrRslType == 'D' ? 'Delivery ' : '',PrimaryColor,15),

                      ],
                    ),
                    gapHC(5),
                    lineC(0.2, Colors.black),
                    gapHC(5),
                    Row(
                      children: [
                        Icon(Icons.person ,size: 13,),
                        gapWC(5),
                        ts(lstrCreateUser,Colors.black,12),
                      ],
                    ),
                    gapHC(5),
                    Row(
                      children: [
                        Icon(Icons.sticky_note_2_outlined,size: 13,),
                        gapWC(5),
                        ts(orderMode,Colors.black,12),
                      ],
                    ),Row(
                      children: [
                        Icon(Icons.credit_card_sharp,size: 13,color: Colors.black,),
                        gapWC(5),
                        ts(orderRef,Colors.black,12),
                      ],
                    ),
                    gapHC(5),
                    lineC(0.2, Colors.black),
                    gapHC(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        th( 'AED '+ lstrNetAmount,PrimaryColor,16),
                      ],
                    ),
                    gapHC(10),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          lstrPrintDocno =rslDocNo;
                        });
                        PageDialog().printDialog(context, fnPrintHistory);
                      },
                      child: Container(
                        height: 40,
                        decoration: boxBaseDecoration(Colors.amber, 5),
                        child: Center(
                          child: Icon(Icons.print,color: Colors.black,size: 20,),
                        ),
                      ),
                    )


                  ],
                ),
              )
            ),
          ),
        );
  }
  Widget itemView(snapshot){
    var srno  =0;
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: lstrSelectedkotDet.length,
        itemBuilder: (context, index) {
          var dataList = lstrSelectedkotDet[index];
          var lstrOrderNo  =  dataList["DOCNO"];

          var itemCode = dataList['STKCODE'];
          var itemName = dataList['STKDESCP'];
          var itemQty = g.mfnDbl(dataList['QTY1']);
          var itemStatus = dataList['STATUS'].toString();
          var itemRate = dataList['RATE'].toString();
          var discAmt = g.mfnDbl(dataList['DISC_AMT'].toString());
          var discCode = dataList['DISC_CODE']??"";
          var discDescp = dataList['DISC_DESCP']??"";
          var itemTotal = (itemQty * double.parse(itemRate))-discAmt;
          if( itemStatus != 'C'){
            srno = srno+1;
          }

          return GestureDetector(
            onTap: (){

            },
            child: itemStatus == 'C' ? Container():   Container(
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              margin: EdgeInsets.only(bottom: 5),
              decoration: boxBaseDecoration(greyLight, 3),
              child:  Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      lstrDiscountScreen && lstrSelectedDiscount =='ITEM' && lstrDiscountItems.contains(itemCode)?
                      Container(
                        //DISCOUNT##
                        child: Checkbox(
                            activeColor: Colors.green,
                            value: lstrSelectedItemDisc.contains(itemCode) ,
                            onChanged: (value) {
                              print(value);
                              fnItemWiseDiscSelect(itemCode,value);
                            }),
                      ):Container(),
                      Expanded(child: tc((srno).toString() +'. '+itemName,Colors.black,13),),

                      Container(
                        width: 60,
                        child: th(double.parse(itemRate).toStringAsFixed(2) ,Colors.black,12),
                      ),
                      Container(
                        width: 50,
                        child: th('x '+itemQty.toStringAsFixed(2),Colors.black,12),
                      ),
                      Container(
                          width: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              th(itemTotal.toStringAsFixed(1),PrimaryColor,13),
                            ],
                          )
                      ),
                      // Row(
                      //   children: [
                      //     tc(itemRate.toString() ,Colors.black,15),
                      //     gapW(),
                      //     tc('x'+itemQty.toString(),Colors.black,15),
                      //     gapW(),
                      //     gapW(),
                      //     tc(itemTotal.toString(),PrimaryColor,15),
                      //   ],
                      // )
                    ],
                  ),
                  discAmt > 0 ?
                  Row(
                    children: [
                      Container(
                          padding: EdgeInsets.all(2),
                          decoration: boxDecoration(Colors.red, 30),
                          child:Icon(Icons.percent_rounded,size: 10,color: Colors.white,),
                      ),

                      gapWC(5),
                      tcn(discDescp.toString(), Colors.black, 12)
                    ],
                  ):gapHC(0)
                ],
              )
            ),
          );
        });
  }
  Widget rslItemView(){
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: lstrSelectedRslItems.length,
        itemBuilder: (context, index) {
          var dataList = lstrSelectedRslItems[index];
          var lstrOrderNo  =  dataList["DOCNO"];

          var itemCode = dataList['STKCODE'];
          var itemName = dataList['STKDESCP'];
          var itemQty = dataList['QTY1'].toString();
          var itemStatus = dataList['STATUS'].toString();
          var itemRate = dataList['RATE'].toString();
          var itemTotal = double.parse(itemQty)  * double.parse(itemRate);
          var returnSts  =   dataList['RETURNED_YN'].toString();
          var voidQty  =   dataList['VOID_QTY'].toString();
          var voidAmount  =   g.mfnDbl(dataList['VOID_QTY'].toString()) * g.mfnDbl(dataList['RATE'].toString());
          return GestureDetector(
            onTap: (){

            },
            child: itemStatus == 'C' ? Container():  Container(
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 3),
              margin: EdgeInsets.only(bottom: 5),
              decoration: boxBaseDecoration(returnSts == "Y"?Colors.red:greyLight, 3),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: th((index+1).toString() +'. '+itemName,returnSts == "Y"?Colors.white:Colors.black,12),),
                  Row(
                    children: [
                      Container(
                        width: 60,
                        child: th(double.parse(itemRate).toStringAsFixed(2) ,returnSts == "Y"?Colors.white: Colors.black,12),
                      ),
                      Container(
                        width: 50,
                        child: th('x '+double.parse(itemQty).toStringAsFixed(0),returnSts == "Y"?Colors.white:Colors.black,12),
                      ),
                      Container(
                          width: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              th(itemTotal.toStringAsFixed(1),returnSts == "Y"?Colors.white:PrimaryColor,13),
                            ],
                          )
                      ),

                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
  Widget discountCard(size,title,mode){
     return Bounce(child: Container(
       height: 50,
       width: size.width*0.25,
       decoration: boxDecoration( lstrSelectedDiscount  == mode? Colors.amber: Colors.white, 5),
       child: Center(
         child: tcn(title, Colors.black, 15),
       ),
     ),
     duration: Duration(milliseconds: 110),
     onPressed: (){
       setState((){
         lstrSelectedDiscount = mode;
       });
     });
  }
  fnPayPopup(){
    if(lstrSelectedDocno.isEmpty){
      showToast( 'Please choose order');
      return;
    }
    //fnSave();
    //Navigator.push(context, MaterialPageRoute(builder: (context) => Payment()));
    if((lstrSelectedBill[0]["DELIVERY_MODE"])=="") {
      PageDialog().showL(context, Payment(
        lstrDataList: lstrSelectedBill,
        fnCallBack: fnPaymentCallBack,
        lstrPaymentList: [],
      ), 'Payment Details');
    }
    else{
      PageDialog().showL(context, PaymentCredit(
        lstrDataList: lstrSelectedBill,
        fnCallBack: fnPaymentCallBack,
        lstrPaymentList: [],
      ), 'Payment Details');

    }
  }

  //================================================================PAGE FN

  //MERGE#
  fnOrderClickMerge(docno,dataList){
    var kot  = dataList['KOT'];
    var kotDet  = dataList['KOTDET'];

    if(!g.fnValCheck(lstrMergeKotDet)){
      fnRemoveDiscount();
      setState(() {
        lstrDiscountScreen =false;
        lstrSelectedDiscount = "ITEM";
        lstrItemDiscountList = [];
        lstrSelectedRecpDisc = [];
        lstrItemWiseDiscList = [];
        lstrSelectedItemDisc = [];
        lstrDiscountItems = [];
        lstrAppliedDisc = [];

        lstrBalanceAmt = 0.00;
        lstrPaidAmt=0.00;
        lstrLastGross = 0.00;
        lstrLastVat = 0.00;
        lstrLastOtherAmount = 0.00;
        lstrLastTotal = 0.00;
        lstrTaxable = 0.00;
        lstrLastDiscount = 0.00;
      });
      lstrSelectedOrderType = "T";
      lstrSelectedName = "";
      lstrSelectedPhone = "";
      lstrSelectedDocno = "MERGE";

      lstrSelectedBill.add({
        "DOCNO":"MERGE",
        "TYPE": "MERGE",
        "USER" :lstrSelectedUser,
        "NAME" : "",
        "CASH" : 0.00,
        "CARD" : 0.00,
        "TOTAL_AMT":0.00,
        "PAID_AMT":0.00,
        "CHANGE_TO":0.00,
        "DELIVERY_MODE":kot[0]["REF3"]??"",
        "PARTYCODE":kot[0]["PARTYCODE"]??"",
        "PARTYNAME":kot[0]["PARTYNAME"]??"",
        "ORDER_ROOM":kot[0]["ORDER_ROOM"]??"",
        "ORDER_MODE":kot[0]["ORDER_MODE"]??"",
        "ORDER_REF":kot[0]["ORDER_REF"]??"",
        "ROOM_YN":kot[0]["ROOM_SERVICE_YN"]??"",
      });
    }

    setState((){
      lstrSelectedkot =kot;
      if(lstrMergeKotDocno.contains(docno.toString())){
        lstrMergeKotDocno.remove(docno.toString());
        for(var e in kotDet){
          lstrSelectedkotDet.remove(e);
        }
      }else{
        lstrMergeKotDocno.add(docno.toString());
        for(var e in kotDet){
          lstrSelectedkotDet.add(e);
        }
      }
    });
    print(lstrSelectedkotDet);

    fnOrderCalc(lstrSelectedkotDet);
  }
  fnSaveMergeKot(){

    print('SAVE MERGE');
    if(lstrMergeKotDocno.length < 2){
      showToast( 'Please Select Orders');
      return;
    }

    var lstrKot = [];
    var lstrKotDet = [];
    var lstrKotMerge = [];

    try{
      var totalAmount = 0.0;
      var totalQty = 0.0;
      var grossAmount = 0.0;
      var vatAmount = 0.0;
      var taxable = 0.0;
      var totTaxable = 0.0;
      var srno =0 ;
      var lsrno =0 ;
      for(var e in lstrSelectedkotDet){
        var qty = g.mfnDbl(e["QTY1"]);
        var vQty = e["VOID_QTY"]??0;
        var price = e["RATE"].toString();
        var sts =  e["STATUS"];
        var vatSts = e["TAXINCLUDE_YN"];
        var vatP = e["TAX_PERC"]??0.0;
        var vat = 0.0;
        var vatA = 0.0;
        var gross = 0.0;
        //var aQty = int.parse(qty)- vQty;
        var total = qty *  double.parse(price);

        if(vatSts == 'Y' && vatP > 0){
          var dvd = 100 /(100+vatP);
          vat =  total * dvd;
          vatA = total - vat;
          taxable = total - vatA;
          totTaxable = (totTaxable +total) - vatA;
          totalAmount =totalAmount +total ;

        }else{
          vat = (vatP)/100;
          vatA = total * vat;
          taxable =total;
          totTaxable = (totTaxable +total);
          totalAmount =totalAmount +total + vatA;
        }
        e['TAX_AMT'] = vatA;
        grossAmount = grossAmount +total;
        vatAmount = vatA + vatAmount;
        gross = total ;
        totalQty = totalQty + qty;

        var netAmt =  gross +vatA;

        srno =srno +1;
        if(qty != 0){
          lsrno = lsrno +1;
        }
        if(g.wstrOrderMode == "CANCEL"){
          lstrKotDet.add({
            "COMPANY":g.wstrCompany,
            "YEARCODE":g.wstrYearcode,
            "DOCNO":e["DOCNO"],
            "SRNO":srno,
            "LINE_SRNO":int.parse(qty) == 0 ? -1 : lsrno,
            "STKCODE":e["STKCODE"],
            "STKDESCP":e["STKDESCP"],
            "UNIT1":e["UNIT1"],
            "PRINT_CODE":e["PRINT_CODE"],
            "QTY1":0,
            "RATE":price,
            "RATEFC":price,
            "GRAMT":0,
            "GRAMTFC":0,
            "AMT":0,
            "AMTFC":0,
            "REF1":e["REF1"],
            "REF2":"",
            "CREATE_USER":g.wstrUserCd,
            "KITCHENCODE":e["KITCHENCODE"],
            "ADDON_YN":"",
            "ADDON_STKCODE":"",
            "STATUS":"C",
            "ORDER_PRIORITY":0,
            "TAXINCLUDE_YN":e['TAXINCLUDE_YN'],
            "TAX_PER":g.mfnDbl(e["TAX_PER"]),
            "TAX_AMT":vatA,
            "TAX_AMTFC":vatA,
            "TAXABLE_AMT":taxable,
            "TAXABLE_AMTFC":taxable,
          });
        }else{
          lstrKotDet.add({
            "COMPANY":g.wstrCompany,
            "YEARCODE":g.wstrYearcode,
            "DOCNO":e["DOCNO"],
            "SRNO":srno,
            "LINE_SRNO":qty == 0 ? -1 : lsrno,
            "STKCODE":e["STKCODE"],
            "STKDESCP":e["STKDESCP"],
            "UNIT1":e["UNIT1"],
            "PRINT_CODE":e["PRINT_CODE"],
            "QTY1":qty,
            "RATE":price,
            "RATEFC":price,
            "GRAMT":gross,
            "GRAMTFC":gross,
            "AMT":gross,
            "AMTFC":gross,
            "REF1":e["REF1"],
            "REF2":"",
            "CREATE_USER":g.wstrUserCd,
            "KITCHENCODE":e["KITCHENCODE"],
            "ADDON_YN":"",
            "ADDON_STKCODE":"",
            "STATUS":e["STATUS"],
            "ORDER_PRIORITY":0,
            "TAXINCLUDE_YN":e['TAXINCLUDE_YN'],
            "TAX_PER":g.mfnDbl(e["TAX_PER"]),
            "TAX_AMT":vatA,
            "TAX_AMTFC":vatA,
            "TAXABLE_AMT":taxable,
            "TAXABLE_AMTFC":taxable,
          });
        }


      }

      lstrKot.add({
        "COMPANY" : g.wstrCompany,
        "YEARCODE":g.wstrYearcode,
        "DOCNO":g.wstrLastSelectedKotDocno,
        "SMAN":"",
        "CURR":"AED",
        "CURRATE":"1",
        "GRAMT":grossAmount,
        "GRAMTFC":grossAmount,
        "NETAMT":totalAmount,
        "NETAMTFC":totalAmount,
        "REMARKS":"",
        "REF1":"",
        "REF2":"",
        "REF3":"",
        "REF6":"",
        "PRINT_YN":"",
        "EDIT_USER":g.wstrUserCd,
        "EDIT_USER":g.wstrUserCd,
        "ORDER_TYPE" :"",
        "STATUS":"P",
        "TABLE_DET":"",
        "ORDER_PRIORITY":0,
        "TAX_PER":0,
        "TAX_AMT":vatAmount,
        "TAX_AMTFC":vatAmount,
        "TAXABLE_AMT":totTaxable,
        "TAXABLE_AMTFC":totTaxable,
        "CREATE_MACHINEID":g.wstrDeivceId,
        "CREATE_MACHINENAME":g.wstrDeviceName,
        "ORDER_MODE":g.wstrDeliveryMode,
        "ORDER_ROOM":"",
        "ORDER_REF":"",
      });

      srno =  0;
      for(var e in lstrMergeKotDocno){
        srno = srno+1;
        lstrKotMerge.add({
          "COMPANY":g.wstrCompany,
          "YEARCODE":g.wstrYearcode,
          "SRNO":srno,
          "KOT_DOCNO":e,
          "KOT_DOCTYPE":"KOT",
        });
      }


    }catch (e){
      print(e);
    }

    if(g.fnValCheck(lstrKot)){
      fnSaveMerge(lstrKot, lstrKotDet, "", [], lstrKotMerge);
    }


  }

  //SPLIT#
  fnSplit(){
    setState((){
      lstrSplitScreen = true;
      lstrSplitOption = 'EQ';
      
      lstrSplitBills.add("SLIP1");
      lstrSplitBills.add("SLIP2");
      var total = lstrLastTotal/lstrSplitBills.length;
      lstrSplitBillAmt =  total;

      var qty = 0.0;
      for(var e in lstrSelectedkotDet){
        qty  =  qty +  e["QTY1"];
      }
      lstrSplitBillQty = qty;
      lstrOldSplitBill = g.mfnJson(lstrSelectedkotDet);
    });
  
  }
  fnSplitBillEqually(mode){
    setState((){
      if(mode == "ADD"){
        if(lstrSplitOption == "QU"){
          if(lstrSplitBillQty >  lstrSplitBills.length){
            var slip =  "SLIP"+(lstrSplitBills.length +1).toString();
            lstrSplitBills.add(slip);
          }

        }else{
          var slip =  "SLIP"+(lstrSplitBills.length +1).toString();
          lstrSplitBills.add(slip);
        }
      }else if(mode == "CLEAR"){
          lstrSplitBills = [];
          lstrSplitBills.add("SLIP1");
          lstrSplitBills.add("SLIP2");
      }else if(mode == "SUB"){
        if(!(lstrSplitBills.length < 3)){
          var slip =  "SLIP"+(lstrSplitBills.length).toString();
          lstrSplitBills.remove(slip);
        }
      }

      var total = lstrLastTotal/lstrSplitBills.length;
      lstrSplitBillAmt =  total;

    });
  }
  fnSplitBillQuantity(){


    if(lstrSplitBillQty  < 1){
      showToast( 'QTY 1,Quantity wise split not possible');
    }

  }
  fnSplitItemSelection(datalist,value){
    setState((){

      if(value){
        lstrSelectedSplitItem.add(datalist);
      }else{
        lstrSelectedSplitItem.remove(datalist);
      }

    });
    fnDiscountCalc();
  }
  fnSplitAddOldToNew() {
    setState((){
      if (lstrSplitQtyBill == "") {
        showToast( 'Please select slip#');
      }else{
        if(lstrSelectedSplitItem.length > 0){
          //add item to new bill
          for(var e in lstrSelectedSplitItem){
            e["SPLIT_NO"] = lstrSplitQtyBill;
            lstrNewSplitBill.add(e);
            lstrOldSplitBill.remove(e);
          }

          lstrSelectedSplitItem = [];

        }else{
          showToast( 'Please select items');
        }
      }

    });
  }
  fnSplitAddNewToOld(mode,dataList) {
    setState((){
      var srno = dataList["SRNO"];
      var stkCode = dataList["STKCODE"];
      var selectedData = [];
      var qty = dataList["QTY1"];
      var itemQty = 0.0;
      var availableQty = 0.0;

      if(g.fnValCheck(lstrOldSplitBill)){
        selectedData = g.mfnJson(lstrOldSplitBill);
        selectedData.retainWhere((i){
          return i["STKCODE"] == stkCode && i["SRNO"] == srno;
        });
      } 
      if(g.fnValCheck(selectedData)){
        itemQty =  g.mfnDbl(selectedData[0]["QTY1"].toString());
      }
      
      if(mode == "ADD"){
        if(itemQty > qty){
          for(var e in lstrNewSplitBill){
            if(e["STKCODE"] == stkCode && e["SRNO"] == srno && e["SPLIT_NO"] == lstrSplitQtyBill){
              e["QTY1"] = qty+1;
            }
          }
          var removeSts = false;
          var removeData;
          for(var e in lstrOldSplitBill){
            if(e["STKCODE"] == stkCode && e["SRNO"] == srno){
              e["QTY1"] = e["QTY1"]-1;
              if(e["QTY1"] == 0){
                removeSts =true;;
                removeData = e;
              }
            }
          }
          if(removeSts){
            lstrOldSplitBill.remove(removeData);
          }
        }
      }else if(mode == "SUB"){
        if(qty < 1){
          lstrOldSplitBill.add(dataList);
          var removeData;
          for(var e in lstrNewSplitBill){
            if(e["STKCODE"] == stkCode && e["SRNO"] == srno && e["SPLIT_NO"] == lstrSplitQtyBill){
              removeData = e;
            }
          }
          lstrNewSplitBill.remove(removeData);
        }else{
          if(itemQty > 0){

            for(var e in lstrOldSplitBill){
              if(e["STKCODE"] == stkCode && e["SRNO"] == srno){
                e["QTY1"] = itemQty+1;
              }
            }


          }else{
            lstrOldSplitBill.add(dataList);
            for(var e in lstrOldSplitBill){
              if(e["STKCODE"] == stkCode && e["SRNO"] == srno){
                e["SPLIT_NO"] = "";
                e["QTY1"] = 1;
              }
            }
          }
          var removeSts =false;
          var removeData;
          for(var e in lstrNewSplitBill){
            if(e["STKCODE"] == stkCode && e["SRNO"] == srno && e["SPLIT_NO"] == lstrSplitQtyBill){
              e["QTY1"] = qty-1;
              if(e["QTY1"] <= 0){
                removeSts =true;;
                removeData = e;
              }
            }
          }
          if(removeSts){
            lstrNewSplitBill.remove(removeData);
          }
        }

      }
    });
  }
  fnSaveSplitKot(){
    var orders  = [];

    if(lstrSplitOption == "EQ"){
      for(var e in lstrSplitBills){
        var lstrKot = [];
        var lstrKotDet = [];
        var lstrKotMerge = [];

        try{
          var totalAmount = 0.0;
          var totalQty = 0.0;
          var grossAmount = 0.0;
          var vatAmount = 0.0;
          var taxable = 0.0;
          var totTaxable = 0.0;
          var srno =0 ;
          var lsrno =0 ;
          for(var e in lstrSelectedkotDet){
            var qty = g.mfnDbl(e["QTY1"]);
            var vQty = e["VOID_QTY"]??0;
            var price = e["RATE"].toString();
            var sts =  e["STATUS"];
            var vatSts = e["TAXINCLUDE_YN"];
            var vatP = e["TAX_PERC"]??0.0;
            var vat = 0.0;
            var vatA = 0.0;
            var gross = 0.0;
            //var aQty = int.parse(qty)- vQty;
            qty =  qty / lstrSplitBills.length;
            var total = qty *  double.parse(price);

            if(vatSts == 'Y' && vatP > 0){
              var dvd = 100 /(100+vatP);
              vat =  total * dvd;
              vatA = total - vat;
              taxable = total - vatA;
              totTaxable = (totTaxable +total) - vatA;
              totalAmount =totalAmount +total ;

            }else{
              vat = (vatP)/100;
              vatA = total * vat;
              taxable =total;
              totTaxable = (totTaxable +total);
              totalAmount =totalAmount +total + vatA;
            }
            e['TAX_AMT'] = vatA;
            grossAmount = grossAmount +total;
            vatAmount = vatA + vatAmount;
            gross = total ;
            totalQty = totalQty + qty;

            var netAmt =  gross +vatA;

            srno =srno +1;
            if(qty != 0){
              lsrno = lsrno +1;
            }
            if(g.wstrOrderMode == "CANCEL"){
              lstrKotDet.add({
                "COMPANY":g.wstrCompany,
                "YEARCODE":g.wstrYearcode,
                "DOCNO":e["DOCNO"],
                "SRNO":srno,
                "LINE_SRNO":int.parse(qty) == 0 ? -1 : lsrno,
                "STKCODE":e["STKCODE"],
                "STKDESCP":e["STKDESCP"],
                "UNIT1":e["UNIT1"],
                "PRINT_CODE":e["PRINT_CODE"],
                "QTY1":0,
                "RATE":price,
                "RATEFC":price,
                "GRAMT":0,
                "GRAMTFC":0,
                "AMT":0,
                "AMTFC":0,
                "REF1":e["REF1"],
                "REF2":"",
                "CREATE_USER":g.wstrUserCd,
                "KITCHENCODE":e["KITCHENCODE"],
                "ADDON_YN":"",
                "ADDON_STKCODE":"",
                "STATUS":"C",
                "ORDER_PRIORITY":0,
                "TAXINCLUDE_YN":e['TAXINCLUDE_YN'],
                "TAX_PER":g.mfnDbl(e["TAX_PER"]),
                "TAX_AMT":vatA,
                "TAX_AMTFC":vatA,
                "TAXABLE_AMT":taxable,
                "TAXABLE_AMTFC":taxable,
              });
            }else{
              lstrKotDet.add({
                "COMPANY":g.wstrCompany,
                "YEARCODE":g.wstrYearcode,
                "DOCNO":e["DOCNO"],
                "SRNO":srno,
                "LINE_SRNO":qty == 0 ? -1 : lsrno,
                "STKCODE":e["STKCODE"],
                "STKDESCP":e["STKDESCP"],
                "UNIT1":e["UNIT1"],
                "PRINT_CODE":e["PRINT_CODE"],
                "QTY1":qty,
                "RATE":price,
                "RATEFC":price,
                "GRAMT":gross,
                "GRAMTFC":gross,
                "AMT":gross,
                "AMTFC":gross,
                "REF1":e["REF1"],
                "REF2":"",
                "CREATE_USER":g.wstrUserCd,
                "KITCHENCODE":e["KITCHENCODE"],
                "ADDON_YN":"",
                "ADDON_STKCODE":"",
                "STATUS":e["STATUS"],
                "ORDER_PRIORITY":0,
                "TAXINCLUDE_YN":e['TAXINCLUDE_YN'],
                "TAX_PER":g.mfnDbl(e["TAX_PER"]),
                "TAX_AMT":vatA,
                "TAX_AMTFC":vatA,
                "TAXABLE_AMT":taxable,
                "TAXABLE_AMTFC":taxable,
              });
            }


          }

          lstrKot.add({
            "COMPANY" : g.wstrCompany,
            "YEARCODE":g.wstrYearcode,
            "DOCNO":g.wstrLastSelectedKotDocno,
            "SMAN":"",
            "CURR":"AED",
            "CURRATE":"1",
            "GRAMT":grossAmount,
            "GRAMTFC":grossAmount,
            "NETAMT":totalAmount,
            "NETAMTFC":totalAmount,
            "REMARKS":"",
            "REF1":"",
            "REF2":"",
            "REF3":"",
            "REF6":"",
            "PRINT_YN":"",
            "EDIT_USER":g.wstrUserCd,
            "EDIT_USER":g.wstrUserCd,
            "ORDER_TYPE" :"",
            "STATUS":"P",
            "TABLE_DET":"",
            "ORDER_PRIORITY":0,
            "TAX_PER":0,
            "TAX_AMT":vatAmount,
            "TAX_AMTFC":vatAmount,
            "TAXABLE_AMT":totTaxable,
            "TAXABLE_AMTFC":totTaxable,
            "CREATE_MACHINEID":g.wstrDeivceId,
            "CREATE_MACHINENAME":g.wstrDeviceName,
            "ORDER_MODE":g.wstrDeliveryMode,
            "ORDER_ROOM":"",
            "ORDER_REF":"",
          });

        }catch (e){
          print(e);
        }

        orders.add({
          "KOT": lstrKot,
          "KOTDET": lstrKotDet,
          "PASSCODE": "",
          "MODE": "ADD",
          "KOT_CHOICE": [],
          "KOT_TABLEDET": lstrSelectedKotTables,
          "KOT_ADDRESS": lstrSelectedAddress,
          "VOID_REASON_CODE": "",
          "VOID_REASON_DESCP": "",
        });
      }
    }
    else{


      for(var e in lstrSplitBills){
        var selectedData = [];
        if(g.fnValCheck(lstrNewSplitBill)){
          selectedData = g.mfnJson(lstrNewSplitBill);
          selectedData.retainWhere((i){
            return i["SPLIT_NO"] == e;
          });
        }
        if(g.fnValCheck(selectedData)){

          var lstrKot = [];
          var lstrKotDet = [];
          var lstrKotMerge = [];

          try{
            var totalAmount = 0.0;
            var totalQty = 0.0;
            var grossAmount = 0.0;
            var vatAmount = 0.0;
            var taxable = 0.0;
            var totTaxable = 0.0;
            var srno =0 ;
            var lsrno =0 ;
            for(var e in selectedData){
              var qty = g.mfnDbl(e["QTY1"]);
              var vQty = e["VOID_QTY"]??0;
              var price = e["RATE"].toString();
              var sts =  e["STATUS"];
              var vatSts = e["TAXINCLUDE_YN"];
              var vatP = e["TAX_PERC"]??0.0;
              var vat = 0.0;
              var vatA = 0.0;
              var gross = 0.0;
              var total = qty *  double.parse(price);

              if(vatSts == 'Y' && vatP > 0){
                var dvd = 100 /(100+vatP);
                vat =  total * dvd;
                vatA = total - vat;
                taxable = total - vatA;
                totTaxable = (totTaxable +total) - vatA;
                totalAmount =totalAmount +total ;

              }else{
                vat = (vatP)/100;
                vatA = total * vat;
                taxable =total;
                totTaxable = (totTaxable +total);
                totalAmount =totalAmount +total + vatA;
              }
              e['TAX_AMT'] = vatA;
              grossAmount = grossAmount +total;
              vatAmount = vatA + vatAmount;
              gross = total ;
              totalQty = totalQty + qty;

              var netAmt =  gross +vatA;

              srno =srno +1;
              if(qty != 0){
                lsrno = lsrno +1;
              }
              if(g.wstrOrderMode == "CANCEL"){
                lstrKotDet.add({
                  "COMPANY":g.wstrCompany,
                  "YEARCODE":g.wstrYearcode,
                  "DOCNO":e["DOCNO"],
                  "SRNO":srno,
                  "LINE_SRNO":int.parse(qty) == 0 ? -1 : lsrno,
                  "STKCODE":e["STKCODE"],
                  "STKDESCP":e["STKDESCP"],
                  "UNIT1":e["UNIT1"],
                  "PRINT_CODE":e["PRINT_CODE"],
                  "QTY1":0,
                  "RATE":price,
                  "RATEFC":price,
                  "GRAMT":0,
                  "GRAMTFC":0,
                  "AMT":0,
                  "AMTFC":0,
                  "REF1":e["REF1"],
                  "REF2":"",
                  "CREATE_USER":g.wstrUserCd,
                  "KITCHENCODE":e["KITCHENCODE"],
                  "ADDON_YN":"",
                  "ADDON_STKCODE":"",
                  "STATUS":"C",
                  "ORDER_PRIORITY":0,
                  "TAXINCLUDE_YN":e['TAXINCLUDE_YN'],
                  "TAX_PER":g.mfnDbl(e["TAX_PER"]),
                  "TAX_AMT":vatA,
                  "TAX_AMTFC":vatA,
                  "TAXABLE_AMT":taxable,
                  "TAXABLE_AMTFC":taxable,
                });
              }else{
                lstrKotDet.add({
                  "COMPANY":g.wstrCompany,
                  "YEARCODE":g.wstrYearcode,
                  "DOCNO":e["DOCNO"],
                  "SRNO":srno,
                  "LINE_SRNO":qty == 0 ? -1 : lsrno,
                  "STKCODE":e["STKCODE"],
                  "STKDESCP":e["STKDESCP"],
                  "UNIT1":e["UNIT1"],
                  "PRINT_CODE":e["PRINT_CODE"],
                  "QTY1":qty,
                  "RATE":price,
                  "RATEFC":price,
                  "GRAMT":gross,
                  "GRAMTFC":gross,
                  "AMT":gross,
                  "AMTFC":gross,
                  "REF1":e["REF1"],
                  "REF2":"",
                  "CREATE_USER":g.wstrUserCd,
                  "KITCHENCODE":e["KITCHENCODE"],
                  "ADDON_YN":"",
                  "ADDON_STKCODE":"",
                  "STATUS":e["STATUS"],
                  "ORDER_PRIORITY":0,
                  "TAXINCLUDE_YN":e['TAXINCLUDE_YN'],
                  "TAX_PER":g.mfnDbl(e["TAX_PER"]),
                  "TAX_AMT":vatA,
                  "TAX_AMTFC":vatA,
                  "TAXABLE_AMT":taxable,
                  "TAXABLE_AMTFC":taxable,
                });
              }


            }

            lstrKot.add({
              "COMPANY" : g.wstrCompany,
              "YEARCODE":g.wstrYearcode,
              "DOCNO":g.wstrLastSelectedKotDocno,
              "SMAN":"",
              "CURR":"AED",
              "CURRATE":"1",
              "GRAMT":grossAmount,
              "GRAMTFC":grossAmount,
              "NETAMT":totalAmount,
              "NETAMTFC":totalAmount,
              "REMARKS":"",
              "REF1":"",
              "REF2":"",
              "REF3":"",
              "REF6":"",
              "PRINT_YN":"",
              "EDIT_USER":g.wstrUserCd,
              "EDIT_USER":g.wstrUserCd,
              "ORDER_TYPE" :"",
              "STATUS":"P",
              "TABLE_DET":"",
              "ORDER_PRIORITY":0,
              "TAX_PER":0,
              "TAX_AMT":vatAmount,
              "TAX_AMTFC":vatAmount,
              "TAXABLE_AMT":totTaxable,
              "TAXABLE_AMTFC":totTaxable,
              "CREATE_MACHINEID":g.wstrDeivceId,
              "CREATE_MACHINENAME":g.wstrDeviceName,
              "ORDER_MODE":g.wstrDeliveryMode,
              "ORDER_ROOM":"",
              "ORDER_REF":"",
            });

          }catch (e){
            print(e);
          }

          orders.add({
            "KOT": lstrKot,
            "KOTDET": lstrKotDet,
            "PASSCODE": "",
            "MODE": "ADD",
            "KOT_CHOICE": [],
            "KOT_TABLEDET": lstrSelectedKotTables,
            "KOT_ADDRESS": lstrSelectedAddress,
            "VOID_REASON_CODE": "",
            "VOID_REASON_DESCP": "",
          });

        }

      }



    }
    print(orders);
    fnSaveSplit(orders);
  }

  fnGetTableName(lastOrderTable) {

    var tableName ='';
    for(var e in lastOrderTable){
      var t = e["TABLE_DESCP"];
      tableName =  tableName == "" ? t :t + ','+ tableName ;
    }
    return tableName;
  }
  fnOrderClick(dataList,code){
    //fnRemoveDiscount();
    setState(() {
      lstrDiscountScreen =false;
      lstrSelectedDiscount = "ITEM";
      lstrItemDiscountList = [];
      lstrSelectedRecpDisc = [];
      lstrItemWiseDiscList = [];
      lstrSelectedItemDisc = [];
      lstrDiscountItems = [];
      lstrAppliedDisc = [];

      lstrBalanceAmt = 0.00;
      lstrPaidAmt=0.00;
      lstrLastGross = 0.00;
      lstrLastVat = 0.00;
      lstrLastOtherAmount = 0.00;
      lstrLastTotal = 0.00;
      lstrTaxable = 0.00;
      lstrLastDiscount = 0.00;
    });


    fnClear();
    var kot  = dataList['KOT'];
    var kotDet  = dataList['KOTDET'];
    var kotTables  = dataList['KOT_TABLEDET'];
    var kotAddress  = dataList['KOT_ADDRESS'];
    var lstrOrderType  =  kot[0]["ORDER_TYPE"];
    var lstrCreateUser  =  kot[0]["CREATE_USER"];
    var lstrDoctype  =  kot[0]["DOCTYPE"];
    var lstrCustomerName  = "";
    var lstrCustomerMob  =  "";
    if(g.fnValCheck(kotAddress)){
      lstrCustomerName  =  kotAddress[0]["FNAME"].toString();
      lstrCustomerMob  =  kotAddress[0]["PHONE1"].toString();
    }

    var lstrCreateDate = kot[0]["CREATE_DATE"]??'';
    if(lstrCreateDate != ""){
      var now = DateTime.now();
      lstrCreateDate = formatTime.format(DateTime.parse(lstrCreateDate)).toString();
      lstrSelectedDate =lstrCreateDate;
    }

    var lstrTableNo = '';
    if(g.fnValCheck(kotTables)){
      lstrTableNo  =  fnGetTableName(kotTables);
    }
    lstrSelectedOrderType = lstrOrderType;
    lstrSelectedName = lstrCustomerName;
    lstrSelectedPhone = lstrCustomerMob;
    lstrSelectedDocno = code??'';
    lstrSelectedkot =kot;
    lstrSelectedkotDet = kotDet;
    lstrSelectedKotTables = kotTables;
    lstrSelectedAddress = kotAddress;
    lstrSelectedUser = lstrCreateUser;
    lstrSelectedDocType= lstrDoctype;
    lstrSelectedType = lstrOrderType == 'T' ?'Table  '+lstrTableNo :lstrOrderType == 'A' ? 'Takeaway' :lstrOrderType == 'D' ? 'Delivery' :'';
    lstrDeliveryMode= (kot[0]["ORDER_MODE"]??"")+' - '+(kot[0]["ORDER_MODE"]??"");
    lstrPaymentList =[];
    lstrSelectedBill.clear();
    lstrSelectedBill.add({
      "DOCNO":code,
      "TYPE": lstrSelectedType,
      "USER" :lstrSelectedUser,
      "NAME" : lstrCustomerName,
      "CASH" : 0.00,
      "CARD" : 0.00,
      "TOTAL_AMT":0.00,
      "PAID_AMT":0.00,
      "CHANGE_TO":0.00,
      "DELIVERY_MODE":kot[0]["REF3"]??"",
      "PARTYCODE":kot[0]["PARTYCODE"]??"",
      "PARTYNAME":kot[0]["PARTYNAME"]??"",
      "ORDER_ROOM":kot[0]["ORDER_ROOM"]??"",
      "ORDER_MODE":kot[0]["ORDER_MODE"]??"",
      "ORDER_REF":kot[0]["ORDER_REF"]??"",
      "ROOM_YN":kot[0]["ROOM_SERVICE_YN"]??"",
      "REF":"",
    });
    lstrLastDiscount = kot[0]["DISC_AMT"]??0.0;
    lstrLastAddlAmount = kot[0]["ADDL_AMT"]??0.0;


    fnGetOrderDetails(code);

  }
  fnRslClick(dataList,code){
    setState(() {
      lstrBalanceAmt = 0.00;
      lstrPaidAmt=0.00;
      lstrLastGross = 0.00;
      lstrLastVat = 0.00;
      lstrLastOtherAmount = 0.00;
      lstrLastTotal = 0.00;
      lstrTaxable = 0.00;
      lstrLastDiscount = 0.00;
      lstrLastAddlAmount = 0.00;
      lstrSelectedDocDate = '';
    });


    fnClear();
    var rsl  = dataList['RSL'];
    var rslDet  = dataList['RSLDET'];
    var otherCharges  = dataList['RSL_OTHERCHARGE']??[];
    var lstrCreateUser  =  rsl[0]["CREATE_USER"];

    setState(() {
      lstrSelectedCharges = otherCharges;
      lstrSelectedDocno = code??'';
      lstrSelectedRsl = rsl;
      lstrSelectedRslItems = rslDet;
      lstrSelectedUser = lstrCreateUser??'';
      lstrSelectedName =  (rsl[0]["ORDER_MODE"]??"").toString() + "  "+ (rsl[0]["REF6"]??"").toString();;
      lstrTaxable = rsl[0]["TAXABLE_AMTFC"]??0.0;
      lstrLastVat = rsl[0]["TAX_AMT"]??0.0;
      lstrLastOtherAmount = rsl[0]["OTHER_AMTFC"]??0.0;
      lstrLastDiscount = rsl[0]["DISC_AMT"]??0.0;
      lstrLastTotal = rsl[0]["NETAMT"]??0.0;
      lstrPaidAmt = rsl[0]["PAID_AMT"]??0.0;
      lstrBalanceAmt =  lstrLastTotal - lstrPaidAmt;
      lstrLastGross = rsl[0]["TAXABLE_AMTFC"]??0.0;
      lstrLastAddlAmount = rsl[0]["ADDL_AMT"]??0.0;
      lstrSelectedDocDate = formatDate.format(DateTime.parse(rsl[0]["DOCDATE"].toString())).toString();
      lstrSelectedDate = formatTime.format(DateTime.parse(rsl[0]["CREATE_DATE"].toString())).toString();


    });


  }
  fnOrderCalc(lastOrder){
    //lastOrderHead
    if(g.fnValCheck(lastOrder)){
      var totalAmount = 0.0;
      var grossAmount = 0.0;
      var totalQty = 0.0;
      var vatAmount = 0.0;
      var taxableAmount = 0.0;
      var totalAmt  = 0.0;
      var discount = 0.0;
      for(var e in lastOrder){
        var sts =  e["STATUS"];
        if(sts != 'C'){
          var qty = g.mfnDbl(e["QTY1"]);
          var vQty = e["VOID_QTY"]??0;
          var discAmt = g.mfnDbl(e["DISC_AMT"]);
          if(qty  > 0){
            var price = e["RATE"].toString();
            var total = (qty  *  double.parse(price)) - discAmt;
            totalAmt = totalAmt +total;
          }
        }
      }

      //1.OTHER_TAX >> FIND TOTAL TAX PERC
      var totalTaxPerc = 0.0;
      for(var f  in lstrOtherAmountList){
        //{CODE: MUN, DESCP: MUNCIPALITY FEE, SHORTDESCP: MUNCIPAL, PERC: 7.0, ACCODE: 106007, VAT_PERC: null, VAT_ACCODE: null}
        var perc  =  g.mfnDbl(f["PERC"]);
        var vatPerc  =  g.mfnDbl(f["VAT_PERC"]);
        var vatPerc1 = 0.0;
        vatPerc1 = (perc*vatPerc)/100;
        var totalVat = perc + vatPerc1;
        totalTaxPerc = totalTaxPerc + totalVat;
      }

      for(var e in lastOrder){
        var sts =  e["STATUS"];
        var vatSts = e["TAXINCLUDE_YN"];
        var vatP = e["TAX_PER"];
        var itemTotalTaxPerc  =  totalTaxPerc+vatP;
        var itemTaxable = 0.0;
        var itemConversionFactor  = 0.0;

        //2.OTHER_TAX >> FIND CONVERSION FACTOR



        if(sts != 'C'){
          var qty = g.mfnDbl(e["QTY1"]);
          var vQty = e["VOID_QTY"]??0;
          if(qty > 0){
            var price = e["RATE"].toString();
            var discAmt = g.mfnDbl(e["DISC_AMT"].toString());
            var amt = (qty *  double.parse(price)) - discAmt ;
            var headerDiscount = 0.0;
            if(totalAmt > 0){
              headerDiscount = (amt / totalAmt) * lstrLastDiscount;
            }
            var total = (amt - headerDiscount);
            itemConversionFactor =  ((100+itemTotalTaxPerc)/100);


            var vat = 0.0;
            var vatA = 0.0;
            if(vatSts == 'Y' && vatP > 0){
              itemTaxable = (total/itemConversionFactor);
              var dvd = 100 /(100+vatP);
              vat =  total * dvd;
              vatA = total - vat;
              taxableAmount = (taxableAmount + total) - vatA;
              totalAmount = totalAmount +total ;
            }else{
              vat = (vatP)/100;
              vatA = total * vat;
              taxableAmount = (taxableAmount +total);
              totalAmount =totalAmount +total + vatA;
            }
            grossAmount = grossAmount +amt;
            vatAmount = vatA + vatAmount;
            totalQty = totalQty + qty;
          }

        }
      }

      // //other amount
      // lstrLastOtherAmount = 0.00;
      // var otherTotalTaxPerc = 0.0;
      //
      // for(var e  in lstrOtherAmountList){
      //   //{CODE: MUN, DESCP: MUNCIPALITY FEE, SHORTDESCP: MUNCIPAL, PERC: 12.0, ACCODE: 106007}
      //   var perc  =  g.mfnDbl(e["PERC"]);
      //   var amt =  (g.mfnDbl(taxableAmount) *  perc)/100;
      //   lstrLastOtherAmount =  lstrLastOtherAmount+amt;
      // }


      setState(() {
        lstrLastTotal = totalAmount + lstrLastAddlAmount + lstrLastOtherAmount;
        lstrLastGross = grossAmount;
        lstrTaxable = taxableAmount;
        lstrLastVat = vatAmount;
        if(g.fnValCheck(lstrSelectedBill)){
          lstrSelectedBill[0]["TOTAL_AMT"] = totalAmount +  lstrLastAddlAmount +lstrLastOtherAmount;
        }
      });



    }else{

      setState(() {
        lstrLastTotal = 0.00;
        lstrLastGross = 0.00;
        lstrLastVat = 0.00;
        lstrLastOtherAmount = 0.00;
        lstrTaxable = 0.00;
        lstrLastDiscount = 0.00;
      });
    }

    fnPaidCalc();
  }
  fnPosCardClick(type) async{
    final SharedPreferences prefs = await _prefs;
    setState(() {
      lstrDiscountScreen = false  ;
      lstrPosSelection = type;
    });
    fnClear();
    if(type =='All'){
      fnGetOrders(null, null,"");
    }else if(type =='H'){
      setState(() {
        lstrSelectedRslItems = [];
      });
      fnGetRsl(null,null,null,null,"");
    }else if(type =='N'){
      g.wstrOrderScreenMode = "P";

      prefs.setString('wstrOrderScreenMode',"P");

      Navigator.pushReplacement(context, NavigationController().fnRoute(1));
    }else if(type =='R'){
      setState(() {
        lstrSelectedRslItems = [];
      });
      fnGetRsl(null,null,null,null,lstrSideOrderMode);
    }else if(type =='RS'){
      fnGetOrders(null, null,lstrSideOrderMode);
    }else{

      fnGetOrders(type, null,"");
    }
  }
  fnRefresh(){
    fnPageRefresh();

  }
  fnUpdateTime(){
    setState(() {
      var now = DateTime.now();
      lstrTime = formatTimeSecond.format(now) ;
    });
  }
  fnClear(){
    setState(() {
      lstrRsl = [];
      lstrRslDet=[];
      lstrRslVoid = [];
      lstrRslVoidDet = [];


      lstrSelectedDocno = '' ;
      lstrSelectedDocType = '' ;
      lstrSelectedType = '' ;
      lstrSelectedUser = '' ;
      lstrSelectedName = '' ;
      lstrSelectedPhone = '' ;
      lstrDeliveryMode='';


      lstrBalanceAmt = 0.00;
      lstrPaidAmt=0.00;
      lstrLastGross = 0.00;
      lstrLastVat = 0.00;
      lstrLastOtherAmount = 0.00;
      lstrLastTotal = 0.00;
      lstrTaxable = 0.00;
      lstrLastDiscount = 0.00;
      lstrLastAddlAmount = 0.00;

      lstrSelectedAddlList = [];
      lstrSelectedkot = [];
      lstrSelectedkotDet = [];
      lstrSelectedKotTables = [];
      lstrSelectedAddress = [];
      lstrAddlAmount = [];

      lstrSelectedDiscount = "ITEM";
      lstrItemDiscountList = [];
      lstrSelectedRecpDisc = [];
      lstrItemWiseDiscList = [];
      lstrSelectedItemDisc = [];
      lstrDiscountItems = [];
      lstrAppliedDisc = [];
      lstrMergeKotDocno = [];
      lstrSplitScreen = false;
      lstrBottomOption = "";

      lstrSplitOption = '';
      lstrSplitBills = [];
      lstrSplitBillAmt= 0.0;
      lstrSplitBillQty = 0.0;
      lstrSplitQtyBill = '';
      lstrNewSplitBill = [];
      lstrOldSplitBill = [];
      lstrSelectedSplitItem = [];


      txtCash.text = '0';
      txtCard.text = '0';

    });
  }
  fnSave(){

    if(lstrSelectedDocno.isEmpty){
      showToast( 'Please choose order');
      return;
    }
    setState(() {
      lstrPayMode = '';
    });
    if(g.fnValCheck(lstrSelectedBill)){
      var lcash = 0.0;
      var lcard = 0.0;
      var lpaid = 0.0;
      var lchangeto = 0.0;
      var data = lstrSelectedBill[0];
      lcard = data["CARD"]??0.0;
      lcash = data["CASH"]??0.0;
      lpaid = data["PAID_AMT"]??0.0;
      lchangeto = data["CHANGE_TO"]??0.0;

      setState(() {
        lstrPayMode = lcash > 0 ?'CASH':'';
        lstrPaidAmt = lpaid  ;
        lstrBalanceAmt =  lchangeto > 0 ? 0.00: lchangeto;
      });
    }else{
      showToast( 'Please select payment mode');
      return;
    }

    lstrRsl = [];
    lstrRslDet=[];
    lstrRslVoid = [];
    lstrRslVoidDet = [];
    lstrRslAddlCharge = [];
    var OTHER_AMT =[];
    var srno = 0;


    lstrLastTotal =  g.mfnDbl(lstrLastTotal.toStringAsFixed(3));
    if(lstrPaidAmt < lstrLastTotal && lstrPaymentList[0]["MODE"]!="CREDIT")
    {
      showToast( 'Please check your amount');
      return;
    }


    var data = lstrSelectedBill[0];
    lstrPartyCode=data["PARTYCODE"]??'';
    lstrPartyDescp=data["PARTYNAME"]??'';
    lstrAddress4=data["ORDER_REF"]??'';
    lstrRef=data["ORDER_MODE"]??'';
    if(lstrPaymentList[0]["MODE"]=="CREDIT"&& lstrPartyCode=="" )
    {
      showToast( 'Please Select Party');
      return;
    }
    setState(() {
      saveSts = false;
    });

    if(g.fnValCheck(lstrSelectedkotDet)){
      var totalAmount = 0.0;
      var grossAmount = 0.0;
      var totalQty = 0.0;
      var vatAmount = 0.0;
      var otherAmount = 0.00;
      var taxableAmount = 0.0;
      var totalAmt  = 0.0;
      var discount = 0.0;
      for(var e in lstrSelectedkotDet){
        var sts =  e["STATUS"];
        if(sts != 'C'){
          var qty = g.mfnDbl(e["QTY1"]);
          var vQty = e["VOID_QTY"]??0;
          var discAmt = g.mfnDbl(e["DISC_AMT"]);
          if(qty  > 0){
            var price = e["RATE"].toString();
            var total = (qty *  double.parse(price)) - discAmt;
            totalAmt = totalAmt +total;
          }

        }
      }



      for(var e in lstrSelectedkotDet){
        srno = srno + 1;
        var sts =  e["STATUS"];
        var vatSts = e["TAXINCLUDE_YN"];
        var vatP = e["TAX_PER"];

        if(sts != 'C'){
          var qty = g.mfnDbl(e["QTY1"]);
          var vQty = e["VOID_QTY"]??0;
          var discAmt = g.mfnDbl(e["DISC_AMT"]);
          if(qty > 0){
            var price = e["RATE"].toString();
            var gramt = (qty *  double.parse(price)) ;
            var amt = (qty *  double.parse(price)) - discAmt ;
            var headerDiscount = 0.0;
            var headerAddlAmount  = 0.0;
            if(totalAmt > 0){
              headerDiscount = (amt / totalAmt) * lstrLastDiscount;
              headerAddlAmount  = (amt / totalAmt) * lstrLastAddlAmount;
            }
            var total = (amt - headerDiscount);
            var taxableAmt = 0.00;
            var vat = 0.0;
            var vatA = 0.0;
            if(vatSts == 'Y' && vatP > 0){
              var dvd = 100 /(100+vatP);
              vat =  total * dvd;
              vatA = total - vat;
              taxableAmt = total - vatA;
              taxableAmount = (taxableAmount + total) - vatA;
              totalAmount = totalAmount +total ;
            }else{
              vat = (vatP)/100;
              vatA = total * vat;
              taxableAmt =total;
              taxableAmount = (taxableAmount +total);
              totalAmount =totalAmount +total + vatA;
            }
            grossAmount = grossAmount + amt;
            vatAmount = vatA + vatAmount;
            totalQty = totalQty + qty;
            lstrRslDet.add({
              "COMPANY":g.wstrCompany,
              "YEARCODE":g.wstrYearcode,
              "SRNO":srno,
              "DUEDATE":"",
              "STKCODE":e["STKCODE"],
              "STKDESCP":e["STKDESCP"],
              "STKBARCODE":"",
              "RETURNED_YN":"",
              "FOC_YN":"",
              "LOC":"",
              "UNIT1":e["UNIT1"],
              "QTY1":e["QTY1"],
              "UNITCF":e["UNITCF"],
              "RATE":e["RATE"],
              "RATEFC":e["RATEFC"],
              "GRAMT":double.parse(gramt.toStringAsFixed(5)) ,
              "GRAMTFC": double.parse(gramt.toStringAsFixed(5)) ,
              "DISC_AMT":g.mfnDbl(e["DISC_AMT"].toString()),
              "DISC_AMTFC":g.mfnDbl(e["DISC_AMTFC"].toString()) * g.wstrCurrencyRate,
              "DISC_CODE":e["DISC_CODE"],
              "DISC_DESCP":e["DISC_DESCP"],
              "DISCPERCENT":e["DISCPERCENT"],
              "AMT": double.parse(amt.toStringAsFixed(5)),
              "AMTFC":double.parse(amt.toStringAsFixed(5)),
              "ADDL_AMT":headerAddlAmount,
              "ADDL_AMTFC":headerAddlAmount * g.wstrCurrencyRate,
              "AC_AMT":"",
              "AC_AMTFC":"",
              "PRVDOCTABLE":"KOT",
              "PRVYEARCODE":e["YEARCODE"],
              "PRVDOCNO":lstrSelectedDocno,
              "PRVDOCTYPE":lstrSelectedDocType,
              "PRVDOCSRNO":e["SRNO"],
              "PRVDOCQTY":e["QTY1"],
              "PRVDOCPENDINGQTY":e["PENDINGQTY"],
              "PENDINGQTY":e["PENDINGQTY"],
              "CLEARED_QTY":e["CLEARED_QTY"],
              "ADDON_STKCODE":e["ADDON_STKCODE"],
              "REF1":"",
              "REF2":"",
              "REF3":"",
              "EXPIRYDATE":"",
              "AVGCOST":"",
              "AVGCOSTFC":"",
              "LASTCOST":"",
              "LASTCOSTFC":"",
              "HEADER_DISC_AMT": double.parse(headerDiscount.toStringAsFixed(5)),
              "HEADER_DISC_AMTFC":double.parse(headerDiscount.toStringAsFixed(5)) * g.wstrCurrencyRate,
              "HEADER_GIFT_VOUCHER_AMT":"",
              "HEADER_GIFT_VOUCHER_AMTFC":"",
              "TOT_TAX_AMT": double.parse(vatA.toStringAsFixed(5))  ,
              "TOT_TAX_AMTFC": double.parse(vatA.toStringAsFixed(5)) * g.wstrCurrencyRate,
              "GIFT_VOUCHER_NO":"",
              "GIFT_VOUCHER_AMT":"",
              "GIFT_VOUCHER_AMTFC":"",
              "HEADER_DISC_TAX_AMTFC":"",
              "HEADER_DISC_TAX_AMT":"",
              "RATE_INCLUDE_TAX":e["TAXINCLUDE_YN"],
              "EX_VATAMTFC":"",
              "EX_VATAMT":"",
              "ADVANCE_AMTFC":"",
              "ADVANCE_AMT":"",
              "TAXABLE_AMT":  double.parse(taxableAmt.toStringAsFixed(3))  ,
              "TAXABLE_AMTFC":double.parse(taxableAmt.toStringAsFixed(3)) * g.wstrCurrencyRate,
              "ORDER_TYPE":lstrSelectedOrderType
            });
          }
        }
      }


      //AddlAmount


      var srnoOther  = 1;
      otherAmount = 0.0;
      for(var e in lstrOtherAmountList){
        var perc  =  g.mfnDbl(e["PERC"]);
        var amt =  (g.mfnDbl(taxableAmount) *  perc)/100;
        //COMPANY,DOCNO,DOCTYPE,YEARCODE,SRNO,CODE,DESCP,PERC,AMTFC,AMT,ACCODE,CURR,CURRATE
        OTHER_AMT.add({
          "COMPANY":g.wstrCompany,
          "DOCNO":"",
          "DOCTYPE":"RSL",
          "YEARCODE":g.wstrYearcode,
          "SRNO":srnoOther,
          "CODE":e["CODE"],
          "DESCP":e["DESCP"],
          "PERC":e["PERC"],
          "AMTFC":amt.toStringAsFixed(3),
          "AMT":g.mfnDbl(amt).toStringAsFixed(3) * g.wstrCurrencyRate,
          "ACCODE":e["ACCODE"],
          "CURR":"AED",
          "CURRATE":1
        });
        srnoOther = srnoOther+1;
        otherAmount = otherAmount+amt;
      }



      setState(() {
        lstrLastTotal = double.parse(totalAmount.toStringAsFixed(3))  ;
        lstrLastGross = double.parse(grossAmount.toStringAsFixed(3)) ;
        lstrTaxable = double.parse(taxableAmount.toStringAsFixed(3)) ;
        lstrLastVat = double.parse(vatAmount.toStringAsFixed(3)) ;
        lstrLastOtherAmount = double.parse(otherAmount.toStringAsFixed(3)) ;
        lstrLastTotal =  lstrLastAddlAmount  + lstrLastTotal +lstrLastOtherAmount;
      });


    }
    var discPerc =  0.0;
    if(g.mfnDbl(lstrLastDiscount) > 0){
      discPerc = (lstrLastDiscount/(lstrLastTotal+lstrLastDiscount))*100;
    }
    lstrCashCredit="";
    if(lstrPaymentList.length==1 && lstrPaymentList[0]["MODE"]=="CREDIT")
      {
        lstrCashCredit='CR';
      }



    lstrRsl.add({
    "COMPANY":g.wstrCompany,
    "YEARCODE":g.wstrYearcode,
    "DUEDATE":null,
    "PARTYCODE":lstrPartyCode,
    "PARTYNAME":lstrPartyDescp,
    "GUESTCODE":"",
    "GUESTNAME":"",
    "PRVDOCNO":lstrSelectedDocno,
    "PRVDOCTYPE":lstrSelectedDocType,
    "CASH_CREDIT":lstrCashCredit,
    "CURR":g.wstrCurrency,
    "CURRATE":g.wstrCurrencyRate,
    "GRAMT":lstrLastGross,
    "GRAMTFC":lstrLastGross,
    "ADDL_AMT":lstrLastAddlAmount * g.wstrCurrencyRate,
    "ADDL_AMTFC":lstrLastAddlAmount ,
    "PAID_MOD1":"",
    "PAID_AMT1":0,
    "PAID_AMT1FC":0,
    "PAID_MOD2":"",
    "PAID_AMT2":0,
    "PAID_AMT2FC":0,
    "DISC_PERCENT":discPerc,
    "DISC_AMT": double.parse(lstrLastDiscount.toStringAsFixed(5)) ,
    "DISC_AMTFC":double.parse(lstrLastDiscount.toStringAsFixed(5)) ,
    "CHG_CODE":"",
    "CHG_AMT":0,
    "CHG_AMTFC":0,
    "EXHDIFF_AMT":0,
    "NETAMT":lstrLastTotal,
    "NETAMTFC":lstrLastTotal * g.wstrCurrencyRate,
    "PAID_AMT":double.parse(lstrPaidAmt.toStringAsFixed(5)) * g.wstrCurrencyRate ,
    "PAID_AMTFC":double.parse(lstrPaidAmt.toStringAsFixed(5)) ,
    "BAL_AMT":double.parse(lstrBalanceAmt.toStringAsFixed(5))* g.wstrCurrencyRate,
    "BAL_AMTFC":double.parse(lstrBalanceAmt.toStringAsFixed(5)) ,
    "AC_AMTFC":0,
    "AC_AMT":0,
    "REMARKS":"",
    "REF1":"",
    "REF2":"",
    "REF3":"",
    "REF4":"",
    "REF5":data["ORDER_REF"],
    "REF6":data["ORDER_ROOM"],
    "EDIT_USER":g.wstrUserCd,
    "SHIFNO":g.wstrShifNo.toString(),
    "GUEST_TEL":"",
    "CARD_TYPE":"",
    "CARDHOLDER_NAME":"",
    "CARD_AC":"",
    "CARD_DETAILS":"",
    "NOOF_PRINT":"",
    "GIFT_VOUCHER_NO":"",
    "GIFT_VOUCHER_AMT":"",
    "GIFT_VOUCHER_AMTFC":"",
    "LOYALTY_CARD_NO":"",
    "VAT_PERC":"",
    "COUNTER_NO":g.wstrDeivceId,
    "MACHINENAME":g.wstrDeviceName,
    "DOCUMENT_STATUS":"",
    "TAX_AMT": double.parse(lstrLastVat.toStringAsFixed(5))  * g.wstrCurrencyRate ,
    "TAX_AMTFC": double.parse(lstrLastVat.toStringAsFixed(5))  ,
    "TAXABLE_AMT": double.parse(lstrTaxable.toStringAsFixed(5)) * g.wstrCurrencyRate,
    "TAXABLE_AMTFC": double.parse(lstrTaxable.toStringAsFixed(5))  ,
    "ORDER_MODE": data["ORDER_MODE"]??'' ,
    "ORDER_ROOM": data["ORDER_ROOM"]??''  ,
    "ORDER_REF": data["ORDER_REF"]??'' ,
    "ORDER_TYPE":lstrSelectedOrderType,
    "OTHER_AMT": g.mfnDbl(lstrLastOtherAmount)  * g.wstrCurrencyRate,
    "OTHER_AMTFC": g.mfnDbl(lstrLastOtherAmount)  ,
    });


   fnSaveInvoice(OTHER_AMT);

  }
  fnPaymentCallBack(datalist,retailPay,paymentList){
   setState(() {
     lstrSelectedBill  = datalist;
     lstrRetailPay = retailPay;
     lstrPaymentList = paymentList;
   });
    saveSts? fnSave():'';
  }
  fnPaidCalc(){
    if(g.fnValCheck(lstrSelectedBill)){
      var lcash = 0.0;
      var lcard = 0.0;
      var lpaid = 0.0;
      var lchangeto = 0.0;
      var data = lstrSelectedBill[0];
      lcard = data["CARD"]??0.0;
      lcash = data["CASH"]??0.0;
      lpaid = data["PAID_AMT"]??0.0;
      lchangeto = data["CHANGE_TO"]??0.0;

      setState(() {
        lstrPaidAmt = lpaid ;
        lstrBalanceAmt =  lchangeto > 0 ? 0.00: lchangeto;
      });
    }

  }
  fnCalcPaidAmount(){
    var lstrLastCardPaid = 0.00;
    var lstrLastCashPaid = 0.00;
    var lstrLastPaidTotal = 0.00;
    var lstrLastChangeTo = 0.00;
    var amount = 0.00;
    if(g.fnValCheck(lstrPaymentList)){
      for (var e in lstrPaymentList) {
        var lcode = e["MODE"].toString();
        if(lcode == "CASH"){
          setState(() {
            lstrLastCashPaid = e["AMOUNT"] + lstrLastCashPaid;
          });
        }else{
          setState(() {
            lstrLastCardPaid = e["AMOUNT"] + lstrLastCardPaid;
          });
        }
        setState(() {
          amount = e["AMOUNT"] + amount;
        });
      }
    }
    setState(() {
      var balnc =  lstrLastTotal - amount ;
      lstrPaidAmt = amount ;
      lstrBalanceAmt =  balnc > 0 ? 0.00: balnc;
    });


  }
  fnOpeningCash(){
    PageDialog().showL(context, OpeningCash(
      fnCallBack: fnOpeningCashCallBack,
    ), 'Opening Cash');
  }
  fnOpeningCashCallBack(){

  }

  //Discount##
  fnDiscount(){

    if(!g.wstrDiscountYn){
      showToast( 'Please contact admin!');
      return;
    }
    if(lstrSelectedDocno.isEmpty){
      showToast( 'Please choose order');
      return;
    }
    // var templstrSelectedBill= [];
    // setState(() {
    //
    //   templstrSelectedBill.add({
    //     "DOCNO":'NEW',
    //     "TYPE": lstrSelectedOrderType,
    //     "USER" :g.wstrUserCd,
    //     "NAME" : '',
    //     "CASH" : 0.00,
    //     "CARD" : 0.00,
    //     "TOTAL_AMT":lstrLastTotal+lstrLastDiscount,
    //     "PAID_AMT":0.00,
    //     "CHANGE_TO":0.00
    //   });
    // });
    //
    // PageDialog().showL(context, Discount(
    //   fnCallBack: fnDiscountCallBack,
    //   oldValue: lstrLastDiscount,
    //   lstrDataList: templstrSelectedBill,
    // ), 'Discount');

    if(g.fnValCheck(lstrSelectedkot) && !lstrDiscountScreen){
      setState((){
        lstrDiscountScreen = true;
        lstrSelectedDiscount = "ITEM";
        lstrItemDiscountList = [];
        lstrSelectedRecpDisc = [];
        lstrItemWiseDiscList = [];
        lstrSelectedItemDisc = [];
        lstrDiscountItems = [];
      });
      fnGetDiscountList();
    }

  }
  Widget fnReceiptDiscount(){
    var templstrSelectedBill= [];
    setState(() {
      templstrSelectedBill.add({
        "DOCNO":'NEW',
        "TYPE": lstrSelectedOrderType,
        "USER" :g.wstrUserCd,
        "NAME" : '',
        "CASH" : 0.00,
        "CARD" : 0.00,
        "TOTAL_AMT":lstrLastTotal+lstrLastDiscount,
        "PAID_AMT":0.00,
        "CHANGE_TO":0.00
      });
    });

    return DiscountReceipt(
      fnCallBack: fnDiscountCallBack,
      oldValue: lstrLastDiscount,
      lstrDataList: templstrSelectedBill,
    );
  }
  fnDiscountCallBack(amount){
    setState(() {
      lstrLastDiscount = amount;
      lstrDiscountScreen = false;
    });

    fnOrderCalc(lstrSelectedkotDet);
    fnCalcPaidAmount();

    var lstrKot= [];

    fnUpdateKotDiscount(lstrSelectedDocno, lstrSelectedDocType, lstrLastDiscount);
  }
  fnItemWiseDiscSelect(stkcode,value){
    setState((){

      if(value){
        lstrSelectedItemDisc.add(stkcode);
      }else{
        lstrSelectedItemDisc.remove(stkcode);
      }

    });
    fnDiscountCalc();
  }
  fnApplyDiscount(data,code){

    setState((){
      if(lstrAppliedDisc.contains(code)){
        lstrAppliedDisc.remove(code);
      }else{
        var selectedData = g.mfnJson(lstrItemWiseDiscList);
        if(g.fnValCheck(selectedData)){
          selectedData.retainWhere((i){
            return i["CODE"] == code;
          });
        }
        for(var e in selectedData){
          var stkCode = e["STKCODE"];
          var selectedItem = g.mfnJson(lstrItemWiseDiscList);
          if(g.fnValCheck(selectedItem)){
            selectedItem.retainWhere((i){
              return i["STKCODE"] == stkCode;
            });
          }
          for(var f in selectedItem){
            lstrAppliedDisc.remove(f["CODE"]);
          }
        }
        lstrAppliedDisc.add(code);
      }
    });

    fnDiscountCalc();
  }
  fnDiscountCalc(){

    setState((){
      for(var k in lstrSelectedkotDet){
        k["DISC_AMT"] = 0.0;
        k["DISC_AMTFC"] = 0.0;
        k["DISC_CODE"] = '';
      }
      if(g.fnValCheck(lstrAppliedDisc)){
        for(var e in lstrAppliedDisc){
          var code  =  e;
          var descp  =  '';
          var itemList = g.fnValCheck(lstrSelectedItemDisc)?lstrSelectedItemDisc:lstrDiscountItems;
          var discData = g.mfnJson(lstrItemDiscountList);
          if(g.fnValCheck(discData)){
            discData.retainWhere((i){
              return  i["CODE"] == code;
            });
          }
          if(g.fnValCheck(discData)){
            descp = discData[0]["DESCP"];
          }
          for(var f in itemList){
            var stkcode = f;
            var perc = 0.0;
            var selectedData = g.mfnJson(lstrItemWiseDiscList);
            if(g.fnValCheck(selectedData)){
              selectedData.retainWhere((i){
                return i["STKCODE"] == stkcode && i["CODE"] == code;
              });
            }
            if(g.fnValCheck(selectedData)){
              perc = selectedData[0]["DISC_PERC"]??0.0;
              for(var k in lstrSelectedkotDet){
                var kotCode  =  k["STKCODE"];
                if(kotCode == stkcode){
                  var sts =  k["STATUS"];
                  if(sts != 'C'){
                    var qty = g.mfnDbl(k["QTY1"]);
                    if(qty  > 0){
                      var price = k["RATE"].toString();
                      var total = (qty *  double.parse(price));
                      var disca =  perc/100;
                      var discAmt =  total * disca;
                      k["DISC_AMT"] = discAmt;
                      k["DISC_AMTFC"] = discAmt;
                      k["DISC_CODE"] = code;
                      k["DISC_DESCP"] = descp;
                      k["DISCPERCENT"] = perc;
                    }
                  }
                }

              }
            }
          }
        }
      }
    });
    fnOrderCalc(lstrSelectedkotDet);
  }
  fnRemoveDiscount(){
    setState((){

      for(var k in lstrSelectedkotDet){
        k["DISC_AMT"] = 0.0;
        k["DISC_AMTFC"] = 0.0;
        k["DISC_CODE"] = '';
        k["DISCPERCENT"] = 0.0;
      }
      lstrDiscountScreen =false;
      lstrSelectedDiscount = "ITEM";
      lstrItemDiscountList = [];
      lstrSelectedRecpDisc = [];
      lstrItemWiseDiscList = [];
      lstrSelectedItemDisc = [];
      lstrDiscountItems = [];
      lstrAppliedDisc = [];
    });
    fnOrderCalc(lstrSelectedkotDet);
  }
  fnClockOut(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ShiftClosing()
    ));
  }
  fnAddlAmount(){
    if(lstrSelectedDocno.toString() == ""){
      return;
    }
    PageDialog().showL(context, AddlAmount(
      lstrDataList: lstrSelectedBill,
      fnCallBack: fnAddlCallBack,
      lstrAddlList: lstrSelectedAddlList,
    ), 'Additional Amount');
  }
  fnAddlCallBack(addlList,amount,addlDataList){
    setState(() {
      lstrAddlAmount = addlList;
      lstrLastAddlAmount = amount;
      lstrSelectedAddlList =  addlDataList;
    });
   fnOrderCalc(lstrSelectedkotDet);


    fnUpdateKotAddl(lstrSelectedDocno, lstrSelectedDocType, lstrLastAddlAmount,lstrAddlAmount);
  }
  fnReports(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ReportViewer()
    ));
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
              Expanded(child: tc((g.wstrPrinterName + " | " +g.wstrPrinterPath).toString(),Colors.black,20))
            ],
          )
        ],
      ),
    ), 'System Info');
  }
  fnChoosePrinter(){
    PageDialog().showS(context, PrinterSelection(
    ), 'Choose Printer');
  }

  fnSalesSummary(){

    if(g.wstrRoleCode == "QADMIN" || g.wstrRoleCode == "ADMIN" ){
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
  fnSalesSummarySuccess(data,user){
    if(data == '1'){
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => SalesSummary()
      ));
    }else{
      showToast( 'PERMISSION DENIED');
    }
  }


  //==================================API============================================


  //MERGE#
  fnSaveMerge(kot,kotDet,passcode,kotChoice,kotMerge) async{

    futureOrder=  apiCall.SaveMergeOrder(kot, kotDet, "ADD", passcode, kotChoice, kotMerge);
    futureOrder.then((value) => fnSaveMergeSuccess(value));
  }
  fnSaveMergeSuccess(value){
    setState((){
      print(value);
      fnClear();
      lstrBottomOption = "";
    });
    if(lstrPosSelection =='All'){
      fnGetOrders(null, null,"");
    }else if(lstrPosSelection =='H'){
      // fnGetRsl(null,null,null,null);
    }else if(lstrPosSelection =='RS'){
      fnGetOrders(null, null,lstrSideOrderMode);
    }else{
      fnGetOrders(lstrPosSelection, null,"");
    }
  }

  //SPLIT#
  fnSaveSplit(orders){
    futureOrder=  apiCall.SaveSplitOrder(g.wstrCompany, g.wstrYearcode, lstrSelectedDocno, lstrSelectedDocType, g.wstrUserCd, g.wstrDeivceId, orders);
    futureOrder.then((value) => fnSaveSplitSuccess(value));
  }
  fnSaveSplitSuccess(value) {
    setState(() {
      print(value);
      fnClear();
      lstrBottomOption = "";
    });
    if (lstrPosSelection == 'All') {
      fnGetOrders(null, null, "");
    } else if (lstrPosSelection == 'H') {
      // fnGetRsl(null,null,null,null);
    } else if (lstrPosSelection == 'RS') {
      fnGetOrders(null, null, lstrSideOrderMode);
    } else {
      fnGetOrders(lstrPosSelection, null, "");
    }
  }

  fnPageRefresh(){
    futureRefresh  = apiCall.pageRefresh(g.wstrCompany,g.wstrYearcode,"CASHIER",refreshTime);
    futureRefresh.then((value) => fnPageRefreshSuccess(value));
  }
  fnPageRefreshSuccess(value){
    var count = 0;
    var timeB  = '';
    if(g.fnValCheck(value)){
      count =  value[0]["COUNT"];
      timeB =  value[0]["TIME"];
    }
    else{
      timeB = refreshTime;
      count = pageCount;
    }
    if(pageCount != count){
      if(lstrPosSelection =='All'){
        fnGetOrders(null, null,"");
      }else if(lstrPosSelection =='H'){
        // fnGetRsl(null,null,null,null);
      }else if(lstrPosSelection =='RS'){
        fnGetOrders(null, null,lstrSideOrderMode);
      }else{
        fnGetOrders(lstrPosSelection, null,"");
      }
    }
    if(mounted){
      setState(() {
        refreshTime = timeB;
        pageCount = count;
      });
    }
  }

  fnGetOrders(type,tablenNo,mode) async{

    futureOrders =  apiCall.getKotInvoices(g.wstrCompany,g.wstrYearcode,null,type,tablenNo,mode,txtKotSearch.text);
    futureOrders.then((
        value) => fnGetOrderSuccess(value));
  }
  fnGetOrderSuccess(value){

  }
  fnGetOrderDetails(code) async{
    futureOrderDet =  apiCall.getKotInvoices(g.wstrCompany,g.wstrYearcode,code,null,null,"","");
    futureOrderDet.then((value) => fnGetOrderDetailsSuccess(value));
  }
  fnGetOrderDetailsSuccess(value){

    if(g.fnValCheck(value)){
      setState(() {
        lstrAddlAmount = value[0]['KOT_ADDL_CHARGES'];
      });
      fnOrderCalc(value[0]['KOTDET']);
    }


  }

  fnGetRsl(code,type,dateFrom,dateTo,mode) async{
    if(lstrPosSelection == "R"){
      mode = lstrSideOrderMode;
    }
    futureRsl=  apiCall.getInvoice(g.wstrCompany,g.wstrYearcode,code,type,dateFrom,dateTo,'','','','',mode,1);
    futureRsl.then((value) => fnGetRslSuccess(value));
  }
  fnGetRslSuccess(value){
    if(g.fnValCheck(value)){

    }

  }

  fnSaveInvoice(otherAmt) async{
    futureOrderSave =  apiCall.saveInvoice(lstrRsl,lstrRslDet,lstrRslVoid,lstrRslVoidDet,lstrRetailPay,wstrPageMode,lstrAddlAmount,null,g.wstrPrinterPath,"","","",otherAmt,"","","",[]);
    futureOrderSave.then((value) => fnSaveInvoiceSuccess(value));
  }
  fnSaveInvoiceSuccess(value){
    setState(() {
      saveSts = true;
    });
    fnClear();
    fnPosCardClick('All');
    if(g.fnValCheck(value)){
      var sts = value[0]['STATUS'].toString();
      var msg = value[0]['MSG'];
      if(sts == '1'){
        showToast( msg);

        setState(() {
          lstrPrintDocno = value[0]['CODE'];
        });
        fnPrint();
       //PageDialog().printDialog(context, fnPrint);
      }else{
        setState(() {
          lstrPayMode = "";
        });
      }
      showToast( msg);


    }

  }

  fnPrintKotCall(kot){

    if(g.fnValCheck(kot)){
      setState(() {
        lstrPrintKotDocno = kot[0]["DOCNO"];
        lstrPrintKotDoctype = kot[0]["DOCTYPE"];
        lstrPrintKotYearcode = kot[0]["YEARCODE"];
      });
    }

    PageDialog().printDialog(context, fnPrintKot);
  }
  fnPrintKot() async{
    Navigator.pop(context);
    if(printKot){
      setState(() {
        printKot = false;
      });
      futurePrintKot = apiCall.printOrder(g.wstrCompany, lstrPrintKotDocno, lstrPrintKotDoctype, lstrPrintKotYearcode, 1, g.wstrPrinterPath);
      futurePrintKot.then((value) => fnPrintKotSuccess(value));

    }

  }
  fnPrintKotSuccess(value){

    setState(() {
      printKot = true;
    });
  }

  fnPrint() async{

    if(printRsl){
      //Navigator.pop(context);
      setState(() {
        printRsl = false;
      });
      futurePrint =  apiCall.printInvoice(g.wstrCompany, g.wstrYearcode, lstrPrintDocno, "RSL", 1, g.wstrPrinterPath,lstrPayMode);
      futurePrint.then((value) => fnPrintSuccess(value));

    }

  }
  fnPrintSuccess(value){

    setState(() {
      lstrPayMode = "";
      printRsl = true;
    });
  }

  fnPrintHistory() async{

    if(printRslHistory){
      Navigator.pop(context);
      setState(() {
        printRslHistory = false;
      });
      futurePrint =  apiCall.printInvoice(g.wstrCompany, g.wstrYearcode, lstrPrintDocno, "RSL", 1, g.wstrPrinterPath,"");
      futurePrint.then((value) => fnPrintHistorySuccess(value));

    }

  }
  fnPrintHistorySuccess(value){

    setState(() {
      printRslHistory = true;
    });
  }

  fnReturnBill(){

    if(lstrSelectedDocno == ""){
      return false;
    }

    setState(() {
      returnRsl = [];
      returnRslDet = [];
      returnRslVoidHistory = [];
      returnRslVoidHistoryDet = [];
      returnRetailPay = [];
      lstrSelectedBill= [];
      lstrSelectedBill.add({
        "DOCNO":lstrSelectedDocno,
        "TYPE": lstrSelectedOrderType,
        "USER" :g.wstrUserCd,
        "NAME" : '',
        "DISCOUNT":lstrLastDiscount,
        "ADDL_AMT":lstrLastAddlAmount,
        "TAXABLE_AMT":lstrTaxable,
        "OTHER_AMT":lstrLastOtherAmount,
        "TOTAL_AMT":lstrLastTotal,
        "OTHER_CHARGES":lstrOtherAmountList,
        "OLD_CHARGES":lstrSelectedCharges
      });
    });

    PageDialog().showL(context, ReturnBill(
      lstrDataList: lstrSelectedBill,
      fnCallBack: fnReturnBillCallBack,
      lstrDataListDet: lstrSelectedRslItems,
      lstrRslHeader: lstrSelectedRsl,
    ), 'REOPEN BILL');
  }
  fnReturnBillCallBack(rsl,rsldet,retailpay,history,historydet,OTHER_AMT){
    setState(() {
      returnRsl = rsl;
      returnRslDet =rsldet;
      returnRetailPay = retailpay;
      returnOtherAmount = OTHER_AMT;
      returnRslVoidHistory = history;
      returnRslVoidHistoryDet =historydet;

      saveSts = true;
    });
    fnAdminPermission();

  }

  fnAdminPermission(){
    if(g.wstrRoleCode == "QADMIN" || g.wstrRoleCode == "ADMIN" ){
      setState(() {
        lstrVoidApprovedUser = g.wstrUserCd;
      });
      fnSaveInvoiceReturn(returnRsl,returnRslDet,returnRetailPay,returnRslVoidHistory,returnRslVoidHistoryDet,returnOtherAmount);
    }else{
      // showToast( 'Contact your admin!!');
      PageDialog().show_(context, OpenDrawer(
          fnCallBack:fnAdminPermissionSuccess
      ), '');

    }
  }
  fnAdminPermissionSuccess(data,user){
    if(data == '1'){
      setState(() {
        lstrVoidApprovedUser = user;
      });
      fnSaveInvoiceReturn(returnRsl,returnRslDet,returnRetailPay,returnRslVoidHistory,returnRslVoidHistoryDet,returnOtherAmount);

    }else{
      showToast( 'PLEASE CONTACT YOUR ADMIN!');
    }
  }

  fnSaveInvoiceReturn(rsl,rsldet,retailpay,history,historyDet,otherAmount) {
    if(saveSts){
      setState(() {
        saveSts = false;
      });
      futureOrderSave =  apiCall.saveInvoiceVoid(rsl,rsldet,[],[],retailpay,"EDIT",[],"",g.wstrPrinterPath,"CASH","N","",lstrVoidApprovedUser,history,historyDet,otherAmount);
      futureOrderSave.then((value) => fnSaveInvoiceReturnSuccess(value));
    }
  }
  fnSaveInvoiceReturnSuccess(value){
    setState(() {
      saveSts = true;
    });

    if(g.fnValCheck(value)){
      var sts = value[0]['STATUS'].toString();
      var msg = value[0]['MSG'];
      if(sts == '1'){
        setState(() {
          lstrSelectedRsl = [];
          lstrSelectedRslItems = [];
          lstrSelectedDocno = "";
          lstrPrintDocno = value[0]['CODE'];
        });
        //fnPrint();
        //PageDialog().printDialog(context, fnPrint);
      }
      fnGetRsl(null,null,null,null,"");
      showToast( msg);
    }
  }

  //Discount api
  fnGetDiscountList(){
    futureDiscount =  apiCall.getDiscountList(lstrSelectedDocno,lstrSelectedDocType,g.wstrCompany,g.wstrYearcode);
    futureDiscount.then((value) => fnGetDiscountListSuccess(value));
  }
  fnGetDiscountListSuccess(value){
    print(value);
    if(g.fnValCheck(value)){
      setState((){
        lstrItemDiscountList = [];
        lstrSelectedRecpDisc = [];
        lstrItemWiseDiscList = [];

        lstrItemDiscountList = value["Table1"];
        lstrItemWiseDiscList = value["Table2"];
        var table3 =  [];
        lstrItemWiseDiscList.forEach((e) {
          lstrDiscountItems.add(e["STKCODE"]);
        });

        // lstrItemWiseDiscList.forEach((e) {
        //   if(!lstrSelectedItemDisc.contains(e["STKCODE"])){
        //     lstrSelectedItemDisc.add(e["STKCODE"]);
        //   }
        // });
      });

    }
  }

  fnUpdateKotDiscount(docno, doctype, discAmt){
    setState(() {
      lstrDiscountScreen = false;
    });
    var totalAmount = 0.0;
    var grossAmount = 0.0;
    var totalQty = 0.0;
    var vatAmount = 0.0;
    var taxableAmount = 0.0;
    var totalAmt  = 0.0;
    var srno = 0;
    var kotDet = [];
    for(var e in lstrSelectedkotDet){
      srno = srno + 1;
      var sts =  e["STATUS"];
      var vatSts = e["TAXINCLUDE_YN"];
      var vatP = e["TAX_PER"];

      if(sts != 'C'){
        var qty = g.mfnDbl(e["QTY1"]);
        var vQty = e["VOID_QTY"]??0;
        var discAmt = g.mfnDbl(e["DISC_AMT"]);
        if(qty > 0){
          var price = e["RATE"].toString();
          var gramt = (qty *  double.parse(price)) ;
          var amt = (qty *  double.parse(price)) - discAmt ;
          var headerDiscount = 0.0;
          var headerAddlAmount  = 0.0;
          if(totalAmt > 0){
            headerDiscount = (amt / totalAmt) * lstrLastDiscount;
            headerAddlAmount  = (amt / totalAmt) * lstrLastAddlAmount;
          }
          var total = (amt - headerDiscount);
          var taxableAmt = 0.00;
          var vat = 0.0;
          var vatA = 0.0;
          if(vatSts == 'Y' && vatP > 0){
            var dvd = 100 /(100+vatP);
            vat =  total * dvd;
            vatA = total - vat;
            taxableAmt = total - vatA;
            taxableAmount = (taxableAmount + total) - vatA;
            totalAmount = totalAmount +total ;
          }else{
            vat = (vatP)/100;
            vatA = total * vat;
            taxableAmt =total;
            taxableAmount = (taxableAmount +total);
            totalAmount =totalAmount +total + vatA;
          }
          grossAmount = grossAmount + amt;
          vatAmount = vatA + vatAmount;
          totalQty = totalQty + qty;
          kotDet.add({
            "COMPANY":g.wstrCompany,
            "YEARCODE":g.wstrYearcode,
            "DOCNO":e["DOCNO"],
            "DOCTYPE":e["DOCTYPE"],
            "STKCODE":e["STKCODE"],
            "STKDESCP":e["STKDESCP"],
            "SRNO":e["SRNO"],
            "GRAMT":double.parse(gramt.toStringAsFixed(5)) ,
            "GRAMTFC": double.parse(gramt.toStringAsFixed(5)) ,
            "DISC_AMT":g.mfnDbl(e["DISC_AMT"].toString()),
            "DISC_AMTFC":g.mfnDbl(e["DISC_AMTFC"].toString()) * g.wstrCurrencyRate,
            "DISC_CODE":e["DISC_CODE"],
            "DISC_DESCP":e["DISC_DESCP"],
            "DISCPERCENT":g.mfnDbl(e["DISCPERCENT"]),
            "AMT": double.parse(amt.toStringAsFixed(5)),
            "AMTFC":double.parse(amt.toStringAsFixed(5)),
            "HEADER_DISC_AMT": double.parse(headerDiscount.toStringAsFixed(5)),
            "HEADER_DISC_AMTFC":double.parse(headerDiscount.toStringAsFixed(5)) * g.wstrCurrencyRate,
            "TAX_PER": e["TAX_PER"]  ,
            "TAX_AMT": double.parse(vatA.toStringAsFixed(5))  ,
            "TAX_AMTFC": double.parse(vatA.toStringAsFixed(5)) * g.wstrCurrencyRate,
            "TAXINCLUDE_YN":e["TAXINCLUDE_YN"],
            "TAXABLE_AMT":  double.parse(taxableAmt.toStringAsFixed(3))  ,
            "TAXABLE_AMTFC":double.parse(taxableAmt.toStringAsFixed(3)) * g.wstrCurrencyRate
          });
        }
      }
    }




    futureDiscount =  apiCall.updateKotDiscount(g.wstrCompany, g.wstrYearcode, docno, doctype, discAmt,kotDet);
    futureDiscount.then((value) => fnUpdateKotDiscountRes(value));
  }
  fnUpdateKotDiscountRes(value){
    setState(() {
      fnGetOrders(null, null,"");
    });
  }

  fnUpdateKotAddl(docno, doctype, discAmt,addlList){
    setState(() {
      lstrDiscountScreen = false;
    });
    var totalAmount = 0.0;
    var grossAmount = 0.0;
    var totalQty = 0.0;
    var vatAmount = 0.0;
    var taxableAmount = 0.0;
    var totalAmt  = 0.0;
    var srno = 0;
    var kotDet = [];
    for(var e in lstrSelectedkotDet){
      srno = srno + 1;
      var sts =  e["STATUS"];
      var vatSts = e["TAXINCLUDE_YN"];
      var vatP = e["TAX_PER"];

      if(sts != 'C'){
        var qty = g.mfnDbl(e["QTY1"]);
        var vQty = e["VOID_QTY"]??0;
        var discAmt = g.mfnDbl(e["DISC_AMT"]);
        if(qty > 0){
          var price = e["RATE"].toString();
          var gramt = (qty *  double.parse(price)) ;
          var amt = (qty *  double.parse(price)) - discAmt ;
          var headerDiscount = 0.0;
          var headerAddlAmount  = 0.0;
          if(totalAmt > 0){
            headerDiscount = (amt / totalAmt) * lstrLastDiscount;
            headerAddlAmount  = (amt / totalAmt) * lstrLastAddlAmount;
          }
          var total = (amt - headerDiscount);
          var taxableAmt = 0.00;
          var vat = 0.0;
          var vatA = 0.0;
          if(vatSts == 'Y' && vatP > 0){
            var dvd = 100 /(100+vatP);
            vat =  total * dvd;
            vatA = total - vat;
            taxableAmt = total - vatA;
            taxableAmount = (taxableAmount + total) - vatA;
            totalAmount = totalAmount +total ;
          }else{
            vat = (vatP)/100;
            vatA = total * vat;
            taxableAmt =total;
            taxableAmount = (taxableAmount +total);
            totalAmount =totalAmount +total + vatA;
          }
          grossAmount = grossAmount + amt;
          vatAmount = vatA + vatAmount;
          totalQty = totalQty + qty;
          kotDet.add({
            "COMPANY":g.wstrCompany,
            "YEARCODE":g.wstrYearcode,
            "DOCNO":e["DOCNO"],
            "DOCTYPE":e["DOCTYPE"],
            "STKCODE":e["STKCODE"],
            "STKDESCP":e["STKDESCP"],
            "SRNO":e["SRNO"],
            "HEADER_DISC_AMT": double.parse(headerAddlAmount.toStringAsFixed(5)),
            "HEADER_DISC_AMTFC":double.parse(headerAddlAmount.toStringAsFixed(5)) * g.wstrCurrencyRate,
          });
        }
      }
    }


    futureDiscount =  apiCall.updateKotAddl(g.wstrCompany, g.wstrYearcode, docno, doctype, discAmt,kotDet,addlList);
    futureDiscount.then((value) => fnUpdateKotAddlRes(value));
  }
  fnUpdateKotAddlRes(value){
    setState(() {
      fnGetOrders(null, null,"");
    });
  }
  //nav
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


  apiGetOtherAmount(){
    futureOther =  apiCall.apiGetRslOtherAmount();
    futureOther.then((value) => apiGetOtherAMountRes(value));
  }
  apiGetOtherAMountRes(value){
    setState(() {
      lstrOtherAmountList =  [];
      if(g.fnValCheck(value)){
        //{CODE: MUN, DESCP: MUNCIPALITY FEE, SHORTDESCP: MUNCIPAL, PERC: 12.0, ACCODE: 106007}
        lstrOtherAmountList = value;
        //MUNCIPALITY TAX
      }
    });
  }

}

