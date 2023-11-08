
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class ReturnBill extends StatefulWidget {

  final List<dynamic>  lstrDataList;
  final List<dynamic>  lstrDataListDet;
  final List<dynamic>  lstrRslHeader;
  final Function  fnCallBack;

  const ReturnBill({Key? key, required this.lstrDataList, required this.fnCallBack, required this.lstrDataListDet, required this.lstrRslHeader, }) : super(key: key);

  @override
  _ReturnBillState createState() => _ReturnBillState();
}

class _ReturnBillState extends State<ReturnBill> {


  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic> futureCard;

  var lstrEntryMode = 'C';
  var lstrCashEntry ='0.0';
  var lstrSelectedData = [];
  var lstrSelectedDataDet = [];
  var lstrSelectedRsl = [];
  var lstrItems = [];
  var lstrRsl = [];
  var lstrRslDet=[];
  var lstrRetailPay = [];
  var lstrOtherCharges = [];
  var lstrOldOtherCharges = [];

  var lstrSelectedDocno = '' ;
  var lstrSelectedDocDate  =   '';
  var lstrSelectedType = '' ;
  var lstrSelectedCharge = '' ;

  var lstrSelectedStkDesp = '';
  var lstrSelectedStkCode = '';
  var lstrSelectedSrno = '';

  var lstrLastTotal = 0.00;
  var lstrLastAddlAmt = 0.0;
  var lstrLastdiscountAmt = 0.0;
  var lstrTaxableAmt  = 0.0;
  var lstrOtherAmount  = 0.0;

  var lstrReturnAmt  =  0.0;
  var lstrFinalBillAmt  = 0.0;
  var lstrTotalItems  = 0;
  var lstrBalanceAmount = 0.0;
  var lstrSelectedQty  =0.0;
  var srno = 0;


