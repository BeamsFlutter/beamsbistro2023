
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Controllers/Services/apiManager.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/lookup.dart';
import 'package:beamsbistro/Views/Components/lookup_alert.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:beamsbistro/Views/Pages/Bill/QrScanning.dart';
import 'package:beamsbistro/Views/Pages/Bill/addlAmount.dart';
import 'package:beamsbistro/Views/Pages/Bill/couponapply.dart';
import 'package:beamsbistro/Views/Pages/Bill/discount.dart';
import 'package:beamsbistro/Views/Pages/Bill/payment.dart';
import 'package:beamsbistro/Views/Pages/Menu/addon.dart';
import 'package:beamsbistro/Views/Pages/QuickBill/cardPayment.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:serial_port_win32/serial_port_win32.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MRQScreen extends StatefulWidget {
  final String? mode;
  final Function? fnCallBack;
  final Function? fnCallBackVoid;
  final datalist;
  final double? advanceAmount;
  const MRQScreen({Key? key, this.mode, this.fnCallBack, this.datalist,  this.advanceAmount, this.fnCallBackVoid}) : super(key: key);

  @override
  _QuickSaleState createState() => _QuickSaleState();
}

class _QuickSaleState extends State<MRQScreen> {

  //Page Variable

  //Global
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Global g =  Global();
  ApiCall apiCall  = ApiCall();
  late Future<dynamic> futureMenu ;
  late Future<dynamic> futureGetBooking ;
  late Future<dynamic> futureGuest ;
  late Future<dynamic> futureOrderSave ;
  late Future<dynamic> futurePrint ;
  late Future<dynamic> futureAddon ;
  late Future<dynamic> futureOrderKot ;
  late Future<dynamic> futureCoupon ;
  var formatDate = new DateFormat('dd MMM yyyy');
  var formatDate2 = new DateFormat('dd-MM-yyyy');

  var wstrPayHide  =  "N";

  //Variables

  var lstrSelectedColor = PrimaryColor;
  var lastLevel= 0;
  var lstrMenuCode ;
  var lstrMenuGroup ;
  var lstrGp1 ;
  var lstrGp2 ;
  var lstrGp3 ;
  var lstrGp4 ;
  var lstrGp5 ;
  var lstrGp6 ;
  var lstrGp7 ;
  var lstrGp8 ;
  var lstrGp9 ;
  var lstrGp10 ;
  var lstrSearch;

  var txtSearchDishCode = new TextEditingController();
  var txtSearchBooking = new TextEditingController();
  var txtQty = new TextEditingController();
  var txtNote = new TextEditingController();
  var txtCustMobileNo= TextEditingController();
  var txtCustomerName = TextEditingController();
  var txtCustomerCode = TextEditingController();
  var txtMrqRemarks = TextEditingController();

  var arrMenuCode ;
  var arrMenuGroup ;
  var arrGp1 ;
  var arrGp2 ;
  var arrGp3 ;
  var arrGp4 ;
  var arrGp5 ;
  var arrGp6 ;
  var arrGp7 ;
  var arrGp8 ;
  var arrGp9 ;
  var arrGp10 ;

  var lstrSelectedStkCode = '';
  var lstrSelectedStkDescp = '';
  var lstrSelectedDishGroup = '';
  var lstrSelectedRate = '';
  var lstrKitchenNote = '';
  var lstrSelectedQty = '';
  var lstrSelectedNote= '';
  var lstrSelectedCategory = '';
  var lstrSelectedOrderType = "TAKEAWAY";
  var lstrPrintDocno  =  '';
  var lstrSelectedDocno  = '';
  var lstrSelectedUser  = '';
  var lstrSelectedDate = '';
  var lstrSelectedBookingNo = '';
  var lstrSelectedBookingParty = '';
  var lstrSelectedBookingPartyName = '';
  var finalBillYn = 'N';
  var lstrSelectedBookingDocType = '';
  var lstrSelectedBookingYearcode = '';

  var lstrPayMode= "";


  var wstrPageMode = "";
  var lastOrder = [];
  var lastOrderHead = [];
  var lastOrderTable = [];
  var lastOrderAddress = [];
  var lstrSelectedInstructions = [];
  var lstrLastInstructions = [];
  var lstrSelectedBill = [];
  var lstrPaymentList =[];
  var lstrRetailPay = [];
  var lstrSelectedCategoryList = [];
  var lstrSelectedRslItems = [];
  var lstrSelectedRsl = [];

  var lstrRsl = [];
  var lstrRslDet=[];
  var lstrRslBooking = [];
  var lstrRslDetBooking =[];
  var lstrRslBookingTable =[];
  var lstrRslVoid = [];
  var lstrRslVoidDet = [];
  var lstrRslAddlCharge = [];
  var lstrBookingGuest = [];
  var lstrKotDet = [];
  var lstrKot = [];
  var lstrAddonDataList;

  int counter = 0;
  var lstrOrderQtyV = 0;
  var lstrLastGross = 0.00;
  var lstrLastVat = 0.00;
  var lstrLastTotal = 0.00;
  var lstrLastDiscount = 0.00;
  var lstrLastAddlAmount = 0.00;
  var lstrTaxable = 0.00;
  var lstrPaidAmt = 0.00;
  var lstrBalanceAmt = 0.00;
  var lstrAdvAmount = 0.00;
  var lstrFinalBillAdvAmount = 0.00;
  var lstrMobArea = "+971";


  //AddlAmount
  var lstrAddlAmount = [];
  var lstrSelectedAddlList  = [];


  //O- ORDERVIEW |
  var sidePageView = "O";

  //COUPON
  var lstrCouponNo = '';
  var lstrCouponDate = '';
  var lstrCouponStatus = '';
  var lstrCouponCombo = [];
  var lstrCouponItems = [];
  var lstrCouponIssue= [];
  var lstrCouponMast= [];
  var lstrCouponRedeemQty  = 0.0;
  var lstrCouponUsedCombo  = '';
  var lstrSelectedCouponitems=[];
  var lstrSelectedCitems=[];

  var lstOrderCouponitems=[];
  var lstrOrderCitems=[];

  bool creditCheck =  false;
  bool saveSts =  false;
  bool printRsl =  false;
  bool printRslSpot =  true;
  bool optionMode  =  false;

  bool couponRsl = true;

  //card payment

  var paymentDocno  = "";
  var paymentDoctype  = "";
  var paymentCard  = "";

  var polDisplayYn  = "Y";



  //Branch
  var branchList  = [];
  var selectedBranch  = "";
  var selectedBranchDescp  = "";

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    setState(() {
      sidePageView = "O";


      // branchList = [
      //   {
      //   "CODE":"1",
      //   "DESCP":"AL KARAMA"
      //   },
      //   {
      //     "CODE":"2",
      //     "DESCP":"AL BARSHA"
      //   },
      //   {
      //     "CODE":"3",
      //     "DESCP":"DEIRA"
      //   },
      //   {
      //     "CODE":"4",
      //     "DESCP":"AL NAHDA"
      //   },
      //   {
      //     "CODE":"5",
      //     "DESCP":"QUSAIS"
      //   }
      // ];

    });

