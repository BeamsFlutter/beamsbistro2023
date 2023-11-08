

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';

class SalesSummary extends StatefulWidget {
  const SalesSummary({Key? key}) : super(key: key);

  @override
  State<SalesSummary> createState() => _SalesSummaryState();
}

class _SalesSummaryState extends State<SalesSummary> {


  //Global
  var g = Global();
  var apiCall =  ApiCall();

  late Future<dynamic> futureClosingData;
  var lstrClosingDet = [];
  var lstrClosing = [];
  var lstrClosingUser = [];
  var lstrClosingUserDet = [];

  var lstrSelectedDocno  = '';
  var lstrSelectedDoctype  = '';
  var lstrSelectedDate = '';
  var lstrSelectedCloseDate = '';
  var lstrSelectedUser = '';
  var lstrSelectedMacID = '';

  var lstrSelectedSale = 0.0;
  var lstrSelectedCash = 0.0;
  var lstrSelectedCard = 0.0;
  var lstrSelectedVoid = 0.0;
  var lstrSelectedDiscount = 0.0;
  var lstrSelectedAdv = 0.0;
  var lstrSelectedAddl = 0.0;

  var lstrSelectedExpCash  = 0.0;
  var lstrSelectedActualCash  = 0.0;
  var lstrSelectedGross  = 0.0;
  var lstrSelectedReturn  = 0.0;
  var lstrSelectedOpenCash  = 0.0;
  var lstrSelectedCashPayment  = 0.0;

  var lstrSelectedMode = 'D';

  var formatDate = new DateFormat('dd MMMM yyyy');
  var formatDate1 = new DateFormat('dd MMMM yyyy hh:mm a');
  var formatDate2 = new DateFormat('MM-dd-yyyy');

  DateTime lstrFromDate = DateTime.now();
  DateTime lstrToDate = DateTime.now();

  var lblFromDate ="" ;
  var lblToDate="" ;
  var lstrToday = '';
  var lstrDayMode = '';
  var radioMode = 'Today';
  var id=1;

