
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/PopupLookup/searchpopup.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/lookup/lookup.dart';
import 'package:beamsbistro/Views/Components/tableComponent.dart';
import 'package:beamsbistro/Views/Pages/Login/userLogin.dart';
import 'package:beamsbistro/Views/Pages/Menu/MenuAvailability.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaiterHomeL extends StatefulWidget  {
  const WaiterHomeL({Key? key}) : super(key: key);

  @override
  _WaiterHomeLState createState() => _WaiterHomeLState();
}
enum popEnum { itemOne }
class _WaiterHomeLState extends State<WaiterHomeL> with SingleTickerProviderStateMixin {

  late TabController _controller;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  //global

  //api
  late Future<dynamic> futureFloor;
  late Future<dynamic> futureTable;
  late Future<dynamic> futureMultiTable;
  late Future<dynamic> futureOrder;
  late Future<dynamic> futureCancelOrder;
  late Future<dynamic> futureTakeAway;
  late Future<dynamic> futureDelivery;
  late Future<dynamic> futureFinishOrder;
  late Future<dynamic> futureReason;
  late Future<dynamic> futureRefresh;
  late Future<dynamic> futureDeliveryMOde;
  late Future<dynamic> futureForm;

  //==============================audio
  late AudioCache _audioCache;
  // FlutterTts flutterTts = FlutterTts();
  // TtsState ttsState = TtsState.stopped;
  //
  // get isPlaying => ttsState == TtsState.playing;
  // get isStopped => ttsState == TtsState.stopped;
  // get isPaused => ttsState == TtsState.paused;
  // get isContinued => ttsState == TtsState.continued;


  //==============================audio end

  var pageCount = 0;
  var refreshTime  = '';


  var formatTime = new DateFormat('hh:mm a');

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
  var lstrSelectedTime = "";
  var lstrSelectedQty = 0.0;

  var lstrMultiTable = [] ;
  var lstrSelectedItems = [];
  var lstrSelectedTabels= [];
  var lstrSelectedKot= [];
  var lstrSelectedAddress= [];

  var selectedTakeAwayNo = '';

  //for delivery
  var lstrDeliveryOptions = [];

  //print
  var lstrPrintDocno = '';
  var lstrPrintDoctype = '';
  var lstrPrintYearcode = '';
  bool kotPrint  = true;

  //Controller
  var txtGuestNo = TextEditingController();
  var txtReason = TextEditingController();

  //room selection
  var lstrRoomSelection  = false;
  var lstrSelectedRoomYn  = "";
  var lstrSelectedDelvMode  = "";


  var formatDate = new DateFormat('yyyy-MM-dd hh:mm:ss');
  var formatDate1 = new DateFormat('yyyy-MM-dd');

  var lstrTableCall = 1;
  var lstrTakeWayCall = 1;
  var lstrDeliveryCall = 1;


  //cancel
  var lstrKot = [];

  //pageMode
  //O- ORDER | T-TABLECHANGE
  var pageMode = "O";
  //W- waiter | P- pos
  var screenMode = "";
  //T- Table Selection | O- ORDERSTATUS | V-VIEWORDER | E-EMPTY | A- TAKEAWAYSTATUS | D-DELIVRYSTATUS |AT- TAKEAWAY ORDER | DT-DELIVRY ORDER
  var sideScreenMode = "E";


  //void order
  bool p1 =false;
  bool p2 =false;
  bool p3 =false;
  bool p4 =false;
  var  passCode  ='';
  var lstrSelectedVoidCode = '';
  var lstrCancelMode = 'CANCEL';

  late Timer timer;
  int counter = 0;

  String audioasset = "assets/audio/mytune.mp3";
  bool isplaying = false;
  bool audioplayed = false;
  late Uint8List audiobytes;

  AudioPlayer player = AudioPlayer();

  TextEditingController txtController = TextEditingController();

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    g.wstrRoomPriceList = "ROOM";

    fnGetTable();
    fnGetTakeAway();
    fnGetDelivery();
    fnGetReason();
    screenMode = g.wstrOrderScreenMode;
    txtGuestNo.text ='0';

     var tabCount = (g.wstrDINE_IN_YN == "Y"?1:0) + (g.wstrTAKEAWAY_YN == "Y"?1:0) + (g.wstrDELIVERY_YN == "Y"?1:0);
     if(g.wstrDINE_IN_YN == "Y"){
       sideScreenMode = "E";
     }else if(g.wstrTAKEAWAY_YN == "Y"){
      sideScreenMode = "AT";
    }else if(g.wstrDELIVERY_YN == "Y"){
      sideScreenMode = "DT";
    }


    _controller = new TabController(length: tabCount,vsync: this);
    timer = Timer.periodic(Duration(seconds: 4), (Timer t) => fnRefresh());

    // _audioCache = AudioCache(
    //     prefix: "assets/audio/");

    Future.delayed(Duration.zero, () async {
      ByteData bytes = await rootBundle.load(audioasset); //load audio from assets
      audiobytes = bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    });

