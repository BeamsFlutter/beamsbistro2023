


import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterPopup extends StatefulWidget {
  final title;
  final searchYn;
  final showKey;
  final mainKey;
  final List<dynamic>  lstrColumnList;
  final List<dynamic>  lstrOldData;
  final List<dynamic>  lstrData;
  final Function  callback;

  const FilterPopup({Key? key, this.title, this.searchYn, required this.lstrColumnList, required this.lstrData, required this.callback, this.showKey, this.mainKey, required this.lstrOldData}) : super(key: key);

  @override
  State<FilterPopup> createState() => _FilterPopupState();
}

class _FilterPopupState extends State<FilterPopup> {


  //Global
  var g = Global();

  //Page Variables
  var lstrSearchData = [];
  var lstrColumn = [];
  var flReturnList = [];

  //Controller
  var txtSearch = TextEditingController();
  var fnSearch  =  FocusNode();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(10),
      decoration: boxBaseDecoration(Colors.white, 0),
      child: Column(
        children: [
          Expanded(child: SingleChildScrollView(
            child: Column(
              children: wFilterList(),
            ),
          )),
          GestureDetector(
            onTap: (){
              fnClear();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: boxOutlineCustom1(Colors.white,30,Colors.black.withOpacity(0.5), 1.0),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tcn('Clear', Colors.black, 10),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              fnApply();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: boxBaseDecoration(BgColor, 30),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tcn('Apply', Colors.white, 10),
                ],
              ),
            ),
          )

        ],
      ),
    );
  }

  //=====================================WIDGET

  List<Widget> wFilterList(){
    List<Widget> rtnList  =  [];
    for(var e  in lstrSearchData){
      rtnList.add(
          Bounce(
            onPressed: () {
              if(mounted){
                setState(() {
                  if (flReturnList.contains(e[widget.mainKey])) {
                    flReturnList.remove(e[widget.mainKey]);
                  }else{
                    flReturnList.add(e[widget.mainKey]);
                  }
                });
              }
            },
            duration: const Duration(milliseconds: 110),
            child: Container(
              decoration: boxBaseDecoration(greyLight  , 5),
              margin: const EdgeInsets.only(bottom: 5),
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  Container(
                    height: 15,
                    width: 15,
                    decoration:flReturnList.contains(e[widget.mainKey])? boxDecoration(BgColor, 5): boxOutlineCustom1(Colors.white, 5, BgColor, 1.0),
                    child: flReturnList.contains(e[widget.mainKey])?const Icon(Icons.done,color: Colors.white,size: 10,):gapHC(0),
                  ),
                  gapWC(10),
                  tcn(e[widget.showKey].toString(), Colors.black, 10)
                ],
              ),
            ),
          )
      );
    }

    return rtnList;
  }


  //=====================================PAGE FN
    fnGetPageData(){
      if(mounted){
        setState(() {
          lstrSearchData = g.mfnJson(widget.lstrData)??[];
          flReturnList = g.mfnJson(widget.lstrOldData)??[];
        });
      }
    }

    fnApply(){
      widget.callback(flReturnList);
      Navigator.pop(context);
    }
    fnClear(){
      flReturnList = [];
      widget.callback(flReturnList);
      Navigator.pop(context);
    }

  //=====================================API CALL
}
