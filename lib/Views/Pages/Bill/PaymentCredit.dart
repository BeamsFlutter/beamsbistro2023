

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/lookup.dart';
import 'package:beamsbistro/Views/Components/lookup_alert.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:oktoast/oktoast.dart';

import '../../Components/rounded_inputfield.dart';

class PaymentCredit extends StatefulWidget {

  final List<dynamic>  lstrDataList;
  final List<dynamic> ? lstrRetailPay;
  final List<dynamic>  lstrPaymentList;
  final Function  fnCallBack;

  const PaymentCredit({Key? key, required this.lstrDataList, required this.fnCallBack, this.lstrRetailPay, required this.lstrPaymentList}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<PaymentCredit> {


  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic> futureCard;

  var lstrSelectedData = [];
  var lstrSelectedRetail = [];


  var lstrSelectedDocno = '' ;
  var lstrSelectedType = '' ;


  var lstrCashEntry ='0.0';
  var lstrCardEntry = '';
  var lstrDiscountEntry = '0.0';
  var lstrEntryMode = 'C';
  var lstrDoneButton = 0;
  bool lstrClearSts = true;


  var lstrLastTotal = 0.00;
  var lstrPaidAmount = 0.00;
  var lstrCashPaidAmount = 0.00;
  var lstrCardPaidAmount = 0.00;
  var lstrCash = 0.00;
  var lstrCard = 0.00;
  var lstrPaymentList = [];


  //for payment calc
  var lstrLastPaidTotal = 0.0;
  var lstrLastCashPaid = 0.0;
  var lstrLastCardPaid = 0.0;
  var lstrLastChangeTo = 0.0;

  var lstrEnterAmt = 0.0;
  var lstrEnterMode = "";

  var lstrPartyCode="";
  var lstrPartyDescp="";
  var lstrRoomCode="";
  var lstrRoomDescp="";
  var lstrRoomYN="";
  var txtPartyCode = TextEditingController();
  var txtRoomCode = TextEditingController();
  var txtRefCode = TextEditingController();


  String lstrSelectedPaymentMode = 'CREDIT';

  List <String> lstrSelectedPayment = [
    'CREDIT',
    'CASH',
  ] ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lstrSelectedData = widget.lstrDataList;
    lstrPaymentList = widget.lstrPaymentList;
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
            children: [
              Container(
                width: size.width*0.5,
                height: 550,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: boxDecoration(Colors.white, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          tc('${mfnLng("Order #")} ' +lstrSelectedDocno, Colors.black, 16),
                          tc(lstrSelectedType, PrimaryColor, 15),

                        ],
                      ),
                    ),
                    gapHC(10),
                    g.wstrRoomMode == "Y"?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: size.width*0.14,
                            child: RoundedInputField(
                              hintText: mfnLng('Party'),
                              labelYn: 'Y',
                              txtRadius: 5,
                              txtController: txtPartyCode,
                              txtWidth: 0.2,
                              suffixIcon: Icons.search ,
                              suffixIconOnclick: () {
                                fnLookup('PARTY','');
                              },
                              onChanged: (value) {
                                fnLookup('PARTY','') ;
                              },


                            ),
                        ),
                        Container(
                          width: size.width*0.14,
                          child:   RoundedInputField(
                            hintText: ((lstrRoomYN=="Y"?mfnLng('Coupon No'):mfnLng("Ref No"))),
                            labelYn: 'Y',
                            txtRadius: 5,
                            txtController: txtRefCode,
                            txtWidth: 0.2,



                          ),
                        ),
                        lstrRoomYN=="Y"?
                        Container(
                            width: size.width*0.13,
                            child:   RoundedInputField(
                              hintText: (lstrRoomYN=="Y"?mfnLng('Room'):mfnLng("Ref No")),
                              labelYn: 'Y',
                              txtRadius: 5,
                              txtController: txtRoomCode,
                              txtWidth: 0.2,
                              enablests: (lstrRoomYN=="N"?false:true),
                              suffixIcon: Icons.search ,
                              suffixIconOnclick: () {
                              fnLookup('ROOM','');
                              },
                              onChanged: (value) {
                               fnLookup('ROOM','') ;
                              },



                            ),
                        ):gapHC(0),
                      ],
                    ):gapHC(0),
                    g.wstrRoomMode == "Y"?
                    Row(
                      children: [
                        Container(
                            width: size.width*0.2,
                            child:  tc('' +lstrPartyDescp, Colors.black, 16),
                        ),
                        Container(
                          width: size.width*0.05,
                        ),
                        Container(
                            width: size.width*0.2,
                            child: tc('' +lstrRoomDescp, Colors.black, 16),
                        )
                      ],
                    ):gapHC(0),



                    gapHC(10),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: boxBaseDecoration(greyLight, 10),
                      child: Center(
                        child:  tc('${mfnLng("TOTAL")}  ' + lstrLastTotal.toStringAsFixed(3),Colors.red,25),
                      ),
                    ),
                    gapHC(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: size.width*0.21,
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          decoration: boxBaseDecoration(Colors.green, 5),
                          child: Row(
                            children: [
                              tcn(mfnLng('Paid'),Colors.white,20),
                              gapWC(10),
                              Expanded(child:  tc(lstrLastPaidTotal.toStringAsFixed(2),Colors.white,20),)

                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          width: size.width*0.21,
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          decoration: boxBaseDecoration(Colors.red, 5),
                          child: Row(
                            children: [
                              tcn(mfnLng('Balance'),Colors.white,20),
                              gapWC(10),
                              Expanded(child: tc(  lstrLastChangeTo.toStringAsFixed(2),Colors.white,20),)

                            ],
                          ),
                        ),


                      ],
                    ),
                    gapHC(10),
                    Row(
                      children: [
                        Container(
                            width: size.width*0.14,
                            child: th(mfnLng('Mode'),Colors.black,15)
                        ),
                        Container(
                            width: size.width*0.16,
                            child: th(mfnLng('Amount'),Colors.black,15)
                        ),
                        Container(
                            width: size.width*0.15,
                            child: th(mfnLng('Card'),Colors.black,15)
                        )
                      ],
                    ),
                    gapHC(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          width: size.width*0.14,
                          decoration: boxBaseDecoration(blueLight, 5),
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
                                    fnSetCardAmount();
                                  }
                                  if(data.toString() == "CREDIT"){
                                    fnSetCreditAmount();
                                  }
                                });
                              },
                              items: lstrSelectedPayment.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            if(lstrSelectedPaymentMode=="CREDIT")
                              {
                                fnSetCreditAmount();
                              }
                            else{
                              fnEntryMOdePress('C');
                            }
                          },
                          child:  Container(
                            height: 40,
                            width: size.width*0.14,
                            decoration: boxBaseDecoration(lstrEntryMode == 'C'?redLight:blueLight, 5),
                            child: Center(
                              child: tc(lstrCashEntry.toString(),lstrEntryMode == 'C' ? PrimaryColor :Colors.black,20),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            fnEntryMOdePress('D');
                          },
                          child:  Container(
                            height: 40,
                            width: size.width*0.14,
                            decoration: boxBaseDecoration(lstrEntryMode == 'D'?redLight:blueLight, 5),
                            child: Center(
                                child:  tc(lstrCardEntry.toString(),lstrEntryMode == 'D' ? PrimaryColor :Colors.black,20)
                            ),
                          ),
                        )
                      ],
                    ),
                    gapHC(10),
                    Expanded(child: itemView(lstrPaymentList,size)),



                  ],
                ),
              ),
              Expanded(child:
              Container(

                  height: 520,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          amountPress('05',size),
                          amountPress('10',size),
                          amountPress('20',size),
                          amountPress('50',size),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          amountPress('100',size),
                          amountPress('200',size),
                          amountPress('500',size),
                          amountPress('1000',size),
                        ],
                      ),
                      gapHC(10),
                      Expanded(
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  numberPress('1',size),
                                  numberPress('2',size),
                                  numberPress('3',size),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  numberPress('4',size),
                                  numberPress('5',size),
                                  numberPress('6',size),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  numberPress('7',size),
                                  numberPress('8',size),
                                  numberPress('9',size),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  numberPress('.',size),
                                  numberPress('0',size),
                                  numberPress('x',size),

                                ],
                              ),
                            ],),
                          )
                      ),

                      Bounce(
                        child: Container(
                            margin: EdgeInsets.only(left: 20,right: 20),
                            height: 60,
                            decoration: boxDecoration(Colors.green, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.verified_sharp,color: Colors.white,),
                                gapWC(10),
                                tc(mfnLng('DONE'),Colors.white,25),
                              ],
                            )
                        ),
                        duration: Duration(
                            milliseconds: 110
                        ),
                        onPressed: (){
                          setState(() {
                            lstrDoneButton =lstrDoneButton+1;
                          });
                          fnCalcPayment();
                        },
                      )



                    ],
                  )
              ))
            ],
          )
        ],
      ),
    );
  }

  Widget itemView(snapshot,size){
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.length,
        itemBuilder: (context, index) {
          var amount = 0.00;
          var dataList = snapshot[index];
          var mode = dataList["MODE"];
          amount = dataList["AMOUNT"];
          var card = dataList["CARD_NO"];
          return GestureDetector(
            onTap: (){

            },
            child : Container(
              height: 40,
              margin: EdgeInsets.only(bottom: 5),
              decoration: boxBaseDecoration(greyLight, 0),
              child: Center(
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        width: size.width*0.05,
                        child: ts((index+1).toString(),Colors.black,15),
                      ),
                      Container(
                        width: size.width*0.1,
                        child: tc(mode.toString(),Colors.black,15),
                      ),
                      Container(
                        width:  size.width*0.1,
                        child:  tc(amount.toStringAsFixed(2),Colors.black,15),
                      ),
                      Container(
                        width:  size.width*0.1,
                        child: tc(card.toString(),Colors.black,15),
                      ),
                      GestureDetector(
                        onTap: (){
                          fnRemovePayment(dataList);
                        },
                        child: Container(
                          width: size.width*0.05,
                          child: Center(
                            child: Icon(Icons.cancel_outlined,color: Colors.black,size: 28,),
                          ),
                        ),
                      )

                    ],
                  )
              ),
            ),

          );
        });
  }
  GestureDetector numberPress(text,size) =>
      GestureDetector(

        onLongPress: (){
          fnLongPress(text);
        },
        child: Bounce(
          child: Container(
            height: 60,
            width: size.width*0.1,
            margin: EdgeInsets.all(4),
            decoration: boxDecoration(Colors.white, 10.0),
            child: Center(
              child: th(text,Colors.black,25),
            ),
          ),
          duration: Duration(milliseconds: 110),
          onPressed: (){
            if(lstrSelectedPaymentMode!="CREDIT"){
            fnOnPress(text);
            }
          },
        ),
      );
  GestureDetector amountPress(text,size) => GestureDetector(
    onTap: (){
      // fnOnPress(text);
      fnAmountPress(text,"ADD");
    },
    onLongPress: (){
      fnAmountPress(text,"MINUS");
      //fnLongPress(text);
    },
    child: Container(
      height: 50,
      width: size.width*0.07,
      margin: EdgeInsets.only(left: 5,right: 5,top: 5),
      decoration: boxDecoration(Colors.amber, 5),
      child: Center(
        child: tc(text,Colors.black,20),
      ),
    ),
  );
  fnAmountPress(amount,mode){
    var enterdAmount = double.parse(lstrCashEntry);
    var updateAmount = 0.0;
    if(lstrSelectedPaymentMode == "CASH"){
      if(mode == "ADD"){
        updateAmount =enterdAmount + int.parse(amount);
      }else{
        updateAmount =enterdAmount - int.parse(amount);
      }
      setState(() {

        if(updateAmount >= 0){
          lstrCashEntry = lstrCashEntry == '0.0' ? '' :lstrCashEntry;
          lstrCashEntry = updateAmount.toString();
        }

      });
      fnEntryCalc();
    }
  }

  fnOnPress(mode){

    if(mode == 'x'){

      if(lstrEntryMode == 'C'){
        setState(() {
          if(lstrCashEntry.isNotEmpty){
            lstrCashEntry =lstrCashEntry.substring(0, lstrCashEntry.length - 1);
            lstrCashEntry = lstrCashEntry.isEmpty ? '0.0': lstrCashEntry ;
          }
        });
      }else{
        setState(() {
          lstrCardEntry =lstrCardEntry.substring(0, lstrCardEntry.length - 1);
        });
      }
    }else if(mode == '.'){
      if(lstrEntryMode == 'C'){
        if(lstrClearSts){
          setState(() {
            lstrCashEntry = '';
          });
        }
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
          if(lstrClearSts){
            setState(() {
              lstrCashEntry = '';
            });
          }
          if(lstrCashEntry.length < 12){
            lstrCashEntry = lstrCashEntry == '0.0' ? '' :lstrCashEntry;
            lstrCashEntry =lstrCashEntry.toString() + mode.toString();
          }

        });
      }else{
        setState(() {
          if(lstrCardEntry.length <12){

            lstrCardEntry =lstrCardEntry.toString() + mode.toString();
          }

        });
      }
    }

    setState(() {
      lstrClearSts = false;
    });
    fnEntryCalc();
  }
  fnLongPress(mode){
    if(mode == 'x'){
      if(lstrEntryMode == 'C'){
        setState(() {
          lstrCashEntry = '0.0';
        });
      }else{
        setState(() {
          lstrCardEntry = '';
        });
      }
    }
    fnEntryCalc();
  }
  fnEntryMOdePress(mode){
    lstrClearSts =true;
    if(mode=='C'){
      if(lstrLastPaidTotal == 0){
        lstrCashEntry = lstrCashEntry.isEmpty || lstrCashEntry == '0.0' ? lstrLastTotal.toStringAsFixed(3) : lstrCashEntry  ;
      }else{
        fnSetCardAmount();
      }
    }
    setState(() {
      lstrEntryMode = mode;
      lstrCashEntry = lstrCashEntry.isEmpty ? '0.0': lstrCashEntry ;
      lstrCardEntry = lstrCardEntry.isEmpty ? '': lstrCardEntry ;
    });
    fnEntryCalc();
  }
  fnSetPageData(){

    if(g.fnValCheck(lstrSelectedData)){

      var dataList =  lstrSelectedData[0];
      setState(() {
        lstrSelectedDocno = dataList["DOCNO"];
        lstrSelectedType = dataList["TYPE"];
        lstrLastTotal = g.mfnDbl(dataList["TOTAL_AMT"].toStringAsFixed(3));
        lstrPartyCode = dataList["PARTYCODE"];
        lstrPartyDescp= dataList["PARTYNAME"];
        lstrRoomYN= dataList["ROOM_YN"];
        lstrRoomCode= dataList["ORDER_ROOM"];
        txtPartyCode.text=lstrPartyCode;
        txtRoomCode.text=lstrRoomCode;
        txtRefCode.text=dataList["ORDER_REF"];
      });
    }
    fnCalcPaidAmount();
    fnGetCard();

  }
  fnDone(){
    setState(() {
      lstrSelectedRetail.clear();
    });
    var srno = 0;
    if(g.fnValCheck(lstrPaymentList)) {
      for (var e in lstrPaymentList) {
        srno = srno +1;
        lstrSelectedRetail.add({
          "COMPANY":g.wstrCompany,
          "SRNO":srno,
          "PAYMODE":e["MODE"],
          "CURR":g.wstrCurrency,
          "CURRATE":g.wstrCurrencyRate,
          "AMT":e["AMOUNT"],
          "AMTFC":e["AMOUNT"],
          "CHANGE_AMT": e["MODE"] == "CASH"? lstrLastChangeTo :0,
          "CHANGE_AMTFC":e["MODE"] == "CASH"? lstrLastChangeTo * g.wstrCurrencyRate : 0,
          "PRINT_YN":"",
          "POST_YN":"",
          "POSTDATE":"",
          "POST_FLAG":"",
          "AUTH_YN":"",
          "CLOSED_YN":"",
          "CARD_NO":e["CARD_NO"],
        });
      }
    }


    lstrSelectedData [0]["CASH"] = lstrLastCashPaid;
    lstrSelectedData [0]["CARD"] = lstrLastCardPaid;
    lstrSelectedData [0]["PAID_AMT"] = lstrLastPaidTotal;
    lstrSelectedData [0]["CHANGE_TO"] = lstrLastChangeTo;
    lstrSelectedData [0]["PARTYCODE"] = txtPartyCode.text.toString();
    lstrSelectedData [0]["PARTYNAME"] = lstrPartyDescp;
    lstrSelectedData [0]["ADDRESS4"] = txtRoomCode.text.toString();
    lstrSelectedData [0]["COUPON"] = txtRefCode.text;
    lstrSelectedData [0]["ORDER_ROOM"] = txtRoomCode.text.toString();
    lstrSelectedData [0]["ORDER_REF"] = txtRefCode.text.toString();



    widget.fnCallBack(lstrSelectedData,lstrSelectedRetail,lstrPaymentList);
    Navigator.of(context).pop();
  }
  fnAddPayment(){

    if(lstrSelectedPaymentMode == "CASH"){
      if(!fnCheckCode()){
        setState(() {
          lstrPaymentList.add({
            "MODE":lstrSelectedPaymentMode,
            "AMOUNT":double.parse(lstrCashEntry),
            "CARD_NO" : lstrCardEntry.toString()
          });
        });
      }
    }else{
      setState(() {
        lstrPaymentList.add({
          "MODE":lstrSelectedPaymentMode,
          "AMOUNT":double.parse(lstrCashEntry),
          "CARD_NO" : lstrCardEntry.toString()
        });
      });
    }

    setState(() {
      lstrCashEntry = '0.0';
      if(lstrSelectedPaymentMode!="CREDIT"){
        lstrSelectedPaymentMode = "CASH";
      }

      lstrCardEntry = "";
    });

    fnCalcPaidAmount();

  }
  fnCheckCode(){
    var sts = false;
    if(g.fnValCheck(lstrPaymentList)){
      for (var e in lstrPaymentList) {
        var lcode = e["MODE"].toString();
        if( lcode == 'CASH' ){
          setState(() {
            e["AMOUNT"] = e["AMOUNT"]+ double.parse(lstrCashEntry);
            sts = true;
          });
          break;
        }
      }
    }
    return sts;
  }
  fnRemovePayment(data){
    setState(() {
      lstrPaymentList.remove(data);
    });
    fnCalcPaidAmount();
  }
  fnCalcPayment(){
    setState(() {
      lstrCashPaidAmount = 0.00;
      lstrCardPaidAmount = 0.00;
      lstrPaidAmount = 0.00;
    });


    var enterdAmount = double.parse(lstrCashEntry);

    var amount = 0.00;
    if(g.fnValCheck(lstrPaymentList)){
      for (var e in lstrPaymentList) {
        var lcode = e["MODE"].toString();
        if(lcode == "CASH"){
          setState(() {
            lstrCashPaidAmount = e["AMOUNT"] + lstrCashPaidAmount;
          });
        }else{
          setState(() {
            lstrCardPaidAmount = e["AMOUNT"] + lstrCardPaidAmount;
          });
        }
        setState(() {
          amount = e["AMOUNT"] + amount;
        });
      }
    }
    setState(() {
      lstrPaidAmount =amount;
    });
    if(lstrSelectedPaymentMode != "CASH"){
      if(lstrCashPaidAmount < lstrLastTotal ){
        var balance =  lstrLastTotal - lstrCashPaidAmount;
        if(balance < enterdAmount){
          showToast( 'Please enter correct amount');
          setState(() {
            lstrCashEntry = '0.0';
          });
          return;
        }else{
          fnAddPayment();
        }
      }else{
        showToast( 'Please enter correct amount');
        setState(() {
          lstrCashEntry = '0.0';
        });
        return;
      }
    }else{
      fnAddPayment();
    }

  }
  fnEntryCalc(){
    var enterdAmount = double.parse(lstrCashEntry);
    var enterdMode = lstrSelectedPaymentMode;
    var lCashAmt = 0.0;
    var lcardAmt = 0.0;
    if(enterdMode == "CASH"){
      lCashAmt = enterdAmount;
    }else{
      lcardAmt = enterdAmount;
    }


    setState(() {
      lstrLastCardPaid = 0.00;
      lstrLastCashPaid = 0.00;
      lstrLastPaidTotal = 0.00;
      lstrLastChangeTo = 0.00;
    });
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
      lstrLastCashPaid = lstrLastCashPaid + lCashAmt;
      lstrLastCardPaid = lstrLastCardPaid + lcardAmt;
      var balnc =  lstrLastTotal - (amount +enterdAmount );
      lstrLastChangeTo = balnc;
      lstrLastPaidTotal = (amount +enterdAmount );
    });
  }
  fnSetCardAmount(){
    setState(() {
      lstrCashPaidAmount = 0.00;
      lstrCardPaidAmount = 0.00;
      lstrPaidAmount = 0.00;
    });
    var amount = 0.00;
    if(g.fnValCheck(lstrPaymentList)){
      for (var e in lstrPaymentList) {
        var lcode = e["MODE"].toString();
        if(lcode == "CASH"){
          setState(() {
            lstrCashPaidAmount = e["AMOUNT"] + lstrCashPaidAmount;
          });
        }else{
          setState(() {
            lstrCardPaidAmount = e["AMOUNT"] + lstrCardPaidAmount;
          });
        }
        setState(() {
          amount = e["AMOUNT"] + amount;
        });
      }
    }

    if(amount < lstrLastTotal){
      var bal = lstrLastTotal -amount;
      setState(() {
        lstrCashEntry = bal.toStringAsFixed(3);
      });
    }

  }
  fnSetCreditAmount(){
    setState(() {
      lstrCashPaidAmount = 0.00;
      lstrCardPaidAmount = 0.00;
      lstrPaidAmount = 0.00;
    });
    var amount = 0.00;



      var bal = 0;
      setState(() {
        lstrPaymentList=[];
        lstrCashEntry = bal.toStringAsFixed(3);
      });


  }
  fnCalcPaidAmount(){
    setState(() {
      lstrLastCardPaid = 0.00;
      lstrLastCashPaid = 0.00;
      lstrLastPaidTotal = 0.00;
      lstrLastChangeTo = 0.00;
    });
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
      lstrLastChangeTo = balnc;
      lstrLastPaidTotal = amount;
    });
