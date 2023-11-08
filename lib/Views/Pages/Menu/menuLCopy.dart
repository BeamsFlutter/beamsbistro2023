
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/responsiveHelper.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';



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

  var lstrOrderQty = '';
  var lstrOrderQtyV = 0;
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

  var lstrSelectedItem = [];
  var lstrSelectedInstructions = [];
  var lstrLastInstructions = [];


  ApiCall apiCall = ApiCall();
  Global g = Global();
  late Future<dynamic> futureMenu;
  late Future<dynamic> futureAddon;
  late Future<dynamic> futureOrder;
  late Future<dynamic> futureReason;

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



  //save order
  bool viewOrderBtnSts =true;
  var lstrKot = [];
  var lstrKotDet = [];
  var lstrKotTableDet = [];
  var lstrKotDelivryDet = [];

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
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 35,left: 10,right: 10),
                height: 50,
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
                        GestureDetector(
                          onTap: (){
                            if(g.wstrOrderType =='T'){
                              g.wstrTableUpdateMode = 'M';
                              Navigator.pushReplacement(context, NavigationController().fnRoute(7));
                            }
                          },
                          child:th(((g.wstrOrderType =='T'?  'Table ' : g.wstrOrderType =='A'? 'TAKEAWAY ': 'DELIVERY ' )+ lstrTableName.toString() ),Colors.black,22),
                        )
                      ],
                    ),
                   Row(
                     children: [
                       RoundedInputField(
                         hintText: 'Search.',
                         txtRadius: 10,
                         txtWidth: 0.4,
                         txtController: txtSearchDishCode,
                         suffixIcon: Icons.cancel_outlined,
                         suffixIconOnclick: (){
                           fnClearSearch();
                         },
                         onChanged: (value){
                           fnSearchDishCode();
                         },
                       ),
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
                             child: th('Close',Colors.red,15),
                           ),
                         ),
                       ),


                     ],
                   )

                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    height: size.height*0.86,
                    width: size.width*0.65,
                    padding: EdgeInsets.all(10),
                    child: menuScreenView(size),

                  ),
                  Container(
                    height: size.height*0.85,
                    width: size.width*0.33,
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
                            tcn("Choose Items...".toString(),greyLight,25),
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
                              var waitingTime = dataList['WAITINGTIME']??'';
                              var itemPrice = dataList['PRICE1']??'0.0';
                              var itemQty = dataList['QTY']??'0.0';
                              var itemSts = '';
                              var itemClearedQty = 0;
                              var itemClearedQtyS = '';
                              var itemNote = dataList['NOTE']??'';
                              itemSts = dataList["OLD_STATUS"].toString();
                              itemClearedQty = int.parse(dataList["CLEARED_QTY"].toString());
                              itemClearedQtyS = itemClearedQty == 0 ? '' :itemClearedQty.toString();
                              var itemqty1 = 0.0;
                              itemqty1 = g.mfnDbl(itemQty.toString());
                              return GestureDetector(
                                onTap: (){
                                  fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
                                },
                                onLongPress: (){
                                  int.parse(itemQty) > 0? fnShowNotePopupSelected(dataList):'';

                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 2,bottom: 2),
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            gapWC(5),
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
                                            Expanded(child: GestureDetector(
                                              child: Container(
                                                padding: EdgeInsets.only(left: 15),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    th(itemName.toString(),Colors.black,14),
                                                    tcn('AED  ' + itemPrice.toString(),PrimaryColor,15),
                                                    //catS('AED  ' + itemPrice.toString()),
                                                  ],
                                                ),
                                              ),
                                            )),
                                            Container(
                                                child:  GestureDetector(
                                                  onTap: (){
                                                    int.parse(itemQty) > 0?
                                                    fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty):''
                                                    ;
                                                  },
                                                  onLongPress: (){
                                                    fnRemoveItemSelected(dataList);
                                                    // fnRemoveItemSelected(dataList,orderData);
                                                  },
                                                  child: Container(
                                                    width:60,
                                                    height:40,
                                                    margin: EdgeInsets.all(10),
                                                    decoration: boxDecoration(double.parse(itemQty) >0? Colors.white: Colors.red, 5),
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
                                          child:  ts('Note : '+itemNote,Colors.black,15),
                                        )
                                      ],
                                    ),
                                  ),
                                  decoration: boxBaseDecoration(blueLight, 7),
                                ),
                              );
                            })),
                        gapHC(5),
                        lineC(0.2, Colors.black),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              th('Selected Items', Colors.black, 15),
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
                              th('Total Amount', Colors.red, 15),
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
                            GestureDetector(
                              onTap: (){
                                 g.wstrTableUpdateMode = 'M';
                                 Navigator.pushReplacement(context, NavigationController().fnRoute(7));
                              },
                              child: Container(
                                width: size.width*0.05,
                                height: 40,
                                decoration: boxBaseDecoration(Colors.amber, 10),
                                child: Center(
                                  child: Icon(Icons.table_chart),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                viewOrderBtnSts ==  true? fnSaveOrder():'';
                              },
                              child: Container(
                                width: size.width*0.15,
                                height: 40,
                                decoration: boxGradientDecoration(16, 60),
                                child: Center(
                                  child: tc('SUBMIT ORDER',Colors.white,15),
                                ),
                              ),
                            )
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
                            tcn('Qty',Colors.black,15),
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
                            tcn('Kitchen Note',Colors.black,15),
                            gapHC(5),
                            Row(
                              children: [
                                Container(
                                  height: 120,
                                  width: size.width*0.25,
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
                                  child: tc('Close',Colors.black,15),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                fnItemNoteCallBack(lstrSelectedStkCode,txtNote.text.toString(),txtQty.text);
                              },
                              child: Container(
                                height: 40,
                                width: size.width*0.21,
                                decoration: boxGradientDecoration(16, 60),
                                child: Center(
                                  child: tc('ADD',Colors.white,15),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ):sidePageView == "A"?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       Container(
                         height: size.height*0.7,
                         padding: EdgeInsets.all(5),
                         child: SingleChildScrollView(
                           child: Column(
                             children: [
                               RoundedInputField(
                                 hintText: 'Vehicle No',
                                 labelYn: 'Y',
                                 txtRadius: 5,
                                 txtController: txtVehicleNo,
                               ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  RoundedInputField(
                                    hintText: 'Mobile No',
                                    labelYn: 'Y',
                                    txtRadius: 5,
                                    textType: TextInputType.number,
                                    txtController: txtMob1,
                                    txtWidth: 0.15,
                                  ),
                                  RoundedInputField(
                                    hintText: 'Mobile No 2',
                                    labelYn: 'Y',
                                    txtRadius: 5,
                                    textType: TextInputType.number,
                                    txtController: txtMob2,
                                    txtWidth: 0.15,
                                  ),
                                ],
                              ),
                               RoundedInputField(
                                 hintText: 'First Name',
                                 txtRadius: 5,
                                 labelYn: 'Y',
                                 txtController: txtFullName,
                               ),
                               RoundedInputField(
                                 hintText: 'Last Name',
                                 labelYn: 'Y',
                                 txtRadius: 5,
                                 txtController: txtLastName,
                               ),
                               RoundedInputField(
                                 hintText: 'Full Address ',
                                 labelYn: 'Y',
                                 txtRadius: 5,
                                 txtController: txtAddress1,
                               ),
                               RoundedInputField(
                                 hintText: 'Address 2',
                                 labelYn: 'Y',
                                 txtRadius: 5,
                                 txtController: txtAddress2,
                               ),
                               RoundedInputField(
                                 hintText: 'Landmark',
                                 labelYn: 'Y',
                                 txtRadius: 5,
                                 txtController: txtLandMark,
                               ),
                               RoundedInputField(
                                 hintText: 'Delivery Note',
                                 labelYn: 'Y',
                                 txtRadius: 5,
                                 txtController: txtDeliveryNote,
                               ),
                             ],
                           ),
                         ),
                       ),
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
                              child: th('DONE',Colors.white,16),
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
                              tc('Item Cancel',Colors.black,20)
                            ],
                          ),
                          gapHC(10),
                          line(),
                          gapHC(10),
                          ts('Reason Note',Colors.black,15),
                          gapHC(5),

                          Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: size.width*0.24,
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
                                    ),
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

                                    numberPress('1'),
                                    numberPress('2'),
                                    numberPress('3'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    numberPress('4'),
                                    numberPress('5'),
                                    numberPress('6'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    numberPress('7'),
                                    numberPress('8'),
                                    numberPress('9'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                   Icon(Icons.fingerprint,size: 45,color: Colors.white,),
                                    numberPress('0'),
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
                                  decoration: boxBaseDecoration(greyLight, 5),
                                  child: Center(
                                    child: tc('Close',PrimaryColor,20),
                                  ),
                                ),
                              ),
                              GestureDetector(

                                onTap: (){
                                  setState(() {
                                    voidMode = "Y";
                                    viewOrderBtnSts ==  true? fnSaveOrder():'';
                                  });
                                  //Navigator.pop(context);
                                },
                                child: Container(
                                  height: 40,
                                  width: size.width*0.2,
                                  decoration: boxDecoration(PrimaryColor, 5),
                                  child: Center(
                                    child: tc('VOID',Colors.white,20),
                                  ),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ):Column(
                      children: [],
                    ),

                  ),

                ],
              )
            ],
          ),
        ),
      ),
    ),
        onWillPop: () async{
          return fnPageBack();
        },
    );
  }
  //widget
  SingleChildScrollView menuScreenView(Size size) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          lstrMenuGroup != null ?
          Container(
              height: 60,
              width: size.width *0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      height: 50,
                      child: Center(
                        child: Icon(Icons.arrow_back_ios_rounded,size: 25,),
                      ),
                    ),
                  )
                  ,
                  Container(
                    width: size.width*0.55,
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
          ):
          Container(),
          gapHC(10),
          tc(lstrSelectedCategory.toString(),Colors.black,20),
          gapHC(10),
          Container(
            height: size.height*0.81,
            child: futureMenuview(),
          )
        ],
      ),
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
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio:  1.8,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15),
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
              setState(() {
                sidePageView = "O";
              });
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
                             // tc(g.fnStatus(itemSts) + '  ' + itemClearedQtyS.toString(),g.fnStatusColor(itemSts),12)
                            ],
                          ),
                          gapHC(5),
                          tc(orderSts ? 'x ' + orderData["QTY"].toString() : '',Colors.black,15),
                        ],
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
                          fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty);
                        },
                        onLongPress: (){
                          setState(() {
                            sidePageView = "O";
                          });
                          fnRemoveItem(dataList,orderData);
                        },
                        child: Container(
                          width:50,
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
              ),
              decoration: boxDecoration(Colors.white, 15),
            ),
          );
        });
  }
  Widget catView(snapshot){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio:  1.6,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemCount:  snapshot.data['Table2'].length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data['Table2'][index];
          var code = dataList['CODE']??'';
          var menuGroupName = dataList['DESCP']??'';

          return code != null? GestureDetector(
            onTap: (){
              fnUpdateTable(code,menuGroupName);
            },
            child: Container(
              margin: EdgeInsets.all(3),
              height: 60,
              width: 200,
              alignment: Alignment.center,
              child: Center(
                child:tc(menuGroupName.toString(), Colors.black, 15),
              ),
              decoration: boxDecoration(Colors.amber, 5),
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
      tcn('Kitchen Note',Colors.black,15),
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
            child: tc('ADD',Colors.white,20),
          ),
        ),
      )
    ],
  );
  GestureDetector numberPress(text) => GestureDetector(
    onTap: (){
      fnOnPress(text);
    },

    child: ResponsiveWidget(
      mobile: Container(
        height: 45,
        width: 80,
        margin: EdgeInsets.only(bottom: 5),
        decoration: boxDecoration(Colors.white, 10),
        child: Center(
          child: tc(text,Colors.black,30),
        ),
      ),
      tab: Container(
        height: 45,
        width: 80,
        margin: EdgeInsets.only(bottom: 5),
        decoration: boxDecoration(Colors.white, 10),
        child: Center(
          child: tc(text,Colors.black,30),
        ),
      ),
      windows: Container(
        height: 45,
        width: 80,
        margin: EdgeInsets.only(bottom: 5),
        decoration: boxDecoration(Colors.white, 10),
        child: Center(
          child: tc(text,Colors.black,30),
        ),
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
          return lastLevel == 0? catView(snapshot) :
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


  //page function..
  fnGetPageData(){

    setState(() {

      txtVehicleNo.clear();
      txtFullName.clear();
      txtLastName.clear();
      txtAddress1.clear();
      txtAddress2.clear();
      txtLandMark.clear();
      txtMob1.clear();
      txtMob2.clear();
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
        fnOrderCalc();
      }else{
        //showToast( 'ADD');
        lastOrder = [];
      }
    });

    if(g.fnValCheck(lastOrderAddress)){
      for (var e in lastOrderAddress) {
        setState(() {
          txtVehicleNo.text = e['ADDRESS4'].toString();
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
  }

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
    if(mode == "ADD"){
      fnGetAddOnCombo('ADDON',itemCode,dataList);
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
      var totalQty = 0;
      var vatAmount = 0.0;
      var taxable = 0.0;
      for(var e in lastOrder){
        var sts =  e["STATUS"];
        var vatSts = e["TAXINCLUDE_YN"];
        var vatP = e["VAT"];
        if(sts != 'C'){
          var qty = e["QTY"].toString();
          var vQty = e["VOID_QTY"]??0;
          var price = e["PRICE1"].toString();
         // var aQty = int.parse(qty)- vQty;
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
  fnGetAddOnCombo(mode,code,dataList){
    futureAddon = apiCall.getComboAddon(mode, code);
    futureAddon.then((value) => fnGetAddOnComboSuccess(value,dataList) );
  }
  fnGetAddOnComboSuccess(value,dataList){
    if(g.fnValCheck(value)){
      //showDownbar(dataList);
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


  fnSaveOrder(){
    if(voidMode == "Y" && txtReason.text.isEmpty){
      showToast( "Please fill reasone note..");
      return;
    }
    if(g.wstrOrderMode != "CANCEL" && voidMode != "Y"  ){
      if(g.wstrOrderType == 'A' ){
        // if(txtFullName.text.isEmpty){
        //   PageDialog().show(context,orderDialogChild(),'Order Details');
        //   showToast( 'Please fill name');
        //   return;
        // }else
        if(txtVehicleNo.text.isEmpty){
          //PageDialog().show(context,orderDialogChild(),'Order Details');
          setState(() {
            sidePageView = "A";
          });
          showToast( 'Please fill vehicle no');
          return;
        }
      }
      if(g.wstrOrderType == 'D' ){
         if(txtFullName.text.isEmpty){
           setState(() {
             sidePageView = "A";
           });
           showToast( 'Please fill name');
           return;
         }else
        if(txtMob1.text.isEmpty){
          //PageDialog().show(context,orderDialogChild(),'Order Details');
          setState(() {
            sidePageView = "A";
          });
          showToast( 'Please fill mobile no');
          return;
        }
      }
      if(g.wstrOrderType == 'T' ){

        if(!g.fnValCheck(g.wstrLastSelectedTables)){

          showToast( 'Please choose table');
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
      var vQty = e["VOID_QTY"]??0;
      var price = e["PRICE1"].toString();
      var sts =  e["STATUS"];
      var vatSts = e["TAXINCLUDE_YN"];
      var vatP = e["VAT"];
      var vat = 0.0;
      var vatA = 0.0;
      var gross = 0.0;
      //var aQty = int.parse(qty)- vQty;
      var total = int.parse(qty) *  double.parse(price);

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
      "REF1":"",
      "REF2":"",
      "REF3":g.wstrDeliveryMode,
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
    futureOrder=  apiCall.saveOrder(lstrKot,lstrKotDet,lstrKotTableDet,lstrKotDelivryDet,wstrPageMode,passCode,lstrSelectedVoidCode,txtReason.text,[]);
    futureOrder.then((value) => fnSaveSuccess(value));
  }
  fnSaveSuccess(value){
    fnOnPressClear();
    if(g.fnValCheck(value)){
      print(value);
      setState(() {

      });
      var sts =  value[0]['STATUS'];
      var msg =  value[0]['MSG'];

      if(sts == '1'){
        Navigator.pushReplacement(context, NavigationController().fnRoute(1));
      }else if(sts == '2'){

        setState(() {

          sidePageView = "V";
          viewOrderBtnSts =true;
        });

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

  //reason
  fnGetReason(){
    futureReason =  apiCall.getReason();
  }


}