    _controller.addListener(() {
        fnRemoveAllTable();
        if(_controller.index == 0){
          if(g.wstrDINE_IN_YN == "Y"){
            setState(() {
              sideScreenMode = "E";
            });
            fnGetTable();
          }else if(g.wstrTAKEAWAY_YN == "Y"){
            setState(() {
              sideScreenMode = "AT";
            });
            fnGetTakeAway();
          }else if(g.wstrDELIVERY_YN == "Y"){
            setState(() {
              sideScreenMode = "DT";
            });
            fnGetDelivery();
          }
        }else
        if(_controller.index == 1){
          if(g.wstrTAKEAWAY_YN == "Y"){
            setState(() {
              sideScreenMode = "AT";
            });
            fnGetTakeAway();
          }else if(g.wstrDELIVERY_YN == "Y"){
            setState(() {
              sideScreenMode = "DT";
            });
            fnGetDelivery();
          }
        }else if(_controller.index == 2){
          if(g.wstrDELIVERY_YN == "Y"){
            setState(() {
              sideScreenMode = "DT";
            });
            fnGetDelivery();
          }
        }
      //print("Selected Index: " + _controller.index.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    g.wstrContext = this.context;
    return WillPopScope(child: Scaffold(
      // appBar: mainAppBarMobile(fnLogout,g.wstrUserName + ' - '+ g.wstrShifDescp.toString().toUpperCase(),fnSysytemInfo),
      appBar:AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left:10),
          child: Icon(Icons.segment,color: PrimaryText,size: 30,),
        ),
        title: tc(g.wstrUserName + ' - '+ g.wstrShifDescp.toString().toUpperCase(), Colors.black, 17),
        actions: [
          // GestureDetector(
          //   onTap: (){
          //     fnSysytemInfo();
          //   },
          //   child: Container(
          //     width: 50,
          //     margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
          //     decoration: boxBaseDecoration(Colors.amber, 10),
          //     child: Icon(Icons.food_bank_outlined,color: Colors.black,size: 20,),
          //   ),
          // ),
          gapWC(5),
          GestureDetector(
            onTap: (){
              fnSysytemInfo();
            },
            child: Container(
              width: 50,
              margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              decoration: boxBaseDecoration(Colors.amber, 10),
              child: Icon(Icons.computer_sharp,color: Colors.black,size: 20,),
            ),
          ),
          Container(
              margin: EdgeInsets.only(right:20),
              child:  IconButton(onPressed: (){
                fnLogout();
              }, icon: Icon(Icons.power_settings_new,color: PrimaryColor,size: 30,))
          )

        ],
      ),
      body: fnCheckDocDate()? Container(
        width: size.width,
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [

                  Expanded(
                    child: Container(
                      child: pageMode == "O"? Column(
                        children: [//table
                          Container(
                            decoration: boxBaseDecoration(Colors.white, 5),
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end ,
                              children: [
                                Row(
                                  children: [
                                    // Checkbox(
                                    //     activeColor: Colors.green,
                                    //     value: lstrRoomSelection,
                                    //     onChanged: (value){
                                    //       setState(() {
                                    //         if(lstrRoomSelection){
                                    //           lstrRoomSelection= false;
                                    //         }else{
                                    //           lstrRoomSelection = true;
                                    //         }
                                    //       });
                                    //     }),
                                    Bounce(child: Container(
                                      decoration: boxDecoration( Colors.amber, 30),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          gapWC(5),
                                          Icon(Icons.food_bank_outlined, color: Colors.black,size: 12,),
                                          gapWC(5),
                                          tc('86 Menu', Colors.black, 12),
                                          gapWC(5),
                                        ],
                                      ),
                                    ), duration: Duration(milliseconds: 110),
                                        onPressed: (){
                                        if(g.wstrE86ITEM_YN != "Y"){
                                          showToast(mfnLng('Please contact admin!'));
                                          return;
                                        }
                                          Navigator.push(context, MaterialPageRoute(
                                              builder: (context) => MenuAvailability()
                                          ));
                                        }),
                                    gapWC(5),
                                    g.wstrRoomMode == "Y"?
                                    Bounce(child: Container(
                                      decoration: boxDecoration( lstrRoomSelection?Colors.green:Colors.grey, 2),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          gapWC(5),
                                          Icon(Icons.adjust_rounded, color: lstrRoomSelection?Colors.white:Colors.black,size: 12,),
                                          gapWC(5),
                                          tc(mfnLng('Room Service'), lstrRoomSelection?Colors.white:Colors.black, 12),
                                          gapWC(5),
                                        ],
                                      ),
                                    ),
                                        duration: Duration(milliseconds: 110),
                                        onPressed: (){
                                          setState(() {
                                            if(lstrRoomSelection){
                                              lstrRoomSelection= false;
                                            }else{
                                              lstrRoomSelection = true;
                                            }
                                          });
                                        }):gapHC(0)
                                  ],
                                )
                              ],
                            ),
                          ),
                          new Container(
                            decoration: boxBaseDecoration(greyLight, 30.0),
                            child: new TabBar(
                              controller: _controller,
                              isScrollable: false,
                              indicator: UnderlineTabIndicator(
                                   //borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(width: 50.0,color:Colors.amber),
                                  insets: EdgeInsets.symmetric(horizontal:20.0)
                              ),
                              tabs:wListTab(size)
                            ),
                          ),
                          
                          Expanded(
                            child: new Container(
                              padding: EdgeInsets.only(left: 5,right: 5),
                              child: new TabBarView(
                                controller: _controller,
                                children: wListTabDet(size),
                              ),
                            ),
                          ),
                        ],
                      ):
                      Column(
                        children: [

                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: size.width*0.33,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(5),
                    decoration: boxDecoration(Colors.white, 10),
                    child: sideScreenMode == "T" ?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [


                        th(mfnLng('Selected Tables'),Colors.black,15),
                        gapHC(10),
                        Expanded(child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio:5/2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: List.generate(lstrMultiTable.length, (index) {
                            var datalist =  lstrMultiTable[index];
                            var code = datalist['TABLE_DESCP'];

                            return GestureDetector(
                              onTap: (){
                                fnRemoveTable(datalist);
                              },
                              child: Container(
                                decoration: boxBaseDecoration(SecondaryColor, 5),
                                child: Center(
                                  child: tc(datalist['TABLE_DESCP']??'',Colors.black,18),
                                ),
                              ),
                            );
                          }),
                        ),),
                        tcn('Guest No', Colors.black, 15),
                        Container(
                            width: size.width*0.3,
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
                        gapHC(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width* 0.2,
                              height: 40,
                              padding: EdgeInsets.all(5),
                              decoration: boxBaseDecoration(blueLight, 5),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: mfnLng('Name')

                                ),
                              ),
                            ),
                            Container(
                              width: size.width* 0.1,
                              height: 40,
                              padding: EdgeInsets.all(5),
                              decoration: boxBaseDecoration(blueLight, 5),
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: txtGuestNo,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: mfnLng('Guest No')
                                ),
                              ),
                            ),
                          ],
                        ),
                        gapHC(15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  fnRemoveAllTable();

                                });
                              },
                              child: Container(
                                height: 50,
                                width: size.width*0.1,
                                decoration: boxBaseDecoration(greyLight, 30),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      tcn(mfnLng('Close'),Colors.red,17)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            gapWC(10),
                            Expanded(child: GestureDetector(
                              onTap: (){

                                g.wstrMenuMode= 'ADD';
                                g.wstrOrderMode = 'ADD';
                                g.wstrOrderType = 'T';
                                g.wstrLastSelectedTables = lstrMultiTable;
                                var guestNo  = txtGuestNo.text.isEmpty?'0': txtGuestNo.text.toString() ;
                                g.wstrGuestNo = int.parse(guestNo);
                                g.wstrDeliveryMode =lstrRoomSelection ?g.wstrRoomPriceList:"";
                                g.wstrRoomYN = lstrRoomSelection ?"Y":"";
                                g.wstrLastSelectedAdd = [];
                                //lstrMultiTable.clear();
                                Navigator.pushReplacement(context, NavigationController().fnRoute(15));
                              },
                              child: Container(
                                height: 50,
                                decoration: boxGradientDecoration(16, 30),
                                child: Center(
                                  child: tcn(mfnLng('Continue'),Colors.white,15),
                                ),
                              ),
                            ),)

                          ],
                        ),
                        gapHC(3),
                      ],
                    ):
                    sideScreenMode == "O" ?
                    Column(
                      children: [
                        Container(
                          height: 45,
                          padding: EdgeInsets.all(10),
                          decoration: boxDecoration(Colors.white, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    //sideScreenMode = "T";
                                  });
                                  g.wstrMenuMode= 'EDIT';
                                  g.wstrOrderMode = 'EDIT';
                                  g.wstrOrderType = 'T';
                                  g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
                                  g.wstrLastSelectedTables = lstrSelectedTabels;
                                  g.wstrLastSelectedAdd = lstrSelectedAddress;
                                  g.wstrLastMenuItems = lstrSelectedItems;
                                  g.wstrTableUpdateMode = 'M';
                                  g.wstrDeliveryMode = lstrSelectedDelvMode;
                                  g.wstrRoomYN = lstrSelectedRoomYn;
                                  Navigator.pushReplacement(context, NavigationController().fnRoute(7));
                                },
                                child: th('Table : ' +lstrSelectedTableNo, Colors.black, 16),
                              ),

                              Row(
                                children: [
                                  tc(lstrSelectedOrderNo.toString(), Colors.black, 18),
                                  gapWC(5),
                                  Icon(Icons.confirmation_number,color: Colors.black,),
                                  gapWC(10),
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
                                      height: 40,
                                      width: 70,
                                      decoration: boxDecoration(Colors.amber, 50),
                                      child: Center(
                                        child:    Icon(Icons.print,color: Colors.black,size: 20,),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        gapHC(10),
                        Container(
                          height: 30,
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
                        gapHC(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            th('${mfnLng("ORDER")} ' + lstrSelectedOrderDocNo.toString(),Colors.black,13 ),
                            tc('${mfnLng("TABLE")} ' + lstrOrderTables.toString(),Colors.black,13 ),
                          ],
                        ),
                        gapHC(10),
                        Expanded(child: futureItemView(),),
                        gapHC(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            clockRow(lstrSelectedTime),
                            // tc('Qty'  +'  ' + lstrSelectedQty.toString(),Colors.black,15),
                            th(lstrTotalAmount,Colors.black,17)
                          ],
                        ),
                        gapHC(15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  sideScreenMode = "E";
                                  lstrSelectedTableNo = "";
                                });
                              },
                              child: Container(
                                height: 40,
                                width: size.width*0.1,
                                decoration: boxBaseDecoration(greyLight, 5),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      tcn(mfnLng('Close'),Colors.black,16)
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Bounce(
                                child: Container(
                                  height: 40,
                                  width: size.width*0.1,
                                  decoration: boxBaseDecoration(PrimaryColor, 5),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        th(mfnLng('Cancel'),Colors.white,15)
                                      ],
                                    ),
                                  ),
                                ),
                                duration: Duration(milliseconds: 110),
                                onPressed: (){
                                  g.wstrMenuMode= 'CANCEL';
                                  g.wstrOrderMode = 'CANCEL';
                                  g.wstrOrderType = 'T';
                                  g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
                                  g.wstrLastSelectedTables = lstrSelectedTabels;
                                  g.wstrLastMenuItems = lstrSelectedItems;
                                  setState(() {
                                    lstrCancelMode = "CANCEL";
                                  });
                                  fnCancelOrder();
                                }),
                            Bounce(child:
                            Container(
                              height: 40,
                              width: size.width*0.1,
                              decoration: boxBaseDecoration(Colors.green, 5),
                              child: Center(
                                child:th(mfnLng('Add'),Colors.white,15),
                              ),
                            ),
                                duration:Duration(milliseconds: 110),
                                onPressed: (){
                                  g.wstrMenuMode= 'EDIT';
                                  g.wstrOrderMode = 'EDIT';
                                  g.wstrOrderType = 'T';
                                  g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
                                  g.wstrLastSelectedTables = lstrSelectedTabels;
                                  g.wstrLastSelectedAdd = lstrSelectedAddress;
                                  g.wstrLastMenuItems = lstrSelectedItems;
                                  g.wstrDeliveryMode = lstrSelectedDelvMode;
                                  g.wstrRoomYN = lstrSelectedRoomYn;
                                  setState(() {
                                    //pageMode = "M";
                                    // sideScreenMode = "V";

                                  });
                                  Navigator.pushReplacement(context, NavigationController().fnRoute(15));
                                })

                          ],
                        ),
                        gapHC(15),
                      ],
                    ):
                    sideScreenMode == "V" ?
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //void
                          gapHC(5),
                          Row(
                            children: [
                              gapWC(10),
                              Icon(Icons.delete_sweep,color: Colors.red,),
                              gapWC(5),
                              th(mfnLng('Order Cancel'),Colors.black,18)
                            ],
                          ),
                          gapHC(5),
                          lineC(0.2,Colors.black),
                          gapHC(10),
                          tcn(mfnLng('Reason Note'),Colors.black,15),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Container(
                                      height: 50,
                                      padding: EdgeInsets.all(3),
                                      decoration: boxBaseDecoration(greyLight, 3),
                                      child: TextField(
                                        keyboardType: TextInputType.multiline,
                                        style: TextStyle(fontSize: 15.0),
                                        maxLines: 10,
                                        controller: txtReason,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),),
                                    gapWC(10),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          txtReason.text = '';
                                        });
                                      },
                                      child: Container(
                                        decoration: boxBaseDecoration(blueLight, 3),
                                        height: 50,
                                        width: 50,
                                        child: Center(
                                          child: Icon(Icons.delete_sweep_sharp),
                                        ),
                                      ),
                                    )

                                  ],
                                ),
                                gapHC(5),
                                Container(
                                  height: 50,
                                  child: new FutureBuilder<dynamic>(
                                    future: futureReason,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return reasonView(snapshot);
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
                                gapHC(10),
                                Container(
                                  height: 40,
                                  decoration: boxBaseDecoration(redLight, 5),
                                  child: Center(
                                    child: tc((p1?" * ":"")+(p2?" * ":"")+(p3?" * ":"")+(p4?" * ":"") , Colors.black,25),
                                  ),
                                ),
                                gapHC(10),
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
                                    Icon(Icons.fingerprint,size: 45,color: Colors.white,),
                                    numberPress('0',size),
                                    IconButton(onPressed: (){
                                      fnOnPressClear();
                                    }, icon:  Icon(Icons.backspace,size: 30,),)

                                  ],
                                ),
                              ],
                            ),
                          ),
                          gapHC(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              GestureDetector(

                                onTap: (){
                                  setState(() {
                                    sideScreenMode = "E";
                                  });
                                  //Navigator.pop(context);
                                },
                                child: Container(
                                  height: 40,
                                  width: size.width*0.1,
                                  decoration: boxBaseDecoration(greyLight, 30),
                                  child: Center(
                                    child: tcn(mfnLng('Close'),Colors.black,15),
                                  ),
                                ),
                              ),
                              gapWC(10),
                              Expanded(child: GestureDetector(

                                onTap: (){
                                  setState(() {
                                    //sideScreenMode = "E";
                                    setState(() {
                                      lstrCancelMode = "VOID_CANCEL";
                                    });
                                    fnCancelOrder();
                                  });
                                  //Navigator.pop(context);
                                },
                                child: Container(
                                  height: 40,
                                  decoration: boxDecoration(PrimaryColor, 30),
                                  child: Center(
                                    child: th(mfnLng('VOID'),Colors.white,16),
                                  ),
                                ),
                              ))
                            ],
                          )
                        ],
                      ),
                    ):
                    sideScreenMode == "A" ?
                    Column(
                      children: [
                        Container(
                          height: 45,
                          padding: EdgeInsets.all(10),
                          decoration: boxDecoration(Colors.white, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              th('${mfnLng("Order")} : ' +lstrSelectedOrderDocNo, Colors.black, 16),
                              Row(
                                children: [
                                  tc(lstrSelectedOrderNo.toString(), Colors.black, 16),
                                  gapWC(5),
                                  Icon(Icons.confirmation_number,color: Colors.black,),
                                  gapWC(5),
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
                                      height: 40,
                                      width: 70,
                                      decoration: boxDecoration(Colors.amber, 50),
                                      child: Center(
                                        child:    Icon(Icons.print,color: Colors.black,size: 20,),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        gapHC(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: th('${mfnLng("Name")}  ' + lstrSelectedName.toString(),Colors.black,12 ),),
                            tcn('  ' + lstrSelectedMob.toString(),Colors.black,12 ),
                          ],
                        ),
                        gapHC(10),
                        Expanded(child: futureItemTakeAway()),
                        gapHC(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            clockRow(lstrSelectedTime),
                            th(lstrTotalAmount,Colors.black,18),
                          ],
                        ),
                        gapHC(15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  sideScreenMode = "AT";
                                  selectedTakeAwayNo = '';
                                });
                              },
                              child: Container(
                                height: 40,
                                width: size.width*0.1,
                                decoration: boxBaseDecoration(greyLight, 5),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      tcn(mfnLng('Close'),Colors.black,17)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Bounce(
                                child: Container(
                                  height: 40,
                                  width: size.width*0.1,
                                  decoration: boxBaseDecoration(PrimaryColor, 5),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        th(mfnLng('Cancel'),Colors.white,15)
                                      ],
                                    ),
                                  ),
                                ),
                                duration: Duration(milliseconds: 110),
                                onPressed: (){
                                   g.wstrMenuMode= 'CANCEL';
                                g.wstrOrderMode = 'CANCEL';
                                g.wstrOrderType = 'A';
                                g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
                                g.wstrLastSelectedTables = lstrSelectedTabels;
                                g.wstrLastMenuItems = lstrSelectedItems;
                                setState(() {
                                  lstrCancelMode = "CANCEL";
                                });
                                fnCancelOrder();
                                // Navigator.pushReplacement(context, NavigationController().fnRoute(15));
                             }),
                            Bounce(child:
                            Container(
                              height: 40,
                              width: size.width*0.1,
                              decoration: boxBaseDecoration(Colors.green, 5),
                              child: Center(
                                child:th(mfnLng('Add'),Colors.white,15),
                              ),
                            ),
                                duration:Duration(milliseconds: 110),
                                onPressed: (){
                                  g.wstrMenuMode= 'EDIT';
                                  g.wstrOrderMode = 'EDIT';
                                  g.wstrOrderType = 'A';
                                  g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
                                  g.wstrLastMenuItems = lstrSelectedItems;
                                  g.wstrLastSelectedAdd = lstrSelectedAddress;
                                  g.wstrLastSelectedTables = [];
                                  g.wstrDeliveryMode = lstrSelectedDelvMode;
                                  g.wstrRoomYN = lstrSelectedRoomYn;
                                  Navigator.pushReplacement(context, NavigationController().fnRoute(15));
                            })
                          ],
                        ),
                        gapHC(15),
                      ],
                    ):
                    sideScreenMode == "D" ?
                    Column(
                      children: [
                        Container(
                          height: 45,
                          padding: EdgeInsets.all(10),
                          decoration: boxDecoration(Colors.white, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              th('${mfnLng("Order")} : ' +lstrSelectedOrderDocNo, Colors.black, 16),
                              Row(
                                children: [
                                  tc(lstrSelectedOrderNo.toString(), Colors.black, 18),
                                  gapWC(10),
                                  Icon(Icons.confirmation_number,color: Colors.black,),
                                  gapWC(10),
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
                                      height: 40,
                                      width: 70,
                                      decoration: boxDecoration(Colors.amber, 50),
                                      child: Center(
                                        child:    Icon(Icons.print,color: Colors.black,size: 20,),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        gapHC(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: th('${mfnLng("Name")} -  ' + lstrSelectedName.toString(),Colors.black,12 ),),
                            tcn('  ' + lstrSelectedMob.toString(),Colors.black,12 ),
                          ],
                        ),
                        gapHC(15),
                        Expanded(child: futureItemDelivery()),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            clockRow(lstrSelectedTime),
                            th(lstrTotalAmount,Colors.black,18),
                          ],
                        ),
                        gapHC(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  sideScreenMode = "DT";
                                });
                              },
                              child: Container(
                                height: 40,
                                width: size.width*0.1,
                                decoration: boxBaseDecoration(greyLight, 5),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      tc(mfnLng('Close'),Colors.red,17)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Bounce(
                                child: Container(
                                  height: 40,
                                  width: size.width*0.1,
                                  decoration: boxBaseDecoration(PrimaryColor, 5),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        th(mfnLng('Cancel'),Colors.white,15)
                                      ],
                                    ),
                                  ),
                                ),
                                duration: Duration(milliseconds: 110),
                                onPressed: (){
                                  g.wstrMenuMode= 'CANCEL';
                                  g.wstrOrderMode = 'CANCEL';
                                  g.wstrOrderType = 'D';
                                  g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
                                  g.wstrLastSelectedTables = lstrSelectedTabels;
                                  g.wstrLastMenuItems = lstrSelectedItems;
                                  setState(() {
                                    lstrCancelMode = "CANCEL";
                                  });
                                  fnCancelOrder();
                                  //Navigator.pushReplacement(context, NavigationController().fnRoute(15));
                                }),
                            Bounce(child:
                            Container(
                              height: 40,
                              width: size.width*0.1,
                              decoration: boxBaseDecoration(Colors.green, 5),
                              child: Center(
                                child:th('Add',Colors.white,15),
                              ),
                            ),
                                duration:Duration(milliseconds: 110),
                                onPressed: (){
                                  g.wstrMenuMode= 'EDIT';
                                  g.wstrOrderMode = 'EDIT';
                                  g.wstrOrderType = 'D';
                                  g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
                                  g.wstrLastMenuItems = lstrSelectedItems;
                                  g.wstrLastSelectedAdd = lstrSelectedAddress;
                                  g.wstrLastSelectedTables = [];
                                  g.wstrDeliveryMode = lstrSelectedDelvMode;
                                  g.wstrRoomYN = lstrSelectedRoomYn;
                                  Navigator.pushReplacement(context, NavigationController().fnRoute(15));
                                })

                          ],
                        ),
                        gapHC(10),
                      ],
                    ):
                    sideScreenMode == "DT" ?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        gapHC(10),
                        Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: fnGetDeliveryOptions(size),
                              ),
                            )),
                        // Column(
                        //   children: [
                        //     Image.asset("assets/images/delivery.jpg",
                        //       width: 160,),
                        //     gapHC(10),
                        //     th("Delivery".toString(),Colors.black,25),
                        //   ],
                        // ),
                        GestureDetector(
                          onTap: (){
                            g.wstrOrderType = 'D';
                            g.wstrOrderMode = 'ADD';
                            g.wstrMenuMode = 'ADD';
                            g.wstrLastSelectedAdd = [];
                            g.wstrLastSelectedTables = [];
                            g.wstrDeliveryMode = lstrRoomSelection ?g.wstrRoomPriceList:"";
                            g.wstrRoomYN = lstrRoomSelection ?"Y":"";
                            Navigator.pushReplacement(context, NavigationController().fnRoute(15));
                          },
                          child: Container(
                            width: size.width*0.3,
                            margin: EdgeInsets.only(bottom: 5),
                            height: 50,
                            decoration: boxGradientDecoration(16, 30),
                            child: Center(
                              child: tcn(mfnLng('Take Order'),Colors.white,15),
                            ),
                          ),
                        ),
                      ],
                    ):
                    sideScreenMode == "AT" ?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        gapHC(10),
                        Column(
                          children: [
                            Image.asset("assets/images/takeaway.jpg",
                              width: 160,),
                            gapHC(10),
                            th(mfnLng("Takeaway").toString(),Colors.black,25),
                          ],
                        ),
                        GestureDetector(

                          onTap: (){
                            g.wstrOrderType = 'A';
                            g.wstrOrderMode = 'ADD';
                            g.wstrMenuMode = 'ADD';
                            g.wstrLastSelectedAdd = [];
                            g.wstrLastSelectedTables = [];
                            g.wstrDeliveryMode = lstrRoomSelection ?g.wstrRoomPriceList:"";
                            g.wstrRoomYN = lstrRoomSelection ?"Y":"";
                            Navigator.pushReplacement(context, NavigationController().fnRoute(15));
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 5),
                            width: size.width*0.3,
                            height: 50,
                            decoration: boxGradientDecoration(16, 30),
                            child: Center(
                              child: ts(mfnLng('Take Order'),Colors.white,15),
                            ),
                          ),
                        ),
                      ],
                    ):Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/waiter.jpg",
                          width: 180,),
                        tc(g.wstrUserName.toString(),Colors.black,30),
                        tc(g.wstrShifDescp.toString().toUpperCase(),Colors.black,15),
                        gapH()
                      ],
                    ),
                  )
                ],
              ),
            ),
            gapHC(10)
          ],
        ),
      ):
      Container(
        child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.punch_clock,size: 60,),
            gapHC(10),
            tc(mfnLng('CLOCK-IN NOT VALID'),Colors.black,30),
            tcn(mfnLng('LAST CLOCK-IN'),Colors.black,20),
            tcn(formatDate.format(DateTime.parse(g.wstrClockInDate.toString())).toString(),Colors.red,20),
          ],
        )
        ),
      ),
    ), onWillPop: () async{
      if(screenMode == "W"){
        SystemNavigator.pop();
      }else{
        Navigator.pushReplacement(context, NavigationController().fnRoute(9));
      }
      //Navigator.pushReplacement(context, NavigationController().fnRoute(11));
      return true;
    });
  }
  //======================================================================Widgets


  fnGetDeliveryOptions(size){
    List<Widget> returnList = [];

    lstrDeliveryOptions.forEach((e) {
      returnList.add(
        Bounce(child: Container(
          width: size.width*0.28,
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.only(bottom: 5),
          decoration: boxDecoration(Colors.white, 5),
          child: Row(
            children:[
              Expanded(child: tc(e["DESCP"].toString(), Colors.black, 15),),
              Icon(Icons.arrow_forward_ios,color: Colors.black,)
            ]
          ),
        ), duration:
        Duration(milliseconds: 110),
        onPressed: (){
          fnOnclickDeliveryMode(e["CODE"]??"",e["ROOM_SERVICE_YN"]??"");
        })
      );
    });
    return returnList;
  }

  Container tabHead(name,size) => Container(
    height: 40,
    padding: EdgeInsets.all(5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon( name =="Table"? Icons.table_chart:name =="Takeaway"?Icons.fastfood_outlined:name =="Others"?Icons.table_chart:Icons.delivery_dining,size: 18,color: Colors.black,),
        gapWC(5),
        th(name,Colors.black,16)
      ],
    ),
  );
  Widget floorView(snapshot){
    try{
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
    }catch(e){
      return Container();
    }

  }
  Widget tableView(snapshot,size){

    try{
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
    }catch(e){
      return Container();
    }
  }
  Widget reasonView(snapshot){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data[index];
          var reasonCode = dataList['CODE']??"";
          var reasonDescp = dataList['DESCP']??"";

          return GestureDetector(
            onTap: (){
              setState(() {
                lstrSelectedVoidCode = reasonCode;
                txtReason.text = txtReason.text+reasonDescp;
              });
            },
            child:  Container(
              height: 30,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              margin: EdgeInsets.only(right: 10,top: 5),
              decoration: boxBaseDecoration( blueLight , 5),
              child: Center(
                child: tcn(reasonDescp,  Colors.black,15),
              ),
            ),
          );
        });
  }

  //future
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


  //========================================================================Widgets

  List<Widget>  wListTab(size){
    List<Widget> rtnList= [];



    if( g.wstrDINE_IN_YN == "Y"){
      rtnList.add(Tab(
          child: tabHead(mfnLng('Table'),size)
      ));
    }
    if( g.wstrTAKEAWAY_YN == "Y"){
      rtnList.add(GestureDetector(
        onTap: (){
          //fnGetTakeAway();
        },
        child: new Tab(
          child: tabHead(mfnLng('Takeaway'),size),
        ),
      ));
    }
    if( g.wstrDELIVERY_YN == "Y"){
      rtnList.add(GestureDetector(
        onTap: (){
          //fnGetDelivery();
        },
        child: new Tab(
          child: tabHead(mfnLng('Delivery'),size),
        ),
      ));
    }

    return rtnList;
  }

  List<Widget>  wListTabDet(size){
    List<Widget> rtnList= [];


    if( g.wstrDINE_IN_YN == "Y"){
      rtnList.add(Container(
        padding: EdgeInsets.all(5),
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(top:10),
              height: 40,
              width: size.width,
              child: floorFuture(),
            ),
            gapHC(10),
            Expanded(child: Container(
              width: size.width ,
              child: tableFuture(size),
            )),
          ],
        ),
      )
      );
    }
    if( g.wstrTAKEAWAY_YN == "Y"){
      rtnList.add(Container(
          margin: EdgeInsets.only(left: 20,right: 10,top: 0,bottom:0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: takeAwayFuture(),
                ),
              ),
            ],
          )
      ));
    }
    if( g.wstrDELIVERY_YN == "Y"){
      rtnList.add(Container(
          margin: EdgeInsets.only(left: 20,right: 10,top: 0,bottom:0),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(5),
                height: size.height*0.75,
                child: deliveryFuture(),
              ),
            ],
          )
      ));
    }

    return rtnList;
  }
  Widget  orderView(snapshot){
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
              decoration: boxBaseDecoration(lstrSelectedOrderDocNo == orderCode ? PrimaryColor :SecondarySubColor, 10),
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
          var itemNote  = dataList['REF1'];
          var itemQty =  g.mfnDbl(dataList["QTY1"]);
          var clearedQty = dataList['CLEARED_QTY'].toInt().toString();
          var itemStatus = dataList['PREP_STATUS'].toString();
          var status = dataList['STATUS'].toString();
          //var pendingQty = itemQty - int.parse(clearedQty);
          var voidQty = dataList['VOID_QTY']??0;
          var Qty  =  g.mfnDbl(dataList["QTY1"]);
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
              g.wstrMenuMode= 'EDIT';
              g.wstrOrderMode = 'EDIT';
              if(sideScreenMode == "A"){
                g.wstrOrderType = 'A';
              }else
              if(sideScreenMode == "D"){
                g.wstrOrderType = 'D';
              }else
              if(sideScreenMode == "O"){
                g.wstrOrderType = 'T';
              }
              g.wstrLastSelectedKotDocno = lstrSelectedOrderDocNo;
              g.wstrLastSelectedTables = lstrSelectedTabels;
              g.wstrLastSelectedAdd = lstrSelectedAddress;
              g.wstrLastMenuItems = lstrSelectedItems;
              g.wstrDeliveryMode = lstrSelectedDelvMode;
              g.wstrRoomYN = lstrSelectedRoomYn;
              setState(() {
                //pageMode = "M";
                // sideScreenMode = "V";

              });
              Navigator.pushReplacement(context, NavigationController().fnRoute(15));
            },
            child:   Container(
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
              margin: EdgeInsets.only(bottom: 10),
              decoration: boxBaseDecoration(blueLight, 3),
              child:  SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: tc((index+1).toString() +'. '+itemName+'  x'+ itemQty.toString(),Colors.black,14)),
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
                        gapHC(5),
                        itemNote != ""?
                        tc('Note : '+itemNote.toString(),Colors.black,12):Container(),
                        gapHC(5),
                        voidQty > 0 ?
                        tc('Void Qty : '+voidQty.toString(),Colors.black,12):Container(),
                      ],
                    )
                  ],
                ),
              ),

            ),
          );
        });
  }
  Widget takeAwayView(snapshot){
    if(snapshot.data['OrderList'] == null){
      return Container();
    }
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data['OrderList'].length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data['OrderList'][index];
          var kotDetails = snapshot.data['TableDet'][index];

          var lstrOrderNo = dataList["Docno"]??"";
          var lstrOrderMode = kotDetails["ORDER_MODE"]??"";
          var lstrOrderRoom = kotDetails["ORDER_ROOM"]??"";
          var lstrOrderRef = kotDetails["ORDER_REF"]??"";
          var lstrOrderSts = kotDetails["PREP_STATUS"]??"";
          var lstrAddressDetails = dataList["Address"]??"";
          var fName ="";
          var mobNo="";
          var mobNo2="";
          var carNum="";
          if(g.fnValCheck(lstrAddressDetails)){
             fName =  lstrAddressDetails[0]['FNAME']??"";
             mobNo =  lstrAddressDetails[0]['PHONE1']??"";
             mobNo2 =  lstrAddressDetails[0]['PHONE2']??"";
             carNum =  lstrOrderMode + ' '+lstrOrderRoom+ ' '+  lstrOrderRef;
             //lstrRoomRef =  lstrRoomRef + " - "+  lstrAddressDetails[0]['ADDRESS4']??'';
          }

          var totalAmount =  kotDetails['NETAMT'].toString();
          var phoneNum =  mobNo + ' - ' + mobNo2;
          var lstrCreateDate  = kotDetails["CREATE_DATE"]??"";

          if(lstrCreateDate != ""){
            var now = DateTime.now();
            lstrCreateDate = formatTime.format(DateTime.parse(lstrCreateDate)).toString();

          }


          return GestureDetector(
            onTap: (){
              setState(() {
                selectedTakeAwayNo = lstrOrderNo;
                lstrSelectedRoomYn  = lstrOrderMode == g.wstrRoomPriceList?"Y":"";
                lstrSelectedDelvMode  = lstrOrderMode;
              });
              fnTakeAwayClick(dataList,snapshot.data,lstrOrderNo,lstrCreateDate);
            },
            child: ClipPath(
              clipper: MovieTicketClipper(),
              child: Container(
                padding: EdgeInsets.all(10),
                child:  SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(7),
                        decoration: boxBaseDecoration(lstrOrderSts =="P"?Colors.amber.withOpacity(0.3):lstrOrderSts =="R"?Colors.blue.withOpacity(0.3):lstrOrderSts =="K"?Colors.green.withOpacity(0.3): Colors.white, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              th('#' + lstrOrderNo,Colors.black,15),
                              tcn(lstrOrderSts =="P"?"Waiting":lstrOrderSts =="R"?"Preparing":lstrOrderSts =="K"?"Ready":"",Colors.black,12),
                            ],
                          )),
                      gapHC(5),
                      lineC(0.2, Colors.black),
                      gapHC(5),
                      clockRow(lstrCreateDate),
                      Row(
                        children: [
                          Icon(Icons.person, size: 15,),
                          gapWC(10),
                          tcn(fName + '  '+lstrOrderMode ,Colors.black,15),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.phone, size: 15,),
                          gapWC(10),
                          tcn(phoneNum,Colors.black,15),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.sticky_note_2_outlined, size: 15,),
                          gapWC(10),
                          tcn(carNum.toString(),Colors.black,15),
                        ],
                      ),
                      gapHC(10),
                      lineC(0.2, Colors.black),
                      gapHC(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          th('AED  '+ totalAmount,PrimaryColor,18),
                        ],
                      )

                    ],
                  ),
                ),
                decoration: boxDecoration( selectedTakeAwayNo == lstrOrderNo?blueLight: Colors.white, 0),
              ),
            ),
          );
        });
  }
  Widget deliveryView(snapshot){
    if(snapshot.data['OrderList'] == null){
      return Container();
    }
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: .9,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data['OrderList'].length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data['OrderList'][index];
          var kotDetails = snapshot.data['TableDet'][index];
          var lstrOrderNo = dataList["Docno"];
          var lstrDoctype =  kotDetails["DOCTYPE"]??"";
          var lstrOrderSts = kotDetails["PREP_STATUS"]??"";
          var lstrAddressDetails = dataList["Address"]??[];
          var fName = "";
          var mobNo= "";
          var mobNo2= "";

          if(g.fnValCheck(lstrAddressDetails)){
            fName =  lstrAddressDetails[0]['FNAME'];
            mobNo =  lstrAddressDetails[0]['PHONE1'];
            mobNo2 =  lstrAddressDetails[0]['PHONE2'];
          }

          var totalAmount =  kotDetails['NETAMT'].toString();
          var lstrCreateDate  = kotDetails["CREATE_DATE"]??"";
          var lstrDeliveryMode  = kotDetails["ORDER_MODE"]??"";
          var lstrOrderRoom  = kotDetails["ORDER_ROOM"]??"";
          var lstrDeliveryRef  = kotDetails["ORDER_REF"]??"";
          var lstrDriver  = kotDetails["DEL_MAN_CODE"]??"";
          var lstrDriverName  = kotDetails["DRIVER_NAME"]??"";
          var lstrVehicle  = kotDetails["VEHICLE_NO"]??"";

          if(lstrCreateDate != ""){
            var now = DateTime.now();
            lstrCreateDate = formatTime.format(DateTime.parse(lstrCreateDate)).toString();

          }

          var phoneNum =  mobNo + ' - ' + mobNo2;
          return GestureDetector(
            onTap: (){
              setState(() {
                selectedTakeAwayNo = lstrOrderNo;
                lstrSelectedRoomYn  = lstrDeliveryMode == g.wstrRoomPriceList?"Y":"";
                lstrSelectedDelvMode  = lstrDeliveryMode;
              });
              fnDeliveryClick(dataList,snapshot.data,lstrOrderNo,lstrCreateDate);
            },
            child: ClipPath(
              clipper: MovieTicketClipper(),
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: EdgeInsets.all(7),
                        decoration: boxBaseDecoration(lstrOrderSts =="P"?Colors.amber.withOpacity(0.3):lstrOrderSts =="R"?Colors.blue.withOpacity(0.3):lstrOrderSts =="K"?Colors.green.withOpacity(0.3): Colors.white, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            th('#' + lstrOrderNo,Colors.black,15),
                            tcn(lstrOrderSts =="P"?"Waiting":lstrOrderSts =="R"?"Preparing":lstrOrderSts =="K"?"Ready":"",Colors.black,12),
                          ],
                        )),
                    //th('Order   #' + lstrOrderNo,Colors.black,14),
                    tc( lstrDeliveryMode+' - '+ (lstrOrderRoom == ""?"":(lstrOrderRoom+' - '))+lstrDeliveryRef,Colors.black,14),
                    gapHC(10),
                    lineC(0.2, Colors.black),
                    gapHC(10),
                    clockRow(lstrCreateDate),
                    gapHC(5),

                    Row(
                      children: [
                        Icon(Icons.person, size: 20,),
                        gapWC(10),
                        tcn(fName == ""?lstrDeliveryMode:fName,Colors.black,15),
                      ],
                    ),
                    gapHC(5),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 20,),
                        gapWC(10),
                        tcn(phoneNum,Colors.black,15),
                      ],
                    ),
                    gapHC(5),
                    Row(
                      children: [
                        Icon(Icons.manage_accounts_rounded, size: 20,),
                        gapWC(5),
                        PopupMenuButton<popEnum>(
                          enabled: true,
                          position: PopupMenuPosition.under,
                          tooltip: "",
                          onSelected: (popEnum item) {

                          },
                          shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<popEnum>>[
                            PopupMenuItem<popEnum>(
                              value: popEnum.itemOne,
                              padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                              child: wSearchPopupChoice("DELIVERY",lstrOrderNo,lstrDoctype,lstrDriver,lstrVehicle),
                            ),
                          ],
                          child:  lstrDriver.toString().isEmpty?
                          Container(
                            decoration: boxDecoration(Colors.green, 30),
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                            child: tcn('Driver', Colors.white, 12),
                          ):
                          Container(
                            decoration: boxDecoration(Colors.blue, 30),
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                            child: tcn('Change', Colors.white, 12),
                          ),
                        ),
                        gapWC(10),
                        tcn("$lstrDriverName",Colors.black,15),
                        gapWC(10),

                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.delivery_dining, size: 20,),
                        gapWC(5),
                        PopupMenuButton<popEnum>(
                          enabled: true,
                          position: PopupMenuPosition.under,
                          tooltip: "",
                          onSelected: (popEnum item) {

                          },
                          shape:  RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<popEnum>>[
                            PopupMenuItem<popEnum>(
                              value: popEnum.itemOne,
                              padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 0),
                              child: wSearchPopupChoice("VEHICLE",lstrOrderNo,lstrDoctype,lstrDriver,lstrVehicle),
                            ),
                          ],
                          child:  lstrVehicle.toString().isEmpty?
                          Container(
                            decoration: boxDecoration(Colors.green, 30),
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                            child: tcn('Vehicle', Colors.white, 12),
                          ):
                          Container(
                            decoration: boxDecoration(Colors.blue, 30),
                            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 1),
                            child: tcn('Change', Colors.white, 12),
                          ),
                        ),
                        gapWC(10),
                        tcn("$lstrVehicle",Colors.black,15),
                        gapWC(10),

                      ],
                    ),
                    gapHC(5),
                   lineC(0.2, Colors.black),
                    gapHC(10),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       th('AED  '+ totalAmount,PrimaryColor,18),
                     ],
                   )

                  ],
                ),
                decoration: boxDecoration(selectedTakeAwayNo == lstrOrderNo?blueLight: Colors.white, 15),
              ),
            ),
          );
        });
  }
  Widget fnCallTable(chair,oChair,mode,name,type,order,time,size){
    if(type == 'S'){
      return ctableSquare(chair,oChair,mode,name,int.parse(order),time,size,lstrSelectedTableNo);
    }else if(type == 'R'){
      return ctableRound(chair,oChair,mode,name,int.parse(order),lstrSelectedTableNo);
    }else if(type == 'L'){
      return ctableRectangle(chair,oChair,mode,name,int.parse(order),lstrSelectedTableNo);
    }else{
      return Container();
    }
  }

  Widget wSearchPopupChoice(mode,docno,doctype,driver,vehicle){
    Widget rtnWidget  =  Container();

    if(mode  == "DELIVERY"){
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'DEL_MAN_CODE', 'Display': 'Driver'},
        {'Column': 'NAME', 'Display': 'Name'},
        {'Column': 'VEHICLE_NO', 'Display': 'Vehicle'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
      ];
      var lstrFilter =[];

      rtnWidget = Lookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'CRDELIVERYMANMASTER',
        title: 'Driver',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'DEL_MAN_CODE',
        mode: "S",
        layoutName: "B",
        callback: (data){
          if(g.fnValCheck(data)){
            apiUpdateKotDelivery(docno, doctype, (data['DEL_MAN_CODE']??""), vehicle);
          }
        },
        searchYn: 'Y',
      );
    }
    else if(mode  == "VEHICLE"){
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'VEHICLE_NO', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Vehicle'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
      ];
      var lstrFilter =[];

      rtnWidget = Lookup(
        txtControl: txtController,
        oldValue: "",
        lstrTable: 'CRVEHICLEMASTER',
        title: 'Driver',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'VEHICLE_NO',
        mode: "S",
        layoutName: "B",
        callback: (data){
          if(g.fnValCheck(data)){
            apiUpdateKotDelivery(docno, doctype, driver,(data['VEHICLE_NO']??""));
          }
        },
        searchYn: 'Y',
      );
    }
    return rtnWidget;
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

  //void
  Widget numberPress(text,size) => Bounce(
    onPressed: (){
      fnOnPress(text);
    },
    duration: Duration(milliseconds: 110),
    child: Container(
      height: 60,
      width: size.width*0.1,
      margin: EdgeInsets.only(bottom: 5),
      decoration: boxDecoration(Colors.white, 5),
      child: Center(
        child: tc(text,Colors.black,25),
      ),
    ),
  );
  fnOnPress(mode){
    if(p4){
      //fnLogin();
    }else if(p3){
      p4 = true;
      passCode = passCode+mode;
      //fnLogin();
    }else if(p2){
      p3 = true;
      passCode = passCode+mode;
    }else if(p1){
      p2 = true;
      passCode = passCode+mode;
    }else{
      p1 = true;
      passCode = passCode+mode;
    }

    setState(() {
      passCode =passCode;
    });

  }
  fnOnPressClear(){

    if(p4){
      p4 = false;
    }else if(p3){
      p3 = false;
    }else if(p2){
      p2 = false;
    }else if(p1){
      p1 = false;
    }else{
      passCode = '';
    }

    if(passCode.isNotEmpty){
      passCode = passCode.substring(0, passCode.length - 1);
    }

    setState(() {

      passCode =passCode;
    });
  }


  //===========================================page Functions

  //fn for delivery mode
  fnOnclickDeliveryMode(mode,RoomYN){
    g.wstrOrderType = 'D';
    g.wstrOrderMode = 'ADD';
    g.wstrMenuMode = 'ADD';
    g.wstrLastSelectedAdd = [];
    g.wstrLastSelectedTables = [];
    g.wstrDeliveryMode = mode;
    g.wstrRoomYN = RoomYN;
    Navigator.pushReplacement(context, NavigationController().fnRoute(15));
  }
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

  fnSysytemInfo(){
    PageDialog().showSysytemInfo(context, Container(
      child: Column(

        children: [
          Row(
            children: [
              Icon(Icons.date_range_rounded,size: 20,color: Colors.black,),
              gapWC(10),
              tc(formatDate.format(DateTime.parse(g.wstrClockInDate)).toString(),Colors.black,20)
            ],
          ),
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
    ), mfnLng('System Info'));
  }

  //table
  fnTableDoubleClick(dataList){
    var orderNo = int.parse(dataList['NO_ORDER'].toString()) ;
    var tableCode = dataList['CODE'];
    var tableName = dataList['DESCP'];
    var noOfGuest = dataList['NO_PEOPLE'];
    var noOfChair = dataList['NOOFPERSON'];
    var selectedTable = fnCheckTable(tableCode);

    setState(() {
      sideScreenMode = "T";
      lstrSelectedTableNo = "";
    });
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
    var lstrCreateDate  = dataList['ORDERTIME']??'';
    var lstrDeliveryMode  = dataList['ORDER_MODE']??'';
    var selectedTable = fnCheckTable(tableCode);


    if(lstrCreateDate != ""){
      var now = DateTime.now();
      lstrCreateDate = formatTime.format(DateTime.parse(lstrCreateDate)).toString();
      lstrSelectedTime =lstrCreateDate;
      lstrSelectedRoomYn  = lstrDeliveryMode == g.wstrRoomPriceList?"Y":"";
      lstrSelectedDelvMode  = lstrDeliveryMode;
    }

    if(g.fnValCheck(lstrMultiTable)){
      setState(() {

        sideScreenMode = "T";
        lstrSelectedTableNo = "";
      });
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
          sideScreenMode = "O";
          lstrSelectedTableNo = tableCode;
          lstrSelectedOrderNo = orderNo.toString();
          fnGetTableItems(tableCode,'T');
        });
      }else{
        setState(() {
          sideScreenMode = "T";
          lstrSelectedTableNo = "";
        });
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
    if(!g.fnValCheck(lstrMultiTable)){
      setState(() {
        sideScreenMode = "E";
      });
    }
  }
  fnRemoveAllTable(){
    setState(() {
      lstrSelectedTableNo = "";
      sideScreenMode = "E";
      lstrSelectedName = '';
      txtGuestNo.clear();
      lstrMultiTable.clear();
    });
  }

  //takeaway
  fnTakeAwayClick(dataList,value,docNo,lstrCreateDate){
    var lstrAddressDetails = dataList["Address"]??[];
    var fName = "";
    var mobNo ="";
    var mobNo2 ="";
    if(g.fnValCheck(lstrAddressDetails)){
     fName =  lstrAddressDetails[0]['FNAME'];
     mobNo =  lstrAddressDetails[0]['PHONE1'];
     mobNo2 =  lstrAddressDetails[0]['PHONE2'];
    }
    lstrSelectedTime =lstrCreateDate;

    setState(() {
      lstrSelectedName = fName??'';
      lstrSelectedMob = mobNo +  '   ' +  mobNo2 ;
      lstrSelectedOrderDocNo = docNo;
    });
    fnGetOrderDetails(value);
    setState(() {
      sideScreenMode = "A";
    });
    //PageDialog().showItems(context,takeawayDialogChild(),'Order Details');
  }
  fnDeliveryClick(dataList,value,docNo,lstrCreateDate){

    g.wstrDeliveryMode=dataList["DeliveryMode"]??"";
    var lstrAddressDetails = dataList["Address"]??[];
    var fName ="";
    var mobNo ="";
    var mobNo2 ="";
    if(g.fnValCheck(lstrAddressDetails)){
     fName =  lstrAddressDetails[0]['FNAME'];
     mobNo =  lstrAddressDetails[0]['PHONE1'];
     mobNo2 =  lstrAddressDetails[0]['PHONE2'];
    }
    lstrSelectedTime = lstrCreateDate??"";
    setState(() {
      lstrSelectedName = fName??'';
      lstrSelectedMob = mobNo +  '   ' +  mobNo2 ;
      lstrSelectedOrderDocNo = docNo;
    });
    fnGetOrderDetails(value);
    setState(() {
      sideScreenMode = "D";
    });

    //PageDialog().showItems(context,deliveryDialogChild(),'Order Details');
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
    setState((){
      lstrTotalAmount = '';
      lstrOrderTables = '';
      lstrSelectedItems = [];
      lstrSelectedTabels = [];
      lstrSelectedAddress = [];
    });

    setState(() {
      var dataList = snapshot['OrderList'];
      var selectedData = [];
      var selectedTables = [];
      var selectedAddress = [];
      var selectedKotDet = snapshot['TableDet'];
      if(g.fnValCheck(dataList)){
        for (var e in dataList) {
          var docNo = e["Docno"].toString();
          if( lstrSelectedOrderDocNo == docNo ){
            lstrSelectedKot.add({
              'DOCNO': docNo
            });

            selectedData = e['Items']??[];
            selectedTables  =e['Tables']??[];
            selectedAddress = e['Address']??[];
            break;
          }
        }
      }
      var totalAmount = 0.0;
      var totalQty = 0.0;

      if(g.fnValCheck(selectedData)){
        for (var e in selectedData) {
          var qty = g.mfnDbl(e["QTY1"]);
          var vQty = e['VOID_QTY']??0.0;
          var price =  e["RATE"].toString();
          var vat =  e["TAX_AMT"].toString();
          var taxInclYn =  e["TAXINCLUDE_YN"].toString();
          var totAmt =  double.parse(price) * qty;
          if(taxInclYn == 'Y'){
            totalAmount =(totalAmount + totAmt );
          }else{
            totalAmount =(totalAmount + totAmt )+ double.parse(vat);
          }

          totalQty = totalQty + qty;

          lstrSelectedItems.add({
            "DISHCODE":e['STKCODE'].toString(),
            "DISHDESCP":e['STKDESCP'].toString(),
            "QTY": g.mfnDbl(e['QTY1']) ,
            "PRICE1":e['RATE'],
            "WAITINGTIME":"",
            "NOTE":e["REF1"],
            "REMARKS":"",
            "PREP_STATUS":e["PREP_STATUS"],
            "PRINT_CODE":e["PRINT_CODE"],
            "UNIT1":e['UNIT1'].toString(),
            "KITCHENCODE":e['KITCHENCODE'],
            "ADDON_YN":e["ADDON_YN"],
            "ADDON_STKCODE":e["ADDON_STKCODE"].toString(),
            "NEW":"N",
            "VAT":e["TAX_PER"],
            "TAXINCLUDE_YN":e["TAXINCLUDE_YN"],
            "OLD_STATUS":e["STATUS"],
            "CLEARED_QTY":e["CLEARED_QTY"].toInt().toString(),
            "STATUS":e["STATUS"].toString(),
            "TAXABLE_AMT":e["TAXABLE_AMT"],
            "TAXABLE_AMT":e["TAXABLE_AMT"].toString(),
            "VOID_QTY":e["VOID_QTY"]??0,
            "ADDON_MAX_QTY":(e['ADDON_MAX_QTY']??""),
            "ADDON_MIN_QTY":(e['ADDON_MIN_QTY']??""),
            "TAX_AMT":0,
            "CHOICE_CODE":e['CHOICE_CODE']??"",
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
      lstrOrderTables = tableName + " | "+(selectedKotDet[0]["ORDER_MODE"]??"")+" " +(selectedKotDet[0]["ORDER_ROOM"]??"");
      lstrTotalAmount = 'AED  '+ totalAmount.toStringAsFixed(3);
    });

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
     // Navigator.pop(context);
      fnGetOrderDetails(value);
      sideScreenMode = "O";
      //PageDialog().showItems(context,tableDialogChild(),'Order Details');
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
  fnRefresh(){
    fnPageRefresh();
  }


  //api Call
  fnGetUserDetails() async{
    showToast( g.wstrUserCd);
  }
  fnGetTable() async{
    if(lstrTableCall == 1){
      setState(() {
        lstrTableCall = 0;
      });
      futureTable = apiCall.getTables(g.wstrCompany, g.wstrYearcode ,lstrSelectedFloor,g.wstrUserCd);
      futureTable.then((value) => fnGetTableSuccess(value));
    }

  }
  fnGetTableSuccess(value){
    setState(() {
      lstrTableCall = 1;
    });
    if(value['FLOORS'] != null){
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
        setState(() {
          sideScreenMode = "O";
        });
        //PageDialog().showItems(context,tableDialogChild(),'Order Details');
      }
    }else{
      print(value);
      setState(() {

      });
    }

  }

  fnGetTakeAway() async{
    if(lstrTakeWayCall == 1){
      setState(() {
        lstrTakeWayCall =0;
      });
      futureTakeAway = apiCall.getTableItems(g.wstrCompany, g.wstrYearcode ,'','A');
      futureTakeAway.then((value) => fnGetTakeAwaySuccess(value));
    }

  }
  fnGetTakeAwaySuccess(value){
    setState(() {
      lstrTakeWayCall = 1;
    });
  }

  fnGetDelivery() async{
    if(lstrDeliveryCall == 1){
      setState(() {
        lstrDeliveryCall = 0;
      });
      futureDelivery= apiCall.getTableItems(g.wstrCompany, g.wstrYearcode ,'','D');
      futureDelivery.then((value) => fnGetDeliverySuccess(value));
    }
  }
  fnGetDeliverySuccess(value){
    setState(() {
      lstrDeliveryCall = 1;
    });
    fnGetDeliveryMode();
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

  fnPageRefresh(){
    futureRefresh  = apiCall.pageRefresh(g.wstrCompany,g.wstrYearcode,"KITCHEN",refreshTime);
    futureRefresh.then((value) => fnPageRefreshSuccess(value));
  }
  fnPageRefreshSuccess(value){
    var count = 0;
    var timeT  = '';
      if(g.fnValCheck(value)){
        count =  value[0]["COUNT"];
        timeT = (value[0]["TIME"]??"");
      }
      else
      {
        timeT = refreshTime;
        count = pageCount;
      }
      if(pageCount != count){
        if(pageCount > 0){
          //_audioCache.play('waiter.mp3');
          player.setSourceBytes(audiobytes);
        }
        //fnSpeach();

        if(sideScreenMode == "E"){
          fnGetTable();
        }
        if(sideScreenMode == "AT"){
          fnGetTakeAway();
        }
        if(sideScreenMode == "DT"){
          fnGetDelivery();
        }
      }
      if(mounted){
        setState(() {
          refreshTime =  timeT;
          pageCount = count;
        });
      }
  }

  //cancel
  fnCancelOrder(){
    if(lstrCancelMode == "VOID_CANCEL" && txtReason.text.isEmpty){
      showToast( "Please fill reason note..");
      return;
    }
    lstrKot = [];
    lstrKot.add({
      "COMPANY" : g.wstrCompany,
      "YEARCODE":g.wstrYearcode,
      "DOCNO":g.wstrLastSelectedKotDocno,
      "EDIT_USER":g.wstrUserCd,
      "CREATE_MACHINEID":g.wstrDeivceId,
      "CREATE_MACHINENAME":g.wstrDeviceName,
    });

    PageDialog().cancelDialog(context, fnCancel);
  }

  fnCancel() async{
    Navigator.pop(context);
    futureCancelOrder=  apiCall.saveOrder(lstrKot,null,null,null,lstrCancelMode,passCode,lstrSelectedVoidCode,txtReason.text,[]);
    futureCancelOrder.then((value) => fnCancelSuccess(value));
  }
  fnCancelSuccess(value){
    fnOnPressClear();
    if(g.fnValCheck(value)){
      print(value);
      var sts =  value[0]['STATUS'];
      var msg =  value[0]['MSG'];

      if(sts == '1'){
        fnGetTable();
        setState(() {
          txtReason.clear();
          p4 = false;
          p3 = false;
          p2 = false;
          p1 = false;
          passCode = '';

          sideScreenMode = "E";
        });
       // Navigator.pushReplacement(context, NavigationController().fnRoute(1));
      }else if(sts == '2'){
        fnGetTable();
        setState(() {
          sideScreenMode = "V";
        });
        // Navigator.pushReplacement(context, NavigationController().fnRoute(1));
      }
      else{
        setState(() {
          sideScreenMode = "V";
        });
      }
      showToast( msg??'');
    }else{

      showToast( 'Failed');
    }
  }




  //api for delivery=====================================================

  fnGetDeliveryMode(){
    futureDeliveryMOde = apiCall.getDeliveryModes();
    futureDeliveryMOde.then((value) => fnGetDeliveryModeSuccess(value));

  }
  fnGetDeliveryModeSuccess(value){
    print(value);
    if(g.fnValCheck(value)){
      setState((){
        lstrDeliveryOptions = value;
      });
    }
  }

  apiUpdateKotDelivery(docNo, doctype, delManCode, vehicleNo){
    futureForm =apiCall.apiUpdateKotDelivery(docNo, doctype, delManCode, vehicleNo);
    futureForm.then((value) => apiUpdateKotDeliveryRes(value));
  }
  apiUpdateKotDeliveryRes(value){
    //if(g.fnget)
    print(value);
    if(g.fnValCheck(value)){

      var sts =  value[0]['STATUS'];
      var msg =  value[0]['MSG'];

      if(sts == '1'){
        successMsg(context, "UPDATED");
        fnGetDelivery();
      }else{
        errorMsg(context, msg);
      }
    }

  }


  //navigation
  fnLogout() async{
    final SharedPreferences prefs = await _prefs;
    var scMode = prefs.getString('wstrOrderScreenMode');
    setState(() {
      //screenMode = g.wstrOrderScreenMode;
      screenMode =  scMode??"W";
    });
    if(screenMode == "P"){
      Navigator.pushReplacement(context, NavigationController().fnRoute(9));

    }else{


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

  fnGetReason(){
    futureReason =  apiCall.getReason();
  }

  fnCheckDocDate(){
    var rtnSts = false;
    var lstrToday;
    var formatClockDate =  DateFormat('yyyy-MM-dd HH:mm:ss');
    if(g.wstrClockInDate != null){
      var checkDate = DateTime.parse(formatClockDate.format(DateTime.parse(g.wstrClockInDate).add(Duration(days:1))));
      //var checkDate = DateTime.parse(formatDate2.format(DateTime.parse(g.wstrClockInDate)));
      var checkDateTime  =  DateTime(checkDate.year,checkDate.month,checkDate.day,4,0,0);
      var now = DateTime.now();
      lstrToday = DateTime.parse(formatClockDate.format(now));
      rtnSts  =  lstrToday.isBefore(checkDateTime);
    }
    return rtnSts;
  }


  //=================AUDIO
  // Future _speak() async{
  //   var result = await flutterTts.speak("Hello World");
  //   if (result == 1) setState(() => ttsState = TtsState.playing);
  // }
  //
  // Future _stop() async{
  //   var result = await flutterTts.stop();
  //   if (result == 1) setState(() => ttsState = TtsState.stopped);
  // }
  //
  // fnSpeach() async{
  //   await flutterTts.setLanguage("en-US");
  //   await flutterTts.setSpeechRate(0.5); //speed of speech
  //   await flutterTts.setVolume(1.0); //volume of speech
  //   await flutterTts.setPitch(1); //pitc of sound
  //
  //   //play text to sp
  //   var result = await flutterTts.speak("Hello World, this is Flutter Campus.");
  //   if(result == 1){
  //     //speaking
  //   }else{
  //     //not speaking
  //   }
  // }


}