if(txtPartyCode.text.isNotEmpty && lstrPaymentList.length==1 && lstrPaymentList[0]["MODE"] == 'CREDIT')
{
  fnDone();

}
    if(lstrPaymentList.length==1 && txtPartyCode.text.isEmpty && lstrPaymentList[0]["MODE"] == 'CREDIT')
    {
      showToast( 'Please Select Party');
      if(lstrPaymentList.length>1){
        setState(() {
          lstrPaymentList=[];
        });
      }

    }

    if(lstrLastPaidTotal >= lstrLastTotal && lstrDoneButton > 0){
      fnDone();
    }

  }

  //api

  fnGetCard() async{
    futureCard =  apiCall.getCardType(g.wstrCompany);
    futureCard.then((
        value) => fnGetCardSuccess(value));
  }
  fnGetCardSuccess(value){

    if(g.fnValCheck(value)){
      for(var e in value){
        setState(() {
          if(!lstrSelectedPayment.contains(e["CODE"])){
            lstrSelectedPayment.add(e["CODE"]);
          }

        });
      }
    }else{
      setState(() {
        lstrSelectedPayment.add("CARD");
      });
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
    if (mode == 'PARTY') {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'SLCODE', 'Display': 'Code'},
        {'Column': 'SLDESCP', 'Display': 'Descp'}
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {'sourceColumn': 'SLCODE','contextField': txtPartyCode,'context': 'window'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtPartyCode,
        oldValue: txtPartyCode.text,
        lstrTable: 'VIEW_SLMAST_AR',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100000',
        lstrFilter: [],
        keyColumn: 'SLCODE',
        layoutName: "B",
        mode: lookupMode,
        callback: fnLookupPartyCallBack,
      ), 'PARTY ');
    }
  }

  fnLookupPartyCallBack(data){
    setState(() {
      lstrPartyDescp=data["SLDESCP"];
    });
  }

  fnLookupRoomCallBack(data){
//lstrRoomCode=data[0]["CODE"]??"";
//lstrRoomDescp=data[0]["DESCP"]??"";
  }
}
