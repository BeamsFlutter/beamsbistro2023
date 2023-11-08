

import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'common.dart';

class TableController extends StatefulWidget {

  final double chair;
  final String name;
  final String mode;
  final double oChair;

  //chair,name,mode,oChair
  const TableController({Key? key, required this.chair, required this.name, required this.mode, required this.oChair}) : super(key: key);

  @override
  _TableControllerState createState() => _TableControllerState();
}

class _TableControllerState extends State<TableController> {

  var cardType ='';
  var name = '';
  var mode ='';
  var oChair = 0.0;
  var chair = 0.0;

  var cardHeight = 0.0;
  var cardWidth = 0.0;
  var cardInHeight = 0.0;
  var cardInWidth = 0.0;
  var cardRadius = 0.0;



  @override
  void initState() {
    // TODO: implement initState
    cardType ='';
    name = widget.name;
    mode = widget.mode;
    oChair = widget.oChair == null ? 0.0 : widget.oChair;
    chair =  widget.chair == null ? 0.0 : widget.chair;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Row(
        children: [
          chair == 4 ? fnChairR(fnGetChairStatus(3,oChair)) :Container(),
          Column(
            children: [
              fnChairC(fnGetChairStatus(1,oChair)),
              Container(
                  height: 130,
                  width: 130,
                  decoration: boxBaseDecoration(fnGetModeLightColor(chair,oChair,mode), 200),
                  child: Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: boxBaseDecoration(fnGetModeColor(chair,oChair,mode), 200),
                      child: Center(
                        child:  Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            tc(name,Colors.white,20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.people,color: Colors.white,size: 15,),
                                gapWC(2),
                                tc('3',Colors.white,12)
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
              ),
              fnChairC(fnGetChairStatus(2,oChair)),
            ],
          ),
          chair == 4 ? fnChairR(fnGetChairStatus(4,oChair)) :Container(),
        ],
      ),
    );
  }

  //Get Colors
  fnGetModeColor(chair,oChair,res){

    var mode = '';
    if(res == 'R'){
      mode = 'R';
    }else{
      oChair == chair ? mode = 'F' : oChair == 0 ? mode = 'E' :  mode = 'C';
    }


    Color modeColor= emptyTable;

    if(mode == 'F'){
      modeColor= fullTable;
    }else if (mode == 'C'){
      modeColor= freeTable;
    }else if (mode == 'R'){
      modeColor= reservedTable;
    }

    return modeColor;
  }
  fnGetModeLightColor(chair,oChair,res){

    var mode = '';
    if(res == 'R'){
      mode = 'R';
    }else{
      oChair == chair ? mode = 'F' : oChair == 0 ? mode = 'E' :  mode = 'C';
    }

    Color modeColor= emptyTableLight;
    if(mode == 'F'){
      modeColor= fullTableLight;
    }else if (mode == 'C'){
      modeColor= freeTableLight;
    }else if (mode == 'R'){
      modeColor= reservedTableLight;
    }

    return modeColor;
  }
  fnGetModeChairColor(mode){
    Color modeColor= freeChair;
    if(mode == 'O'){
      modeColor= activeChair;
    }

    return modeColor;
  }
  fnGetChairStatus(chair,oChair){
    var sts = 'F';
    if(chair <= oChair){
      sts = 'O' ;
    }
    return sts;
  }

  //Chair build
  Container fnChairC(mode) => Container(
    height: 20,
    width: 30,
    margin: EdgeInsets.all(5),
    decoration: boxDecoration(getModeChairColor(mode), 5),
  );
  Container fnChairR(mode) => Container(
    height: 30,
    width: 20,
    margin:  EdgeInsets.all(5),
    decoration: boxDecoration(getModeChairColor(mode), 5),
  );

  //Other Functions
  fnGetSizes(mode){
    setState(() {
      if(mode=='R'){
        cardHeight = 0;
        cardWidth = 0;
        cardInHeight = 0;
        cardInWidth = 0;
        cardRadius = 0;
      }else if(mode=='S'){
        cardHeight = 0;
        cardWidth = 0;
        cardInHeight = 0;
        cardInWidth = 0;
        cardRadius = 0;
      }else if(mode == 'L'){
        cardHeight = 0;
        cardWidth = 0;
        cardInHeight = 0;
        cardInWidth = 0;
        cardRadius = 0;
      }
    });
  }

}
