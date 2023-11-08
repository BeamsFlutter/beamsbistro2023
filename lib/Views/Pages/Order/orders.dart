
import 'dart:async';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/responsiveHelper.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:beamsbistro/Views/Pages/Menu/itemDetails.dart';
import 'package:beamsbistro/Views/Pages/Menu/menu.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class Orders extends StatefulWidget  {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders>  {

  //api

  ApiCall apiCall = ApiCall();
  Global g = Global();
  late Future<dynamic> futureMenu ;
  late Future<dynamic> futureOrder ;
  late Future<dynamic> futureDetails ;
  //Order
  var lastOrder = [];
  var lastOrderTable = [];
  var lastOrderHead = [];
  var lastOrderAddress = [];

  var wstrSelectedTables = [];

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
  var txtNote = new TextEditingController();

  var orderNo = '';
  var lstrTableName = '';
  var lstrGuestNo = '';
  var lstrOrder = '';

  var lstrKot = [];
  var lstrKotDet = [];
  var lstrKotTableDet = [];
  var lstrKotDelivryDet = [];

  var lstrGrossAmount = '0.00';
  var lstrVatAmount = '0.00';
  var lstrTotalAmnt = '0.00';
  var lstrOrderQty = '';
  var lstrOrderQtyV = 0;
  var lstrOrderAmountV = 0.0;
  var lstrOrderAmount = '0:00';
  var lstrOrderGross = 0.00;
  var lstrOrderVat = 0.00;
  var lstrOrderTotal = 0.00;
  var lstrTaxableAmt = 0.00;

  var lstrLastInstructions = [];

  //page
  var wstrPageMode = 'ADD';
  var wstrMenuMode = '';
  var wstrOrderMode = '';
  var lstrSelectedStkCode = '';
  var lstrSelectedStkDescp = '';
  var lstrSelectedRate = '';
  var lstrSelectedTime = '';
  var lstrKitchenNote = '';
  var lstrSelectedQty = '';
  var lstrSelectedNote= '';
  var viewOrderBtnSts = true;
  var lstrSelectedItem = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lastOrder = g.wstrLastMenuItems;
    wstrMenuMode =  g.wstrMenuMode;
    wstrOrderMode = g.wstrOrderMode;
    lstrGuestNo =  g.wstrGuestNo.toString();
    wstrPageMode = g.wstrOrderMode;
    fnGetPageData();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: navigationTitleAppBar(context,"Order Details",fnPageBack),

      body:WillPopScope(
        child: SafeArea(
          child: Container(
            height: size.height,
            width: size.width,
            margin: pageMargin(),
            child: SingleChildScrollView(
              child:Column(
                children: [
                  ResponsiveWidget(mobile: Container(
                    height: size.height * 0.82,
                    child: selectedItemView(context, size),
                  ), tab:
                  Container(
                    height: size.height * 0.87,
                    child: selectedItemView(context, size),
                  ), windows:
                  Container(
                    height: size.height * 0.87,
                    child: selectedItemView(context, size),
                  )),
                  gapHC(10),
                  g.wstrOrderMode == "CANCEL" ?
                  GestureDetector(
                    onTap: (){
                      //
                      fnSaveOrder();
                    },
                    child: Container(
                      height: 60,
                      width: size.width*0.9,
                      decoration: boxBaseDecoration(PrimaryColor, 10),
                      child: Center(
                        child: tc('CANCEL ORDER',Colors.white,20),
                      ),
                    ),
                  ):
                  Container(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            g.wstrMenuMode='EDIT';
                            g.wstrLastMenuItems = lastOrder;
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Menu()));
                          },
                          child: Container(
                            width: size.width*0.45,
                            decoration: boxGradientDecoration(11, 10),
                            child: Center(
                              child: Icon(Icons.add_circle_outline,color: Colors.white,size: 30,),
                            ),
                          ),
                        ),
                        viewOrderBtnSts == true ? GestureDetector(
                          onTap: (){
                            //
                            viewOrderBtnSts ==  true? fnSaveOrder():'';
                          },
                          child: Container(
                            width: size.width*0.45,
                            decoration: boxBaseDecoration(PrimaryColor, 10),
                            child: Center(
                              child: tc('SUBMIT ORDER',Colors.white,20),
                            ),
                          ),
                        ):Container()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: () async{
          return fnPageBack();
        },
      )
    );
  }

  Column selectedItemView(BuildContext context, Size size) {
    return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        padding: EdgeInsets.only(left: 5,right: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                h2('Order '+ orderNo),
                                gapHC(5),
                                // Row(
                                //   children: [
                                //     Icon(Icons.access_time,size: 20,),
                                //     gapWC(10),
                                //     sl3('avg 00:00')
                                //   ],
                                // )
                              ],
                            ),
                            GestureDetector(
                              onTap: (){
                                g.wstrTableUpdateMode = 'O';
                                Navigator.pushReplacement(context, NavigationController().fnRoute(7));
                              },
                              child: g.wstrOrderType =='T'?  h2('Table ' + lstrTableName): g.wstrOrderType =='A'?  h2('' + 'TAKEAWAY ') : h2('' + 'DELIVERY ') ,
                            ),
                            g.wstrOrderType =='T'? h2('Guest '+ lstrGuestNo) :
                            GestureDetector(
                              onTap: (){
                                PageDialog().show(context,orderDialogChild(),'Order Details');
                              },
                              child:Container(
                                decoration: boxDecoration(Colors.amber, 10),
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(Icons.person,color: Colors.black,),
                                    gapW(),
                                    tc('Address',Colors.black,16)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),gapHC(15),
                      ResponsiveWidget(
                      mobile: Container(
                          height: size.height*0.56,
                          child:  itemListGridView()
                      ), tab: Container(
                          height: size.height*0.66,
                          child:  itemListGridView()
                      ), windows: Container(
                          height: size.height*0.68,
                          child:  itemListGridView()
                      )),
                      gapHC(10),
                      Container(
                        decoration: boxBaseDecoration(greyLight, 10),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                tc('Kitchen Note', Colors.black, 18),
                                gapHC(5),
                                Container(
                                  height: 100,
                                  width: size.width*0.4,
                                  padding: EdgeInsets.all(10),
                                  decoration: boxBaseDecoration(Colors.white, 10),
                                  child: TextField(
                                    keyboardType: TextInputType.multiline,
                                    style: TextStyle(fontSize: 18.0),
                                    maxLines: 10,
                                    controller: txtKitchenNote,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                           Container(
                             child:  Column(
                               crossAxisAlignment: CrossAxisAlignment.end,
                               children: [
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: size.width*0.4,
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      tc('Taxable Amount', Colors.black, 18),
                                      gapW(),
                                      tc(lstrTaxableAmt.toStringAsFixed(3), Colors.black, 18),
                                    ],
                                  ),
                                ),
                                 gapHC(5),
                                 Container(
                                   padding: EdgeInsets.all(5),
                                   width: size.width*0.4,
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       tc('VAT Amount', Colors.black, 18),
                                       gapW(),
                                       tc(lstrOrderVat.toStringAsFixed(3), Colors.black, 18),
                                     ],
                                   ),
                                 ),
                                 gapHC(15),
                                 Container(
                                   height: 60,
                                   width: size.width*0.4,
                                   padding: EdgeInsets.all(5),
                                   color: greyLight,
                                   child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                     children: [
                                       tc('Total Amount', Colors.red, 20),
                                       gapW(),
                                       tc(lstrOrderAmountV.toStringAsFixed(3), Colors.red, 20),
                                     ],
                                   ),
                                 )
                               ],
                             ),
                           )
                          ],
                        ),
                      )

                    ],
                  );
  }
  GridView itemListGridView() {
    return GridView.builder(
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 400,
                                childAspectRatio: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20),
                            itemCount:  lastOrder.length,
                            itemBuilder: (BuildContext ctx, index) {
                              var dataList = lastOrder[index];
                              var itemCode = dataList['DISHCODE'] ??'';
                              var itemName = dataList['DISHDESCP']??'';
                              var waitingTime = dataList['WAITINGTIME']??'';
                              var itemPrice = dataList['PRICE1']??'0.0';
                              var itemQty = dataList['QTY']??'0.0';
                              var itemSts = '';
                              var itemClearedQty = 0;
                              var itemClearedQtyS = '';

                              itemSts = dataList["OLD_STATUS"].toString();
                              itemClearedQty = int.parse(dataList["CLEARED_QTY"].toString());
                              itemClearedQtyS = itemClearedQty == 0 ? '' :itemClearedQty.toString();

                              return GestureDetector(
                                onTap: (){
                                  fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
                                },
                                onLongPress: (){
                                  int.parse(itemQty) > 0? fnShowNotePopup(dataList):'';
                                  //fnGetAddOnCombo('ADDON',itemCode,dataList);
                                },
                                child: Container(
                                  height: 60,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                    children: <Widget>[

                                      Expanded(child: GestureDetector(
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
                                              Row(
                                                children: [
                                                  clockRow(' avg  '+waitingTime.toString()),
                                                  gapW(),
                                                  tc(g.fnStatus(itemSts) + '  ' + itemClearedQtyS.toString(),g.fnStatusColor(itemSts),12)
                                                ],
                                              ),
                                              gapHC(5),
                                              tc('x ' + itemQty.toString(),Colors.black,20),
                                            ],
                                          ),
                                        ),
                                      )),
                                      Container(
                                          child:  GestureDetector(
                                            onTap: (){
                                              fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty);
                                            },
                                            onLongPress: (){
                                              fnRemoveItem(dataList);
                                            },
                                            child: Container(
                                              width:70,
                                              margin: EdgeInsets.all(10),
                                              decoration: boxGradientDecoration(12, 15),
                                              child: Center(
                                                child: Icon(Icons.remove_circle_outline_outlined,color: Colors.white,size: 30,),
                                              ),
                                            ),
                                          )
                                      )
                                    ],
                                  ),
                                  decoration: boxDecoration(Colors.white, 15),
                                ),
                              );
                            });
  }

  Column orderDialogChild() => Column(
    children: [
        RoundedInputField(
            hintText: 'First Name',
            txtRadius: 5,
            txtController: txtFullName,
        ),
        RoundedInputField(
          hintText: 'Last Name',
          txtRadius: 5,
          txtController: txtLastName,
        ),
      RoundedInputField(
        hintText: 'Full Address ',
        txtRadius: 5,
        txtController: txtAddress1,
      ),
      RoundedInputField(
        hintText: 'Address 2',
        txtRadius: 5,
        txtController: txtAddress2,
      ),
      RoundedInputField(
        hintText: 'Landmark',
        txtRadius: 5,
        txtController: txtLandMark,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RoundedInputField(
            hintText: 'Mobile No',
            txtRadius: 5,
            txtWidth: 0.25,
            textType: TextInputType.number,
            txtController: txtMob1,
          ),
          RoundedInputField(
            hintText: 'Mobile No 2',
            txtRadius: 5,
            txtWidth: 0.25,
            textType: TextInputType.number,
            txtController: txtMob2,
          )
        ],
      ),
      RoundedInputField(
        hintText: 'Delivery Note',
        txtRadius: 5,
        txtController: txtDeliveryNote,
      ),
      gapH(),
      GestureDetector(

        onTap: (){
          Navigator.pop(context);
        },
        child: Container(
          height: 50,
          decoration: boxDecoration(PrimaryColor, 5),
          child: Center(
            child: tc('Add',Colors.white,20),
          ),
        ),
      )

    ],
  );
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
      tc('AED  '+lstrSelectedRate.toString() ,PrimaryColor,20),
      tc('x ' + lstrSelectedQty.toString() ,Colors.black,20),
      gapHC(20),
      s3('Kitchen Note'),
      gapHC(20),
      Container(
        height: 100,
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
      GestureDetector(
        onTap: (){
          fnUpdateNote(lstrSelectedStkCode);
        },
        child: Container(
          height: 50,
          decoration: boxDecoration(PrimaryColor, 15),
          child: Center(
            child: tc('ADD',Colors.white,20),
          ),
        ),
      )
    ],
  );

  fnItemPress(dataList,qty,mode,sts,itemClearedQty) async{
    bool checkItem = false;
    bool checkQtyZero = false;
    var itemCode = dataList['DISHCODE'].toString();
    var itemName = dataList['DISHDESCP'];
    var waitingTime = dataList['WAITINGTIME'];
    var itemPrice = dataList['PRICE1'];

    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        var lqty = int.parse(e["QTY"]);
        if( itemCode == lcode ){
          checkItem = true;
          if(mode=='ADD'){
            var v =  lqty + qty;
            e["QTY"] = v.toString();
            e["STATUS"] = "P";
            e["PRINT_CODE"] = null;
          }
          else{
            var v =  lqty - qty;
            if(sts != 'R' && sts != 'D'){
              e["QTY"] = v.toString();
              e["STATUS"] = "P";
              e["PRINT_CODE"] = null;
              if(double.parse(e["QTY"].toString()) <= 0){
                fnRemoveItem(dataList);
              }
            }else{
              if(v >= itemClearedQty){
                e["QTY"] = v.toString();
                e["STATUS"] = "P";
                e["PRINT_CODE"] = null;
                if(double.parse(e["QTY"].toString()) <= 0){
                  fnRemoveItem(dataList);
                }
              }else{
                showToast( g.fnStatus(sts) + '');
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
          "DESCP":dataList['DISHDESCP'],
          "QTY":qty.toString(),
          "PRICE1":itemPrice.toString(),
          "NOTE":itemPrice.toString(),
          "REMARKS":itemPrice.toString(),
          "ADDONCODE":itemPrice.toString(),
        });
      });
    }

    setState(() {

    });
    print(lastOrder);
    fnOrderCalc();
    //Vibration.vibrate();

  }
  fnRemoveItem(selectedItem){

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
    fnOrderCalc();
  }
  fnOrderCalc(){
    //lastOrderHead
    if(g.fnValCheck(lastOrder)){
      var totalAmount = 0.0;
      var grossAmount = 0.0;
      var totalQty = 0;
      var vatAmount = 0.0;
      var taxableAmount = 0.0;
      for(var e in lastOrder){
        var sts =  e["STATUS"];
        var vatSts = e["TAXINCLUDE_YN"];
        var vatP = e["VAT"];
        if(sts != 'C'){
          var qty = e["QTY"].toString();
          var price = e["PRICE1"].toString();
          var total = int.parse(qty) *  double.parse(price);
          var vat = 0.0;
          var vatA = 0.0;
          if(vatSts == 'Y' && vatP > 0){
            var dvd = 100 /(100+vatP);
            vat =  total * dvd;
            vatA = total - vat;

            taxableAmount = (taxableAmount + total) - vatA;
            totalAmount =totalAmount +total ;
          }else{
            vat = (vatP)/100;
            vatA = total * vat;
            taxableAmount = taxableAmount + total;
            totalAmount =totalAmount +total + vatA;
          }
          e['TAX_AMT'] = vatA;
          vatAmount = vatA + vatAmount;
          grossAmount = grossAmount +total;
          totalQty = totalQty + int.parse(qty);
        }
      }

      setState(() {
        lstrOrderGross = grossAmount;
        lstrOrderVat = vatAmount;
        lstrOrderQty = totalQty.toString();
        lstrOrderAmount = totalAmount.toStringAsFixed(3);
        lstrOrderAmountV = totalAmount;
        lstrOrderQtyV = totalQty;
        lstrTaxableAmt = taxableAmount;
      });
    }else{
      setState(() {
        lstrOrderVat = 0.0;
        lstrOrderGross =0.0;
        lstrOrderQty = '0.00';
        lstrOrderAmount = '0.00';
        lstrOrderAmountV = 0;
        lstrOrderQtyV = 0;
        lstrTaxableAmt = 0.0;
      });
    }
  }
  fnGetPageData(){

    setState(() {
      txtFullName.clear();
      txtLastName.clear();
      txtAddress1.clear();
      txtAddress2.clear();
      txtLandMark.clear();
      txtMob1.clear();
      txtMob2.clear();
      txtDeliveryNote.clear();
    });

    setState(() {
      lastOrder =g.wstrLastMenuItems;
      lastOrderTable =  g.wstrLastSelectedTables;
      lastOrderAddress = g.wstrLastSelectedAdd;
    });

    if(g.fnValCheck(lastOrderAddress)){
      for (var e in lastOrderAddress) {
        setState(() {
          txtFullName.text = e['FNAME'].toString();
          txtLastName.text = e['LNAME'].toString();
          txtAddress1.text = e['ADDRESS1'].toString();
          txtAddress2.text = e['ADDRESS2'].toString();
          txtLandMark.text = e['LANDMARK'].toString();
          txtMob1.text = e['PHONE1'].toString();
          txtMob2.text = e['PHONE2'].toString();
          txtDeliveryNote.text = e['REMARKS'].toString();
        });
      }
    }


    fnOrderCalc();
    fnGetTableName();
  }
  fnGetTableName() {

    var tableName ='';
    for(var e in lastOrderTable){
      var t = e["TABLE_DESCP"];
      tableName =  tableName == "" ? t :t + ','+ tableName ;
    }
    setState(() {
      lstrTableName = tableName;
    });
  }
  fnShowNotePopup(dataList){

    var itemCode = dataList['DISHCODE'] ??'';
    var itemName = dataList['DISHDESCP']??'';
    var waitingTime = dataList['WAITINGTIME']??'';
    var itemPrice = dataList['PRICE']??'0.0';
    fnGetDetails(itemCode);

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

    });
    PageDialog().showNote(context, ItemDetails(
      fnCallBack: fnItemNoteCallBack,
      lstrDataList: lstrSelectedItem,
      qty: lstrSelectedQty,
      note: lstrSelectedNote.toString(),

    ), 'Item Details');
   // PageDialog().showNote(context, kitchenNoteColumn(), 'Item Details');
  }

  fnItemNoteCallBack(itemCode,note){
    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( itemCode == lcode ){
          e["NOTE"]=note.toString();
          break;
        }
      }
    }
    Navigator.pop(context);
    print(lastOrder);
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
    Navigator.pop(context);
    print(lastOrder);
  }
  fnSaveOrder(){

    if(g.wstrOrderMode != "CANCEL"){
      if(g.wstrOrderType == 'A' || g.wstrOrderType == 'D'){
        // if(txtFullName.text.isEmpty){
        //   PageDialog().show(context,orderDialogChild(),'Order Details');
        //   showToast( 'Please fill name');
        //   return;
        // }else
        if(txtMob1.text.isEmpty){
          PageDialog().show(context,orderDialogChild(),'Order Details');
          showToast( 'Please fill Mobile No');
          return;
        }
      }
    }

    setState(() {
      viewOrderBtnSts =false;
    });


    setState(() {
      lstrKot = [];
      lstrKotTableDet = [];
      lstrKotDet = [];
      lstrKotTableDet = [];
      lstrKotDelivryDet = [];
    });

    var totalAmount = 0.0;
    var totalQty = 0;
    var grossAmount = 0.0;
    var vatAmount = 0.0;
    var taxable = 0.0;
    var totTaxable = 0.0;
    var srno =0 ;
    var lsrno =0 ;
    for(var e in lastOrder){
      var qty = e["QTY"].toString();
      var price = e["PRICE1"].toString();
      var sts =  e["STATUS"];
      var vatSts = e["TAXINCLUDE_YN"];
      var vatP = e["VAT"];
      var total = int.parse(qty) *  double.parse(price);
      var vat = 0.0;
      var vatA = 0.0;
      var gross = 0.0;
      if(sts != 'C'){

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
        totalQty = totalQty + int.parse(qty);
      }

      var netAmt =  gross +vatA;

      srno =srno +1;
      if(int.parse(qty) != 0){
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
          "REF2":"",
          "CREATE_USER":g.wstrUserCd,
          "KITCHENCODE":e["KITCHENCODE"],
          "ADDON_YN":"",
          "ADDON_STKCODE":"",
          "STATUS":"C",
          "ORDER_PRIORITY":0,
          "TAXINCLUDE_YN":e['TAXINCLUDE_YN'],
          "TAX_PER":e["VAT"],
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
          "LINE_SRNO":int.parse(qty) == 0 ? -1 : lsrno,
          "STKCODE":e["DISHCODE"],
          "STKDESCP":e["DISHDESCP"],
          "UNIT1":e["UNIT1"],
          "PRINT_CODE":e["PRINT_CODE"],
          "QTY1":int.parse(qty),
          "RATE":price,
          "RATEFC":price,
          "GRAMT":gross,
          "GRAMTFC":gross,
          "AMT":gross,
          "AMTFC":gross,
          "REF1":e["NOTE"],
          "REF2":"",
          "CREATE_USER":g.wstrUserCd,
          "KITCHENCODE":e["KITCHENCODE"],
          "ADDON_YN":"",
          "ADDON_STKCODE":"",
          "STATUS":e["STATUS"],
          "ORDER_PRIORITY":0,
          "TAXINCLUDE_YN":e['TAXINCLUDE_YN'],
          "TAX_PER":e["VAT"],
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
      "REF1":txtKitchenNote.text,
      "REF2":txtAddNote.text,
      "REF2":g.wstrDeliveryMode,
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
    });



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
      "ADDRESS3":"",
      "ADDRESS4":"",
      "LANDMARK":txtLandMark.text,
      "PHONE1":txtMob1.text,
      "PHONE2":txtMob2.text,
      "REMARKS":txtDeliveryNote.text,
    });


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
      showToast( 'Please choose item');
    }




  }
  fnSave() async{
    futureOrder=  apiCall.saveOrder(lstrKot,lstrKotDet,lstrKotTableDet,lstrKotDelivryDet,wstrPageMode,"","","",[]);
    futureOrder.then((value) => fnSaveSuccess(value));
  }
  fnSaveSuccess(value){

    if(g.fnValCheck(value)){
     print(value);
     var sts =  value[0]['STATUS'];
     var msg =  value[0]['MSG'];

     if(sts == '1'){
       Navigator.pushReplacement(context, NavigationController().fnRoute(1));
     }else{
       setState(() {
         viewOrderBtnSts =true;
       });
     }
     showToast( msg??'');
    }else{
      setState(() {
        viewOrderBtnSts =true;
      });
      showToast( 'Failed');
    }
  }
  bool fnPageBack(){
    g.wstrMenuMode='EDIT';
    g.wstrLastMenuItems = lastOrder;
    if(g.wstrOrderMode == "CANCEL"){
      Navigator.pushReplacement(context, NavigationController().fnRoute(1));
    }else{
      Navigator.pushReplacement(context, NavigationController().fnRoute(6));
    }

    return false;
  }


  //api
  fnGetDetails(code){
    futureDetails = apiCall.getComboAddon("KOT", code);
    futureDetails.then((value) => fnInstructionSuccess(value) );
  }
  fnInstructionSuccess(value){
    if(g.fnValCheck(value)){
      setState(() {
        lstrLastInstructions = value;
      });
    }

  }

}
