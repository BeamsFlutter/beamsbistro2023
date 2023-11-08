

import 'dart:async';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:beamsbistro/Views/Pages/Login/userLogin.dart';
import 'package:beamsbistro/Views/Pages/Menu/menu.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Waiter extends StatefulWidget {
  const Waiter({Key? key}) : super(key: key);

  @override
  _WaiterState createState() => _WaiterState();
}

class _WaiterState extends State<Waiter> with SingleTickerProviderStateMixin {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //api
  late TabController _controller;
  late Future<dynamic> futureFloor;
  late Future<dynamic> futureTable;
  late Future<dynamic> futureMultiTable;
  late Future<dynamic> futureOrder;
  late Future<dynamic> futureTakeAway;
  late Future<dynamic> futureDelivery;
  var  apiCall = ApiCall();
  var lstrSelectedFloor;
  var lstrMultiTable = [] ;

  //TextEditor
  var txtGuestNo = TextEditingController();

  var lstrSelectedItems = [];
  var lstrSelectedTabels= [];
  var lstrSelectedKot= [];
  var lstrSelectedAddress= [];

  var lstrSelectedTableNo = '' ;
  var lstrSelectedOrderNo = '' ;
  var lstrSelectedOrderDocNo = '' ;

  var lstrSelectedName = '' ;
  var lstrSelectedMob = '' ;
  var lstrTotalAmount = '' ;
  var lstrOrderTables = '' ;
  var lstrSelectedGuestNum = '' ;

  Global g = Global();


  late Timer timer;
  int counter = 0;

