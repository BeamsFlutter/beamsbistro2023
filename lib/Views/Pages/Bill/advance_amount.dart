

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class Advance extends StatefulWidget {

  final double  oldValue;
  final List<dynamic>  lstrDataList;
  final Function  fnCallBack;

  const Advance({Key? key,  required this.fnCallBack, required this.oldValue, required this.lstrDataList}) : super(key: key);

  @override
  _AdvanceState createState() => _AdvanceState();
}

class _AdvanceState extends State<Advance> {


  Global g = Global();
  ApiCall apiCall = ApiCall();

  var lstrSelectedData = [];

  var lstrOldValue =0.00;
  var lstrCashEntry ='0.0';
  var lstrCardEntry = '';
  var lstrEntryMode = 'C';

  var lstrLastTotal = 0.00;

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
                tc('Advance Amount' , Colors.black, 16),
                tc('', PrimaryColor, 15),
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
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: boxBaseDecoration(greyLight, 10),
                      child: Center(
                        child:  tc('TOTAL  ' + lstrLastTotal.toStringAsFixed(3),Colors.red,40),
                      ),
                    ),
                    gapHC(10),
                    tc('ADVANCE AMOUNT', Colors.black, 10),
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
                              tc('DONE',Colors.white,20),
                            ],
                          ),
                        ),
                        duration: Duration(milliseconds: 110),
                        onPressed: (){
                          fnDone();
                        }
                    )



                  ],
                ),

              ))
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
    ),
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
      lstrSelectedData= widget.lstrDataList;
      lstrOldValue = widget.oldValue;
      lstrCashEntry = lstrOldValue.toString();
    });

    if(g.fnValCheck(lstrSelectedData)){

      var dataList =  lstrSelectedData[0];
      setState(() {
        lstrLastTotal = dataList["TOTAL_AMT"];
      });
    }

  }
  fnDone(){

    var amount = double.parse(lstrCashEntry);

    widget.fnCallBack(amount);
    Navigator.pop(context);

  }


}
