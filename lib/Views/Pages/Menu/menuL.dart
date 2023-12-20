
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/lookup.dart';
import 'package:beamsbistro/Views/Components/lookup_alert.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:beamsbistro/Views/Pages/Menu/choiceSelection.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:beamsbistro/main.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
//import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import 'package:intl/intl.dart';
import 'package:oktoast/oktoast.dart';
import 'package:badges/badges.dart' as badges;


import 'addon.dart';



class MenuL extends StatefulWidget {
  const MenuL({Key? key}) : super(key: key);

  @override
  _MenuLState createState() => _MenuLState();
}

class _MenuLState extends State<MenuL> {


  var wstrPageMode= '';

  var txtQty = new TextEditingController();
  var txtNote = new TextEditingController();
  var txtReason = new TextEditingController();
  var lstrQty = 0;
  var orderNo = '';
  var lstrTableName = '';
  var avgTime ='0.00';
  var lastLevel= 0;

  var lstrMenuCode ;
  var lstrMenuGroup ;
  var lstrGp1 ;
  var lstrGp2 ;
  var lstrGp3 ;
  var lstrGp4 ;
  var lstrGp5 ;
  var lstrGp6 ;
  var lstrGp7 ;
  var lstrGp8 ;
  var lstrGp9 ;
  var lstrGp10 ;
  var lstrSearch;
  var txtSearchDishCode = new TextEditingController();

  var arrMenuCode ;
  var arrMenuGroup ;
  var arrGp1 ;
  var arrGp2 ;
  var arrGp3 ;
  var arrGp4 ;
  var arrGp5 ;
  var arrGp6 ;
  var arrGp7 ;
  var arrGp8 ;
  var arrGp9 ;
  var arrGp10 ;

  //Order
  var lastOrder = [];
  var lastOrderHead = [];
  var lastOrderTable = [];
  var lastOrderAddress = [];
  var lstrAddonDataList;

  var lstrOrderQty = '';
  var lstrOrderQtyV = 0.0;
  var lstrOrderAmountV = 0.0;
  var lstrOrderGross = 0.00;
  var lstrOrderVat = 0.00;
  var lstrOrderTotal = 0.00;
  var lstrTaxableAmt = 0.00;

  var lstrOrderAmount = '0:00';
  var wstrSelectedTables = [];

  var lstrSelectedStkCode = '';
  var lstrSelectedStkDescp = '';
  var lstrSelectedDishGroup = '';
  var lstrSelectedRate = '';
  var lstrSelectedTime = '';
  var lstrKitchenNote = '';
  var lstrSelectedQty = '';
  var lstrSelectedNote= '';
  var lstrSelectedCategory = '';
  var lstrSelectedCategoryList = [];
  var lstrOrderType = '';

  //choice
  var lstrSelectedChoiceCode = '';
  var lstrSelectedChoices = [];
  var lstrSelectedItem = [];
  var lstrSelectedInstructions = [];
  var lstrLastInstructions = [];
  var lstrSelectedColor =  PrimaryColor;


  ApiCall apiCall = ApiCall();
  Global g = Global();
  late Future<dynamic> futurePage;
  late Future<dynamic> futureMenu;
  late Future<dynamic> futureAddon;
  late Future<dynamic> futureOrder;
  late Future<dynamic> futureReason;
  late Future<dynamic> futureChoice;
  late Future<dynamic> futureView;

  //address
  var txtFullName = TextEditingController();
  var txtLastName = TextEditingController();
  var txtAddress1 = TextEditingController();
  var txtAddress2 = TextEditingController();
  var txtLandMark = TextEditingController();
  var txtMob1 = TextEditingController();
  var txtMob2 = TextEditingController();
  var txtDeliveryNote = TextEditingController();
  var txtKitchenNote = TextEditingController();
  var txtAddNote = TextEditingController();
  var txtVehicleNo = TextEditingController();
  var txtCouponNo = TextEditingController();
  var txtRoomNo = TextEditingController();
  var txtSearch = TextEditingController();


  //SEARCH
  var lstrSearchResult= [];
   //save order
  bool viewOrderBtnSts =true;
  var lstrKot = [];
  var lstrKotDet = [];
  var lstrKotTableDet = [];
  var lstrKotDelivryDet = [];
  var lstrKotChoice = [];

  //void order
  bool p1 =false;
  bool p2 =false;
  bool p3 =false;
  bool p4 =false;
  var  passCode  ='';
  var voidMode = "N";
  var lstrSelectedVoidCode = "";

  //sidemenu
  //O- ORDERVIEW | D- DETAILVIEW / A- ADDRESS / V- VOID MODE
  var sidePageView = "O";


  //printer
 // var printerManager = PrinterManager.instance;
  var printHead = [];
  var printDet =[];
  var kotPrinterList = [];
  var kotPrintData = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fnGetPageData();
    fnGetTableName();
    fnGetMenu();
    fnGetReason();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    g.wstrContext = this.context;
    return WillPopScope(
        child: Scaffold(
      //appBar: navigationTitleAppBar(context,(g.wstrOrderType =='T'?  'Table ' : g.wstrOrderType =='A'? 'TAKEAWAY ': 'DELIVERY ') + lstrTableName.toString() , fnPageBack),
      body: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 35,left: 10,right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          fnPageBack();
                        },
                        child: Icon(Icons.arrow_back_outlined),
                      ),
                      gapWC(10),

