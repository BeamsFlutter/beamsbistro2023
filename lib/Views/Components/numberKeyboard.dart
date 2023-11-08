
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:oktoast/oktoast.dart';

class NumberKeyboard extends StatefulWidget {

  final String oldValue;
  final Function  fnCallBack;

  const NumberKeyboard({Key? key, required this.oldValue, required this.fnCallBack, }) : super(key: key);

  @override
  _NumberKeyboardState createState() => _NumberKeyboardState();
}

class _NumberKeyboardState extends State<NumberKeyboard> {


  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic> futureCard;

  var lstrSelectedData = [];
  var lstrSelectedRetail = [];

  var lstrSelectedDocno = '' ;
  var lstrSelectedType = '' ;

  var lstrCashEntry ='0.0';
  var lstrCardEntry = '';
  var lstrEntryMode = 'C';

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


  String lstrSelectedPaymentMode = 'CASH';

  List <String> lstrSelectedPayment = [
    'CASH',
  ] ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fnSetPageData();


  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height*0.72,
        width: size.width*0.76,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 45,
                padding: EdgeInsets.all(10),
                decoration: boxDecoration(Colors.white, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    tc('Order # ' +lstrSelectedDocno, Colors.black, 16),
                    tc(lstrSelectedType, PrimaryColor, 15),
                    Row(
                      children: [
                        gapWC(5),
                        tc(lstrLastTotal.toStringAsFixed(3), Colors.black, 15),
                      ],
                    )
                  ],
                ),
              ),
              gapH(),
              Row(
                children: [
                  Container(
                    height: size.height*0.62,
                    width: size.width*0.45,
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: boxBaseDecoration(greyLight, 10),
                          child: Center(
                            child:  tc('AED  ' + lstrLastTotal.toStringAsFixed(3),Colors.red,40),
                          ),
                        ),
                        gapHC(10),
                        Row(
                          children: [
                            Container(
                              width: size.width*0.15,
                              child: tc('Mode',Colors.black,15)
                            ),
                            Container(
                              width: size.width*0.13,
                              child: tc('Amount',Colors.black,15)
                            ),
                            Container(
                              width: size.width*0.12,
                              child: tc('Card ',Colors.black,15)
                            )
                          ],
                        ),
                        gapHC(5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 50,
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
                              fnEntryMOdePress('C');
                            },
                            child:  Container(
                              height: 50,
                              width: size.width*0.13,
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
                               height: 50,
                               width: size.width*0.13,
                               decoration: boxBaseDecoration(lstrEntryMode == 'D'?redLight:blueLight, 5),
                               child: Center(
                                   child:  tc(lstrCardEntry.toString(),lstrEntryMode == 'D' ? PrimaryColor :Colors.black,20)
                               ),
                             ),
                           )


                          ],
                        ),
                        gapHC(10),
                        Container(
                          height: size.height*0.3,
                          child: itemView(lstrPaymentList,size),
                        )


                      ],
                    ),
                  ),
                  Container(
                    height: size.height*0.62,
                    width: size.width*0.3,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              numberPress('1'),
                              numberPress('2'),
                              numberPress('3'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              numberPress('4'),
                              numberPress('5'),
                              numberPress('6'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              numberPress('7'),
                              numberPress('8'),
                              numberPress('9'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              numberPress('.'),
                              numberPress('0'),
                              numberPress('x'),

                            ],
                          ),
                          gapHC(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  fnCalcPayment();
                                },
                                child: Container(
                                  height: 50,
                                  width: size.width*0.09,
                                  decoration: boxDecoration(greyLight, 5),
                                  child: Center(
                                    child: Icon(Icons.add_circle_outline,color: Colors.black,size: 30,),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  fnDone();
                                },
                                child: Container(
                                  height: 50,
                                  width: size.width*0.19,
                                  decoration: boxDecoration(Colors.green, 10),
                                  child: Center(
                                    child: tc('DONE',Colors.white,20),
                                  ),
                                ),
                              )
                            ],
                          )



                        ],
                      ),

                    ),
                  )
                ],
              )
            ],
          ),
        )
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
              width: size.width*0.4,
              margin: EdgeInsets.only(bottom: 5),
              decoration: boxBaseDecoration(greyLight, 0),
              child: Center(
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 5),
                        width: size.width*0.02,
                        child: h3((index+1).toString()),
                      ),
                      Container(
                        width: size.width*0.13,
                        child: h3(mode),
                      ),
                      Container(
                        width: size.width*0.1,
                        child: h3(amount.toStringAsFixed(3)),
                      ),
                      Container(
                        width: size.width*0.1,
                        child:  h3(card.toString()),
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

  GestureDetector numberPress(text) => GestureDetector(
    onTap: (){
      fnOnPress(text);
    },
    child: Container(
      height: 75,
      width: 100,
      margin: EdgeInsets.only(bottom: 10),
      decoration: boxDecoration(Colors.white, 10),
      child: Center(
        child: tc(text,titleSubText,30),
      ),
    ),
  );
  fnOnPress(mode){

    if(mode == 'x'){

      if(lstrEntryMode == 'C'){
        setState(() {
            lstrCashEntry = lstrCashEntry == '0.0' ? '' :lstrCashEntry;
            lstrCashEntry =lstrCashEntry.substring(0, lstrCashEntry.length - 1);
            lstrCashEntry = lstrCashEntry.isEmpty ? '0.0': lstrCashEntry ;
        });
      }else{
        setState(() {
            lstrCardEntry =lstrCardEntry.substring(0, lstrCardEntry.length - 1);
        });
      }
    }else if(mode == '.'){
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

        var enterAmount = double.parse(lstrCashEntry);
        if(lstrSelectedPaymentMode!="CASH"){

        }

        setState(() {
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


  }
  fnEntryMOdePress(mode){
    if(mode=='C'){
      if(lstrLastPaidTotal == 0){
        lstrCashEntry = lstrCashEntry.isEmpty || lstrCashEntry == '0.0' ? lstrLastTotal.toStringAsFixed(3) : lstrCashEntry  ;
      }
    }
    setState(() {
      lstrEntryMode = mode;
      lstrCashEntry = lstrCashEntry.isEmpty ? '0.0': lstrCashEntry ;
      lstrCardEntry = lstrCardEntry.isEmpty ? '': lstrCardEntry ;
    });
  }
  fnSetPageData(){

    if(g.fnValCheck(lstrSelectedData)){

      var dataList =  lstrSelectedData[0];
      setState(() {
        lstrSelectedDocno = dataList["DOCNO"];
        lstrSelectedType = dataList["TYPE"];
        lstrLastTotal = dataList["TOTAL_AMT"];
      });
    }
    fnCalcPaidAmount();
   fnGetCard();

  }
  fnDone(){
    fnCalcPaidAmount();
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
          "CHANGE_AMTFC":e["MODE"] == "CASH"? lstrLastChangeTo * g.wstrCurrencyRate:0,
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
      lstrSelectedPaymentMode = "CASH";
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
    if(enterdAmount <= 0 ){
      return;
    }
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
          lstrSelectedPayment.add(e["CODE"]);
        });
      }
    }
    

  }
}
