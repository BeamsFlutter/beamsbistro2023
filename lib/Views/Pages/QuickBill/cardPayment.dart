
import 'dart:async';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

class CardPaymentStatus extends StatefulWidget {

  final data;
  final Function fnCallBack;
  const CardPaymentStatus({Key? key, this.data, required this.fnCallBack}) : super(key: key);

  @override
  State<CardPaymentStatus> createState() => _CardPaymentStatusState();
}

class _CardPaymentStatusState extends State<CardPaymentStatus> {


  //Global
  var g =  Global();
  var apiCall  = ApiCall();
  late Future<dynamic> futureFrom;

  var docno  = "";
  var doctype  = "";
  var amount  = 0.0;
  var createDate  = DateTime.now();
  var expDate   = DateTime.now();

  late Timer timer;
  late Timer timerTime;
  var time = "00:00";


  @override
  void initState() {
    // TODO: implement initState
    fnGetPageData();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    timerTime.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child:
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset("assets/gifs/nfc.gif",width: 120,),
          tc(fnGetTime(createDate).toString() , Colors.red, 25),
          tcn("Waiting for payment,It will be Expire after 2 minutes" , Colors.black, 8),
          Divider(),
          tcn("TRN NO: "+docno.toString()  , Colors.black, 10),
          tcn("DEVICE :" + g.wstrTapDeviceId.toString() + " | " + g.wstrTapDeviceName.toString() , Colors.black, 10),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Icon(Icons.calendar_month,color: Colors.black,size: 12,),
               gapWC(5),
               tcn(setDate(7, createDate)  , Colors.black, 10),
             ],
           ),
          Divider(),
          tc(amount.toString(), Colors.black, 30),
          gapHC(10),
          Bounce(
            onPressed: (){
              apiCancelPayment();
            },
            duration: Duration(milliseconds: 110),
            child: Container(
              decoration: boxDecoration(Colors.blue, 30),
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 60),
              child: Column(
                children: [
                  tcn('CLOSE', Colors.white, 10)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //====================================WIDGET
  //====================================PAGEFN
    fnGetPageData(){
      if(mounted){
        setState(() {
          if(widget.data != null){
            docno  = widget.data["DOCNO"];
            doctype  = widget.data["DOCTYPE"];
            amount  = g.mfnDbl(widget.data["AMOUNT"]);
            createDate  = widget.data["DOCDATE"] == null || widget.data["DOCDATE"] == "" ?DateTime.now():DateTime.parse(widget.data["DOCDATE"].toString());
            expDate  = widget.data["EXP_DATE"] == null || widget.data["EXP_DATE"] == ""?DateTime.now():DateTime.parse(widget.data["EXP_DATE"].toString());
          }else{
            Get.back();
          }
        });
        timer = Timer.periodic(Duration(seconds: 3), (Timer t) => fnRefresh());
        timerTime = Timer.periodic(Duration(seconds: 1), (Timer t) => fnTime());
      }
    }
    fnRefresh(){
      if(mounted){
        apiCheckPayment();
      }
    }
    fnGetTime(time) {
      var billTime = time;
      var now = DateTime.now();
      var diffrence = now.difference(billTime).inSeconds;
      // var minutes = diffrence / 60;
      double minutes = (diffrence / 60);
      double minutesStr = ((minutes % 1) * 60);
      String mmss =
          minutes.toInt().toString() + ':' + minutesStr.toInt().toString();
      return mmss;
    }
    fnTime(){
      if(mounted){
        setState(() {

        });
      }
    }
  //====================================API CALL

  apiCheckPayment(){
    if(mounted){
      futureFrom =  apiCall.apiCheckPayment(docno, doctype);
      futureFrom.then((value) => apiCheckPaymentRes(value));
    }
  }
  apiCheckPaymentRes(value){
    if(mounted){
      //[{STATUS: 0, MSG: PAYMENT NOT DONE, CODE: 00000018, DOCTYPE: PTXN}]
      print(value);

      if(g.fnValCheck(value)){
        var sts  = value[0]["STATUS"]??"";
        var msg  = value[0]["MSG"]??"";
        if(sts.toString() == "1"){
          var docno  = value[0]["CODE"]??"";
          var doctype  = value[0]["DOCTYPE"]??"";
          var trnDocno  = value[0]["TRN_DOCNO"]??"";
          var trnDoctype  = value[0]["TRN_DOCTYPE"]??"";
          var cardNo  = value[0]["TRN_CARDNO"]??"";

          var retail = [];
          retail.add({
            "COMPANY":g.wstrCompany,
            "SRNO":1,
            "PAYMODE":"PREPAID",
            "CURR":g.wstrCurrency,
            "CURRATE":g.wstrCurrencyRate,
            "AMT":amount,
            "AMTFC":amount,
            "CHANGE_AMT": 0,
            "CHANGE_AMTFC":0,
            "PRINT_YN":"",
            "POST_YN":"",
            "POSTDATE":"",
            "POST_FLAG":"",
            "AUTH_YN":"",
            "CLOSED_YN":"",
            "CARD_NO":cardNo,
          });
          Navigator.pop(context);
          widget.fnCallBack(trnDocno,trnDoctype,cardNo,retail);
        }
        else{
          var now  = DateTime.now();
          if(expDate.isBefore(now)){
            apiCancelPayment();

          }
        }
      }
    }
  }


  apiCancelPayment(){
    futureFrom  = apiCall.apiCancelPayment(docno, doctype);
    futureFrom.then((value) => apiCancelPaymentRes(value));
  }
  apiCancelPaymentRes(value){
    print(value);
    if(mounted){
      var sts  = value[0]["STATUS"]??"";
      var msg  = value[0]["MSG"]??"";
      if(sts.toString() == "1"){
        Navigator.pop(context);
      }else{
        showToast(msg);
      }

    }
  }

}
