import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Pages/Login/userLogin.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> with TickerProviderStateMixin {

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  var deviceId = '';
  var deviceName = '';
  var deviceIp = '';
  var deviceMode ='';
  var lstrToday ;
  var wstrLoginDate ;
  var formatDate = new DateFormat('yyyy-MM-dd hh:mm:ss');

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );





  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Global g =  Global();
  ApiCall apiCall = ApiCall();

  late Future<dynamic> futureIp;

  var loginUserRole = '';
  var clockInSts = '';
  @override
  void initState() {
    // TODO: implement initState

    initPlatformState();
    var now = DateTime.now();
    g.wstrAutoClockOutTime = 4;
    g.wstrRoomMode = "N";
    g.wstrQuickBillYN = "N";
    g.wstrDirectPrintYn = "N";
    g.wstrImgYn = "N";
    g.wstrBistroLng = "ENGLISH";
    //g.wstrBaseUrl = "https://10.255.254.33:1100/";
    g.wstrBaseUrl = "http://localhost:19695/";
    lstrToday = DateTime.parse(formatDate.format(now));
    startTime();
    fnClearDualDisplay();
    super.initState();
  }

  @override
  void dispose() {

    _controller.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {

    var deviceData = <String, dynamic>{};
    try {

      // final ipv4 = await Ipify.ipv4();
      // print(ipv4); // 98.207.254.136
      //
      // final ipv6 = await Ipify.ipv64();
      // print(ipv6); // 98.207.254.136 or 2a00:1450:400f:80d::200e
      //
      // final ipv4json = await Ipify.ipv64(format: Format.JSON);
      // print(ipv4json); //{"ip":"98.207.254.136"} or {"ip":"2a00:1450:400f:80d::200e"}

      if (kIsWeb) {
        _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);

      } else {
        if (Platform.isAndroid) {
              _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else if (Platform.isLinux) {
           _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
           _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {

          _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (!mounted) return;
    g.wstrDeviceName = deviceName;
    g.wstrDeivceId = deviceId;

  }
  _readAndroidBuildData(AndroidDeviceInfo build) {

    setState(() {
      deviceMode = '';
      deviceId = build.id??'';
      deviceName =  build.model??'';

    });

  }
  _readIosDeviceInfo(IosDeviceInfo data) {
    print("??????????????????????????");
    print(data);
    setState(() {
      deviceMode = '';
      deviceId = data.name??'';
      deviceName =  data.systemName??'';
    });

  }
  _readLinuxDeviceInfo(LinuxDeviceInfo data) {

  }
  _readWebBrowserInfo(WebBrowserInfo data)  {

     setState(() {
       deviceMode = 'W';
       deviceId = describeEnum(data.browserName);
       deviceName =  describeEnum(data.browserName);
     });


  }
  _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    setState(() {
      deviceMode = '';
      deviceId = data.systemGUID??'';
      deviceName =  data.computerName;
    });
  }
  _readWindowsDeviceInfo(WindowsDeviceInfo data) {

    setState(() {
      deviceMode = '';
      deviceId = data.computerName;
      deviceName =  data.computerName;
    });
  }


  startTime() async {
    final SharedPreferences prefs = await _prefs;
    var loginSts = prefs.getString('wstrLoginSts');
    var loginDate = prefs.getString('wstrLoginDate');
    var loginUserCd = prefs.getString('wstrUserCd');
    var loginUserName = prefs.getString('wstrUserName');
    loginUserRole = prefs.getString('wstrUserRole').toString();
    var loginCompany = prefs.getString('wstrCompany');
    var loginYearcode = prefs.getString('wstrYearcode');
    var loginShifNo = prefs.getString('wstrShift');
    var loginShifDescp = prefs.getString('wstrShiftDescp');
    var loginClockInDate = prefs.getString('wstrClockInDate');
    var userBrnCode = prefs.getString('wstrUserBrnCode');
    var bistroLng = prefs.getString('wstrBistroLng');
    var token =  prefs.getString('wstrToken')??"";



    g.wstrToken =  token;
    clockInSts = prefs.getString('wstrClockInSts').toString();
    prefs.setString("wstrDeviceId", deviceId);
    prefs.setString("wstrDeviceName", deviceName);
    prefs.setString("wstrDeviceIP", deviceIp);
    g.wstrSelectedkitchen = (prefs.getString('wstrKitchenCode')??'').toString();
    g.wstrSelectedkitchenDescp = (prefs.getString('wstrKitchenDescp')??'');
    g.wstrPrinterCode = (prefs.getString('wstrPrinterCode')??'').toString();
    g.wstrPrinterName = (prefs.getString('wstrPrinterName')??'').toString();
    g.wstrPrinterPath = (prefs.getString('wstrPrinterPath')??'').toString();
    g.wstrTapDeviceId = (prefs.getString('wstrTapDeviceId')??'').toString();
    g.wstrTapDeviceName = (prefs.getString('wstrTapDeviceName')??"").toString();
    g.wstrIp = prefs.getString('wstrIP')??'';
    g.wstrUserBrnCode = (prefs.getString('userBrnCode')??"").toString();
    g.wstrBistroLng = (prefs.getString('wstrBistroLng')??"").toString();

    g.wstrDeviceIP = (prefs.getString('wstrDeviceIP')??'').toString();

    g.wstrDiscountYn = prefs.getString('wstrDiscYn') == "Y"?true:false;
    g.wstrDiscountType = (prefs.getString('wstrDiscType')??'').toString();
    g.wstrDiscountMaxPerc = g.mfnDbl(prefs.getDouble('wstrDiscMaxPerc'));
    g.wstrDiscountGroup = (prefs.getString('wstrDiscGroup')??'').toString();

    var sts ;
    if(loginDate != null){
      var addDate  = DateTime.parse(loginDate).add(const Duration(minutes: 2));
      wstrLoginDate = DateTime.parse(formatDate.format(addDate));
      sts = wstrLoginDate.compareTo(lstrToday).toString();
    }

    if(deviceMode == "W"){
      fnGetApi();
    }
    fnGetLanguage();


    if(sts == "-1"){
      var duration = new Duration(seconds: 5);
      return new Timer(duration, route);
    }else{
      // if(loginSts == 'Y'){
      //   g.wstrCompany = loginCompany;
      //   g.wstrYearcode = loginYearcode;
      //   g.wstrUserName = loginUserName;
      //   g.wstrUserCd = loginUserCd??'';
      //   g.wstrUserCd = loginUserCd??'';
      //   g.wstrShifNo= loginShifNo??'';
      //   g.wstrShifDescp= loginShifDescp??'';
      //   g.wstrClockInDate = loginClockInDate??'';
      //
      //
      //   var duration = new Duration(seconds: 7);
      //   return new Timer(duration, loginRoute);
      //
      //
      // }else{
      //   var duration = new Duration(seconds: 7);
      //   return new Timer(duration, route);
      // }
      var duration = new Duration(seconds: 7);
      return new Timer(duration, route);
    }



  }
  route() async{

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Login()
    ));
  }
  loginRoute() async{

    if(clockInSts == "OUT"){
      Navigator.pushReplacement(context, NavigationController().fnRoute(12));
    }else
    if(loginUserRole == 'WAITER'){
      Navigator.pushReplacement(context, NavigationController().fnRoute(1));
    }else if(loginUserRole == 'CHEF'){
      Navigator.pushReplacement(context, NavigationController().fnRoute(10));
    }else if(loginUserRole == 'ADMIN'){
      Navigator.pushReplacement(context, NavigationController().fnRoute(9));
    }else if(loginUserRole == 'QUICK' || loginUserRole == 'QADMIN'){
      Navigator.pushReplacement(context, NavigationController().fnRoute(16));
    }else if(loginUserRole == 'CASHIER'){
      Navigator.pushReplacement(context, NavigationController().fnRoute(9));
    }else{
      Navigator.pushReplacement(context, NavigationController().fnRoute(9));
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child:Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/bg1.jpg"),
                  fit: BoxFit.cover
              )
          ),
          height: size.height,
          width: size.width,
          child: Container(
            decoration: boxGradientDecoration(16, 0),
            child:   Column(
              children: <Widget>[
                Expanded(child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 15,left: 30,right: 30),
                        height: 170,
                        width: 170,
                        padding: EdgeInsets.all(10),
                        decoration: boxDecoration(greyLight, 150),
                        child:Container(
                            margin: EdgeInsets.all(5),
                            decoration: boxDecoration(Colors.white, 130),
                            child: Center(
                                child:  ScaleTransition(
                                  scale: _animation,
                                  child: Image.asset("assets/icons/bislogo.png",width: 120,),
                                )
                            )
                        ),
                      ),
                    ],
                  ),
                ),),
                Container(
                  child:Column(
                    children: [
                      tc('Beams', Colors.white, 15)
                    ],
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
  //==============================API CALL========================

  fnGetApi() async{
    futureIp = apiCall.getIP();
    futureIp.then((value) => fnGetApiSucces(value));
  }
  fnGetApiSucces(data) {
    setState(() {
      deviceIp =data??"";
      g.wstrDeviceIP = data??"";
      deviceId =  deviceId+deviceIp;
      g.wstrDeivceId = deviceId;
    });
  }

  fnGetLanguage() async{
    futureIp = apiCall.apiGetMultiLanguage();
    futureIp.then((value) => fnGetLanguageRes(value));
  }
  fnGetLanguageRes(value) {
    if(mounted){
      print("hello");
      print(value);
      setState(() {
        g.wstrLanguage = value  == null?[]:(value["MENU"]??[]);
        g.wstrLanguageList = value  == null?[]:(value["LANGUAGE"]??[]);
      });
    }
  }

  fnClearDualDisplay() async{
    var data =  {
      "STS":"0",
      "COMPANY_DATA":{
        "NAME":"JASMINE TIME",
        "ADD":"DUBAI",
        "MOBILE":"0526912325",
      },
      "BILL_DETAILS":{
        "BILLNO":"NEW",
        "DOCDATE":"",
        "USER":g.wstrUserName,
        "DEVICE":"Device",
      },
      "ITEM_LIST":[],
      "TOTAL":{
        "NET_TOTAL":""
      },
      "MESSAGE":{
        "BOTTOM_MESSAGE":"THANK YOU"
      },
    };

    await writeJsonDataToFile(data);
  }
  writeJsonDataToFile(var jsonData) async {
    try {
      String jsonString = jsonEncode(jsonData);
      File file = File("C:/BEAMS/data.json");
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error writing JSON file: $e');
    }
  }



}

