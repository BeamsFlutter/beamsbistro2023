import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/responsiveHelper.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClockIn extends StatefulWidget {
  const ClockIn({Key? key}) : super(key: key);

  @override
  _ClockInState createState() => _ClockInState();
}

class _ClockInState extends State<ClockIn> {

  ApiCall apiCall = ApiCall();
  Global g = Global();

  late Future<dynamic> futureShift;
  late Future<dynamic> futureClockIn;

  var _radioValue = 0 ;
  var selectedShifCode = '';
  var selectedShifName= '';
  var formatDate = new DateFormat('dd MMMM yyyy');
  var formatTime = new DateFormat('hh:mm a');
  var formatTimeSecond = new DateFormat('hh:mm:ss a');
  var lstrToday = '';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnPageLoad();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    return WillPopScope(child: Scaffold(
      appBar: navigationAppBar(context,fnPageBack),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(children: [
            ResponsiveWidget(mobile:  mobileView(size), tab: mobileView(size), windows: windowView(size)),
            Container(
              child: Center(
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tc('BEAMS ',PrimaryColor,10),
                    tc('RESTAURANT ',SecondaryColor,10),
                  ],
                ),
              ),
            )
          ],),
        ),
      ),
    ),  onWillPop: () async{
      final SharedPreferences prefs = await _prefs;
      SystemNavigator.pop();
      return true;
    });
  }

  Container mobileView(Size size) {
    return Container(
            height: size.height * 0.9,
            width: size.width,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  gapHC(60),
                  tc('CLOCK-IN',PrimaryText,25),
                  gapHC(30),
                  tc(lstrToday.toString(),Colors.black,18),
                  gapHC(30),
                  Container(
                    height:size.height*0.1 ,
                    width: 400,
                    child: FutureBuilder<dynamic>(
                      future:  futureShift,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return  shiftView(snapshot) ;
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
                  tc(selectedShifName.toUpperCase().toString(),Colors.black,30),
                  gapHC(50),
                  GestureDetector(
                    onTap: (){
                      fnClockIn();
                    },
                    child: Container(
                      height: 220,
                      width: 220,
                      decoration: boxBaseDecoration(redLight, 200),
                      child: Center(
                        child: Container(
                          height: 180,
                          width: 180,
                          decoration: boxDecoration(Colors.white, 100),
                          child: Center(
                            child: Icon(
                              Icons.power_settings_new,size: 100,color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  gapHC(50),
                  tc(g.wstrUserName,PrimaryColor,35),
                  gapHC(10),
                  //sl4('Your last clock-out was : 09 JUNE 2021 11:00 pm'),
                  gapHC(10),
                  sl4('Have a nice day and enjoy your work'),
                  gapHC(200),


                ],
              ),
            ),
          );
  }
  Container windowView(Size size) {
    return Container(
      height: size.height * 0.85,
      width: size.width,
      child: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: size.width *0.5,
              height: size.height*0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  gapHC(60),
                  tc('CLOCK-IN',PrimaryColor,40),
                  gapHC(50),
                  Container(
                    height:size.height*0.5 ,
                    width: 500,
                    child: FutureBuilder<dynamic>(
                      future:  futureShift,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return  shiftView(snapshot) ;
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
                  gapHC(50),
                  tc(selectedShifName.toUpperCase().toString(),Colors.black,30),
                  tc(lstrToday.toString(),Colors.black,18),



                ],
              ),
            ),
            Container(
              decoration: boxDecoration(Colors.white, 10),
              height: size.height*0.8,
              width: size.width *0.4,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        fnClockIn();
                      },
                      child: Container(
                        height: 220,
                        width: 220,
                        decoration: boxBaseDecoration(redLight, 200),
                        child: Center(
                          child: Container(
                            height: 180,
                            width: 180,
                            decoration: boxDecoration(Colors.white, 100),
                            child: Center(
                              child: Icon(
                                Icons.power_settings_new,size: 100,color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    gapHC(50),
                    tc(g.wstrUserName,PrimaryColor,35),
                    gapHC(10),
                    //sl4('Your last clock-out was : 09 JUNE 2021 11:00 pm'),
                    gapHC(10),
                    sl4('Have a nice day and enjoy your work'),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget shiftView(snapshot){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            mainAxisExtent: 80,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data[index];
          var code = dataList["CODE"]??'';
          var name = dataList["DESCP"]??'';
          var startTimestartTime = dataList["FROM_TIME"]??'';
          var endTime = dataList["END_TIME"]??'';

          return Container(
              height: 60,
              padding: EdgeInsets.only(bottom: 5),
              child: Center(
                child: Row(
                  children: [
                    new Radio(
                      value: index,
                      groupValue: _radioValue,
                      activeColor: Colors.green,
                      onChanged: (value){
                        fnShiftRadioClick(code,name,index);
                      },
                    ),
                    GestureDetector(
                      onTap: (){
                        fnShiftRadioClick(code,name,index);
                      },
                      child: tc(name,Colors.black,20),
                    )
                  ],
                ),
              )
          );
        });

  }
  fnShiftRadioClick(code,name,index){
    setState(() {
      _radioValue = index;
      selectedShifCode = code;
      selectedShifName = name;
    });
  }

  //other
  fnPageLoad(){
    fnGetShift();
    setState(() {
      var now = DateTime.now();
      lstrToday = formatDate.format(now);
    });
  }

  //api
  fnGetShift() async{
    futureShift =  apiCall.getShift();
    futureShift.then((value) => fnGetShiftSuccess(value));
  }
  fnGetShiftSuccess(value){
    if(g.fnValCheck(value)){
      setState(() {
        selectedShifCode = value[0]["CODE"];
        selectedShifName = value[0]["DESCP"];
      });
    }
  }

  fnClockIn(){
    futureClockIn =  apiCall.colckInOut('IN', g.wstrUserCd, g.wstrCompany, selectedShifCode,g.wstrYearcode);
    futureClockIn.then((value) => fnClockInSuccess(value));
  }
  fnClockInSuccess(value) async{
    if(g.fnValCheck(value)){
      var dataList  =  value['Table1'][0];
      var sts = dataList["STATUS"].toString();
      var msg = dataList["MSG"];
      var clockInDate = dataList["CLOCKIN_DATE"].toString();
      final SharedPreferences prefs = await _prefs;
      prefs.setString('wstrShift',selectedShifCode);
      prefs.setString('wstrClockInDate',clockInDate);
      prefs.setString('wstrClockInSts','IN');
      prefs.setString('wstrShiftDescp',selectedShifName);
      g.wstrShifDescp = selectedShifName;

      g.wstrShifNo = selectedShifCode;
      g.wstrClockInDate = clockInDate;

        showToast( 'Welcome Back');

        if(g.wstrRoleCode == 'WAITER'){

          Navigator.pushReplacement(context, NavigationController().fnRoute(1));

        }else if(g.wstrRoleCode == 'CHEF'){
          Navigator.pushReplacement(context, NavigationController().fnRoute(10));

        }else if(g.wstrRoleCode == 'ADMIN'){

        }else if(g.wstrRoleCode == 'GENERAL'){

        }else if(g.wstrRoleCode == 'CASHIER'){
          Navigator.pushReplacement(context, NavigationController().fnRoute(9));

        }else if(g.wstrRoleCode == 'QUICK' || g.wstrRoleCode == 'QADMIN'){
          Navigator.pushReplacement(context, NavigationController().fnRoute(16));
        }else{
          Navigator.pushReplacement(context, NavigationController().fnRoute(9));
        }

      showToast( msg);
    }
  }

  fnPageBack(){
    Navigator.pushReplacement(context, NavigationController().fnRoute(11));
  }

}
