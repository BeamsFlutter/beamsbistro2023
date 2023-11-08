
import 'dart:async';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/responsiveHelper.dart';
import 'package:beamsbistro/Views/Pages/Login/userLogin.dart';
import 'package:beamsbistro/Views/Pages/Menu/menu.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class waiterHome extends StatefulWidget {
  const waiterHome({Key? key}) : super(key: key);

  @override
  _waiterHomeState createState() => _waiterHomeState();
}

class _waiterHomeState extends State<waiterHome> {

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //global

  //api
  late Future<dynamic> futureFloor;
  late Future<dynamic> futureTable;
  late Future<dynamic> futureMultiTable;
  late Future<dynamic> futureOrder;
  late Future<dynamic> futureTakeAway;
  late Future<dynamic> futureDelivery;
  late Future<dynamic> futureFinishOrder;
  var  apiCall = ApiCall();
  Global g = Global();

  // page Variables
  var bottomIndex = 0;
  var lstrSelectedFloor;
  var lstrSelectedTableNo = '' ;
  var lstrSelectedOrderNo = '' ;
  var lstrSelectedOrderDocNo = '' ;
  var lstrSelectedName = '' ;
  var lstrSelectedMob = '' ;
  var lstrTotalAmount = '' ;
  var lstrOrderTables = '' ;
  var lstrSelectedGuestNum = '' ;

  var lstrMultiTable = [] ;
  var lstrSelectedItems = [];
  var lstrSelectedTabels= [];
  var lstrSelectedKot= [];
  var lstrSelectedAddress= [];

  //print
  var lstrPrintDocno = '';
  var lstrPrintDoctype = '';
  var lstrPrintYearcode = '';
  bool kotPrint  = true;

  //Controller
  var txtGuestNo = TextEditingController();


