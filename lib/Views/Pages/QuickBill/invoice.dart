import 'dart:async';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/responsiveHelper.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:beamsbistro/Views/Pages/Bill/open_drawer.dart';
import 'package:beamsbistro/Views/Pages/Bill/openingCash.dart';
import 'package:beamsbistro/Views/Pages/Bill/printerSelection.dart';
import 'package:beamsbistro/Views/Pages/Bill/return.dart';
import 'package:beamsbistro/Views/Pages/Bill/shiftClosing.dart';
import 'package:beamsbistro/Views/Pages/QuickBill/quicksale.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InvoiceHistory extends StatefulWidget {
  const InvoiceHistory({Key? key}) : super(key: key);

  @override
  _InvoiceHistoryState createState() => _InvoiceHistoryState();
}

class _InvoiceHistoryState extends State<InvoiceHistory> {

  //Global
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var g  =  Global();
  var apiCall  = ApiCall();
  late Future<dynamic> futureRsl;
  late Future<dynamic> futureGetHoldRsl;
  late Future<dynamic> futurePrint;
  late Future<dynamic> futureOrderSave;
  late Future<dynamic> futureDrawer;
  late Future<dynamic> futureRefresh;

  // array
  var lstrHoldBill = [];
  var lstrSelectedBill = [];
  var lstrSelectedRslItems = [];
  var lstrHoldRsl = [];
  var lstrHoldRslDet = [];
  var lstrHoldAddl = [];
  var lstrSelectedRsl = [];
  var lstrSelectedBookingInvoice = [];
  var lastOrder = [];
  var lstrSelectedBookingAllItems = [];

  var returnRsl = [];
  var returnRslDet = [];
  var returnRslVoidHistory = [];
  var returnRslVoidHistoryDet = [];
  var returnRetailPay = [];


  // variable
  bool printRslHistory  = true;
  bool saveSts  = true;
  bool printRsl  = true;
  bool printRslSpot  = true;
  var lstrTime ;
  var lstrSelectedBookingNo = '';
  var lstrSelectedInvoiceMode  =  'C';
  var lstrSelectedDocno  = '';
  var lstrSelectedOrderType = "A";
  var lstrBookingMode  =  'A';
  var lstrSelectedUser  = '';
  var lstrSelectedDate = '';
  var lstrSelectedDocDate = '';
  var finalBillYn = 'N';
  var lstrVoidApprovedUser  = '';


  var lstrTaxable = 0.00;
  var lstrLastVat = 0.00;
  var lstrLastDiscount = 0.00;
  var lstrLastAddlAmount = 0.00;
  var lstrLastTotal = 0.00;
  var lstrPaidAmt = 0.00;
  var lstrBalanceAmt = 0.00;
  var lstrAdvAmount = 0.00;
  var lstrLastGross = 0.00;
  var lstrFinalBillAdvAmount = 0.00;
  var lstrSelectedBookingDocType = '';
  var lstrSelectedBookingInvNo = '';
  var lstrPrintDocno  =  '';
  var lstrPrintPrvDocno  =  '';
  var pageCount = 0;
  var refreshTime = '';

  var formatDate = new DateFormat('dd-MM-yyyy hh:mm');
  var formatTimeSecond = new DateFormat('hh:mm:ss a');

  var txtSearchDocno  = TextEditingController();

  //O- ORDERVIEW |
  var sidePageView = "O";

