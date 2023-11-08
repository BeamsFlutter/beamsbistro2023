import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:flutter/material.dart';

class Lookup extends StatefulWidget {

  final title;
  final mode;
  final source;
  final TextEditingController  txtControl;
  final selectColumns;
  final keyColumn;
  final fillDataTo;
  final String  oldValue;
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
  Lookup({Key ?key, this.title, this.source, required this.txtControl, this.selectColumns, this.keyColumn, this.fillDataTo, required this.oldValue, required this.callback, required this.layoutName, this.lstrColumns, this.lstrTable, this.lstrPage, this.lstrPageSize, this.lstrFilter, required this.lstrColumnList, this.focusNode, required this.lstrFilldata, this.mode}) : super(key: key);




  @override
  _LookupState createState() => _LookupState();
}

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
    fnLookupValidate(widget.lstrTable, lookupFilterVal);

    lstrFutureLookup = apiCall.LookupSearch(widget.lstrTable, columnList, widget.lstrPage, widget.lstrPageSize, widget.lstrFilter);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height:  MediaQuery.of(context).size.height*0.7, // Change as per your requirement
        width:  MediaQuery.of(context).size.width*0.6,
        child: Center(
          child: Column(
            children: <Widget>[
              RoundedInputField(
                txtRadius: 5,
                txtWidth: 0.95,
                autoFocus: true,
                txtController: txSearchControl,
                icon: Icons.search,
                textType: TextInputType.text,
                suffixIcon: Icons.search,
                hintText: "Search...",
                onChanged: (value){
                  setState(() {
                    lstrSearchval = value;
                    fnLookupsearch();
                  });
                },

              ),
              _createListView(),
            ],
          ),
        )
    );
  }

  Widget _createListView() {
    return Flexible(

        child: FutureBuilder<dynamic>(
          future: lstrFutureLookup,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _Listview(snapshot);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}"+" NO DATA");
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          },
        )
    );
  }
  //List layout Create here
  Widget _Listview(snapshot){
    if(lstrLayoutName == "B"){
      return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            var datalist;

            datalist = snapshot.data[index];
            return Container(

              margin: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 0),
                  Flexible(
                      child: GestureDetector(
                          onTap: (){
                            fnCallback(datalist);
                            fnFillData(datalist);
                            //txtControl.text = datalist['$key_column'];
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(top: 10,right: 5,left: 10,bottom: 10),
                            decoration: boxOutlineDecoration(Colors.white, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                //for ( var i in column_list )
                                for ( var i in fnColumnList(datalist))
                                  i,
                                //Divider(
                                //  height: 10,
                                //  thickness: 2,
                                //  color: Colors.grey,
                                //),
                              ],
                            ),
                          )
                      )
                  ),
                ],
              ),
            );
          });
    }else{
      return const Text('No Layout Found');
    }
  }

  fnColumnList(datalist){
    final children = <Widget>[];
    for ( var i in widget.lstrColumnList){

      children.add( i['Column'] != null && i['Column'] != "" ? datalist[i['Column']] != null ?Text(i['Display'].toString() +' :  ' + datalist[i['Column']].toString()):Text(i['Display'].toString() +' :  ') :Text(''));
    }

    return children;
  }

  fnSortColumns(){
    for ( var i in widget.lstrColumnList){
      columnList == null ?  columnList = i['Column'] + "|": columnList += i['Column'] + "|";
    }
    print(columnList);
  }

  fnLookupsearch(){
    var filterVal= [];
    filterVal  = g.mfnJson(widget.lstrFilter)??[];
    for(var e in widget.lstrColumnList){
      filterVal.add({ "Column": e['Column'], "Operator": "LIKE", "Value": lstrSearchval, "JoinType": "OR" });
    }
    lstrFutureLookup = apiCall.LookupSearch(widget.lstrTable, columnList, widget.lstrPage, widget.lstrPageSize, filterVal);
    lstrFutureLookup.then((value) => fnLookupSearchSuccess(value));
  }
  fnLookupSearchSuccess(value){
    setState(() {

    });
  }

  fnLookupValidate(lstrTable,lstrfilter){

    lstrFutureLookupValidate = apiCall.LookupValidate(lstrTable, lstrfilter);
    lstrFutureLookupValidate.then((value) =>
        fnValidate(value)
    );

  }

  fnValidate(value) async{

    print(value);

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

}

