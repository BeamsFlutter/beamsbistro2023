

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:oktoast/oktoast.dart';

class Discount extends StatefulWidget {

  final double  oldValue;
  final List<dynamic>  lstrDataList;
  final Function  fnCallBack;

  const Discount({Key? key,  required this.fnCallBack, required this.oldValue, required this.lstrDataList}) : super(key: key);

  @override
  _DiscountState createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {


  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic> futureDiscount ;

  var lstrSelectedData = [];

  var lstrOldValue =0.00;
  var lstrCashEntry ='0.0';
  var lstrPercEntry ='0';
  var lstrCardEntry = '';
  var lstrPinEntry = '';
  var lstrEntryMode = 'C';

  var lstrSelectedDocno = '';
  var lstrSelectedType = '';
  var lstrLastTotal = 0.00;
  var maxDiscPerc  =  0.0;

  //Authorised Passcode
  bool p1 =false;
  bool p2 =false;
  bool p3 =false;
  bool p4 =false;
  var  passCode  ='';
  bool AuthSts  = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
          Container(
            height: 45,
            padding: EdgeInsets.all(10),
            decoration: boxDecoration(Colors.white, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                tc('${mfnLng("Order #")} ' +lstrSelectedDocno, Colors.black, 16),
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
                height: 450,
                width: size.width*0.5,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: boxBaseDecoration(greyLight, 5),
                      child: Center(
                        child:  tc('${mfnLng("BILL AMOUNT")}   '+ lstrLastTotal.toStringAsFixed(3),Colors.red,25),
                      ),
                    ),
                    gapHC(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ts(mfnLng('Discount Amount'),Colors.black,15),
                            gapHC(5),
                            GestureDetector(
                              onTap: (){
                                fnEntryMOdePress('C');
                              },
                              child:  Container(
                                height: 45,
                                width: size.width*0.2,
                                decoration: boxBaseDecoration(lstrEntryMode == 'C'?redLight:blueLight, 5),
                                child: Center(
                                  child: tc(lstrCashEntry.toString(),lstrEntryMode == 'C' ? PrimaryColor :Colors.black,20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ts(mfnLng('Discount %'),Colors.black,15),
                            gapHC(5),
                            GestureDetector(
                              onTap: (){
                                fnEntryMOdePress('P');
                              },
                              child:  Container(
                                height: 45,
                                width: size.width*0.2,
                                decoration: boxBaseDecoration(lstrEntryMode == 'P'?redLight:blueLight, 5),
                                child: Center(
                                  child: tc(lstrPercEntry.toString(),lstrEntryMode == 'P' ? PrimaryColor :Colors.black,20),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    gapHC(10),
                    AuthSts ?SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ts(mfnLng('Authorized user passcode.'),Colors.black,15),
                          gapHC(5),
                          GestureDetector(
                            onTap: (){
                              fnEntryMOdePress('A');
                            },
                            child:  Container(
                              height: 60,
                              decoration: boxBaseDecoration(lstrEntryMode == 'A'?redLight:blueLight, 5),
                              child: Center(
                                child: tc((p1?" * ":"")+(p2?" * ":"")+(p3?" * ":"")+(p4?" * ":""),lstrEntryMode == 'A' ? PrimaryColor :Colors.black,20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ):Container(),
                  ],
                ),
              ),
              Expanded(child:
              Container(
                height: 450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    Expanded(child: SingleChildScrollView(
                      child: Column(
                        children: [
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
                        ],
                      ),
                    )),
                    gapHC(10),
                    Bounce(
                        child: Container(
                          height: 60,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: boxDecoration(Colors.green, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.verified_sharp,color: Colors.white,size: 20,),
                              gapWC(10),
                              tc(mfnLng('DONE'),Colors.white,20)
                            ],
                          ),
                        ),
                        duration: Duration(milliseconds: 110),
                        onPressed: (){
                          fnCheckDiscount();
                        })



                  ],
                ),

              ))
            ],
          )
        ],
      ),
    );
  }


  //===============WIDGET UI ================================

  GestureDetector numberPress(text,size) => GestureDetector(
    onLongPress: (){
      fnLongPress(text);
    },
    child: Bounce(
      child: Container(
        height: 70,
        width: size.width*0.1,
        margin: EdgeInsets.all(5),
        decoration: boxDecoration(Colors.white, 10),
        child: Center(
          child: tc(text,titleSubText,30),
        ),
      ),
      duration: Duration(milliseconds: 110),
      onPressed: (){
        fnOnPress(text);
      },
    ),
  );

  //================PAGE FUNCTIONS================================

  fnCheckDiscount(){
    var perc  =  g.mfnDbl(lstrPercEntry);

    if(perc >  maxDiscPerc && maxDiscPerc != 0){
      fnDiscountAuth();
      return false;
    }else{
      fnDone();
    }
  }

  fnDone(){

    var amount = double.parse(lstrCashEntry);
    if(amount > lstrLastTotal){
      setState(() {
        lstrCashEntry = "0";
      });
      return;
    }else{
      widget.fnCallBack(amount);
      Navigator.pop(context);
    }

  }

  //=================OTHER FUNCTIONS ==========================

