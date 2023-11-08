

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class AddOns extends StatefulWidget {

  final lstrDataList;
  final lastOrder;
  final lstrAddOnList;
  final Function  fnCallBack;
  final lstrItemDetails ;
  final double enterQty;
  final  String qtyMode ;

  const AddOns({Key? key,  required this.fnCallBack, required this.lastOrder, required this.lstrDataList, required this.enterQty, required this.qtyMode, this.lstrAddOnList, this.lstrItemDetails}) : super(key: key);

  @override
  _AddOnsState createState() => _AddOnsState();
}

class _AddOnsState extends State<AddOns> {


  Global g = Global();
  ApiCall apiCall = ApiCall();
  var dataList ;
  var addonList = [] ;
  var addonArrayList  = [];
  var lastOrder ;
  var itemCode  =   "";
  var itemName  =   "";
  var itemPrice  =  0.0;
  var itemQty  =  0.0;
  var enterQty = 0.0;
  var qtyMode = "";
  var msg  = "";

  var addOnMin = 0.0;
  var addOnMax = 0.0;
  var addMinQty = 0.0;
  var addMaxQty = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.menu_book),
            gapW(),
            tc(itemName.toString(),Colors.black,15),
            gapW(),
            tc(msg,PrimaryColor,20),
          ],
        ),
        gapHC(5),
        tc('AED  ' + itemPrice.toString(),PrimaryColor,15),
        gapHC(10),
        Expanded(child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 300,
                childAspectRatio: 2.5,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount:  addonList.length,
            itemBuilder: (BuildContext ctx, index) {
              var dataList = addonList[index];
              var itemCode = dataList['DISHCODE']??'';
              var itemName = dataList['DISHDESCP']??'';
              var itemPrice = dataList['PRICE1']??'0.0';
              var itemSts = 'P';
              var itemClearedQty = 0;
              var Cardcolor = Colors.white;
              var orderData = fnCheckItemAddon(itemCode);
              bool orderSts  = false;
              if(g.fnValCheck(orderData)){
                orderSts = true;
                itemClearedQty = g.mfnInt(orderData["CLEARED_QTY"]);
                itemSts = orderData["OLD_STS"].toString();
              }
              return GestureDetector(
                onTap: (){
                  setState(() {
                    fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
                  });
                },
                onLongPress: (){

                },
                child: Container(
                  padding: EdgeInsets.all(5),
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
                              gapHC(5),
                              menuNameS(itemName.toString()),
                              catS('AED  ' + itemPrice.toString()),
                              gapHC(2),
                              tc(orderSts ? 'x ' + orderData["QTY"].toString() : '',Colors.black,15),
                            ],
                          ),
                        ),
                      ),
                      gapHC(10),
                      orderSts ?
                      Container(
                          child:  GestureDetector(
                            onTap: (){
                              fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty);
                            },
                            onLongPress: (){
                              fnRemoveItem(dataList,orderData);
                            },
                            child: Container(
                              width:50,
                              decoration: boxGradientDecoration(12, 20  ),
                              child: Center(
                                child: Icon(Icons.remove_circle_outline_outlined,color: Colors.white,size: 20,),
                              ),
                            ),
                          )
                      )
                          :
                      Container()
                    ],
                  ),
                  decoration: boxBaseDecoration(redLight, 20),
                ),
              );
            }),),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: (){
                fnDone();
              },
              child: Container(
                height: 40,
                width: 150,
                decoration: boxDecoration(Colors.green, 30),
                child: Center(
                  child: tc('Done',Colors.white,15),
                ),
              ),
            )


          ],
        )


      ],
    );
  }

  
  //=========================OTHER FUNCTIONS ==========================
  fnCheckItem(additemCode){
    msg = "";
    var selectedData ;
    if(g.fnValCheck(lastOrder)){

      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( additemCode == lcode ){
          selectedData = e;
          break;
        }
      }
    }
    return selectedData;
  }
  fnCheckItemAddon(additemCode){
    msg = "";
    var selectedData ;
    if(g.fnValCheck(lastOrder)){
      print("*************************************ABC");
      print(itemCode);
      print(lastOrder.where((element) => element["ADDON_STKCODE"] == itemCode).toList());
      for (var e in lastOrder.where((element) => element["ADDON_STKCODE"] == itemCode).toList()) {
        var lcode = e["DISHCODE"].toString();
        if( additemCode == lcode ){
          selectedData = e;
          break;
        }
      }
    }
    print(selectedData);
    return selectedData;
  }
  fnItemPress(dataList,qty,mode,sts,itemClearedQty) async{
    bool checkItem = false;
    bool checkQtyZero = false;
    var itemCodea = dataList['DISHCODE'].toString();
    var itemName = dataList['DISHDESCP'];
    var waitingTime = dataList['WAITINGTIME'];
    var itemPrice = dataList['PRICE1'];


    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder.where((element) => element["ADDON_STKCODE"] == itemCode).toList()) {
        var lcode = e["DISHCODE"].toString();
        var lqty = double.parse(e["QTY"].toString());
        if( itemCodea == lcode ){
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
          "QTY":qty.toInt().toString(),
          "PRICE1":itemPrice.toString(),
          "WAITINGTIME":waitingTime.toString(),
          "NOTE":"",
          "PRINT_CODE":null,
          "REMARKS":itemPrice.toString(),
          "UNIT1":dataList['UNIT'],
          "KITCHENCODE":dataList['KITCHENCODE'],
          "ADDON_YN":"Y",
          "ADDON_MIN_QTY":dataList['ADDON_MIN_QTY'],
          "ADDON_MAX_QTY":dataList['ADDON_MAX_QTY'],
          "ADDON_STKCODE":dataList['CODE'],
          "CLEARED_QTY":"0",
          "NEW":"Y",
          "OLD_STATUS":"",
          "TAXINCLUDE_YN":(dataList['TAXINCLUDE_YN']??"Y"),
          "VAT":dataList['VAT'],
          "TAX_AMT":0,
          "STATUS":"P"
        });

      });
    }

    setState(() {

    });

  }
  fnRemoveItem(dataList,selectedItem){
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
        }
      }
    }else{
    }
    print(lastOrder);
  }
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
  fnCheckMin(){
    var minSts = true;
    var addOnQty  =  fnSelectAddOnQty(itemCode);
    if(addMinQty > 0){
      minSts = addOnQty >= addMinQty ? true:false;
    }
    return minSts;

  }
  fnCheckMax(){
    var maxSts  = true;
    var addOnQty  =  fnSelectAddOnQty(itemCode);
    if(addMaxQty > 0){
      maxSts = addOnQty > addMaxQty ? false:true;
    }
    return  maxSts;
  }
  
  //=========================PAGE FUNCTIONS  =======================
  fnGetPageData(){
    setState(() {
      dataList  =  g.mfnJson(widget.lstrDataList)??[];
      lastOrder  = g.mfnJson(widget.lastOrder)??[];
      addonList = g.mfnJson(widget.lstrAddOnList)??[];
      qtyMode =  widget.qtyMode;
      enterQty =  widget.enterQty;
    });
    if(g.fnValCheck(dataList)){
      itemCode  =   dataList["DISHCODE"].toString();
      itemName  =   dataList["DISHDESCP"].toString();;
      itemPrice  =  g.mfnDbl(dataList['PRICE1']);
      addOnMin = g.mfnDbl(dataList['ADDON_MIN_QTY']);
      addOnMax = g.mfnDbl(dataList['ADDON_MAX_QTY']);
      var orderData = fnCheckItem(itemCode);
      if(g.fnValCheck(orderData)){
        itemQty = g.mfnDbl(orderData["QTY"]);
      }

      if(qtyMode == "ADD"){
        itemQty= enterQty + itemQty;
      }else  if(qtyMode == "MINUS"){
        itemQty= itemQty - enterQty;
      }
      addMinQty = itemQty == 0?addOnMin:( addOnMin * itemQty);
      addMaxQty = itemQty == 0?addOnMax:(addOnMax * itemQty);
    }
  }
  fnDone(){
    if(!fnCheckMin()){
      showToast( 'Please select minimum '+ addMinQty.toString() +' Add-on' );
      setState(() {
        msg = 'Please select minimum '+ addMinQty.toString() +' Add-on';
      });
      return false;
    }

    if(!fnCheckMax()){
      showToast( 'Only '+addMaxQty.toString()+ " Add-ons are allowed!!" );
      setState(() {
        msg = 'Only '+addMaxQty.toString()+ " Add-ons are allowed!!";
      });
      return false;
    }
    addonArrayList = [];
    for(var e in lastOrder){
      if( e["ADDON_STKCODE"] == itemCode){
        addonArrayList.add(e);
      }
    }

    Navigator.pop(context);
    widget.fnCallBack(lastOrder,widget.lstrItemDetails,widget.lstrDataList,addonArrayList);
  }

  //========================API CALL  =================================



}
