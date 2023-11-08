
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrinterSelection extends StatefulWidget {

  const PrinterSelection({Key? key}) : super(key: key);
  //getKitchenDetails()

  @override
  _PrinterSelectionState createState() => _PrinterSelectionState();
}

class _PrinterSelectionState extends State<PrinterSelection> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //api
  ApiCall apiCall =ApiCall();
  Global g = Global();
  late Future<dynamic> futurePrinter;


  //pageVariable
  var _radioValue = 0 ;
  var lstrSelectedPrinter = '';
  var lstrSelectedPrinterName = '';
  var lstrSelectedPrinterPath = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<dynamic>(
      future:  futurePrinter,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return  kitchenView(snapshot) ;
        } else if (snapshot.hasError) {
          return Container();
        }
        // By default, show a loading spinner.
        return Center(
          child: Container(),
        );
      },
    );
  }
  Widget kitchenView(snapshot){
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data[index];
          var printerCode = dataList["CODE"]??'';
          var printerDescp = dataList["NAME"]??'';
          var printerPath = dataList["PATH"]??'';
          return GestureDetector(
            onTap: (){

            },
            //h1(userName.toString())
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Transform.scale(scale: 1,
                    child: new Radio(
                      value: index,
                      groupValue: _radioValue,
                      onChanged: (value){
                        fnPrinterRadioClick(printerCode,printerDescp,printerPath,index);

                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      fnPrinterRadioClick(printerCode,printerDescp,printerPath,index);
                    },
                    child: tc(printerDescp+" | "+printerPath,Colors.black,15),
                  )
                ],
              ),
            ),
          );
        });
  }

  //page
  fnGetPageData(){
    lstrSelectedPrinter = g.wstrPrinterCode;
    lstrSelectedPrinterName = g.wstrPrinterName;
    lstrSelectedPrinterPath = g.wstrPrinterPath;
    futurePrinter = apiCall.getPrinters();
    futurePrinter.then((value) => fnGetPageDataSuccess(value));

  }
  fnGetPageDataSuccess(value){
    if(g.fnValCheck(value)){
      print(value);
    }
  }


  //other
  fnPrinterRadioClick(code,name,path,index) async{
    setState(() {
      _radioValue = index;
      lstrSelectedPrinter = code;
      lstrSelectedPrinterName = name;
      lstrSelectedPrinterPath = path;
      g.wstrPrinterCode = code;
      g.wstrPrinterName = name;
      g.wstrPrinterPath = path;
    });


    final SharedPreferences prefs = await _prefs;
    prefs.setString('wstrPrinterCode', code);
    prefs.setString('wstrPrinterName', name);
    prefs.setString('wstrPrinterPath', path);

    Navigator.pop(context);
  }

  //api


}
