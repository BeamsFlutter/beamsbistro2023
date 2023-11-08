
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/tableComponent.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:oktoast/oktoast.dart';

class Tables extends StatefulWidget {
  const Tables({Key? key}) : super(key: key);

  @override
  _TableState createState() => _TableState();
}

class _TableState extends State<Tables> {

  late Future<dynamic> futureFloor;
  late Future<dynamic> futureTable;
  ApiCall  apiCall = ApiCall();
  Global g = Global();
  var txtGuestNo = TextEditingController();
  var lstrSelectedGuestNum = '' ;

  var lstrMultiTable  = [];
  var lstrSelectedFloor = '';
  var wstrTableMode  = '';

  var orderNo = '';
  var lstrTableName = '';
  var lstrGuestNo = '';


  @override
  void initState() {
    // TODO: implement initState
    lstrMultiTable = g.wstrLastSelectedTables;
    wstrTableMode =  g.wstrTableUpdateMode;
    fnGetTable();
    lstrGuestNo =  g.wstrGuestNo.toString();
    txtGuestNo.text = g.wstrGuestNo.toString();
    fnGetTableName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        child: pageScreen(
        Container(
          height: size.height *0.83,
          width: size.width,
          child:  Row(
            children: [
              Expanded(child: Container(
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      width: size.width,
                      child: new FutureBuilder<dynamic>(
                        future: futureTable,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return floorView(snapshot);
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
                    Container(
                      height: size.height*0.7,
                      child:  new FutureBuilder<dynamic>(
                        future: futureTable,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return tableView(snapshot,size);
                          } else if (snapshot.hasError) {
                            return Container();
                          }

                          // By default, show a loading spinner.
                          return Center(
                            child: Container(

                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),),
              Container(
                padding: EdgeInsets.all(10),
                width: size.width*0.33,
                decoration: boxDecoration(Colors.white, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    th('Selected Tables',Colors.black,16),
                    gapHC(10),
                    Expanded(child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio:5/2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: List.generate(lstrMultiTable.length, (index) {
                        var datalist =  lstrMultiTable[index];

                        return GestureDetector(
                          onTap: (){
                            fnRemoveTable(datalist);
                          },
                          child: Container(
                            decoration: boxBaseDecoration(SecondaryColor, 5),
                            child: Center(
                              child: tc(datalist['TABLE_DESCP']??'',Colors.black,18),
                            ),
                          ),
                        );
                      }),
                    ),),
                    tcn('Guest No', Colors.black, 16),
                    Container(
                        width: size.width*0.3,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              guestNum('1'),
                              guestNum('2'),
                              guestNum('3'),
                              guestNum('4'),
                              guestNum('5'),
                              guestNum('6'),
                              guestNum('7'),
                              guestNum('8'),
                              guestNum('9'),
                            ],
                          ),
                        )
                    ),
                    gapHC(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width* 0.2,
                          height: 40,
                          padding: EdgeInsets.all(5),
                          decoration: boxBaseDecoration(blueLight, 5),
                          child: TextField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Name'

                            ),
                          ),
                        ),
                        Container(
                          width: size.width* 0.1,
                          height: 40,
                          padding: EdgeInsets.all(5),
                          decoration: boxBaseDecoration(blueLight, 5),
                          child: TextField(
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            controller: txtGuestNo,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Guest No'
                            ),
                          ),
                        ),
                      ],
                    ),
                    gapHC(10),
                    Bounce(child: Container(
                      height: 40,
                      decoration: boxDecoration(PrimaryColor, 30),
                      child: Center(
                        child: th('Done',Colors.white,18),
                      ),
                    ), duration: Duration(milliseconds: 110),
                        onPressed: (){
                      g.wstrLastSelectedTables = lstrMultiTable;
                      if(g.wstrTableUpdateMode == "B"){
                        Navigator.pop(context);
                      }else{
                        if(g.fnValCheck(lstrMultiTable)){
                          g.wstrLastSelectedTables = lstrMultiTable;
                          var guestNo  = txtGuestNo.text.isEmpty?'0': txtGuestNo.text.toString() ;
                          g.wstrGuestNo = int.parse(guestNo);
                          Navigator.pushReplacement(context, NavigationController().fnRoute(15));
                        }else{
                          showToast( "Please Choose table..");
                        }
                      }
                    }),
                  ],
                ),
              )
            ],
          ),
        ),
        size,context,fnBack),
      onWillPop: () async{
        fnBack();
      return true;
    });
  }

  Widget floorView(snapshot){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data['FLOORS'].length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data['FLOORS'][index];
          var floorCode = dataList['CODE'];
          var floorName = dataList['DESCP'];

          return GestureDetector(
            onTap: (){
              fnUpdateFloor(floorCode);
            },
            child:  Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              margin: EdgeInsets.only(right: 10),
              decoration: boxBaseDecoration(lstrSelectedFloor == floorCode ? PrimaryColor :SecondarySubColor, 20),
              child: Center(
                child: tc(floorName, lstrSelectedFloor == floorCode ? Colors.white : PrimaryText,15),
              ),
            ),
          );
        });
  }
  Widget tableView(snapshot,size){

    if(snapshot.data['TABLES'] == null){
      return Container();
    }

    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(snapshot.data['TABLES'].length, (index) {
        var dataList = snapshot.data['TABLES'][index];
        var tableName = dataList['DESCP'];
        var noOfChair = dataList['NOOFPERSON']??0;
        var guestNumber = dataList['NO_PEOPLE']??0;
        var tableType = dataList['TYPE'];
        var orderTime = dataList['ORDERTIME'];
        var orderNo = dataList['NO_ORDER'].toString();
        return GestureDetector(
          onDoubleTap: (){

          },
          onTap: (){
            fnTableClick(dataList);
          },
          child: fnCallTable(noOfChair,tableName,'',guestNumber,tableType,orderNo,orderTime,size),
        ) ;//g.wstrTableView == '1'?
      }),
    );
  }
  GestureDetector gusestNum(num) {
    return GestureDetector(
      onTap: (){
        fnNumberPress(num);
      },
      child: Container(
        height: 45,
        width: 40,
        margin: EdgeInsets.only(right: 5),
        decoration: boxBaseDecoration(lstrSelectedGuestNum == num ?Colors.amber: greyLight, 5),
        child: Center(
          child: s3(num),
        ),
      ),
    );
  }
  Widget fnCallTable(chair,oChair,mode,name,type,order,time,size){
    if(type == 'S'){
      return ctableSquare(chair,oChair,mode,name,int.parse(order),time,size,'');
    }else if(type == 'R'){
      return ctableRound(chair,oChair,mode,name,int.parse(order),'');
    }else if(type == 'L'){
      return ctableRectangle(chair,oChair,mode,name,int.parse(order),'');
    }else{
      return Container();
    }
  }
  fnTableClick(dataList){

    var tableCode = dataList['CODE'];
    var tableName = dataList['DESCP'];
    var selectedTable = fnCheckTable(tableCode);
    if(!g.fnValCheck(selectedTable)){
      setState(() {
        lstrMultiTable.add({
          "COMPANY":g.wstrCompany.toString(),
          "YEARCODE":g.wstrYearcode.toString(),
          "SRNO":"0",
          "TABLE_CODE":tableCode.toString(),
          "TABLE_DESCP":tableName.toString(),
          "GUEST_NO":"",
          "STATUS":"P",
        });
      });
    }
    print(lstrMultiTable);


  }
  fnCheckTable(tableCode){
    var selectedData ;
    if(g.fnValCheck(lstrMultiTable)){
      for (var e in lstrMultiTable) {
        var lcode = e["TABLE_CODE"].toString();
        if( tableCode == lcode ){
          selectedData = e;
          break;
        }
      }
    }
    return selectedData;
  }
  fnRemoveTable(dataList){
    setState(() {
      lstrMultiTable.remove(dataList);
    });
  }
  fnRemoveAllTable(){
    setState(() {
      lstrMultiTable.clear();
    });
  }
  fnNumberPress(num){
    setState(() {
      lstrSelectedGuestNum = num.toString();
      txtGuestNo.text = num.toString();
    });
  }
  fnGetTableName() {

    var tableName ='';
    for(var e in lstrMultiTable){
      var t = e["TABLE_DESCP"];
      tableName =  tableName == "" ? t :t + ','+ tableName ;
    }
    setState(() {
      lstrTableName = tableName;
    });
  }
  fnUpdateFloor(floorCode) {
    setState(() {
      lstrSelectedFloor = floorCode;
      fnGetTable();
    });
  }
  fnBack(){
    if(g.wstrTableUpdateMode == "B"){
      Navigator.pop(context);
    }else{
      Navigator.pushReplacement(context, NavigationController().fnRoute(15));
    }
  }
  GestureDetector guestNum(num) {
    return GestureDetector(
      onTap: (){
        fnNumberPress(num);
      },
      child: Container(
        height: 44,
        width: 40,
        margin: EdgeInsets.only(right: 5),
        decoration: boxBaseDecoration(lstrSelectedGuestNum == num ?Colors.amber: greyLight, 5),
        child: Center(
          child: tc(num,Colors.black,15),
        ),
      ),
    );
  }

  //api
  fnGetTable() async{
    futureTable = apiCall.getTables(g.wstrCompany, g.wstrYearcode ,lstrSelectedFloor,g.wstrUserCd);
    futureTable.then((value) => fnGetTableSuccess(value));
  }
  fnGetTableSuccess(value){
    if(value != null){
      if(value['FLOORS'].length > 0){
        setState(() {
          lstrSelectedFloor = lstrSelectedFloor == ''? lstrSelectedFloor= value['FLOORS'][0]['CODE']:lstrSelectedFloor;
        });
      }
    }

  }

}
