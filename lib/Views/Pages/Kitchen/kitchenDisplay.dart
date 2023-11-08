import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

class KitchenDisplay extends StatefulWidget {
  var lstrSelectedOrderNo ='';
  var lstrSelectedTableNo='';
  var lstrSelectedOrderTime='';
  var lstrSelectedOrderType='';
  var lstrSelectedItems=[];
  late Future<dynamic> futureChef;
  var lstrSelectedMode = '';
  final Function fnCallBack;



  //const KitchenDisplay({Key? key}) : super(key: key);
   KitchenDisplay({
     Key? key,
    required this.lstrSelectedOrderNo,
    required this.lstrSelectedTableNo,
    required this.lstrSelectedOrderTime,
    required this.lstrSelectedOrderType,
    required this.lstrSelectedItems,
    required this.lstrSelectedMode,
    required this.futureChef,
    required this.fnCallBack,}) : super(key: key);

  @override
  _KitchenDisplayState createState() => _KitchenDisplayState();
}

class _KitchenDisplayState extends State<KitchenDisplay> {

  ApiCall apiCall = ApiCall();
  Global g = Global();



  var lstrSelectedChefName ='';
  var lstrSelectedChef='';
  var lstrSelectedType =[];
  var lstrSaveItems = [];
  var colorChangeT ='B';
  var colorChangeP ='';
  var _radioValue = 0;

  var selectAll = false;
  var buttonVal = 'Select All';


