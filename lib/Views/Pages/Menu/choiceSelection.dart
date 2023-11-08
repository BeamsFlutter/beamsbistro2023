

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:oktoast/oktoast.dart';

class Choices extends StatefulWidget {

  final lstrItemDataList;
  final lstrChoiceList;
  final oldData;
  final Function  fnCallBack;
  final  String choiceCode ;

  const Choices({Key? key, this.lstrChoiceList, required this.fnCallBack, required this.choiceCode, this.lstrItemDataList, this.oldData}) : super(key: key);

  @override
  State<Choices> createState() => _ChoicesState();
}

class _ChoicesState extends State<Choices> {


  Global g = Global();
  var  RST_CHOICE_MAST =[];
  var  RST_CHOICE_DET =[];
  var  RST_CHOICE_LEVEL =[];
  var  lstrChoiceLevels =[];
  var lstrCreatedChoices = [];
  var lstrSelectedChoiceList= [];
  var lstrSelectedDetList= [];

  var _radioValue = '00' ;
  var _radioValueChild = '00' ;

  var lstrItemName  = '';
  var lstrSelectedChoice  = 1;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }
  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: size.width*0.35,
            decoration: boxDecoration(Colors.white,10),
            child: Column(
              children: [
               Container(
                 padding: EdgeInsets.all(10),
                 //decoration: boxBaseDecoration(Colors.white, 5),
                 child: Row(
                   children: [
                     Icon(Icons.food_bank_outlined,size: 18,),
                     gapWC(10),
                     Expanded(child: tc(lstrItemName,Colors.black,16))
                   ],
                 ),
               ),
                gapHC(5),
                lineC(0.3, Colors.black),
                gapHC(10),
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    children: fnGetSlectedChoice(),
                  ),
                )),
               lineC(0.3, Colors.black),
               gapHC(5),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   tc('QTY', Colors.black, 17),
                   tc(fnTotalQty(), Colors.black, 17),
                 ],
               ),
                gapHC(5),
               lineC(0.3, Colors.black),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Bounce(child:
                   Container(
                     width: size.width*0.06,
                     margin: EdgeInsets.all(5),
                     padding: EdgeInsets.all(10),
                     decoration: boxDecoration(Colors.white, 50),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         // tcn('', Colors.green, 15),
                         // gapWC(5),
                         Icon(Icons.add_circle_outline,color: Colors.black,size: 17,)
                       ],
                     ),
                   ), duration
                       : Duration(milliseconds: 110),
                       onPressed: (){
                     fnAddChoiceList();
                   }),

                   Expanded(child: GestureDetector(
                     child: Container(
                       margin: EdgeInsets.all(5),
                       padding: EdgeInsets.all(10),
                       decoration: boxDecoration(Colors.green, 50),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           tc('DONE', Colors.white, 15),
                         ],
                       ),
                     ),
                     onTap: (){
                       fnDone();
                     },

                   ))
                 ],
               )
              ],
            ),

          ),
          gapWC(20),
          Expanded(child:
          Container(
            height: 600,
            padding: EdgeInsets.all(10),
            child:SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: fnGetOptionList(),
              ),
            ),
          ),),


        ],

      ),
    );
  }

  //=============================WIDGET=========================================

  fnGetOptionList(){
    List<Widget> options = [];
    var srno = 0;
    lstrChoiceLevels.forEach((e) {
      options.add(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              gapHC(10),
              lineC(0.1, Colors.black),
              gapHC(5),
              Container(

                child: tc( (srno+1).toString()+". "+ e["OPTIONS"].toString(), PrimaryColor, 15),
              ),
              gapHC(5),
              lineC(0.1, Colors.black),
              gapHC(10),
              Column(
                children:
                  fnGetParentData(e["LINE_SRNO"],e["MULTIPLE_YN"])
                ,
              )
            ],
          )
      );
      srno =srno+1;
    });
    return options;
  }
  fnGetParentData(lineSrno,multipleYn){
    List<Widget> options = [];
    var srno = 0;

    var parentData = g.mfnJson(RST_CHOICE_DET);
    parentData.retainWhere((i){
      return i["MAIN_LINE_SRNO"] == lineSrno && i["PARENT_SRNO"] == 0 ;
    });
    parentData.forEach((e) {

      options.add(

          GestureDetector(
            onTap: (){
              setState((){

                _radioValue = e["SRNO"].toString();
                _radioValueChild = '';

              });
              if(multipleYn == "Y"){

                fnChoiceCheckBox(lineSrno,e);
              }else{
                fnAddChoice(lineSrno,e);
              }
            },
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: boxBaseDecoration(redLight.withOpacity(0.5), 10),
              margin: EdgeInsets.only(bottom: 5),
              child: Column(
                children: [
                  Row(
                    children: [
                      Transform.scale(scale: 0.9,
                        child: multipleYn == "Y"?
                        Checkbox(
                               activeColor: Colors.green,
                               value: fnCheckSelectedChoice(lineSrno, e["SRNO"]),
                               onChanged: (value) {
                                 fnChoiceCheckBox(lineSrno,e);
                               }):
                        Radio(
                          value: e["SRNO"].toString(),
                          groupValue: fnCheckRadioValue(lineSrno),
                          onChanged: (value){

                            setState((){
                              _radioValue = value.toString();
                              _radioValueChild = '';
                            });
                            fnAddChoice(lineSrno,e);

                          },
                        ),
                      ),
                      
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            tcn(e["DESCP"]??"",Colors.black,14),
                            gapWC(10),
                            th((e["PRICE"]??"").toString(),Colors.black,14),
                          ],
                        ),
                      ),
                      gapWC(10),
                    ],
                  ),
                  fnCheckSelectedChoice(lineSrno,e["SRNO"])?
                  Container(
                    child: Row(
                      children: [
                        gapWC(30),
                        Expanded(child: Row(
                          children: fnGetChild(lineSrno,e["LINE_SRNO"],e["MULTIPLE_YN"]),
                        ))
                      ],
                    ),
                  ):gapHC(0),
                  gapHC(10),

                ],
              ),
            ),
          ),

      );
      srno =srno+1;
    });
    return options;
  }
  fnGetChild(lineSrno,parentSrno,multipleYn){
    List<Widget> options = [];
    var childData = g.mfnJson(RST_CHOICE_DET);
    childData.retainWhere((i){
      return i["MAIN_LINE_SRNO"] == lineSrno && i["PARENT_SRNO"] == parentSrno ;
    });
    childData.forEach((e) {
      options.add(
        Container(
          decoration: boxDecoration(Colors.white, 10),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(5),
          width: 230,
          child: Column(
            children: [
              Row(
                children: [
                  Transform.scale(scale: 0.8,
                    child:multipleYn == "Y"?
                    Checkbox(
                        activeColor: Colors.green,
                        value:fnCheckSelectedChildChoice(lineSrno,e["SRNO"],parentSrno),
                        onChanged: (value) {
                          fnChoiceChildCheckBox(lineSrno,e,parentSrno);
                        }):
                    Radio(
                      value: e["SRNO"].toString(),
                      groupValue: fnCheckChildRadioValue(lineSrno,parentSrno),
                      onChanged: (value){
                        //fnKitchenRadioClick(kitchenCode,KitchenDescp,index);
                        setState((){
                          _radioValueChild = value.toString();
                          fnAddChildChoice(lineSrno,parentSrno,e);
                        });

                      },
                    ),
                  ),
                  Expanded(child: GestureDetector(
                    onTap: (){
                      setState((){
                        if(multipleYn == "Y"){
                          fnChoiceChildCheckBox(lineSrno,e,parentSrno);
                        }else{
                          fnAddChildChoice(lineSrno,parentSrno,e);
                        }

                        _radioValueChild = e["SRNO"].toString();
                      });

                    },
                    child: tcn((e["DESCP"]??"")+"  @ "+e["PRICE"].toString(),Colors.black,13),
                  )),
                  gapWC(10),
                ],
              ),

            ],
          ),
        ),

      );
    });

    return options;
  }

  fnGetSlectedChoice(){
    List<Widget> choices = [];
    lstrCreatedChoices.forEach((e) {
      choices.add(
        GestureDetector(
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: boxBaseDecoration(lstrSelectedChoice == e["SRNO"]? blueLight: Colors.white, 10),
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           tcn("CHOICE  "+e["SRNO"].toString(), Colors.black, 15),
                           tcn('x QTY '+e["QTY"].toString(), PrimaryColor, 12)
                         ]
                       ),
                      Row(
                        children: [
                          GestureDetector(
                            child: Bounce(
                                child:  Container(
                                  width: 40,
                                  height: 30,
                                  padding: EdgeInsets.all(5),
                                  decoration: boxGradientDecorationBase(16, 5),
                                  child: Center(
                                    child: Icon(Icons.remove_circle_outline,color: Colors.white,size: 15,),
                                  ),
                                ),
                                duration: Duration(milliseconds: 110),
                                onPressed: (){
                                  setState((){
                                    if(e["QTY"]>1){
                                      e["QTY"] =e["QTY"]-1;
                                    }

                                  });
                                }),
                            onLongPress: (){
                              setState((){
                                if(e["QTY"]>1){
                                  e["QTY"] =1;
                                }

                              });
                            },

                          ),

                          gapWC(5),
                          tc(e["QTY"].toString(),Colors.black, 15),
                          gapWC(5),
                          Bounce(child: Container(
                            width: 40,
                            height: 30,
                            padding: EdgeInsets.all(5),
                            decoration: boxGradientDecorationBase(16, 5),
                            child: Center(
                              child: Icon(Icons.add_circle_outline,color: Colors.white,size: 15,),
                            ),
                          ),
                          duration: Duration(milliseconds: 110),
                          onPressed: (){
                            setState((){
                              e["QTY"] =e["QTY"]+1;
                            });
                          }),
                          gapWC(5),
                          Bounce(
                            child: Container(
                              width: 30,
                              height: 30,
                              padding: EdgeInsets.all(5),
                              decoration: boxDecoration(Colors.white, 5),
                              child: Center(
                                child: Icon(Icons.delete_sweep_outlined,color: Colors.black,size: 15,),
                              ),
                            ),
                            duration: Duration(milliseconds: 110),
                            onPressed: (){
                              fnRemoveChoiceList(e);

                            },
                          )
                        ],
                      )
                    ],
                  ),
                  gapHC(5),

                ],
              ),
            ),
            onTap: (){
              setState((){
                lstrSelectedChoice = e["SRNO"];
              });
            })
      );
    });

    return  choices;
  }

  fnAddChoice(lineSrno,e){

   setState((){
     if(g.fnValCheck(lstrSelectedChoiceList)){
       var checkData = g.mfnJson(lstrSelectedChoiceList);
       checkData.retainWhere((i){
         return i["MAIN_LINE_SRNO"] == lineSrno && i["CHOICE_SRNO"] == lstrSelectedChoice ;
       });

       if(g.fnValCheck(checkData)){
         var stsVal = 0;
         var removeData;
         for (var f in lstrSelectedChoiceList){
           if(f["MAIN_LINE_SRNO"] == lineSrno && f["CHOICE_SRNO"] == lstrSelectedChoice){
             stsVal =1;
             removeData = f;
           }
         }
         if(stsVal == 1){
           lstrSelectedChoiceList.remove(removeData);
         }
       }

       lstrSelectedChoiceList.add({
         "CHOICE_SRNO":lstrSelectedChoice,
         "MAIN_LINE_SRNO":lineSrno,
         "SRNO": e["SRNO"],
         "PARENT_SRNO": 0
       });

     }else{
       lstrSelectedChoiceList.add({
         "CHOICE_SRNO":lstrSelectedChoice,
         "MAIN_LINE_SRNO":lineSrno,
         "SRNO": e["SRNO"],
         "PARENT_SRNO": 0
       });
     }

     if(g.fnValCheck(lstrSelectedDetList)){
       var stsVal = 0;
       var removeData ;
       for (var f in lstrSelectedDetList) {
         if (f["MAIN_LINE_SRNO"] == lineSrno && f["CHOICE_SRNO"] == lstrSelectedChoice) {
           stsVal = 1;
           removeData = f;
         }
       }
       if (stsVal == 1) {
         lstrSelectedDetList.remove(removeData);
       }
     }

   });
  }
  fnRemoveChoice(){

  }
  fnCheckSelectedChoice(mainSrno,srno){
    var sts = false;
    if(g.fnValCheck(lstrSelectedChoiceList)){
      var checkData = g.mfnJson(lstrSelectedChoiceList);
      checkData.retainWhere((i){
        return i["MAIN_LINE_SRNO"] == mainSrno && i["SRNO"] == srno && i["CHOICE_SRNO"] == lstrSelectedChoice;
      });
      if(g.fnValCheck(checkData)){
        sts = true;
      }
    }

    return sts;
  }
  fnCheckRadioValue(mainSrno){
    var radioValue = '0';
    if(g.fnValCheck(lstrSelectedChoiceList)){
      var checkData = g.mfnJson(lstrSelectedChoiceList);
      checkData.retainWhere((i){
        return i["MAIN_LINE_SRNO"] == mainSrno && i["CHOICE_SRNO"] == lstrSelectedChoice ;
      });
      if(g.fnValCheck(checkData)){
        radioValue = checkData[0]["SRNO"].toString();
      }
    }

    return radioValue;
  }

  //checkbox
  fnChoiceCheckBox(lineSrno,e){
    var value = fnCheckSelectedChoice(lineSrno, e["SRNO"]);
    setState((){
      if(value){
        var stsVal = 0;
        var removeData;
        for (var f in lstrSelectedChoiceList){
          if(f["MAIN_LINE_SRNO"] == lineSrno && f["CHOICE_SRNO"] == lstrSelectedChoice && f["SRNO"] == e["SRNO"]){
            stsVal =1;
            removeData = f;
          }
        }
        if(stsVal == 1){
          lstrSelectedChoiceList.remove(removeData);
        }
      }else{
        lstrSelectedChoiceList.add({
          "CHOICE_SRNO":lstrSelectedChoice,
          "MAIN_LINE_SRNO":lineSrno,
          "SRNO": e["SRNO"],
          "PARENT_SRNO": 0
        });
      }
    });
  }
  fnChoiceChildCheckBox(lineSrno,e,parentSrno){
    var value = fnCheckSelectedChildChoice(lineSrno,e["SRNO"],parentSrno);
    setState((){
      if(value){
        var stsVal = 0;
        var removeData;
        for (var f in lstrSelectedDetList){
          if(f["MAIN_LINE_SRNO"] == lineSrno && f["CHOICE_SRNO"] == lstrSelectedChoice && f["SRNO"] == e["SRNO"]){
            stsVal =1;
            removeData = f;
          }
        }
        if(stsVal == 1){
          lstrSelectedDetList.remove(removeData);
        }
      }else{
        lstrSelectedDetList.add({
          "CHOICE_SRNO":lstrSelectedChoice,
          "MAIN_LINE_SRNO":lineSrno,
          "SRNO": e["SRNO"],
          "PARENT_SRNO": parentSrno
        });
      }
    });
  }

  //child
  fnAddChildChoice(lineSrno,parentSrno,e){
    // lstrSelectedDetList

    setState(() {
      if (g.fnValCheck(lstrSelectedDetList)) {
        var checkData = g.mfnJson(lstrSelectedDetList);
        checkData.retainWhere((i) {
          return i["MAIN_LINE_SRNO"] == lineSrno && i["CHOICE_SRNO"] == lstrSelectedChoice;
        });

        if (g.fnValCheck(checkData)) {
          var stsVal = 0;
          var removeData;
          for (var f in lstrSelectedDetList) {
            if (f["MAIN_LINE_SRNO"] == lineSrno && f["CHOICE_SRNO"] == lstrSelectedChoice) {
              stsVal = 1;
              removeData = f;
            }
          }
          if (stsVal == 1) {
            lstrSelectedDetList.remove(removeData);
          }


        }

        lstrSelectedDetList.add({
          "CHOICE_SRNO":lstrSelectedChoice,
          "MAIN_LINE_SRNO": lineSrno,
          "SRNO": e["SRNO"],
          "PARENT_SRNO": parentSrno
        });
      } else {
        lstrSelectedDetList.add({
          "CHOICE_SRNO":lstrSelectedChoice,
          "MAIN_LINE_SRNO": lineSrno,
          "SRNO": e["SRNO"],
          "PARENT_SRNO": parentSrno
        });
      }
    });

  }
  fnCheckSelectedChildChoice(mainSrno,srno,parentSrno){
    var sts = false;
    if(g.fnValCheck(lstrSelectedDetList)){
      var checkData = g.mfnJson(lstrSelectedDetList);
      checkData.retainWhere((i){
        return i["MAIN_LINE_SRNO"] == mainSrno && i["PARENT_SRNO"] == parentSrno && i["SRNO"] == srno && i["CHOICE_SRNO"] == lstrSelectedChoice;
      });
      if(g.fnValCheck(checkData)){
        sts = true;
      }
    }

    return sts;
  }
  fnCheckChildRadioValue(mainSrno,parentSrno){
    var radioValue = '0';
    if(g.fnValCheck(lstrSelectedDetList)){
      var checkData = g.mfnJson(lstrSelectedDetList);
      checkData.retainWhere((i){
        return i["MAIN_LINE_SRNO"] == mainSrno &&  i["PARENT_SRNO"] == parentSrno && i["CHOICE_SRNO"] == lstrSelectedChoice;
      });
      if(g.fnValCheck(checkData)){
        radioValue = checkData[0]["SRNO"].toString();
      }
    }

    return radioValue;
  }

  //=======================PAGE FUN===============================================

  fnGetPageData(){
    var value  =  widget.lstrChoiceList;
    setState(() {
      RST_CHOICE_MAST = value["Table1"];
      RST_CHOICE_DET= value["Table3"];
      RST_CHOICE_LEVEL= value["Table2"];

      lstrChoiceLevels = [];
      lstrCreatedChoices = [];


      for (var e in RST_CHOICE_LEVEL){
        if(fnParentCheck(e["LINE_SRNO"])){
          lstrChoiceLevels.add(e);
        }
      }

      lstrItemName = widget.lstrItemDataList["DISHDESCP"];

      if (g.fnValCheck(widget.oldData)){
        var choiceSrno = 0;
        // widget.oldData.sort((a, b) => a["CHOICE_SRNO"].compareTo(b["CHOICE_SRNO"]));
        for (var e in widget.oldData) {
          if (choiceSrno != e["CHOICE_SRNO"]) {
            choiceSrno = e["CHOICE_SRNO"];
            lstrCreatedChoices.add({
              'SRNO': choiceSrno,
              "CHOICE_CODE": widget.choiceCode,
              "CHOICE_DESCP": "",
              "DISHCODE": widget.lstrItemDataList["DISHCODE"],
              "DISHDESCP": widget.lstrItemDataList["DISHDESCP"],
              "CHOICE": [],
              "QTY": e["CHOICE_QTY"],
            });
            fnOldDataAdd(e,choiceSrno);
          } else {
            fnOldDataAdd(e,choiceSrno);
          }
        }

       }
        else{
        lstrCreatedChoices.add({
          'SRNO':1,
          "CHOICE_CODE":widget.choiceCode,
          "CHOICE_DESCP":"",
          "DISHCODE":widget.lstrItemDataList["DISHCODE"],
          "DISHDESCP":widget.lstrItemDataList["DISHDESCP"],
          "CHOICE":[],
          "QTY":1,
        });
      }
    });
  }
  fnOldDataAdd(e,choiceSrno){
    if (e["PARENT_SRNO"] == 0) {
      lstrSelectedChoiceList.add({
        "CHOICE_SRNO": choiceSrno,
        "MAIN_LINE_SRNO": e["MAIN_LINE_SRNO"],
        "SRNO": e["SRNO"],
        "PARENT_SRNO": e["PARENT_SRNO"]
      });
    }
    else {
      lstrSelectedDetList.add({
        "CHOICE_SRNO": choiceSrno,
        "MAIN_LINE_SRNO": e["MAIN_LINE_SRNO"],
        "SRNO": e["SRNO"],
        "PARENT_SRNO": e["PARENT_SRNO"]
      });
      var itemData = g.mfnJson(RST_CHOICE_DET);
      itemData.retainWhere((i){
        return i["MAIN_LINE_SRNO"] ==  e["MAIN_LINE_SRNO"] && i["LINE_SRNO"] == e["PARENT_SRNO"];
      });
      var parentData = g.mfnJson(lstrSelectedChoiceList);
      parentData.retainWhere((i){
        return i["SRNO"] ==  itemData[0]["SRNO"] && i["CHOICE_SRNO"] == choiceSrno;
      });
      if(!g.fnValCheck(parentData)){
        lstrSelectedChoiceList.add({
          "CHOICE_SRNO": choiceSrno,
          "MAIN_LINE_SRNO": e["MAIN_LINE_SRNO"],
          "SRNO": itemData[0]["SRNO"],
          "PARENT_SRNO": 0
        });
      }
    }
  }
  bool fnParentCheck(lineSrno){
    var sts = false;
    var parentData = g.mfnJson(RST_CHOICE_DET);
    parentData.retainWhere((i){
      return i["MAIN_LINE_SRNO"] == lineSrno && i["PARENT_SRNO"] == 0 ;
    });

    if(g.fnValCheck(parentData)){
      sts = true;
    }

    return sts;
  }
  fnUpdateChoiceDescp(){
    //choice wise desp updation

  }
  fnAddChoiceList(){

    if(fnCheckAllChoiceSelected()){
      var srno = 0 ;
      for (var e in lstrCreatedChoices){
        srno =  e["SRNO"];
      }
      setState((){
        lstrCreatedChoices.add({
          'SRNO':srno+1,
          "CHOICE_CODE":widget.choiceCode,
          "CHOICE_DESCP":"",
          "DISHCODE":widget.lstrItemDataList["DISHCODE"],
          "DISHDESCP":widget.lstrItemDataList["DISHDESCP"],
          "CHOICE":[],
          "QTY":1,

        });
        lstrSelectedChoice = srno+1;
      });
    }


  }
  fnRemoveChoiceList(e){

    if(lstrCreatedChoices.length > 1){
      setState((){
        lstrCreatedChoices.remove(e);
        if(g.fnValCheck(lstrSelectedChoiceList)){
          var temp = [];
          for(var f in lstrSelectedChoiceList){
            if(f["CHOICE_SRNO"] !=  e["SRNO"]){
              temp.add(f);
            }
          }
          lstrSelectedChoiceList =temp;
        }
        if(g.fnValCheck(lstrSelectedDetList)){
          var temp1 = [];
          for(var f in lstrSelectedDetList){
            if(f["CHOICE_SRNO"] !=  e["SRNO"]){
              temp1.add(f);
            }
          }
          lstrSelectedDetList =temp1;
        }

        var srno = 0;
        // for(var f in lstrCreatedChoices){
        //   f["SRNO"] = srno+1;
        //   srno++;
        // }


      });



    }else{
      showToast( 'Must need one choice');
    }

  }
  fnTotalQty(){
    var qty = 0.0;
    setState((){
      for (var e in lstrCreatedChoices){
        qty = qty +e["QTY"] ;
      }
    });
    return qty.toStringAsFixed(0);
  }


  fnCheckAllChoiceSelected(){
    var sts =true;
    if(g.fnValCheck(lstrSelectedChoiceList)){
      for(var m in lstrCreatedChoices){
        for(var e in lstrChoiceLevels){

          var lineSrno =  e["LINE_SRNO"];
          var parentData = g.mfnJson(lstrSelectedChoiceList);
          parentData.retainWhere((i){
            return i["MAIN_LINE_SRNO"] == lineSrno && i["CHOICE_SRNO"] == m["SRNO"] ;
          });
          if(!g.fnValCheck(parentData)){
            sts =false;
          }
           // if(sts){
           //   var childData = g.mfnJson(RST_CHOICE_DET);
           //   childData.retainWhere((i){
           //     return i["MAIN_LINE_SRNO"] == lineSrno && i["PARENT_SRNO"] == 0 && i["ITEM_CHOICE"] == "C";
           //   });
           //
           //   for (var f in childData){
           //     var childDet = g.mfnJson(lstrSelectedChoiceList);
           //     childDet.retainWhere((i){
           //       return i["MAIN_LINE_SRNO"] == lineSrno && i["PARENT_SRNO"] == f["LINE_SRNO"] &&  i["CHOICE_SRNO"] == m["SRNO"] ;
           //     });
           //     if(!g.fnValCheck(childDet)){
           //       sts = false;
           //     }
           //   }
           // }

        }
      }

    }else{
      sts = false;
    }

    return sts;
  }
  fnDone(){
    var HeaderData = [];
    var ItemDetails = [];

    if(!fnCheckAllChoiceSelected()){
      showToast( 'Please select all options');
      return;
    }

    HeaderData.add(
      {
        "CHOICE_CODE":widget.choiceCode,
        "DISHCODE":widget.lstrItemDataList["DISHCODE"],
        "DISHDESCP":widget.lstrItemDataList["DISHDESCP"],
        "TOTAL_QTY": fnTotalQty(),
        "TOTAL_PRICE": 0.0,
      }
    );
    var choiceItemsList  = [];
    for(var e in lstrSelectedChoiceList){
      var itemtData = g.mfnJson(RST_CHOICE_DET);
      itemtData.retainWhere((i){
        return i["SRNO"] == e["SRNO"]  ;
      });
      if(itemtData[0]["ITEM_CHOICE"] != "C"){
        choiceItemsList.add(e);
      }

    }
    for(var e in lstrSelectedDetList){
      choiceItemsList.add(e);
    }
    for(var e in choiceItemsList){
      var itemtData = g.mfnJson(RST_CHOICE_DET);
      itemtData.retainWhere((i){
        return i["SRNO"] == e["SRNO"]  ;
      });

      var choiceData = g.mfnJson(lstrCreatedChoices);
      choiceData.retainWhere((i){
        return i["SRNO"] == e["CHOICE_SRNO"]  ;
      });
      ItemDetails.add({
        "CHOICE_CODE":widget.choiceCode,
        "DISHCODE":widget.lstrItemDataList["DISHCODE"],
        "DISHDESCP":widget.lstrItemDataList["DISHDESCP"],
        "CHOICE_SRNO":e["CHOICE_SRNO"],
        "MAIN_LINE_SRNO":e["MAIN_LINE_SRNO"],
        "PARENT_SRNO":e["PARENT_SRNO"],
        "CHOICE_ITEM":itemtData[0]["ITEM_CHOICE_CODE"],
        "CHOICE_ITEMDESCP":itemtData[0]["DESCP"],
        "CHOICE_QTY":choiceData[0]["QTY"],
        "SRNO":itemtData[0]["SRNO"],
        "PRICE":g.mfnDbl(itemtData[0]["PRICE"]),
      });
    }
    ItemDetails.sort((a, b) => a["CHOICE_SRNO"].compareTo(b["CHOICE_SRNO"]));

    var price = 0.0;
    for (var e in ItemDetails){
      var p =  g.mfnDbl(e["PRICE"])*e["CHOICE_QTY"];
      price = price +p ;
    }

    HeaderData[0]["TOTAL_PRICE"] = (price/g.mfnDbl(HeaderData[0]["TOTAL_QTY"]))+widget.lstrItemDataList["PRICE1"];


    widget.fnCallBack(HeaderData,ItemDetails,widget.lstrItemDataList);

  }

}