  //late Timer timer;
  late Timer timerTime;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      lstrSelectedRslItems = [];
      lstrSelectedRsl =[];
      lstrSelectedDocno = '';
      lastOrder = [];
      lstrSelectedInvoiceMode = 'C';
      sidePageView = "H";
    });
    //timer = Timer.periodic(Duration(seconds: 3), (Timer t) => fnPageRefresh());
    timerTime =
        Timer.periodic(Duration(seconds: 1), (Timer t) => fnUpdateTime());

    fnGetRsl(null, null, null, null);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timerTime.cancel();
    //timer.cancel();
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: size.height*0.1,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: boxBaseDecoration(Colors.white, 0),
                    child:Row(
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
                            th(g.wstrUserName.toString().toUpperCase(), Colors.blueGrey, 15),
                            gapWC(20),
                            tcn(lstrTime??'',Colors.blueGrey,16),
                            gapWC(20),
                            tcn(g.wstrShifDescp.toString().toUpperCase(),Colors.blueGrey,16),
                            gapWC(20),

                            // GestureDetector(
                            //   onTap: (){
                            //     fnChoosePrinter();
                            //   },
                            //   child: Container(
                            //     height: 40,
                            //     width: 50,
                            //     margin: EdgeInsets.symmetric(horizontal: 5),
                            //     decoration: boxBaseDecoration(Colors.amber, 10),
                            //     child: Icon(Icons.print,color: Colors.black,size: 20,),
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: (){
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
                            GestureDetector(
                              onTap: (){
                                fnLogout();
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                decoration: boxBaseDecoration(greyLight, 10),
                                child: Icon(Icons.close,color: Colors.red,size: 30,),
                              ),
                            )
                          ],
                        )
                      ],
                    ) ,
                  ),
                  Container(
                    height: size.height*0.87,
                    child: Row(
                      children: [
                        Expanded(child: Container(
                          padding: EdgeInsets.all(10),
                          height: size.height*0.86,
                          child: Container(
                            decoration: boxBaseDecoration(greyLight, 0  ),
                            width: size.width*0.55,
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        invoiceCard('C','COMPLETED'),
                                        invoiceCard('H','HOLD'),
                                        invoiceCard('B','BOOKING'),
                                      ],
                                    ),
                                    RoundedInputField(
                                      hintText: 'Search.',
                                      txtRadius: 5,
                                      txtWidth: 0.35,
                                      txtHeight:35,
                                      txtController: txtSearchDocno,
                                      suffixIcon: Icons.cancel_outlined,
                                      suffixIconOnclick: (){
                                        fnClearSearch();
                                      },
                                      onChanged: (value){


                                        lstrSelectedInvoiceMode =='C' ? fnGetRsl(null, null, null, null) :
                                        lstrSelectedInvoiceMode =='H' ? fnGetHoldRsl() :
                                        lstrSelectedInvoiceMode == 'B' ? fnGetBookingRsl(null, null, null, null) : '';


                                      },
                                    ),
                                  ],
                                ),
                                gapHC(15),
                                lstrSelectedInvoiceMode != "H"?
                                Container(
                                  decoration: boxBaseDecoration(greyLight, 0  ),
                                  height: size.height*0.7,
                                  child: FutureBuilder<dynamic>(
                                    future: futureRsl,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return  lstrSelectedInvoiceMode == 'C'? rslView(snapshot):rslBookingView(snapshot)  ;
                                      } else if (snapshot.hasError) {
                                        return Container();
                                      }
                                      // By default, show a loading spinner.
                                      return Center(
                                        child: Container(),
                                      );
                                    },
                                  ),
                                ):Container(
                                    decoration: boxBaseDecoration(greyLight, 0  ),
                                    height: size.height*0.7,
                                    child: rslHoldView()
                                )

                              ],
                            ),
                          ),
                        ),),
                        Container(
                          padding: EdgeInsets.all(10),
                          color: Colors.white,
                          height:  size.height*0.86,
                          width: size.width*.3,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  th('Order #' +lstrSelectedDocno.toString() , Colors.black, 14),
                                  tc(lstrSelectedOrderType , PrimaryColor, 15),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.sticky_note_2_outlined,size: 13,),
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
                              line(),
                              Expanded(child: rslItemView(),),
                              Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    gapHC(5),
                                    line(),

                                    gapHC(3),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        tcn('Taxable Amount', Colors.black, 15),
                                        tcn(lstrTaxable.toStringAsFixed(3), Colors.black, 15)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        tcn('Vat Amount', Colors.black, 15),
                                        tcn(lstrLastVat.toStringAsFixed(3), Colors.black, 15)
                                      ],
                                    ),
                                    g.wstrDiscountYn?
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        tcn('Discount', Colors.black, 15),
                                        GestureDetector(
                                          onTap: (){
                                            //fnDiscount();
                                          },
                                          child: Container(
                                            height: 20,
                                            width: size.width*0.15,
                                            decoration: boxBaseDecoration(greyLight,0),
                                            child:
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                tc(lstrLastDiscount.toStringAsFixed(3),Colors.black,15)
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ):gapHC(0),
                                    gapHC(2),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: tcn('Additional Amount', Colors.black, 15),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            //fnAddlAmount();
                                          },
                                          child: Container(
                                            height: 20,
                                            width: size.width*0.15,
                                            decoration: boxBaseDecoration(greyLight,0),
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
                                        th('Net Amount', Colors.black, 17),
                                        tc(lstrLastTotal.toStringAsFixed(3), PrimaryColor, 18)
                                      ],
                                    ),
                                    gapHC(5),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        tcn('Advance', Colors.black, 15),
                                        tcn(lstrAdvAmount.toStringAsFixed(3), Colors.black, 15)
                                      ],
                                    ),
                                    gapHC(2),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        tcn('Paid Amount', Colors.black, 15),
                                        tcn(lstrPaidAmt.toStringAsFixed(3), Colors.black, 15)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        tcn('Change to', Colors.black, 15),
                                        tcn(lstrBalanceAmt.toStringAsFixed(3), Colors.black, 15)
                                      ],
                                    ),
                                    gapHC(10),
                                    lstrSelectedInvoiceMode == "H"?
                                    GestureDetector(
                                      onTap: (){
                                        fnPayNow();
                                      },
                                      child: Container(
                                        height: 35,
                                        decoration: boxDecoration(PrimaryColor, 30),
                                        child: Center(
                                          child: th('PAY NOW',Colors.white,15),
                                        ),
                                      ),
                                    ):
                                    lstrSelectedInvoiceMode == "C"?
                                    lstrSelectedDocDate == formatDate.format(DateTime.parse(g.wstrClockInDate.toString()))?
                                    GestureDetector(
                                      onTap: (){
                                        fnReturnBill();
                                      },
                                      child: Container(
                                        height: 35,
                                        decoration: boxDecoration(PrimaryColor, 30),
                                        child: Center(
                                          child: th('REOPEN BILL',Colors.white,14),
                                        ),
                                      ),
                                    ):gapHC(0):gapHC(0),
                                  ],
                                ),
                              ),
                              gapHC(5),

                            ],
                          ),

                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
         onWillPop: () async{
      return false;
    });
  }