  late Future<dynamic> futureQuick ;



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
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
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.lstrSelectedMode == 'P' || widget.lstrSelectedMode == ''? GestureDetector(
                      onTap: () {

                        print(widget.lstrSelectedMode);
                        setState(() {
                          if(selectAll){
                            selectAll = false;
                            buttonVal = 'Select All';
                          }else{
                            selectAll = true;
                            buttonVal = 'None';
                          }
                        });

                        fnAddList();

                        print(selectAll);
                        print(colorChangeT);
                      },
                      child:  Container(
                        padding: const EdgeInsets.only(left: 5,right: 5,top:5,bottom: 5),
                        height: 50,
                        width: size.width * 0.15,
                        decoration: boxBaseDecoration(Colors.green,15),
                        child: Center(
                          child: tc(
                              buttonVal, Colors.white ,
                              15),
                        ),
                      ),
                    ) : Container(),
                  ],
                ),

                gapWC(80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    tc('${mfnLng("Order #")} ' + widget.lstrSelectedOrderNo, Colors.black, 16),
                    gapWC(25),
                    widget.lstrSelectedOrderType == 'T'
                        ? tc(mfnLng("Table")+" " + widget.lstrSelectedTableNo, PrimaryColor, 15)
                        : widget.lstrSelectedOrderType == 'A'
                        ? tc(mfnLng('TAKEAWAY'), PrimaryColor, 15)
                        : tc(mfnLng('DELIVERY'), PrimaryColor, 15),
                    gapWC(25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.access_time_sharp,
                          color: Colors.black,
                        ),
                        gapWC(5),
                        tc(widget.lstrSelectedOrderTime.toString(), Colors.black, 15),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
          gapHC(10),
          // tc(lstrSelectedOrderTime.toString(), Colors.black, 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: boxBaseDecoration(blueLight, 10),
                padding: EdgeInsets.all(10),
                height: 450,
                width: size.width * 0.4,
                child: itemDetailView(widget.lstrSelectedItems),
              ),
              Expanded(child:
              Container(
                padding: EdgeInsets.all(10),
                height:450,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tc(mfnLng('SELECT CHEF NAME'), Colors.black, 15),
                    Expanded(child: FutureBuilder<dynamic>(
                      future: widget.futureChef,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return chefView(snapshot);
                        } else if (snapshot.hasError) {
                          return Container();
                        }
                        // By default, show a loading spinner.
                        return Center(
                          child: Container(),
                        );
                      },
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            fnSave("R");
                          },
                          child: Container(
                            height: 50,
                            width: size.width * 0.15,
                            decoration: boxDecoration(Colors.green, 5),
                            child: Center(
                              child: th(mfnLng('START'), Colors.white, 15),
                            ),
                          ),
                        ),
                        gapWC(5),
                        Expanded(child: GestureDetector(
                          onTap: () {
                            fnStartAll("R");
                          },
                          child: Container(
                            height: 50,
                            decoration: boxDecoration(Colors.green, 5),
                            child: Center(
                              child: th(mfnLng('START ALL'), Colors.white, 15),
                            ),
                          ),
                        ),),
                        gapWC(5),
                        GestureDetector(
                          onTap: () {
                            print('--------------- ARRAY LIST-------------------------------');
                            print(lstrSelectedType);
                            fnFinishAll();
                          },
                          child: Container(
                            height: 50,
                            width: size.width * 0.15,
                            decoration: boxDecoration(Colors.blue, 5),
                            child: Center(
                              child: tc(mfnLng('FINISH ALL'), Colors.white, 15),
                            ),
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),)
            ],
          )
        ],
      ),
    );

  }

  // UI Design for item list
  Widget itemDetailView(itemList) {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          var dataList = itemList[index];
          var itemCode = dataList['STKCODE'];
          var itemDescp = dataList['STKDESCP'];
          var itemQty = dataList['QTY1'].toString();
          var itemStatus = dataList['STATUS'].toString();
          var itemNote = dataList['REF1'].toString();
          var chefName = dataList['CHEF_NAME'] ?? '';
          var itemPriority = 0;
          return Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              margin: EdgeInsets.only(bottom: 5),
              decoration: boxBaseDecoration(Colors.white, 10),
              child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: lName(itemDescp +
                                  ' x ' +
                                  itemQty.toString() +
                                  ' - ' +
                                  chefName.toString(),
                                  itemStatus,
                                  itemPriority)),
                          itemStatus == 'D'
                              ? Icon(
                            Icons.done_all_sharp,
                            size: 20,
                            color: Colors.grey,
                          )
                              : itemStatus == 'R'
                              ? GestureDetector(
                            onTap: () {
                              fnDoneItem(dataList);
                            },
                            child: Container(
                              height: 45,
                              width: 100,
                              decoration:
                              boxDecoration(Colors.green, 5),
                              child: Center(
                                child: tc(mfnLng("READY"), Colors.white, 15),
                              ),
                            ),
                          )
                              : itemStatus == 'P'
                              ? Transform.scale(
                            scale: 1.5,
                            child: Checkbox(
                                activeColor: Colors.green,
                                value: fnCheckItem(itemCode),
                                onChanged: (value) {

                                  fnItemCheckClick(
                                        dataList, itemCode);

                                }),
                          )
                              : itemStatus == 'C'
                              ? Container()
                              : Container()
                        ],
                      ),
                      itemNote == ''
                          ? Container()
                          : ts(itemNote, Colors.black, 12)
                    ],
                  )));
        });
  }

  Widget chefView(snapshot) {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data[index];
          var userName = dataList["USER_NAME"] ?? '';
          var userCode = dataList["USER_CD"] ?? '';
          return GestureDetector(
            onTap: () {},
            //h1(userName.toString())
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Transform.scale(
                    scale: 1,
                    child: new Radio(
                      value: index,
                      groupValue: _radioValue,
                      onChanged: (value) {
                        fnChefRadioClick(userCode, userName, index);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      fnChefRadioClick(userCode, userName, index);
                    },
                    child: tc(userName, Colors.black, 20),
                  )
                ],
              ),
            ),
          );
        });
  }

  // ---------------- Functions
  fnDoneItem(dataList) {
    lstrSelectedChefName   = dataList["CHEF_NAME"];
    lstrSelectedChef      = dataList["CHEF_CODE"];
    lstrSelectedType      = [];
    setState(() {
      lstrSelectedType.add(dataList);
    });
    fnSave("D");
  }
  fnCheckItem(itemCode) {
   bool sData = false;
   if (g.fnValCheck(lstrSelectedType)) {
     for (var e in lstrSelectedType) {
       var lcode = e["STKCODE"].toString();
       if (itemCode == lcode) {
         sData = true;
         break;
       }
     }
   }
   return sData;
 }
  fnItemCheckClick(itemList, itemCode) {
   if (fnCheckItem(itemCode)) {
     setState(() {
       lstrSelectedType.remove(itemList);
     });
   } else {
     setState(() {
       lstrSelectedType.add(itemList);
     });
   }

 /*  Navigator.pop(context);
   PageDialog().showL(context, fnItemChild(context), 'Kitchen Display');
   print(lstrSelectedType.length.toString());*/
 }

  fnAddList(){
    if(selectAll){
      lstrSelectedType = [];
      for(var e in widget.lstrSelectedItems){
        setState(() {
          lstrSelectedType.add(e);
        });
      }
    }else{
      lstrSelectedType = [];
    }
  }
  fnSave(type) {
   if (!g.fnValCheck(lstrSelectedType)) {
     showToast( mfnLng('Please choose items!'));
     return;
   }
   lstrSaveItems = [];
   for (var e in lstrSelectedType) {
     lstrSaveItems.add({
       "COMPANY": e["COMPANY"],
       "YEARCODE": e["YEARCODE"],
       "DOCNO": e["DOCNO"],
       "DOCTYPE": e["DOCTYPE"],
       "SRNO": e["SRNO"],
       "QTY1": e["QTY1"],
       "STKCODE": e["STKCODE"],
       "STKDESCP": e["STKDESCP"],
       "PREP_STATUS": type,
       "CHEF_CODE": lstrSelectedChef,
       "CHEF_NAME": lstrSelectedChefName,
       "STATUS": type
     });
   }

   print(lstrSaveItems);

   // call back function has to call
   widget.fnCallBack(lstrSaveItems,"OTHER");
 //  Navigator.of(context).pop();

 }
  fnStartAll(type) {

    for(var e in widget.lstrSelectedItems){
      setState(() {
        var sts = e["STATUS"];
        if (sts == "P") {
          lstrSelectedType.add(e);
        }
      });
    }

    if (!g.fnValCheck(lstrSelectedType)) {
      showToast( mfnLng('Preparation Already Started'));
      return;
    }
    lstrSaveItems = [];
    for (var e in lstrSelectedType) {
      lstrSaveItems.add({
        "COMPANY": e["COMPANY"],
        "YEARCODE": e["YEARCODE"],
        "DOCNO": e["DOCNO"],
        "DOCTYPE": e["DOCTYPE"],
        "SRNO": e["SRNO"],
        "QTY1": e["QTY1"],
        "STKCODE": e["STKCODE"],
        "STKDESCP": e["STKDESCP"],
        "PREP_STATUS": type,
        "CHEF_CODE": lstrSelectedChef,
        "CHEF_NAME": lstrSelectedChefName,
        "STATUS": type
      });
    }

    print(lstrSaveItems);

    // call back function has to call
    widget.fnCallBack(lstrSaveItems,"OTHER");
    //  Navigator.of(context).pop();

  }

  fnFinishAll() {
    setState(() {
      lstrSelectedType = [];
    });
    for (var e in widget.lstrSelectedItems) {
      var sts = e["STATUS"];
      if (sts == "R") {
        lstrSelectedType.add(e);
      }
    }
    if (!g.fnValCheck(lstrSelectedType)) {
      showToast( mfnLng('No items started yet..'));
      return;
    } else {
      fnSave("D");
    }
  }
  fnFinishQuickAll(){

    if (g.fnValCheck(widget.lstrSelectedItems)) {
      var docno  = widget.lstrSelectedItems[0]["DOCNO"];
      var doctype  = widget.lstrSelectedItems[0]["DOCTYPE"];
      var yearcode  = widget.lstrSelectedItems[0]["YEARCODE"];
      fnQuickCloseApi(docno,doctype,yearcode);
    }


  }
  fnChefRadioClick(code, name, index) {
    setState(() {
      _radioValue = index;
      lstrSelectedChef = code;
      lstrSelectedChefName = name;
    });
   /* Navigator.pop(context);
    PageDialog().showL(context, fnItemChild(context), 'Kitchen Display');*/
  }
  _fnSelectNone(){

    setState(() {
      widget.lstrSelectedItems = [];
    });


  }


  //========================APICALL=============================

  fnQuickCloseApi(docno,doctype,yearcode){
    futureQuick  = apiCall.kotQuickCompletion(g.wstrCompany, docno, doctype, yearcode);
    futureQuick.then((value) => fnQuickCloseApiSuccess(value));
  }
  fnQuickCloseApiSuccess(value){
    widget.fnCallBack([],"QUICK");
  }

}