  @override
  void dispose() {
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3,vsync: this);
    fnGetTable();
    fnGetTakeAway();
    fnGetDelivery();
    txtGuestNo.text ='0';
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => fnRefresh());
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return WillPopScope(child: Scaffold(
      appBar: mainAppBar(fnLogout,fnSysytemInfo),
      body: SafeArea(
        child: Container(
          padding: pageMargin(),
          height: size.height,
          color: Colors.white,
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                gapHC(5),
                hh(g.wstrUserCd??''),
                gapHC(5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // GestureDetector(
                    //   onTap: (){
                    //
                    //   },
                    //   child: Container(
                    //     width: size.width*0.2,
                    //     height: 120,
                    //     decoration: boxDecoration(SecondaryColor, 10),
                    //     padding: pagePadding(),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.end,
                    //       children: <Widget>[
                    //         Icon(Icons.qr_code_scanner,size: 40,color: PrimaryText,),
                    //         gapHC(12),
                    //         h3('Scan & Order')
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    gapW(),
                    GestureDetector(
                      onTap: (){
                        g.wstrOrderType = 'A';
                        g.wstrOrderMode = 'ADD';
                        g.wstrMenuMode = 'ADD';
                        g.wstrLastSelectedAdd = [];
                        g.wstrLastSelectedTables = [];
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Menu()));
                      },
                      child: Container(
                        width: size.width*0.41,
                        height: 110,
                        decoration: boxGradientDecoration(12, 10),
                        padding: pagePadding(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.post_add,size: 50,color: Colors.white),
                            gapHC(12),
                            tc('Take Away',Colors.white,20)

                          ],
                        ),
                      ),
                    ),
                    gapW(),
                    GestureDetector(
                      onTap: (){
                        g.wstrOrderType = 'D';
                        g.wstrOrderMode = 'ADD';
                        g.wstrMenuMode = 'ADD';
                        g.wstrLastSelectedAdd = [];
                        g.wstrLastSelectedTables = [];
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Menu()));
                      },
                      child: Container(
                        width: size.width*0.41,
                        height: 110,
                        decoration: boxGradientDecoration(12, 10),
                        padding: pagePadding(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Icon(Icons.delivery_dining,size: 50,color: Colors.white),
                            gapHC(12),
                            tc('Delivery',Colors.white,20)

                          ],
                        ),
                      ),
                    ),
                    gapW(),
                    // GestureDetector(
                    //   onTap: (){
                    //     //Navigator.push(context, MaterialPageRoute(builder: (context) => Menu()));
                    //   },
                    //   child: Container(
                    //     width: size.width*0.2,
                    //     height: 120,
                    //     decoration: boxDecoration(SecondaryColor, 10),
                    //     padding: pagePadding(),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.center,
                    //       mainAxisAlignment: MainAxisAlignment.end,
                    //       children: <Widget>[
                    //         Icon(Icons.fastfood,size: 40,color: PrimaryText),
                    //         gapHC(12),
                    //         h3('Menu')
                    //       ],
                    //     ),
                    //   ),
                    // ),

                  ],
                ),
                gapH(),
                new Container(
                  decoration: boxDecoration(Colors.white, 20),
                  margin: EdgeInsets.only(left: 5,right: 5),

                  child: new TabBar(
                    controller: _controller,
                    isScrollable: false,
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 50.0,color:SecondarySubColor),
                        insets: EdgeInsets.symmetric(horizontal:20.0)
                    ),
                    tabs: [
                      new Tab(
                          child: tabHead('Table',size)
                      ),
                      GestureDetector(
                        onTap: (){
                          fnGetTakeAway();
                        },
                        child: new Tab(
                          child: tabHead('Takeaway',size),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          fnGetDelivery();
                        },
                        child: new Tab(
                          child: tabHead('Delivery',size),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  height: size.height*0.73,
                  padding: EdgeInsets.only(left: 5,right: 5),
                  child: new TabBarView(
                    controller: _controller,
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.all(20),
                        child:  SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 5,right: 5),
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: size.width,
                                      child: new FutureBuilder<dynamic>(
                                        future: futureTable,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return floorView(snapshot);
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
                                    gapH(),
                                    Container(
                                      height:  g.fnValCheck(lstrMultiTable) ? size.height*0.45 : size.height*0.64,
                                      width: size.width,
                                      child: new FutureBuilder<dynamic>(
                                        future: futureTable,
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return tableView(snapshot,size);
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
                                    g.fnValCheck(lstrMultiTable) ? Container(
                                      decoration: boxDecoration(Colors.white, 10),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: size.height*0.08,
                                            child: GridView.count(
                                              crossAxisCount: 5,
                                              childAspectRatio:5/2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10,
                                              children: List.generate(lstrMultiTable.length, (index) {
                                                var datalist =  lstrMultiTable[index];
                                                var code = datalist['TABLE_DESCP'];

                                                return GestureDetector(
                                                  onLongPress: (){
                                                    fnRemoveTable(datalist);
                                                  },
                                                  child: Container(
                                                    decoration: boxBaseDecoration(SecondaryColor, 10),
                                                    child: Center(
                                                      child: tc(datalist['TABLE_DESCP']??'',Colors.black,20),
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              gusestNum('1'),
                                              gusestNum('2'),
                                              gusestNum('3'),
                                              gusestNum('4'),
                                              gusestNum('5'),
                                              gusestNum('6'),
                                              gusestNum('7'),
                                              gusestNum('8'),
                                              gusestNum('9'),
                                              RoundedInputField(
                                                  hintText: 'Guest No',
                                                textType: TextInputType.number,
                                                txtWidth: 0.2,
                                                txtRadius: 5,
                                                txtController: txtGuestNo,
                                              )
                                            ],
                                          ),
                                          gapHC(15),
                                          g.fnValCheck(lstrMultiTable) ?
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [

                                              GestureDetector(
                                                onTap: (){
                                                  g.wstrMenuMode= 'ADD';
                                                  g.wstrOrderMode = 'ADD';
                                                  g.wstrOrderType = 'T';
                                                  g.wstrLastSelectedTables = lstrMultiTable;
                                                  var guestNo  = txtGuestNo.text.isEmpty?'0': txtGuestNo.text.toString() ;
                                                  g.wstrGuestNo = int.parse(guestNo);
                                                  //lstrMultiTable.clear();
                                                  Navigator.pushReplacement(context, NavigationController().fnRoute(6));
                                                },
                                                child: Container(
                                                  width: size.width*0.7,
                                                  height: 50,
                                                  decoration: boxDecoration(PrimaryColor, 10),
                                                  child: Center(
                                                    child: tc('Take Order',Colors.white,18),
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: (){
                                                  fnRemoveAllTable();
                                                },
                                                child: Container(
                                                  width: size.width*0.08,
                                                  height: 50,
                                                  decoration: boxBaseDecoration(Colors.amber, 10),
                                                  child: Center(
                                                    child: Icon(Icons.clear_all_rounded,color: Colors.black,size: 30,),
                                                  ),
                                                ),
                                              )
                                            ],
                                          )
                                              : Container()
                                        ],
                                      ),
                                    ) :Container()
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      new Container(
                          margin: EdgeInsets.only(left: 20,right: 10,top: 0,bottom:0),
                          child: Column(
                            children: [
                              gapH(),
                              Container(
                                height: size.height*0.52,
                                width: size.width,
                                child: new FutureBuilder<dynamic>(
                                  future: futureTakeAway,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return takeAwayView(snapshot);
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
                            ],
                          )
                      ),
                      new Container(
                          margin: EdgeInsets.only(left: 20,right: 10,top: 0,bottom:0),
                          child: Column(
                            children: [
                              gapH(),
                              Container(
                                height: size.height*0.52,
                                width: size.width,
                                child: new FutureBuilder<dynamic>(
                                  future: futureDelivery,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return deliveryView(snapshot);
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
                            ],
                          )
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ), onWillPop: () async{
      SystemNavigator.pop();
      //Navigator.pushReplacement(context, NavigationController().fnRoute(11));
      return true;
    },);
  }

  GestureDetector gusestNum(num) {
    return GestureDetector(
      onTap: (){
        fnNumberPress(num);
      },
      child: Container(
        height: 45,
        width: 40,
        margin: EdgeInsets.only(right: 5),
        decoration: boxBaseDecoration(lstrSelectedGuestNum == num ?Colors.amber: greyLight, 5),
        child: Center(
          child: s3(num),
        ),
      ),
    );
  }

  //api call widgets
  Widget floorView(snapshot){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data['FLOORS'].length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data['FLOORS'][index];
          var floorCode = dataList['CODE'];
          var floorName = dataList['DESCP'];

          return GestureDetector(
            onTap: (){
              fnUpdateFloor(floorCode);
            },
            child:  Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              margin: EdgeInsets.only(right: 10),
              decoration: boxBaseDecoration(lstrSelectedFloor == floorCode ? PrimaryColor :SecondarySubColor, 20),
              child: Center(
                child: tc(floorName, lstrSelectedFloor == floorCode ? Colors.white : PrimaryText,15),
              ),
            ),
          );
        });
  }
  Widget orderView(snapshot){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data['OrderList'].length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data['OrderList'][index];
          var orderCode = dataList['Docno'];

          return GestureDetector(
            onTap: (){
              fnUpdateOrder(snapshot.data,orderCode);
            },
            child:  Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              margin: EdgeInsets.only(right: 10),
              decoration: boxBaseDecoration(lstrSelectedOrderDocNo == orderCode ? PrimaryColor :SecondarySubColor, 20),
              child: Center(
                child: tc(orderCode.toString(), lstrSelectedOrderDocNo == orderCode ? Colors.white : PrimaryText,15),
              ),
            ),
          );
        });
  }
  Widget tableView(snapshot,size){
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(snapshot.data['TABLES'].length, (index) {
      var dataList = snapshot.data['TABLES'][index];
      var tableCode = dataList['CODE'];
      var tableName = dataList['DESCP'];
      var noOfChair = dataList['NOOFPERSON']??0;
      var floorCode = dataList['FLOOR_CODE'];
      var guestNumber = dataList['NO_PEOPLE']??0;
      var tableType = dataList['TYPE'];
      var orderTime = dataList['ORDERTIME'];
      var orderNo = dataList['NO_ORDER'].toString();
        return GestureDetector(
          onTap: (){
            fnTableClick(dataList);
          },
          onDoubleTap: (){
            fnTableSingleClick(dataList);
          },
          child: fnCallTable(noOfChair,tableName,'',guestNumber,tableType,orderNo,orderTime,size),
        ) ;//g.wstrTableView == '1'?
      }),
    );
  }
  Widget itemView(snapshot){

    var itemList = fnGetOrderItems(snapshot);
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          var dataList = itemList[index];
          var orderCode = lstrSelectedOrderDocNo;
          var itemCode = dataList['STKCODE'];
          var itemName = dataList['STKDESCP'];
          var itemQty = dataList['QTY1'].toInt().toString();
          var clearedQty = dataList['CLEARED_QTY'].toInt().toString();
          var itemStatus = dataList['PREP_STATUS'].toString();
          var pendingQty = int.parse(itemQty) - int.parse(clearedQty);
          var sts = "P";
          if(pendingQty == 0){
            sts = "D";
          }else if(int.parse(clearedQty) > 0) {
            sts = "R";
          }else if(pendingQty== clearedQty) {
            sts = "P";
          }

          if(itemStatus == "C"){
            sts = "C";
          }

          return GestureDetector(
            onTap: (){

            },
            child:   Container(
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: boxBaseDecoration(blueLight, 3),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  s2((index+1).toString() +'. '+itemName+'  x'+ itemQty.toString()),
                  Row(
                    children: [
                      // gapW(),
                      // tc( itemQty.toString(),Colors.black,20),
                      // gapWC(10),
                      // tc(clearedQty.toString(),Colors.green,20),
                      // gapWC(10),
                      // tc( pendingQty.toString(),Colors.deepOrange,20),
                      gapWC(10),
                       Container(
                         padding: EdgeInsets.symmetric(horizontal: 30,vertical: 3),
                         decoration: boxDecoration(itemStatus == 'P' ? Colors.white:itemStatus == 'R'? Colors.amber:itemStatus == 'D'? Colors.green: itemStatus == 'C'? Colors.red :Colors.white, 5),
                         child: Center(
                           child: tc(sts == 'P' ? 'PENDING':sts == 'R'? 'PREPARING':sts == 'D'? 'DONE': sts == 'C'?'CANCEL':'',sts == 'P' ? Colors.black:itemStatus == 'R'? Colors.black:sts == 'D'? Colors.white: sts == 'C'? Colors.white :Colors.white,10),
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
  Widget takeAwayView(snapshot){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 5 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data['OrderList'].length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data['OrderList'][index];
          var kotDetails = snapshot.data['TableDet'][index];
          var lstrOrderNo = dataList["Docno"];
          var lstrAddressDetails = dataList["Address"];
          var fName =  lstrAddressDetails[0]['FNAME'];
          var mobNo =  lstrAddressDetails[0]['PHONE1'];
          var mobNo2 =  lstrAddressDetails[0]['PHONE2'];
          var totalAmount =  kotDetails['NETAMT'].toString();
          var phoneNum =  mobNo + ' - ' + mobNo2;
          return GestureDetector(
            onTap: (){
              fnTakeAwayClick(dataList,snapshot.data,lstrOrderNo);
            },
            child: Container(
              height: 60,
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                  width: 10,
                  decoration: boxBaseDecoration(Colors.grey, 10),),
                  gapW(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          tc('Order   #' + lstrOrderNo,Colors.black,15),
                          gapW(),
                          tc('AED  '+ totalAmount,PrimaryColor,15),
                        ],
                      ),

                      clockRow('0.00'),
                      gapHC(10),
                      Row(
                        children: [
                          Icon(Icons.person, size: 20,),
                          gapWC(10),
                          tc(fName,Colors.black,15),
                        ],
                      ),
                      gapHC(5),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 20,),
                          gapWC(10),
                          tc(phoneNum,Colors.black,15),
                        ],
                      ),

                    ],
                  )
                ],
              ),
              decoration: boxDecoration(Colors.white, 15),
            ),
          );
        });
  }
  Widget deliveryView(snapshot){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 5 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data['OrderList'].length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data['OrderList'][index];
          var kotDetails = snapshot.data['TableDet'][index];
          var lstrOrderNo = dataList["Docno"];
          var lstrAddressDetails = dataList["Address"];
          var fName =  lstrAddressDetails[0]['FNAME'];
          var mobNo =  lstrAddressDetails[0]['PHONE1'];
          var mobNo2 =  lstrAddressDetails[0]['PHONE2'];
          var totalAmount =  kotDetails['NETAMT'].toString();
          var phoneNum =  mobNo + ' - ' + mobNo2;
          return GestureDetector(
            onTap: (){
              fnDeliveryClick(dataList,snapshot.data,lstrOrderNo);
            },
            child: Container(
              height: 60,
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    decoration: boxBaseDecoration(Colors.grey, 10),),
                  gapW(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          tc('Order   #' + lstrOrderNo,Colors.black,15),
                          gapW(),
                          tc('AED  '+ totalAmount,PrimaryColor,15),
                        ],
                      ),

                      clockRow('0.00'),
                      gapHC(10),
                      Row(
                        children: [
                          Icon(Icons.person, size: 20,),
                          gapWC(10),
                          tc(fName,Colors.black,15),
                        ],
                      ),
                      gapHC(5),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 20,),
                          gapWC(10),
                          tc(phoneNum,Colors.black,15),
                        ],
                      ),

                    ],
                  )
                ],
              ),
              decoration: boxDecoration(Colors.white, 15),
            ),
          );
        });
  }

  //widgets
  Column tableDialogChild() => Column(
    children: [
      Container(
        height: 45,
        padding: EdgeInsets.all(10),
        decoration: boxDecoration(Colors.white, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tc('Table : ' +lstrSelectedTableNo, Colors.black, 18),
            Row(
              children: [
                tc(lstrSelectedOrderNo.toString(), Colors.black, 18),
                gapWC(5),
                Icon(Icons.confirmation_number,color: Colors.black,)
              ],
            )
          ],
        ),
      ),
      gapH(),
      Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              child: new FutureBuilder<dynamic>(
                future: futureOrder,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return orderView(snapshot);
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
            gapHC(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                h3('ORDER ' + lstrSelectedOrderDocNo.toString() ),
                h3('TABLE   '  +lstrOrderTables),
              ],
            ),
            gapH(),
            Container(
              height: 320,
              child: new FutureBuilder<dynamic>(
                future: futureOrder,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return itemView(snapshot);
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

          ],
        ),
      ),
      gapH(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          clockRow('0.00'),
          tc('Qty',Colors.black,12),
          tc('Done',Colors.green,12),
          tc('Preparing',Colors.deepOrange,12),
          h1(lstrTotalAmount),
        ],
      ),
      gapH(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          GestureDetector(
            onTap: (){
              g.wstrMenuMode= 'CANCEL';
              g.wstrOrderMode = 'CANCEL';
              g.wstrOrderType = 'T';
              g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
              g.wstrLastSelectedTables = lstrSelectedTabels;
              g.wstrLastMenuItems = lstrSelectedItems;
              Navigator.pushReplacement(context, NavigationController().fnRoute(8));
            },
            child: Container(
              height: 70,
              width: 100,
              decoration: boxBaseDecoration(SecondarySubColor, 5),
              child: Center(
                child: Icon(Icons.cancel_outlined,color: PrimaryColor,),
              ),
            ),
          ),

          Container(
            height: 70,
            width: 100,
            decoration: boxBaseDecoration(SecondarySubColor, 5),
            child: Center(
              child: Icon(Icons.print,color: PrimaryColor,),
            ),
          ),
          GestureDetector(
            onTap: (){
              g.wstrMenuMode= 'EDIT';
              g.wstrOrderMode = 'EDIT';
              g.wstrOrderType = 'T';
              g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
              g.wstrLastSelectedTables = lstrSelectedTabels;
              g.wstrLastMenuItems = lstrSelectedItems;
              Navigator.pushReplacement(context, NavigationController().fnRoute(8));
            },
            child: Container(
              height: 70,
              width: 100,
              decoration: boxBaseDecoration(SecondarySubColor, 5),
              child: Center(
                child: Icon(Icons.add_circle,color: PrimaryColor,),
              ),
            ),
          )

        ],
      ),
      gapH(),
    ],
  );
  Column takeawayDialogChild() => Column(
    children: [
      Container(
        height: 45,
        padding: EdgeInsets.all(10),
        decoration: boxDecoration(Colors.white, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tc('Order : ' +lstrSelectedOrderDocNo, Colors.black, 18),
            Row(
              children: [
                tc(lstrSelectedOrderNo.toString(), Colors.black, 18),
                gapWC(5),
                Icon(Icons.confirmation_number,color: Colors.black,)
              ],
            )
          ],
        ),
      ),
      gapH(),
      Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapHC(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                h3('Name  ' + lstrSelectedName.toString() ),
                h3('   '  +lstrSelectedMob.toString()),
              ],
            ),
            gapH(),
            Container(
              height: 320,
              child: new FutureBuilder<dynamic>(
                future: futureTakeAway,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return itemView(snapshot);
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

          ],
        ),
      ),
      gapH(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          clockRow('0.00'),
          h1(lstrTotalAmount),
        ],
      ),
      gapH(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
            height: 70,
            width: 100,
            decoration: boxBaseDecoration(SecondarySubColor, 5),
            child: Center(
              child: Icon(Icons.local_fire_department_sharp,color: PrimaryColor,),
            ),
          ),
          Container(
            height: 70,
            width: 100,
            decoration: boxBaseDecoration(SecondarySubColor, 5),
            child: Center(
              child: Icon(Icons.print,color: PrimaryColor,),
            ),
          ),
          GestureDetector(
            onTap: (){
              g.wstrMenuMode= 'EDIT';
              g.wstrOrderMode = 'EDIT';
              g.wstrOrderType = 'A';
              g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
              g.wstrLastMenuItems = lstrSelectedItems;
              g.wstrLastSelectedAdd = lstrSelectedAddress;
              g.wstrLastSelectedTables = [];
              Navigator.pushReplacement(context, NavigationController().fnRoute(8));
            },
            child: Container(
              height: 50,
              width: 150,
              decoration: boxBaseDecoration(SecondarySubColor, 5),
              child: Center(
                child: Icon(Icons.add_circle,color: PrimaryColor,),
              ),
            ),
          )

        ],
      ),
      gapH(),
    ],
  );
  Column deliveryDialogChild() => Column(
    children: [
      Container(
        height: 45,
        padding: EdgeInsets.all(10),
        decoration: boxDecoration(Colors.white, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tc('Order : ' +lstrSelectedOrderDocNo, Colors.black, 18),
            Row(
              children: [
                tc(lstrSelectedOrderNo.toString(), Colors.black, 18),
                gapWC(5),
                Icon(Icons.confirmation_number,color: Colors.black,)
              ],
            )
          ],
        ),
      ),
      gapH(),
      Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            gapHC(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                h3('Name  ' + lstrSelectedName.toString() ),
                h3('   '  +lstrSelectedMob.toString()),
              ],
            ),
            gapH(),
            Container(
              height: 320,
              child: new FutureBuilder<dynamic>(
                future: futureDelivery,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return itemView(snapshot);
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

          ],
        ),
      ),
      gapH(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          clockRow('0.00'),
          h1(lstrTotalAmount),
        ],
      ),
      gapH(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Container(
            height: 70,
            width: 100,
            decoration: boxBaseDecoration(SecondarySubColor, 5),
            child: Center(
              child: Icon(Icons.cancel_outlined,color: PrimaryColor,),
            ),
          ),
          Container(
            height: 70,
            width: 100,
            decoration: boxBaseDecoration(SecondarySubColor, 5),
            child: Center(
              child: Icon(Icons.print,color: PrimaryColor,),
            ),
          ),
          GestureDetector(
            onTap: (){
              g.wstrMenuMode= 'EDIT';
              g.wstrOrderMode = 'EDIT';
              g.wstrOrderType = 'A';
              g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
              g.wstrLastMenuItems = lstrSelectedItems;
              g.wstrLastSelectedAdd = lstrSelectedAddress;
              g.wstrLastSelectedTables = [];
              Navigator.pushReplacement(context, NavigationController().fnRoute(6));
            },
            child: Container(
              height: 70,
              width: 100,
              decoration: boxBaseDecoration(SecondarySubColor, 5),
              child: Center(
                child: Icon(Icons.add_circle,color: PrimaryColor,),
              ),
            ),
          )

        ],
      ),
      gapH(),
    ],
  );
  Container itemListCard(text) {
    return Container(padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
            decoration: boxBaseDecoration(Colors.white, 3),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                s2(text+'. Item Name x 5'),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 3),
                      decoration: boxDecoration(SecondarySubColor, 5),
                      child: Center(
                        child: tc('-',Colors.black,15),
                      ),
                    ),
                    gapW(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30,vertical: 3),
                      decoration: boxDecoration(SubColor, 5),
                      child: Center(
                        child: tc('+',Colors.white,15),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
  }
  Container tabHead(name,size) => Container(
    width: size.width * 0.3,
    height: 40,
    padding: EdgeInsets.all(5),

    child: Center(
      child: tc(name,Colors.black,15),

    ),
  );
  Container cardTabHead(name) => Container(
    height: 40,
    padding: EdgeInsets.all(5),

    child: Center(
      child: tc(name,PrimaryColor,10),

    ),
  );

  //dialog
  Column showGuest() => Column(
    children: [
      Container(
        height: 45,
        padding: EdgeInsets.all(10),
        decoration: boxDecoration(SecondaryColor, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tc('Table : A1', Colors.black, 18),
            Row(
              children: [
                tc('4', Colors.black, 18),
                gapWC(5),
                Icon(Icons.people_alt_outlined,color: Colors.black,)
              ],
            )
          ],
        ),
      ),
      gapH(),

    ],
  );
  //other Function
  Widget fnCallTable(chair,oChair,mode,name,type,order,time,size){
    if(type == 'S'){
      return tableSquare(chair,oChair,mode,name,int.parse(order),time,size);
    }else if(type == 'R'){
      return tableRound(chair,oChair,mode,name,'');
    }else if(type == 'L'){
      return tableRectangle(chair,oChair,mode,name);
    }else{
      return Container();
    }
  }

  //table
  fnTableSingleClick(dataList){
    var orderNo = int.parse(dataList['NO_ORDER'].toString()) ;
    var tableCode = dataList['CODE'];
    var tableName = dataList['DESCP'];
    if(orderNo != 0){
      setState(() {
        lstrSelectedTableNo = tableCode;
        lstrSelectedOrderNo = orderNo.toString();
        fnGetTableItems(tableCode,'T');
      });

    }

  }
  fnTableClick(dataList){

    var orderNo = int.parse(dataList['NO_ORDER'].toString()) ;
    var tableCode = dataList['CODE'];
    var tableName = dataList['DESCP'];
    var noOfGuest = dataList['NO_PEOPLE'];
    var noOfChair = dataList['NOOFPERSON'];
    var selectedTable = fnCheckTable(tableCode);

    if(!g.fnValCheck(selectedTable)){
      setState(() {
        lstrMultiTable.add({
          "COMPANY":g.wstrCompany.toString(),
          "YEARCODE":g.wstrYearcode.toString(),
          "SRNO":"0",
          "TABLE_CODE":tableCode.toString(),
          "TABLE_DESCP":tableName.toString(),
          "GUEST_NO":"",
          "NO_PEOPLE":noOfGuest,
          "NOOFPERSON":noOfChair,
          "STATUS":"P",
        });
      });
    }
    print(lstrMultiTable);

  }
  fnCheckTable(tableCode){
    var selectedData ;
    if(g.fnValCheck(lstrMultiTable)){
      for (var e in lstrMultiTable) {
        var lcode = e["TABLE_CODE"].toString();
        if( tableCode == lcode ){
          selectedData = e;
          break;
        }
      }
    }
    return selectedData;
  }
  fnRemoveTable(dataList){
    setState(() {
      lstrMultiTable.remove(dataList);
    });
  }
  fnRemoveAllTable(){
    setState(() {
      lstrSelectedName = '';
      txtGuestNo.clear();
      lstrMultiTable.clear();
    });
  }

  //takeaway
  fnTakeAwayClick(dataList,value,docNo){
    var lstrAddressDetails = dataList["Address"];
    var fName =  lstrAddressDetails[0]['FNAME'];
    var mobNo =  lstrAddressDetails[0]['PHONE1'];
    var mobNo2 =  lstrAddressDetails[0]['PHONE2'];
    setState(() {
      lstrSelectedName = fName??'';
      lstrSelectedMob = mobNo +  '   ' +  mobNo2 ;
      lstrSelectedOrderDocNo = docNo;
    });
    fnGetOrderDetails(value);
    PageDialog().show(context,takeawayDialogChild(),'Order Details');
  }
  fnDeliveryClick(dataList,value,docNo){
    var lstrAddressDetails = dataList["Address"];
    var fName =  lstrAddressDetails[0]['FNAME'];
    var mobNo =  lstrAddressDetails[0]['PHONE1'];
    var mobNo2 =  lstrAddressDetails[0]['PHONE2'];
    setState(() {
      lstrSelectedName = fName??'';
      lstrSelectedMob = mobNo +  '   ' +  mobNo2 ;
      lstrSelectedOrderDocNo = docNo;
    });
    fnGetOrderDetails(value);
    PageDialog().show(context,deliveryDialogChild(),'Order Details');
  }

  fnGetOrderItems(snapshot){

    var dataList = snapshot.data['OrderList'];
    var selectedData = [];
    var selectedTables = [];
    if(g.fnValCheck(dataList)){
      for (var e in dataList) {
        var docNo = e["Docno"].toString();
        if( lstrSelectedOrderDocNo == docNo ){
          lstrSelectedKot.add({
            'DOCNO': docNo
          });

          selectedData = e['Items'];
          break;
        }
      }
    }

    return selectedData;
  }
  fnGetOrderDetails(snapshot){
    lstrTotalAmount = '';
    lstrOrderTables = '';
    lstrSelectedItems = [];
    lstrSelectedTabels = [];
    lstrSelectedAddress = [];

    var dataList = snapshot['OrderList'];
    var selectedData = [];
    var selectedTables = [];
    var selectedAddress = [];
    if(g.fnValCheck(dataList)){
      for (var e in dataList) {
        var docNo = e["Docno"].toString();
        if( lstrSelectedOrderDocNo == docNo ){
          lstrSelectedKot.add({
            'DOCNO': docNo
          });

          selectedData = e['Items'];
          selectedTables  =e['Tables'];
          selectedAddress = e['Address'];
          break;
        }
      }
    }
    var totalAmount = 0.0;
    var totalQty = 0;

    if(g.fnValCheck(selectedData)){
      for (var e in selectedData) {
        var qty = e['QTY1'].toInt().toString();
        var price =  e["RATE"].toString();
        var vat =  e["TAX_AMT"].toString();
        var taxInclYn =  e["TAXINCLUDE_YN"].toString();
        var totAmt =  double.parse(price) * int.parse(qty);
        if(taxInclYn == 'Y'){
          totalAmount =(totalAmount + totAmt );
        }else{
          totalAmount =(totalAmount + totAmt )+ double.parse(vat);
        }

        totalQty = totalQty + int.parse(qty);

        lstrSelectedItems.add({
          "DISHCODE":e['STKCODE'].toString(),
          "DISHDESCP":e['STKDESCP'].toString(),
          "QTY": e['QTY1'].toInt().toString() ,
          "PRICE1":e['RATE'],
          "WAITINGTIME":"",
          "NOTE":e["REF1"],
          "REMARKS":"",
          "PREP_STATUS":e["PREP_STATUS"],
          "PRINT_CODE":e["PRINT_CODE"],
          "UNIT1":e['UNIT1'].toString(),
          "KITCHENCODE":e['KITCHENCODE'],
          "ADDON_YN":e["ADDON_YN"],
          "ADDON_STKCODE":"",
          "NEW":"N",
          "VAT":e["TAX_PER"],
          "TAXINCLUDE_YN":e["TAXINCLUDE_YN"],
          "OLD_STATUS":e["STATUS"],
          "CLEARED_QTY":e["CLEARED_QTY"].toInt().toString(),
          "STATUS":e["STATUS"].toString(),
          "TAXABLE_AMT":e["TAXABLE_AMT"],
          "TAXABLE_AMT":e["TAXABLE_AMT"].toString()
        });
      }
    }

    if(g.fnValCheck(selectedTables)){
      for (var e in selectedTables) {
        lstrSelectedTabels.add({
          "COMPANY":e['COMPANY'],
          "YEARCODE":e['YEARCODE'],
          "SRNO":"0",
          "TABLE_CODE":e['TABLE_CODE'],
          "TABLE_DESCP":e['TABLE_DESCP'],
          "GUEST_NO":e['GUEST_NO'],
          "STATUS":e['STATUS'],
        });
      }
    }
  if(g.fnValCheck(selectedAddress)){
      for (var e in selectedAddress) {
        lstrSelectedAddress.add({
          "COMPANY":e['COMPANY'],
          "YEARCODE":e['YEARCODE'],
          "DOCNO":e['DOCNO'],
          "FNAME":e['FNAME'],
          "LNAME":e['LNAME'],
          "ADDRESS1":e['ADDRESS1'],
          "ADDRESS2":e['ADDRESS2'],
          "ADDRESS3":e['ADDRESS3'],
          "ADDRESS4":e['ADDRESS4'],
          "LANDMARK":e['LANDMARK'],
          "PHONE1":e['PHONE1'],
          "PHONE2":e['PHONE2'],
          "REMARKS":e['REMARKS'],
        });
      }
    }

    var tableName ='';
    for(var e in lstrSelectedTabels){
      var t = e["TABLE_DESCP"];
      tableName =  tableName == "" ? t :t + ','+ tableName ;
    }
    lstrOrderTables = tableName;
    lstrTotalAmount = 'AED  '+ totalAmount.toStringAsFixed(3);

  }
  fnUpdateFloor(floorCode) {
    setState(() {
      lstrSelectedFloor = floorCode;
      fnGetTable();
    });
  }
  fnUpdateOrder(value,ordercode){
    setState(() {
      lstrSelectedOrderDocNo = ordercode;
      Navigator.pop(context);
      fnGetOrderDetails(value);
      PageDialog().show(context,tableDialogChild(),'Order Details');
      //fnGetTable();
    });
  }
  fnGetTableName() {

    var tableName ='';
    for(var e in lstrSelectedTabels){
      var t = e["TABLE_DESCP"];
      tableName =  tableName == "" ? t :t + ','+ tableName ;
    }
    setState(() {
      lstrOrderTables = tableName;
    });
  }
  fnNumberPress(num){
    setState(() {
      lstrSelectedGuestNum = num.toString();
      txtGuestNo.text = num.toString();
    });
  }
  fnTableWiseGuestNum(){


  }
  fnRefresh(){
    fnGetTable();
   // fnGetDelivery();
   // fnGetTakeAway();
  }

  //Api Call
  fnGetUserDetails() async{
    showToast( g.wstrUserCd);
  }
  fnGetTable() async{
    futureTable = apiCall.getTables(g.wstrCompany, g.wstrYearcode ,lstrSelectedFloor,g.wstrUserCd);
    futureTable.then((value) => fnGetTableSuccess(value));
  }
  fnGetTableSuccess(value){
    if(value != null){
      if(value['FLOORS'].length > 0){
        setState(() {
          lstrSelectedFloor = lstrSelectedFloor == ''? lstrSelectedFloor= value['FLOORS'][0]['CODE']:lstrSelectedFloor;
        });
      }
    }

  }

  fnGetTableItems(code,viewType) async{
    futureOrder = apiCall.getTableItems(g.wstrCompany, g.wstrYearcode ,code,viewType);
    futureOrder.then((value) => fnGetTableItemSuccess(value,viewType));
  }
  fnGetTableItemSuccess(value,viewType){

    if(viewType == 'T'){
      if(g.fnValCheck(value)){
        var dataList = value['OrderList'][0];
        var orderCode = dataList['Docno'];
        setState(() {
          lstrSelectedOrderDocNo = orderCode;
        });
        print(value);
        fnGetOrderDetails(value);
        PageDialog().show(context,tableDialogChild(),'Order Details');
      }
    }else{
      print(value);
      setState(() {

      });
    }

  }

  fnGetTakeAway() async{
    futureTakeAway = apiCall.getTableItems(g.wstrCompany, g.wstrYearcode ,'','A');
    futureTakeAway.then((value) => fnGetTakeAwaySuccess(value));
  }
  fnGetTakeAwaySuccess(value){

  }

  fnGetDelivery() async{
    futureDelivery= apiCall.getTableItems(g.wstrCompany, g.wstrYearcode ,'','D');
    futureDelivery.then((value) => fnGetTakeAwaySuccess(value));
  }
  fnGetDeliverySuccess(value){
    setState(() {

    });
  }

  fnSysytemInfo(){

  }

  fnLogout() async{
    final SharedPreferences prefs = await _prefs;

    prefs.setString('wstrUserCd', '');
    prefs.setString('wstrUserName', '');
    prefs.setString('wstrUserRole', '');
    prefs.setString('wstrCompany', '01');
    prefs.setString('wstrYearcode', '2022');
    prefs.setString('wstrLoginSts', 'N');
    prefs.setString('wstrTableView','');

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Login()
    ));
  }


}