                      Container(
                        width: 200,
                        height: 40,
                        decoration: boxDecoration(Colors.white, 30),
                        child: DropdownButtonFormField(
                            value: g.wstrOrderType =='T'?  'Table' : g.wstrOrderType =='A'? 'Takeaway': 'Delivery',
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: InputBorder.none,

                            ),
                            items: <String>['Table', 'Takeaway', 'Delivery'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(), onChanged: (value){
                              print(value);
                             setState((){
                               g.wstrOrderType = value =="Table"?'T': value =='Takeaway'? 'A': 'D';
                             });
                              print(g.wstrOrderType);
                        }),
                      ),
                      gapWC(10),
                      g.wstrOrderType == "T"?
                      GestureDetector(
                        onTap: (){

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          decoration: boxDecoration(Colors.white, 5),
                          child: Row(
                            children: [
                              th(((g.wstrOrderType =='T'?  'Table' : g.wstrOrderType =='A'? 'TAKEAWAY ': 'DELIVERY ' )+ lstrTableName.toString() ),Colors.black,16),
                            ],
                          ),
                        ),
                      ):gapWC(0),
                      gapWC(10),
                      GestureDetector(
                        onTap: (){
                          if(g.wstrOrderType =='T'){
                            g.wstrTableUpdateMode = 'M';
                            Navigator.pushReplacement(context, NavigationController().fnRoute(7));
                          }
                        },
                        child:Container(
                          width: 60,
                          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          decoration: boxDecoration(Colors.amber, 5),
                          child: Center(
                            child: Icon(Icons.compare_arrows),
                          ),
                        )
                      ),

                    ],
                  ),
                 Row(
                   children: [
                     gapWC(15),
                     GestureDetector(
                       onTap: (){
                         fnPageBack();
                       },
                       child: Container(
                         width: 150,
                         height: 40,
                         decoration: boxBaseDecoration(greyLight, 30),
                         child: Center(
                           child: th(mfnLng('Close'),Colors.red,15),
                         ),
                       ),
                     ),


                   ],
                 )

                ],
              ),
            ),
            Expanded(child: Row(
              children: [
                Expanded(child: Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Container(
                        decoration: boxBaseDecoration(Colors.white, 10),
                        width: size.width*0.2,
                        padding: EdgeInsets.all(5),
                        child: menuScreenView(size),
                      ),
                      gapWC(5),
                      Expanded(child:  Container(
                        decoration: boxBaseDecoration(greyLight, 10),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gapHC(5),
                            Row(
                              children: [
                                Expanded(child: tc(lstrSelectedCategory.toString(),Colors.black,18),)
                              ],
                            ),
                            gapHC(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RoundedInputField(
                                  hintText: mfnLng('Search'),
                                  txtRadius: 5,
                                  txtWidth: 0.4,
                                  txtHeight:35,
                                  txtController: txtSearchDishCode,
                                  suffixIcon: Icons.cancel_outlined,
                                  suffixIconOnclick: (){
                                    fnClearSearch();
                                  },
                                  onChanged: (value){
                                    fnSearchDishCode();
                                  },
                                ),
                                gapWC(5),
                              ],
                            ),
                            Expanded(child: futureMenuview(),)
                          ],
                        ),

                      ),)
                    ],
                  ),

                ),),
                Container(
                  width: size.width*0.3,
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  decoration: boxDecoration(Colors.white, 10),
                  child: sidePageView == "O"?( lastOrder.length==0 ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      gapHC(10),
                      Column(
                        children: [
                          Image.asset("assets/images/empty.jpg",
                            width: 180,),
                          gapHC(10),
                          tcn(mfnLng("Choose Items..."),greyLight,25),
                        ],
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                sidePageView = "A";
                              });
                            },
                            child: Container(
                              width: size.width*0.05,
                              height: 40,
                              decoration: boxBaseDecoration(Colors.amber, 10),
                              child: Center(
                                child: Icon(Icons.person_add_alt_1_rounded),
                              ),
                            ),
                          ),
                          gapWC(10),
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                fnPageBack();
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 5),
                                height: 40,
                                decoration: boxDecoration(PrimaryColor, 60),
                                child: Center(
                                  child: tcn('Close',Colors.white,20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ):
                  Column(
                    children: [
                      Expanded(child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: lastOrder.length,
                          itemBuilder: (context, index) {
                            var dataList = lastOrder[index];
                            var itemCode = dataList['DISHCODE'] ??'';
                            var itemName = dataList['DISHDESCP']??'';
                            var lngName = dataList['LNGNAME']??'';
                            var waitingTime = dataList['WAITINGTIME']??'';
                            var itemPrice = g.mfnDbl(dataList['PRICE1']);
                            var itemQty = dataList['QTY']??'0.0';
                            var itemSts = '';
                            var itemClearedQty = 0;
                            var itemClearedQtyS = '';
                            var addonStkCode =  dataList['ADDON_STKCODE']??"" ;
                            var addonYn = dataList['ADDON_YN']??"N";
                            var addonMax = g.mfnDbl(dataList['ADDON_MAX_QTY']);
                            var addonMin = g.mfnDbl(dataList['ADDON_MIN_QTY']);
                            var choiceCode = dataList['CHOICE_CODE']??"N";

                            var itemNote = dataList['NOTE']??'';

                            itemSts = dataList["OLD_STATUS"].toString();
                            itemClearedQty = int.parse(dataList["CLEARED_QTY"].toString());
                            itemClearedQtyS = itemClearedQty == 0 ? '' :itemClearedQty.toString();
                            var addonItems = fnSelectAddOn(itemCode);
                            var addonItemsQty = fnSelectAddOnQty(itemCode);
                            var addonSts  =  false;
                            var addOnList = "";
                            if(g.fnValCheck(addonItems)){
                              addonSts  =  true;
                              for(var e in addonItems){
                                if(g.mfnDbl(e['QTY'].toString()) >0){
                                  addOnList += "@ "+e["DISHDESCP"] + " x "+ (e['QTY'].toString()??'0.0') + " - "+ (e['PRICE1'].toString()??'0.0') + " \n";
                                }
                              }
                            }
                            var itemqty1 = 0.0;
                            itemqty1 = g.mfnDbl(itemQty.toString());

                            var addMinQty = g.mfnDbl(addonMin);
                            addMinQty = g.mfnDbl(dataList['QTY']) == 0?  g.mfnDbl(addonMin):  (g.mfnDbl(addonMin) * g.mfnDbl(dataList['QTY']));


                            return addonStkCode == "" || addonStkCode == "null"?
                            GestureDetector(
                              onTap: (){

                                  print("================++CHOICE");
                                  print(choiceCode);
                                  print("================");
                                if(choiceCode != "" && choiceCode != null && choiceCode != "N"){
                                  //show choice view
                                  fnGetChoiceList(dataList,choiceCode);
                                }else{
                                  if(addonMin > 0  &&  addonYn == "Y" && (addMinQty+1) > addonItemsQty){
                                    var itemData = [];
                                    itemData.add({
                                      "DISHCODE":itemCode,
                                      "MODE":'ADD',
                                      "ENTER_QTY":1.0,
                                      "CLEARED_QTY":itemClearedQty,
                                      "ITEM_STATUS":itemSts
                                    });
                                    fnGetAddOnCombo('ADDON',itemCode,dataList,1.0,'ADD',itemData);
                                  }else{
                                    fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
                                  }
                                }


                              },
                              onLongPress: (){

                                double.parse(itemQty) > 0? fnShowNotePopupSelected(dataList):'';
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(bottom: 5),
                                padding: EdgeInsets.only(top: 0,bottom: 0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                        children: <Widget>[

                                          Expanded(child:
                                          GestureDetector(
                                            child: Container(
                                                padding: EdgeInsets.only(left: 10),
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
                                                        lngName.toString().isNotEmpty?
                                                        tc(lngName.toString() ,Colors.black,12):gapHC(0),
                                                        tc(itemName.toString() ,Colors.black,12),
                                                        gapHC(0),
                                                        tcn('AED  ' + itemPrice.toString(),PrimaryColor,12),
                                                        //catS('AED  ' + itemPrice.toString()),
                                                        gapHC(2),
                                                        addonYn == "Y" ?
                                                        GestureDetector(
                                                          onTap: (){
                                                            fnGetAddOnCombo('ADDON',itemCode,dataList,0,'',[]);
                                                          },
                                                          child:  tc('Add-ons  : ',Colors.black,14),
                                                        ):
                                                        Container(),
                                                        addonSts ?
                                                        GestureDetector(
                                                          onTap: (){
                                                            fnGetAddOnCombo('ADDON',itemCode,dataList,0,'',[]);
                                                          },
                                                          child:tcn(addOnList.toString(),Colors.black,12),
                                                        ):Container(),

                                                      ],
                                                    ),)
                                                  ],
                                                )
                                            ),
                                          )),
                                          Container(
                                              child:  GestureDetector(
                                                onTap: (){
                                                  if(choiceCode != "" && choiceCode != null && choiceCode != "N"){
                                                    //show choice view
                                                    fnGetChoiceList(dataList,choiceCode);
                                                  }else{
                                                    if(addonMin > 0  &&  addonYn == "Y" && (addMinQty+1) > addonItemsQty){
                                                      var itemData = [];
                                                      itemData.add({
                                                        "DISHCODE":itemCode,
                                                        "MODE":'MINUS',
                                                        "ENTER_QTY":1.0,
                                                        "CLEARED_QTY":itemClearedQty,
                                                        "ITEM_STATUS":itemSts
                                                      });
                                                      double.parse(itemQty) > 0?
                                                      fnGetAddOnCombo('ADDON',itemCode,dataList,1.0,'MINUS',itemData):'';
                                                    }else{
                                                      double.parse(itemQty) > 0?
                                                      fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty):'';
                                                    }
                                                  }




                                                },
                                                onLongPress: (){
                                                  fnRemoveItemSelected(dataList);
                                                  // fnRemoveItemSelected(dataList,orderData);
                                                },
                                                child: Container(
                                                  width:60,
                                                  height:40,
                                                  margin: EdgeInsets.all(10),
                                                  decoration: boxDecoration(g.mfnDbl(itemQty) >0? Colors.white: Colors.red, 5),
                                                  child: Center(
                                                    child: Icon(Icons.remove_circle_outline_outlined,color: Colors.black,size: 25,),
                                                  ),
                                                ),
                                              )
                                          )
                                        ],
                                      ),
                                      itemNote == ""?Container():
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        child:  ts('${mfnLng("Note")} : '+itemNote,Colors.black,15),
                                      )
                                    ],
                                  ),
                                ),
                                decoration: boxBaseDecoration(blueLight, 7),
                              ),
                            ):Container();
                          })),
                      gapHC(5),
                      lineC(0.2, Colors.black),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            th(mfnLng('Selected Items'), Colors.black, 15),
                            gapW(),
                            tc((lastOrder.length).toString(), Colors.black, 18),
                          ],
                        ),
                      ),
                      lineC(0.2, Colors.black),
                      gapHC(10),
                      Container(
                        padding: EdgeInsets.all(5),
                        color: greyLight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            th(mfnLng('Total Amount'), Colors.red, 15),
                            gapW(),
                            tc(lstrOrderAmountV.toStringAsFixed(3), Colors.red, 18),
                          ],
                        ),
                      ),
                      gapHC(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              fnPageBack();
                            },
                            child: Container(
                              width: size.width*0.05,
                              height: 40,
                              decoration: boxBaseDecoration(greyLight, 10),
                              child: Center(
                                child: Icon(Icons.cancel_outlined),
                              ),
                            ),
                          ),
                          gapWC(5),
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                sidePageView = "A";
                              });
                            },
                            child: Container(
                              width: size.width*0.04,
                              height: 40,
                              decoration: boxBaseDecoration(Colors.amber, 10),
                              child: Center(
                                child: Icon(Icons.person_add_alt_1_rounded),
                              ),
                            ),
                          ),
                          gapWC(5),
                          GestureDetector(
                            onTap: (){
                              g.wstrTableUpdateMode = 'M';
                              Navigator.pushReplacement(context, NavigationController().fnRoute(7));
                            },
                            child: Container(
                              width: size.width*0.04,
                              height: 40,
                              decoration: boxBaseDecoration(Colors.amber, 10),
                              child: Center(
                                child: Icon(Icons.table_chart),
                              ),
                            ),
                          ),
                          gapWC(5),
                          Expanded(child: GestureDetector(
                            onTap: (){
                              viewOrderBtnSts ==  true? fnSaveValidate():'';
                            },
                            child: Container(
                              height: 40,
                              decoration: boxGradientDecoration(16, 60),
                              child: Center(
                                child: tc(mfnLng('SEND TO KOT'),Colors.white,15),
                              ),
                            ),
                          ))
                        ],
                      ),
                      gapHC(10),

                    ],
                  )):sidePageView == "D"?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.menu_book),
                              gapW(),
                              th(lstrSelectedStkDescp.toString(),Colors.black,15),
                            ],
                          ),
                          tc('AED  '+lstrSelectedRate.toString() ,PrimaryColor,15),
                          gapHC(10),
                          tcn(mfnLng('Qty'),Colors.black,15),
                          gapHC(5),
                          Container(
                            height: 50,
                            width: size.width*0.1,
                            padding: EdgeInsets.all(3),
                            decoration: boxBaseDecoration(greyLight, 10),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              style: TextStyle(fontSize: 18.0),
                              maxLines: 10,
                              controller: txtQty,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          // tc('x ' + lstrSelectedQty.toString() ,Colors.black,20),
                          gapHC(10),
                          tcn(mfnLng('Kitchen Note'),Colors.black,15),
                          gapHC(5),
                          Row(
                            children: [
                              Expanded(child: Container(
                                height: 120,
                                padding: EdgeInsets.all(10),
                                decoration: boxBaseDecoration(greyLight, 10),
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  style: TextStyle(fontSize: 18.0),
                                  maxLines: 10,
                                  controller: txtNote,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),),
                              gapWC(10),
                              GestureDetector(
                                onTap: (){
                                  setState(() {
                                    txtNote.text = '';
                                  });
                                },
                                child: Container(
                                  decoration: boxBaseDecoration(blueLight, 10),
                                  height: 120,
                                  width: 50,
                                  child: Center(
                                    child: Icon(Icons.delete_sweep_sharp),
                                  ),
                                ),
                              )

                            ],
                          ),
                          gapHC(10),
                          g.fnValCheck(lstrLastInstructions)?
                          Container(
                            height: 100,
                            child: GridView.builder(
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    maxCrossAxisExtent: 200,
                                    childAspectRatio:  6,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                                itemCount:  lstrLastInstructions.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  var dataList = lstrLastInstructions[index];
                                  var code = dataList['CODE'] ??'';
                                  var descp = dataList['DESCP']??'';
                                  var dishGrop = dataList['DISH_GROUP']??'';
                                  var sts = true;
                                  // if(lstrSelectedDishGroup == dishGrop){
                                  //   sts = true;
                                  // }

                                  return sts ? GestureDetector(
                                    onTap: (){
                                      fnUpdateNoteText(descp);
                                    },
                                    child: Container(
                                      height: 30,
                                      decoration: boxBaseDecoration(Colors.amber, 5),
                                      padding: EdgeInsets.all(3),
                                      child: Center(
                                        child: tc(descp.toString(),Colors.black,15),
                                      ),
                                    ),
                                  ):Container() ;
                                }),
                          ) : Container(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                sidePageView = "O";
                              });
                            },
                            child: Container(
                              height: 40,
                              width: size.width*0.1,
                              margin: EdgeInsets.only(bottom: 5),
                              decoration: boxBaseDecoration(greyLight, 60),
                              child: Center(
                                child: tc(mfnLng('Close'),Colors.black,15),
                              ),
                            ),
                          ),
                          gapWC(10),
                          Expanded(child: GestureDetector(
                            onTap: (){
                              fnItemNoteCallBack(lstrSelectedStkCode,txtNote.text.toString(),txtQty.text);
                            },
                            child: Container(
                              height: 40,
                              decoration: boxGradientDecoration(16, 60),
                              child: Center(
                                child: tc(mfnLng('ADD'),Colors.white,15),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ],
                  ):sidePageView == "A"?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: boxBaseDecoration(greyLight, 5),
                        child: TextFormField(
                          controller: txtSearch,

                          decoration:  InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                              suffixIcon:
                              GestureDetector(
                                onTap: (){
                                  if(mounted){
                                    setState(() {
                                      txtSearch.clear();
                                    });
                                  }
                                },
                                  child: Icon( txtSearch.text.isEmpty? Icons.search:Icons.clear, color: PrimaryColor),
                              ),

                          ),

                          onChanged: (value) {
                            apiSearchCustomer();
                          },
                        ),
                      ),
                      txtSearch.text.isEmpty?
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [

                                gapHC(10),
                                g.wstrRoomYN=="Y"?
                                RoundedInputField(
                                  hintText: (mfnLng("Room No")),
                                  labelYn: 'Y',
                                  txtRadius: 5,
                                  txtController: txtRoomNo,
                                  suffixIcon:  Icons.search ,
                                  suffixIconOnclick: () {
                                    fnLookup('ROOM','');
                                  },
                                  onChanged: (value) {
                                    fnLookup('ROOM','');
                                  },

                                ):gapHC(0),

                                RoundedInputField(
                                  hintText: ( g.wstrRoomYN=="Y"?mfnLng("Coupon No"):(g.wstrDeliveryMode!=""?mfnLng('Ref No'):mfnLng('Vehicle No'))),
                                  labelYn: 'Y',
                                  txtRadius: 5,
                                  txtController: txtVehicleNo,
                                ),
                                // RoundedInputField(
                                //   hintText: 'Coupon No',
                                //   labelYn: 'Y',
                                //   txtRadius: 5,
                                //   txtController: txtCouponNo,
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    RoundedInputField(
                                      hintText: mfnLng('Mobile No'),
                                      labelYn: 'Y',
                                      txtRadius: 5,
                                      textType: TextInputType.number,
                                      txtController: txtMob1,
                                      txtWidth: 0.13,
                                    ),
                                    RoundedInputField(
                                      hintText: mfnLng('Mobile No 2'),
                                      labelYn: 'Y',
                                      txtRadius: 5,
                                      textType: TextInputType.number,
                                      txtController: txtMob2,
                                      txtWidth: 0.13,
                                    ),
                                  ],
                                ),
                                RoundedInputField(
                                  hintText: mfnLng('First Name'),
                                  txtRadius: 5,
                                  labelYn: 'Y',
                                  txtController: txtFullName,
                                ),
                                RoundedInputField(
                                  hintText: mfnLng('Last Name'),
                                  labelYn: 'Y',
                                  txtRadius: 5,
                                  txtController: txtLastName,
                                ),
                                RoundedInputField(
                                  hintText: mfnLng('Full Address'),
                                  labelYn: 'Y',
                                  txtRadius: 5,
                                  txtController: txtAddress1,
                                ),
                                RoundedInputField(
                                  hintText: mfnLng('Address 2'),
                                  labelYn: 'Y',
                                  txtRadius: 5,
                                  txtController: txtAddress2,
                                ),
                                RoundedInputField(
                                  hintText: mfnLng('Landmark'),
                                  labelYn: 'Y',
                                  txtRadius: 5,
                                  txtController: txtLandMark,
                                ),
                                RoundedInputField(
                                  hintText: mfnLng('Delivery Note'),
                                  labelYn: 'Y',
                                  txtRadius: 5,
                                  txtController: txtDeliveryNote,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ):
                      Expanded(child: viewSearchResult()),
                      GestureDetector(

                        onTap: (){
                          setState(() {
                            sidePageView = "O";
                          });
                          //Navigator.pop(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: boxDecoration(PrimaryColor, 30),
                          child: Center(
                            child: th(mfnLng('DONE'),Colors.white,16),
                          ),
                        ),
                      )

                    ],
                  ):sidePageView == "V"?
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //void
                        gapHC(10),
                        Row(
                          children: [
                            gapWC(10),
                            Icon(Icons.delete_sweep,color: Colors.red,),
                            gapWC(5),
                            tc(mfnLng('Item Cancel'),Colors.black,20)
                          ],
                        ),
                        gapHC(10),
                        line(),
                        gapHC(10),
                        ts(mfnLng('Reason Note'),Colors.black,15),
                        gapHC(5),

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
                                  )),
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
                              Container(
                                height: 50,
                                width: size.width*0.3,
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
                                width: size.width*0.3,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(

                              onTap: (){
                                setState(() {
                                  sidePageView = "O";
                                });
                                //Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                width: size.width*0.1,
                                decoration: boxBaseDecoration(greyLight, 30),
                                child: Center(
                                  child: tc(mfnLng('Close'),Colors.black,13),
                                ),
                              ),
                            ),
                            gapWC(5),
                            Expanded(child:  GestureDetector(

                              onTap: (){
                                setState(() {
                                  voidMode = "Y";
                                  viewOrderBtnSts ==  true? fnSaveValidate():'';
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
                  ):Column(
                    children: [],
                  ),

                ),

              ],
            )),
            gapHC(10),
          ],
        ),
      ),
    ),
        onWillPop: () async{
          return fnPageBack();
        },
    );
  }
  //widget
  Widget menuScreenView(Size size) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(child: Container(
          child: FutureBuilder<dynamic>(
            future: futureMenu,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return catView(snapshot);
              } else if (snapshot.hasError) {
                return Container();
              }
              // By default, show a loading spinner.
              return Center(
                child: Container(),
              );
            },
          ),
        )),
        gapHC(10),
        GestureDetector(
          onTap: (){
            lstrMenuGroup != null ? fnBackButton():'';
          },
          onLongPress: (){
            fnBackLongPress();
          },
          child:  Container(
            decoration: boxDecoration(Colors.amber,50),
            height: 40,
            child: Center(
              child: tcn( lstrMenuGroup != null ?mfnLng('BACK'):mfnLng("CATEGORY"), Colors.black, 15),
            ),
          ),
        ),
      ],
    );
  }
  Widget menuGroupView(snapshot){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data['Table2'].length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data['Table2'][index];
          var code = dataList['CODE']??'';
          var menuGroupName = dataList['DESCP']??'';
          return menuGroupName != ""? GestureDetector(
            onTap: (){
              fnUpdateTable(code,menuGroupName);
            },
            child:  Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              margin: EdgeInsets.only(right: 10),
              decoration: boxBaseDecoration(lstrMenuGroup == code ? PrimaryColor :blueLight, 5),
              child: Center(
                child: tc(menuGroupName, lstrMenuGroup == code ? Colors.white : PrimaryText,15),
              ),
            ),
          ):Container();
        });
  }
  Widget itemView(snapshot){
    return GridView.builder(
        gridDelegate:  SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio:  g.wstrImgYn == "Y"? 1.1:1.8,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemCount:  snapshot.data['Table1'].length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data['Table1'][index];
          var itemCode = dataList['DISHCODE'] ??'';
          var itemName = dataList['DISHDESCP']??'';
          var lngName = "";
          if(g.wstrBistroLng == "ARABIC"){
             lngName = (dataList['ARABIC_DESCP']??'').toString();
          }else if(g.wstrBistroLng == "CHINESE"){
            lngName = (dataList['CHINESE_DESCP']??'').toString();
          }
          var waitingTime = dataList['WAITINGTIME']??'';
          var itemPrice = g.mfnDbl(dataList['PRICE1']);
          var addonYn = dataList['ADDON_YN']??"N";
          var addonMax = g.mfnDbl(dataList['ADDON_MAX_QTY']);
          var addonMin = g.mfnDbl(dataList['ADDON_MIN_QTY']);
          var choiceCode = dataList['CHOICE_CODE']??"N";
          var menuYn = dataList['MENU_YN']??"";
          var picPath = dataList['PICPATH']??"";

          var imgUrl = (g.wstrIp.toString().isEmpty?g.wstrBaseUrl:g.wstrIp)+picPath;

          var itemSts = '';
          var itemClearedQty = 0;
          var itemClearedQtyS = '';
          var orderData = fnCheckItem(itemCode);
          bool orderSts  = false;

          var addonItems = fnSelectAddOnQty(itemCode);
          var addonSts  =  false;
          if(addonItems > 0){
            addonSts  =  true;
          }

          if(g.fnValCheck(orderData)){
            var qty = double.parse(orderData["QTY"].toString());
            itemSts = orderData["OLD_STATUS"].toString();
            itemClearedQty = int.parse(orderData["CLEARED_QTY"].toString());
            itemClearedQtyS = itemClearedQty == 0 ? '' :itemClearedQty.toString();
            if(qty > 0){
              orderSts = true;
            }
          }
          var addMinQty = g.mfnDbl(addonMin);
          if(orderSts){
            addMinQty = g.mfnDbl(orderData["QTY"]) == 0?  g.mfnDbl(addonMin):  (g.mfnDbl(addonMin) * g.mfnDbl(orderData["QTY"]));
          }

          return GestureDetector(
            onTap: (){
              if(menuYn == "N"){
                return;
              }
              setState(() {
                sidePageView = "O";
              });
              if(choiceCode != "" && choiceCode != null && choiceCode != "N"){
                //show choice view
                fnGetChoiceList(dataList,choiceCode);
              }else{
              if(addonMin > 0  &&  addonYn == "Y" && (addMinQty+1) > addonItems){
                var itemData = [];
                itemData.add({
                  "DISHCODE":itemCode,
                  "MODE":'ADD',
                  "ENTER_QTY":1.0,
                  "CLEARED_QTY":itemClearedQty,
                  "ITEM_STATUS":itemSts
                });
                fnGetAddOnCombo('ADDON',itemCode,dataList,1.0,'ADD',itemData);
              }else{
                fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
              }
              }

            },
            onLongPress: (){
              if(menuYn == "N"){
                return;
              }
              setState(() {
                lstrAddonDataList = dataList;
              });
              if(choiceCode != "" && choiceCode != null && choiceCode != "N"){
                //show choice view
                fnGetChoiceList(dataList,choiceCode);
              }else if(addonYn == "Y" && orderSts ==true){
                fnGetAddOnCombo('ADDON',itemCode,dataList,0,'',[]);
              }



              //orderSts ==true ? fnShowNotePopup(dataList,orderData):'';
            },

            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  g.wstrImgYn == "Y"?
                  badges.Badge(
                    showBadge: orderSts,
                    badgeContent: tc(orderSts ?  g.mfnDbl(orderData["QTY"].toString()).toStringAsFixed(0) : '', Colors.black,15),
                    badgeStyle: badges.BadgeStyle(
                        padding: EdgeInsets.all(10),
                      badgeColor: Colors.amber
                    ),
                    child: Container(
                      height: 80,
                      width: double.infinity,
                      decoration: boxOutlineCustom1(Colors.white, 10, Colors.grey.withOpacity(0.2), 1.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                        child: Image.network(imgUrl,
                            fit: BoxFit.fitHeight,

                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: boxBaseDecoration(greyLight, 10),
                                alignment: Alignment.center,
                                child: Icon(Icons.food_bank_outlined,color: Colors.grey,size: 40,),
                              );
                            },
                      )

                      ),
                    ),
                  ):gapHC(0),
                  Expanded(child: Row(
                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                gapHC(1),
                                lngName.isNotEmpty?
                                (menuYn == "N"?iName(lngName,"C",""):
                                tcn(lngName.toString(),Colors.black,11)):gapHC(0),
                                (menuYn == "N"?iName(itemName,"C",""):
                                tcn(itemName.toString(),Colors.black,12)),
                                th('AED  ' + itemPrice.toString(),PrimaryColor,13),
                                gapHC(5),
                                g.wstrImgYn != "Y"?
                                tc(orderSts ? 'x ' + orderData["QTY"].toString() : '',Colors.black,15):gapHC(0),
                                // gapHC(5),
                                addonYn == "Y" && orderSts?
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      lstrAddonDataList = dataList;
                                    });
                                    orderSts ==true ? fnGetAddOnCombo('ADDON',itemCode,dataList,0,'',[]):'';
                                  },
                                  child: Container(
                                    decoration: boxBaseDecoration(Colors.blue, 30),
                                    height: 25,
                                    width: 70,
                                    child: Center(
                                      child: tc( 'Add-ons' ,Colors.white,10),
                                    ),
                                  ),
                                )
                                    :Container(),
                              ],
                            ),
                          ),
                        ),
                      )),
                      orderSts ?
                      Container(
                          child:  GestureDetector(
                            onTap: (){


                              setState(() {
                                sidePageView = "O";
                              });

                              if(choiceCode != "" && choiceCode != null && choiceCode != "N"){
                                //show choice view
                                fnGetChoiceList(dataList,choiceCode);
                              }else{
                                if(addonMin > 0  &&  addonYn == "Y" && (addMinQty+1) > addonItems){
                                  if((double.parse(orderData["QTY"].toString())-1) == 0){
                                    fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty);
                                  }else{
                                    var itemData = [];
                                    itemData.add({
                                      "DISHCODE":itemCode,
                                      "MODE":'MINUS',
                                      "ENTER_QTY":1.0,
                                      "CLEARED_QTY":itemClearedQty,
                                      "ITEM_STATUS":itemSts
                                    });
                                    fnGetAddOnCombo('ADDON',itemCode,dataList,1.0,'MINUS',itemData);
                                  }

                                }else{
                                  fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty);
                                }
                              }



                            },
                            onLongPress: (){
                              setState(() {
                                sidePageView = "O";
                              });
                              fnRemoveItem(dataList,orderData);
                            },
                            child: Container(
                              width:40,
                              margin: EdgeInsets.all(10),
                              decoration: boxGradientDecoration(12, 10),
                              child: Center(
                                child: Icon(Icons.remove_circle_outline_outlined,color: Colors.white,size: 20,),
                              ),
                            ),
                          )
                      )
                          :Container()
                    ],
                  ),)
                ],
              ),
              decoration: boxDecoration(menuYn == "N"? greyLight: Colors.white, 5),
            ),
          );
        });
  }
  Widget catView(snapshot){

    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data['Table2'].length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data['Table2'][index];
          var code = dataList['CODE']??'';
          var menuGroupName = dataList['DESCP']??'';

          return code != null? GestureDetector(
            onTap: (){
              fnUpdateTable(code,menuGroupName);
            },
            child: Container(
              margin: EdgeInsets.all(2),
              padding: EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Icon(Icons.dashboard,size: 10,color: Colors.amber,),
                  gapWC(5),
                  Expanded(child: th(menuGroupName.toString().toUpperCase()+'', Colors.white, 12)),
                  Icon(Icons.arrow_forward_ios_sharp,size: 10,color: Colors.white,)
                ],
              ),
              decoration: boxDecoration(lstrSelectedColor, 5),
            ),
          ):Container();
        });
  }
  Widget addOnView(snapshot){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 6 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data[index];
          var itemCode = dataList['DISHCODE']??'';
          var itemName = dataList['DISHDESCP']??'';
          var arabicName = dataList['DISHDESCP']??'';
          var itemPrice = g.mfnDbl(dataList['PRICE']);
          var itemSts = 'P';
          var itemClearedQty = 0;
          var orderData = fnCheckItem(itemCode);
          bool orderSts  = false;
          if(g.fnValCheck(orderData)){
            orderSts = true;
            itemClearedQty = orderData["CLEARED_QTY"].toInt();
            itemSts = orderData["OLD_STS"].toString();
          }
          return GestureDetector(
            onDoubleTap: (){
              fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
            },
            onLongPress: (){

            },
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: <Widget>[

                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gapHC(10),
                          Icon(Icons.album_outlined,color: Colors.red,size: 15,),
                          menuNameS(itemName.toString()),
                          catS('AED  ' + itemPrice.toString()),
                          gapHC(2),
                          gapHC(5),
                          tc(orderSts ? 'x ' + orderData["QTY"].toString() : '',Colors.black,20),
                        ],
                      ),
                    ),
                  ),


                  orderSts ?
                  Container(
                      child:  GestureDetector(
                        onDoubleTap: (){
                          fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty);
                        },
                        onLongPress: (){
                          fnRemoveItem(dataList,orderData);
                        },
                        child: Container(
                          width:70,
                          decoration: boxGradientDecoration(11, 5),
                          child: Center(
                            child: Icon(Icons.remove_circle_outline_outlined,color: Colors.white,size: 30,),
                          ),
                        ),
                      )
                  )
                      :
                  Container()
                ],
              ),
              decoration: boxDecoration(Colors.white, 15),
            ),
          );
        });
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
                lstrSelectedVoidCode  = reasonCode;
                txtReason.text = txtReason.text+reasonDescp;
              });
            },
            child:  Container(
              height: 30,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              margin: EdgeInsets.only(right: 10,top: 5),
              decoration: boxBaseDecoration( greyLight , 5),
              child: Center(
                child: tc(reasonDescp,  Colors.black,15),
              ),
            ),
          );
        });
  }
  Column kitchenNoteColumn() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(Icons.menu_book),
          gapW(),
          h1(lstrSelectedStkDescp.toString())
        ],
      ),
      gapHC(5),
      tc('AED  '+lstrSelectedRate.toString() ,PrimaryColor,15),
      tc('x ' + lstrSelectedQty.toString() ,Colors.black,10),
      gapHC(10),
      g.fnValCheck(lstrLastInstructions)?
      Container(
        height: 100,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150,
                childAspectRatio:  4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount:  lstrLastInstructions.length,
            itemBuilder: (BuildContext ctx, index) {
              var dataList = lstrLastInstructions[index];
              var code = dataList['CODE'] ??'';
              var descp = dataList['DESCP']??'';
              var dishGrop = dataList['DISH_GROUP']??'';
              var sts = false;
              if(lstrSelectedDishGroup == dishGrop){
                sts = true;
              }

              return sts ? Container(
                height: 40,
                decoration: boxBaseDecoration(PrimaryColor, 5),
                padding: EdgeInsets.all(5),
                child: Center(
                  child: tc(descp.toString(),Colors.white,10),
                ),
              ):Container() ;
            }),
      ) : Container(),
      tcn(mfnLng('Kitchen Note'),Colors.black,15),
      gapHC(10),
      Container(
        height: 200,
        padding: EdgeInsets.all(10),
        decoration: boxBaseDecoration(greyLight, 10),
        child: TextField(
          keyboardType: TextInputType.multiline,
          style: TextStyle(fontSize: 18.0),
          maxLines: 10,
          controller: txtNote,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
        ),
      ),
      gapHC(20),
      Container(
        height: 200,
        padding: EdgeInsets.all(10),
      ),
      gapHC(20),
      GestureDetector(
        onTap: (){
          fnUpdateNote(lstrSelectedStkCode);
        },
        child: Container(
          height: 50,
          decoration: boxGradientDecoration(16, 15),
          child: Center(
            child: tc(mfnLng('ADD'),Colors.white,20),
          ),
        ),
      )
    ],
  );
  Widget numberPress(text,size) => Bounce(
    onPressed: (){
      fnOnPress(text);
    },
    duration: Duration(milliseconds: 110),

    child: Container(
      height: 45,
      width: size.width*0.08,
      margin: EdgeInsets.only(bottom: 5),
      decoration: boxDecoration(Colors.white, 10),
      child: Center(
        child: tc(text,Colors.black,30),
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

  //future
  FutureBuilder<dynamic> futureMenuview() {
    return new FutureBuilder<dynamic>(
      future: futureMenu,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return
          itemView(snapshot);
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
  Future<void> showDownbar(dataList) async{

    return showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (context) {
        var itemCode = dataList['DISHCODE'];
        var itemName = dataList['DISHDESCP'];
        var waitingTime = dataList['WAITINGTIME'];
        var itemPrice = dataList['PRICE1'];
        var preparationNote = dataList['PREPARATION']??'';
        return StatefulBuilder(
          builder: (context, setModalState) {
            return  Container(
                height: 500,
                width: 100,
                padding: EdgeInsets.all(30),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.menu_book),
                          gapW(),
                          h1(dataList['DISHDESCP'])
                        ],
                      ),
                      gapHC(5),
                      tc('AED  ' + itemPrice.toString(),PrimaryColor,20),
                      gapHC(5),
                      clockRow('  avg '+dataList['WAITINGTIME'].toString()),
                      gapHC(5),
                      tc(preparationNote.toString(),PrimaryColor,20),
                      Container(
                        height: 320,
                        child: new FutureBuilder<dynamic>(
                          future: futureAddon,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return addOnView(snapshot);
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
                )

            );
          },
        );
      },
    );
  }


  //=====================================================================page function..
  fnGetPageData(){

    setState(() {

      txtRoomNo.clear();
      txtVehicleNo.clear();
      txtFullName.clear();
      txtLastName.clear();
      txtAddress1.clear();
      txtAddress2.clear();
      txtLandMark.clear();
      txtMob1.clear();
      txtMob2.clear();
      txtCouponNo.clear();
      txtDeliveryNote.clear();

      wstrSelectedTables = g.wstrLastSelectedTables;
      wstrPageMode = g.wstrMenuMode;
      lastOrder =g.wstrLastMenuItems;
      lastOrderTable =  g.wstrLastSelectedTables;
      lastOrderAddress = g.wstrLastSelectedAdd;
      print(wstrSelectedTables);
      if(wstrPageMode == 'EDIT'){
        lastOrder =  g.wstrLastMenuItems;
        lastOrderAddress = g.wstrLastSelectedAdd;
        print("============================= EDIT ITEM LOAD");
        print(lastOrder);
        print("=============================");


        fnOrderCalc();
      }else{
        lastOrder = [];
        lstrSelectedChoices.clear();
      }
    });

    if(g.fnValCheck(lastOrderAddress)){
      for (var e in lastOrderAddress) {
        setState(() {
          txtRoomNo.text = e['ADDRESS3'].toString();
          txtFullName.text = e['FNAME'].toString();
          txtLastName.text = e['LNAME'].toString();
          txtAddress1.text = e['ADDRESS1'].toString();
          txtAddress2.text = e['ADDRESS2'].toString();
          txtLandMark.text = e['LANDMARK'].toString();
          txtMob1.text = e['PHONE1'].toString();
          txtMob2.text = e['PHONE2'].toString();
          txtVehicleNo.text = e['ADDRESS4'].toString();
          txtDeliveryNote.text = e['REMARKS'].toString();
        });
      }
    }
  }

  fnUpdateTable(code,descp) {
    setState(() {
      lstrSelectedCategoryList.add(descp);
      switch (lastLevel) {
        case 0:
          lstrMenuGroup = code;
          lstrSelectedColor = Colors.green;
          break;
        case 1:
          lstrGp1 = code;
          lstrSelectedColor = Colors.red;
          break;
        case 2:
          lstrGp2 = code;
          lstrSelectedColor = Colors.blue;
          break;
        case 3:
          lstrGp3 = code;
          lstrSelectedColor = Colors.pink;
          break;
        case 4:
          lstrGp4 = code;
          lstrSelectedColor = Colors.deepOrangeAccent;
          break;
        case 5:
          lstrGp5 = code;
          lstrSelectedColor = Colors.indigo;
          break;
        case 6:
          lstrGp6 = code;
          lstrSelectedColor = Colors.cyan;
          break;
        case 7:
          lstrGp7 = code;
          break;
        case 8:
          lstrGp8 = code;
          break;
        case 9:
          lstrGp9 = code;
          break;
        case 10:
          lstrGp10 = code;
          break;
        default:

          break;
      }
      fnUpdateCategory();
      fnGetMenu();
    });
  }
  fnBackButton(){

    setState(() {
      switch (lastLevel) {
        case 0:
          break;
        case 1:
          fnClearAll();
          break;
        case 2:
          lstrGp1 = null;
          lstrSelectedColor = Colors.green;
          lstrSelectedCategoryList[1] = null;
          break;
        case 3:
          lstrGp2 = null;
          lstrSelectedColor = Colors.red;
          lstrSelectedCategoryList[2] = null;
          break;
        case 4:
          lstrGp3 = null;
          lstrSelectedColor = Colors.blue;
          lstrSelectedCategoryList[3] = null;
          break;
        case 5:
          lstrGp4 = null;
          lstrSelectedColor = Colors.pink;
          lstrSelectedCategoryList[4] = null;
          break;
        case 6:
          lstrGp5 = null;
          lstrSelectedColor = Colors.blue;
          lstrSelectedCategoryList[5] = null;
          break;
        case 7:
          lstrGp6 = null;
          lstrSelectedColor = Colors.deepOrangeAccent;
          lstrSelectedCategoryList[6] = null;
          break;
        case 8:
          lstrGp7 = null;
          lstrSelectedColor = Colors.indigo;
          lstrSelectedCategoryList[7] = null;
          break;
        case 9:
          lstrGp8 = null;
          lstrSelectedColor = Colors.cyan;
          lstrSelectedCategoryList[8] = null;
          break;
        case 10:
          lstrGp9 = null;
          lstrSelectedCategoryList[9] = null;
          break;
        default:
          break;
      }
    });
    fnUpdateCategory();
    fnGetMenu();
  }
  fnBackLongPress(){
    fnClearAll();
    fnGetMenu();
  }
  fnClearAll(){
    lstrSelectedCategoryList.clear();
    lstrSelectedCategory = '';
    setState(() {
      lstrMenuCode = null ;
      lstrMenuGroup  = null ;
      lstrGp1  = null ;
      lstrGp2  = null ;
      lstrGp3  = null ;
      lstrGp4  = null ;
      lstrGp5  = null ;
      lstrGp6  = null ;
      lstrGp7  = null ;
      lstrGp8  = null ;
      lstrGp9  = null ;
      lstrGp10  = null ;
    });
    fnUpdateCategory();
  }
  fnUpdateCategory(){
    setState(() {
      lstrSelectedCategory = '';
    });
    var i = 0;
    if(g.fnValCheck(lstrSelectedCategoryList)){
      for(var e in lstrSelectedCategoryList){
        setState(() {
          if (e != null ){
            lstrSelectedCategory = i == 0? e.toString() : lstrSelectedCategory +  '  >  ' + e.toString();

          }
          i =i+1;
        });
      }
    }else{
      setState(() {
        lstrSelectedCategory = '';
      });
    }
  }

  fnItemPress(dataList,qty,mode,sts,itemClearedQty) async{
    bool checkItem = false;
    bool checkQtyZero = false;
    var itemCode = dataList['DISHCODE'].toString();
    var itemName = dataList['DISHDESCP'];
    var waitingTime = dataList['WAITINGTIME'];
    var itemPrice = dataList['PRICE1'];

    var lngName = "";
    if(g.wstrBistroLng == "ARABIC"){
      lngName = (dataList['ARABIC_DESCP']??'').toString();
    }else if(g.wstrBistroLng == "CHINESE"){
      lngName = (dataList['CHINESE_DESCP']??'').toString();
    }

    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        var lqty = g.mfnDbl(e["QTY"].toString());
        if( itemCode == lcode ){
          checkItem = true;

          if(mode=='ADD'){
            var v =  lqty + qty;
            e["QTY"] = v.toString();
            e["STATUS"] = "P";
            e["PRINT_CODE"] = null;
          }else{
            var v =  lqty - qty;
            if(sts != 'R' && sts != 'D'){
              e["QTY"] = v.toString();
              e["STATUS"] = "P";
              e["PRINT_CODE"] = null;
              if(double.parse(e["QTY"].toString()) <= 0){
                fnRemoveItem(dataList,e);
              }
            }else{
              e["QTY"] = v.toString();
              e["STATUS"] = "P";
              e["PRINT_CODE"] = null;
              if(double.parse(e["QTY"].toString()) <= 0){
                fnRemoveItem(dataList,e);
              }

            }

          }

          break;
        }
      }
    }

    if(!checkItem){
      setState(() {
        lastOrder.add({
          "DISHCODE":dataList['DISHCODE'],
          "DISHDESCP":dataList['DISHDESCP'],
          "LNGNAME":lngName,
          "QTY":qty.toInt().toString(),
          "PRICE1":itemPrice.toString(),
          "WAITINGTIME":waitingTime.toString(),
          "NOTE":"",
          "PRINT_CODE":null,
          "REMARKS":itemPrice.toString(),
          "UNIT1":dataList['UNIT'],
          "KITCHENCODE":dataList['KITCHENCODE'],
          "ADDON_YN":dataList['ADDON_YN'],
          "ADDON_STKCODE":(dataList['ADDON_STKCODE']??""),
          "CLEARED_QTY":"0",
          "NEW":"Y",
          "OLD_STATUS":"",
          "TAXINCLUDE_YN":dataList['TAXINCLUDE_YN'],
          "VAT":dataList['VAT'],
          "ADDON_MAX_QTY":dataList['ADDON_MAX_QTY'],
          "ADDON_MIN_QTY":dataList['ADDON_MIN_QTY'],
          "TAX_AMT":0,
          "STATUS":"P",
          "CHOICE_CODE":dataList['CHOICE_CODE']??"",
        });
      });
    }

    setState(() {

    });
    print(lastOrder);
    if(mode == "ADD"){
     // fnGetAddOnCombo('ADDON',itemCode,dataList,1.0,'MINUS',itemData);
    }
    fnOrderCalc();
    //Vibration.vibrate();

  }
  fnRemoveItem(dataList,selectedItem){

    var itemSts = '';
    itemSts = selectedItem["OLD_STATUS"].toString();
    var newItem = selectedItem['NEW'].toString();
    if(itemSts != 'R' && itemSts != 'D'){
      if(g.wstrOrderMode == 'ADD' ){
        setState(() {
          lastOrder.remove(selectedItem);
          fnRemoveChoiceList(selectedItem["DISHCODE"].toString());
          fnRemoveAddOn(selectedItem["DISHCODE"].toString());
        });
      }else{
        if(newItem == "Y"){
          setState(() {
            lastOrder.remove(selectedItem);
            fnRemoveChoiceList(selectedItem["DISHCODE"].toString());
            fnRemoveAddOn(selectedItem["DISHCODE"].toString());
          });
        }else{
          fnEditRemove(dataList);
        }

      }
    }else{
      showToast( g.fnStatus(itemSts));
    }



    print(lastOrder);
    fnOrderCalc();
  }
  fnRemoveChoiceList(dishcode){
    if(g.fnValCheck(lstrSelectedChoices)){
      var removedata = [];
      for (var e in lstrSelectedChoices){
        if(e["DISHCODE"] == dishcode){
          removedata.add(e);
        }
      }
      for(var e in removedata){
        setState((){
          lstrSelectedChoices.remove(e);
        });
      }

    }
  }
  fnRemoveItemSelected(selectedItem){

    var itemSts = '';
    itemSts = selectedItem["OLD_STATUS"].toString();
    var newItem = selectedItem['NEW'].toString();
    if(itemSts != 'R' && itemSts != 'D'){
      if(g.wstrOrderMode == 'ADD' ){
        setState(() {
          lastOrder.remove(selectedItem);
        });
      }else{
        if(newItem == "Y"){
          setState(() {
            lastOrder.remove(selectedItem);
          });
        }else{
          fnEditRemove(selectedItem);
        }

      }
    }else{
      showToast( g.fnStatus(itemSts));
    }
    print(lastOrder);
    fnOrderCalc();
  }
  fnGetTableName() {

    var tableName ='';
    for(var e in g.wstrLastSelectedTables){
      var t = e["TABLE_DESCP"];
      tableName =  tableName == "" ? t :t + ','+ tableName ;
    }
    setState(() {
      lstrTableName = tableName;
    });
  }
  fnShowNotePopup(dataList,orderData){

    var itemCode = dataList['DISHCODE'] ??'';
    var itemName = dataList['DISHDESCP']??'';
    var waitingTime = dataList['WAITINGTIME']??'';
    var itemPrice = dataList['PRICE1']??'0.0';
    var dishGroup = dataList['MENUGROUP'];
    var groupInstruction =  [];
    //groupInstruction =  fnCheckInstruction(dishGroup);
    print(groupInstruction);
    setState(() {
      lstrSelectedItem.clear();
      lstrSelectedItem.add(dataList);
      lstrLastInstructions =  groupInstruction;
      lstrSelectedStkCode = itemCode??'';
      lstrSelectedStkDescp = itemName??'';
      lstrSelectedDishGroup = dishGroup;
      lstrSelectedRate = itemPrice.toString();
      lstrKitchenNote = '';
      lstrSelectedQty=orderData['QTY'].toString();
      lstrSelectedNote=orderData['NOTE'].toString();
      txtNote.text = lstrSelectedNote;
      sidePageView = "D";
      txtQty.text = lstrSelectedQty;
    });
    // PageDialog().showNote(context, ItemDetails(
    //   fnCallBack: fnItemNoteCallBack,
    //   lstrDataList: lstrSelectedItem,
    //   qty: lstrSelectedQty,
    //   note: lstrSelectedNote.toString(),
    //
    // ), 'Item Details');
  }
  fnShowNotePopupSelected(dataList){

    var itemCode = dataList['DISHCODE'] ??'';
    var itemName = dataList['DISHDESCP']??'';
    var waitingTime = dataList['WAITINGTIME']??'';
    var itemPrice = dataList['PRICE']??'0.0';
    //fnGetDetails(itemCode);

    setState(() {

      lstrSelectedStkCode = itemCode??'';
      lstrSelectedStkDescp = itemName??'';
      lstrSelectedRate = itemPrice.toString();
      lstrKitchenNote = '';
      lstrSelectedQty=dataList['QTY'].toString();
      lstrSelectedNote=dataList['NOTE'].toString();
      txtNote.text = lstrSelectedNote;
      lstrSelectedItem.clear();
      lstrSelectedItem.add(dataList);
      sidePageView = "D";
      txtQty.text = lstrSelectedQty;

    });
    // PageDialog().showNote(context, ItemDetails(
    //   fnCallBack: fnItemNoteCallBack,
    //   lstrDataList: lstrSelectedItem,
    //   qty: lstrSelectedQty,
    //   note: lstrSelectedNote.toString(),
    //
    // ), 'Item Details');
    // PageDialog().showNote(context, kitchenNoteColumn(), 'Item Details');
  }

  fnEditRemove(dataList){
    var itemCode = dataList['DISHCODE'].toString();
    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( itemCode == lcode ){
          e["QTY"] = '0';
          e["STATUS"] = 'C';
          e["PRINT_CODE"] = null;
          break;
        }
      }
    }
  }
  fnOrderCalc(){
    //lastOrderHead
    if(g.fnValCheck(lastOrder)){
      var totalAmount = 0.0;
      var grossAmount = 0.0;
      var totalQty = 0.0;
      var vatAmount = 0.0;
      var taxable = 0.0;
      for(var e in lastOrder){
        var sts =  e["STATUS"];
        var vatSts = e["TAXINCLUDE_YN"];
        var vatP = g.mfnDbl(e["VAT"]);
        if(sts != 'C'){
          var qty = g.mfnDbl(e["QTY"]);
          var vQty = e["VOID_QTY"]??0;
          var price = g.mfnDbl(e["PRICE1"]);
         // var aQty = int.parse(qty)- vQty;
          var total = qty *  price;
          var vat = 0.0;
          var vatA = 0.0;

          if(vatSts == 'Y' && vatP > 0){
            var dvd = 100 /(100+vatP);
            vat =  total * dvd;
            vatA = total - vat;

            taxable = (taxable +total) - vatA;
            totalAmount =totalAmount +total ;
          }else{
            vat = (vatP)/100;
            vatA = total * vat;
            totalAmount =totalAmount +total + vatA;
          }
          grossAmount = grossAmount +total;
          vatAmount = vatA + vatAmount;
          totalQty = totalQty + qty;
        }
      }

      setState(() {
        lstrOrderGross = grossAmount;
        lstrOrderVat = vatAmount;
        lstrOrderQty = totalQty.toString();
        lstrOrderAmount = totalAmount.toStringAsFixed(3);
        lstrOrderAmountV = totalAmount;
        lstrOrderQtyV = totalQty;
      });
    }else{
      setState(() {
        lstrOrderVat = 0.0;
        lstrOrderGross =0.0;
        lstrOrderQty = '0.00';
        lstrOrderAmount = '0.00';
        lstrOrderAmountV = 0;
        lstrOrderQtyV = 0.0;
      });
    }
  }
  fnCheckItem(itemCode){
    var selectedData ;
    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( itemCode == lcode ){
          selectedData = e;
          break;
        }
      }
    }
    return selectedData;
  }
  fnCheckInstruction(dishGroup){
    var selectedData =[] ;
    if(g.fnValCheck(lstrSelectedInstructions)){
      for (var e in lstrSelectedInstructions) {
        var lcode = e["DISH_GROUP"].toString();
        if( dishGroup == lcode ){
          selectedData.add(e);
        }
      }
    }
    return selectedData;
  }
  fnUpdateNoteText(note){
    setState(() {
      txtNote.text = txtNote.text +'  ' + note.toString();
    });
  }
  fnUpdateNote(itemCode){
    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( itemCode == lcode ){
          e["NOTE"]=txtNote.text;
          break;
        }
      }
    }
    print(lastOrder);
  }
  fnItemNoteCallBack(itemCode,note,qty){
    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( itemCode == lcode ){
          e["NOTE"]=note.toString();
          e["QTY"]=qty;
          break;
        }
      }
    }
    setState(() {
      sidePageView = "O";
    });
    print(lastOrder);
    fnOrderCalc();
  }
  fnClearSelected(){
    if(g.wstrOrderMode == 'ADD'){
      setState(() {
        lastOrder.clear();
        lstrSelectedChoices.clear();
        lstrOrderQty = '0';
        lstrOrderAmount = '0';
        lstrOrderQtyV = 0;
        lstrOrderAmountV = 0.0;
      });
    }else{

    }
  }
  fnClear(){
    g.wstrLastMenuItems.clear();
    Navigator.pushReplacement(context, NavigationController().fnRoute(1));
  }


  //============ADD ON

  fnSelectAddOn(code){
    var selectedData = [];
    for(var e in lastOrder){
      var lstrAddonCode = e["ADDON_STKCODE"];
      if(lstrAddonCode == code  ){
        selectedData.add(e);
      }
    }
    return selectedData;
  }
  fnSelectAddOnQty(code){
    var qty = 0.0;
    for(var e in lastOrder){
      var lstrAddonCode = e["ADDON_STKCODE"];
      if(lstrAddonCode == code  ){
        qty += g.mfnDbl(e["QTY"]);
      }
    }
    return qty;
  }
  fnRemoveAddOn(code){
    var selectedData =[] ;
    for(var e in lastOrder){
      var lstrAddonCode = e["ADDON_STKCODE"];
      if(lstrAddonCode == code  ){
        selectedData.add(e);
      }
    }

    setState(() {
      if(g.fnValCheck(selectedData)){
        for(var e in selectedData){
          lastOrder.remove(e);
        }
      }
    });
    fnOrderCalc();
  }
  fnAddOnCallBack(order,lstrItemDetails,dataList,addOnList){
    var mode = "";
    var sts = "";
    var enterQty = 0.0;
    var clearedQty = 0.0;
    var dishCode  =  '';
    if(g.fnValCheck(lstrItemDetails)){
      mode = lstrItemDetails[0]["MODE"];
      sts = lstrItemDetails[0]["ITEM_STATUS"];
      dishCode = lstrItemDetails[0]["DISHCODE"];
      enterQty = g.mfnDbl(lstrItemDetails[0]["ENTER_QTY"]);
      clearedQty = g.mfnDbl(lstrItemDetails[0]["CLEARED_QTY"]);
    }
    if(mode != ""){
      fnItemPress(dataList,enterQty,mode,sts,clearedQty);
      setState(() {
        var oldAddOnData  = [];
        for(var e in lastOrder){
          var faddOnCode = e["ADDON_STKCODE"];
          if(dishCode == faddOnCode){
            oldAddOnData.add(e);
          }
        }
        for(var e  in oldAddOnData){
          lastOrder.remove(e);
        }
        for(var e in addOnList){
          lastOrder.add(e);
        }
      });
    }else{
      setState(() {
        lastOrder = order;
      });
    }
    fnOrderCalc();

  }
  fnGetAddOnSrno(code){
    var srno = 0;
    for(var e in lstrKotDet){
      if(code == e["STKCODE"]){
        srno =  e["SRNO"];
        break;
      }
    }
    return srno;
  }


  //================== CHOICE SELECTION

  fnGetChoiceList(dataList,choiceCode){
    print("============================================");
    print(choiceCode);

    futureChoice = apiCall.getChoice(choiceCode);
    futureChoice.then((value) => fnGetChoiceSuccess(value,choiceCode,dataList));
  }
  fnGetChoiceSuccess(value,choiceCode,dataList){

    var  RST_CHOICE_MAST =[];
    var  RST_CHOICE_DET =[];
    var  RST_CHOICE_LEVEL =[];

    RST_CHOICE_MAST = value["Table1"];
    print(RST_CHOICE_MAST);


    if(g.fnValCheck(RST_CHOICE_MAST)){
      RST_CHOICE_DET= value["Table2"];
      RST_CHOICE_LEVEL= value["Table3"];

      print(RST_CHOICE_DET);
      print(RST_CHOICE_LEVEL);
      var oldData  = [];
      for(var e in lstrSelectedChoices){
        if( e["CHOICE_CODE"] == choiceCode && e["DISHCODE"] ==  dataList["DISHCODE"]){
          oldData.add(e);
        }
      }

      PageDialog().showL(context,
          Choices(
            fnCallBack: fnChoiceCallBack,
            choiceCode: choiceCode,
            lstrChoiceList: value,
            lstrItemDataList: dataList,
            oldData: oldData,
          ),
          mfnLng('Choices'));
    }

  }
  fnChoiceCallBack(header,choiceDetails,dataList){


    print("========================================== CALLBACK");
    print(header);
    print(choiceDetails);
    print(dataList);
    print("==========================================");


    Navigator.pop(context);
    var note = '';
    setState((){

      lstrSelectedChoices.removeWhere((e) => e["CHOICE_CODE"] == header[0]["CHOICE_CODE"] && e["DISHCODE"] ==  header[0]["DISHCODE"]);
      print(lstrSelectedChoices);
      print("========================================== BEFORE");

      // if(g.fnValCheck(lstrSelectedChoices)){
      //   var removeDate  = [];
      //
      //
      //
      //   for(var e in lstrSelectedChoices){
      //     if( e["CHOICE_CODE"] == header[0]["CHOICE_CODE"] && e["DISHCODE"] ==  header[0]["DISHCODE"]){
      //       removeDate.add(e);
      //     }
      //   }
      //   for(var e in removeDate){
      //     lstrSelectedChoices.remove(e);
      //   }
      // }

      var choiceSrno = 0;
      for(var e in choiceDetails){
        lstrSelectedChoices.add(e);

        if(choiceSrno != e["CHOICE_SRNO"]){
          choiceSrno = e["CHOICE_SRNO"];
          note =note+ "\n"+"CHOICE "+ e["CHOICE_SRNO"].toString()+"\n";
          note = note+ "QTY "+e["CHOICE_QTY"].toString()+"\n";
          note = note+"* "+ e["CHOICE_ITEMDESCP"].toString()+" @ "+e["PRICE"].toString()+"\n";
        }else{
          note = note+"* "+ e["CHOICE_ITEMDESCP"].toString()+" @ "+e["PRICE"].toString()+"\n";
        }

      }

      print(lstrSelectedChoices);
      print("========================================== AFTER");
    });

    fnItemPress(dataList,g.mfnInt(header[0]["TOTAL_QTY"].toString()),'ADD',"P",dataList["CLEARED_QTY"]);
    fnItemNoteCallBack(header[0]["DISHCODE"],note,header[0]["TOTAL_QTY"].toString());
    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( header[0]["DISHCODE"] == lcode ){
          e["PRICE1"]=g.mfnDbl(header[0]["TOTAL_PRICE"]);
          break;
        }
      }
    }
    fnOrderCalc();
  }

  //=========================================API CALL================================
  fnGetMenu() async{
    futureMenu =  apiCall.getMenuItem(g.wstrCompany, lstrMenuCode, lstrMenuGroup, lstrGp1, lstrGp2, lstrGp3, lstrGp4, lstrGp5, lstrGp6, lstrGp7, lstrGp8, lstrGp9, lstrGp10, lstrSearch,g.wstrUserCd,g.wstrDeliveryMode);
    futureMenu.then((value) => fnGetMenuSuccess(value));
  }
  fnGetMenuSuccess(value){
    if(g.fnValCheck(value)){
      if(g.fnValCheck(value['Table2'])){
        var dataList = value['Table2'][0];
        lastLevel = int.parse(dataList['LEVEL']);
      }else{
        setState(() {
          lastLevel =lastLevel +1;
        });
      }
      if(g.fnValCheck(value['Table3'])){
        lstrSelectedInstructions = value['Table3'];
      }

    }else{

      showToast( '');
    }
  }
  fnGetAddOnCombo(mode,code,dataList,enterQty,Mode,itemData){

    futureAddon = apiCall.getComboAddon(mode, code);
    futureAddon.then((value) => fnGetAddOnComboSuccess(value,dataList,enterQty,Mode,itemData) );
  }
  fnGetAddOnComboSuccess(value,dataList,enterQty,Mode,itemData){
    print("********************************");
    print(lastOrder);
    print(itemData);
    print("********************************");
    if(g.fnValCheck(value)){
      setState(() {
        lstrAddonDataList = dataList;
      });
      PageDialog().showL(context,
          AddOns(
            lastOrder: lastOrder,
            fnCallBack: fnAddOnCallBack,
            enterQty: g.mfnDbl(enterQty), qtyMode: Mode,
            lstrDataList: dataList,
            lstrAddOnList:value,
            lstrItemDetails: itemData,
          ),
          mfnLng('Add-ons'));
    }
  }


  //======================================= NAVIGATION ====================
  bool fnPageBack(){
    if(g.fnValCheck(lastOrder)){
      if(g.wstrOrderMode == 'ADD'){
        PageDialog().clearDialog(context, fnClear);
        return false;
      }else{
        g.wstrLastMenuItems.clear();
        Navigator.pushReplacement(context, NavigationController().fnRoute(1));
        return true;
      }
    }else{
      Navigator.pushReplacement(context, NavigationController().fnRoute(1));
      return true;
    }

  }


  //lookup
  fnSearchDishCode(){
    if(txtSearchDishCode.text.isEmpty){
      setState(() {
        lstrSearch = null;
      });
    }else{
      setState(() {
        lstrSearch = txtSearchDishCode.text.toString();

      });
    }
    fnGetMenu();
  }
  fnClearSearch(){
    setState(() {
      txtSearchDishCode.clear();
      lstrSearch = null;
    });
    fnGetMenu();
  }


  //---------------save order --------------------

  fnSaveValidate(){
    if(g.wstrRoomYN != "Y" && g.wstrDeliveryMode != "" && txtVehicleNo.text.isNotEmpty){
      fnValidateRef(g.wstrDeliveryMode, txtVehicleNo.text);
      return;
    }else if(g.wstrRoomYN == "Y" && g.wstrDeliveryMode != "" && txtCouponNo.text.isNotEmpty){
      fnValidateRef(g.wstrDeliveryMode, txtCouponNo.text);
      return;
    }else{
      fnSaveOrder();
    }

  }
  fnSaveOrder(){
    if(voidMode == "Y" && txtReason.text.isEmpty){
      showToast(mfnLng("Please fill reason note.."));
      return;
    }

    if(g.wstrRoomYN == "Y" && txtRoomNo.text.isEmpty){
      setState(() {
        sidePageView = "A";
      });
      showToast( mfnLng("Please fill Room No"));
      return;
    }

    if(g.wstrRoomYN != "Y" && g.wstrDeliveryMode != "" && txtVehicleNo.text.isEmpty){
      setState(() {
        sidePageView = "A";
      });
      showToast( "Please fill "+(g.wstrDeliveryMode!=""?'Ref No':'Vehicle No'));
      return;
    }


    if(g.wstrOrderMode != "CANCEL" && voidMode != "Y"  ){
      if(g.wstrOrderType == 'A' ){
        // if(txtFullName.text.isEmpty){
        //   PageDialog().show(context,orderDialogChild(),'Order Details');
        //   showToast( 'Please fill name');
        //   return;
        // }else
        if(g.wstrRoomYN != "Y" && txtVehicleNo.text.isEmpty){
          //PageDialog().show(context,orderDialogChild(),'Order Details');
          setState(() {
            sidePageView = "A";
          });
          showToast( mfnLng('Please fill vehicle no'));
          return;
        }
      }
      if(g.wstrOrderType == 'D'&& g.wstrDeliveryMode == "" ){
         if(txtFullName.text.isEmpty){
           setState(() {
             sidePageView = "A";
           });
           showToast( mfnLng('Please fill name'));
           return;
         }else
        if(txtMob1.text.isEmpty){
          //PageDialog().show(context,orderDialogChild(),'Order Details');
          setState(() {
            sidePageView = "A";
          });
          showToast( mfnLng('Please fill mobile no'));
          return;
        }
      }
      if(g.wstrOrderType == 'T' ){

        if(!g.fnValCheck(g.wstrLastSelectedTables)){
          showToast( mfnLng('Please choose table'));
          return;
        }
      }
    }

    setState(() {
      viewOrderBtnSts =false;
    });


    if(g.wstrOrderMode == "ADD"){
      g.wstrLastSelectedKotDocno = '';
    }

    setState(() {
      lstrKot = [];
      lstrKotTableDet = [];
      lstrKotDet = [];
      lstrKotDelivryDet = [];
    });

    try{
      var totalAmount = 0.0;
      var totalQty = 0.0;
      var grossAmount = 0.0;
      var vatAmount = 0.0;
      var taxable = 0.0;
      var totTaxable = 0.0;
      var srno =0 ;
      var lsrno =0 ;
      for(var e in lastOrder){
        var qty = g.mfnDbl(e["QTY"]);
        var vQty = e["VOID_QTY"]??0;
        var price = e["PRICE1"].toString();
        var sts =  e["STATUS"];
        var vatSts = e["TAXINCLUDE_YN"];
        var vatP = g.mfnDbl(e["VAT"]);
        var vat = 0.0;
        var vatA = 0.0;
        var gross = 0.0;
        //var aQty = int.parse(qty)- vQty;
        var total = qty *  double.parse(price);

        if(vatSts == 'Y' && vatP > 0){
          var dvd = 100 /(100+vatP);
          vat =  total * dvd;
          vatA = total - vat;
          taxable = total - vatA;
          totTaxable = (totTaxable +total) - vatA;
          totalAmount =totalAmount +total ;

        }else{
          vat = (vatP)/100;
          vatA = total * vat;
          taxable =total;
          totTaxable = (totTaxable +total);
          totalAmount =totalAmount +total + vatA;
        }
        e['TAX_AMT'] = vatA;
        grossAmount = grossAmount +total;
        vatAmount = vatA + vatAmount;
        gross = total ;
        totalQty = totalQty + qty;

        var netAmt =  gross +vatA;

        srno =srno +1;
        if(qty != 0){
          lsrno = lsrno +1;
        }
        if(g.wstrOrderMode == "CANCEL"){
          lstrKotDet.add({
            "COMPANY":g.wstrCompany,
            "YEARCODE":g.wstrYearcode,
            "DOCNO":g.wstrLastSelectedKotDocno,
            "SRNO":srno,
            "LINE_SRNO":int.parse(qty) == 0 ? -1 : lsrno,
            "STKCODE":e["DISHCODE"],
            "STKDESCP":e["DISHDESCP"],
            "STKDETAIL":e["LNGNAME"],
            "UNIT1":e["UNIT1"],
            "PRINT_CODE":e["PRINT_CODE"],
            "QTY1":0,
            "RATE":price,
            "RATEFC":price,
            "GRAMT":0,
            "GRAMTFC":0,
            "AMT":0,
            "AMTFC":0,
            "REF1":e["NOTE"],
            "REF2":e["LNGNAME"],
            "CREATE_USER":g.wstrUserCd,
            "KITCHENCODE":e["KITCHENCODE"],
            "ADDON_YN":"",
            "ADDON_STKCODE":e["ADDON_STKCODE"],
            "STATUS":"C",
            "ORDER_PRIORITY":0,
            "TAXINCLUDE_YN":e['TAXINCLUDE_YN'],
            "TAX_PER":g.mfnDbl(e["VAT"]),
            "TAX_AMT":vatA,
            "TAX_AMTFC":vatA,
            "TAXABLE_AMT":taxable,
            "TAXABLE_AMTFC":taxable,
          });
        }else{
          lstrKotDet.add({
            "COMPANY":g.wstrCompany,
            "YEARCODE":g.wstrYearcode,
            "DOCNO":g.wstrLastSelectedKotDocno,
            "SRNO":srno,
            "LINE_SRNO":qty == 0 ? -1 : lsrno,
            "STKCODE":e["DISHCODE"],
            "STKDESCP":e["DISHDESCP"],
            "STKDETAIL":e["LNGNAME"],
            "UNIT1":e["UNIT1"],
            "PRINT_CODE":e["PRINT_CODE"],
            "QTY1":qty,
            "RATE":price,
            "RATEFC":price,
            "GRAMT":gross,
            "GRAMTFC":gross,
            "AMT":gross,
            "AMTFC":gross,
            "REF1":e["NOTE"],
            "REF2":e["LNGNAME"],
            "CREATE_USER":g.wstrUserCd,
            "KITCHENCODE":e["KITCHENCODE"],
            "ADDON_YN":"",
            "ADDON_STKCODE":e["ADDON_STKCODE"],
            "STATUS":e["STATUS"],
            "ORDER_PRIORITY":0,
            "TAXINCLUDE_YN":e['TAXINCLUDE_YN'],
            "TAX_PER":g.mfnDbl(e["VAT"]),
            "TAX_AMT":vatA,
            "TAX_AMTFC":vatA,
            "TAXABLE_AMT":taxable,
            "TAXABLE_AMTFC":taxable,
          });
        }


      }

      lstrKot.add({
        "COMPANY" : g.wstrCompany,
        "YEARCODE":g.wstrYearcode,
        "DOCNO":g.wstrLastSelectedKotDocno,
        "SMAN":"",
        "CURR":"AED",
        "CURRATE":"1",
        "GRAMT":grossAmount,
        "GRAMTFC":grossAmount,
        "NETAMT":totalAmount,
        "NETAMTFC":totalAmount,
        "REMARKS":"",
        "REF1":"",
        "REF2":"",
        "REF3":g.wstrDeliveryMode,
        "REF6":txtVehicleNo.text,
        "PRINT_YN":"",
        "EDIT_USER":g.wstrUserCd,
        "EDIT_USER":g.wstrUserCd,
        "ORDER_TYPE" :g.wstrOrderType,
        "STATUS":g.wstrOrderMode == "CANCEL" ?"C":"P",
        "TABLE_DET":lstrTableName,
        "ORDER_PRIORITY":0,
        "TAX_PER":0,
        "TAX_AMT":vatAmount,
        "TAX_AMTFC":vatAmount,
        "TAXABLE_AMT":totTaxable,
        "TAXABLE_AMTFC":totTaxable,
        "CREATE_MACHINEID":g.wstrDeivceId,
        "CREATE_MACHINENAME":g.wstrDeviceName,
        "ORDER_MODE":g.wstrDeliveryMode,
        "ORDER_ROOM":txtRoomNo.text,
        "ORDER_REF":txtVehicleNo.text,
      });

      lstrKotChoice = [];
      var srnoKotChoice =0;
      for(var e  in lstrSelectedChoices){
        var price = e["PRICE"] * e["CHOICE_QTY"];
        lstrKotChoice.add({
          "COMPANY"   :  g.wstrCompany,
          "YEARCODE"  :  g.wstrYearcode,
          "DOCNO"     :  g.wstrLastSelectedKotDocno,
          "SRNO"     :  srnoKotChoice+1,
          "STKCODE"   :  e["CHOICE_ITEM"],
          "STKDESCP"  :  e["CHOICE_ITEMDESCP"],
          "UNIT1"     :  '',
          "QTY1"      :  e["CHOICE_QTY"],
          "UNITCF"    :  '',
          "RATE"      :  price,
          "RATEFC"    :  price,
          "GRAMT"     :  price,
          "GRAMTFC"   : price,
          "AMT"        :  price,
          "AMTFC"      : price,
          "REF1"       :  e["CHOICE_SRNO"],
          "REF2"       :  e["MAIN_LINE_SRNO"],
          "REF3"       :  e["PARENT_SRNO"],
          "CREATE_USER":  g.wstrUserCd,
          "CREATE_DATE":  '',
          "CREATE_TIME":  '',
          "KITCHENCODE":  '',
          "VOID_QTY"     :  '',
          "CHOICE_CODE"  :  e["CHOICE_CODE"],
          "PARENT_ITEM"	:e["DISHCODE"],
        });
        srnoKotChoice =srnoKotChoice+1;
      }

      srno = 0;
      int tablesNo  = lastOrderTable.length == 0 ?1:lastOrderTable.length ;
      var mode =  g.wstrGuestNo % (tablesNo);
      for(var e in lastOrderTable){
        srno =srno+1;

        var dvdNo = g.wstrGuestNo / tablesNo;
        var guestNo  = dvdNo.toInt();


        lstrKotTableDet.add({
          "COMPANY":g.wstrCompany.toString(),
          "YEARCODE":g.wstrYearcode.toString(),
          "DOCNO":g.wstrLastSelectedKotDocno,
          "SRNO":srno,
          "TABLE_CODE":e["TABLE_CODE"],
          "TABLE_DESCP":e["TABLE_DESCP"],
          "GUEST_NO":guestNo,
          "STATUS":"P",
        });
      }

      if(g.fnValCheck(lstrKotTableDet)){
        lstrKotTableDet[0]["GUEST_NO"] = lstrKotTableDet[0]["GUEST_NO"] +mode;
      }


      lstrKotDelivryDet.add({
        "COMPANY":g.wstrCompany.toString(),
        "YEARCODE":g.wstrYearcode.toString(),
        "DOCNO":g.wstrLastSelectedKotDocno,
        "FNAME":txtFullName.text,
        "LNAME":txtLastName.text,
        "ADDRESS1":txtAddress1.text,
        "ADDRESS2":txtAddress2.text,
        "ADDRESS3":txtRoomNo.text,
        "ADDRESS4":txtVehicleNo.text,
        "LANDMARK":txtLandMark.text,
        "PHONE1":txtMob1.text,
        "PHONE2":txtMob2.text,
        "REMARKS":txtDeliveryNote.text,
      });

      //for void case
      if(voidMode == "Y"){
        setState(() {
          wstrPageMode = "VOID";
        });
      }else{
        setState(() {
          wstrPageMode = g.wstrMenuMode;
        });
      }

      if(g.wstrOrderType != "T"){
        lstrKotTableDet = [];
      }

      print(lstrKot);
      print(lstrKotDet);
      print(lstrKotTableDet);
      print(wstrPageMode);



      setState(() {

      });

      if(g.fnValCheck(lstrKotDet)){
        fnSave();
      }else{
        setState(() {
          viewOrderBtnSts =true;
        });
        showToast(mfnLng("Please choose item"));
      }
    }catch (e){
      print(e);
      setState(() {
        viewOrderBtnSts = true;
      });
    }




  }
  fnSave() async{
    futureOrder=  apiCall.saveOrder(lstrKot,lstrKotDet,lstrKotTableDet,lstrKotDelivryDet,wstrPageMode,passCode,lstrSelectedVoidCode,txtReason.text,lstrKotChoice);
    futureOrder.then((value) => fnSaveSuccess(value));
  }
  fnSaveSuccess(value) async{
    fnOnPressClear();
    if(g.fnValCheck(value)){
      print(value);
      setState(() {

      });
      var sts =  value[0]['STATUS'];
      var msg =  value[0]['MSG'];

      if(sts == '1'){

        var docno =  value[0]['DOCNO'];
        var doctype =  value[0]['DOCTYPE'];

        g.wstrLastSelectedAdd = [];
        g.wstrLastSelectedTables = [];
        g.wstrMenuMode = "";
        g.wstrLastMenuItems = [];
        g.wstrLastSelectedTables = [];


        await apiGetKotPrint(docno, doctype, g.wstrYearcode);

        Navigator.pushReplacement(context, NavigationController().fnRoute(1));
      }
      else if(sts == '2'){

        setState(() {
          sidePageView = "V";
          viewOrderBtnSts =true;
        });

      }
      else{
        setState(() {
          viewOrderBtnSts =true;
        });
      }
      showToast( msg??'');
    }
    else{
      setState(() {
        viewOrderBtnSts =true;
      });
      showToast( mfnLng('Failed'));
    }
  }

  //reason
  fnGetReason(){
    futureReason =  apiCall.getReason();
  }

  fnLookup(mode,lookupMode) {
    if (mode == 'ROOM') {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Room'}
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {'sourceColumn': 'CODE','contextField': txtRoomNo,'context': 'window'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtRoomNo,
        oldValue: txtRoomNo.text,
        lstrTable: 'ROOMMASTER',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100000',
        lstrFilter: [],
        keyColumn: 'CODE',
        layoutName: "B",
        mode: lookupMode,
        callback: fnLookupPartyCallBack,
      ), mfnLng('ROOM'));
    }
  }
  fnLookupPartyCallBack(data){

  }

  fnValidateRef(mode, orderref){
    futureOrder = apiCall.validateOrderRef(g.wstrCompany, mode, orderref);
    futureOrder.then((value) => fnValidateRefRes(value));
  }
  fnValidateRefRes(value){
      print(value);
      if(g.fnValCheck(value)){
        var sts =  value[0]["STATUS"].toString();
        if(sts == "1"){
          fnSaveOrder();
        }else{
          showToast(mfnLng('Reference number already exist!'));
        }
      }
  }


  //======================================PRINT


  fnKotMultiplePrint() async{
    print(">>>>>>>>>>>>>>>>>KOT MILTI PRINT");
    for(var e in kotPrinterList){
      print(e);
      if(e.toString().isNotEmpty){
        //printing
        var printerData =  kotPrintData.where((element) => element["PRINT_PATH"].toString() == e.toString() && (element["ADDON_STKCODE"]??"").toString().isEmpty).toList();
        print(printerData);
        if(printerData.isNotEmpty){
          var docno = (printerData[0]["DOCNO"]??"").toString();
          await fnPrintKOT(printerData,e.toString(),docno);
        }
      }
    }
  }

  Future fnPrintKOT(printerData,printerIP,docno) async {
    List<int> bytes = [];



    final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // PaperSize.mm80 or PaperSize.mm58
    final generator = Generator(PaperSize.mm80, profile);

    //Header
    // final ByteData data = await rootBundle.load('assets/icons/logo.png');
    // final Uint8List imgBytes = data.buffer.asUint8List();
    // final img.Image images = img.decodeImage(imgBytes)!;
    // bytes += generator.image(images,);

    final now = DateTime.now();
    final formatter = DateFormat('MM/dd/yyyy hh:mm a');
    final String timestamp = formatter.format(now);

    bytes += generator.text('KOT PRINT',
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            bold: true
        ),
        linesAfter: 1);


    bytes += generator.hr();
    bytes += generator.row([
      PosColumn(
          text: 'Order: $docno',
          width: 4,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: timestamp,
          width: 8,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);
    bytes += generator.row([
      PosColumn(
          text: 'Device:'+g.wstrDeivceId,
          width: 4,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size1)),
      PosColumn(
          text: 'User:'+g.wstrUserCd,
          width: 8,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size1)),
    ]);
    // bytes += generator.text('BILL#: $lstrPrintDocno',
    //     styles: PosStyles(align: PosAlign.left));
    // bytes += generator.text('Device:'+g.wstrDeivceId,
    //     styles: PosStyles(align: PosAlign.left));
    // bytes += generator.text('User:'+g.wstrUserCd,
    //     styles: PosStyles(align: PosAlign.left));

    bytes += generator.hr();
    //DET
    bytes += generator.row([
      PosColumn(text: 'Item', width: 10),
      PosColumn(text: 'Qty', width: 2),
    ]);
    //DET

    bytes += generator.emptyLines(1);

    for(var e in printerData){


      var stkCode=  (e["STKCODE"]??"").toString();
      var stkDescp=  (e["STKDESCP"]??"").toString();
      var addonStkCode=  (e["ADDON_STKCODE"]??"").toString();
      var qty=  g.mfnDbl(e["QTY1"].toString());
      var note=  (e["REF1"]??"").toString();

      var addonItems = [];
      addonItems = kotPrintData.where((element) => element["ADDON_STKCODE"] == stkCode).toList();

      if(addonStkCode.isEmpty){
        bytes += generator.row([
          PosColumn(text: stkDescp, width: 10),
          PosColumn(text:  qty.toStringAsFixed(0), width: 2),
        ]);

      }


      // if(addonItems.length>0){
      //   // bytes += generator.row([
      //   //   PosColumn(text:  "", width: 1,),
      //   //   PosColumn(text: 'Addon:',styles: PosStyles(align: PosAlign.left,underline: true), width: 7),
      //   // ]);
      //    bytes += generator.text('Addon:',styles: PosStyles(align: PosAlign.left,underline: true));
      // }

      for(var k in addonItems){

        var AstkDescp=  (k["STKDESCP"]??"").toString();
        var Aqty=  g.mfnDbl(k["QTY1"].toString());
        bytes += generator.row([
          PosColumn(text:  "", width: 1,),
          PosColumn(text: "$AstkDescp x ${Aqty.toStringAsFixed(0)}", width: 9),
          PosColumn(text:  "", width: 2,),
        ]);
      }

      if(addonStkCode.isEmpty && note.isNotEmpty){
        bytes += generator.row([
          PosColumn(text:  "", width: 1),
          PosColumn(text: "* Note: $note", width: 11),
        ]);
      }

      //bytes += generator.emptyLines(1);
    }
    bytes += generator.hr();

    _printEscPos(bytes, generator,printerIP);
  }
  void _printEscPos(List<int> bytes, Generator generator,printerIP) async {
    var connectedTCP = false;

    var ip = printerIP;

    bytes += generator.feed(2);
    bytes += generator.cut();
    // connectedTCP = await printerManager.connect(type: PrinterType.network, model: TcpPrinterInput(ipAddress: ip));
    // if (!connectedTCP) debugPrint(' --- please review your connection ---');
    //
    // printerManager.send(type: PrinterType.network, bytes: bytes);
    // printerManager.disconnect(type: PrinterType.network);

  }


  apiGetKotPrint(docNo, doctype, yearcode) async{

    if(g.wstrDirectPrintYn !="Y"){
      return;
    }

    futurePage = apiCall.apiGetKotPrint(docNo, doctype, yearcode, g.wstrCompany);
    await futurePage.then((value) =>  apiGetKotPrintRes(value));
  }
  apiGetKotPrintRes(value) async{
    if(mounted){
      print("PRINTER LIST<<<<<<<<<<<<<<<<<<<<");
      print(value);
      if(g.fnValCheck(value)){
        var seen = Set<String>();
        var printList = value.where((element) => seen.add((element["PRINT_PATH"]??""))).toList();
        setState(() {
          kotPrintData = value;
          for(var e in seen){
            kotPrinterList.add(e);
          }
        });
        print("PRINTER LIST>>>>>>>>>>>>>>>>>>>>>");

        await fnKotMultiplePrint();
      }

    }
  }



  //========search customer

  apiSearchCustomer() {
    var filterVal = [];
    final List<Map<String, dynamic>> columnList = [
      {'Column': 'PHONE1'},
      {'Column': 'PHONE2'},
      {'Column': 'FNAME'},
      {'Column': 'LNAME'},
      {'Column': 'ADDRESS1'},
      {'Column': 'ADDRESS2'},
      {'Column': 'ADDRESS3'},
      {'Column': 'ADDRESS4'},
      {'Column': 'LANDMARK'}
    ];
    var columnListTemp;
    for (var e in columnList) {
      filterVal.add({
        "Column": e['Column'],
        "Operator": "LIKE",
        "Value": txtSearch.text,
        "JoinType": "OR"
      });
      columnListTemp == null
          ? columnListTemp = e['Column'] + "|"
          : columnListTemp += e['Column'] + "|";
    }

    futureView = apiCall.LookupSearch(
        "(SELECT DISTINCT FNAME,LNAME,ADDRESS1,ADDRESS2,ADDRESS3,ADDRESS4,PHONE1,PHONE2,LANDMARK  FROM KOT_ADDRESS) AS TABLE1",
        columnListTemp,
        0,
        100,
        filterVal);
    futureView.then((value) => apiSearchAreaRes(value));
  }

  apiSearchAreaRes(value) {
    if (mounted) {
      setState(() {
        lstrSearchResult = [];
        if (g.fnValCheck(value)) {
          lstrSearchResult = value;
        }
      });
    }
  }

  Widget viewSearchResult() {
    return ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: lstrSearchResult.length,
            itemBuilder: (context, index) {
              var dataList = lstrSearchResult[index];
              var name = dataList["FNAME"] ?? "";
              var name2 = dataList["LNAME"] ?? "";
              var vehcle = dataList["ADDRESS4"] ?? "";
              var phone = dataList["PHONE1"] ?? "";
              var phone2 = dataList["PHONE2"] ?? "";
              var phone3 = dataList["PHONE2"] ?? "";
              var ADD1 = dataList["ADDRESS1"] ?? "";
              var ADD2 = dataList["ADDRESS2"] ?? "";
              var ADD3 = dataList["ADDRESS3"] ?? "";
              var REM = dataList["REMARKS"] ?? "";
              var LAN = dataList["LANDMARK"] ?? "";

              return Bounce(
                onPressed: () {
                  if(mounted){
                    setState(() {
                      txtSearch.clear();

                      txtVehicleNo.text = vehcle;
                      txtMob1.text = phone;
                      txtMob2.text = phone2;
                      txtFullName.text = name;
                      txtLastName.text = name2;
                      txtAddress1.text = ADD1;
                      txtAddress2.text = ADD2;
                      txtLandMark.text = LAN;
                    });
                  }

                },
                duration: const Duration(milliseconds: 110),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: boxBaseDecoration(Colors.white, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      th(name.toString(), Colors.black, 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.numbers,
                            color: PrimaryColor,
                            size: 15,
                          ),
                          gapWC(10),
                          Expanded(
                            child: tcn(vehcle.toString(), Colors.black, 12),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_android,
                            color: PrimaryColor,
                            size: 15,
                          ),
                          gapWC(10),
                          Expanded(
                            child: tcn(phone.toString(), Colors.black, 12),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            color: PrimaryColor,
                            size: 15,
                          ),
                          gapWC(10),
                          Expanded(
                            child: tcn(ADD1.toString(), Colors.black, 12),
                          )
                        ],
                      ),
                      gapHC(5),
                      lineC(1.0, greyLight),
                      gapHC(5),
                    ],
                  ),
                ),
              );
            }));
  }


}