  fnOnPress(mode){

    if(mode == 'x'){
      setState(() {
        if(lstrEntryMode == "C"){
          lstrCashEntry = lstrCashEntry == '0.0' ? '' :lstrCashEntry;
          lstrCashEntry = lstrCashEntry == ''? '' : lstrCashEntry.substring(0, lstrCashEntry.length - 1);
          lstrCashEntry = lstrCashEntry.isEmpty ? '0.0': lstrCashEntry ;
        }else if(lstrEntryMode == "P"){
          lstrPercEntry = lstrPercEntry == ''? '' : lstrPercEntry.substring(0, lstrPercEntry.length - 1);
        }else if(lstrEntryMode == "A"){
          if(p4){
            p4 = false;
          }else if(p3){
            p3 = false;
          }else if(p2){
            p2 = false;
          }else if(p1){
            p1 = false;
          }else{
            passCode = '';
          }
          if(passCode.isNotEmpty){
            passCode = passCode.substring(0, passCode.length - 1);
          }
          passCode =passCode;
        }

      });



    }else if(mode == '.'){
      if(lstrEntryMode == 'C'){
        if(!lstrCashEntry.contains('.',0)){
          setState(() {
            lstrCashEntry = lstrCashEntry == '0.0' ? '' :lstrCashEntry;
            lstrCashEntry =lstrCashEntry.toString() + mode.toString();
          });
        }
      }else if(lstrEntryMode == "P"){
        if(!lstrPercEntry.contains('.',0)){
          setState(() {
            lstrPercEntry = lstrPercEntry == '0' ? '' :lstrPercEntry;
            lstrPercEntry =lstrPercEntry.toString() + mode.toString();
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
          var value = g.mfnDbl(lstrCashEntry);
          if(value > lstrLastTotal){
            lstrCashEntry = lstrCashEntry == ''? '' : lstrCashEntry.substring(0, lstrCashEntry.length - 1);
          }

        });
      }else if(lstrEntryMode == "P"){
        setState(() {
          if(lstrPercEntry.length < 6){
            lstrPercEntry = lstrPercEntry == '0.0' ? '' :lstrPercEntry;
            lstrPercEntry =lstrPercEntry.toString() + mode.toString();
          }
          var value = g.mfnDbl(lstrPercEntry);
          if(value > 100){
            lstrPercEntry = lstrPercEntry == ''? '' : lstrPercEntry.substring(0, lstrPercEntry.length - 1);
          }

        });
      }else if(lstrEntryMode =="A"){
        if(p4){
          //fnLogin();
        }else if(p3){
          p4 = true;
          passCode = passCode+mode;
          //fnLogin();
        }else if(p2){
          p3 = true;
          passCode = passCode+mode;
        }else if(p1){
          p2 = true;
          passCode = passCode+mode;
        }else{
          p1 = true;
          passCode = passCode+mode;
        }

        setState(() {
          passCode =passCode;
        });
      }
    }

    fnDiscountCalc();

  }
  fnEntryMOdePress(mode){
    setState(() {
      lstrEntryMode = mode;
      lstrCashEntry = lstrCashEntry.isEmpty ? '0.0': lstrCashEntry ;
    });
  }
  fnSetPageData(){

    setState(() {
      lstrSelectedData= widget.lstrDataList;
      lstrOldValue = widget.oldValue;
      lstrCashEntry = lstrOldValue.toString();
      maxDiscPerc =  g.wstrDiscountMaxPerc;
    });

    if(g.fnValCheck(lstrSelectedData)){

      var dataList =  lstrSelectedData[0];
      setState(() {
        lstrSelectedDocno = dataList["DOCNO"];
        lstrSelectedType = dataList["TYPE"];
        lstrLastTotal = dataList["TOTAL_AMT"];
      });
    }

    fnDiscountCalc();

  }
  fnDiscountCalc(){
    var cash =  g.mfnDbl(lstrCashEntry);
    var perc =  g.mfnDbl(lstrPercEntry);
   setState(() {
     if(lstrEntryMode == "C"){
       var percent = 0.0;
       percent = (cash/lstrLastTotal)*100;
       lstrPercEntry = percent.toStringAsFixed(2);
     }else if(lstrEntryMode == "P"){
       var amount =  0.0;
       amount = (lstrLastTotal/100)*perc;
       lstrCashEntry =  amount.toStringAsFixed(3);
     }
   });

   var discPerc = g.mfnDbl(lstrPercEntry);
   if(discPerc > maxDiscPerc && maxDiscPerc != 0){
     setState(() {
       AuthSts = true;
     });
   }else{
     setState(() {
       AuthSts = false;
     });
   }
   if(lstrEntryMode != "A"){
     fnPassCodeClear();
   }

  }
  fnPassCodeClear(){
    setState(() {
      p4 = false;
      p3 = false;
      p2 = false;
      p1 = false;
      passCode = "";
    });
  }
  fnLongPress(mode){
    if(mode == 'x'){
      if(lstrEntryMode == 'C'){
        setState(() {
          lstrCashEntry = '0.0';
        });
      }else{
        setState(() {
          lstrPercEntry = '';
        });
      }
    }
    fnDiscountCalc();
  }

  //====================API CALL ===============================


  fnDiscountAuth(){
    if(passCode == ""){
      showToast( mfnLng('Please enter passcode'));
      return false;
    }
    futureDiscount =  apiCall.geDiscountAuth(g.wstrDiscountGroup, passCode);
    futureDiscount.then((value) => fnDiscountAuthSuccess(value));
  }
  fnDiscountAuthSuccess(value){
    if(g.fnValCheck(value)){
      var sts  = value[0]["STATUS"].toString();
      var msg  = value[0]["MSG"].toString();
      if(sts == "1"){
        fnDone();
      }else{
        showToast( mfnLng('Please check your passcode'));
      }
    }
  }


}