  late Timer timer;
  int counter = 0;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: mainAppBarMobile(fnLogout,g.wstrUserName + ' - '+ g.wstrShifDescp,fnSysytemInfo),
      bottomNavigationBar:  BottomNavigationBar(
        backgroundColor: SecondaryColor,
        currentIndex: bottomIndex,
        elevation: 30,
        selectedItemColor: PrimaryColor,
        unselectedItemColor: Colors.black,
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            label: 'TABLE',
             tooltip: 'Table',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: 'TAKE AWAY',
              tooltip: 'Take Away'

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'DELIVERY',
              tooltip: 'Delivery'
          ),
        ],
        onTap: fnBottomNavClick,
      ),
      body: ResponsiveWidget(
        mobile: Container(
          color: Colors.white,
          height: size.height,
          width: size.width,
          padding: pageMargin(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Table
                bottomIndex == 0? Container(
                  height: size.height * 0.85,
                  width: size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc('Tables',Colors.black,30),
                        gapHC(5),
                        tableStatus(size),
                        new Container(
                          child:  SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top:10),
                                  height: 40,
                                  width: size.width,
                                  child: floorFuture(),
                                ),
                                gapHC(10),
                                Container(
                                  height:  g.fnValCheck(lstrMultiTable) ? size.height*0.42 : size.height*0.6,
                                  width: size.width ,
                                  child: tableFuture(size),
                                ),
                                g.fnValCheck(lstrMultiTable) ? multiTableSelection(size, context) :Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : bottomIndex == 1?Container(
                  height: size.height*0.83,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc('Take Away',Colors.black,30),
                        gapHC(5),
                        Container(
                          height: size.height* 0.08,
                          padding: EdgeInsets.all(10),
                          decoration: boxBaseDecoration(appLight, 10),
                          child: takwAwayStatus(),
                        ),
                        gapHC(5),
                        Container(
                          height: size.height*0.63,
                          width: size.width,
                          child: takeAwayFuture(),
                        ),
                        takeawayButton(context)

                      ],
                    ),
                  ),

                )
                    : Container(
                  height: size.height*0.83,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc('Delivery',Colors.black,30),
                        gapHC(5),
                        Container(
                          height: size.height* 0.08,
                          padding: EdgeInsets.all(10),
                          decoration: boxBaseDecoration(appLight, 10),
                          child: takwAwayStatus(),
                        ),
                        gapHC(5),
                        Container(
                          height: size.height*0.63,
                          width: size.width,
                          child: deliveryFuture(),
                        ),
                        deliveryButton(context)

                      ],
                    ),
                  ),

                )
              ],
            ),
          ),
        ),
        tab: Container(
        color: Colors.white,
        height: size.height,
        width: size.width,
        padding: pageMargin(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Table
              bottomIndex == 0? Container(
                height: size.height * 0.88,
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tc('Tables',Colors.black,30),
                    gapHC(5),
                    tableStatus(size),
                    new Container(
                      child:  SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top:10),
                              height: 40,
                              width: size.width,
                              child: floorFuture(),
                            ),
                            gapHC(10),
                            Container(
                              height:  g.fnValCheck(lstrMultiTable) ? size.height*0.52 : size.height*0.65,
                              width: size.width ,
                              child: tableFuture(size),
                            ),
                            g.fnValCheck(lstrMultiTable) ? multiTableSelection(size, context) :Container(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : bottomIndex == 1?Container(
                height: size.height*0.88,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      tc('Take Away',Colors.black,30),
                      gapHC(5),
                      Container(
                        height: size.height* 0.08,
                        padding: EdgeInsets.all(10),
                        decoration: boxBaseDecoration(appLight, 10),
                        child: takwAwayStatus(),
                      ),
                      gapHC(5),
                      Container(
                        height: size.height*0.7,
                        width: size.width,
                        child: takeAwayFuture(),
                      ),
                      takeawayButton(context)

                    ],
                  ),
                ),

              )
                  : Container(
                height: size.height*0.88,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      tc('Delivery',Colors.black,30),
                      gapHC(5),
                      Container(
                        height: size.height* 0.08,
                        padding: EdgeInsets.all(10),
                        decoration: boxBaseDecoration(appLight, 10),
                        child: takwAwayStatus(),
                      ),
                      gapHC(5),
                      Container(
                        height: size.height*0.7,
                        width: size.width,
                        child: deliveryFuture(),
                      ),
                      deliveryButton(context)

                    ],
                  ),
                ),

              )
            ],
          ),
        ),
      ),
        windows: Container(
          color: Colors.white,
          height: size.height,
          width: size.width,
          padding: pageMargin(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                //Table
                bottomIndex == 0? Container(
                  height: size.height * 0.87,
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      tc('Tables',Colors.black,30),
                      gapHC(5),
                      tableStatus(size),
                      new Container(
                        child:  SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top:10),
                                height: 40,
                                width: size.width,
                                child: floorFuture(),
                              ),
                              gapHC(10),
                              Container(
                                height:  g.fnValCheck(lstrMultiTable) ? size.height*0.52 : size.height*0.65,
                                width: size.width ,
                                child: tableFuture(size),
                              ),
                              g.fnValCheck(lstrMultiTable) ? multiTableSelection(size, context) :Container(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : bottomIndex == 1?Container(
                  height: size.height*0.86,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc('Take Away',Colors.black,30),
                        gapHC(5),
                        Container(
                          height: size.height* 0.08,
                          padding: EdgeInsets.all(10),
                          decoration: boxBaseDecoration(appLight, 10),
                          child: takwAwayStatus(),
                        ),
                        gapHC(5),
                        Container(
                          height: size.height*0.7,
                          width: size.width,
                          child: takeAwayFuture(),
                        ),
                        takeawayButton(context)

                      ],
                    ),
                  ),

                )
                    : Container(
                  height: size.height*0.86,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc('Delivery',Colors.black,30),
                        gapHC(5),
                        Container(
                          height: size.height* 0.08,
                          padding: EdgeInsets.all(10),
                          decoration: boxBaseDecoration(appLight, 10),
                          child: takwAwayStatus(),
                        ),
                        gapHC(5),
                        Container(
                          height: size.height*0.7,
                          width: size.width,
                          child: deliveryFuture(),
                        ),
                        deliveryButton(context)

                      ],
                    ),
                  ),

                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container multiTableSelection(Size size, BuildContext context) {
    return Container(
                            decoration: boxBaseDecoration(appLight, 10),
                            padding: EdgeInsets.all(5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ts('Selected Tables',Colors.black,15),
                                gapHC(5),
                                Container(
                                  height: size.height*0.05,
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
                                          decoration: boxBaseDecoration(SecondaryColor, 5),
                                          child: Center(
                                            child: tc(datalist['TABLE_DESCP']??'',Colors.black,15),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),

                                ),
                                Row(
                                  children: [
                                    Container(
                                        width: size.width*0.6,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              guestNum('1'),
                                              guestNum('2'),
                                              guestNum('3'),
                                              guestNum('4'),
                                              guestNum('5'),
                                              guestNum('6'),
                                              guestNum('7'),
                                              guestNum('8'),
                                              guestNum('9'),
                                            ],
                                          ),
                                        )
                                    ),
                                    Container(
                                      width: size.width* 0.2,
                                      height: 40,
                                      padding: EdgeInsets.all(5),
                                      decoration: boxBaseDecoration(blueLight, 5),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: txtGuestNo,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,

                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                gapHC(10),
                                Row(
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
                                        width: size.width*0.75,
                                        height: 50,
                                        decoration: boxDecoration(PrimaryColor, 10),
                                        child: Center(
                                          child: tc('Take Order',Colors.white,20),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        fnRemoveAllTable();
                                      },
                                      child: Container(
                                        width: size.width*0.1,
                                        height: 40,
                                        child: Center(
                                          child: Icon(Icons.cancel_outlined,color: Colors.black,size: 30,),
                                        ),
                                      ),
                                    )
                                  ],
                                )

                              ],
                            ),
                          );
  }
  FutureBuilder<dynamic> tableFuture(Size size) {
    return new FutureBuilder<dynamic>(
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
                            );
  }
  FutureBuilder<dynamic> floorFuture() {
    return new FutureBuilder<dynamic>(
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
                            );
  }
  Container tableStatus(Size size) {
    return Container(
                    height: size.height* 0.12,
                    padding: EdgeInsets.all(10),
                    decoration: boxBaseDecoration(appLight, 10),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.album_rounded,color: Colors.green,size: 20,),
                              gapWC(10),
                              ts(' Free Table',Colors.black,15)
                            ],
                          ),
                          gapHC(5),
                          Row(
                            children: [
                              Icon(Icons.album_rounded,color: Colors.amber,size: 20,),
                              gapWC(10),
                              ts(' Preparation Pending',Colors.black,15)
                            ],
                          ),
                          gapHC(5),
                          Row(
                            children: [
                              Icon(Icons.album_rounded,color: Colors.blue,size: 20,),
                              gapWC(10),
                              ts(' Preparation Finished',Colors.black,15)
                            ],
                          )
                        ],
                      ),
                    ),
                  );
  }
  SingleChildScrollView takwAwayStatus() {
    return SingleChildScrollView(
                          child: Column(
                            children: [

                              Row(
                                children: [
                                  Icon(Icons.album_rounded,color: Colors.amber,size: 20,),
                                  gapWC(10),
                                  ts(' Preparation Pending',Colors.black,15)
                                ],
                              ),
                              gapHC(5),
                              Row(
                                children: [
                                  Icon(Icons.album_rounded,color: Colors.blue,size: 20,),
                                  gapWC(10),
                                  ts(' Preparation Finished',Colors.black,15)
                                ],
                              )
                            ],
                          ),
                        );
  }

  FutureBuilder<dynamic> deliveryFuture() {
    return new FutureBuilder<dynamic>(
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
                        );
  }
  FutureBuilder<dynamic> takeAwayFuture() {
    return new FutureBuilder<dynamic>(
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
                        );
  }
  GestureDetector deliveryButton(BuildContext context) {
    return GestureDetector(
                      onTap: (){
                        g.wstrOrderType = 'D';
                        g.wstrOrderMode = 'ADD';
                        g.wstrMenuMode = 'ADD';
                        g.wstrLastSelectedAdd = [];
                        g.wstrLastSelectedTables = [];
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Menu()));
                      },
                      child: Container(
                        height: 50,
                        decoration: boxBaseDecoration(PrimaryColor, 10),
                        child: Center(
                          child: tc('Take Order',Colors.white,20),
                        ),
                      ),
                    );
  }
  GestureDetector takeawayButton(BuildContext context) {
    return GestureDetector(
                      onTap: (){
                        g.wstrOrderType = 'A';
                        g.wstrOrderMode = 'ADD';
                        g.wstrMenuMode = 'ADD';
                        g.wstrLastSelectedAdd = [];
                        g.wstrLastSelectedTables = [];
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Menu()));
                      },
                      child: Container(
                        height: 50,
                        decoration: boxBaseDecoration(PrimaryColor, 10),
                        child: Center(
                          child: tc('Take Order',Colors.white,20),
                        ),
                      ),
                    );
  }
  //Widgets
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
          var status = dataList['STATUS'].toString();
          var pendingQty = int.parse(itemQty) - int.parse(clearedQty);
          var Qty  =  dataList['QTY1']??0;
          var pQty  =  dataList['P_QTY']??0;
          var rQty  =  dataList['R_QTY']??0;
          var cQty  =  dataList['C_QTY']??0;
          var dQty  =  dataList['D_QTY']??0;


          var sts = "P";

          if(pQty > 0){
            sts  = 'P';
          }else if(rQty > 0){
            sts  = 'R';
          }
          if(dQty >0){
            if((Qty - cQty) == dQty){
              sts  = 'D';
            }
          }


          if(status == "C"){
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
                        decoration: boxDecoration(sts == 'P' ? Colors.white:sts == 'R'? Colors.amber:sts == 'D'? Colors.green: sts == 'C'? Colors.red :Colors.white, 5),
                        child: Center(
                          child: tc(sts == 'P' ? 'PENDING':sts == 'R'? 'PREPARING':sts == 'D'? 'DONE': sts == 'C'?'CANCEL':'',sts == 'P' ? Colors.black:sts == 'R'? Colors.black:sts == 'D'? Colors.white: sts == 'C'? Colors.white :Colors.white,10),
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
            childAspectRatio: 1.8,
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
          var carNum =    kotDetails['ADDRESS4']??'';
          var phoneNum =  mobNo + ' - ' + mobNo2;
          return GestureDetector(
            onTap: (){
              fnTakeAwayClick(dataList,snapshot.data,lstrOrderNo);
            },
            child: Container(
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
                      gapHC(5),
                      clockRow('0.00'),
                      gapHC(10),
                      Row(
                        children: [
                          Icon(Icons.person, size: 15,),
                          gapWC(10),
                          tc(fName,Colors.black,15),
                        ],
                      ),
                      gapHC(5),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 15,),
                          gapWC(10),
                          tc(phoneNum,Colors.black,15),
                        ],
                      ),
                      gapHC(5),
                      Row(
                        children: [
                          Icon(Icons.directions_car, size: 15,),
                          gapWC(10),
                          tc(carNum,Colors.black,15),
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
            childAspectRatio: 1.8,
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
  Widget tableView(snapshot,size){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio:1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 15),
        itemCount:  snapshot.data['TABLES'].length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data['TABLES'][index];
          var tableCode = dataList['CODE'];
          var tableName = dataList['DESCP'];
          var noOfChair = dataList['NOOFPERSON']??0;
          var floorCode = dataList['FLOOR_CODE'];
          var guestNumber = dataList['NO_PEOPLE']??0;
          var tableType = dataList['TYPE'];
          var orderTime = dataList['ORDERTIME'];
          var orderNo = dataList['NO_ORDER'].toString();
          var status = dataList['TABLE_STATUS']??"E";
          var mode = 'E';

          mode = status;


          return GestureDetector(
            onTap: (){
              fnTableSingleClick(dataList);
            },
            onDoubleTap: (){
              fnTableDoubleClick(dataList);
            },
            child: fnCallTable(noOfChair,tableName,mode,guestNumber,tableType,orderNo,orderTime,size),
          ) ;
        });
  }

  GestureDetector guestNum(num) {
    return GestureDetector(
      onTap: (){
        fnNumberPress(num);
      },
      child: Container(
        height: 44,
        width: 40,
        margin: EdgeInsets.only(right: 5),
        decoration: boxBaseDecoration(lstrSelectedGuestNum == num ?Colors.amber: greyLight, 5),
        child: Center(
          child: tc(num,Colors.black,15),
        ),
      ),
    );
  }
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
      gapHC(10),
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
                s3('ORDER ' + lstrSelectedOrderDocNo.toString() ),
                s3('TABLE   '  +lstrOrderTables),
              ],
            ),
            gapH(),
            ResponsiveWidgetAlert(mobile: Container(
              height: 340,
              child: futureItemView(),
            ), tab: Container(
              height: 580,
              child: futureItemView(),
            ), windows: Container(
              height: 580,
              child: futureItemView(),
            ))
            ,

          ],
        ),
      ),
      gapH(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          clockRow('0.00'),
          tc('Qty',Colors.black,15),
          h1(lstrTotalAmount),
        ],
      ),
      gapHC(15),
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
              height: 50,
              width: 100,
              decoration: boxBaseDecoration(PrimaryColor, 5),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tc('Cancel',Colors.white,15)
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              setState(() {
                lstrPrintDocno = lstrSelectedOrderDocNo;
                lstrPrintDoctype = "KOT";
                lstrPrintYearcode = g.wstrYearcode;
              });
              fnPrintCall();
              //fnFinishOrder(lstrSelectedOrderDocNo, "KOT", g.wstrYearcode);
            },
            child:
            Container(
              height: 50,
              width: 200,
              decoration: boxBaseDecoration(Colors.green, 5),
              child: Center(
                child: tc('Print',Colors.white,15),
              ),
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
              height: 50,
              width: 100,
              decoration: boxBaseDecoration(greyLight, 5),
              child: Center(
                child: Icon(Icons.add_circle,color: PrimaryColor,),
              ),
            ),
          )

        ],
      ),
      gapHC(15),
    ],
  );
  FutureBuilder<dynamic> futureItemView() {
    return new FutureBuilder<dynamic>(
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
            );
  }

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

            ResponsiveWidgetAlert(
              mobile:  Container(
              height: 340,
              child: futureItemTakeAway(),
            ),
              tab:  Container(
              height: 550,
              child: futureItemTakeAway(),
            ),
              windows:  Container(
                height: 550,
                child: futureItemTakeAway(),
              ),)
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
      gapHC(15),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          GestureDetector(
            onTap: (){
              g.wstrMenuMode= 'CANCEL';
              g.wstrOrderMode = 'CANCEL';
              g.wstrOrderType = 'A';
              g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
              g.wstrLastSelectedTables = lstrSelectedTabels;
              g.wstrLastMenuItems = lstrSelectedItems;
              Navigator.pushReplacement(context, NavigationController().fnRoute(8));
            },
            child: Container(
              height: 50,
              width: 100,
              decoration: boxBaseDecoration(PrimaryColor, 5),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tc('Cancel',Colors.white,15)
                  ],
                ),
              ),
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
              width: 100,
              decoration: boxBaseDecoration(greyLight, 5),
              child: Center(
                child: Icon(Icons.add_circle,color: PrimaryColor,),
              ),
            ),
          )

        ],
      ),

      gapHC(15),
    ],
  );
  FutureBuilder<dynamic> futureItemTakeAway() {
    return new FutureBuilder<dynamic>(
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
            );
  }

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
            gapHC(15),
            ResponsiveWidgetAlert(
              mobile:  Container(
                height: 340,
                child: futureItemDelivery(),
              ),
              tab:  Container(
                height: 580,
                child: futureItemDelivery(),
              ),
              windows:  Container(
                height: 580,
                child: futureItemDelivery(),
              ),)

          ],
        ),
      ),
      gapHC(15),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          clockRow('0.00'),
          h1(lstrTotalAmount),
        ],
      ),
      gapHC(15),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          GestureDetector(
            onTap: (){
              g.wstrMenuMode= 'CANCEL';
              g.wstrOrderMode = 'CANCEL';
              g.wstrOrderType = 'D';
              g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
              g.wstrLastSelectedTables = lstrSelectedTabels;
              g.wstrLastMenuItems = lstrSelectedItems;
              Navigator.pushReplacement(context, NavigationController().fnRoute(8));
            },
            child: Container(
              height: 50,
              width: 100,
              decoration: boxBaseDecoration(PrimaryColor, 5),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tc('Cancel',Colors.white,15)
                  ],
                ),
              ),
            ),
          ),

          GestureDetector(
            onTap: (){
              g.wstrMenuMode= 'EDIT';
              g.wstrOrderMode = 'EDIT';
              g.wstrOrderType = 'D';
              g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
              g.wstrLastMenuItems = lstrSelectedItems;
              g.wstrLastSelectedAdd = lstrSelectedAddress;
              g.wstrLastSelectedTables = [];
              Navigator.pushReplacement(context, NavigationController().fnRoute(6));
            },
            child: Container(
              height: 50,
              width: 100,
              decoration: boxBaseDecoration(greyLight, 5),
              child: Center(
                child: Icon(Icons.add_circle,color: PrimaryColor,),
              ),
            ),
          )

        ],
      ),
      gapHC(15),
    ],
  );
  FutureBuilder<dynamic> futureItemDelivery() {
    return new FutureBuilder<dynamic>(
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
            );
  }


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

  
  //page Functions
  void fnBottomNavClick(int index) {
    setState(() {
      bottomIndex = index;
    });

    if(bottomIndex == 0){
      fnGetTable();
    }else if(bottomIndex == 1){
      fnGetTakeAway();
    }else{
      fnGetDelivery();
    }

  }

  //table
  fnTableDoubleClick(dataList){
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

  }
  fnTableSingleClick(dataList){

    var orderNo = int.parse(dataList['NO_ORDER'].toString()) ;
    var tableCode = dataList['CODE'];
    var tableName = dataList['DESCP'];
    var noOfGuest = dataList['NO_PEOPLE'];
    var noOfChair = dataList['NOOFPERSON'];
    var selectedTable = fnCheckTable(tableCode);

    if(g.fnValCheck(lstrMultiTable)){
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
    }else{
      if(orderNo != 0){
        setState(() {
          lstrSelectedTableNo = tableCode;
          lstrSelectedOrderNo = orderNo.toString();
          fnGetTableItems(tableCode,'T');
        });
      }else{
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
    }





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
    PageDialog().showItems(context,takeawayDialogChild(),'Order Details');
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
    PageDialog().showItems(context,deliveryDialogChild(),'Order Details');
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
      PageDialog().showItems(context,tableDialogChild(),'Order Details');
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
    fnGetTakeAway();
  }

  fnSysytemInfo(){
    PageDialog().showSysytemInfo(context, Container(
      child: Column(

        children: [

          Row(
            children: [
              Icon(Icons.person_outline,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrUserName.toString(),Colors.black,20)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.access_time_outlined,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrShifDescp.toString(),Colors.black,20)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.laptop,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrDeviceName.toString(),Colors.black,20)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.confirmation_number_outlined,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrDeivceId.toString(),Colors.black,20)
            ],
          )
        ],
      ),
    ), 'System Info');
  }

  //api Call
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
        PageDialog().showItems(context,tableDialogChild(),'Order Details');
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

  fnFinishOrder(docno, doctype, yearcode){
    futureFinishOrder = apiCall.finishOrder(g.wstrCompany,docno, doctype, yearcode);
    futureFinishOrder.then((value) =>  fnFinishOrderSuccess(value));
  }
  fnFinishOrderSuccess(value){

    if(g.fnValCheck(value)){
      var data = value[0];
      var sts = data["STATUS"];
      var msg = data["MSG"];
      if(sts == "1"){
        fnPrintCall();
      }else{

      }
      showToast( msg);
    }
  }
  fnPrintCall(){
    Navigator.pop(context);
    PageDialog().printDialog(context, fnPrint);
  }

  fnPrint(){
    Navigator.pop(context);
    if(kotPrint){
      setState(() {
        kotPrint = false;
      });
      futureFinishOrder = apiCall.printOrder(g.wstrCompany, lstrPrintDocno, lstrPrintDoctype, lstrPrintYearcode, 1, "");
      futureFinishOrder.then((value) => fnPrintSuccess(value));

    }

  }
  fnPrintSuccess(value){
    setState(() {
      kotPrint = true;
    });
   // Navigator.pop(context);
  }
  //Navigation
  fnLogout() async{
    final SharedPreferences prefs = await _prefs;

    prefs.setString('wstrUserCd', '');
    prefs.setString('wstrUserName', '');
    prefs.setString('wstrUserRole', '');
    prefs.setString('wstrCompany', g.wstrCompany);
    prefs.setString('wstrYearcode', g.wstrYearcode);
    prefs.setString('wstrLoginSts', 'N');
    prefs.setString('wstrTableView','');

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Login()
    ));
  }
  
}
