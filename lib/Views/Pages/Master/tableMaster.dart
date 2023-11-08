

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/bottomNavigator.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/lookup.dart';
import 'package:beamsbistro/Views/Components/lookup_alert.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class TableMast extends StatefulWidget {
  const TableMast({Key? key}) : super(key: key);

  @override
  _TableMastState createState() => _TableMastState();
}

class _TableMastState extends State<TableMast> {

  //api
  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic> futureTable;

  //textController
  var txtCode = new TextEditingController();
  var txtDescp = new TextEditingController();
  var txtNoChair = new TextEditingController();
  var txtFloor = new TextEditingController();
  var txtType = new TextEditingController();

  //varaibles
  var wstrPageMode = '';
  var lstrPageDocno = '';
  var lstrFloorDescp = '';

  @override
  void initState() {
    // TODO: implement initState
    wstrPageMode = 'VIEW';
    fnPageData('','LAST');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return pageMenuScreen(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            h1('Table Master'),
            gapH(),
            RoundedInputField(
              hintText: 'Code',
              txtRadius: 5,
              txtWidth: 0.4,
              suffixIcon:  wstrPageMode == 'VIEW'? Icons.search : null,
              txtController: txtCode,
              suffixIconOnclick: (){
                wstrPageMode == 'VIEW'?  fnLookup('TABLE') : '';
              },
              onChanged: (value) {
                wstrPageMode == 'VIEW'?  fnLookup('TABLE') : '';
              },
              enablests: wstrPageMode == 'EDIT'? false:true,
            ),
            RoundedInputField(
              hintText: 'Description',
              txtRadius: 5,
              txtController: txtDescp,
              enablests: wstrPageMode == 'VIEW'? false:true,
            ),
            RoundedInputField(
              hintText: 'No of person',
              txtRadius: 5,
              txtWidth: 0.4,
              txtController: txtNoChair,
              textType: TextInputType.number,
              enablests: wstrPageMode == 'VIEW'? false:true,
            ),
            RoundedInputField(
              hintText: 'Floor',
              txtRadius: 5,
              txtWidth: 0.4,
              txtController: txtFloor,
              enablests: wstrPageMode == 'VIEW'? false:true,
              suffixIcon:  wstrPageMode != 'VIEW'? Icons.search : null,
              suffixIconOnclick: (){
                wstrPageMode != 'VIEW'?  fnLookup('FLOOR') : '';
              },
              onChanged: (value) {
                wstrPageMode != 'VIEW'?  fnLookup('FLOOR') : '';
              },
            ),
            RoundedInputField(
              hintText: 'Type',
              txtRadius: 5,
              txtWidth: 0.4,
              txtController: txtType,
              enablests: wstrPageMode == 'VIEW'? false:true,
              suffixIcon:  wstrPageMode != 'VIEW'? Icons.search : null,
              suffixIconOnclick: (){
                wstrPageMode != 'VIEW'?  fnLookup('TYPE') : '';
              },
              onChanged: (value) {
                wstrPageMode != 'VIEW'?  fnLookup('v') : '';
              },
            )
          ],
        ),size,context,
        BottomNavigation(
          mode: wstrPageMode,
          fnAdd: fnAdd,
          fnEdit: fnEdit,
          fnCancel: fnCancel,
          fnPage: fnPage,
          fnSave: fnSave,
          fnDelete: fnDelete,
        ),fnBack
    );
  }

  //ButtonClicks
  fnAdd(){
    txtCode.clear();
    txtDescp.clear();
    txtFloor.clear();
    txtType.clear();
    txtNoChair.clear();
    setState(() {
      lstrFloorDescp= '';
      wstrPageMode = 'ADD';
    });
  }
  fnEdit(){
    setState(() {
      wstrPageMode = 'EDIT';
    });
  }
  fnCancel(){
    setState(() {
      wstrPageMode = 'VIEW';
      fnPageData(lstrPageDocno,'');
    });
  }
  fnPage(mode){
    switch (mode) {
      case 'FIRST':
        fnPageData('',mode);
        break;
      case 'LAST':
        fnPageData('',mode);
        break;
      case 'NEXT':
        fnPageData(lstrPageDocno,mode);
        break;
      case 'PREVIOUS':
        fnPageData(lstrPageDocno,mode);
        break;
    }
  }
  fnSave(){
    if(txtCode.text.isEmpty){
      showToast( 'Please fill Table Code');
      return;
    }else if(txtFloor.text.isEmpty){
      showToast( 'Please Choose Floor');
      return;
    }else{
      futureTable = apiCall.saveFloor(txtCode.text, txtDescp.text, wstrPageMode);
      futureTable.then((value) => fnSaveCallBack(value));
    }
  }
  fnDelete(){

  }
  fnSaveCallBack(value){
    if(g.fnValCheck(value)){
      var sts = value[0]['STATUS'];
      var msg = value[0]['MSG'];
      if(sts == '1'){
        setState(() {
          wstrPageMode = 'VIEW';
          lstrPageDocno = value[0]['CODE'];
        });
        showToast( msg);
        fnPageData(lstrPageDocno, '');
      }else{
        showToast( msg);
      }
    }
  }

  //viewapi
  fnPageData(docNo,mode){
    futureTable = apiCall.viewTable(docNo, mode , g.wstrCompany);
    futureTable.then((value) => fnPageDataCallback(value));
  }
  fnPageDataCallback(value){
    if(g.fnValCheck(value)){
      var data = value[0];
      fnFillData(data);
    }
  }
  fnFillData(data){
    lstrPageDocno = data['CODE'];
    txtCode.text = data['CODE'];
    txtDescp.text = data['DESCP'];
    txtNoChair.text = data['NOOFPERSON'].toString();
    txtFloor.text = data['FLOOR_CODE'];
    txtType.text = data['TYPE'];
    lstrFloorDescp = data['FLOOR_DESCP'];
  }

  //lookup
  fnLookup(mode){
    if(mode == 'TABLE'){

      final List<Map<String, dynamic >> lookupColumns= [{'Column': 'CODE', 'Display': 'Table Code'},{'Column': 'DESCP', 'Display': 'Table Name'},{'Column': 'NOOFPERSON', 'Display': 'No of person'}];
      final List<Map<String, dynamic >> lookupFillData= [
        {'sourceColumn': 'CODE', 'contextField': txtCode, 'context': 'window'},
        {'sourceColumn': 'DESCP', 'contextField': txtDescp, 'context': 'window'},
        {'sourceColumn': 'NOOFPERSON', 'contextField': txtNoChair, 'context': 'window'},
        {'sourceColumn': 'FLOOR_CODE', 'contextField': txtFloor, 'context': 'window'},
        {'sourceColumn': 'TYPE', 'contextField': txtType, 'context': 'window'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtCode,
        oldValue: txtCode.text,
        lstrTable: 'TABLEMAST',
        lstrColumnList: lookupColumns,
        lstrFilldata: lookupFillData,
        lstrPage: '0',
        lstrPageSize: '1000',
        lstrFilter: [],
        keyColumn:'CODE',
        layoutName: "B",
        callback: fnCallBack,
      ),'Choose Floor');
    }else if(mode == 'FLOOR'){

      final List<Map<String, dynamic >> lookupColumns= [{'Column': 'CODE', 'Display': 'Floor Code'},{'Column': 'DESCP', 'Display': 'Floor Name'}];
      final List<Map<String, dynamic >> lookupFillData= [
        {'sourceColumn': 'CODE', 'contextField': txtFloor, 'context': 'window'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtFloor,
        oldValue: txtFloor.text,
        lstrTable: 'RST_FLOORMAST',
        lstrColumnList: lookupColumns,
        lstrFilldata: lookupFillData,
        lstrPage: '0',
        lstrPageSize: '1000',
        lstrFilter: [],
        keyColumn:'CODE',
        layoutName: "B",
        callback: fnCallBackFloor,
      ),'Choose Floor');
    }
  }
  fnCallBack(data){
    fnFillData(data);
  }
  fnCallBackFloor(data){
    setState(() {
      lstrFloorDescp = data['DESCP'];
    });
  }
  fnBack(){

  }


}
