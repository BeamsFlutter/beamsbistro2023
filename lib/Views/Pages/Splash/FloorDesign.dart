

import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Pages/Splash/MovableLong.dart';
import 'package:beamsbistro/Views/Pages/Splash/MovableLong.dart';
import 'package:beamsbistro/Views/Pages/Splash/MovableLong.dart';
import 'package:flutter/material.dart';

import 'Movable.dart';
import 'MovableRound.dart';

class FloorDesign extends StatefulWidget {
  const FloorDesign({Key? key}) : super(key: key);

  @override
  State<FloorDesign> createState() => _FloorDesignState();
}



class _FloorDesignState extends State<FloorDesign> {
  List<Widget> movableItems = [];
  List<Widget> movableItemsView = [];
  List<dynamic> movableItemsList = [];
  var editMode = true;


  @override
  void initState() {
    movableItems.add(MoveableStackItem(mode: editMode, id: 1,x: 0.0,y: 0.0,fnCallBack: fnCallBack,));
    movableItems.add(MoveableStackItem(mode: editMode, id: 2,x: 0.0,y: 0.0,fnCallBack: fnCallBack,));
    // movableItems.add(MoveableStackItemRound());
    movableItems.add(MoveableStackItem(mode: editMode, id: 3,x: 0.0,y: 0.0,fnCallBack: fnCallBack,));
    // movableItems.add(MoveableStackItemRound());
    movableItems.add(MoveableStackItem(mode: editMode, id: 4,x: 0.0,y: 0.0,fnCallBack: fnCallBack,));
    // movableItems.add(MoveableStackItemRound());
    // movableItems.add(MoveableStackItemLong());
    // movableItems.add(MoveableStackItemLong());
    // movableItems.add(MoveableStackItemLong());

    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Expanded(child: Stack(
              children: movableItems,
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    fnView();
                  },
                  child: tc('PRINT      ', Colors.black, 20),
                ),
                tc('VIEW       ', Colors.black, 20),
              ],
            ),
            gapHC(10),
          ],
        ));
  }

  fnGetPageData(){
    var idno = 0;
    for(var e in movableItems){
      movableItemsList.add({
        "ID":idno+1,
        "X":0.0,
        "Y":0.0,
      });
      idno = idno +1;
    }

  }
  fnCallBack(x,y,id){
    for(var e in movableItemsList){
      if(e["ID"] ==  id){
        e["X"] =  x;
        e["Y"] =  y;
      }
    }
  }


  fnView(){

   setState(() {
     movableItems = [];
     editMode = editMode?false:true;
     movableItems.add(MoveableStackItem(mode: editMode, id: 1,x:fnGetXY(1,"X"),y:fnGetXY(1,"Y"),fnCallBack: fnCallBack,));
     movableItems.add(MoveableStackItem(mode: editMode, id: 2,x:fnGetXY(2,"X"),y:fnGetXY(2,"Y"),fnCallBack: fnCallBack,));
     movableItems.add(MoveableStackItem(mode: editMode, id: 3,x:fnGetXY(3,"X"),y:fnGetXY(3,"Y"),fnCallBack: fnCallBack,));
     movableItems.add(MoveableStackItem(mode: editMode, id: 4,x:fnGetXY(4,"X"),y:fnGetXY(4,"Y"),fnCallBack: fnCallBack,));
   });
  }
  fnGetXY(id,mode){
    var data  ;
    for(var e in movableItemsList){
      if(e["ID"] ==  id){
        data =e;
      }
    }
    if(data != null){
      if(mode =="X"){
        return data["X"];
      }else{
        return data["Y"];
      }
    }else{
      return 0.0;
    }
  }

  fnPrint(){

  }

}