    fnAddNew();
    if(g.wstrMenuGroup != ""){

    }
    if(widget.mode == "B" ){
      lastOrder = widget.datalist;
      fnOrderCalc();
    }
    if(widget.mode == "F"){
      lastOrder = widget.datalist;
      finalBillYn = "Y";
      lstrFinalBillAdvAmount = widget.advanceAmount??0.0;
      fnOrderCalc();
    }
    apiGetBranch();
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
          margin: EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height*0.97,
                  child: Row(
                    children: [
                      Container(
                        decoration: boxBaseDecoration(Colors.white, 0),
                        height: size.height*0.97,
                          width: size.width*0.16,
                          padding: EdgeInsets.all(5),
                          child: menuScreenView(size),
                        ),
                      Container(
                        decoration: boxBaseDecoration(greyLight, 0),
                        padding: EdgeInsets.all(10),
                        height: size.height*0.97,
                        width: size.width*0.54,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gapHC(5),
                            Row(
                              children: [
                                Expanded(child: tc(lstrSelectedCategory.toString(),Colors.black,18),)
                              ],
                            ),
                            gapHC(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RoundedInputField(
                                  hintText: 'Search.',
                                  txtRadius: 5,
                                  txtWidth: 0.5,
                                  txtHeight:50,
                                  txtController: txtSearchDishCode,
                                  suffixIcon: Icons.cancel_outlined,
                                  suffixIconOnclick: (){
                                    fnClearSearch();
                                  },
                                  onChanged: (value){
                                    fnSearchDishCode();
                                  },
                                ),
                              ],
                            ),
                            Expanded(child: futureMenuview(),)

                          ],
                        ),

                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        height: size.height*0.97,
                        width: size.width*0.3,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: (){
                                fnClosePage();
                              },
                              child: Container(
                                height: 40,
                                width: 80,
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                child: Icon(Icons.cancel_outlined,color: Colors.black,size: 30,),
                              ),
                            ),
                            sidePageView == "O"?
                            (lastOrder.length==0 ?
                            Container(
                              width: size.width*0.3,
                              height:  size.height*0.86,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  gapHC(10),
                                  Column(
                                    children: [
                                      Image.asset("assets/icons/ticket.png",
                                        width: 200,),
                                      gapHC(10),
                                      ts("  Choose Items...".toString(),greyLight,15),
                                    ],
                                  ),
                                   GestureDetector(
                                     onTap: (){
                                       fnClosePage();
                                     },
                                     child: Container(
                                       width: size.width*0.3,
                                       height: 40,
                                       decoration: boxDecoration(PrimaryColor, 60),
                                       child: Center(
                                         child: tc('Close',Colors.white,15),
                                       ),
                                     ),
                                   ),
                                ],
                              ),
                            ):
                            Container(
                              height:  size.height*0.86,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  lstrSelectedBookingNo.isEmpty?Container():
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      tc('Booking #' +'' , Colors.black, 15),
                                      Row(
                                        children: [
                                          tc(lstrSelectedBookingNo.toString() , PrimaryColor, 15),
                                          gapWC(5),
                                          GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                lstrSelectedBookingNo = "";
                                                lstrSelectedBookingParty = '';
                                                lstrSelectedBookingPartyName = '';
                                              });
                                            },
                                            child:  Icon(Icons.cancel_outlined,size: 20,),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  gapHC(5),
                                  line(),
                                  Expanded(child: ListView.builder(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: lastOrder.length,
                                      itemBuilder: (context, index) {
                                        var dataList = lastOrder[index];
                                        var itemCode = dataList['DISHCODE'] ??'';
                                        var itemName = dataList['DISHDESCP']??'';
                                        var waitingTime = dataList['WAITINGTIME']??'';
                                        var itemPrice = dataList['PRICE1']??'0.0';
                                        var itemQty = dataList['QTY']??'0.0';
                                        var itemSts = '';
                                        var itemClearedQty = 0;
                                        var itemClearedQtyS = '';
                                        var addonStkCode =  dataList['ADDON_STKCODE']??"" ;
                                        var addonYn = dataList['ADDON_YN']??"N";
                                        var addonMax = g.mfnDbl(dataList['ADDON_MAX_QTY']);
                                        var addonMin = g.mfnDbl(dataList['ADDON_MIN_QTY']);

                                        var itemNote = dataList['NOTE']??'';
                                        var group = dataList['GROUP']??'';
                                        var couponDocno = dataList['COUPON_DOCNO']??'';
                                        var couponNo = dataList['COUPON_NO']??'';
                                        var couponSts = false;
                                        if(couponDocno!=""){
                                          couponSts = true;
                                        }

                                        itemSts = dataList["OLD_STATUS"].toString();
                                        itemClearedQty = int.parse(dataList["CLEARED_QTY"].toString());
                                        itemClearedQtyS = itemClearedQty == 0 ? '' :itemClearedQty.toString();
                                        var addonItems = fnSelectAddOn(itemCode);
                                        var addonItemsQty = fnSelectAddOnQty(itemCode);
                                        var addonSts  =  false;
                                        var addOnList = "";
                                        if(g.fnValCheck(addonItems)){
                                          addonSts  =  true;
                                          for(var e in addonItems){
                                            addOnList += "@ "+e["DISHDESCP"] + " x "+ (e['QTY']??'0.0') + " - "+ (e['PRICE1']??'0.0') + " \n";
                                          }
                                        }
                                        var itemqty1 = 0.0;
                                        itemqty1 = g.mfnDbl(itemQty.toString());

                                        var addMinQty = g.mfnDbl(addonMin);
                                        addMinQty = g.mfnDbl(dataList['QTY']) == 0?  g.mfnDbl(addonMin):  (g.mfnDbl(addonMin) * g.mfnDbl(dataList['QTY']));


                                        return addonStkCode == "" ? GestureDetector(
                                          onTap: (){
                                            if(couponDocno =="" ){
                                              if(addonMin > 0  &&  addonYn == "Y" && (addMinQty+1) > addonItemsQty){
                                                var itemData = [];
                                                itemData.add({
                                                  "DISHCODE":itemCode,
                                                  "MODE":'ADD',
                                                  "ENTER_QTY":1.0,
                                                  "CLEARED_QTY":itemClearedQty,
                                                  "ITEM_STATUS":itemSts
                                                });
                                                fnGetAddOnCombo('ADDON',itemCode,dataList,1.0,'ADD',itemData);
                                              }else{
                                                fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
                                              }
                                            }


                                          },
                                          onLongPress: (){

                                            double.parse(itemQty) > 0 && couponDocno =="" ? fnShowNotePopupSelected(dataList):'';
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(bottom: 5),
                                            padding: EdgeInsets.only(top: 0,bottom: 0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[

                                                      Expanded(child:
                                                      GestureDetector(
                                                        child: Container(
                                                          padding: EdgeInsets.only(left: 10),
                                                          child: Row(
                                                            children: [
                                                                Container(
                                                                  height: 40,
                                                                  width: 40,
                                                                  decoration: boxDecoration(Colors.white, 30),
                                                                  child: Center(
                                                                    child: th(itemqty1.toStringAsFixed(0), Colors.black, 13),
                                                                  ),
                                                                ),
                                                                Container(
                                                                  height: 40,
                                                                  child: Center(
                                                                    child: tcn('  x ', Colors.black, 14),
                                                                  ),
                                                                ),
                                                                gapWC(5),
                                                             Expanded(child:  Column(
                                                               mainAxisAlignment: MainAxisAlignment.start,
                                                               crossAxisAlignment: CrossAxisAlignment.start,
                                                               children: [

                                                                 th(itemName.toString() ,Colors.black,13),
                                                                 gapHC(0),
                                                                 tcn('AED  ' + itemPrice.toString(),PrimaryColor,12),
                                                                 //catS('AED  ' + itemPrice.toString()),
                                                                 gapHC(2),
                                                                 couponSts?
                                                                 tcn('COUPON NO:  ' + couponNo.toString(),Colors.black,10):gapHC(0),
                                                                 addonYn == "Y" ?
                                                                 GestureDetector(
                                                                   onTap: (){
                                                                     fnGetAddOnCombo('ADDON',itemCode,dataList,0,'',[]);
                                                                   },
                                                                   child:  tc('Add-ons  : ',Colors.black,14),
                                                                 ):
                                                                 Container(),
                                                                 addonSts ?
                                                                 GestureDetector(
                                                                   onTap: (){
                                                                     fnGetAddOnCombo('ADDON',itemCode,dataList,0,'',[]);
                                                                   },
                                                                   child:tcn(addOnList.toString(),Colors.black,12),
                                                                 ):Container(),

                                                               ],
                                                             ),)
                                                            ],
                                                          )
                                                        ),
                                                      )),
                                                      Container(
                                                          child:  GestureDetector(
                                                            onTap: (){
                                                              if(addonMin > 0  &&  addonYn == "Y" && (addMinQty+1) > addonItemsQty){
                                                                var itemData = [];
                                                                itemData.add({
                                                                  "DISHCODE":itemCode,
                                                                  "MODE":'MINUS',
                                                                  "ENTER_QTY":1.0,
                                                                  "CLEARED_QTY":itemClearedQty,
                                                                  "ITEM_STATUS":itemSts
                                                                });
                                                                double.parse(itemQty) > 0?
                                                                fnGetAddOnCombo('ADDON',itemCode,dataList,1.0,'MINUS',itemData):'';
                                                              }else{
                                                                double.parse(itemQty) > 0?
                                                                fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty):'';
                                                              }
                                                            },
                                                            onLongPress: (){
                                                              if(couponDocno == ""){
                                                                fnRemoveItemSelected(dataList);
                                                              }

                                                              // fnRemoveItemSelected(dataList,orderData);
                                                            },
                                                            child: Container(
                                                              width:60,
                                                              height:40,
                                                              margin: EdgeInsets.all(10),
                                                              decoration: boxDecoration(double.parse(itemQty) >0? Colors.white: Colors.red, 5),
                                                              child: Center(
                                                                child: Icon(Icons.remove_circle_outline_outlined,color: Colors.black,size: 25,),
                                                              ),
                                                            ),
                                                          )
                                                      )
                                                    ],
                                                  ),
                                                  itemNote == ""?Container():
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                                    child:  ts('Note : '+itemNote,Colors.black,15),
                                                  )
                                                ],
                                              ),
                                            ),
                                            decoration: boxBaseDecoration(couponSts?redLight: blueLight, 7),
                                          ),
                                        ):Container();
                                      })),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        gapHC(5),
                                        line(),
                                        gapHC(5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            th('Selected Items', Colors.black, 16),
                                            gapW(),
                                            th((lastOrder.length).toString(), Colors.black, 16),
                                          ],
                                        ),
                                        gapHC(5),
                                        line(),
                                        gapHC(5),
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
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    tc(lstrLastDiscount.toStringAsFixed(3),Colors.black,15)
                                                  ],
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

                                        finalBillYn =="Y"? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            tcn('Advance Amount', Colors.black, 15),
                                            tcn(lstrFinalBillAdvAmount.toStringAsFixed(3), Colors.black, 15)
                                          ],
                                        ):gapHC(5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            th('Net Amount', Colors.black, 17),
                                            tc(lstrLastTotal.toStringAsFixed(3), PrimaryColor, 17)
                                          ],
                                        ),
                                        gapHC(5),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     tcn('Paid Amount', Colors.black, 15),
                                        //     ts(lstrPaidAmt.toStringAsFixed(3), Colors.black, 16)
                                        //   ],
                                        // ),
                                        // Row(
                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //   children: [
                                        //     tcn('Change to', Colors.black, 15),
                                        //     ts(lstrBalanceAmt.toStringAsFixed(3), Colors.black, 16)
                                        //   ],
                                        // ),
                                        // Container(
                                        //   padding: EdgeInsets.all(5),
                                        //   color: greyLight,
                                        //   child: Row(
                                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //     children: [
                                        //       tc('Total Amount', Colors.red, 18),
                                        //       gapW(),
                                        //       tc(lstrOrderAmountV.toStringAsFixed(3), Colors.red, 20),
                                        //     ],
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  ),

                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Bounce(
                                            onPressed: (){
                                              if(mounted){
                                                setState(() {
                                                  sidePageView = "G";
                                                });
                                              }
                                            },
                                            duration: Duration(milliseconds: 110),
                                            child: Container(
                                              height: 40,
                                              padding: EdgeInsets.symmetric(horizontal: 30),
                                              decoration: boxBaseDecoration(greyLight, 30),
                                              child: Center(
                                                child: Icon(Icons.account_balance,size: 20,),
                                              ),
                                            ),
                                          ),
                                          gapWC(5),
                                          Expanded(child:  Bounce(
                                            onPressed: (){

                                              if(selectedBranch.isEmpty){
                                                if(mounted){
                                                  setState(() {
                                                    sidePageView = 'G';
                                                  });
                                                  return;
                                                }
                                              }

                                              PageDialog().showRequest(context, Container(
                                                child: Column(
                                                  children: [
                                                    Expanded(child: Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Icon(Icons.calendar_month,color: Colors.black,size: 15,),
                                                            gapWC(10),
                                                            tcn(setDate(6, DateTime.now()), Colors.black, 15)
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(Icons.account_balance,color: Colors.black,size: 15,),
                                                            gapWC(10),
                                                            tcn('Send To : $selectedBranchDescp', Colors.black, 15)
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [

                                                        Bounce(
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                            fnSave();
                                                          },
                                                          duration: Duration(milliseconds: 110),
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                                                            decoration: boxDecoration(Colors.green, 30),
                                                            child: tcn('Confirm', Colors.white, 15),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ), "Request Confirmation");
                                            },
                                            duration: Duration(milliseconds: 110),
                                            child: Container(
                                              height: 40,
                                              decoration: boxBaseDecoration(PrimaryColor, 30),
                                              child: Center(
                                                child: tc('Send Request',Colors.white,16),
                                              ),
                                            ),
                                          ),)

                                        ],
                                      ),
                                      gapHC(5),

                                     
                                    ],
                                  )

                                ],
                              ),
                            )
                            ):
                            sidePageView == "D"?
                            Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.menu_book),
                                            gapW(),
                                            h1(lstrSelectedStkDescp.toString())
                                          ],
                                        ),
                                        tc('AED  '+lstrSelectedRate.toString() ,PrimaryColor,15),
                                        gapHC(10),
                                        ts('Qty',Colors.black,15),
                                        gapHC(5),
                                        Container(
                                          height: 45,
                                          width: size.width*0.1,
                                          padding: EdgeInsets.all(3),
                                          decoration: boxBaseDecoration(greyLight, 5),
                                          child: TextField(
                                            keyboardType: TextInputType.number,
                                            style: TextStyle(fontSize: 18.0),
                                            maxLines: 10,
                                            controller: txtQty,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        // tc('x ' + lstrSelectedQty.toString() ,Colors.black,20),
                                        gapHC(10),
                                        ts('Note',Colors.black,15),
                                        gapHC(5),
                                        Row(
                                          children: [
                                            Container(
                                              height: 120,
                                              width: size.width*0.2,
                                              padding: EdgeInsets.all(10),
                                              decoration: boxBaseDecoration(greyLight, 5),
                                              child: TextField(
                                                keyboardType: TextInputType.multiline,
                                                style: TextStyle(fontSize: 18.0),
                                                maxLines: 10,
                                                controller: txtNote,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                            gapWC(10),
                                            GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  txtNote.text = '';
                                                });
                                              },
                                              child: Container(
                                                decoration: boxBaseDecoration(blueLight, 5),
                                                height: 120,
                                                width: 50,
                                                child: Center(
                                                  child: Icon(Icons.delete_sweep_sharp),
                                                ),
                                              ),
                                            )

                                          ],
                                        ),
                                        gapHC(10),
                                        g.fnValCheck(lstrLastInstructions)?
                                        Container(
                                          height: 100,
                                          child: GridView.builder(
                                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 200,
                                                  childAspectRatio:  6,
                                                  crossAxisSpacing: 20,
                                                  mainAxisSpacing: 20),
                                              itemCount:  lstrLastInstructions.length,
                                              itemBuilder: (BuildContext ctx, index) {
                                                var dataList = lstrLastInstructions[index];
                                                var code = dataList['CODE'] ??'';
                                                var descp = dataList['DESCP']??'';
                                                var dishGrop = dataList['DISH_GROUP']??'';
                                                var sts = true;
                                                // if(lstrSelectedDishGroup == dishGrop){
                                                //   sts = true;
                                                // }

                                                return sts ? GestureDetector(
                                                  onTap: (){
                                                    fnUpdateNoteText(descp);
                                                  },
                                                  child: Container(
                                                    height: 30,
                                                    decoration: boxBaseDecoration(Colors.amber, 5),
                                                    padding: EdgeInsets.all(3),
                                                    child: Center(
                                                      child: tc(descp.toString(),Colors.black,15),
                                                    ),
                                                  ),
                                                ):Container() ;
                                              }),
                                        ) : Container(),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              sidePageView = "O";
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: size.width*0.06,
                                            decoration: boxBaseDecoration(greyLight, 30),
                                            child: Center(
                                              child: tc('Close',Colors.black,15),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            fnItemNoteCallBack(lstrSelectedStkCode,txtNote.text.toString(),txtQty.text);
                                          },
                                          child: Container(
                                            height: 40,
                                            width: size.width*0.2,
                                            decoration: boxDecoration(PrimaryColor, 5),
                                            child: Center(
                                              child: tc('ADD',Colors.white,15),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                            ):
                            sidePageView == "G"?
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  decoration: boxBaseDecoration(greyLight, 30),
                                  child: Row(
                                    children: [
                                      tcn('Note', Colors.black, 15)
                                    ],
                                  ),
                                ),

                                gapHC(10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  decoration: boxOutlineCustom1(Colors.white, 5, Colors.black, 0.5),
                                  child: TextFormField(
                                    controller: txtMrqRemarks,
                                    autofocus: true,
                                    style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
                                    keyboardType: TextInputType.visiblePassword,
                                    minLines: 5,
                                    maxLines: 5,
                                    decoration:   InputDecoration(
                                      hintText: 'Remarks',
                                      hintStyle: GoogleFonts.poppins(fontSize: 12),
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (val){
                                      if(mounted){
                                        setState(() {

                                        });
                                      }
                                    },
                                  ),
                                ),
                                gapHC(10),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                  decoration: boxBaseDecoration(greyLight, 30),
                                  child: Row(
                                      children: [
                                        tcn('Select Branch', Colors.black, 15)
                                      ],
                                  ),
                                ),
                                gapHC(10),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                        children: wBranchList(),
                                    ),
                                  ),
                                ),
                                gapHC(20),
                                Bounce(
                                  onPressed: (){
                                    if(mounted){
                                      setState(() {
                                        sidePageView = "O";
                                      });
                                    }
                                  },
                                  duration: Duration(milliseconds: 110),
                                  child: Container(
                                    height: 40,
                                    decoration: boxBaseDecoration(PrimaryColor, 30),
                                    child: Center(
                                      child: tc('Close',Colors.white,16),
                                    ),
                                  ),
                                )

                              ],
                            )):
                            Container()

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
    );
  }

  //============================WIDGET UI===================
  SingleChildScrollView menuScreenView(Size size) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            height: size.height*0.85,
            child: FutureBuilder<dynamic>(
              future: futureMenu,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return catView(snapshot);
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
          gapHC(10),
          GestureDetector(
            onTap: (){
              lstrMenuGroup != null ? fnBackButton():fnClosePage();
            },
            onLongPress: (){
              fnBackLongPress();
            },
            child:  Container(
              decoration: boxDecoration(Colors.amber,50),
              height: 40,
              child: Center(
                child: tcn( lstrMenuGroup != null ?'BACK':"CATEGORY", Colors.black, 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
  FutureBuilder<dynamic> futureMenuview() {
    return new FutureBuilder<dynamic>(
      future: futureMenu,
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
    );
  }
  Widget itemView(snapshot){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio:  1.5,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemCount:  snapshot.data['Table1'].length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data['Table1'][index];
          var itemCode = dataList['DISHCODE'] ??'';
          var itemName = dataList['DISHDESCP']??'';
          var waitingTime = dataList['WAITINGTIME']??'';
          var itemPrice = dataList['PRICE1']??'0.0';
          var addonYn = dataList['ADDON_YN']??"N";
          var addonMax = g.mfnDbl(dataList['ADDON_MAX_QTY']);
          var addonMin = g.mfnDbl(dataList['ADDON_MIN_QTY']);


          var itemSts = '';
          var itemClearedQty = 0;
          var itemClearedQtyS = '';
          var orderData = fnCheckItem(itemCode);
          bool orderSts  = false;

          var addonItems = fnSelectAddOnQty(itemCode);
          var addonSts  =  false;
          if(addonItems > 0){
            addonSts  =  true;
          }

          if(g.fnValCheck(orderData)){
            var qty = double.parse(orderData["QTY"].toString());
            itemSts = orderData["OLD_STATUS"].toString();
            itemClearedQty = int.parse(orderData["CLEARED_QTY"].toString());
            itemClearedQtyS = itemClearedQty == 0 ? '' :itemClearedQty.toString();
            if(qty > 0){
              orderSts = true;
            }
          }
          var addMinQty = g.mfnDbl(addonMin);
          if(orderSts){
            addMinQty = g.mfnDbl(orderData["QTY"]) == 0?  g.mfnDbl(addonMin):  (g.mfnDbl(addonMin) * g.mfnDbl(orderData["QTY"]));
          }

          return GestureDetector(
            onTap: (){
              setState(() {
                sidePageView = "O";
              });
              if(addonMin > 0  &&  addonYn == "Y" && (addMinQty+1) > addonItems){
                var itemData = [];
                itemData.add({
                  "DISHCODE":itemCode,
                  "MODE":'ADD',
                  "ENTER_QTY":1.0,
                  "CLEARED_QTY":itemClearedQty,
                  "ITEM_STATUS":itemSts
                });

                fnGetAddOnCombo('ADDON',itemCode,dataList,1.0,'ADD',itemData);
              }else{
                fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
              }
            },
            onLongPress: (){
              setState(() {
                lstrAddonDataList = dataList;
              });
              if(addonYn == "Y" && orderSts ==true){
                  fnGetAddOnCombo('ADDON',itemCode,dataList,0,'',[]);
              }
              //orderSts ==true ? fnShowNotePopup(dataList,orderData):'';
            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(left: 7),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gapHC(5),
                            tcn(itemName.toString(),Colors.black,13),
                            th('AED  ' + itemPrice.toString(),PrimaryColor,13),
                            gapHC(5),
                            tc(orderSts ? 'x ' + orderData["QTY"].toString() : '',Colors.black,15),
                            gapHC(5),
                            addonYn == "Y" && orderSts?
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  lstrAddonDataList = dataList;
                                });
                                orderSts ==true ? fnGetAddOnCombo('ADDON',itemCode,dataList,0,'',[]):'';
                              },
                              child: Container(
                                decoration: boxDecoration(Colors.blue, 30),
                                height: 25,
                                width: 70,
                                child: Center(
                                  child: tc( 'Select Add-ons' ,Colors.white,10),
                                ),
                              ),
                            )
                            :Container(),
                          ],
                        ),
                      ),
                    ),
                  )),
                  orderSts ?
                  Container(
                      child:  GestureDetector(
                        onTap: (){
                          setState(() {
                            sidePageView = "O";
                          });
                          if(addonMin > 0  &&  addonYn == "Y" && (addMinQty+1) > addonItems){
                            var itemData = [];
                            itemData.add({
                              "DISHCODE":itemCode,
                              "MODE":'MINUS',
                              "ENTER_QTY":1.0,
                              "CLEARED_QTY":itemClearedQty,
                              "ITEM_STATUS":itemSts
                            });
                            fnGetAddOnCombo('ADDON',itemCode,dataList,1.0,'MINUS',itemData);
                          }else{
                            fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty);
                          }


                        },
                        onLongPress: (){
                          setState(() {
                            sidePageView = "O";
                          });
                          fnRemoveItem(dataList,orderData);
                        },
                        child: Container(
                          width:40,
                          margin: EdgeInsets.all(10),
                          decoration: boxGradientDecoration(12, 10),
                          child: Center(
                            child: Icon(Icons.remove_circle_outline_outlined,color: Colors.white,size: 20,),
                          ),
                        ),
                      )
                  )
                      :Container()
                ],
              ),
              decoration: boxDecoration(CupertinoColors.white, 5),
            ),
          );
        });
  }
  Widget catView(snapshot){

    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data['Table2'].length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data['Table2'][index];
          var code = dataList['CODE']??'';
          var menuGroupName = dataList['DESCP']??'';

          return code != null? GestureDetector(
            onTap: (){
              fnUpdateTable(code,menuGroupName);
            },
            child: Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Icon(Icons.dashboard,size: 10,color: Colors.amber,),
                  gapWC(5),
                  Expanded(child: th(menuGroupName.toString().toUpperCase()+'', Colors.white, 11)),
                  Icon(Icons.arrow_forward_ios_sharp,size: 10,color: Colors.white,)
                ],
              ),
              decoration: boxDecoration(lstrSelectedColor, 5),
            ),
          ):Container();
        });
  }
  Widget menuGroupView(snapshot){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data['Table2'].length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data['Table2'][index];
          var code = dataList['CODE']??'';
          var menuGroupName = dataList['DESCP']??'';
          return menuGroupName != ""? GestureDetector(
            onTap: (){
              fnUpdateTable(code,menuGroupName);
            },
            child:  Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              margin: EdgeInsets.only(right:10),
              decoration: boxBaseDecoration(lstrMenuGroup == code ? PrimaryColor :blueLight, 5),
              child: Center(
                child: tc(menuGroupName, lstrMenuGroup == code ? Colors.white : PrimaryText,15),
              ),
            ),
          ):Container();
        });
  }
  Widget addOnView(snapshot){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio: 3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data[index];
          var itemCode = dataList['DISHCODE']??'';
          var itemName = dataList['DISHDESCP']??'';
          var itemPrice = dataList['PRICE1']??'0.0';
          var itemSts = 'P';
          var itemClearedQty = 0;
          var Cardcolor = Colors.white;
          var orderData = fnCheckItem(itemCode);
          bool orderSts  = false;
          if(g.fnValCheck(orderData)){
            orderSts = true;
            itemClearedQty = g.mfnInt(orderData["CLEARED_QTY"]);
            itemSts = orderData["OLD_STS"].toString();
          }
          return GestureDetector(
            onTap: (){
              setState(() {

                fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
                Navigator.pop(context);
                PageDialog().showL(context, fnShowAddon(lstrAddonDataList), 'Add-ons');
              });
            },
            onLongPress: (){

            },
            child: Container(
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gapHC(5),
                          menuNameS(itemName.toString()),
                          catS('AED  ' + itemPrice.toString()),
                          gapHC(2),
                          tc(orderSts ? 'x ' + orderData["QTY"].toString() : '',Colors.black,15),
                        ],
                      ),
                    ),
                  ),

                   orderSts ?
                   Container(
                       child:  GestureDetector(
                         onTap: (){
                           fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty);
                           Navigator.pop(context);
                           PageDialog().showL(context, fnShowAddon(lstrAddonDataList), 'Add-ons');
                         },
                         onLongPress: (){
                           fnRemoveItem(dataList,orderData);
                           Navigator.pop(context);
                           PageDialog().showL(context, fnShowAddon(lstrAddonDataList), 'Add-ons');
                         },
                         child: Container(
                           width:50,
                           decoration: boxGradientDecoration(12, 10),
                           child: Center(
                             child: Icon(Icons.remove_circle_outline_outlined,color: Colors.white,size: 20,),
                           ),
                         ),
                       )
                   )
                       :
                   Container()
                ],
              ),
              decoration: boxDecoration(Colors.white, 5),
            ),
          );
        });
  }
  Widget fnShowAddon(dataList){
    var itemCode = dataList['DISHCODE'];
    var itemName = dataList['DISHDESCP'];
    var waitingTime = dataList['WAITINGTIME'];
    var itemPrice = dataList['PRICE1'];
    var preparationNote = dataList['PREPARATION']??'';
    return StatefulBuilder(builder: (context, setModalState){
       return Container(
           padding: EdgeInsets.all(30),
           child: SingleChildScrollView(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Row(
                   children: [
                     Icon(Icons.menu_book),
                     gapW(),
                     tc(dataList['DISHDESCP'],Colors.black,15),
                   ],
                 ),
                 gapHC(5),
                 tc('AED  ' + itemPrice.toString(),PrimaryColor,15),
                 gapHC(5),
                 clockRow('  avg '+dataList['WAITINGTIME'].toString()),
                 gapHC(5),
                 tc(preparationNote.toString(),PrimaryColor,12),
                 Container(
                   height: 320,
                   child: new FutureBuilder<dynamic>(
                     future: futureAddon,
                     builder: (context, snapshot) {
                       if (snapshot.hasData) {
                         return addOnView(snapshot);
                       } else if (snapshot.hasError) {
                         return Container();
                       }
                       // By default, show a loading spinner.
                       return Center(
                         child: Container(),
                       );
                     },
                   ),
                 )

               ],
             ),
           )

       );
    });
  }


  //Branch

  List<Widget> wBranchList(){
    List<Widget> rtnList  =  [];
    for(var e in branchList){
      rtnList.add( GestureDetector(
        onTap: (){
          if(mounted){
            setState(() {
              selectedBranch =  e["CODE"];
              selectedBranchDescp =  e["DESCP"];
            });
          }
        },
        child: Container(
            child: Column(
              children: [
                Divider(
                  thickness: 0.5,
                ),
                Row(
                  children: [
                    Container(
                      decoration: selectedBranch == e["CODE"]? boxBaseDecoration(PrimaryColor, 5):boxOutlineCustom1(Colors.white, 5, Colors.black, 0.5),
                      height: 20,
                      width: 20,
                      child: Center(
                        child: Icon(Icons.done,color:Colors.white,size: 10,),
                      ),
                    ),
                    gapWC(5),
                    tcn(e["DESCP"].toString(), Colors.black, 15)
                  ],
                ),
                Divider(
                  thickness: 0.5,
                )
              ],
            )
        )),
      );
    }
    return rtnList;
  }



  //============================PAGE FUNCTIONS ===================

  fnSave(){



    var lstrMRQ = [];
    var lstrMRQDet=[];


    var srno = 0;


    var templstrLastTotal = 0.0  ;
    var templstrLastGross = 0.0 ;
    var templstrTaxable = 0.0 ;
    var templstrLastVat = 0.0 ;

    setState(() {
      saveSts = false;
    });

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
          var total = (qty *  double.parse(price));
          totalAmt = totalAmt +total;
        }
      }
      //AddlAmount
      for(var e in lastOrder){
        srno = srno + 1;
        var vatSts = e["TAXINCLUDE_YN"];
        var vatP = e["VAT"]??0.0;

        var qty = double.parse(e["QTY"].toString());
        if(qty > 0){
          var price = e["PRICE1"].toString();
          var amt = (qty *  double.parse(price)) ;
          var headerDiscount = 0.0;
          var headerAddlAmount  = 0.0;

          if(totalAmt > 0){
            headerDiscount = (amt / totalAmt) * lstrLastDiscount;
            headerAddlAmount  = (amt / totalAmt) * lstrLastAddlAmount;
          }

          var total = amt - headerDiscount;
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
          lstrMRQDet.add({
            "COMPANY":g.wstrCompany,
            "YEARCODE":g.wstrYearcode,
            "DOCNO" : '',
            "DOCTYPE" : '',
            "SRNO" : srno,
            "DOCNO_RPT" : '',
            "DOCDATE" : '',
            "DUEDATE" : '',
            "STKCODE" : e["DISHCODE"],
            "STKDESCP" : e["DISHDESCP"],
            "RETURNED_YN" : '',
            "FOC_YN" : '',
            "LOC" : '',
            "UNIT1":e["UNIT1"],
            "QTY1":e["QTY"],
            "UNITCF":1,
            "RATE":e["PRICE1"],
            "RATEFC":e["PRICE1"],
            "GRAMT":double.parse(amt.toStringAsFixed(5)) ,
            "GRAMTFC": double.parse(amt.toStringAsFixed(5)) ,
            "DISC_AMT":double.parse(headerDiscount.toStringAsFixed(5)),
            "DISC_AMTFC":double.parse(headerDiscount.toStringAsFixed(5)),
            "DISCPERCENT" : 0,
            "AMT": double.parse(amt.toStringAsFixed(5)),
            "AMTFC":double.parse(amt.toStringAsFixed(5)),
            "ADDL_AMT":headerAddlAmount,
            "ADDL_AMTFC":headerAddlAmount * g.wstrCurrencyRate,
            "PRVDOCSRNO" : 0,
            "PRVDOCQTY" : 0,
            "PRVDOCPENDINGQTY" : 0,
            "PENDINGQTY" : 0,
            "CLEARED_QTY" : 0,
            "REF1" : e["NOTE"],
            "REF2" : '',
            "REF3" : '',
            "BINNO" : '',
            "HEADER_DISC_AMT": double.parse(headerDiscount.toStringAsFixed(5)),
            "HEADER_DISC_AMTFC":double.parse(headerDiscount.toStringAsFixed(5)) * g.wstrCurrencyRate,
            "REMARKS" : '',
          });
        }
      }

      setState(() {


        templstrLastTotal = double.parse(totalAmount.toStringAsFixed(3))  ;
        templstrLastGross = double.parse(grossAmount.toStringAsFixed(3)) ;
        templstrTaxable = double.parse(taxableAmount.toStringAsFixed(3)) ;
        templstrLastVat = double.parse(vatAmount.toStringAsFixed(3)) ;
        templstrLastTotal =  lstrLastAddlAmount  + templstrLastTotal;


        lstrLastTotal = double.parse(totalAmount.toStringAsFixed(3))  ;
        lstrLastGross = double.parse(grossAmount.toStringAsFixed(3)) ;
        lstrTaxable = double.parse(taxableAmount.toStringAsFixed(3)) ;
        lstrLastVat = double.parse(vatAmount.toStringAsFixed(3)) ;
        lstrLastTotal =  lstrLastAddlAmount  + lstrLastTotal;

      });


    }

    var discPerc =  0.0;
    if(g.mfnDbl(lstrLastDiscount) > 0){
      discPerc = (lstrLastDiscount/(templstrLastTotal+lstrLastDiscount))*100;
    }

    lstrMRQ.add({
      "COMPANY":g.wstrCompany,
      "YEARCODE":g.wstrYearcode,
      "DOCNO" : '',
      "DOCTYPE" : '',
      "DOCDATE" : '',
      "CRDAYS" : 0,
      "DUEDATE" : null,
      "BRNCODE" : g.wstrUserBrnCode,
      "DIVCODE" : '',
      "CCCODE" : '',
      "SMAN" : '',
      "LOC" : '',
      "PARTYCODE":selectedBranch,
      "CASH_CREDIT" : "",
      "CURR" : g.wstrCurrency,
      "CURRATE" : g.wstrCurrencyRate,
      "GRAMT" : templstrLastGross,
      "GRAMTFC" : templstrLastGross,
      "ADDL_AMT" : lstrLastAddlAmount,
      "ADDL_AMTFC" : lstrLastAddlAmount * g.wstrCurrencyRate,
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
      "NETAMT":templstrLastTotal,
      "NETAMTFC":templstrLastTotal * g.wstrCurrencyRate,
      "PAID_AMT":double.parse(lstrPaidAmt.toStringAsFixed(5))  ,
      "PAID_AMTFC":double.parse(lstrPaidAmt.toStringAsFixed(5)) * g.wstrCurrencyRate,
      "BAL_AMT":double.parse(lstrBalanceAmt.toStringAsFixed(5)),
      "BAL_AMTFC":double.parse(lstrBalanceAmt.toStringAsFixed(5)) * g.wstrCurrencyRate,
      "AC_AMTFC":0,
      "AC_AMT":0,
      "REMARKS" : txtMrqRemarks.text,
      "REF1" : selectedBranchDescp,
      "REF2" : '',
      "REF3" : '',
      "REF4" : '',
      "REF5" : '',
      "REF6" : '',
      "CREATE_USER" : g.wstrUserCd,
      "CREATE_DATE" : setDate(2, DateTime.now()),
      "EDIT_USER" : g.wstrUserCd,
      "EDIT_DATE" : setDate(2, DateTime.now()),
      "PRINTING_COUNT" : 0,
      "SMAN_DESCP" : '',

    });

    apiSaveMrq(lstrMRQ, lstrMRQDet);

  }
  fnLookup(mode) {
    if (mode == 'CUST') {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'GUEST_CODE', 'Display': 'Code'},
        {'Column': 'GUEST_NAME', 'Display': 'Name'},
        {'Column': 'MOBILE', 'Display': 'Mobile'},
        {'Column': 'EMAIL', 'Display': 'Email'},
        {'Column': 'TEL', 'Display': 'Telephone'},
        {'Column': 'CONTACT_MOBILE', 'Display': 'Mobile 2'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {'sourceColumn': 'GUEST_CODE','contextField': txtCustomerCode,'context': 'window'},
        {'sourceColumn': 'GUEST_NAME','contextField': txtCustomerName,'context': 'window'},
        //{'sourceColumn': 'MOBILE','contextField': txtCustMobileNo,'context': 'window'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtCustomerCode,
        oldValue: txtCustomerCode.text,
        lstrTable: 'GUESTMASTER',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100000',
        lstrFilter: [],
        keyColumn: 'GUEST_CODE',
        layoutName: "B",
        callback: fnLookupCallBackCust,
      ), 'Party ');
    }
  }
  fnLookupCallBack(data){

  }
  fnLookupCallBackCust(data){
    if(g.fnValCheck(data)){
      setState(() {
        txtCustMobileNo.text = data["MOBILE"].toString().replaceAll("+971", "");
      });
    }
  }

 //============================OTHER FUNCTIONS ===================
  fnClearSearch(){
    setState(() {
      txtSearchDishCode.clear();
      lstrSearch = null;
    });
    fnGetMenu();
  }
  fnSearchDishCode(){
    if(txtSearchDishCode.text.isEmpty){
      setState(() {
        lstrSearch = null;
      });
    }else{
      setState(() {
        lstrSearch = txtSearchDishCode.text.toString();

      });
    }
    fnGetMenu();
  }
  fnClearAll(){
    lstrSelectedCategoryList.clear();
    lstrSelectedCategory = '';
    setState(() {
      lstrSelectedColor = PrimaryColor;
      lstrMenuCode = null ;
      lstrMenuGroup  = null ;
      lstrGp1  = null ;
      lstrGp2  = null ;
      lstrGp3  = null ;
      lstrGp4  = null ;
      lstrGp5  = null ;
      lstrGp6  = null ;
      lstrGp7  = null ;
      lstrGp8  = null ;
      lstrGp9  = null ;
      lstrGp10  = null ;
    });
    fnUpdateCategory();
  }
  fnBackButton(){

    setState(() {
      switch (lastLevel) {
        case 0:
          break;
        case 1:
          fnClearAll();
          break;
        case 2:
          lstrGp1 = null;
          lstrSelectedColor = Colors.green;
          lstrSelectedCategoryList[1] = null;
          break;
        case 3:
          lstrGp2 = null;
          lstrSelectedColor = Colors.red;
          lstrSelectedCategoryList[2] = null;
          break;
        case 4:
          lstrGp3 = null;
          lstrSelectedColor = Colors.blue;
          lstrSelectedCategoryList[3] = null;
          break;
        case 5:
          lstrGp4 = null;
          lstrSelectedColor = Colors.pink;
          lstrSelectedCategoryList[4] = null;
          break;
        case 6:
          lstrGp5 = null;
          lstrSelectedColor = Colors.blue;
          lstrSelectedCategoryList[5] = null;
          break;
        case 7:
          lstrGp6 = null;
          lstrSelectedColor = Colors.deepOrangeAccent;
          lstrSelectedCategoryList[6] = null;
          break;
        case 8:
          lstrGp7 = null;
          lstrSelectedColor = Colors.indigo;
          lstrSelectedCategoryList[7] = null;
          break;
        case 9:
          lstrGp8 = null;
          lstrSelectedColor = Colors.cyan;
          lstrSelectedCategoryList[8] = null;
          break;
        case 10:
          lstrGp9 = null;
          lstrSelectedCategoryList[9] = null;
          break;
        default:
          break;
      }
    });
    fnUpdateCategory();
    fnGetMenu();
  }
  fnBackLongPress(){
    fnClearAll();
    fnGetMenu();
  }
  fnCheckItem(itemCode){
    var selectedData ;
    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( itemCode == lcode ){
          selectedData = e;
          break;
        }
      }
    }
    return selectedData;
  }
  fnItemPress(dataList,qty,mode,sts,itemClearedQty) async{
    bool checkItem = false;
    bool checkQtyZero = false;
    var itemCode = dataList['DISHCODE'].toString();
    var itemName = dataList['DISHDESCP'];
    var waitingTime = dataList['WAITINGTIME'];
    var itemPrice = dataList['PRICE1'];



    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        var lqty = double.parse(e["QTY"].toString());
        if( itemCode == lcode ){
          checkItem = true;

          if(mode=='ADD'){
            var v =  lqty + qty;
            e["QTY"] = v.toString();
            e["STATUS"] = "P";
            e["PRINT_CODE"] = null;
            fnGetAvailablePorts(itemName, itemPrice, "");
          }else{
            var v =  lqty - qty;
            if(sts != 'R' && sts != 'D'){
              e["QTY"] = v.toString();
              e["STATUS"] = "P";
              e["PRINT_CODE"] = null;
              if(double.parse(e["QTY"].toString()) <= 0){
                fnRemoveItem(dataList,e);
              }
            }else{
              e["QTY"] = v.toString();
              e["STATUS"] = "P";
              e["PRINT_CODE"] = null;
              if(double.parse(e["QTY"].toString()) <= 0){
                fnRemoveItem(dataList,e);
              }

            }

          }

          break;
        }
      }
    }

    if(!checkItem){
      setState(() {
        lastOrder.add({
          "DISHCODE":dataList['DISHCODE'],
          "DISHDESCP":dataList['DISHDESCP'],
          "QTY":qty.toInt().toString(),
          "PRICE1":itemPrice.toString(),
          "WAITINGTIME":waitingTime.toString(),
          "NOTE":"",
          "PRINT_CODE":null,
          "REMARKS":itemPrice.toString(),
          "UNIT1":dataList['UNIT'],
          "KITCHENCODE":dataList['KITCHENCODE'],
          "ADDON_YN":dataList['ADDON_YN'],
          "ADDON_MIN_QTY":dataList['ADDON_MIN_QTY'],
          "ADDON_MAX_QTY":dataList['ADDON_MAX_QTY'],
          "ADDON_STKCODE":dataList['CODE'],
          "CLEARED_QTY":"0",
          "NEW":"Y",
          "OLD_STATUS":"",
          "TAXINCLUDE_YN":dataList['TAXINCLUDE_YN'],
          "VAT":dataList['VAT'],
          "TAX_AMT":0,
          "STATUS":"P"
        });
      });
      fnGetAvailablePorts(itemName, itemPrice, qty);
    }

    setState(() {

    });
    print(lastOrder);
    fnOrderCalc();
    //Vibration.vibrate();

  }
  fnRemoveItem(dataList,selectedItem){
    var group =  selectedItem["GROUP"]??"";
    var itemSts = '';
    itemSts = selectedItem["OLD_STATUS"].toString();
    var newItem = selectedItem['NEW'].toString();
    if(itemSts != 'R' && itemSts != 'D'){
      if(g.wstrOrderMode == 'ADD' ){
        setState(() {
          lastOrder.remove(selectedItem);
          fnRemoveAddOn(selectedItem["DISHCODE"].toString());
        });
      }else{
        if(newItem == "Y"){
          setState(() {
            lastOrder.remove(selectedItem);
            fnRemoveAddOn(selectedItem["DISHCODE"].toString());
          });
        }else{
          fnEditRemove(dataList);
        }

      }
    }else{
      showToast( g.fnStatus(itemSts));
    }



    print(lastOrder);
    fnOrderCalc();
  }
  fnUpdateTable(code,descp) {
    setState(() {
      lstrSelectedCategoryList.add(descp);
      switch (lastLevel) {
        case 0:
          lstrMenuGroup = code;
          lstrSelectedColor = Colors.green;
          break;
        case 1:
          lstrGp1 = code;
          lstrSelectedColor = Colors.red;
          break;
        case 2:
          lstrGp2 = code;
          lstrSelectedColor = Colors.blue;
          break;
        case 3:
          lstrGp3 = code;
          lstrSelectedColor = Colors.pink;
          break;
        case 4:
          lstrGp4 = code;
          lstrSelectedColor = Colors.deepOrangeAccent;
          break;
        case 5:
          lstrGp5 = code;
          lstrSelectedColor = Colors.indigo;
          break;
        case 6:
          lstrGp6 = code;
          lstrSelectedColor = Colors.cyan;
          break;
        case 7:
          lstrGp7 = code;
          break;
        case 8:
          lstrGp8 = code;
          break;
        case 9:
          lstrGp9 = code;
          break;
        case 10:
          lstrGp10 = code;
          break;
        default:

          break;
      }
      fnUpdateCategory();
      fnGetMenu();
    });
  }
  fnUpdateCategory(){
    setState(() {
      lstrSelectedCategory = '';
    });
    var i = 0;
    if(g.fnValCheck(lstrSelectedCategoryList)){
      for(var e in lstrSelectedCategoryList){
        setState(() {
          if (e != null ){
            lstrSelectedCategory = i == 0? e.toString() : lstrSelectedCategory +  '  >  ' + e.toString();

          }
          i =i+1;
        });
      }
    }else{
      setState(() {
        lstrSelectedCategory = '';
      });
    }
  }
  fnEditRemove(dataList){
    var itemCode = dataList['DISHCODE'].toString();
    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( itemCode == lcode ){
          e["QTY"] = '0';
          e["STATUS"] = 'C';
          e["PRINT_CODE"] = null;
          break;
        }
      }
    }
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
      lstrPayMode = "";
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
          var headerDiscount = 0.0;
          if(totalAmt > 0){
            headerDiscount = (amt / totalAmt) * lstrLastDiscount;
          }

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
        lstrLastTotal = (totalAmount + lstrLastAddlAmount) - lstrFinalBillAdvAmount;
        lstrLastGross = grossAmount;
        lstrTaxable = taxableAmount;
        lstrLastVat = vatAmount;

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
        lstrPayMode = lcash > 0 ? 'CASH':"";
        lstrPaidAmt = lpaid ;
        lstrBalanceAmt =  lchangeto > 0 ? 0.00: lchangeto;
      });
    }
  }
  fnShowNotePopupSelected(dataList){

    var itemCode = dataList['DISHCODE'] ??'';
    var itemName = dataList['DISHDESCP']??'';
    var waitingTime = dataList['WAITINGTIME']??'';
    var itemPrice = dataList['PRICE']??'0.0';
    //fnGetDetails(itemCode);

    setState(() {

      lstrSelectedStkCode = itemCode??'';
      lstrSelectedStkDescp = itemName??'';
      lstrSelectedRate = itemPrice.toString();
      lstrKitchenNote = '';
      lstrSelectedQty=dataList['QTY'].toString();
      lstrSelectedNote=dataList['NOTE'].toString();
      txtNote.text = lstrSelectedNote;
      sidePageView = "D";
      txtQty.text = lstrSelectedQty;

    });
    // PageDialog().showNote(context, ItemDetails(
    //   fnCallBack: fnItemNoteCallBack,
    //   lstrDataList: lstrSelectedItem,
    //   qty: lstrSelectedQty,
    //   note: lstrSelectedNote.toString(),
    //
    // ), 'Item Details');
    // PageDialog().showNote(context, kitchenNoteColumn(), 'Item Details');
  }
  fnRemoveItemSelected(selectedItem){
    var itemSts = '';
    itemSts = selectedItem["OLD_STATUS"].toString();
    var newItem = selectedItem['NEW'].toString();
    if(itemSts != 'R' && itemSts != 'D'){
      if(g.wstrOrderMode == 'ADD' ){
        setState(() {
          lastOrder.remove(selectedItem);
          fnRemoveAddOn(selectedItem["DISHCODE"]);
        });
      }else{
        if(newItem == "Y"){
          setState(() {
            lastOrder.remove(selectedItem);
            fnRemoveAddOn(selectedItem["DISHCODE"]);
          });
        }else{
          fnEditRemove(selectedItem);
        }

      }
    }else{
      showToast( g.fnStatus(itemSts));
    }
    print(lastOrder);
    fnOrderCalc();
  }
  fnAddlAmount(){
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
    fnOrderCalc();
  }
  fnDiscount(){
    setState(() {
      lstrSelectedBill= [];
      lstrSelectedBill.add({
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


    PageDialog().showL(context, Discount(
      fnCallBack: fnDiscountCallBack, oldValue: lstrLastDiscount, lstrDataList: lstrSelectedBill,
    ), 'Discount');
  }
  fnDiscountCallBack(amount){
    setState(() {
      lstrLastDiscount = amount;
    });
    fnOrderCalc();
  }
  fnPayPopup(){

    if(couponRsl){
      var selectedData = g.mfnJson(lastOrder);
      selectedData.retainWhere((i){
        return (i["COUPON_NO"]??'') != '' ;
      });

      selectedData = selectedData??[];
      if(selectedData.length >0 && selectedData.length !=  lastOrder.length){
        showToast( 'Only allow coupon items');
        return;
      }
    }

    setState(() {
      lstrSelectedBill= [];
      lstrSelectedBill.add({
        "DOCNO":'NEW',
        "TYPE": lstrSelectedOrderType,
        "USER" :g.wstrUserCd,
        "NAME" : '',
        "CASH" : 0.00,
        "CARD" : 0.00,
        "TOTAL_AMT":lstrLastTotal,
        "PAID_AMT":0.00,
        "CHANGE_TO":0.00
      });
    });
    //fnSave();
    //Navigator.push(context, MaterialPageRoute(builder: (context) => Payment()));
    PageDialog().showL(context, Payment(
      lstrDataList: lstrSelectedBill,
      fnCallBack: fnPaymentCallBack,
      lstrPaymentList: [],
    ), 'Payment Details');
  }
  fnPaymentCallBack(datalist,retailPay,paymentList){
    setState(() {
      lstrSelectedBill  = datalist;
      lstrRetailPay = retailPay;
      lstrPaymentList = paymentList;
    });
    fnPaidCalc();
    saveSts? fnSave():'';
  }
  fnItemNoteCallBack(itemCode,note,qty){
    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( itemCode == lcode ){
          e["NOTE"]=note.toString();
          e["QTY"]=qty;
          break;
        }
      }
    }
    setState(() {
      sidePageView = "O";
    });
    print(lastOrder);
    fnOrderCalc();
  }
  fnUpdateNoteText(note){
    setState(() {
      txtNote.text = txtNote.text +'  ' + note.toString();
    });
  }
  fnAddNew(){
    fnClear();
    setState(() {
      wstrPageMode = "ADD";
      lastOrder = [];
      lastOrderTable = [];
      lastOrderAddress = [];
      lstrSelectedInstructions = [];
      lstrLastInstructions = [];
      lstrSelectedBill = [];
      lstrPaymentList =[];
      lstrRetailPay = [];
      lstrAddlAmount = [];
      lstrSelectedBookingNo = "";
      lstrSelectedBookingParty = '';
      lstrSelectedBookingPartyName = '';
      lstrSelectedBookingDocType = "";
      finalBillYn =  widget.mode == "F"?"Y": "N";

      lstrOrderQtyV = 0;
      lstrLastGross = 0.00;
      lstrLastVat = 0.00;
      lstrLastTotal = 0.00;
      lstrLastDiscount = 0.00;
      lstrLastAddlAmount = 0.00;
      lstrTaxable = 0.00;
      lstrPaidAmt = 0.00;
      lstrBalanceAmt = 0.00;
      lstrFinalBillAdvAmount = 0.00;

      lstrCouponNo = '';
      lstrCouponDate = '';
      lstrCouponStatus = '';
      lstrCouponCombo = [];
      lstrCouponItems = [];
      lstrCouponIssue= [];
      lstrCouponMast= [];
      lstrCouponRedeemQty  = 0.0;
      lstrCouponUsedCombo  = '';
      lstrSelectedCouponitems=[];
      lstrSelectedCitems=[];
      lstOrderCouponitems=[];
      lstrOrderCitems=[];

      optionMode =false;

      selectedBranch = "";
      selectedBranchDescp = "";


    });
    fnClearAll();
    fnGetMenu();

  }
  fnClear(){
    setState(() {
      lstrRsl = [];
      lstrRslDet=[];
      lstrRslVoid = [];
      lstrRslVoidDet = [];
      lstrRslBooking = [];
      lstrRslBookingTable = [];
      lstrRslDetBooking = [];
      lastOrder = [];
      lstrSelectedAddlList = [];
      lstrSelectedRslItems = [];
      lstrPaymentList =[];
      lstrRetailPay = [];
      lstrAddlAmount = [];

      finalBillYn =  widget.mode == "F"?"Y": "N";

      lstrSelectedBill =[];

      txtQty.clear();
      txtNote.clear();
      txtSearchDishCode.clear();


      txtCustMobileNo.clear();
      txtCustomerCode.clear();
      txtCustomerName.clear();

      lstrSelectedBookingNo = '';
      lstrSelectedBookingDocType = '';
      lstrSelectedBookingYearcode = '';
      lstrSelectedBookingParty = '';
      lstrSelectedBookingPartyName = '';


      creditCheck =  false;
      saveSts  = true;
      printRsl  = true;
      printRslSpot =  true;

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

      paymentDocno  = "";
      paymentDoctype  = "";
      paymentCard  = "";

      selectedBranch = "";
      selectedBranchDescp = "";

    });
  }
  fnSelectAddOn(code){
     var selectedData = [];
     for(var e in lastOrder){
       var lstrAddonCode = e["ADDON_STKCODE"];
       if(lstrAddonCode == code  ){
         selectedData.add(e);
       }
     }
     return selectedData;
  }
  fnSelectAddOnQty(code){
    var qty = 0.0;
    for(var e in lastOrder){
      var lstrAddonCode = e["ADDON_STKCODE"];
      if(lstrAddonCode == code  ){
        qty += g.mfnDbl(e["QTY"]);
      }
    }
    return qty;
  }
  fnRemoveAddOn(code){
    var selectedData =[] ;
    for(var e in lastOrder){
      var lstrAddonCode = e["ADDON_STKCODE"];
      if(lstrAddonCode == code  ){
          selectedData.add(e);
      }
    }

    setState(() {
      if(g.fnValCheck(selectedData)){
        for(var e in selectedData){
          lastOrder.remove(e);
        }
      }
    });
    fnOrderCalc();
  }
  fnAddOnCallBack(order,lstrItemDetails,dataList,addOnList){
    var mode = "";
    var sts = "";
    var enterQty = 0.0;
    var clearedQty = 0.0;
    var dishCode  =  '';
    if(g.fnValCheck(lstrItemDetails)){
      mode = lstrItemDetails[0]["MODE"];
      sts = lstrItemDetails[0]["ITEM_STATUS"];
      dishCode = lstrItemDetails[0]["DISHCODE"];
      enterQty = g.mfnDbl(lstrItemDetails[0]["ENTER_QTY"]);
      clearedQty = g.mfnDbl(lstrItemDetails[0]["CLEARED_QTY"]);
    }
    if(mode != ""){
      fnItemPress(dataList,enterQty,mode,sts,clearedQty);
      setState(() {
        var oldAddOnData  = [];
        for(var e in lastOrder){
          var faddOnCode = e["ADDON_STKCODE"];
          if(dishCode == faddOnCode){
            oldAddOnData.add(e);
          }
        }
        for(var e  in oldAddOnData){
          lastOrder.remove(e);
        }
        for(var e in addOnList){
          lastOrder.add(e);
        }
      });
    }else{
      setState(() {
        lastOrder = order;
      });
    }
    fnOrderCalc();

  }
  fnGetAddOnSrno(code){
    var srno = 0;
    for(var e in lstrRslDet){
      if(code == e["STKCODE"]){
        srno =  e["SRNO"];
        break;
      }
    }
    return srno;
  }
  fnCardPaymentCallBack(trnDocno,trnDoctype,trnCard,retailPay){
    setState(() {
      lstrSelectedBill= [];
      lstrSelectedBill.add({
        "DOCNO":'NEW',
        "TYPE": lstrSelectedOrderType,
        "USER" :g.wstrUserCd,
        "NAME" : '',
        "CASH" : 0.00,
        "CARD" : 0.00,
        "TOTAL_AMT":lstrLastTotal,
        "PAID_AMT":lstrLastTotal,
        "CHANGE_TO":0.00
      });
    });
    paymentDocno  = trnDocno;
    paymentDoctype  = trnDoctype;
    paymentCard  = trnCard;
    fnPaymentCallBack(lstrSelectedBill, retailPay, []);
  }


  //mrq


 //============================API CALL ===================

  fnGetMenu() async{
    futureMenu =  apiCall.getMenuItem(g.wstrCompany, lstrMenuCode, lstrMenuGroup, lstrGp1, lstrGp2, lstrGp3, lstrGp4, lstrGp5, lstrGp6, lstrGp7, lstrGp8, lstrGp9, lstrGp10, lstrSearch,g.wstrUserCd,g.wstrDeliveryMode);
    futureMenu.then((value) => fnGetMenuSuccess(value));
  }
  fnGetMenuSuccess(value){
    if(g.fnValCheck(value)){
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
    }
  }

  fnGetBooking(docno,dateFrom,dateTo,mode){
    futureGetBooking =  apiCall.getBooking(g.wstrCompany, g.wstrYearcode, "RBK", docno, mode, dateFrom, dateTo,null,null,null,null,null);
    futureGetBooking.then((value) => fnGetBookingSuccess(value));
  }
  fnGetBookingSuccess(value){

  }

  fnGetCustomer(){
    futureGuest = apiCall.getGuest(lstrMobArea.toString()+txtCustMobileNo.text.toString());
    futureGuest.then((value) => fnGetCustomerSuccess(value));
  }
  fnGetCustomerSuccess(value){
    if(g.fnValCheck(value)){
      var dataList =  value[0];
      txtCustomerName.text = dataList["GUEST_NAME"].toString();
      txtCustomerCode.text = dataList["GUEST_CODE"].toString();
    }
  }

  fnPrint(printmode) {
    if(printRsl){
      //Navigator.pop(context);
      setState(() {
        printRsl = false;
      });
      futurePrint =  apiCall.printInvoice(g.wstrCompany, g.wstrYearcode, lstrPrintDocno, "RSL", 1, g.wstrPrinterPath,lstrPayMode);
      futurePrint.then((value) => fnPrintSuccess(value,printmode));
    }
  }
  fnPrintSuccess(value,printmode){
    if(printmode != "Y"){
      fnPrintKitchenSpot();
    }
    setState(() {
      lstrPayMode = "";
      printRsl = true;
    });
  }

  fnPrintKitchenSpot() {

    if(printRslSpot){
      //Navigator.pop(context);
      printRslSpot = false;
      futurePrint =  apiCall.printSpotInvoice(g.wstrCompany, g.wstrYearcode, lstrPrintDocno, "RSL", 1, "","");
      futurePrint.then((value) => fnPrintKitchenSuccess(value));
    }
  }
  fnPrintKitchenSuccess(value){
    setState(() {
      lstrPrintDocno = '';
      printRslSpot = true;
    });
  }

  fnPrintKitchenSpotBooking() {

    if(printRslSpot){
      //Navigator.pop(context);
      printRslSpot = false;
      futurePrint =  apiCall.printSpotInvoiceBooking(g.wstrCompany, g.wstrYearcode, lstrPrintDocno, "RBI", 1, "","");
      futurePrint.then((value) => fnPrintKitchenBookingSuccess(value));
    }
  }
  fnPrintKitchenBookingSuccess(value){
    if(mounted){
      setState(() {
        lstrPrintDocno = '';
        printRslSpot = true;
      });
    }
  }

  fnGetAddOnCombo(mode,code,dataList,enterQty,Mode,itemData){

    futureAddon = apiCall.getComboAddon(mode, code);
    futureAddon.then((value) => fnGetAddOnComboSuccess(value,dataList,enterQty,Mode,itemData) );
  }
  fnGetAddOnComboSuccess(value,dataList,enterQty,Mode,itemData){
    if(g.fnValCheck(value)){
      setState(() {
        lstrAddonDataList = dataList;
      });
      PageDialog().showL(context,
          AddOns(
            lastOrder: lastOrder,
            fnCallBack: fnAddOnCallBack,
            enterQty: g.mfnDbl(enterQty), qtyMode: Mode,
            lstrDataList: dataList,
            lstrAddOnList:value,
            lstrItemDetails: itemData,
          ),
          'Add-ons');
    }
  }

  apiSaveMrq(mrq, mrqdet){
    futurePrint =  apiCall.apiSaveMrq(mrq, mrqdet, "ADD");
    futurePrint.then((value) => apiSaveMrqRes(value));
  }
  apiSaveMrqRes(value){
    setState(() {
      saveSts = true;
    });
    if(g.fnValCheck(value)){
      var sts = value[0]['STATUS'].toString();
      var msg = value[0]['MSG'];
      if(sts == '1'){
        showToast( msg);
        setState(() {
          lstrPrintDocno = value[0]['CODE'];
        });
        fnAddNew();
      }
      showToast( msg);
    }

    if(widget.mode =="F"){
      widget.fnCallBackVoid!();
      Navigator.pop(context);
    }
  }

  apiGetBranch(){
    futurePrint = apiCall.apiGetBranch();
    futurePrint.then((value) => apiGetBranchRes(value));
  }
  apiGetBranchRes(value){
    print(value);
    if(mounted){
      setState(() {
        branchList = [];
        if(g.fnValCheck(value)){
          branchList =  value??[];
        }
      });
    }
  }


 //============================Navigation ===================

  fnClosePage() async{
    if(widget.mode =="F"){
     try{
       widget.fnCallBackVoid!();
     }catch(e){

     }
      Navigator.pop(context);
    }else{
      Navigator.pop(context);
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
          )
        ],
      ),
    ), 'System Info');
  }

  //===================================POLE DISPLAY
  fnGetAvailablePorts(item,price,total){
    if(polDisplayYn != "Y"){
      return;
    }

    var comPort = g.wstrPolDisplay;
    if(comPort.toString().isEmpty){
      comPort = "COM15";
    }

    fnOrderCalc();

    try{
      SerialPort port = SerialPort(comPort, ByteSize: 8);
      if(!port.isOpened){
        port.open();
        port.BaudRate = 9600;
      }

      var prLen  =  price.toString().length;
      var subLen =  19 -prLen;
      var sub1  =  "                    ";

      if(item.toString().length > subLen){
        item =  item.toString().substring(0,subLen);
      }
      var val  = item+price.toString();
      var difLen1 =  19 - (prLen+item.toString().length);
      if(difLen1 > 0){
        sub1 = sub1.substring(0,difLen1);
        val  = item+sub1+price.toString();
      }


      var totLen = (lstrLastTotal.toString().length)+5;
      var difLen =  19 - totLen;
      var sub  =  "                    ";
      sub = sub.substring(0,difLen);
      var totVal  = "Total"+sub+lstrLastTotal.toString();


      final uint8_data = Uint8List.fromList([27,64]);
      print(port.writeBytesFromUint8List(uint8_data));
      port.writeBytesFromString(val.toString());
      port.writeBytesFromString("\r\n");
      port.writeBytesFromString(totVal);

      port.close();
    }catch(e){
      print(e);
    }
  }

  fnClearDisplay(){
    if(polDisplayYn != "Y"){
      return;
    }
    var comPort = g.wstrPolDisplay;
    if(comPort.toString().isEmpty){
      comPort = "COM15";
    }
    try{
      SerialPort port = SerialPort(comPort, ByteSize: 8);
      if(!port.isOpened){
        port.open();
        port.BaudRate = 9600;
      }
      final uint8_data = Uint8List.fromList([27,64]);
      print(port.writeBytesFromUint8List(uint8_data));
      port.close();
    }catch(e){
      print(e);
    }
  }
  fnFillDisplay(text1,text2){
    if(polDisplayYn != "Y"){
      return;
    }
    var comPort = g.wstrPolDisplay;
    if(comPort.toString().isEmpty){
      comPort = "COM15";
    }
    try{
      SerialPort port = SerialPort(comPort, ByteSize: 8);
      if(!port.isOpened){
        port.open();
        port.BaudRate = 9600;
      }
      final uint8_data = Uint8List.fromList([27,64]);
      print(port.writeBytesFromUint8List(uint8_data));
      port.writeBytesFromString(text1.toString());
      port.writeBytesFromString("\r\n");
      port.writeBytesFromString(text2.toString());
      port.close();
    }catch(e){
      print(e);
    }
  }

}

