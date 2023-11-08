

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class AddlAmount extends StatefulWidget {

  final List<dynamic>  lstrDataList;
  final List<dynamic>  lstrAddlList;
  final Function  fnCallBack;

  const AddlAmount({Key? key, required this.lstrDataList, required this.fnCallBack, required this.lstrAddlList,}) : super(key: key);

  @override
  _AddlAmountState createState() => _AddlAmountState();
}

class _AddlAmountState extends State<AddlAmount> {


  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic>  futureAddlCharge;

  var lstrEntryMode = 'C';
  var lstrCashEntry ='0.0';
  var lstrAddlChargeList  = [];
  var lstrSelectedData = [];

  var lstrSelectedDocno = '' ;
  var lstrSelectedType = '' ;
  var lstrSelectedCharge = '' ;
  var lstrLastTotal = 0.00;
  var lstrLastAddlAmt = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lstrSelectedData = widget.lstrDataList;
    lstrAddlChargeList = widget.lstrAddlList;
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
                tc('AED ' +lstrLastTotal.toString(), PrimaryColor, 15),

              ],
            ),
          ),
          gapHC(10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                //chargetype view
                decoration: boxDecoration(Colors.white, 10),
                padding: EdgeInsets.all(5),
                width: size.width*0.2,
                height: 450,
                child: FutureBuilder<dynamic>(
                  future:  futureAddlCharge ,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return  chargeView(snapshot)  ;
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
              Expanded(child:
              Container(
                height: 450,
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      //chargetype list
                      child: selectedChargeView(lstrAddlChargeList,size),
                    )),
                    Container(
                      decoration: boxBaseDecoration(blueLight, 5),
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            tc('${mfnLng("ADDITIONAL AMOUNT")}  ',Colors.black,18),
                            tc(lstrLastAddlAmt.toStringAsFixed(3),Colors.black,18)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),),
              Container(
                //number
                width: size.width*0.3,
                height: 450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        //fnDone();
                      },
                      child: Container(
                        height: 50,
                        decoration: boxBaseDecoration(redLight, 5),
                        child: Center(
                          child: tc(lstrCashEntry,PrimaryColor,25),
                        ),
                      ),
                    ),
                    gapHC(10),
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
                      child:Container(
                        height: 60,
                        decoration: boxDecoration(Colors.green, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.verified_sharp,color: Colors.white,size: 20,),
                            gapWC(10),
                            tc(mfnLng('Done'),Colors.white,20),
                          ],
                        ),
                      ),
                      onPressed: (){
                        fnDone();
                      },
                      duration: Duration(milliseconds: 110),
                    )


                  ],
                ),
              )
            ],
          ),

        ],
      ),
    );
  }

  GestureDetector numberPress(text,size) => GestureDetector(
    onTap: (){
      fnOnPress(text);
    },
    onLongPress: (){
      fnOnLongPress(text);
    },
    child:  Container(
      height: 60,
      width: size.width*0.09,
      margin: EdgeInsets.only(bottom: 5),
      decoration: boxDecoration(Colors.white, 10),
      child: Center(
        child: tc(text,titleSubText,30),
      ),
    ),
  );
  Widget chargeView(snapshot){
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          var amount = 0.00;
          var dataList = snapshot.data[index];
          var code = dataList["CODE"];
          var descp = dataList["DESCP"];
          amount = dataList["AMT"];
          return GestureDetector(
            onTap: (){
              fnAddAddlAmount(dataList);
            },
            child : Container(
              height: 40,
              margin: EdgeInsets.only(bottom: 5),
              decoration: boxBaseDecoration(Colors.amber, 5),
              child: Center(
                  child:  tc(descp.toString(),Colors.black,15)
              ),
            ),

          );
        });
  }
  Widget selectedChargeView(snapshot,size){
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.length,
        itemBuilder: (context, index) {
          var amount = 0.00;
          var dataList = snapshot[index];
          var code = dataList["CODE"];
          var descp = dataList["DESCP"];
          amount = dataList["AMT"];
          return GestureDetector(
            onTap: (){
              fnSelectedCharge(amount,code);
            },
            child : Container(
              height: 40,
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: boxBaseDecoration(lstrSelectedCharge == code?redLight: greyLight, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tc(descp,Colors.black,15),
                  Row(
                    children: [
                      tc(amount.toString(),PrimaryColor,15),

                      gapWC(15),
                      GestureDetector(
                        onTap: (){
                          fnRemoveCharge(dataList);
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
                ],
              ),
            ),

          );
        });
  }

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
    fnChangeSelectedAmt();

  }
  fnOnLongPress(mode){
    if(mode == 'x'){
      setState(() {
        lstrCashEntry = '0.0';
      });
    }
    fnChangeSelectedAmt();

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
    fnGetChargeType();
    fnCalc();
  }

  fnAddAddlAmount(dataList){

    bool sts = true;
    setState(() {
      for(var e in lstrAddlChargeList){
        if(e == dataList){
          sts = false;
          return;
        }
      }
      if(sts){
        lstrAddlChargeList.add(dataList);
      }

    });
    fnCalc();
  }
  fnRemoveCharge(dataList){
    setState(() {
      lstrAddlChargeList.remove(dataList);
    });
    fnCalc();
  }
  fnCalc(){
    var total = 0.0;
    for(var e in lstrAddlChargeList){
      total = total + e["AMT"];
    }
    setState(() {
      lstrLastAddlAmt =  total;
    });
  }

  fnSelectedCharge(amt,code){
    setState(() {
      lstrCashEntry = amt.toString();
      lstrSelectedCharge = code;
    });
  }

  fnChangeSelectedAmt(){
    var code = "";
    var changeAmt =  double.parse(lstrCashEntry);
    for(var e in lstrAddlChargeList){
      code = e["CODE"];
      if(code == lstrSelectedCharge){
        e["AMT"] = changeAmt;
        fnCalc();
        return;
      }
    }

  }

  fnDone(){
    var addlList = [];
    var srno = 0;
    for(var e in lstrAddlChargeList){

      addlList.add({
        "COMPANY" : g.wstrCompany,
        "DOCNO" : lstrSelectedDocno,
        "DOCTYPE":"KOT",
        "YEARCODE":g.wstrYearcode,
        "SRNO":srno+1,
        "CODE":e["CODE"],
        "DESCP":e["DESCP"],
        "AMT":e["AMT"],
        "DBACCODE":e["DBACCODE"],
        "CRACCODE":e["CRACCODE"]
      });
      srno = srno +1;
    }
    widget.fnCallBack(addlList,lstrLastAddlAmt,lstrAddlChargeList);

    Navigator.pop(context);
  }

  //api

  fnGetChargeType(){
    futureAddlCharge = apiCall.getChargeType(g.wstrCompany,"REST");
    futureAddlCharge.then((value) => fnGetChargeTypeSuccess(value));
  }
  fnGetChargeTypeSuccess(value){
    print(value);
  }


}
