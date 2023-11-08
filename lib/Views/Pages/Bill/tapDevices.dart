

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TapDevices extends StatefulWidget {
  const TapDevices({Key? key}) : super(key: key);

  @override
  State<TapDevices> createState() => _TapDevicesState();
}

class _TapDevicesState extends State<TapDevices> {

  //GLOBAL
  ApiCall apiCall =ApiCall();
  Global g = Global();
  late Future<dynamic> futureFrom;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //pageVariable
  var _radioValue = 0 ;
  var lDeviceList  = [];


  @override
  void initState() {
    // TODO: implement initState
    fnGetPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: wDeviceList(),
        ),
      ),
    );
  }

  //=================================== WIDGET

    List<Widget> wDeviceList(){
      List<Widget> rtnList = [];
      var index  =  0;
      for(var e in lDeviceList){
        var id= e["DEVICE_ID"];
        var name= e["DEVICE_NAME"];
        rtnList.add(Container(
          margin: EdgeInsets.only(bottom: 5),
          child: Row(
            children: [
              Transform.scale(scale: 1,
                child:  Radio(
                  value: index,
                  groupValue: _radioValue,
                  onChanged: (value){
                    fnRadioClick(id,name,index);
                  },
                ),
              ),
              GestureDetector(
                onTap: (){
                  fnRadioClick(id,name,index);
                },
                child: tc(name+" | "+id,Colors.black,15),
              )
            ],
          ),
        ));
        index = index+1;
      }
      return rtnList;
    }
  //=================================== PAGE FN

    fnGetPageData(){
      if(mounted){
        apiGetDevices();
      }
    }

  fnRadioClick(code,name,index) async{
    setState(() {
      _radioValue = index;
      g.wstrTapDeviceId = code;
      g.wstrTapDeviceName = name;
    });


    final SharedPreferences prefs = await _prefs;
    prefs.setString('wstrTapDeviceId', code);
    prefs.setString('wstrTapDeviceName', name);

    Navigator.pop(context);
  }

  //=================================== API CALL

    apiGetDevices(){
      futureFrom  = apiCall.apiGetTapDevices();
      futureFrom.then((value) => apiGetDevicesRes(value));
    }
    apiGetDevicesRes(value){
      if(mounted){
        print(value);
        setState(() {
          lDeviceList =  value;
        });
      }
    }




}
