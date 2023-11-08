


import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:google_fonts/google_fonts.dart';

class Lookup extends StatefulWidget {

  final title;
  final mode;
  final source;
  final TextEditingController  txtControl;
  final selectColumns;
  final keyColumn;
  final fillDataTo;
  final String  oldValue;
  final String  searchYn;
  final Function  callback;
  final String  layoutName;
  final lstrColumns;
  final lstrTable;
  final lstrPage;
  final lstrPageSize;
  final List<dynamic> ? lstrFilter;
  final List<dynamic>  lstrColumnList;
  final FocusNode ? focusNode;
  final List<dynamic>  lstrFilldata;
  Lookup({Key ?key, this.title, this.source, required this.txtControl, this.selectColumns, this.keyColumn, this.fillDataTo, required this.oldValue, required this.callback, required this.layoutName, this.lstrColumns, this.lstrTable, this.lstrPage, this.lstrPageSize, this.lstrFilter, required this.lstrColumnList, this.focusNode, required this.lstrFilldata, this.mode, required this.searchYn}) : super(key: key);




  @override
  _LookupState createState() => _LookupState();
}
enum Menu { itemOne, itemTwo, itemThree, itemFour }
class _LookupState extends State<Lookup> {

  late Future<dynamic> lstrFutureLookup;
  late Future<dynamic> lstrFutureLookupValidate;
  late List<Map<String, dynamic >> lookupFilterVal ;
  var  apiCall = ApiCall();
  var g = Global();

  late Function fnCallback;
  String keyColumn = "";
  String lstrOldvalue = "" ;
  String lstrSearchval = "";
  String lstrLayoutName = "";
  var txSearchControl = TextEditingController();
  var txtControl = TextEditingController();
  var columnList;
  var lstrSelectedDataList;
  var pageData = [];

  late FocusNode focusNode;

