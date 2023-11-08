
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/Charts/beams_barchart.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Pages/Login/userLogin.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {

  //Global
  Global g = Global();
  BeamsChart bc = BeamsChart();
  ApiCall apiCall =  ApiCall();
  late Future<dynamic>  futureDaily;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //Page variable
  var lstrToday ='';
  var lstrTodayFilter ='';
  var formatDate =  DateFormat('yyyy-MM-dd hh:mm:ss');
  var formatDateDb =  DateFormat('yyyy-MM-dd hh:mm:ss');
  var formatDateFilter =  DateFormat('dd-MM-yyyy');
  var formatDateText =  DateFormat('dd | MMM | yyyy');


  //Fliter
  var lstrDateFrom  = '';
  var lstrDateTo  = '';
  var lstrCounterNo  = '';
  var lstrShiftNo  = '';
  var lstrHour  = '';
  var lstrOrderType  = '';
  
  //DashBoard Values
  var lstrTotalSales  =  0.0;
  var lstrTodaySales  =  0.0;

  var totalSalesData  = [];
  var todaySalesData  = [];
  var typeWiseSalesData  = [];
  var hourWiseSalesData  = [];
  var shiftWiseSalesData  = [];
  var counterWiseSalesData  = [];
  var lstrData = [];
  var xColumn = "";
  var yColumnsCounter = [];
  var yColumnsType = [];

  ///Filter Mode :  T-Today A- All F -Filter
  var lstrFilterMode = "T";
  var lstrFilterModeTitle = "Today";
  bool isExpanded = false;
  bool isExpandedT = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    return Scaffold(
      body: Container(
        color: Colors.black87,
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: size.height,
                    width: size.width*0.18,
                    padding: EdgeInsets.only(left: 10,right: 10,bottom: 10,top: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          height: 170,
                          width: size.width*0.15,
                          decoration: boxBaseDecoration(Colors.white12, 30),
                          child: Column(
                            children: [
                              Image.asset("assets/icons/logoyellow.png",
                                width: 100,),
                              gapHC(10),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.person,color: Colors.white70,size: 15,),
                                    gapWC(5),
                                    tc(g.wstrUserName.toString(),Colors.white70,15)
                                  ],
                                ),
                              ),
                              gapHC(10),
                              Container(
                                height: 35,
                                decoration: boxBaseDecoration(Colors.black87, 40),
                                child: Center(
                                  child: tc('ADMIN', Colors.white70, 15),
                                ),
                              )

                            ],
                          ),
                        ),
                        gapHC(20),
                        Expanded(child: SingleChildScrollView(
                          child: Column(
                            children: [
                              line(),
                              gapHC(8),
                              Row(
                                children: [
                                  Icon(Icons.now_widgets_outlined,color: Colors.white70,size: 20,),
                                  gapWC(5),
                                  ts('Daily Analysis',Colors.white70,18)
                                ],
                              ),
                              gapHC(8),
                              line(),
                              gapHC(8),
                              Row(
                                children: [
                                  Icon(Icons.person_outline_rounded,color: Colors.white70,size: 20,),
                                  gapWC(5),
                                  ts('Staff Details',Colors.white70,18)
                                ],
                              ),
                              gapHC(8),
                              line(),
                              gapHC(8),
                              Row(
                                children: [
                                  Icon(Icons.date_range_outlined,color: Colors.white70,size: 20,),
                                  gapWC(5),
                                  ts('Daily Closing',Colors.white70,18)
                                ],
                              ),
                              gapHC(8),
                              line(),
                              gapHC(8),
                              Row(
                                children: [
                                  Icon(Icons.watch_later_outlined,color: Colors.white70,size: 20,),
                                  gapWC(5),
                                  ts('Clock In/Out',Colors.white70,18)
                                ],
                              ),
                              gapHC(8),
                              line(),
                              gapHC(30),
                            ],
                          ),
                        ),),
                        gapHC(20),
                        GestureDetector(
                          onTap: (){
                            fnLogout();
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 50,
                            decoration: boxBaseDecoration(Colors.black87, 40),
                            child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.power_settings_new_rounded,color: Colors.white70,),
                                    gapWC(10),
                                    tc('Logout', Colors.white70, 20),
                                  ],
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    
                    padding: EdgeInsets.all(20),
                    decoration: boxDecoration(Colors.white, 30),
                    height: size.height*0.93,
                    width: size.width*0.8,
                    child: Column(
                      children: [
                        gapHC(5),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end ,
                                children: [
                                  ts('Welcome to the', Colors.black, 20),
                                  gapWC(5),
                                  tc('Dashboard', Colors.black, 25)
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                      height:35,
                                      decoration: boxDecoration(Colors.amber, 30),
                                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                                      child:Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.date_range_sharp,color: Colors.black87,size: 16,),
                                          gapWC(10),
                                          tc(lstrToday.toUpperCase(), Colors.black87, 15)
                                        ],
                                      )
                                  ),
                                  gapWC(20),
                                  Icon(Icons.filter_alt_outlined,color: Colors.black,),
                                ],
                              )
                            ],
                          ),
                        ),
                        gapHC(30),
                        Expanded(child:
                        SingleChildScrollView(
                          child: animColumn([
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          lstrFilterMode = "A";
                                          isExpandedT =!isExpandedT;
                                        });
                                        fnGetDailySales("","");
                                      },
                                      child:  AnimatedContainer(
                                        duration: Duration(
                                          milliseconds: 1000,
                                        ),
                                        curve: Curves.bounceOut,
                                        height:isExpandedT ? 95 : 100,
                                        width: isExpandedT ? size.width*0.2:size.width*0.2,
                                        padding: EdgeInsets.all(10),
                                        decoration: boxBaseDecoration(yellowLight, isExpandedT ? 20 : 10),
                                        child: Row(
                                          children: [

                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ts('Total Sales', Colors.black87, 20),
                                                gapHC(2),
                                                tc(g.mfnCurr(lstrTotalSales), Colors.blue, 30)
                                              ],
                                            ),
                                            gapWC(10),
                                            Icon(Icons.bubble_chart_outlined,size: 50,color: Colors.amber,),
                                          ],
                                        ),
                                      ),
                                    ),

                                    gapHC(10),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          lstrFilterMode = "T";
                                          isExpanded =!isExpanded;
                                        });
                                        fnGetDailySales(lstrTodayFilter,lstrTodayFilter);
                                      },
                                      child: AnimatedContainer(
                                        duration: Duration(
                                          milliseconds: 1000,
                                        ),
                                        curve: Curves.bounceOut,
                                        height:isExpanded ? 95 : 100,
                                        width: isExpanded ? size.width*0.2:size.width*0.2,
                                        padding: EdgeInsets.all(10),
                                        decoration: boxBaseDecoration(blueLight, isExpanded ? 20 : 10),
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ts('Today Sales', Colors.black87, 20),
                                                gapHC(2),
                                                tc( g.mfnCurr(lstrTodaySales), Colors.blue, 30)
                                              ],
                                            ),
                                            gapWC(10),
                                            Icon(Icons.bubble_chart_outlined,size: 50,color: Colors.blue,),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                Bounce(
                                  child: Container(
                                    height: 210,
                                    width: size.width*0.27,
                                    decoration: boxDecoration(Colors.white, 20),
                                    child: bc.fnPDChart( "NET_AMT", "MACHINENAME", counterWiseSalesData,  "Counter wise",  "P"),
                                  ),
                                  duration: Duration(milliseconds: 110),
                                  onPressed: (){

                                  },
                                ),
                                Container(
                                  height: 210,
                                  width: size.width*0.27,
                                  decoration: boxDecoration(Colors.white, 20),
                                  child: bc.fnBlChart(yColumnsType, "ORDER_DESCP", typeWiseSalesData, fnGetFilterName() +' Type wise', 'C'),
                                )

                              ],
                            ),
                          ]),
                        ),)
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );
  }
  //=====================WIDGET UI============================

  //=====================PAGE FUNCTION==========================
  fnGetPageData(){
    var now = DateTime.now();
    yColumnsCounter = [];
    yColumnsType = [];
    yColumnsCounter.add({"COLUMN": "NET_AMT"});
    yColumnsType.add({"COLUMN": "NET_AMT"});
    setState(() {
      lstrToday = formatDateText.format(now);
      lstrTodayFilter = formatDateFilter.format(now);
      lstrDateFrom = lstrTodayFilter;
      lstrDateTo = lstrTodayFilter;
    });
    fnGetDailySales(lstrDateFrom,lstrDateTo);
  }
  //=====================OTHER FUNCTION =========================
  fnFillDailySales(){
    lstrTodaySales = 0.0;
    lstrTotalSales = 0.0;
      if(g.fnValCheck(totalSalesData)){
       setState(() {
         lstrTotalSales = g.mfnDbl(totalSalesData[0]["TOTAL_SALE"]);
       });
       if(g.fnValCheck(todaySalesData)){
         setState(() {
           lstrTodaySales =  g.mfnDbl(todaySalesData[0]["TOTAL_SALE"]);
         });
       }
    }
  }
  fnGetFilterName(){
      return lstrFilterMode == "A"?"Total" :lstrFilterMode == "T"?"Today":"Filter";
  }
  //=====================API CALL  =============================
  fnGetDailySales(dateFrom,dateTo){
    futureDaily =  apiCall.getDailySales(g.wstrCompany, dateFrom, dateTo, lstrCounterNo, lstrShiftNo, lstrHour, lstrOrderType);
    futureDaily.then((value) => fnGetDailySalesSuccess(value));
  }
  fnGetDailySalesSuccess(value){
     if(g.fnValCheck(value)){
       print("======================================DAILY SALES===============================");
       print(value);
       print("================================================================================");
       setState(() {
         totalSalesData  = value ["Table2"];
         todaySalesData  = value ["Table3"];
         typeWiseSalesData  = value ["Table1"];
         hourWiseSalesData  = value ["Table2"];
         shiftWiseSalesData  = value ["Table3"];
         counterWiseSalesData  = value ["Table4"];
       });
       fnFillDailySales();
     }
  }
  //======================NAVIGATION ==================

  fnLogout() async{
    final SharedPreferences prefs = await _prefs;

    prefs.setString('wstrUserCd', '');
    prefs.setString('wstrUserName', '');
    prefs.setString('wstrUserRole', '');
    prefs.setString('wstrCompany', g.wstrCompany);
    prefs.setString('wstrYearcode', g.wstrYearcode);
    prefs.setString('wstrLoginSts', 'N');
    prefs.setString('wstrTableView','');
    prefs.setString('wstrOrderScreenMode',"");

    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => Login()
    ));
  }

}
