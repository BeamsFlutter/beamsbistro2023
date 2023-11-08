
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Pages/mrq/mrq_screen.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class MRQPage extends StatefulWidget {
  const MRQPage({Key? key}) : super(key: key);

  @override
  State<MRQPage> createState() => _MRQPageState();
}

class _MRQPageState extends State<MRQPage> {


  //Global
  var g = Global();
  var apiCall = ApiCall();
  late Future<dynamic> futureForm;


  //Page Variable
  var selectedButton = "Received";
  var recMrqList = [];
  var sendMrqList = [];
  var sendMrqDet = [];
  var lstrSelectedDocno = "";
  var lstrSelectedTotal = 0.0;


  //Controller



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: boxDecoration(Colors.white, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/icons/bislogo.png",
                          width: 80,),
                        gapWC(20),
                        tcn('Material Request', PrimaryColor, 25),
                      ],
                    ),
                    gapWC(10),
                    Row(
                      children: [
                        Bounce(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => MRQScreen()
                            ));
                          },
                          duration: Duration(milliseconds: 110),
                          child: Container(
                            decoration: boxDecoration(SubColor, 30),
                            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 30),
                            child: Row(
                              children: [
                                tcn('New Request ', Colors.black, 15),
                                gapWC(5),
                                Icon(Icons.add_circle_outline_outlined,color: Colors.black,size: 15,)
                              ],
                            ),
                          ),
                        ),
                        gapWC(20),
                        Bounce(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          duration: Duration(milliseconds: 110),
                          child: Container(
                            decoration: boxBaseDecoration(greyLight, 30),
                            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 30),
                            child: Row(
                              children: [
                                tcn('Close', Colors.black, 15),
                                gapWC(5),
                                Icon(Icons.close,color: Colors.black,size: 15,)
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Flexible(
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(5),
                                decoration: boxBaseDecoration(greyLight, 30),
                                child: Row(
                                  children: [
                                    wSRButton('Received'),
                                    gapWC(5),
                                    wSRButton('Send'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          gapHC(10),
                          selectedButton == "Send"?
                          Expanded(child: Wrap(
                            children: wMrqList(),
                          )):
                          Expanded(child: Wrap(
                            children: wMrqRecList(),
                          ))
                        ],
                      ),
                    ),
                  ),
                  gapWC(5),
                  Container(
                    width: 350,
                    padding: EdgeInsets.all(5),
                    decoration: boxDecoration(Colors.white, 10),
                    child: Column(
                      children: [
                        Row(),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: wItemList(),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 0.5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            tcn('Total', Colors.black, 16),
                            tc(lstrSelectedTotal.toString(), Colors.black, 16),
                          ],
                        ),
                        gapHC(10)
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //=========================================WIDGET

  Widget wSRButton(text){
      return Bounce(
        onPressed: (){
          if(mounted){
            setState(() {
              selectedButton = text;
            });
            fnClear();
            if(text == "Send"){
              apiGetMrq();
            }else{
              apiGetMrqRec();
            }

          }
        },
        duration: Duration(milliseconds: 110),
        child: Container(
          decoration: boxBaseDecoration(selectedButton == text?Colors.amber:Colors.transparent, 30),
          padding: EdgeInsets.symmetric(vertical: 5,horizontal: 15),
          width: 120,
          child:  Center(
            child: tcn(text, Colors.black, 15),
          ),
        ),
      );
    }
  List<Widget> wMrqList(){
    List<Widget> rtnList = [];
    rtnList.add(
       Row()
    );
    var srno = 1;
    for(var e in sendMrqList){
      var docno = (e["DOCNO"]??"").toString();
      var doctype = (e["DOCTYPE"]??"").toString();
      var branch = (e["BRNCODE"]??"").toString();
      var branchName = (e["BRANCHNAME"]??"").toString();
      var date = "";
      try{
        date = setDate(8, DateTime.parse((e["CREATE_DATE"]??"").toString()));
      }catch(e){
        date = "";
      }
      var amount = (e["NETAMT"]??"").toString();
      rtnList.add(GestureDetector(
        onTap: (){
          if(mounted){
            setState(() {
              lstrSelectedDocno = docno;
              lstrSelectedTotal = g.mfnDbl(e["NETAMT"]);
            });
            apiGetMrqDet(doctype,docno);
          }
        },
        child: ClipPath(
          clipper: MovieTicketClipper(),
          child: Container(
              width: MediaQuery.of(context).size.width*0.165,
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              decoration: boxDecoration(lstrSelectedDocno ==docno? blueLight : Colors.white, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: boxBaseDecorationC(Colors.green, 5,5,0,5),
                    child: tcn('Send', Colors.white, 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      th('Order ' +  docno,Colors.black,13),
                    ],
                  ),
                  gapHC(5),
                  lineC(0.2, Colors.black),
                  gapHC(5),
                  Row(
                    children: [
                      Icon(Icons.place ,size: 13,),
                      gapWC(5),
                      ts('To '+branchName,Colors.black,12),
                    ],
                  ),
                  gapHC(5),
                  Row(
                    children: [
                      Icon(Icons.calendar_month,size: 13,),
                      gapWC(5),
                      Expanded(child: ts(date,Colors.black,11)),
                    ],
                  ),
                  gapHC(5),
                  lineC(0.2, Colors.black),
                  gapHC(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      th( 'AED '+ amount,PrimaryColor,16),
                    ],
                  ),
                  gapHC(10),

                ],
              )
          ),
        ),
      ));
      srno= srno+1;
    }
    return rtnList;
  }
  List<Widget> wMrqRecList(){
    List<Widget> rtnList = [];
    rtnList.add(
        Row()
    );
    var srno = 1;
    for(var e in recMrqList){
      var docno = (e["DOCNO"]??"").toString();
      var doctype = (e["DOCTYPE"]??"").toString();
      var branch = (e["BRNCODE"]??"").toString();
      var branchName = (e["BRANCHNAME"]??"").toString();
      var date = "";
      try{
        date = setDate(8, DateTime.parse((e["CREATE_DATE"]??"").toString()));
      }catch(e){
        date = "";
      }
      var amount = (e["NETAMT"]??"").toString();
      rtnList.add(GestureDetector(
        onTap: (){
          if(mounted){
            setState(() {
              lstrSelectedDocno = docno;
              lstrSelectedTotal = g.mfnDbl(e["NETAMT"]);
            });
            apiGetMrqDet(doctype,docno);
          }
        },
        child: ClipPath(
          clipper: MovieTicketClipper(),
          child: Container(
              width: MediaQuery.of(context).size.width*0.165,
              margin: EdgeInsets.all(5),
              padding: EdgeInsets.all(10),
              decoration: boxDecoration(lstrSelectedDocno ==docno? blueLight : Colors.white, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: boxBaseDecorationC(Colors.blue, 5,5,0,5),
                    child: tcn('Received', Colors.white, 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      th('Order ' +  docno,Colors.black,13),
                    ],
                  ),
                  gapHC(5),
                  lineC(0.2, Colors.black),
                  gapHC(5),
                  Row(
                    children: [
                      Icon(Icons.place ,size: 13,),
                      gapWC(5),
                      ts('From '+branchName,Colors.black,12),


                    ],
                  ),
                  gapHC(5),
                  Row(
                    children: [
                      Icon(Icons.calendar_month,size: 13,),
                      gapWC(5),
                      Expanded(child: ts(date,Colors.black,11)),
                    ],
                  ),
                  gapHC(5),
                  lineC(0.2, Colors.black),
                  gapHC(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      th( 'AED '+ amount,PrimaryColor,16),
                    ],
                  ),
                  gapHC(10),

                ],
              )
          ),
        ),
      ));
      srno= srno+1;
    }
    return rtnList;
  }
  List<Widget> wItemList(){
    List<Widget> rtnList  = [];
    for(var e in sendMrqDet){
      var itemqty1 = g.mfnDbl(e["QTY1"]);
      var itemPrice = g.mfnDbl(e["RATE"]);
      var itemName = (e["STKDESCP"]??"").toString();
      var total = itemqty1 * itemPrice;
      rtnList.add(
          GestureDetector(
            child: Container( 
                decoration: boxBaseDecoration(blueLight.withOpacity(0.5), 10),
                margin: EdgeInsets.all(3),
                padding: EdgeInsets.all(5),
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
                      ],
                    ),)
                  ],
                )
            ),
          )
      );
    }
    return rtnList;
  }

  //=========================================PAGE FN
  fnClear(){
    if(mounted){
      setState(() {
        sendMrqDet = [];
        lstrSelectedDocno = "";
        lstrSelectedTotal = 0.0;
      });
    }
  }
  //=========================================API CALL

   apiGetMrq(){
     futureForm = apiCall.apiGetMrq(g.wstrCompany, g.wstrUserBrnCode,"S");
     futureForm.then((value) =>  apiGetMrqRes(value));
   }
   apiGetMrqRes(value){
     if(mounted){
       setState(() {
         sendMrqList = [];
         if(g.fnValCheck(value)){
           sendMrqList = value["Table1"];
         }
       });
     }

   }

    apiGetMrqRec(){
      futureForm = apiCall.apiGetMrq(g.wstrCompany, g.wstrUserBrnCode,"R");
      futureForm.then((value) =>  apiGetMrqRecRes(value));
    }
    apiGetMrqRecRes(value){
      if(mounted){
        setState(() {
          recMrqList = [];
          if(g.fnValCheck(value)){
            recMrqList = value["Table1"];
          }
        });
      }

    }

    apiGetMrqDet(doctype,docno){
      futureForm = apiCall.apiGetMrqDet(g.wstrCompany, doctype,docno);
      futureForm.then((value) =>  apiGetMrqDetRes(value));
    }
    apiGetMrqDetRes(value){
      if(mounted){
        print(value);
        setState(() {
          sendMrqDet = [];
          if(g.fnValCheck(value)){
            sendMrqDet = value["Table1"];
          }
        });
      }

    }



}
