

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';

class OpeningCash extends StatefulWidget {


  final Function  fnCallBack;

  const OpeningCash({Key? key,  required this.fnCallBack}) : super(key: key);

  @override
  _OpeningCashState createState() => _OpeningCashState();
}

class _OpeningCashState extends State<OpeningCash> {


  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic> futureOpening;
  late Future<dynamic> futureOpeningGet;


  var lstrOpeningCash  = 0.00;
  var lstrOpenCashEntry  = 0.00;
  var lstrAddAmount  = 0.00;
  var lstrDeductAmount  = 0.00;


  var lstrAddOrDeduct  = 'A';
  var lstrShifno  = '';
  var lstrShifDescp  = '';
  var lstrShifDate  = '';
  var formatDate1 = new DateFormat('dd MMMM yyyy');

  var lstrCashEntry ='0.0';
  var lstrCardEntry = '';
  var lstrEntryMode = 'C';
  var _radioValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnSetPageData();


  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  SingleChildScrollView(
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
                tc(mfnLng('Shift')  +lstrShifDescp, Colors.black, 16),
                tc(g.wstrUserName.toString(), PrimaryColor, 15),
                Row(
                  children: [
                    gapWC(5),
                    tc(lstrShifDate.toString(), Colors.black, 15),
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
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: boxBaseDecoration(greyLight, 10),
                      child: Center(
                        child:  tc('AED  ' + lstrOpeningCash.toStringAsFixed(3),Colors.red,30),
                      ),
                    ),
                    gapHC(10),

                    gapHC(5),
                    GestureDetector(
                      onTap: (){
                        fnEntryMOdePress('C');
                      },
                      child:  Container(
                        height: 50,
                        decoration: boxBaseDecoration(lstrEntryMode == 'C'?redLight:blueLight, 5),
                        child: Center(
                          child: tc(lstrCashEntry.toString(),lstrEntryMode == 'C' ? PrimaryColor :Colors.black,20),
                        ),
                      ),
                    ),
                    gapHC(10),
                    Row(
                      children: [
                        Radio(
                          value: 0,
                          groupValue: _radioValue,
                          onChanged: (value){
                            setState(() {
                              _radioValue = 0;
                              lstrAddOrDeduct = 'A';
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              _radioValue = 0;
                              lstrAddOrDeduct ='A';

                            });
                          },
                          child: tc(mfnLng('Add'),Colors.black,20),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          value: 1,
                          groupValue: _radioValue,
                          onChanged: (value){
                            setState(() {
                              _radioValue = 1;
                              lstrAddOrDeduct ='D';
                            });
                          },
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              _radioValue = 1;
                              lstrAddOrDeduct ='D';
                            });
                          },
                          child: tc(mfnLng('Deduct'),Colors.black,20),
                        )
                      ],
                    ),


                  ],
                ),
              ),
              Expanded(child:
              Container(
                height: 450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: SingleChildScrollView(
                      child: Column(
                        children: [
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
                        ],
                      ),
                    )),
                    gapHC(10),
                    Bounce(
                        child: Container(
                          height: 50,
                          decoration: boxDecoration(Colors.green, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.verified,color: Colors.white,),
                              gapWC(5),
                              tc(mfnLng('DONE'),Colors.white,20),
                            ],
                          )
                        ),
                        duration: Duration(milliseconds: 110),
                        onPressed: (){
                          fnDone();
                        })
                  ],
                ),

              ),)
            ],
          )
        ],
      ),
    );
  }
  GestureDetector numberPress(text,size) => GestureDetector(
    onTap: (){
      fnOnPress(text);
    },
    child: Container(
      height: 70,
      width: size.width*0.12,
      margin: EdgeInsets.only(bottom: 5),
      decoration: boxDecoration(Colors.white, 10),
      child: Center(
        child: tc(text,titleSubText,30),
      ),
    )
  );
  fnOnPress(mode){

    if(mode == 'x'){
      setState(() {
        lstrCashEntry = lstrCashEntry == '0.0' ? '' :lstrCashEntry;
        lstrCashEntry = lstrCashEntry == ''? '' : lstrCashEntry.substring(0, lstrCashEntry.length - 1);
        lstrCashEntry = lstrCashEntry.isEmpty ? '0.0': lstrCashEntry ;
      });
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
        setState(() {
          if(lstrCashEntry.length < 12){
            lstrCashEntry = lstrCashEntry == '0.0' ? '' :lstrCashEntry;
            lstrCashEntry =lstrCashEntry.toString() + mode.toString();
          }

        });
      }
    }


  }
  fnEntryMOdePress(mode){
    setState(() {
      lstrEntryMode = mode;
      lstrCashEntry = lstrCashEntry.isEmpty ? '0.0': lstrCashEntry ;
    });
  }
  fnSetPageData(){

    setState(() {
      lstrShifDate =formatDate1.format(DateTime.parse(g.wstrClockInDate.toString()));
      lstrShifno = g.wstrShifNo;
      lstrShifDescp = g.wstrShifDescp;
    });

    fnGetopening();

  }
  fnDone(){


    var amount = double.parse(lstrCashEntry.toString());
    if(amount > 0){
      lstrOpenCashEntry = amount;
      fnSaveopening();
    }else{
      showToast(mfnLng('Please enter amount'));
    }


  }

  //api

  fnGetopening() async{
    futureOpeningGet =  apiCall.getOpenCash(g.wstrCompany,g.wstrYearcode,g.wstrUserCd,g.wstrDeivceId);
    futureOpeningGet.then((
        value) => fnGetopeningSuccess(value));
  }
  fnGetopeningSuccess(value){
        setState(() {
          lstrAddAmount = 0.0;
          lstrDeductAmount = 0.0;
          lstrOpeningCash = 0.0;
        });
    if(g.fnValCheck(value)){
      for(var e in value){
        var mode = e["ADD_DEDUCT"].toString();
        var amount = e["OPEN_AMT"].toString();
        if(mode == "A"){
          setState(() {
            lstrAddAmount =  double.parse(amount)  + lstrAddAmount;
          });
        }else if(mode == "D"){
          setState(() {
            lstrDeductAmount = double.parse(amount) + lstrDeductAmount;
          });
        }

      }
      setState(() {
        lstrOpeningCash = lstrAddAmount - lstrDeductAmount;
      });
    }
  }

  fnSaveopening() async{
    futureOpening =  apiCall.saveOpenCash(g.wstrCompany,g.wstrYearcode,g.wstrUserCd,g.wstrShifNo,lstrOpenCashEntry,lstrAddOrDeduct,g.wstrDeivceId,g.wstrDeviceName);
    futureOpening.then((
        value) => fnSaveCardSuccess(value));
  }
  fnSaveCardSuccess(value){

    if(g.fnValCheck(value)){
        var sts = value[0]['STATUS'];
        var msg = value[0]['MSG'];
        showToast( msg);
    }
    Navigator.pop(context);
  }
}