  bool printMode = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        leading: Container(

          margin: EdgeInsets.only(left:10),
          child: InkWell(
            onTap: (){
              fnPageBack();
            },
            child: Icon(Icons.arrow_back,color: Colors.black,size: 25,),
          ),
        ),
        title: tc('Closing Summary',Colors.black,25),
        actions: [
          Container(
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Row(
          children: [
            Container(
              width: size.width*0.6,
              height: size.height*0.9,
              padding: EdgeInsets.all(10),
              decoration: boxDecoration(Colors.white, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [

                      GestureDetector(
                        onTap :(){
                          setState(() {
                            radioMode = 'Today';
                            id = 1;
                            lstrDayMode = 'T';
                            fnDateFromTo(lstrDayMode);
                          });
                        },
                        child:Row(
                          children: [
                            Container(
                              child: Radio(
                                value: 1,
                                groupValue: id,
                                onChanged: (val) {
                                  setState(() {
                                    radioMode = 'Today';
                                    id = 1;
                                    lstrDayMode = 'T';
                                    fnDateFromTo(lstrDayMode);
                                  });
                                },
                              ),
                            ),
                            Text(
                              'Today',
                              style: new TextStyle(fontSize: 10.0),
                            ),
                          ],

                        ) ,
                      ),
                      gapWC(5),
                      GestureDetector(
                        onTap :(){
                          setState(() {
                            radioMode = 'This Week';
                            id = 2;
                            lstrDayMode = 'W';
                            fnDateFromTo(lstrDayMode);
                          });
                        },
                        child:Row(
                          children: [
                            Container(
                              child: Radio(
                                value: 2,
                                groupValue: id,
                                onChanged: (val) {
                                  setState(() {
                                    radioMode = 'This Week';
                                    id = 2;
                                    lstrDayMode = 'W';
                                    fnDateFromTo(lstrDayMode);
                                  });
                                },
                              ),
                            ),
                            Text(
                              'This Week',
                              style: new TextStyle(fontSize: 10.0),
                            ),
                          ],

                        ) ,
                      ),
                      gapWC(5),
                      GestureDetector(
                        onTap :(){
                          setState(() {
                            radioMode = 'This Month';
                            id = 3;
                            lstrDayMode = 'M';
                            fnDateFromTo(lstrDayMode);
                          });
                        },
                        child:Row(
                          children: [
                            Container(
                              child: Radio(
                                value: 3,
                                groupValue: id,
                                onChanged: (val) {
                                  setState(() {
                                    radioMode = 'This Month';
                                    id = 3;
                                    lstrDayMode = 'M';
                                    fnDateFromTo(lstrDayMode);
                                  });
                                },
                              ),
                            ),
                            Text(
                              'This Month',
                              style: new TextStyle(fontSize: 10.0),
                            ),
                          ],

                        ) ,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              _selectFromDate(context);
                            },
                            child: Container(
                              height: 35,
                              padding: EdgeInsets.all(5),
                              width: size.width*0.15,
                              decoration: boxOutlineDecoration(Colors.white, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  gapWC(0),
                                  // ts(lblFromDate, PrimaryColor, 12),
                                  ts(lblFromDate, Colors.red[900], 12),
                                  Row(children: [
                                    Icon(Icons.date_range,size: 18,color: PrimaryColor,),
                                    gapWC(5),
                                  ],)
                                ],
                              ),
                            ),
                          ),
                          tc('  to ',Colors.black,12),
                          GestureDetector(
                            onTap: (){
                              _selectToDate(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              height: 35,
                              padding: EdgeInsets.all(5),
                              width: size.width*0.15,
                              decoration: boxOutlineDecoration(Colors.white, 10),
                              child: Row(

                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  gapWC(0),
                                  ts(lblToDate, Colors.red[900], 12),
                                  Row(children: [
                                    Icon(Icons.date_range,size: 18,color: PrimaryColor,),
                                    gapWC(5),
                                  ],)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Bounce(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                                decoration: boxDecoration(Colors.amber, 20),
                                child: Center(

                                  child: tc('SEARCH', Colors.black, 10),
                                ),
                              ), duration: Duration(milliseconds: 110),
                              onPressed: (){
                                setState(() {
                                  lstrSelectedDocno = '';
                                  lstrClosing = [];
                                  lstrClosingDet = [];
                                });
                                fnGetClosingDataFilter();
                              })
                        ],
                      )
                    ],
                  ),
                  gapHC(10),
                  Expanded(child: Container(

                    child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: lstrClosingDet.length,
                        itemBuilder: (context, index) {
                          var dataList = lstrClosingDet[index];

                          var docno  = dataList["DOCNO"]??"";
                          var doctype = dataList["DOCTYPE"]??"";
                          var docdate = dataList["DOCDATE"]??"";
                          var user = dataList["USER_CD"]??"";
                          var shiftNo = dataList["SHIFT_NO"]??"";
                          var macId = dataList["MACHINEID"]??"";
                          var macName = dataList["MACHINENAME"]??"";
                          var createDate = dataList["CREATED_DATE"]??"";
                          var remarks =  dataList["REMARKS"]??"";
                          var sale =  g.mfnDbl(dataList["TOT_NET_SALE"]);
                          var cash = g.mfnDbl(dataList["TOT_CASH"]);
                          var card = g.mfnDbl(dataList["TOT_CARD"]);
                          var discount = g.mfnDbl(dataList["TOT_DISCOUNT"]);
                          var voidAmt = g.mfnDbl(dataList["VOID_AMT"]);
                          var addlAmt = g.mfnDbl(dataList["ADDL_AMT"]);
                          var expCash = g.mfnDbl(dataList["EXPECTED_CASH"]);
                          var actCash = g.mfnDbl(dataList["ACTUAL_AMT"]);
                          var grossAmt = g.mfnDbl(dataList["TOT_GROSS_SALE"]);
                          var rtnAmount = g.mfnDbl(dataList["VOID_AMT"]);

                          var openCash = g.mfnDbl(dataList["OPEN_CASH"]);
                          var cashPayment = g.mfnDbl(dataList["CASH_PAYMENT"]);

                          var note = dataList["REMARKS"]??"";

                          docdate =docdate.toString().isNotEmpty? formatDate1.format(DateTime.parse(docdate)).toString():'';
                          createDate =docdate.toString().isNotEmpty? formatDate1.format(DateTime.parse(createDate)).toString():'';

                          return Bounce(
                            child: Container(
                              margin: EdgeInsets.only(bottom: 5),
                              padding: EdgeInsets.all(10),
                              decoration: boxBaseDecoration(lstrSelectedDocno == docno? redLight: blueLight, 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(5),
                                            decoration: boxBaseDecoration(Colors.white, 50),
                                            child: Center(
                                              child: Icon(Icons.date_range,size: 13,),
                                            ),
                                          ),
                                          gapWC(10),
                                          tc('#'+docno.toString() + ' -   CLOCK IN  '+docdate.toString(), Colors.black, 12),

                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          tc('SALE AMOUNT', Colors.black, 13),
                                          gapWC(5),
                                          tc(sale.toString(), Colors.black, 13),
                                        ],
                                      ),
                                    ],
                                  ),
                                  gapHC(5),
                                  lineC(0.2,Colors.black),
                                  gapHC(10),
                                  Row(
                                    children: [
                                      Icon(Icons.person,size: 12,),
                                      gapWC(5),
                                      ts( user.toString(), Colors.black, 12),
                                    ],
                                  ),
                                  gapHC(5),
                                  Row(
                                    children: [
                                      Icon(Icons.computer,size: 12,),
                                      gapWC(5),
                                      ts(macId.toString(), Colors.black, 12),
                                    ],
                                  ),
                                  gapHC(5),
                                  Row(
                                    children: [
                                      Icon(Icons.query_builder,size: 12,),
                                      gapWC(5),
                                      ts(createDate.toString(), Colors.black, 12),
                                    ],
                                  ),
                                  gapHC(5),
                                  lineC(0.2,Colors.black),
                                  gapHC(10),
                                  Row(
                                    children: [
                                      Icon(Icons.speaker_notes_rounded,size: 12,),
                                      gapWC(5),
                                      Expanded(child: ts(note.toString(), Colors.black, 12),)
                                    ],
                                  ),
                                  //
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     ts('CASH', Colors.black, 12),
                                  //     gapWC(5),
                                  //     ts(cash.toString(), Colors.black, 12),
                                  //   ],
                                  // ),
                                  // gapHC(5),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     ts('CARD', Colors.black, 12),
                                  //     gapWC(5),
                                  //     ts(card.toString(), Colors.black, 12),
                                  //   ],
                                  // ),
                                  // gapHC(10),



                                ],
                              ),
                            ),
                            duration: Duration(milliseconds: 110),

                            onPressed: (){
                              setState(() {
                                lstrSelectedDocno  = docno;
                                lstrSelectedDate = createDate;
                                lstrSelectedCloseDate = docdate;
                                lstrSelectedUser =user;
                                lstrSelectedMacID = macId;
                                lstrSelectedSale = sale;
                                lstrSelectedCash = cash;
                                lstrSelectedCard = card;
                                lstrSelectedVoid = voidAmt;
                                lstrSelectedDiscount = discount;
                                lstrSelectedAdv = 0.0;
                                lstrSelectedAddl = addlAmt;

                                lstrSelectedExpCash  = expCash;
                                lstrSelectedActualCash  = actCash;
                                lstrSelectedGross  = grossAmt;
                                lstrSelectedReturn  = rtnAmount;

                                lstrSelectedOpenCash  = openCash;
                                lstrSelectedCashPayment  = cashPayment;

                              });
                              fnGetClosingDet(docno);
                            },
                          );
                        }),
                  )),

                ],
              ),
            ),
            gapWC(10),
            Expanded(child:
            Container(
              padding: EdgeInsets.all(10),
              decoration: boxDecoration(Colors.white, 30),
              child: lstrClosing.isNotEmpty? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: boxBaseDecoration(greyLight, 10),
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Bounce(
                            child: Container(
                              width: size.width*0.15,
                              padding: EdgeInsets.all(10),
                              decoration: boxBaseDecoration(lstrSelectedMode == "D"? Colors.amber:greyLight, 10),
                              child: Center(
                                child: tc('DETAILS', Colors.black, 10),
                              ),
                            ),
                            duration: Duration(  milliseconds: 110 ),
                            onPressed: (){
                              setState(() {
                                lstrSelectedMode = 'D';
                              });
                            }),
                        Bounce(
                            child: Container(
                              width: size.width*0.15,
                              padding: EdgeInsets.all(10),
                              decoration: boxBaseDecoration(lstrSelectedMode == "C"? Colors.amber:greyLight, 10),
                              child: Center(
                                child: tc('CASHIER', Colors.black, 10),
                              ),
                            ),
                            duration: Duration(  milliseconds: 110 ),
                            onPressed: (){
                              setState(() {
                                lstrSelectedMode = 'C';
                              });
                            })
                      ],
                    ),
                  ),
                  gapHC(20),
                  tc('#'+lstrSelectedDocno.toString(), Colors.black, 15),
                  gapHC(10),
                  Row(
                    children: [
                      Icon(Icons.calendar_today,size: 12,),
                      gapWC(5),
                      tc('CLOCK IN   '+ lstrSelectedCloseDate.toString().toUpperCase(), Colors.black, 12),

                    ],
                  ),
                  gapHC(5),
                  lineC(0.2, Colors.black),
                  gapHC(10),
                  lstrSelectedMode == "C"?
                  Row(
                    children: [
                      Icon(Icons.calculate_sharp,size: 12,),
                      gapWC(5),
                      tc('CASHIER DETAILS', Colors.black, 12),
                    ],
                  ):gapHC(0),
                  lstrSelectedMode == "D"?
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.person,size: 12,),
                            gapWC(5),
                            ts( lstrSelectedUser.toString(), Colors.black, 12),
                          ],
                        ),
                        gapHC(5),
                        Row(
                          children: [
                            Icon(Icons.computer,size: 12,),
                            gapWC(5),
                            ts(lstrSelectedMacID.toString(), Colors.black, 12),
                          ],
                        ),
                        gapHC(5),
                        Row(
                          children: [
                            Icon(Icons.query_builder,size: 12,),
                            gapWC(5),
                            ts(lstrSelectedDate.toString().toUpperCase(), Colors.black, 12),
                          ],
                        ),
                        gapHC(10),
                        lineC(0.2, Colors.black),
                        gapHC(10),
                        Row(
                          children: [
                            Icon(Icons.money,size: 12,),
                            gapWC(5),
                            tc('CASH COUNTER', Colors.black, 12),
                          ],
                        ),
                        gapHC(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ts('OPEN CASH', Colors.black, 12),
                            gapWC(5),
                            ts(lstrSelectedOpenCash.toStringAsFixed(2), Colors.black, 12),
                          ],
                        ),
                        gapHC(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ts('CASH PAYMENT', Colors.black, 12),
                            gapWC(5),
                            ts(lstrSelectedCashPayment.toStringAsFixed(2), Colors.black, 12),
                          ],
                        ),
                        gapHC(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            tc('EXPECTED CASH', Colors.black, 12),
                            gapWC(5),
                            tc(lstrSelectedExpCash.toStringAsFixed(2), Colors.black, 12),
                          ],
                        ),
                        gapHC(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            tc('ACTUAL CASH', Colors.black, 12),
                            gapWC(5),
                            tc(lstrSelectedActualCash.toStringAsFixed(2), Colors.black, 12),
                          ],
                        ),
                        gapHC(10),
                        lineC(0.2, Colors.black),
                        gapHC(10),
                        Row(
                          children: [
                            Icon(Icons.shopping_cart_rounded,size: 12,),
                            gapWC(5),
                            tc('SALES DETAILS', Colors.black, 12),
                          ],
                        ),
                        gapHC(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ts('GROSS AMOUNT', Colors.black, 12),
                            gapWC(5),
                            ts(lstrSelectedGross.toStringAsFixed(2), Colors.black, 12),
                          ],
                        ),
                        gapHC(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ts('VOID', Colors.black, 12),
                            gapWC(5),
                            ts(lstrSelectedReturn.toStringAsFixed(2), Colors.black, 12),
                          ],
                        ),
                        gapHC(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ts('DISCOUNT', Colors.black, 12),
                            gapWC(5),
                            ts(lstrSelectedDiscount.toStringAsFixed(2), Colors.black, 12),
                          ],
                        ),
                        gapHC(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ts('ADDL AMOUNT', Colors.black, 12),
                            gapWC(5),
                            ts(lstrSelectedAddl.toStringAsFixed(2), Colors.black, 12),
                          ],
                        ),
                        gapHC(10),
                        lineC(0.2, Colors.black),
                        gapHC(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            tc('NET SALE ', Colors.black, 12),
                            gapWC(5),
                            tc(lstrSelectedSale.toStringAsFixed(2), Colors.black, 12),
                          ],
                        ),
                        gapHC(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ts('CASH', Colors.black, 12),
                            gapWC(5),
                            ts(lstrSelectedCash.toStringAsFixed(2), Colors.black, 12),
                          ],
                        ),
                        gapHC(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ts('CARD', Colors.black, 12),
                            gapWC(5),
                            ts(lstrSelectedCard.toStringAsFixed(2), Colors.black, 12),
                          ],
                        ),
                        gapHC(10),
                        lineC(0.2,Colors.black),
                        
                      ],
                    ),
                  ):
                  Expanded(
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: lstrClosingUser.length,
                      itemBuilder: (context,index){
                        var dataList  = lstrClosingUser[index];

                        var user  = dataList["USER_CD"]??"";

                        var paymodeData = g.mfnJson(lstrClosingUserDet);
                        paymodeData.retainWhere((i){
                          return i["USER_CD"] == user ;
                        });
                        var total  = 0.0;
                        var disc  = 0.0;
                        var voidAmt  = 0.0;
                        var openCash  = 0.0;

                        if(paymodeData.isNotEmpty){
                          disc = paymodeData[0]["DISC_AMT"];
                          openCash = paymodeData[0]["OPEN_CASH"];
                        }

                        for(var e in paymodeData){
                          var paidIN  =  g.mfnDbl(e["PAID_IN"]);
                          var vamt  =  g.mfnDbl(e["VOID_AMT"]);
                          total =  total+ paidIN;
                          voidAmt =  voidAmt+ vamt;
                        }

                        total = total+ openCash;

                        return Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.all(10),
                          decoration: boxDecoration(Colors.white,5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.person,size: 12,),
                                      gapWC(5),
                                      tc(user.toString().toUpperCase(), Colors.black, 12)
                                    ],
                                  ),
                                  Row(
                                    children: [

                                    ],
                                  )
                                ],
                              ),
                              gapHC(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ts('DISCOUNT',Colors.black,10),
                                  ts(disc.toStringAsFixed(2),Colors.red,10),

                                ],
                              ),
                              gapHC(5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ts('VOID',Colors.black,10),
                                  ts(voidAmt.toStringAsFixed(2),Colors.red,10),

                                ],
                              ),
                              gapHC(5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ts('OPEN CASH',Colors.black,10),
                                  ts(openCash.toStringAsFixed(2),Colors.green,10),

                                ],
                              ),
                              gapHC(5),
                              lineC(0.2, Colors.black),
                              gapHC(5),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildPayMode(paymodeData),
                              ),
                              gapHC(5),
                              lineC(0.2, Colors.black),
                              gapHC(5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  tc('TOTAL',Colors.black,10),
                                  tc(total.toStringAsFixed(2),Colors.black,10),

                                ],
                              )
                            ],
                          ),
                        );
                      },

                    ),
                  ),


                  gapHC(10),
                  Bounce(
                      child: Container(
                        decoration: boxDecoration(Colors.amber, 30),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.print,size: 15,),
                            gapWC(5),
                            tc('PRINT', Colors.black, 15)
                          ],
                        ),
                      ),
                      duration: Duration(milliseconds: 110),
                      onPressed: (){
                        fnHistoryPrint();
                      })
                ],
               
              )
              :Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/icons/ticket.png",
                    width: 200,),
                  gapHC(10),
                  ts("  Select Closing".toString(),greyLight,15),
                  gapHC(5),

                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  //======================WIDGET UI ========================


  _buildPayMode(userData) {
    List<Widget> payMode = [];

    userData.forEach((e) {
      payMode.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ts(e["PAYMENT_MODE"],Colors.black,10),
            ts(e["PAID_IN"].toString(),Colors.black,10),

          ],
        ),
      ));
    });

    return payMode;
  }

  //=======================PAGE FN =========================
  fnGetPageData(){
    fnGetClosingData();
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: lstrFromDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (pickedDate != null && pickedDate != lstrFromDate) {
      setState(() {
        lstrFromDate = pickedDate;
        lblFromDate  = formatDate.format(lstrFromDate).toString();
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: lstrToDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
    if (pickedDate != null && pickedDate != lstrToDate) {
      setState(() {
        lstrToDate = pickedDate;
        lblToDate  = formatDate.format(lstrToDate).toString();
      });
    }
  }


  fnDateFromTo(mode){
    var now = DateTime.now();
    lstrToday =  formatDate.format(now);

    setState(() {
      lstrDayMode = mode;
    });

    if(mode== "T"){

      setState(() {
        lblFromDate =  formatDate.format(now);
        lblToDate   =  formatDate.format(now);
        lstrToDate = now;
        lstrFromDate = now;
      });
    }else if(mode== "W"){

      setState(() {
        lblFromDate =  formatDate.format(now.subtract(Duration(days: now.weekday - 1)));
        lblToDate =  formatDate.format(now.add(Duration(days: DateTime.daysPerWeek - now.weekday)));
        lstrToDate = now.add(Duration(days: DateTime.daysPerWeek - now.weekday));
        lstrFromDate = now.subtract(Duration(days: now.weekday - 1));
      });
    }else if(mode== "M"){

      setState(() {
        var month = now.month;
        var year = now.month;
        DateTime lastDayOfMonth = new DateTime(now.year, now.month + 1, 0);
        lblFromDate =  formatDate.format(DateTime(now.year,now.month,1));
        lblToDate =  formatDate.format(DateTime(now.year, now.month + 1, 0));

        lstrToDate = DateTime(now.year, now.month + 1, 0);
        lstrFromDate = DateTime(now.year,now.month,1);

      });
    }
  }



  //=======================API CALL  ======================
    fnGetClosingData(){

      setState(() {
        g.wstrContext = this.context;
      });

      futureClosingData = apiCall.getClosingHistory(g.wstrCompany, g.wstrYearcode, '', 'DCS', '', '', '', '');
      futureClosingData.then((value) => fnGetClosingDataSuccess(value));
    }
    fnGetClosingDataFilter(){
    g.wstrContext = this.context;
    var from  =  formatDate2.format(lstrFromDate);
    var to  = formatDate2.format(lstrToDate);
    futureClosingData = apiCall.getClosingHistory(g.wstrCompany, g.wstrYearcode, '', 'DCS', '', '', from, to);
    futureClosingData.then((value) => fnGetClosingDataSuccess(value));
  }
    fnGetClosingDataSuccess(value){
      print(value);
      setState(() {
        lstrClosingDet = [];
      });
      if(g.fnValCheck(value)){

        setState(() {
          lstrClosingDet = value["Table1"];
        });
      }
    }

    fnGetClosingDet(docno){

    setState(() {
      lstrClosing = [];
      lstrClosingUser = [];
      lstrClosingUserDet = [];
    });

    g.wstrContext = this.context;
    futureClosingData = apiCall.getClosingHistory(g.wstrCompany, g.wstrYearcode, docno, 'DCS', '', '', '', '');
    futureClosingData.then((value) => fnGetClosingDetSuccess(value));
  }
    fnGetClosingDetSuccess(value){
    if(g.fnValCheck(value)){
      print(value);
      setState(() {
        lstrClosing =  value["Table1"];
        lstrClosingUser =  value["Table2"];
        lstrClosingUserDet =  value["Table3"];

        if(lstrClosing.isNotEmpty){
          var data =  lstrClosing[0];

        }

      });
    }
  }

    fnHistoryPrint(){
      if(printMode){
        setState(() {
          printMode = false;
        });
        futureClosingData = apiCall.printClosing(g.wstrCompany, g.wstrYearcode, lstrSelectedDocno, "DCS", 1, g.wstrPrinterPath);
        futureClosingData.then((value) => fnHistoryPrintSuccess(value));
      }
     }
    fnHistoryPrintSuccess(value){
      setState(() {
        printMode = true;
      });
      showToast( 'DONE');
    }


  //==========================OTHER ========================
  fnPageBack(){
    Navigator.pop(context);
  }
}
