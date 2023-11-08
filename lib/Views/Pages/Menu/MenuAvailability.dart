

import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:oktoast/oktoast.dart';

import '../../../Controllers/Global/globalValues.dart';
import '../../Styles/colors.dart';

class MenuAvailability extends StatefulWidget {
  const MenuAvailability({Key? key}) : super(key: key);

  @override
  State<MenuAvailability> createState() => _MenuAvailabilityState();
}

class _MenuAvailabilityState extends State<MenuAvailability> {


  //Global
  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic> futureMenu;

  var txtAvailable =  TextEditingController();
  var txtNotAvailable =  TextEditingController();


  var lstrAvailableItem = [];
  var lstrNotAvailableItem = [];

  var lstrSelectedAvailable  =[];
  var lstrSelectedNotAvailable  =[];

  @override
  void initState() {
    // TODO: implement initState
    fnGetPagedata();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left:10),
          child: Icon(Icons.food_bank_outlined,color: PrimaryText,size: 30,),
        ),
        title: tc('86 MENU', Colors.black, 20),
        actions: [
          gapWC(5),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              width: 50,
              margin: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              decoration: boxBaseDecoration(greyLight, 10),
              child: Icon(Icons.cancel_outlined,color: Colors.black,size: 20,),
            ),
          ),
          gapWC(10),

        ],
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            Expanded(child: Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: boxDecoration(Colors.white, 5),
                    width: size.width*0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: boxDecoration(Colors.green, 5),
                            child: Row(
                              children: [
                                Icon(Icons.adjust_rounded,color: Colors.white,size: 20,),
                                gapWC(5),
                                tcn(' |  Available Items', Colors.white, 15),
                              ],
                            ),
                          ),
                          gapHC(10),
                          RoundedInputField(
                            hintText: 'Search',
                            txtRadius: 5,
                            txtHeight: 35,
                            suffixIcon: Icons.search,
                            txtController: txtAvailable,
                            onChanged: (value){
                              fnGetAvailableMenu();
                            },

                          ),
                          Expanded(child: getAvailableMenuItem())
                        ],
                      ),
                    )
                  ),
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Bounce(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 50),
                            decoration: boxDecoration(Colors.white, 5),
                            child: Center(
                              child: Icon(Icons.navigate_next_rounded,size: 50,),
                            ),
                          ),
                          duration: Duration(milliseconds: 110),
                          onPressed: (){
                            fnUpdateMenuNotAvailable();
                          },
                        ),
                        gapHC(10),
                        Bounce(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 50),
                            decoration: boxDecoration(Colors.white, 5),
                            child: Center(
                              child: Icon(Icons.navigate_before_rounded,size: 50,),
                            ),
                          ),
                          duration: Duration(milliseconds: 110),
                          onPressed: (){
                            fnUpdateMenuAvailable();
                          },
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: boxDecoration(Colors.white, 5),
                        width: size.width*0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: boxDecoration(Colors.red, 5),
                              child: Row(
                                children: [
                                  Icon(Icons.adjust_rounded,color: Colors.white,size: 20,),
                                  gapWC(5),
                                  tcn(' |  Unavailable Items', Colors.white, 15),
                                ],
                              ),
                            ),
                            gapHC(10),
                            RoundedInputField(
                              hintText: 'Search',
                              txtRadius: 5,
                              txtHeight: 35,
                              suffixIcon: Icons.search,
                              txtController: txtNotAvailable,
                              onChanged: (value){
                                fnGetNotAvailableMenu();
                              },

                            ),
                            Expanded(child: getNotAvailableMenuItem())
                          ],
                        ),
                      )
                  ),

                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
  //==========================================WIDGET===============================
  Widget getAvailableMenuItem(){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio:  1.8,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemCount:  lstrAvailableItem.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = lstrAvailableItem[index];
          var itemCode = dataList['DISHCODE'] ??'';
          var itemName = dataList['DISHDESCP']??'';
          var itemPrice = dataList['PRICE1']??'0.0';


          return GestureDetector(
            onTap: (){
              fnAddaAvailable(itemCode);
            },
            onLongPress: (){

            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(left: 7),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gapHC(5),
                            tcn(itemName.toString(),lstrSelectedAvailable.contains(itemCode)?Colors.white:Colors.black,13),
                            th('AED  ' + itemPrice.toString(),lstrSelectedAvailable.contains(itemCode)?Colors.white:PrimaryColor,13),
                            gapHC(5),
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
              decoration: boxDecoration( lstrSelectedAvailable.contains(itemCode)? Colors.red:Colors.white, 5),
            ),
          );
        });
  }
  Widget getNotAvailableMenuItem(){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio:  1.8,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemCount:  lstrNotAvailableItem.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = lstrNotAvailableItem[index];
          var itemCode = dataList['DISHCODE'] ??'';
          var itemName = dataList['DISHDESCP']??'';
          var itemPrice = dataList['PRICE1']??'0.0';


          return GestureDetector(
            onTap: (){
              fnAddaNotAvailable(itemCode);
            },
            onLongPress: (){

            },
            child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(left: 7),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gapHC(5),
                            tcn(itemName.toString(),lstrSelectedNotAvailable.contains(itemCode)?Colors.white:Colors.black,13),
                            th('AED  ' + itemPrice.toString(),lstrSelectedNotAvailable.contains(itemCode)?Colors.white:PrimaryColor,13),
                            gapHC(5),
                          ],
                        ),
                      ),
                    ),
                  )),
                ],
              ),
              decoration: boxDecoration( lstrSelectedNotAvailable.contains(itemCode)? Colors.green:Colors.white, 5),
            ),
          );
        });
  }
  //=============================================PAGE FN===========================


  fnGetPagedata(){
    fnGetAvailableMenu();
    fnGetNotAvailableMenu();
  }

  fnAddaAvailable(e){
    print(e);
    setState((){
      if(lstrSelectedAvailable.contains(e)){
        lstrSelectedAvailable.remove(e);
      }else{
        lstrSelectedAvailable.add(e);
      }
    });
  }

  fnAddaNotAvailable(e){
    print(e);
    setState((){
      if(lstrSelectedNotAvailable.contains(e)){
        lstrSelectedNotAvailable.remove(e);
      }else{
        lstrSelectedNotAvailable.add(e);
      }
    });
  }

  //==========================================API CALL==============================

    fnGetAvailableMenu(){
    print(txtAvailable.text);
      futureMenu =  apiCall.getAvailableMenu(g.wstrCompany, "Y", txtAvailable.text);
      futureMenu.then((value) => fnGetAvailableMenuSuccess(value));
    }
    fnGetAvailableMenuSuccess(value){
      setState((){
        lstrAvailableItem =  value;
      });

    }

    fnGetNotAvailableMenu(){
      futureMenu =  apiCall.getAvailableMenu(g.wstrCompany, "N", txtNotAvailable.text);
      futureMenu.then((value) => fnGetNotAvailableSuccess(value));
    }
    fnGetNotAvailableSuccess(value){
      if(g.fnValCheck(value)){
        setState((){
          lstrNotAvailableItem =  value;
        });
      }

    }

    fnUpdateMenuNotAvailable(){
      if(!g.fnValCheck(lstrSelectedAvailable)){
        showToast( 'Please select items');
        return;
      }
      var data = [];
      lstrSelectedAvailable.forEach((e) {
        data.add({
          "DISHCODE":e,
          "MENU_YN":"N"
        });
      });

      futureMenu = apiCall.updateMenuAvailable(g.wstrCompany, data);
      futureMenu.then((value) => fnMenuUpdated(value));
    }
    fnUpdateMenuAvailable(){
      if(!g.fnValCheck(lstrSelectedNotAvailable)){
        showToast( 'Please select items');
        return;
      }
      var data = [];
      lstrSelectedNotAvailable.forEach((e) {
        data.add({
          "DISHCODE":e,
          "MENU_YN":"Y"
        });
      });

      futureMenu = apiCall.updateMenuAvailable(g.wstrCompany, data);
      futureMenu.then((value) => fnMenuUpdated(value));
    }
    fnMenuUpdated(value){
      setState((){
        lstrSelectedNotAvailable = [];
        lstrSelectedAvailable = [];
      });
      fnGetPagedata();
    }


}

