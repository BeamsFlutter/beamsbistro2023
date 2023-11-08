
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DualDisplay extends StatefulWidget {
  const DualDisplay({Key? key}) : super(key: key);

  @override
  State<DualDisplay> createState() => _DualDisplayState();
}

class _DualDisplayState extends State<DualDisplay> {

  //Global
  var g  = Global();


  //Page Variables
  var sts  = "0";
  var title = "";

  var companyData = [];
  var billDetails = [];
  var itemList = [];
  var totalList = [];
  var message = [];

  //Company
  var companyName = "";
  var companyAdd = "";
  var companyMob = "";

  //Bill
  var billNo = "";
  var user = "";
  var docDate = "";
  var device = "";

  //Total
  var total = 0.0;



  //Message
  var bottomMessage= "Thank You";

  late Timer timer;


  final List<String> imgList = [
    'assets/images/T1.jpg',
    'assets/images/T2.jpg',
    'assets/images/T3.png',
    'assets/images/T4.png',
    'assets/images/T5.jpg',
    'assets/images/bg4.jpg',
  ];


  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


  @override
  void initState() {
    // TODO: implement initState
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fnRefresh());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(

      body: Container(
        decoration: boxDecoration(Colors.white, 10),
        child: Row(
          children: [
              Expanded(
                flex: 6,
                  child: Container(
                    height: size.height,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        viewportFraction: 1.0
                      ),
                      items: imgList
                          .map((item) => Container(
                        height: size.height,
                        decoration: boxImageDecoration(item, 0),
                      ))
                          .toList(),
                    ),
                  )),
              sts == "1"?
              Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.all(20),
                decoration: boxDecoration(Colors.white, 0),
                child: Column(
                  children: [
                    Row(),
                    Expanded(
                      child: Container(
                        child: Column(
                          children: [
                            // Center(
                            //   child: tc(companyName.toString(), Colors.green, 35),
                            // ),
                            // Center(
                            //   child: tcn(companyAdd.toString(), Colors.black, 12),
                            // ),
                            // gapHC(5),
                            // Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    tcn('Order No', Colors.grey, 12),
                                    gapWC(20),
                                    tc1("#"+billNo.toString(), Colors.black, 13),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    tcn('Type  ', Colors.grey, 12),
                                    gapWC(20),
                                    Container(
                                      decoration: boxBaseDecoration(Colors.amber, 30),
                                        padding: EdgeInsets.symmetric(vertical: 2,horizontal: 15),
                                        child: tc1("Takeaway", Colors.black, 12)),
                                  ],
                                ),
                              ],
                            ),
                            Divider(),
                            Expanded(child: SingleChildScrollView(
                              child: Column(
                                children: wItemList(),
                              ),
                            )),

                            gapHC(5),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: boxBaseDecoration(Colors.redAccent, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          tc('TOTAL', Colors.white, 30),
                          tc(total.toStringAsFixed(2), Colors.white, 30),
                        ],
                      ),
                    ),
                    gapHC(10),
                    tcn(bottomMessage.toString(), Colors.black , 10)

                  ],
                ),
              )):
              gapWC(0)
          ],
        ),
      ),
    );
  }

  //===========================================WIDGET



  Widget wRowHead(text){
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          tcn(text, Colors.white, 12),
        ],
      ),
    );
  }
  Widget wRowHeadEnd(text){
    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          tcn(text, Colors.white, 12),
        ],
      ),
    );
  }
  List<Widget> wItemList(){
    List<Widget> rtnList  = [];

    var srno = 1;
    for(var e in itemList){
      var item  = e["DISHDESCP"].toString();
      var qty  = g.mfnDbl(e["QTY"].toString());
      var rate  = g.mfnDbl(e["RATE"].toString());
      var total  = g.mfnDbl(e["TOTAL"].toString());

      rtnList.add(
          Container(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: boxDecoration(Colors.white, 30),
                      padding: EdgeInsets.all(10),
                      child: tc1(qty.toString(), Colors.black, 10),
                    ),
                    gapWC(10),
                    tc1("x", Colors.grey, 12),
                    gapWC(10),
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc1(item.toString(), Colors.black, 13),
                        tc1("AED  " +rate.toString(), Colors.black, 10)
                      ],
                    ),),
                    tc1(total.toString(), Colors.black, 15)
                  ],
                ),
                Divider(
                  color: greyLight,
                )
              ],
            ),
          )

      );
      srno = srno+1;
    }

    return rtnList;
  }
  List<Widget> wItemList1(){
    List<Widget> rtnList  = [];

    var srno = 1;
    for(var e in itemList){
      var item  = e["DISHDESCP"].toString();
      var qty  = g.mfnDbl(e["QTY"].toString());
      var rate  = g.mfnDbl(e["RATE"].toString());
      var total  = g.mfnDbl(e["TOTAL"].toString());

      rtnList.add(
          Container(
            padding: const EdgeInsets.all(5),
            decoration:(srno%2) == 0? boxBaseDecoration(greyLight.withOpacity(0.6), 0): boxBaseDecoration(Colors.transparent, 0),
            child: Row(
              children: [
                Flexible(
                  flex: 5,
                  child: wRow(srno),
                ),
                Flexible(
                  flex: 18,
                  child: wRow(item),
                ),
                Flexible(
                  flex: 6,
                  child: wRow(qty),
                ),
                Flexible(
                  flex: 6,
                  child: wRowEnd(rate),
                ),
                Flexible(
                  flex: 6,
                  child: wRowEnd(total),
                ),
              ],
            ),
          )

      );
      srno = srno+1;
    }

    return rtnList;
  }

  Widget wRow(text){
    return Container(
      padding: const EdgeInsets.all(2),
      child: Row(
        children: [
          Expanded(child: tcn(text.toString(), Colors.black, 12),)
        ],
      ),
    );
  }
  Widget wRowEnd(text){
    return Container(
      padding: const EdgeInsets.all(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          tcn(text.toString(), Colors.black, 12),
        ],
      ),
    );
  }


  //===========================================PAGE FN
    fnRefresh(){
      if(mounted){
        readJsonDataFromFile();
      }
    }



    fnFillForm(data){
      fnClear();
      if(mounted){
        setState(() {

          companyData.add(data["COMPANY_DATA"]??[]);
          billDetails.add(data["BILL_DETAILS"]??[]);
          itemList = (data["ITEM_LIST"]??[]);
          totalList.add(data["TOTAL"]??[]);
          message.add(data["MESSAGE"]??[]);
          
          //Company
          sts  = (data["STS"]??"0").toString();
          companyName = (companyData[0]["NAME"]??"");
          companyAdd = (companyData[0]["ADD"]??"");
          companyMob = (companyData[0]["MOBILE"]??"");

          //Bill
          billNo = (billDetails[0]["BILLNO"]??"");
          user = (billDetails[0]["USER"]??"");
          docDate = (billDetails[0]["DOCDATE"]??"");
          device = (billDetails[0]["DEVICE"]??"");

          //Total
          total = g.mfnDbl((totalList[0]["NET_TOTAL"]??""));

          //Message
          bottomMessage = (message[0]["BOTTOM_MESSAGE"]??"");

        });
      }
    }

    fnClear(){
      if(mounted){
        setState(() {
          sts  = "0";
          companyData = [];
          billDetails = [];
          itemList = [];
          totalList = [];
          message = [];

          companyName = "";
          companyAdd = "";
          companyMob = "";

          billNo = "";
          user = "";
          docDate = "";
          device = "";

          total = 0.0;

          bottomMessage= "Thank You";
        });
      }
    }


  readJsonDataFromFile() async {
    try {
      Directory appDir = await getApplicationDocumentsDirectory();
      String filePath = 'C:\\Beams\\data.json';
      File file = File(filePath);
      print(file) ;
      if (await file.exists()) {
        String fileContent = await file.readAsString();
        var jsonData = jsonDecode(fileContent);
        fnFillForm(jsonData);
        print(jsonData) ;
      }else{
        print("File not exist") ;
      }
    } catch (e) {
      print('Error reading JSON file: $e');
    }
  }

  writeJsonDataToFile(var jsonData) async {
    try {
      String jsonString = jsonEncode(jsonData);
      File file = File("C:/BEAMS/data.json");
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error writing JSON file: $e');
    }
  }


//===========================================API CALL
}
