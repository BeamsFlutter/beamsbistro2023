
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KitchenSelection extends StatefulWidget {
  final Function  fnCallBack;

  const KitchenSelection({Key? key, required this.fnCallBack}) : super(key: key);
  //getKitchenDetails()

  @override
  _KitchenSelectionState createState() => _KitchenSelectionState();
}

class _KitchenSelectionState extends State<KitchenSelection> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //api
  ApiCall apiCall =ApiCall();
  Global g = Global();
  late Future<dynamic> futureKitchen;


  //pageVariable
  var _radioValue = 0 ;
  var lstrSelectedKitchen = '';
  var lstrSelectedKitchenDescp = '';

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
      future:  futureKitchen,
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
          var kitchenCode = dataList["CODE"]??'';
          var KitchenDescp = dataList["DESCP"]??'';
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
                        fnKitchenRadioClick(kitchenCode,KitchenDescp,index);

                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      fnKitchenRadioClick(kitchenCode,KitchenDescp,index);
                    },
                    child: tc(KitchenDescp,Colors.black,20),
                  )
                ],
              ),
            ),
          );
        });
  }

  //page
  fnGetPageData(){
    lstrSelectedKitchen = g.wstrSelectedkitchen;
    lstrSelectedKitchenDescp = g.wstrSelectedkitchenDescp;
    futureKitchen = apiCall.getKitchenDetails();
    futureKitchen.then((value) => fnGetPageDataSuccess(value));

  }
  fnGetPageDataSuccess(value){
    if(g.fnValCheck(value)){
      print(value);
    }
  }


  //other
  fnKitchenRadioClick(code,name,index) async{
    setState(() {
      _radioValue = index;
      lstrSelectedKitchen = code;
      lstrSelectedKitchenDescp = name;
      g.wstrSelectedkitchen = code;
      g.wstrSelectedkitchenDescp = name;
    });


    final SharedPreferences prefs = await _prefs;
    prefs.setString('wstrKitchenCode', code);
    prefs.setString('wstrKitchenDescp', name);

    widget.fnCallBack();
    Navigator.pop(context);
  }

  //api


}
