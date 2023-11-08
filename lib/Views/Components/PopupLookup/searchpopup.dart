


import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPopup extends StatefulWidget {
  final title;
  final mainKey;
  final searchYn;
  final List<dynamic>  lstrColumnList;
  final List<dynamic>  lstrData;
  final Function  callback;

  const SearchPopup({Key? key, this.title, this.mainKey, this.searchYn, required this.lstrColumnList, required this.lstrData, required this.callback}) : super(key: key);

  @override
  State<SearchPopup> createState() => _SearchPoupState();
}

class _SearchPoupState extends State<SearchPopup> {


  //Global
  var g = Global();

  //Page Variables
  var lstrSearchData = [];
  var lstrColumn = [];

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
          widget.searchYn != "N"?
          Container(
            height: 30,
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: boxOutlineCustom1(Colors.white, 5, Colors.grey, 0.5),
            child: TextFormField(
              autofocus: true,
              controller: txtSearch,
              focusNode: fnSearch,
              style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
              keyboardType: TextInputType.visiblePassword,
              decoration:   InputDecoration(
                hintText: 'Search',
                hintStyle: GoogleFonts.poppins(fontSize: 12),
                border: InputBorder.none,
                suffixIcon: const Icon(Icons.search,color: Colors.blueGrey,size: 15,),
              ),
              onChanged: (value){
                fnSearchData(value);
              },
            ),
          ):gapWC(300),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: wSearchList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  //=====================================WIDGET

    List<Widget> wSearchList(){
      List<Widget> rtnList = [];
      rtnList.add(gapHC(10));
      for(var e in lstrSearchData){
        rtnList.add(Bounce(
          onPressed: (){
            widget.callback(e);
            Navigator.pop(context);
          },
          duration: const Duration(milliseconds: 110),
          child: Container(
            decoration: boxBaseDecoration(greyLight, 5),
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.only(bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: wColumnList(e),
            ),
          ),
        ));
      }
      return rtnList;
    }
    List<Widget> wColumnList(e){
      List<Widget> rtnList = [];
      rtnList.add(Row());
      for(var f in widget.lstrColumnList){
        var value = e[f["COLUMN"]]??"";
        var caption = f["CAPTION"]??"";
        rtnList.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tc(caption, Colors.black , 8),
            tcn(value, Colors.black , 10),
          ],
        ));
      }
      return rtnList;
    }


  //=====================================PAGE FN
    fnGetPageData(){
      if(mounted){
        setState(() {
          lstrSearchData = g.mfnJson(widget.lstrData);
          lstrColumn = g.mfnJson(widget.lstrColumnList);
        });
      }
    }

    fnSearchData(key){

      if(widget.lstrData.isEmpty){
        return;
      }
      if(mounted){
        setState(() {
          lstrSearchData = [];
          var selectedData = g.mfnJson(widget.lstrData);
          if(g.fnValCheck(selectedData)){
            var filterData = [];
            for(var e in selectedData){
              filterData = [];
              for(var f in widget.lstrColumnList){
                if(e[f["COLUMN"]].toString().toLowerCase().contains(key.toString().toLowerCase())){
                  filterData.add(e);
                }
                if(filterData.isNotEmpty){
                  break;
                }
              }
              for(var f in filterData){
                lstrSearchData.add(f);
              }
            }
          }
        });
      }
    }
  //=====================================API CALL
}