  @override
  void dispose() {
    // TODO: implement dispose
    txSearchControl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fnSortColumns();
    fnCallback = widget.callback;
    txtControl = widget.txtControl;
    lstrOldvalue = widget.oldValue;
    lstrSearchval = lstrOldvalue;
    lstrLayoutName  = widget.layoutName;
    txSearchControl.text = lstrOldvalue.toString();
    keyColumn = widget.keyColumn;
    lookupFilterVal = [{'Column': keyColumn, 'Operator': '=', 'Value': lstrSearchval, 'JoinType': 'AND'}];
    //fnLookupValidate(widget.lstrTable, lookupFilterVal);

    lstrFutureLookup = apiCall.LookupSearch(widget.lstrTable, columnList, widget.lstrPage, widget.lstrPageSize, widget.lstrFilter);
    lstrFutureLookup.then((value) => fnLookupSearchSuccess(value));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Container(
        height: 300,
        padding: const EdgeInsets.all(10),
        decoration: boxBaseDecoration(Colors.white, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.searchYn != "N"?
            Container(
              height: 30,
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: boxOutlineCustom1(Colors.white, 5, Colors.grey, 0.5),
              child: TextFormField(
                autofocus: true,
                controller: txSearchControl,
                style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.w500),
                keyboardType: TextInputType.visiblePassword,
                decoration:   InputDecoration(
                  hintText: 'Search',
                  hintStyle: GoogleFonts.poppins(fontSize: 12),
                  border: InputBorder.none,
                  suffixIcon: const Icon(Icons.search,color: Colors.blueGrey,size: 15,),
                ),
                onChanged: (value){
                  lstrSearchval = value;
                  fnLookupSearch();
                },
              ),
            ):gapWC(300),
           // _createListView(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: wSearchList(),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 5, bottom: 0,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      var filter = [{'Column': keyColumn, 'Operator': '=', 'Value': txSearchControl.text, 'JoinType': 'AND'}];
                      fnLookupValidate(widget.lstrTable, filter);
                      Navigator.pop(context);
                    },
                    child: customBButtonFlat('Done', BgColor, Colors.white, Icons.done_all_rounded),
                  )
                ],
              ),
            )
          ],
        )
    );
  }


  //===========================================WIDGET
  Widget _createListView() {
    return Expanded(

        child: FutureBuilder<dynamic>(
        future: lstrFutureLookup,
        builder: (context, snapshot) {
      if (snapshot.hasData) {
        return _Listview(snapshot);
      } else if (snapshot.hasError) {
        return const Text("NO DATA");
      }

      // By default, show a splashscreen spinner.
      return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const[
           CircularProgressIndicator()
        ],
      );
    },
    )
    );
  }
  //List layout Create here
  Widget _Listview(snapshot){
   if(lstrLayoutName == "B"){
      return ListView.builder(
          shrinkWrap: false,
          physics: const ScrollPhysics(),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            var datalist;

            datalist = snapshot.data[index];
            return Container(
              margin: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                      onTap: (){
                        fnCallback(datalist);
                        fnFillData(datalist);
                        //txtControl.text = datalist['$key_column'];
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(top: 10,right: 5,left: 10,bottom: 10),
                        decoration: boxBaseDecoration(blueLight, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: fnColumnList(datalist),
                        ),
                      )
                  )
                ],
              ),
            );
          });
    }else{
       return const Text('No Layout Found');
    }
  }

  List<Widget> wSearchList(){
    List<Widget> rtnList = [];
    rtnList.add(gapHC(10));
    for(var e in pageData){
      rtnList.add(Bounce(
        onPressed: (){
          fnCallback(e);
          fnFillData(e);
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
      var value = e[f["Column"]]??"";
      var caption = f["Display"]??"";
      if(caption != "N"){
        rtnList.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            tc(caption, Colors.black , 8),
            tcn(value, Colors.black , 10),
          ],
        ));
      }

    }
    return rtnList;
  }

  //==========================================PAGE FN
  fnColumnList(datalist){
    final children = <Widget>[];
    for ( var i in widget.lstrColumnList){

      children.add( i['Column'] != null && i['Column'] != "" ? datalist[i['Column']] != null ?tcn(i['Display'].toString() +' :  ' + datalist[i['Column']].toString(),BgColor,12):tcn(i['Display'].toString() +' :  ',BgColor,12) :Text(''));
    }

    return children;
  }
  fnSortColumns(){
    for ( var i in widget.lstrColumnList){
      columnList == null ?  columnList = i['Column'] + "|": columnList += i['Column'] + "|";
    }
    print(columnList);
  }
  fnLookupSearch(){
    var filterVal= [];
    filterVal  = g.mfnJson(widget.lstrFilter)??[];
    for(var e in widget.lstrColumnList){
      filterVal.add({ "Column": e['Column'], "Operator": "LIKE", "Value": lstrSearchval, "JoinType": "OR" });
    }
    lstrFutureLookup = apiCall.LookupSearch(widget.lstrTable, columnList, widget.lstrPage, widget.lstrPageSize, filterVal);
    lstrFutureLookup.then((value) => fnLookupSearchSuccess(value));
  }
  fnLookupSearchSuccess(value){
    if(mounted){
      setState(() {
        pageData = [];
        if(g.fnValCheck(value)){
          pageData =value;
        }
      });
    }
  }
  fnLookupValidate(lstrTable,lstrfilter){

    lstrFutureLookupValidate = apiCall.LookupValidate(lstrTable, lstrfilter);
    lstrFutureLookupValidate.then((value) =>
        fnValidate(value)
    );

  }
  fnValidate(value) async{

    if(value.length > 0){

      lstrSelectedDataList =  value[0];
      fnCallback(value[0]);
      fnFillData(value[0]);
       if(widget.mode == "C"){
         Navigator.pop(context);
       }

    }else{
      txtControl.text= "";
      for ( var i in widget.lstrFilldata ){

        if(i['context'] == 'window'){

          i['contextField'].text = "";

        }else if (i['context'] == 'variable'){

          i['contextField'] = "";

        }
      }
    }

  }
  fnFillData(datalist){
    for ( var i in widget.lstrFilldata){

       if(i['context'] == 'window'){

         i['contextField'].text = datalist[i['sourceColumn']]??'';

       }else if (i['context'] == 'variable'){

         i['contextField'] = datalist[i['sourceColumn']]??'';

       }
      // {'sourceColumn': 'USER_CD', 'contextField': txtMobilenoArea, 'context': 'window'}

    }
  }
  //===========================================APICALL


}

