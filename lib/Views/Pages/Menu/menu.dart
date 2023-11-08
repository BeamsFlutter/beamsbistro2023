
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/responsiveHelper.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:beamsbistro/Views/Pages/Order/orders.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

   var wstrPageMode= '';

   var txtQty = new TextEditingController();
   var txtNote = new TextEditingController();
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
   var lstrOrderQty = '';
   var lstrOrderQtyV = 0;
   var lstrOrderAmountV = 0.0;
   var lstrOrderGross = 0.00;
   var lstrOrderVat = 0.00;
   var lstrOrderTotal = 0.00;

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

   var lstrSelectedItem = [];
   var lstrSelectedInstructions = [];
   var lstrLastInstructions = [];

   //search


   //sidemenu



   //api

   ApiCall apiCall = ApiCall();
   Global g = Global();
   late Future<dynamic> futureMenu;
   late Future<dynamic> futureAddon;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    wstrPageMode = g.wstrMenuMode;
    wstrSelectedTables = g.wstrLastSelectedTables;
    print('HEllo');
    print(wstrSelectedTables);
    if(wstrPageMode == 'EDIT'){
      lastOrder =  g.wstrLastMenuItems;
      fnOrderCalc();
    }else{
      //showToast( 'ADD');
      lastOrder = [];
    }
    fnGetTableName();
    fnGetMenu();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: navigationTitleAppBar(context,'Menu',fnPageBack),
      body:WillPopScope(
        child: Container(
          height: size.height,
          width: size.width,
          margin: pageMargin(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: size.width,
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: (){
                                g.wstrTableUpdateMode = 'M';
                                Navigator.pushReplacement(context, NavigationController().fnRoute(7));
                              },
                              child: g.wstrOrderType =='T'?   tc('Table ' + lstrTableName,Colors.black,30): g.wstrOrderType =='A'? tc('TAKEAWAY ',Colors.black,30) : tc('DELIVERY ',Colors.black,30) ,
                            ),
                            RoundedInputField(
                               hintText: 'Search.',
                               txtRadius: 10,
                               txtWidth: 0.5,
                              txtController: txtSearchDishCode,
                              suffixIcon: Icons.cancel_outlined,
                              suffixIconOnclick: (){
                                fnClearSearch();
                              },
                              onChanged: (value){
                                fnSearchDishCode();
                              },
                            )
                          ],
                        )
                      ],
                    )
                ),
                gapHC(10),
                ResponsiveWidget(
                    mobile: Container(
                      height: size.height*0.76,
                      child: menuScreenView(size),
                    ),
                    tab: Container(
                      height: size.height*0.83,
                      child: menuScreenView(size),
                    ),
                    windows: Container(
                      height: size.height*0.78,
                      child: menuScreenView(size),
                    ))
                ,
                gapHC(10),
                lstrOrderQtyV > 0 ?
                GestureDetector(
                  onTap: (){
                  },
                  child: Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onLongPress: (){
                              fnClearSelected();
                            },
                            child: Container(
                              width: size.width*0.2,
                              decoration: boxBaseDecoration(greyLight, 10),
                              child: Center(
                                child: tc('Cancel'  ,Colors.black,18),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width*0.3,
                            decoration: boxBaseDecoration(SecondaryColor, 10),
                            child: Center(
                              child: tc('AED : ' + lstrOrderAmount   ,Colors.black,18),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              g.wstrLastMenuItems = lastOrder;
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Orders()));
                            },
                            child: Container(
                              width: size.width*0.4,
                              decoration: boxBaseDecoration(PrimaryColor, 10),
                              child: Center(
                                child: tc('View Order   '    ,Colors.white,18),
                              ),
                            ),
                          )
                        ],
                      )
                  ),
                ):Container()
              ],

            ),
          ),
        ),
        onWillPop: () async{
          return fnPageBack();
        },
      )
    );
  }

  SingleChildScrollView menuScreenView(Size size) {
    return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 60,
                          width: size.width *0.9,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              lstrMenuGroup == null ?
                              Container(
                                decoration: boxDecoration(SecondaryColor, 5),
                                width: 80,
                                child: Center(
                                  child: tc('Quick', Colors.black, 20),
                                ),
                              )
                                  :
                              GestureDetector(
                                onTap: (){
                                  fnBackButton();
                                },
                                onLongPress: (){
                                  fnBackLongPress();
                                },
                                child:  Container(
                                  decoration: boxDecoration(SecondaryColor, 5),
                                  width: 80,
                                  child: Center(
                                    child: Icon(Icons.arrow_back_ios_rounded,size: 25,),
                                  ),
                                ),
                              )
                              ,
                              Container(
                                width: size.width*0.75,
                                child: new FutureBuilder<dynamic>(
                                  future: futureMenu,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return menuGroupView(snapshot);
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
                          )
                      ),
                      gapHC(15),
                      tc(lstrSelectedCategory.toString(),Colors.black,20),
                      gapHC(15),
                      ResponsiveWidget(
                          mobile: Container(
                            height: size.height*0.65,
                            child: futureMenuview(),
                          ),
                          tab: Container(
                            height: size.height*0.73,
                            child: futureMenuview(),
                          ),
                          windows: Container(
                            height: size.height*0.73,
                            child: futureMenuview(),
                          ))
                    ],
                  ),
                );
  }
  FutureBuilder<dynamic> futureMenuview() {
    return new FutureBuilder<dynamic>(
                          future: futureMenu,
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

   Widget menuGroupView(snapshot){
     return ListView.builder(
         scrollDirection: Axis.horizontal,
         physics: AlwaysScrollableScrollPhysics(),
         itemCount: snapshot.data['Table2'].length,
         itemBuilder: (context, index) {
           var dataList = snapshot.data['Table2'][index];
           var code = dataList['CODE']??'';
           var menuGroupName = dataList['DESCP']??'';
           return GestureDetector(
             onTap: (){
               fnUpdateTable(code,menuGroupName);
             },
             child:  Container(
               height: 50,
               padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
               margin: EdgeInsets.only(right: 10),
               decoration: boxBaseDecoration(lstrMenuGroup == code ? PrimaryColor :blueLight, 5),
               child: Center(
                 child: tc(menuGroupName, lstrMenuGroup == code ? Colors.white : PrimaryText,18),
               ),
             ),
           );
         });
   }
   Widget itemView(snapshot){
     return GridView.builder(
         gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
             maxCrossAxisExtent: 400,
             childAspectRatio:  2,
             crossAxisSpacing: 20,
             mainAxisSpacing: 20),
         itemCount:  snapshot.data['Table1'].length,
         itemBuilder: (BuildContext ctx, index) {
           var dataList = snapshot.data['Table1'][index];
           var itemCode = dataList['DISHCODE'] ??'';
           var itemName = dataList['DISHDESCP']??'';
           var waitingTime = dataList['WAITINGTIME']??'';
           var itemPrice = dataList['PRICE1']??'0.0';

           var itemSts = '';
           var itemClearedQty = 0;
           var itemClearedQtyS = '';
           var orderData = fnCheckItem(itemCode);
           bool orderSts  = false;

           if(g.fnValCheck(orderData)){
             var qty = int.parse(orderData["QTY"]);
             itemSts = orderData["OLD_STATUS"].toString();
             itemClearedQty = int.parse(orderData["CLEARED_QTY"].toString());
             itemClearedQtyS = itemClearedQty == 0 ? '' :itemClearedQty.toString();
             if(qty > 0){
               orderSts = true;
             }

           }

           return GestureDetector(
             onTap: (){
               fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
             },
             onLongPress: (){

               orderSts ==true ? fnShowNotePopup(dataList,orderData):'';
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
                           tc(orderSts ? 'x ' + orderData["QTY"].toString() : '',Colors.black,20),
                         ],
                       ),
                     ),
                   )),
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
                           width:70,
                           margin: EdgeInsets.all(10),
                           decoration: boxGradientDecoration(12, 15),
                           child: Center(
                             child: Icon(Icons.remove_circle_outline_outlined,color: Colors.white,size: 30,),
                           ),
                         ),
                       )
                   )
                   :Container()
                 ],
               ),
               decoration: boxDecoration(Colors.white, 15),
             ),
           );
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
           var itemPrice = dataList['PRICE']??'0.0';
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
       s3('Kitchen Note'),
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
           decoration: boxDecoration(PrimaryColor, 15),
           child: Center(
             child: tc('ADD',Colors.white,20),
           ),
         ),
       )
     ],
   );
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

   //api
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

      showToast( 'Error');
    }
  }
  fnGetAddOnCombo(mode,code,dataList){
    //futureAddon = apiCall.getComboAddon(mode, code);
    //futureAddon.then((value) => fnShowNotePopup(value) );
  }

  //Other
  fnUpdateTable(code,descp) {
     setState(() {
       lstrSelectedCategoryList.add(descp);
       switch (lastLevel) {
         case 0:
           lstrMenuGroup = code;
           break;
         case 1:
           lstrGp1 = code;
         break;
         case 2:
           lstrGp2 = code;
           break;
         case 3:
           lstrGp3 = code;
           break;
         case 4:
           lstrGp4 = code;
           break;
         case 5:
           lstrGp5 = code;
           break;
         case 6:
           lstrGp6 = code;
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
           lstrSelectedCategoryList[1] = null;
           break;
         case 3:
           lstrGp2 = null;
           lstrSelectedCategoryList[2] = null;
           break;
         case 4:
           lstrGp3 = null;
           lstrSelectedCategoryList[3] = null;
           break;
         case 5:
           lstrGp4 = null;
           lstrSelectedCategoryList[4] = null;
           break;
         case 6:
           lstrGp5 = null;
           lstrSelectedCategoryList[5] = null;
           break;
         case 7:
           lstrGp6 = null;
           lstrSelectedCategoryList[6] = null;
           break;
         case 8:
           lstrGp7 = null;
           lstrSelectedCategoryList[7] = null;
           break;
         case 9:
           lstrGp8 = null;
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
               if(v >= itemClearedQty){
                 e["QTY"] = v.toString();
                 e["STATUS"] = "P";
                 e["PRINT_CODE"] = null;
                 if(double.parse(e["QTY"].toString()) <= 0){
                   fnRemoveItem(dataList,e);
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
           "DISHDESCP":dataList['DISHDESCP'],
           "QTY":qty.toInt().toString(),
           "PRICE1":itemPrice.toString(),
           "WAITINGTIME":waitingTime.toString(),
           "NOTE":"",
           "PRINT_CODE":null,
           "REMARKS":itemPrice.toString(),
           "UNIT1":dataList['UNIT'],
           "KITCHENCODE":dataList['KITCHENCODE'],
           "ADDON_YN":"",
           "ADDON_STKCODE":"",
           "CLEARED_QTY":"0",
           "NEW":"Y",
           "OLD_STATUS":"",
           "TAXINCLUDE_YN":dataList['TAXINCLUDE_YN'],
           "VAT":dataList['VAT'],
           "TAX_AMT":0,
           "STATUS":"P"
         });
       });
     }

     setState(() {

     });
     print(lastOrder);
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
        });
      }else{
        if(newItem == "Y"){
          setState(() {
            lastOrder.remove(selectedItem);
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
    groupInstruction =  fnCheckInstruction(dishGroup);
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

     });
     // PageDialog().showNote(context, ItemDetails(
     //   fnCallBack: fnItemNoteCallBack,
     //   lstrDataList: lstrSelectedItem,
     //   qty: lstrSelectedQty,
     //   note: lstrSelectedNote.toString(),
     //
     // ), 'Item Details');
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
      var totalQty = 0;
      var vatAmount = 0.0;
      var taxable = 0.0;
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

            taxable = (taxable +total) - vatA;
            totalAmount =totalAmount +total ;
          }else{
            vat = (vatP)/100;
            vatA = total * vat;
            totalAmount =totalAmount +total + vatA;
          }
          grossAmount = grossAmount +total;
          vatAmount = vatA + vatAmount;
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
      });
    }else{
      setState(() {
        lstrOrderVat = 0.0;
        lstrOrderGross =0.0;
        lstrOrderQty = '0.00';
        lstrOrderAmount = '0.00';
        lstrOrderAmountV = 0;
        lstrOrderQtyV = 0;
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
  fnClearSelected(){
      if(g.wstrOrderMode == 'ADD'){
        setState(() {
          lastOrder.clear();
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

}