// ======================================================= API CALL ==============================================
  fnGetRsl(code,type,dateFrom,dateTo) async{
    futureRsl=  apiCall.getInvoice(g.wstrCompany,g.wstrYearcode,code,type,dateFrom,dateTo,g.wstrUserCd,'','',txtSearchDocno.text,"",1);
    futureRsl.then((value) => fnGetRslSuccess(value));
  }
  fnGetRslSuccess(value){
    if(g.fnValCheck(value)){
      if(mounted){
        setState(() {

        });
      }
    }

  }
  fnGetHoldRsl() async{
    futureGetHoldRsl=  apiCall.getHoldInvoice(g.wstrCompany,'','');
    futureGetHoldRsl.then((value) => fnGetHoldRslSuccess(value));
  }
  fnGetHoldRslSuccess(value){
    print(value);
    if(g.fnValCheck(value)){
      setState(() {
        lstrHoldBill= value["HOLD_RSL"];
      });
    }
  }
  fnGetHoldRslDet(docno,doctype) async{
    setState(() {
      lstrHoldRsl = [];
      lstrHoldRslDet = [];
      lstrHoldAddl = [];
    });
    futureGetHoldRsl=  apiCall.getHoldInvoice(g.wstrCompany,docno,doctype);
    futureGetHoldRsl.then((value) => fnGetHoldRslDetSuccess(value));
  }
  fnGetHoldRslDetSuccess(value){
    print(value);
    if(g.fnValCheck(value)){
      setState(() {
        lstrHoldRsl = value["RSL"];
        lstrHoldRslDet = value["RSLDET"];
        lstrHoldAddl = value["ADDL_CHARGES"];
        lstrBookingMode = "N";
        lstrSelectedBookingInvNo = '';
        lstrSelectedRslItems = [];
        lstrSelectedRsl = [];
        lstrSelectedUser = '';
        lstrSelectedDate = '';
        lstrSelectedDocDate = '';
        lstrTaxable = 0.0;
        lstrLastVat = 0.0;
        lstrLastDiscount = 0.0;
        lstrLastTotal = 0.0;
        lstrAdvAmount = 0.0;
        sidePageView = "O";
        lstrSelectedBookingInvoice = lstrHoldRslDet;
        lstrSelectedRslItems = lstrHoldRslDet;
        lstrSelectedBookingAllItems = lstrHoldRslDet;
        fnFinalBill();
      });
    }
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


  fnPrintBooking() async{

    if(printRslHistory){
      Navigator.pop(context);
      setState(() {
        printRslHistory = false;
      });
      futurePrint =  apiCall.printInvoiceBkd(g.wstrCompany, g.wstrYearcode, lstrPrintDocno, "RBI", 1, g.wstrPrinterPath,"",lstrPrintPrvDocno);
      futurePrint.then((value) => fnPrintBookingSuccess(value));

    }

  }
  fnPrintBookingSuccess(value){

    setState(() {
      printRslHistory = true;
    });
  }

  fnGetBookingRsl(code,type,dateFrom,dateTo) async{
    futureRsl=  apiCall.getBookingInvoice(g.wstrCompany,g.wstrYearcode,code,type,dateFrom,dateTo,g.wstrUserCd,txtSearchDocno.text);
    futureRsl.then((value) => fnGetBookingRslSuccess(value));
  }
  fnGetBookingRslSuccess(value){
    if(g.fnValCheck(value)){
      setState(() {

      });
    }

  }


  fnSaveInvoiceBooking(rsl,rsldet,retailpay) async{
    futureOrderSave =  apiCall.saveInvoiceBooking(rsl,rsldet,"EDIT",[],g.wstrPrinterPath);

    try{
      futureOrderSave.then((value) => fnSaveInvoiceBookingSuccess(value));
    }catch(e){
      setState(() {
        saveSts = true;
      });
    }
  }
  fnSaveInvoiceBookingSuccess(value){
    setState(() {
      saveSts = true;
    });
    if(g.fnValCheck(value)){
      setState(() {
        saveSts = true;
      });
      if(g.fnValCheck(value)){
        var sts = value[0]['STATUS'].toString();
        var msg = value[0]['MSG'];
        if(sts == '1'){
          setState(() {
            lstrPrintDocno = value[0]['CODE'];
          });
          //fnPrint("N");
          //PageDialog().printDialog(context, fnPrint);
        }
        showToast( msg);
      }
    }
  }

  fnSaveInvoiceReturn(rsl,rsldet,retailpay,history,historyDet) {
    if(saveSts){
      setState(() {
        saveSts = false;
      });
      futureOrderSave =  apiCall.saveInvoiceVoid(rsl,rsldet,[],[],retailpay,"EDIT",[],"",g.wstrPrinterPath,"CASH","N","",lstrVoidApprovedUser,history,historyDet,[]);
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
          lstrPrintDocno = value[0]['CODE'];
        });
        fnPrint("N");
        //PageDialog().printDialog(context, fnPrint);
      }
      showToast( msg);
    }
  }
  fnApiCallGrid(){
    setState(() {
      lstrSelectedRslItems = [];
      lstrSelectedRsl =[];
      lstrSelectedDocno = '';
      lastOrder = [];
      lstrSelectedInvoiceMode = 'C';
      sidePageView = "H";
    });
    fnGetRsl(null, null, null, null);
    //fnGetRsl(null, null, null, null);
  }

  fnPrint(printmode) async{
    if(printRsl){
      //Navigator.pop(context);
      setState(() {
        printRsl = false;
      });
      futurePrint =  apiCall.printInvoiceVoid(g.wstrCompany, g.wstrYearcode, lstrPrintDocno, "RSL", 2, g.wstrPrinterPath,"VOID","CASH");
      futurePrint.then((value) => fnPrintSuccess(value,printmode));
    }
  }
  fnPrintSuccess(value,printmode){
    setState(() {
      printRsl = true;
    });
    if(printmode != "Y"){
      fnPrintKitchenSpot();
    }
    fnApiCallGrid();
  }
  fnPrintKitchenSpot() async{

    if(printRslSpot){
      //Navigator.pop(context);
      setState(() {
        printRslSpot = false;
      });
      futurePrint =  apiCall.printSpotInvoice(g.wstrCompany, g.wstrYearcode, lstrPrintDocno, "RSL", 1, "","VOID");
      futurePrint.then((value) => fnPrintKitchenSuccess(value));

    }

  }
  fnPrintKitchenSuccess(value){

    setState(() {
      lstrPrintDocno = '';
      lstrPrintPrvDocno = '';
      printRslSpot = true;
    });
  }

  fnGetMenu() async{
   // futureMenu =  apiCall.getMenuItem(g.wstrCompany, lstrMenuCode, lstrMenuGroup, lstrGp1, lstrGp2, lstrGp3, lstrGp4, lstrGp5, lstrGp6, lstrGp7, lstrGp8, lstrGp9, lstrGp10, lstrSearch,g.wstrUserCd);
   // futureMenu.then((value) => fnGetMenuSuccess(value));
  }
  fnGetMenuSuccess(value){
 /*   if(g.fnValCheck(value)){
      if(g.fnValCheck(value['Table2'])){
        var dataList = value['Table2'][0];
        lastLevel = int.parse(dataList['LEVEL'].toString());
      }else{
        setState(() {
          lastLevel =lastLevel +1;
        });
      }
      if(g.fnValCheck(value['Table3'])){
        lstrSelectedInstructions = value['Table3'];
      }

    }else{

      showToast( '');
    }*/
  }

  //============================ WIDGET UI=======================================================================================
  GestureDetector invoiceCard(mode,text) => GestureDetector(
    onTap: (){
      fnClear();
      setState(() {
        lstrSelectedInvoiceMode = mode;
      });
      if(lstrSelectedInvoiceMode== "C"){
        fnGetRsl(null, null, null, null);
      }else if(lstrSelectedInvoiceMode== "H"){
        fnGetHoldRsl();
      }else if(lstrSelectedInvoiceMode== "B"){
        fnGetBookingRsl(null, null, null, null);
      }
    },
    child: Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: boxBaseDecoration(lstrSelectedInvoiceMode == mode ? Colors.amber:Colors.white, 30),
      height: 35,
      child: Center(
        child: tcn(text,Colors.black,15),
      ),
    ),
  );
  Widget rslView(snapshot){
    return ResponsiveWidget(
        mobile: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio:1.4,
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
              var prvDocno  = '';

              if(g.fnValCheck(rsl)){
                rslDocNo = rsl[0]["DOCNO"];
                lstrRslType = rsl[0]["DOCNO"];
                lstrCreateUser = rsl[0]["CREATE_USER"];
                lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
                lstrNetAmount = rsl[0]["NETAMT"].toString();
                lstrCustomerName = rsl[0]["DOCNO"];
                lstrCustomerMob = rsl[0]["DOCNO"];
                prvDocno = rsl[0]["PRVDOCNO"]??'';
              }

              var lstrTableNo = '';

              return rslCardView(dataList, rslDocNo, lstrRslType, lstrTableNo, lstrNetAmount, lstrCreateUser,lstrCreateDate,prvDocno);
            }),
        tab: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                childAspectRatio:.8,
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
              var prvDocno  = '';

              if(g.fnValCheck(rsl)){
                rslDocNo = rsl[0]["DOCNO"];
                lstrRslType = rsl[0]["DOCNO"];
                lstrCreateUser = rsl[0]["CREATE_USER"];
                lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
                lstrNetAmount = rsl[0]["NETAMT"].toString();
                lstrCustomerName = rsl[0]["DOCNO"];
                lstrCustomerMob = rsl[0]["DOCNO"];
                prvDocno = rsl[0]["PRVDOCNO"]??'';
              }

              var lstrTableNo = '';

              return  rslCardView(dataList,rslDocNo, lstrRslType, lstrTableNo, lstrNetAmount, lstrCreateUser,lstrCreateDate,prvDocno);
            }),
        windows: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350,
                childAspectRatio:1.4,
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
              var prvDocno  = '';

              if(g.fnValCheck(rsl)){
                rslDocNo = rsl[0]["DOCNO"];
                lstrRslType = rsl[0]["DOCNO"];
                lstrCreateUser = rsl[0]["CREATE_USER"];
                lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
                lstrNetAmount = rsl[0]["NETAMT"].toString();
                lstrCustomerName = rsl[0]["DOCNO"];
                lstrCustomerMob = rsl[0]["DOCNO"];
                prvDocno = rsl[0]["PRVDOCNO"]??'';
              }

              var lstrTableNo = '';

              return rslCardView(dataList,rslDocNo, lstrRslType, lstrTableNo, lstrNetAmount, lstrCreateUser,lstrCreateDate,prvDocno);
            }));
  }
  Widget rslHoldView(){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio:1.5,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  lstrHoldBill.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = lstrHoldBill[index];
          var guestCode = '';
          var guestName = '';
          var amt = 0.0;
          var mobile = '';
          var prvdocno = '';
          var prvdoctype = '';
          if(g.fnValCheck(dataList)){
            guestCode = dataList["GUESTCODE"];
            guestName = dataList["GUESTNAME"];
            amt = g.mfnDbl(dataList["NETAMTFC"]);
            mobile = dataList["REMARKS"].toString();
            prvdocno = dataList["PRVDOCNO"].toString();
            prvdoctype = dataList["PRVDOCTYPE"].toString();
          }

          var lstrTableNo = '';
          return  GestureDetector(
            onTap: (){
              setState(() {
                lstrSelectedBookingNo = prvdocno;
                lstrSelectedBookingDocType = prvdoctype;
              });
              fnGetHoldRslDet(prvdocno,prvdoctype);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: boxDecoration(  lstrSelectedBookingNo == prvdocno? blueLight : Colors.white, 10),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.person,size: 13,),
                      gapWC(5),
                      Expanded(child: tc(guestName.toString(),Colors.black,15),)
                    ],
                  ),
                  gapHC(5),
                  Row(
                    children: [
                      Icon(Icons.phone_android_rounded,size: 13,),
                      gapWC(5),
                      Expanded(child: tc(mobile.toString(),Colors.black,13),)
                    ],
                  ),
                  gapHC(5),
                  line(),
                  gapHC(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      tc(amt.toStringAsFixed(3),Colors.red,25)
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
  Widget rslBookingView(snapshot){
    return ResponsiveWidget(
        mobile: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
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
              var lstrPrvDocno  = '';

              if(g.fnValCheck(rsl)){
                rslDocNo = rsl[0]["DOCNO"];
                lstrRslType = rsl[0]["DOCNO"];
                lstrCreateUser = rsl[0]["CREATE_USER"];
                lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
                lstrNetAmount = rsl[0]["NETAMT"].toString();
                lstrCustomerName = rsl[0]["PARTYNAME"];
                lstrCustomerMob = rsl[0]["PARTYNAME"];
                lstrPrvDocno = rsl[0]["PRVDOCNO"]??'';
              }

              var lstrTableNo = '';

              return rslBkdCardView(dataList, rslDocNo, lstrRslType, lstrTableNo, lstrNetAmount, lstrCreateUser,lstrCreateDate,lstrCustomerName,lstrPrvDocno);
            }),
        tab: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 180,
                childAspectRatio:.6,
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
              var lstrPrvDocno  = '';

              if(g.fnValCheck(rsl)){
                rslDocNo = rsl[0]["DOCNO"]??"";
                lstrRslType = rsl[0]["DOCNO"]??"";
                lstrCreateUser = rsl[0]["CREATE_USER"]??"";
                lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
                lstrNetAmount = rsl[0]["NETAMT"].toString();
                lstrCustomerName = rsl[0]["PARTYNAME"]??"";
                lstrCustomerMob = rsl[0]["PARTYNAME"]??"";
                lstrPrvDocno = rsl[0]["PRVDOCNO"]??"";
              }

              var lstrTableNo = '';

              return  rslBkdCardView(dataList, rslDocNo, lstrRslType, lstrTableNo, lstrNetAmount, lstrCreateUser,lstrCreateDate,lstrCustomerName,lstrPrvDocno);
            }),
        windows: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350,
                childAspectRatio:1.2,
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
              var lstrPrvDocno  = '';

              if(g.fnValCheck(rsl)){
                rslDocNo = rsl[0]["DOCNO"];
                lstrRslType = rsl[0]["DOCNO"];
                lstrCreateUser = rsl[0]["CREATE_USER"];
                lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
                lstrNetAmount = rsl[0]["NETAMT"].toString();
                lstrCustomerName = rsl[0]["PARTYNAME"];
                lstrCustomerMob = rsl[0]["PARTYNAME"];
                lstrPrvDocno = rsl[0]["PRVDOCNO"];
              }

              var lstrTableNo = '';

              return rslBkdCardView(dataList, rslDocNo, lstrRslType, lstrTableNo, lstrNetAmount, lstrCreateUser,lstrCreateDate,lstrCustomerName,lstrPrvDocno);
            }));
  }
  GestureDetector rslCardView(dataList,String rslDocNo, String lstrRslType, String lstrTableNo, String lstrNetAmount, String lstrCreateUser,String lstrCreateDate, String prvDocno) {
    return GestureDetector(
      onTap: (){
        fnRslClick(dataList,rslDocNo);
      },
      child: ClipPath(
        clipper: MovieTicketClipper(),
       child: Container(
         padding: EdgeInsets.all(10),
         decoration: boxDecoration(lstrSelectedDocno ==rslDocNo? blueLight : Colors.white, 5),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 th('Order ' +  rslDocNo,Colors.black,12),
                 tc(lstrRslType == 'T' ?'Table   ' + lstrTableNo : lstrRslType == 'A' ? 'Takeaway' : lstrRslType == 'D' ? 'Delivery' : '',PrimaryColor,15),

               ],
             ),
             gapHC(5),
             line(),
             gapHC(5),

             Row(
               children: [
                 Icon(Icons.watch_later_outlined,size: 13,),
                 gapWC(5),
                 tcn(lstrCreateDate.toString(),Colors.black,12),
               ],
             ),
             gapHC(0),
             Row(
               children: [
                 Icon(Icons.person_rounded,size: 12,),
                 gapWC(5),
                 tcn(lstrCreateUser.toString(),Colors.black,12),
               ],
             ),
             gapHC(5),
             Row(
               children: [
                 Icon(Icons.sticky_note_2,size: 12,),
                 gapWC(5),
                 ts('Booking #'+prvDocno,Colors.black,10),
               ],
             ),
             gapHC(5),
             line(),
             gapHC(5),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 tc( ' '+ lstrNetAmount,PrimaryColor,25),
               ],
             ),
             gapHC(10),
             Row(
               mainAxisAlignment: MainAxisAlignment.center,
               children: [

                 GestureDetector(
                   onTap: (){
                     setState(() {
                       lstrPrintDocno =rslDocNo;
                     });
                     PageDialog().printDialog(context, fnPrintHistory);
                   },
                   child: Container(
                     width: 100,
                     height: 30,
                     decoration: boxBaseDecoration(Colors.amber, 5),
                     child: Center(
                       child: Icon(Icons.print,color: Colors.black,size: 20,),
                     ),
                   ),
                 )

               ],
             )


           ],
         ),
       ),
      ),
    );
  }
  GestureDetector rslBkdCardView(dataList,String rslDocNo, String lstrRslType, String lstrTableNo, String lstrNetAmount, String lstrCreateUser,String lstrCreateDate,String lstrCustomerName,String lstrPrvDocno) {
    return GestureDetector(
      onTap: (){
        fnRslClick(dataList,rslDocNo);
      },
      child: ClipPath(
        clipper: MovieTicketClipper(),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: boxDecoration(lstrSelectedDocno ==rslDocNo? blueLight : Colors.white, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tc('Order ' +  rslDocNo,Colors.black,13),
                  tc(lstrRslType == 'T' ?'Table   ' + lstrTableNo : lstrRslType == 'A' ? 'Takeaway' : lstrRslType == 'D' ? 'Delivery' : '',PrimaryColor,15),

                ],
              ),
              gapHC(5),
              line(),
              gapHC(5),

              Row(
                children: [
                  Icon(Icons.watch_later_outlined,size: 13,),
                  gapWC(5),
                  ts(lstrCreateDate.toString(),Colors.black,12),
                ],
              ),
              gapHC(5),
              Row(
                children: [
                  Icon(Icons.person_rounded,size: 12,),
                  gapWC(5),
                  ts(lstrCreateUser,Colors.black,12),
                ],
              ),
              gapHC(5),
              Row(
                children: [
                  Icon(Icons.person_pin,size: 12,),
                  gapWC(5),
                  ts(lstrCustomerName,Colors.black,12),
                ],
              ),
              gapHC(5),
              Row(
                children: [
                  Icon(Icons.sticky_note_2,size: 12,),
                  gapWC(5),
                  ts('Booking #'+lstrPrvDocno,Colors.black,10),
                ],
              ),
              gapHC(5),
              line(),
              gapHC(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tc( ' '+ lstrNetAmount,PrimaryColor,25),
                ],
              ),
              gapHC(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  GestureDetector(
                    onTap: (){
                      setState(() {
                        lstrPrintDocno =rslDocNo;
                        lstrPrintPrvDocno =lstrPrvDocno;
                      });
                      PageDialog().printDialog(context, fnPrintBooking);
                    },
                    child: Container(
                      width: 100,
                      height: 30,
                      decoration: boxBaseDecoration(Colors.amber, 5),
                      child: Center(
                        child: Icon(Icons.print,color: Colors.black,size: 20,),
                      ),
                    ),
                  )

                ],
              )


            ],
          ),
        ),
      ),
    );
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

  // =============================== PAGE FUNCTIONS ====================================================================



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
      timeK = value[0]["TIME"];
    } else {
      timeK = refreshTime;
      count = pageCount;
    }

    if (pageCount != count) {
      if(lstrSelectedInvoiceMode== "C"){
        fnGetRsl(null, null, null, null);
      }else if(lstrSelectedInvoiceMode== "H"){
        fnGetHoldRsl();
      }else if(lstrSelectedInvoiceMode== "B"){
        fnGetBookingRsl(null, null, null, null);
      }
    }

    if(mounted){
      setState(() {
        refreshTime = timeK;
        pageCount = count;
      });
    }

  }

  fnClearSearch(){
    txtSearchDocno.text = "";
    if(lstrSelectedInvoiceMode== "C"){
      fnGetRsl(null, null, null, null);
    }else if(lstrSelectedInvoiceMode== "H"){
      fnGetHoldRsl();
    }else if(lstrSelectedInvoiceMode== "B"){
      fnGetBookingRsl(null, null, null, null);
    }
  }
  // =============================== FUNCTIONS ====================================================================
  fnClockOut(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ShiftClosing()
    ));
  }
  fnOpeningCash(){
    PageDialog().showL(context, OpeningCash(
      fnCallBack: fnOpeningCashCallBack,
    ), 'Opening Cash');
  }
  fnOpeningCashCallBack(){}
  fnChoosePrinter(){
    PageDialog().showS(context, PrinterSelection(
    ), 'Choose Printer');
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
  fnLogout() async{
    Navigator.pop(context);
  }

  fnClear(){
    setState(() {
      lastOrder = [];
      lstrSelectedRslItems = [];
      finalBillYn = "N";
      lstrSelectedBill =[];
      lstrSelectedBookingNo = '';
      lstrSelectedBookingDocType = '';
      saveSts  = true;
      printRsl  = true;
      printRslHistory  = true;
      lstrBalanceAmt = 0.00;
      lstrPaidAmt=0.00;
      lstrLastGross = 0.00;
      lstrLastVat = 0.00;
      lstrLastTotal = 0.00;
      lstrTaxable = 0.00;
      lstrLastDiscount = 0.00;
      lstrLastAddlAmount = 0.00;
      lstrAdvAmount = 0.00;
      lstrSelectedDocno = '';
      lstrSelectedDate= '';
      lstrSelectedDocDate = '';

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
        "TOTAL_AMT":lstrLastTotal,
      });
    });

    PageDialog().showL(context, ReturnBill(
      lstrDataList: lstrSelectedBill,
      fnCallBack: fnReturnBillCallBack,
      lstrDataListDet: lstrSelectedRslItems,
      lstrRslHeader: lstrSelectedRsl,
    ), 'REOPEN BILL');
  }

  fnReturnBillCallBack(rsl,rsldet,retailpay,history,historydet,other){
    setState(() {
      returnRsl = rsl;
      returnRslDet =rsldet;
      returnRetailPay = retailpay;
      returnRslVoidHistory = history;
      returnRslVoidHistoryDet =historydet;
      saveSts = true;
    });
    fnAdminPermission();

  }


  fnReturnBkdBill(){

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
        "TOTAL_AMT":lstrLastTotal,
      });
    });

    PageDialog().showL(context, ReturnBill(
      lstrDataList: lstrSelectedBill,
      fnCallBack: fnReturnBkdBillCallBack,
      lstrDataListDet: lstrSelectedRslItems,
      lstrRslHeader: lstrSelectedRsl,
    ), 'REOPEN BILL');
  }
  fnReturnBkdBillCallBack(rsl,rsldet,retailpay){
    setState(() {
      returnRsl = rsl;
      returnRslDet =rsldet;
      returnRetailPay = retailpay;
      saveSts = true;
    });
    //fnSaveInvoiceReturn(returnRsl,returnRslDet,returnRetailPay);

  }

  fnFinalBill(){
    setState(() {
      lastOrder = [];
      finalBillYn = "Y";
      if(g.fnValCheck(lstrSelectedBookingAllItems)){
        for (var e in lstrSelectedBookingAllItems){
          lastOrder.add({
            "DISHCODE":e['STKCODE'].toString(),
            "DISHDESCP":e['STKDESCP'].toString(),
            "QTY":e['QTY1'].toString(),
            "PRICE1":e["RATE"].toString(),
            "WAITINGTIME":"",
            "NOTE":"",
            "PRINT_CODE":null,
            "REMARKS":"",
            "UNIT1":e['UNIT'],
            "KITCHENCODE":e['KITCHENCODE'],
            "ADDON_YN":"",
            "ADDON_STKCODE":"",
            "CLEARED_QTY":"0",
            "NEW":"Y",
            "OLD_STATUS":"",
            "TAXINCLUDE_YN":e['RATE_INCLUDE_TAX'],
            "VAT":e['TAXPERC'],
            "TAX_AMT":0,
            "STATUS":"P"
          });
        }
      }
    });
    fnOrderCalc();
  }
  fnPayNow(){
    if(lstrSelectedBookingNo == ""){
      return false;
    }
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => QuickSale(
          datalist: lastOrder,
          mode: "F",
          bookingNo: lstrSelectedBookingNo,
          bookingDoctype: lstrSelectedBookingDocType,
          advanceAmount: lstrFinalBillAdvAmount,

        )
    ));
  }
  fnRslClick(dataList,code){
    setState(() {
      lstrBalanceAmt = 0.00;
      lstrPaidAmt=0.00;
      lstrLastGross = 0.00;
      lstrLastVat = 0.00;
      lstrLastTotal = 0.00;
      lstrTaxable = 0.00;
      lstrLastDiscount = 0.00;
      lstrLastAddlAmount = 0.00;
      lastOrder= [];
    });
    fnClear();
    var rsl  = dataList['RSL'];
    var rslDet  = dataList['RSLDET'];
    var lstrCreateUser  =  rsl[0]["CREATE_USER"];
    setState(() {
      lstrSelectedDocno = code??'';
      lstrSelectedRsl = rsl;
      lstrSelectedRslItems = rslDet;
      lstrSelectedUser = lstrCreateUser??'';
      lstrSelectedDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"].toString()))  ;
      lstrSelectedDocDate = formatDate.format(DateTime.parse(rsl[0]["DOCDATE"].toString()))  ;
      lstrTaxable = rsl[0]["TAXABLE_AMTFC"]??0.0;
      lstrLastVat = rsl[0]["TAX_AMT"]??0.0;
      lstrLastDiscount = rsl[0]["DISC_AMT"]??0.0;
      lstrLastTotal = rsl[0]["NETAMT"]??0.0;
      lstrPaidAmt = rsl[0]["PAID_AMT"]??0.0;
      lstrAdvAmount = rsl[0]["ADV_AMT"]??0.0;
      lstrLastAddlAmount = rsl[0]["ADDL_AMT"]??0.0;
      lstrBalanceAmt =  lstrLastTotal - lstrPaidAmt;
      lstrLastGross = rsl[0]["TAXABLE_AMTFC"]??0.0;
    });
  }
  fnOrderCalc(){
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
        var qty = double.parse(e["QTY"].toString());
        if(qty  > 0){
          var price = e["PRICE1"].toString();
          var total = (qty  *  double.parse(price));
          totalAmt = totalAmt +total;
        }
      }
      for(var e in lastOrder){
        var sts =  e["STATUS"];
        var vatSts = e["TAXINCLUDE_YN"];
        var vatP = e["VAT"]??0.0;
        var qty = double.parse(e["QTY"].toString());
        if(qty > 0){
          var price = e["PRICE1"].toString();
          var amt = (qty *  double.parse(price)) ;
          var headerDiscount = (amt / totalAmt) * lstrLastDiscount;
          var total = amt - headerDiscount;
          var vat = 0.0;
          var vatA = 0.0;
          if(vatSts == 'Y' && vatP > 0){
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
      setState(() {
        lstrLastTotal = totalAmount + lstrLastAddlAmount;
        lstrLastGross = grossAmount;
        lstrTaxable = taxableAmount;
        lstrLastVat = vatAmount;
        if(finalBillYn == "Y"){
          lstrLastTotal = lstrLastTotal - lstrFinalBillAdvAmount;
        }
        if(g.fnValCheck(lstrSelectedBill)){
          lstrSelectedBill[0]["TOTAL_AMT"] =lstrLastTotal;
        }
      });
    }else{

      setState(() {
        lstrLastTotal = 0.00;
        lstrLastGross = 0.00;
        lstrLastVat = 0.00;
        lstrTaxable = 0.00;
        lstrLastDiscount = 0.00;
      });
    }
    fnPaidCalc();
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
  fnAdminPermission(){
    if(g.wstrRoleCode == "QADMIN" || g.wstrRoleCode == "ADMIN" ){
      setState(() {
        lstrVoidApprovedUser = g.wstrUserCd;
      });
      fnSaveInvoiceReturn(returnRsl,returnRslDet,returnRetailPay,returnRslVoidHistory,returnRslVoidHistoryDet);
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
      fnSaveInvoiceReturn(returnRsl,returnRslDet,returnRetailPay,returnRslVoidHistory,returnRslVoidHistoryDet);

    }else{
      showToast( 'PLEASE CONTACT YOUR ADMIN!');
    }
  }
  fnUpdateTime() {
    if (mounted) {
      setState(() {
        var now = DateTime.now();
        lstrTime = formatTimeSecond.format(now);
      });
    }

  }
}