  String lstrSelectedPaymentMode = 'CASH';
  List <String> lstrSelectedPayment = [
    'CASH',
  ] ;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lstrSelectedData = widget.lstrDataList;
    srno = 0;
    lstrSelectedDataDet = g.mfnJson(widget.lstrDataListDet);
    lstrSelectedRsl = g.mfnJson(widget.lstrRslHeader);
    fnSetPageData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: boxDecoration(Colors.white, 10),
                width: size.width*0.2,
                height: 530,
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      gapHC(25),
                      tc('Bill#  '+lstrSelectedDocno.toString(), Colors.black, 15),
                      gapHC(5),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,size: 10,),
                          gapWC(10),
                          tc(lstrSelectedDocDate.toString(), Colors.black, 12)
                        ],
                      ),
                      gapHC(5),
                      line(),
                      gapHC(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              tc('Total Items ', Colors.black, 13),
                              gapHC(5),
                              tc('Discount Amount ', Colors.black, 13),
                              gapHC(5),
                              tc('Additional Amount ', Colors.black, 13),

                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              tc(lstrTotalItems.toString(), Colors.black, 13),
                              gapHC(5),
                              tc(lstrLastdiscountAmt.toStringAsFixed(2), Colors.black, 13),
                              gapHC(5),
                              tc(lstrLastAddlAmt.toStringAsFixed(2), Colors.black, 13),

                            ],
                          )
                        ],
                      ),
                      gapHC(5),
                      line(),
                      gapHC(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              tc('Bill Amount ', Colors.black, 14),
                              gapHC(5),
                              tc('Return Amount ', Colors.black, 14),

                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              tc(lstrLastTotal.toStringAsFixed(2), Colors.green, 14),
                              gapHC(5),
                              tc(lstrReturnAmt.toStringAsFixed(2), Colors.red, 14),

                            ],
                          )
                        ],
                      ),
                      gapHC(5),
                      line(),
                      gapHC(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              tc('Total Amount ', Colors.black, 16),


                            ],
                          ),
                          Column(
                            children: [
                              tc(lstrFinalBillAmt.toStringAsFixed(2), Colors.green, 16),
                            ],
                          )
                        ],
                      ),
                      gapHC(5),
                      line(),
                      gapHC(15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              tc(lstrBalanceAmount.toStringAsFixed(2),Colors.red,35),
                              ts('RETURN AMOUNT',Colors.black,12)
                            ],
                          )
                        ],
                      ),
                      gapHC(10),




                    ],
                  ),
                ),
              ),
              Container(
                width: size.width*0.4,
                height: 530,
                padding: EdgeInsets.all(10),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tc('Bill Items', Colors.black, 15),

                        GestureDetector(
                            onTap: (){
                              fnUpdateReturnAll();
                            },

                            child: Container(
                              height: 20,
                              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                              decoration: boxDecoration(PrimaryColor, 30),
                              child: Center(
                                child:  tc('VOID ALL', Colors.white, 10),
                              ),
                            )
                        )
                      ],
                    ),
                    gapHC(10),
                    Expanded(child: itemView(size)),
                  ],
                ),
              ),

              Container(
                //number
                width: size.width*0.25,
                height: 530,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(child: tc(lstrSelectedStkDesp.toString(), Colors.black, 15))
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: tc('QTY : '+lstrSelectedQty.toStringAsFixed(2), Colors.black, 13))
                      ],
                    ),
                    gapHC(10),
                    Container(
                      padding: EdgeInsets.only(left: 5,right: 5),
                      height: 30,
                      decoration: boxBaseDecoration(blueLight, 15),
                      child: Center(
                        child: DropdownButton<String>(
                          value: lstrSelectedPaymentMode,
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          underline: Container(
                            height: 0,
                            color: Colors.black26,
                          ),
                          onChanged: (data) {
                            setState(() {
                              lstrSelectedPaymentMode = data.toString();
                              if(data.toString() != "CASH"){
                                //fnSetCardAmount();
                              }
                            });
                          },
                          items: lstrSelectedPayment.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: ts(value,Colors.black,10),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    gapHC(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onLongPress: (){
                            setState(() {
                              var qty  = 0.0;

                              lstrCashEntry =  qty.toString();
                            });
                          },
                          onTap: (){
                            setState(() {
                              var qty  = g.mfnDbl(lstrCashEntry);
                              print(qty);
                              qty  = qty == 0 || 0 > qty ?0.0:(qty-1);
                              qty =  0 > qty ?0.0:(qty);

                              lstrCashEntry =  qty.toString();
                              fnUpdateReturn(lstrSelectedStkCode,lstrSelectedSrno);
                            });
                          },
                          child: Container(
                            height: 40,
                            width: size.width*0.05,
                            decoration: boxDecoration(Colors.amber, 5),
                            child: Center(
                              child: tc('-',Colors.black,25),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){

                          },
                          child: Container(
                            height: 40,
                            width: size.width*0.13,
                            decoration: boxBaseDecoration(yellowLight, 5),
                            child: Center(
                              child: tc(lstrCashEntry,PrimaryColor,25),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              var qty  = g.mfnDbl(lstrCashEntry);
                              qty  = qty+1;
                              if(lstrSelectedQty < 1){
                                qty = lstrSelectedQty;
                              }
                              if(lstrSelectedQty >= qty){
                                lstrCashEntry =  qty.toString();
                                fnUpdateReturn(lstrSelectedStkCode,lstrSelectedSrno);
                              }
                            });
                          },
                          child: Container(
                            height: 40,
                            width: size.width*0.05,
                            decoration: boxDecoration(Colors.amber, 5),
                            child: Center(
                              child: tc('+',Colors.black,25),
                            ),
                          ),
                        ),
                      ],
                    ),
                    gapHC(20),
                    Expanded(child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          numberPress('1',size),
                          numberPress('2',size),
                          numberPress('3',size),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          numberPress('4',size),
                          numberPress('5',size),
                          numberPress('6',size),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          numberPress('7',size),
                          numberPress('8',size),
                          numberPress('9',size),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          numberPress('.',size),
                          numberPress('0',size),
                          numberPress('x',size),

                        ],
                      ),
                    ],)),
                    gapHC(10),

                    GestureDetector(
                      onTap: (){
                        fnDone();
                      },
                      child: Container(
                        height: 50,
                        decoration: boxDecoration(Colors.green, 30),
                        child: Center(
                          child: tc('DONE',Colors.white,15),
                        ),
                      ),
                    )


                  ],
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
  //=======================WIDGET UI ===============================s

  Container itemView(size) {
    srno = 0;
    return Container(
      child: ListView.builder(

          physics: AlwaysScrollableScrollPhysics(),
          itemCount: lstrItems.length,
          itemBuilder: (context, index) {
            var dataList = lstrItems[index];
            var lstrOrderNo  =  dataList["DOCNO"];
            var itemCode = dataList['STKCODE'];
            var itemName = dataList['STKDESCP'];
            var itemQty = g.mfnDbl(dataList['QTY1'].toString());
            var returnQty = g.mfnDbl(dataList['RETURN_QTY'].toString());
            var itemStatus = dataList['STATUS'].toString();
            var itemRate = dataList['RATE'].toString();
            var ItemSrno = dataList['SRNO'].toString();
            var itemTotal = g.mfnDbl(dataList['QTY1'].toString()) * double.parse(itemRate);
            var rtnSts  = dataList['RETURNED_YN'].toString();
            var voidQty  = dataList['VOID_QTY'].toString();
            if( itemStatus != 'C'){
              srno = srno+1;
            }

            return  GestureDetector(
              onLongPress: (){
                fnUpdateReturnZero(itemCode,ItemSrno.toString());
              },
              onTap: (){
                if(rtnSts != "Y"){
                  setState(() {
                    srno = 0;
                    lstrSelectedStkCode = itemCode;
                    lstrSelectedStkDesp =  itemName;
                    lstrSelectedQty = dataList['QTY1'] ;
                    lstrSelectedSrno = dataList['SRNO'].toString();
                    lstrCashEntry = lstrSelectedQty.toString();
                  });
                }
              },
              child: itemStatus == 'C' ? Container():   Container(
                padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                margin: EdgeInsets.only(bottom: 5),
                decoration: boxBaseDecoration(rtnSts == "Y"?Colors.red:(lstrSelectedStkCode == itemCode? yellowLight:greyLight), 3),
                child:  Column(
                  children: [
                    gapHC(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child:  Expanded(child: tc((srno).toString() +'. '+itemName,rtnSts == "Y"?Colors.white:Colors.black,13),),
                        ),

                      ],
                    ),
                    gapHC(10),Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width*.06,
                          child: tc('RATE '+itemRate.toString() ,rtnSts == "Y"?Colors.white:Colors.black,10),
                        ),
                        Container(
                          width: size.width*.06,
                          child:  tc( rtnSts == "Y"?'VOID QTY '+ voidQty.toString() :  'QTY '+itemQty.toString(),rtnSts == "Y"?Colors.white:Colors.green,10),
                        ),
                        Container(
                          width: size.width*.06,
                          child:  tc( 'RETURN '+returnQty.toString(),rtnSts == "Y"?Colors.white:Colors.red,10),
                        ),
                        Container(
                          width: size.width*.06,
                          child:  tc(itemTotal.toString(),rtnSts == "Y"?Colors.white:PrimaryColor,10),
                        ),

                      ],
                    ),

                  ],
                ),
              ),
            );
          }),
    );
  }

  //=========================Other Function ======================
  GestureDetector numberPress(text,size) => GestureDetector(
    onTap: (){
      fnOnPress(text);
    },
    onLongPress: (){
      fnOnLongPress(text);
    },
    child: Container(
      height: 60,
      width: size.width*0.07,
      margin: EdgeInsets.only(bottom: 5),
      decoration: boxDecoration(Colors.white, 10),
      child: Center(
        child: tc(text,titleSubText,30),
      ),
    ),
  );
  fnOnPress(mode){

    if(mode == 'x'){
      setState(() {
        lstrCashEntry = lstrCashEntry == '0.0' ? '' :lstrCashEntry;
        lstrCashEntry = lstrCashEntry == ''? '' : lstrCashEntry.substring(0, lstrCashEntry.length - 1);
        lstrCashEntry = lstrCashEntry.isEmpty ? '0.0': lstrCashEntry ;
      });
    }
    else if(mode == '.'){
      if(lstrEntryMode == 'C'){
        if(!lstrCashEntry.contains('.',0)){
          setState(() {
            lstrCashEntry = lstrCashEntry == '0.0' ? '' :lstrCashEntry;
            lstrCashEntry =lstrCashEntry.toString() + mode.toString();
          });
        }
      }
    }else{
      if(lstrEntryMode == 'C'){
        setState(() {
          if(lstrCashEntry.length < 12){
            lstrCashEntry = lstrCashEntry == '0.0' ? '' :lstrCashEntry;
            lstrCashEntry =lstrCashEntry.toString() + mode.toString();
          }

        });
      }
    }
    var qty =  g.mfnDbl(lstrCashEntry);
    if(lstrSelectedQty < qty){
      lstrCashEntry = lstrSelectedQty.toString();
    }

  }
  fnOnLongPress(mode){
    if(mode == 'x'){
      setState(() {
        lstrCashEntry = '0.0';
      });
    }
  }

  fnUpdateReturn(stkcode,srno){
    var qty  =  g.mfnDbl(lstrCashEntry);
    if(qty  >  lstrSelectedQty){
      showToast( 'Please enter correct qty');
      return false;
    }
    var rtrnQty  =  lstrSelectedQty - qty;
    if(rtrnQty >  lstrSelectedQty){
      rtrnQty  =  lstrSelectedQty;
    }
    for (var e  in lstrItems){
      var lcode  =  e["STKCODE"];
      var lsrno  =  e["SRNO"].toString();
      if(lsrno == srno  && lcode  ==  stkcode){
       setState(() {
         e["RETURN_QTY"] = rtrnQty;
       });
        break;
      }
    }
    fnCalc();
  }
  fnUpdateReturnZero(stkcode,srno){
    for (var e  in lstrItems){
      var lcode  =  e["STKCODE"];
      var lsrno  =  e["SRNO"].toString();
      var returnSts = e["RETURNED_YN"];
      if(lsrno == srno  && lcode  ==  stkcode && returnSts != "Y" ){
        setState(() {
          e["RETURN_QTY"] = 0;
        });
        break;
      }
    }
    fnCalc();
  }
  fnUpdateReturnAll(){
    for (var e  in lstrItems){
      var returnSts = e["RETURNED_YN"];
      if(returnSts != "Y" ){
        e["RETURN_QTY"] = e["QTY1"];
      }
    }
    fnCalc();
  }
  fnCheckReturnQty(stkcode,itemSrno){
    var returnQty  = 0.0;
    for (var e  in lstrItems){
      var lcode  =  e["STKCODE"];
      var lsrno  =  e["SRNO"].toString();
      if(lsrno == itemSrno.toString()  && lcode  ==  stkcode){
        returnQty = g.mfnDbl(e["RETURN_QTY"]);
        break;
      }
    }
    return returnQty;
  }

  // ========================PAGE FUNCTIONS  ========================
  fnDone(){

    var RSL_VOID_HISTORY = [];
    var RSL_VOID_HISTORY_DET = [];

    var lstrKot  = [];
    var lstrKotDet = [];
    var lstrItemDetCalc  =  g.mfnJson(lstrSelectedDataDet);
    var rtnSts =  false;
      for(var e  in  lstrItems){
        var rtnQty  =  e["RETURN_QTY"];
        if(rtnQty > 0){
          rtnSts =  true;
          break;
        }
      }
    if(!rtnSts) {
      return false;
    }

    setState(() {
      lstrRsl  = [];
      lstrRslDet = [];
      lstrRetailPay = [];
    });
    var returnQtyDiffItems= [];
    var index  =  0;
    for(var e in lstrItemDetCalc){
        var stkcode  =  e["STKCODE"];
        var srno =  e["SRNO"];
        var qty =  e["QTY1"];
        var qtyDifference = 0.0;
        var returnQty  =  fnCheckReturnQty(stkcode, srno);
        if(returnQty > 0){
          qtyDifference = qty - returnQty ;
          if(qtyDifference != 0){
            returnQtyDiffItems.add(g.mfnJson(lstrItemDetCalc[index]));
          }
          e["RETURNED_YN"] = "Y";
          e["VOID_QTY"] = returnQty;
        }
        index ++;
    }
    index = 0;
    for(var e in returnQtyDiffItems){
      lstrItemDetCalc.add(returnQtyDiffItems[index]);
       index++;
    }
    var lineSrno  =  0;
    var totalAmount = 0.0;
    var totalTaxAmount = 0.0;
    var totalGramt  = 0.0;
    var totalTaxableAmt = 0.0;
    var returnTotalTaxableAmt = 0.0;
    var otherAmtReturn = 0.0;
    var totalTaxPerc = 0.0;

    for(var f  in lstrOtherCharges){
      //{CODE: MUN, DESCP: MUNCIPALITY FEE, SHORTDESCP: MUNCIPAL, PERC: 7.0, ACCODE: 106007, VAT_PERC: null, VAT_ACCODE: null}
      var perc  =  g.mfnDbl(f["PERC"]);
      var vatPerc  =  g.mfnDbl(f["VAT_PERC"]);
      var vatPerc1 = 0.0;
      vatPerc1 = (perc*vatPerc)/100;
      var totalVat = perc + vatPerc1;
      totalTaxPerc = totalTaxPerc + totalVat;
    }

    for(var e  in  lstrItemDetCalc){
      lineSrno= lineSrno +1;
      var qty  =  e["QTY1"];
      var stkcode  =  e["STKCODE"];
      var srno =  e["SRNO"];
      var returnYN =  e["RETURNED_YN"];
      if(returnYN != "Y"){
        var qtyDifference = 0.0;
        var returnQty  =  fnCheckReturnQty(stkcode, srno);
        var disc  =  e["HEADER_DISC_AMTFC"];
        var addl  =  e["ADDL_AMTFC"];
        var amtfc  =  e["AMTFC"];
        var total  =  (amtfc + addl) - disc;
        var vatSts = e["RATE_INCLUDE_TAX"];
        var vatP = e["TAX_PERC"]??0.0;
        var itemTotalTaxPerc  =  totalTaxPerc+vatP;
        var itemTaxable = 0.0;
        var itemConversionFactor  = 0.0;
        //2.OTHER_TAX >> FIND CONVERSION FACTOR
        itemConversionFactor =  ((100+itemTotalTaxPerc)/100);

        var rate = 0.0;
        if(qty != 0){
          rate = total/qty;
        }
        qtyDifference = qty - returnQty;
        var rtnAmount  = rate * qtyDifference;
        var vat = 0.0;
        var itemVatAmount = 0.0;
        var otherVat = 0.0;
        var itemOtherVatAmount = 0.0;
        var netAmt = rtnAmount;
        if(itemTotalTaxPerc > 0) {
          if(vatSts == 'Y' ){
            itemTaxable = (rtnAmount / itemConversionFactor);
            itemVatAmount =  (itemTaxable * vatP)/100;
            itemOtherVatAmount = (itemTaxable * totalTaxPerc)/100;
          }else{
            itemTaxable = rtnAmount;
            vat = (vatP)/100;
            itemVatAmount =  itemTaxable * vatP;
            otherVat = (totalTaxPerc)/100;
            itemOtherVatAmount =  itemTaxable * otherVat;
            netAmt = rtnAmount + itemVatAmount+itemOtherVatAmount;
          }
        }

        e["RATE"] = rate*g.wstrCurrencyRate;
        e["RATEFC"] = rate;
        e["QTY1"] = qtyDifference;
        e["RATEFC"] = rate;
        e["AMT"] = rtnAmount;
        e["AMTFC"] = rtnAmount;
        e["GRAMT"] = rtnAmount;
        e["GRAMTFC"] = rtnAmount;
        e["TAXABLE_AMT"] = itemTaxable;
        e["TAXABLE_AMTFC"] = itemTaxable;
        e["TOT_TAX_AMT"] = itemVatAmount;
        e["TOT_TAX_AMTFC"] = itemVatAmount;
        e["OTHER_TAX_AMT"] = itemOtherVatAmount;
        e["OTHER_TAX_AMTFC"] = itemOtherVatAmount;
        e["HEADER_DISC_AMT"] = 0.0;
        e["HEADER_DISC_AMTFC"] = 0.0;
        e["ADDL_AMT"] = 0.0;
        e["ADDL_AMTFC"] = 0.0;
        totalTaxableAmt = totalTaxableAmt + itemTaxable;
        totalTaxAmount = totalTaxAmount + itemVatAmount;
        totalGramt =totalAmount +rtnAmount;
        totalAmount =totalAmount +netAmt;
      }else{

        var qtyDifference = 0.0;
        var returnQty  =  e["VOID_QTY"];
        var disc  =  e["HEADER_DISC_AMTFC"];
        var addl  =  e["ADDL_AMTFC"];
        var amtfc  =  e["AMTFC"];
        var total  =  (amtfc + addl) - disc;


        var vatSts = e["RATE_INCLUDE_TAX"];
        var vatP = e["TAX_PERC"]??0.0;
        var rate = 0.0;
        if(qty != 0){
          rate = total/qty;
        }
        qtyDifference = returnQty;
        var rtnAmount  = rate * qtyDifference;
        var vat = 0.0;
        var vatA = 0.0;
        var taxable = 0.0;
        var netAmt = rtnAmount;
        if(vatSts == 'Y' && vatP > 0){
          var dvd = 100 /(100+vatP);
          vat =  rtnAmount * dvd;
          vatA = rtnAmount - vat;
          taxable = rtnAmount - vatA;
          returnTotalTaxableAmt = (returnTotalTaxableAmt + rtnAmount) - vatA;
        }else{
          vat = (vatP)/100;
          vatA = rtnAmount * vat;
          taxable = rtnAmount;
          returnTotalTaxableAmt = (returnTotalTaxableAmt + rtnAmount);
          netAmt = netAmt+vatA;
        }
        e["RATE"] = rate*g.wstrCurrencyRate;
        e["RATEFC"] = rate;
        e["QTY1"] = returnQty;
        e["RATEFC"] = rate;
        e["AMT"] = rtnAmount;
        e["AMTFC"] = rtnAmount;
        e["GRAMT"] = rtnAmount;
        e["GRAMTFC"] = rtnAmount;

        e["TOT_TAX_AMT"] = 0.0;
        e["TOT_TAX_AMTFC"] = 0.0;
        e["TAXABLE_AMT"] = 0.0;
        e["TAXABLE_AMTFC"] = 0.0;
        e["HEADER_DISC_AMT"] = 0.0;
        e["HEADER_DISC_AMTFC"] = 0.0;
        e["OTHER_TAX_AMT"] = 0.0;
        e["OTHER_TAX_AMTFC"] = 0.0;
        e["ADDL_AMT"] = 0.0;
        e["ADDL_AMTFC"] = 0.0;

        RSL_VOID_HISTORY_DET.add({
          "STKCODE":e["STKCODE"],
          "STKDESCP":e["STKDESCP"],
          "VOID_QTY":e["VOID_QTY"],
          "VOID_AMT":rtnAmount
        });

      }
      e["SRNO"] = lineSrno;
    }

    var srnoOther  = 1;
    var otherAmount = 0.0;
    var OTHER_AMT = [];
    for(var e in lstrOtherCharges){
      var perc  =  g.mfnDbl(e["PERC"]);
      var vatPerc  =  g.mfnDbl(e["VAT_PERC"]);
      var amt =  (g.mfnDbl(totalTaxableAmt) *  perc)/100;
      var vatAmt = (amt * vatPerc)/100;
      var total = vatAmt + amt;
      //COMPANY,DOCNO,DOCTYPE,YEARCODE,SRNO,CODE,DESCP,PERC,AMTFC,AMT,ACCODE,CURR,CURRATE
      OTHER_AMT.add({
        "COMPANY":g.wstrCompany,
        "DOCNO":lstrSelectedDocno,
        "DOCTYPE":"RSL",
        "YEARCODE":g.wstrYearcode,
        "SRNO":srnoOther,
        "CODE":e["CODE"],
        "DESCP":e["DESCP"],
        "PERC":e["PERC"],
        "AMTFC":amt.toStringAsFixed(3),
        "AMT":g.mfnDbl(amt).toStringAsFixed(3) * g.wstrCurrencyRate,
        "ACCODE":e["ACCODE"],
        "VAT_PERC":g.mfnDbl(e["VAT_PERC"]),
        "VAT_AMT":vatAmt.toStringAsFixed(3),
        "VAT_AMTFC":vatAmt.toStringAsFixed(3),
        "VAT_ACCODE":e["VAT_ACCODE"]??"",
        "TOTAL_AMT":total.toStringAsFixed(3),
        "TOTAL_AMTFC":total.toStringAsFixed(3),
        "CURR":"AED",
        "CURRATE":1
      });
      srnoOther = srnoOther+1;
      otherAmount = otherAmount+total;
    }

    print(totalAmount);
    print(totalTaxAmount);
    print(lstrItemDetCalc);
    print(lstrItemDetCalc.length.toString());
    var returnAmount  = ((totalAmount) - lstrLastTotal).toStringAsFixed(3);
    print(returnAmount);

    RSL_VOID_HISTORY.add({
      "AMT":returnAmount
    });

    lstrRetailPay.add({
      "COMPANY":g.wstrCompany,
      "SRNO":1,
      "PAYMODE":lstrSelectedPaymentMode,
      "YEARCODE":g.wstrYearcode,
      "CURR":g.wstrCurrency,
      "CURRATE":g.wstrCurrencyRate,
      "AMT":returnAmount*g.wstrCurrencyRate,
      "AMTFC":returnAmount,
      "CHANGE_AMT": 0,
      "CHANGE_AMTFC": 0,
      "PRINT_YN":"",
      "POST_YN":"",
      "POSTDATE":"",
      "POST_FLAG":"",
      "AUTH_YN":"",
      "CLOSED_YN":"",
      "CARD_NO":"",
    });

    totalAmount =  totalAmount ;
    if(g.fnValCheck(lstrSelectedRsl)){
      lstrSelectedRsl[0]["GRAMT"] = totalGramt*g.wstrCurrencyRate;
      lstrSelectedRsl[0]["GRAMTFC"] = totalGramt;

      lstrSelectedRsl[0]["AMT"] = totalGramt*g.wstrCurrencyRate;
      lstrSelectedRsl[0]["AMTFC"] = totalGramt;

      lstrSelectedRsl[0]["ADDL_AMT"] = 0.0;
      lstrSelectedRsl[0]["ADDL_AMTFC"] = 0.0;

      lstrSelectedRsl[0]["DISC_AMT"] = 0.0;
      lstrSelectedRsl[0]["DISC_AMTFC"] = 0.0;

      lstrSelectedRsl[0]["TAX_AMT"] = totalTaxAmount*g.wstrCurrencyRate;
      lstrSelectedRsl[0]["TAX_AMTFC"] = totalTaxAmount;

      lstrSelectedRsl[0]["TAXABLE_AMT"] = totalTaxableAmt*g.wstrCurrencyRate;
      lstrSelectedRsl[0]["TAXABLE_AMTFC"] = totalTaxableAmt;

      lstrSelectedRsl[0]["NETAMT"] = totalAmount*g.wstrCurrencyRate;
      lstrSelectedRsl[0]["NETAMTFC"] = totalAmount;

      lstrSelectedRsl[0]["PAID_AMT"] = totalAmount*g.wstrCurrencyRate;
      lstrSelectedRsl[0]["PAID_AMTFC"] = totalAmount;

      lstrSelectedRsl[0]["BAL_AMT"] = 0.0;
      lstrSelectedRsl[0]["BAL_AMTFC"] = 0.0;

      lstrSelectedRsl[0]["OTHER_AMT"] = otherAmount*g.wstrCurrencyRate;
      lstrSelectedRsl[0]["OTHER_AMTFC"] = otherAmount;

      lstrSelectedRsl[0]["COUNTER_NO"] = g.wstrDeivceId;
      lstrSelectedRsl[0]["MACHINENAME"] = g.wstrDeviceName;


      lstrSelectedRsl[0]["CREATE_USER"] = g.wstrUserCd;
      lstrSelectedRsl[0]["EDIT_USER"] = g.wstrUserCd;
      Navigator.pop(context);
      widget.fnCallBack(lstrSelectedRsl,lstrItemDetCalc,lstrRetailPay,RSL_VOID_HISTORY,RSL_VOID_HISTORY_DET,OTHER_AMT);

    }

    lstrKot.add({
      "COMPANY" : g.wstrCompany,
      "YEARCODE":g.wstrYearcode,
      "DOCNO":g.wstrLastSelectedKotDocno,
      "SMAN":"",
      "CURR":"AED",
      "CURRATE":"1",
      "GRAMT":totalGramt,
      "GRAMTFC":totalGramt,
      "NETAMT":lstrLastTotal,
      "NETAMTFC":lstrLastTotal,
      "REMARKS":"",
      "REF1":"",
      "REF2":"",
      "PRINT_YN":"",
      "EDIT_USER":g.wstrUserCd,
      "EDIT_USER":g.wstrUserCd,
      "ORDER_TYPE" :"A",
      "STATUS":"D",
      "TABLE_DET":'',
      "ORDER_PRIORITY":0,
      "TAX_PER":0,
      "TAX_AMT": double.parse(totalTaxAmount.toStringAsFixed(5))  ,
      "TAX_AMTFC": double.parse(totalTaxAmount.toStringAsFixed(5)) * g.wstrCurrencyRate  ,
      "TAXABLE_AMT": double.parse(totalTaxableAmt.toStringAsFixed(5)) ,
      "TAXABLE_AMTFC": double.parse(totalTaxableAmt.toStringAsFixed(5))  * g.wstrCurrencyRate,
      "CREATE_MACHINEID":g.wstrDeivceId,
      "CREATE_MACHINENAME":g.wstrDeviceName,
    });

  }
  fnCalc(){
    var returnAmount  = 0.0;
    var oTaxableAmount= 0.0;
    var totalTaxPerc = 0.0;
    for(var f  in lstrOldOtherCharges){
      //{CODE: MUN, DESCP: MUNCIPALITY FEE, SHORTDESCP: MUNCIPAL, PERC: 7.0, ACCODE: 106007, VAT_PERC: null, VAT_ACCODE: null}
      var perc  =  g.mfnDbl(f["PERC"]);
      var vatPerc  =  g.mfnDbl(f["VAT_PERC"]);
      var vatPerc1 = 0.0;
      vatPerc1 = (perc*vatPerc)/100;
      var totalVat = perc + vatPerc1;
      totalTaxPerc = totalTaxPerc + totalVat;
    }

    for(var e  in  lstrItems){
      var returnSts = e["RETURNED_YN"];
      if(returnSts != "Y"){

        var qty  =  e["QTY1"];
        var rtnQty  =  e["RETURN_QTY"];
        var disc  =  e["HEADER_DISC_AMTFC"];
        var addl  =  e["ADDL_AMTFC"];
        var amtfc  =  e["AMTFC"];
        var total  =  (amtfc + addl) - disc;
        var vatSts = e["RATE_INCLUDE_TAX"]??"Y";
        var vatP = e["TAX_PERC"]??0.0;
        var itemTotalTaxPerc  =  totalTaxPerc+vatP;
        var itemTaxable = 0.0;
        var itemConversionFactor  = 0.0;
        //2.OTHER_TAX >> FIND CONVERSION FACTOR
        itemConversionFactor =  ((100+itemTotalTaxPerc)/100);

        var rate = 0.0;
        if(qty != 0){
          rate  =total/qty;
        }
        var rtnAmount  = rate * rtnQty;
        var vat = 0.0;
        var itemVatAmount = 0.0;
        var otherVat = 0.0;
        var itemOtherVatAmount = 0.0;
        if(itemTotalTaxPerc > 0) {
          if (vatSts == 'Y') {
            itemTaxable = (rtnAmount / itemConversionFactor);
            itemVatAmount =  (itemTaxable * vatP)/100;
            itemOtherVatAmount = (itemTaxable * totalTaxPerc)/100;
          } else {
            itemTaxable = rtnAmount;
            vat = (vatP)/100;
            itemVatAmount =  itemTaxable * vatP;
            otherVat = (totalTaxPerc)/100;
            itemOtherVatAmount =  itemTaxable * otherVat;
            rtnAmount = rtnAmount + itemVatAmount+itemOtherVatAmount;
          }
        }
        oTaxableAmount = oTaxableAmount + itemTaxable;
        returnAmount += rtnAmount;
      }
      setState(() {
        lstrReturnAmt  =returnAmount;
        lstrFinalBillAmt =  lstrLastTotal - lstrReturnAmt;
        lstrBalanceAmount = lstrReturnAmt;
      });
    }
  }
  fnSetPageData(){
    fnGetCard();
    if(g.fnValCheck(lstrSelectedData)){
      var dataList =  lstrSelectedData[0];
      setState(() {
        lstrSelectedDocno = dataList["DOCNO"];
        lstrSelectedType = dataList["TYPE"];
        lstrLastTotal = dataList["TOTAL_AMT"]??0.0;
        lstrLastAddlAmt =  dataList["ADDL_AMT"]??0.0;
        lstrLastdiscountAmt =  dataList["DISCOUNT"]??0.0;
        lstrTaxableAmt =  dataList["TAXABLE_AMT"]??0.0;
        lstrOtherAmount = dataList["OTHER_AMT"]??0.0;
        lstrOtherCharges =  dataList["OTHER_CHARGES"]??[];
        lstrOldOtherCharges =  dataList["OLD_CHARGES"]??[];
        lstrTotalItems =  lstrSelectedDataDet.length;
      });
      lstrItems = [];
      if(g.fnValCheck(lstrSelectedDataDet)){
        for(var e in lstrSelectedDataDet){
          lstrItems.add({
            "DOCNO":e["DOCNO"],
            "SRNO":e["SRNO"],
            "STKCODE":e["STKCODE"],
            "STKDESCP":e["STKDESCP"],
            "STKDESCP":e["STKDESCP"],
            "RETURNED_YN":e["RETURNED_YN"],
            "UNIT1":e["UNIT1"],
            "QTY1":e["QTY1"],
            "RATE":e["RATE"],
            "RATEFC":e["RATEFC"],
            "GRAMT":e["GRAMT"],
            "GRAMTFC":e["GRAMTFC"],
            "AMT":e["AMT"],
            "AMTFC":e["AMTFC"],
            "ADDL_AMT":e["ADDL_AMT"],
            "ADDL_AMTFC":e["ADDL_AMTFC"],
            "HEADER_DISC_AMT":e["HEADER_DISC_AMT"],
            "HEADER_DISC_AMTFC":e["HEADER_DISC_AMTFC"],
            "RATE_INCLUDE_TAX":e["RATE_INCLUDE_TAX"],
            "STATUS":e["STATUS"],
            "VOID_QTY":e["VOID_QTY"],
            "TAX_PERC":e["TAX_PERC"],
            "RETURN_QTY":0.0,
          });
        }
      }

      fnCalc();
    }
  }

  //=======================API CALL ===============================
  fnGetCard() async{
    futureCard =  apiCall.getCardType(g.wstrCompany);
    futureCard.then((
        value) => fnGetCardSuccess(value));
  }
  fnGetCardSuccess(value){

    if(g.fnValCheck(value)){
      for(var e in value){
        print("*********************************");
        print(value);
        setState(() {
          if(!lstrSelectedPayment.contains(e["CODE"]??"")){
            lstrSelectedPayment.add(e["CODE"]??"");
          }

        });
      }
    }else{
      setState(() {
        lstrSelectedPayment.add("CARD");
      });
    }
  }

}
