import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Pages/Kitchen/kitchenDisplay.dart';
import 'package:beamsbistro/Views/Pages/Kitchen/kitchenSelection.dart';
import 'package:beamsbistro/Views/Pages/Login/userLogin.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Kitchen extends StatefulWidget {
  const Kitchen({Key? key}) : super(key: key);

  @override
  _KitchenState createState() => _KitchenState();
}

class _KitchenState extends State<Kitchen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //api
  late Future<dynamic> futureKitchen;
  late Future<dynamic> futurePreparation;
  late Future<dynamic> futureChef;
  late Future<dynamic> futureRefresh;
  var pageCount = 0;
  var refreshTime = '';

  ApiCall apiCall = ApiCall();
  Global g = Global();
  var formatTime = new DateFormat('hh:mm a');
  var formatTimeSecond = new DateFormat('hh:mm:ss a');
  var lstrKitchenCode;

  var lstrKitchenDescp = '';

  //for popup
  var lstrSelectedTableNo = '';
  var lstrSelectedOrderNo = '';
  var lstrSelectedItems = [];
  var lstrSelectedOrderTime = '';
  var lstrSelectedOrderType = '';
  var lstrSelectedType = [];
  var lstrOPenOrders = [];
  var checkedItemList = [];
  var lstrOpenQty = 0.0;
  var lstrLastOpenQty = 0.0;
  var lstrSelectedCheckBox_1 = '';
  var lstrSelectedCheckBox_2 = '';
  var colorChangeT ='B';
  var colorChangeP ='';

  var lstrSaveItems = [];
  var _radioValue = 0;

  var lstrSelectedChef = '';
  var lstrSelectedChefName = '';
  var lstrSelectedMode;
  var passingSelectedMode;

  var lstrSelectedButton = 'R';

  var lstrTime;

  var lastValueLength = 0;

  late AudioCache _audioCache;
  late Timer timer;
  late Timer timerTime;
  int counter = 0;


  String audioasset = "assets/audio/mytune.mp3";
  bool isplaying = false;
  bool audioplayed = false;
  late Uint8List audiobytes;
  AudioPlayer player = AudioPlayer();

  @override
  void dispose() {
    timer.cancel();
    timerTime.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();

    // _audioCache = AudioCache(
    //     prefix: "assets/audio/",
    //     fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));

    Future.delayed(Duration.zero, () async {

      ByteData bytes = await rootBundle.load(audioasset); //load audio from assets
      audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);

    });

    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => fnRefresh());
    timerTime =
        Timer.periodic(Duration(seconds: 1), (Timer t) => fnUpdateTime());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    return WillPopScope(
        child: Scaffold(
          body: Container(
            height: size.height,
            width: size.width,
            margin: EdgeInsets.only(top: 20),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  height: size.height * 0.1,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: boxBaseDecoration(Colors.white, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.asset(
                            "assets/icons/bislogo.png",
                            width: 100,
                          ),
                          h1(''),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          th(
                              '${mfnLng("KITCHEN DISPLAY")} | ' +
                                  g.wstrShifDescp.toString().toUpperCase(),
                              Colors.blue,
                              16),
                          gapWC(20),
                          tcn(lstrTime ?? '', Colors.blue, 16),
                          gapWC(20),
                          GestureDetector(
                            onTap: () {
                              fnChooseKitchen();
                            },
                            child: Container(
                              decoration: boxBaseDecoration(PrimaryColor, 60),
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              height: 35,
                              child: Center(
                                  child: Row(
                                children: [
                                  tc(lstrKitchenDescp, Colors.white, 14),
                                  Icon(
                                    Icons.arrow_drop_down_outlined,
                                    color: Colors.white,
                                  )
                                ],
                              )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              fnSysytemInfo();
                            },
                            child: Container(
                              height: 40,
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: boxBaseDecoration(Colors.amber, 10),
                              child: Icon(
                                Icons.computer_sharp,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                          gapWC(20),
                          GestureDetector(
                            onTap: () {
                              fnLogout();
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: boxBaseDecoration(greyLight, 10),
                              child: Icon(
                                Icons.power_settings_new,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  decoration: boxBaseDecoration(PrimaryColor, 0),
                ),
                Container(
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: boxBaseDecoration(Colors.white, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                fnClickMode('P');
                              },
                              child: kitchenCard(
                                  lstrSelectedButton == 'P' ? 'Y' : 'N',
                                  mfnLng('To Do'),
                                  'P'),
                            ),
                            GestureDetector(
                              onTap: () {
                                fnClickMode('A');
                              },
                              child: kitchenCard(
                                  lstrSelectedButton == 'A' ? 'Y' : 'N',
                                  mfnLng('Open'),
                                  'A'),
                            ),
                            GestureDetector(
                              onTap: () {
                                fnClickMode('R');
                              },
                              child: kitchenCard(
                                  lstrSelectedButton == 'R' ? 'Y' : 'N',
                                  mfnLng('Preparing'),
                                  'R'),
                            ),
                            GestureDetector(
                              onTap: () {
                                fnClickMode('D');
                              },
                              child: kitchenCard(
                                  lstrSelectedButton == 'D' ? 'Y' : 'N',
                                  mfnLng('Completed'),
                                  'D'),
                            ),
                            GestureDetector(
                              onTap: () {
                                fnClickMode('C');
                              },
                              child: kitchenCard(
                                  lstrSelectedButton == 'C' ? 'Y' : 'N',
                                  mfnLng('Canceled'),
                                  'C'),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 300,
                        height: 40,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: size.height * 0.73,
                  width: size.width,
                  padding: pagePadding(),
                  decoration: boxBaseDecoration(greyLight, 0),
                  child: Container(
                    padding: pagePadding(),
                    decoration: boxDecoration(Colors.white, 0),
                    child: FutureBuilder<dynamic>(
                      future: futureKitchen,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return kitchenViewH(snapshot, size);
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
                ),
                Container(
                  height: size.height * 0.05,
                  decoration: boxBaseDecoration(greyLight, 0),
                ),
              ],
            )),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }

  Widget kitchenView(snapshot) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            mainAxisExtent: 400,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data[index];
          var kot = dataList["KOT"];
          var kotDet = dataList["KOTDET"];

          var orderNo = kot[0]["DOCNO"];
          var orderType = kot[0]["ORDER_TYPE"];
          var tableName = kot[0]["TABLE_DET"] ?? '';
          var orderDate = kot[0]["CREATE_DATE"];
          var orderTime =
              formatTime.format(DateTime.parse(kot[0]["CREATE_DATE"]));
          var stsNo = 0;
          if (g.fnValCheck(kotDet)) {
            for (var e in kotDet) {
              var itemStatus = e['STATUS'].toString();
              if (itemStatus == 'R') {
                stsNo = stsNo + 1;
              }
            }
          }

          return GestureDetector(
            onTap: () {
              fnClickOrder(dataList);
            },
            child: Container(
              width: 250,
              margin: EdgeInsets.only(right: 5),
              decoration: boxBaseDecoration(greyLight, 0),
              child: Column(
                children: [
                  Container(
                    height: 30,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: boxBaseDecoration(
                        stsNo == 0 ? Colors.green : Colors.amber, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tc('#' + orderNo.toString(), Colors.white, 12),
                        tc(orderTime.toString(), Colors.white, 15),
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: boxBaseDecoration(
                        stsNo == 0 ? Colors.green : Colors.amber, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        orderType == 'T'
                            ? tc('${mfnLng("Table")} ' + tableName, Colors.white, 18)
                            : orderType == 'A'
                                ? tc(mfnLng('TAKEAWAY'), Colors.white, 18)
                                : tc(mfnLng('DELIVERY'), Colors.white, 18),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_sharp,
                              color: Colors.white,
                              size: 16,
                            ),
                            gapWC(5),
                            tc(fnGetTime(orderDate).toString(), Colors.white,
                                15),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(height: 300, child: itemView(kotDet)),
                ],
              ),
            ),
          );
        });
  }

  Widget kitchenViewH(snapshot, size) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data[index];
          var kot = dataList["KOT"];
          var kotDet = dataList["KOTDET"];
          var voidYn = kot[0]["VOID_YN"];
          var orderNo = kot[0]["DOCNO"];
          var orderType = kot[0]["ORDER_TYPE"];
          var tableName = kot[0]["TABLE_DET"] ?? '';
          var orderDate = kot[0]["CREATE_DATE"];
          var orderTime =
              formatTime.format(DateTime.parse(kot[0]["CREATE_DATE"]));
          var stsNo = 0;
          if (g.fnValCheck(kotDet)) {
            for (var e in kotDet) {
              var itemStatus = e['STATUS'].toString();
              if (itemStatus == 'R') {
                stsNo = stsNo + 1;
              }
            }
          }
          return GestureDetector(
            onTap: () {
              //here
              fnClickOrder(dataList);
            },
            child: Container(
              width: 250,
              margin: EdgeInsets.only(right: 5),
              decoration: boxBaseDecoration(greyLight, 0),
              child: Column(
                children: [
                  Container(
                    height: 30,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: boxBaseDecoration(
                        voidYn == "Y"
                            ? Colors.red
                            : (stsNo == 0 ? Colors.green : Colors.amber),
                        0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tc('#' + orderNo.toString(), Colors.white, 12),
                        tc(orderTime.toString(), Colors.white, 15),
                      ],
                    ),
                  ),
                  Container(
                    height: 30,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: boxBaseDecoration(
                        voidYn == "Y"
                            ? Colors.red
                            : (stsNo == 0 ? Colors.green : Colors.amber),
                        0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        orderType == 'T'
                            ? tc('${mfnLng("Table")} ' + tableName, Colors.white, 18)
                            : orderType == 'A'
                                ? tc(mfnLng('TAKEAWAY'), Colors.white, 18)
                                : tc(mfnLng('DELIVERY'), Colors.white, 18),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_sharp,
                              color: Colors.white,
                              size: 16,
                            ),
                            gapWC(5),
                            tc(fnGetTime(orderDate).toString(), Colors.white,
                                15),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(child: itemView(kotDet))
                ],
              ),
            ),
          );
        });
  }

  Widget itemView(itemList) {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: itemList.length,
        itemBuilder: (context, index) {
          var dataList = itemList[index];
          var itemCode = dataList['STKCODE'];
          var itemDescp = dataList['STKDESCP'];
          var itemQty = dataList['QTY1'].toString();
          var itemStatus = dataList['STATUS'].toString();
          var itemNote = dataList['REF1'].toString();
          var itemPriority = 0;
          return itemName(itemDescp.toString() + '   x  ' + itemQty.toString(),
              itemStatus, itemNote, itemPriority);
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
                                        height: 50,
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

  Container kitchenCard(mode, text, type) => Container(
        height: 35,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        margin: EdgeInsets.only(left: 10),
        decoration: boxBaseDecoration(
            mode == 'Y' ? PrimaryColor : SecondarySubColor, 60),
        child: Center(
          child: th(text, mode == 'Y' ? Colors.white : PrimaryText, 14),
        ),
      );

  fnItemCheckClick(itemList, itemCode) {
    if (fnCheckItem(itemCode)) {
      setState(() {
        lstrSelectedType.remove(itemList);
        checkedItemList.remove(itemList);
      });
    } else {
      setState(() {
        lstrSelectedType.add(itemList);
        checkedItemList.add(itemList);
      });
    }

    Navigator.pop(context);
    PageDialog().showL(context, fnItemChild(context), mfnLng('Kitchen Display'));
    print(lstrSelectedType.length.toString());
  }

  fnChefRadioClick(code, name, index) {
    setState(() {
      _radioValue = index;
      lstrSelectedChef = code;
      lstrSelectedChefName = name;
    });
    Navigator.pop(context);
    PageDialog().showL(context, fnItemChild(context), mfnLng('Kitchen Display'));
  }

  //here
  fnClickOrder(dataList) {
    var kot = dataList["KOT"];
    var kotDet = dataList["KOTDET"];

    var orderNo = kot[0]["DOCNO"];
    var orderType = kot[0]["ORDER_TYPE"];
    var tableName = kot[0]["TABLE_DET"] ?? '';
    var orderDate = kot[0]["CREATE_DATE"];
    var orderTime = formatTime.format(DateTime.parse(kot[0]["CREATE_DATE"]));
    setState(() {
      lstrSelectedOrderNo = orderNo;
      lstrSelectedTableNo = tableName;
      lstrSelectedOrderTime = orderTime;
      lstrSelectedOrderType = orderType;
      lstrSelectedItems = kotDet;
      lstrSelectedType = [];
      lstrSelectedChef = '';
      lstrSelectedChefName = '';
    });

   /* Navigator.push(context, MaterialPageRoute(
        builder: (context) => KitchenDisplay(
          lstrSelectedOrderNo : lstrSelectedOrderNo,
          lstrSelectedTableNo : lstrSelectedTableNo,
          lstrSelectedOrderTime : lstrSelectedOrderTime,
          lstrSelectedOrderType : lstrSelectedOrderType,
          lstrSelectedItems : lstrSelectedItems,
          futureChef : futureChef
        )
    ));*/

    PageDialog().showL(context, KitchenDisplay(
        lstrSelectedOrderNo : lstrSelectedOrderNo,
        lstrSelectedTableNo : lstrSelectedTableNo,
        lstrSelectedOrderTime : lstrSelectedOrderTime,
        lstrSelectedOrderType : lstrSelectedOrderType,
        lstrSelectedItems : lstrSelectedItems,
        futureChef : futureChef,
        lstrSelectedMode : passingSelectedMode.toString().isEmpty ? '':passingSelectedMode,
        fnCallBack:fnCallSave
    ), 'Kitchen Display');


    //here
 //  PageDialog().showL(context, fnItemChild(context), 'Kitchen Display');
  }
  fnCallSave(dataList,mode){
    if(mode == "QUICK"){
      Navigator.pop(context);
    }else{
      fnSavePreparation(dataList);

    }
  }

  fnClickMode(type) {
    setState(() {
      if (type == "A") {
        lstrSelectedMode = null;
        passingSelectedMode = '';
      } else {
        lstrSelectedMode = type;
        passingSelectedMode = type;
      }
      lstrSelectedButton = type;
    });
    fnGetKitchenView();
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

  fnCheckItemDs(itemCode) {
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

  Container ticketCard() {
    return Container(
      width: 250,
      margin: EdgeInsets.only(right: 5),
      decoration: boxBaseDecoration(greyLight, 0),
      child: Column(
        children: [
          Container(
            height: 30,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: boxBaseDecoration(Colors.redAccent, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                tc('#00501', Colors.white, 15),
                tc('11:35 AM', Colors.white, 15),
              ],
            ),
          ),
          Container(
            height: 30,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: boxBaseDecoration(Colors.redAccent, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                tc('Table A1', Colors.white, 15),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_sharp,
                      color: Colors.white,
                      size: 16,
                    ),
                    gapWC(5),
                    tc('4:20', Colors.white, 15),
                  ],
                )
              ],
            ),
          ),
          Container(
            child: Column(
              children: [],
            ),
          ),
        ],
      ),
    );
  }

  fnItemChild(context) {
    setState(() {
      colorChangeP='';
    });

    Size size = MediaQuery.of(context).size;
    var val;
    return Column(
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

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showToast( 'Click'+" "+colorChangeP);
                        colorChangeP='B';
                        _fnSelectNone();
                      });
                    },
                    child: Container(
                      height: 30,
                      width: size.width * 0.15,
                      decoration:  boxDecoration(colorChangeP=='B' ? Colors.black12 : Colors.green,5),
                      child: Center(
                        child: tc('NONE',Colors.black,
                            20),
                      ),
                    ),
                  ),
                  gapWC(30),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showToast( 'Click'+lstrSelectedCheckBox_2);
                        colorChangeT='B';
                      });
                    },
                    child: Container(
                      height: 30,
                      width: size.width * 0.15,
                      decoration: boxDecoration(colorChangeT=='B' ?  Colors.black12  : Colors.green,5),
                      child: Center(
                        child: tc(
                            mfnLng('SELECT ALL'), lstrSelectedCheckBox_2 == 'S' ? Colors.white : Colors.black,
                            20),
                      ),
                    ),
                  ),
                ],
              ),
              gapWC(80),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tc('Order # ' + lstrSelectedOrderNo, Colors.black, 16),
                  gapWC(5),
                  lstrSelectedOrderType == 'T'
                      ? tc('${mfnLng("Table")} ' + lstrSelectedTableNo, PrimaryColor, 15)
                      : lstrSelectedOrderType == 'A'
                          ? tc(mfnLng('TAKEAWAY'), PrimaryColor, 15)
                          : gapWC(5),
                  tc(mfnLng('DELIVERY'), PrimaryColor, 15),
                  gapWC(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.access_time_sharp,
                        color: Colors.black,
                      ),
                      gapWC(5),
                      tc(lstrSelectedOrderTime.toString(), Colors.black, 15),
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
              height: size.height * 0.5,
              width: size.width * 0.35,
              child: itemDetailView(lstrSelectedItems),
            ),
            Container(
              height: size.height * 0.5,
              width: size.width * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: size.width * 0.4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc(mfnLng('SELECT CHEF NAME'), Colors.black, 15),
                        Container(
                          height: size.height * 0.35,
                          child: FutureBuilder<dynamic>(
                            future: futureChef,
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
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //fnSave("R");
                        },
                        child: Container(
                          height: 50,
                          width: size.width * 0.18,
                          decoration: boxDecoration(Colors.green, 10),
                          child: Center(
                            child: tc(mfnLng('START'), Colors.white, 20),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          fnFinishAll();
                        },
                        child: Container(
                          height: 50,
                          width: size.width * 0.18,
                          decoration: boxBaseDecoration(greyLight, 10),
                          child: Center(
                            child: tc(mfnLng('FINISH ALL'), Colors.green, 20),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  //page

  _fnSelectNone(){

    setState(() {
      //lstrSelectedItems = [];
      checkedItemList = [];
    });


  }

  fnGetPageData() {
    setState(() {
      lstrSelectedMode = 'R';
      passingSelectedMode = 'R';
      lstrKitchenCode = g.wstrSelectedkitchen;
      lstrKitchenDescp = g.wstrSelectedkitchenDescp;
    });
    fnGetChef();
    fnGetKitchenView();
  }

  fnSysytemInfo() {
    PageDialog().showSysytemInfo(
        context,
        Container(
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 20,
                    color: Colors.black,
                  ),
                  gapWC(10),
                  tc(g.wstrUserName.toString(), Colors.black, 20)
                ],
              ),
              gapHC(10),
              Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                  gapWC(10),
                  tc(g.wstrShifDescp.toString(), Colors.black, 20)
                ],
              ),
              gapHC(10),
              Row(
                children: [
                  Icon(
                    Icons.laptop,
                    size: 20,
                    color: Colors.black,
                  ),
                  gapWC(10),
                  tc(g.wstrDeviceName.toString(), Colors.black, 20)
                ],
              ),
              gapHC(10),
              Row(
                children: [
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 20,
                    color: Colors.black,
                  ),
                  gapWC(10),
                  tc(g.wstrDeivceId.toString(), Colors.black, 20)
                ],
              )
            ],
          ),
        ),
        'System Info');
  }

  //Other
  fnGetTime(time) {
    var billTime = DateTime.parse(time);
    var now = DateTime.now();
    var diffrence = now.difference(billTime).inSeconds;
    // var minutes = diffrence / 60;
    double minutes = (diffrence / 60);
    double minutesStr = ((minutes % 1) * 60);
    String mmss =
        minutes.toInt().toString() + ':' + minutesStr.toInt().toString();
    return mmss;
  }

  fnChooseKitchen() {
    PageDialog().showS(
        context,
        KitchenSelection(
          fnCallBack: fnUpdateKitchen,
        ),
        'Choose Kitchen');
  }

  fnUpdateKitchen() {
    setState(() {
      lstrKitchenCode = g.wstrSelectedkitchen;
      lstrKitchenDescp = g.wstrSelectedkitchenDescp;
    });
    fnGetKitchenView();
  }

  fnFinishAll() {
    setState(() {
      lstrSelectedType = [];
    });
    for (var e in lstrSelectedItems) {
      var sts = e["STATUS"];
      if (sts == "R") {
        lstrSelectedType.add(e);
      }
    }
    if (!g.fnValCheck(lstrSelectedType)) {
      showToast( mfnLng('No items started yet..'));
      return;
    } else {
      //fnSave("D");
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
    if (g.fnValCheck(lstrSaveItems)) {
      //fnSavePreparation(lstrSaveItems);
    } else {
      showToast( mfnLng('No item selected!'));
    }
  }

  fnRefresh() {
    fnPageRefresh();
  }

  fnUpdateTime() {
    setState(() {
      var now = DateTime.now();
      lstrTime = formatTimeSecond.format(now);
    });
  }

  fnDoneItem(dataList) {
    lstrSelectedChefName = dataList["CHEF_NAME"];
    lstrSelectedChef = dataList["CHEF_CODE"];
    lstrSelectedType = [];
    setState(() {
      lstrSelectedType.add(dataList);
    });
    fnSave("D");
  }

  //api
  fnPageRefresh() {
    futureRefresh = apiCall.pageRefresh(g.wstrCompany, g.wstrYearcode, "WAITER", refreshTime);
    futureRefresh.then((value) => fnPageRefreshSuccess(value));
  }

  fnPageRefreshSuccess(value) {
    var count = 0;
    var timeK = '';
    if (g.fnValCheck(value)) {
      count = value[0]["COUNT"];
      timeK = (value[0]["TIME"]??"");
    } else {
      timeK = refreshTime;
      count = pageCount;
    }
    if (pageCount != count) {
      fnGetKitchenView();
    }
    setState(() {
      refreshTime = timeK;
      pageCount = count;
    });
  }

  fnGetKitchenView() async {
    futureKitchen = apiCall.getKitchenView(g.wstrCompany, g.wstrYearcode, lstrKitchenCode, lstrSelectedMode);
    futureKitchen.then((value) => fnGetKitchenViewSuccess(value));
  }

  fnGetKitchenViewSuccess(value) {
    if (g.fnValCheck(value)) {
      if (lstrSelectedMode == "P") {
        lstrOpenQty = 0;
        setState(() {
          if (value.length > lastValueLength) {
            //_audioCache.play('mytune.mp3');
          }
          for (var e in value) {
            for (var a in e["KOTDET"]) {
              lstrOpenQty = lstrOpenQty + a["QTY1"];
            }
          }
          if (lstrOpenQty != lstrLastOpenQty) {
            // _audioCache.play('mytune.mp3');
            player.setSourceBytes(audiobytes);
          }
          print(lstrOpenQty.toString());
          lstrLastOpenQty = lstrOpenQty;
          lastValueLength = value.length;
        });
      }
    }
  }

  fnGetChef() async {
    futureChef = apiCall.getChef(g.wstrShifNo);
    futureChef.then((value) => fnGetChefSuccess(value));
  }

  fnGetChefSuccess(value) {
    if (g.fnValCheck(value)) {}
    setState(() {});
  }

  fnSavePreparation(dataList) {
    futurePreparation = apiCall.savePreparation(dataList);
    futurePreparation.then((value) => fnSavePreparationSuccess(value));
  }

  fnSavePreparationSuccess(value) {
    if (g.fnValCheck(value)) {
      Navigator.pop(context);
    }
    fnGetKitchenView();
  }

  fnLogout() async {
    final SharedPreferences prefs = await _prefs;

    prefs.setString('wstrUserCd', '');
    prefs.setString('wstrUserName', '');
    prefs.setString('wstrUserRole', '');
    prefs.setString('wstrCompany', g.wstrCompany);
    prefs.setString('wstrYearcode', g.wstrYearcode);
    prefs.setString('wstrLoginSts', 'N');
    prefs.setString('wstrTableView', '');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }
}
