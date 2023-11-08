

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/lookup.dart';
import 'package:beamsbistro/Views/Components/lookup_alert.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:beamsbistro/Views/Pages/Bill/advance_amount.dart';
import 'package:beamsbistro/Views/Pages/Bill/payment.dart';
import 'package:beamsbistro/Views/Pages/QuickBill/quicksale.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';

class Booking extends StatefulWidget {
  const Booking({Key? key}) : super(key: key);

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {

  //Global
  ApiCall apiCall = ApiCall();
  Global g = Global();
  var wstrPageMode="VIEW";
  var wstrDoctype ="";

  late Future<dynamic> futureGetBooking;
  late Future<dynamic> futureGetBookingDet;
  late Future<dynamic> futureEvents;
  late Future<dynamic> futureGuest;
  late Future<dynamic> futureBooking;
  late Future<dynamic> futureBookingPrint;
  late Future<dynamic> futureBookingInvPrint;

  //Page Variable
  DateTime currentDate = DateTime.now();

    DateTime?  currentDate_From;
    DateTime?  currentDate_To ;

  DateTime dob = DateTime.now();
  TimeOfDay timeFrom = TimeOfDay(hour: 7, minute: 15);
  TimeOfDay timeTo   = TimeOfDay(hour: 7, minute: 15);
  TimeOfDay? timeFrom_Drawer ;
  TimeOfDay? timeTo_Drawer   ;
  var formatDate2 = new DateFormat('dd-MM-yyyy');
  var formatDateDB = new DateFormat('yyyy-MM-dd');
  var formatDate = new DateFormat('dd-MM-yyyy hh:mm');
  var formatDate1 = new DateFormat('yyyy-MM-dd hh:mm:ss');

  DateTime? _dateTime ;

  var lstrBookingMode= "V";
  var lstrSelectedOrderType = "A";
  var lstrScheduleSelection= "T";
  var lstrNoOfPersons = 1;
  var _radioValue =0 ;
  var  valueSelect;
  var lstrSelectedEvent = '' ;
  var lstrSelectedEventDescp = '' ;
  var lstrAreaDescp = '' ;
  var lstrAreaDescp_ = '' ;
  var lstrSelectedBookingNo = '';
  var lstrSelectedBookingSts  = '';
  var finalBillYn = 'N';
  var lstrSelectedBookingDocType = '';
  var lstrSelectedBookingYearcode = '';
  var lstrSelectedBookingDate = '';
  var lstrSelectedBookingUser = '';
  var lstrSelectedBookingInvNo = '';
  var lstrMobArea = "+971";
  var lstrToday;
  var lstrToday_Drawer;
  var lstrSelectedDocno  = '';
  var lstrSelectedUser  = '';
  var lstrSelectedDate = '';
  var lstrGuestMobile = '';
  var result_TIME=false;
  var clickFilter=false;
  var lstrSelectedInvDocno  = '';


  var lstrFinalBillAmount = 0.00;
  var lstrFinalBillBalance = 0.00;
  var lstrFinalBillAdvAmount = 0.00;

  int counter = 0;
  var lstrOrderQtyV = 0;
  var lstrLastGross = 0.00;
  var lstrLastVat = 0.00;
  var lstrLastTotal = 0.00;
  var lstrLastDiscount = 0.00;
  var lstrLastAddlAmount = 0.00;
  var lstrTaxable = 0.00;
  var lstrPaidAmt = 0.00;
  var lstrBalanceAmt = 0.00;
  var lstrAdvAmount = 0.00;
  var lstrOldAdvanceAmt = 0.0;
  var lstrAdvanceAmt = 0.0;
  var lstrBillAmt = 0.0;
  var lstrBkgBalanceAmt = 0.0;

  var lstrSelectedBookingItems = [];
  var lstrSelectedBookingAllItems = [];
  var lstrSelectedBookingTables = [];
  var lstrSelectedBookingInvoices = [];
  var lstrSelectedBookingInvoice = [];
  var lstrSelectedBooking = [];
  var lastOrder = [];
  var lstrSelectedBill = [];
  var lstrRetailPay = [];
  var lstrPaymentList = [];

  var lstrRsl = [];
  var lstrRslDet=[];
  var lstrRslBooking = [];
  var lstrRslDetBooking =[];
  var lstrRslBookingTable =[];
  var lstrRslVoid = [];
  var lstrRslVoidDet = [];
  var lstrRslAddlCharge = [];
  var lstrBookingGuest = [];
  var lstrSelectedRslItems = [];


  var txtCustMobileNo= TextEditingController();
  var txtCustomerName = TextEditingController();
  var txtCustomerCode = TextEditingController();
  var txtBPartyCode = TextEditingController();
  var txtBMobileNo = TextEditingController();
  var txtBPartyName = TextEditingController();
  var txtBMobile2 = TextEditingController();
  var txtBTele = TextEditingController();
  var txtBEmail = TextEditingController();
  var txtBAddress = TextEditingController();
  var txtBRemarks = TextEditingController();
  var txtBDob = TextEditingController();
  var txtNoOfPerson = TextEditingController();
  var txtArea = TextEditingController();

  var txtDocNum_D = TextEditingController();
  var txtGuestCode = TextEditingController();
  var txtArea_D = TextEditingController();
  //var txtMobile_D = TextEditingController();

  bool saveSts = true;
  bool printRslHistory = true;

  final GlobalKey<ScaffoldState> scaffoldKey =  GlobalKey<ScaffoldState> ();

  String lstrSelectedStatusMode = 'STATUS';
  String lstrSelectedMode_Drawer = '';
  List <String> lstrSelectedStatus = [
    'STATUS',
    'PENDING',
    'COMPLETED'
  ];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var now = DateTime.now();
    lstrToday = DateTime.parse(formatDate1.format(now));
    lstrToday_Drawer = DateTime.parse(formatDate1.format(now));
    fnGetPageData();
  }



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    return WillPopScope(child:
    Scaffold(
      key : scaffoldKey,
      drawer: Container(
        width: size.width * 0.3,
        child: Drawer(
          child: Container(
            margin: const EdgeInsets.only(top: 50,left: 10,right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundedInputField(
                  hintText: 'Doc No',
                  labelYn: 'Y',
                  labelColor: Colors.black,
                  txtRadius: 5,
                  txtWidth: 0.25,
                  txtController: txtDocNum_D,
                  suffixIcon: Icons.search,
                  suffixIconOnclick: (){
                    fnLookup('DOC_NUM','');
                  },
                ),

                RoundedInputField(
                  hintText: 'Guest Code',
                  labelColor: Colors.black,
                  labelYn: 'Y',
                  txtRadius: 5,
                  txtWidth: 0.25,
                  txtController: txtGuestCode,
                  suffixIcon: Icons.search,
                  suffixIconOnclick: (){
                    fnLookup('PARTYCODE_','');
                  },
                ),
                gapHC(10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc('Date From', Colors.black, 12),
                        gapHC(5),
                        GestureDetector(
                          onTap: (){
                            _selectDate_Drawer(context,'F');
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            //height: 35,
                            width: size.width*0.12,
                            //  height: 35,
                            decoration: boxDecoration(Colors.white, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.event_sharp, size: 20,),
                                tc(currentDate_From == null
                                    ? ''
                                    : formatDate2.format(currentDate_From!).toString(),Colors.black,15),

                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    gapWC(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc('Date To', Colors.black, 12),
                        gapHC(5),

                        GestureDetector(
                          onTap: (){
                            _selectDate_Drawer(context,'T');
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            //height: 35,
                            width: size.width*0.12,
                            //height: 35,
                            decoration: boxDecoration(Colors.white, 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.event_sharp, size: 20,),
                                tc(currentDate_To == null
                                    ? ''
                                    : formatDate2.format(currentDate_To!).toString(),Colors.black,15)
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                gapHC(10),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc('Time From', Colors.black, 12),
                        gapHC(5),
                        GestureDetector(
                          onTap: (){
                            _selectTime(context,'F');
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 15),
                            padding: EdgeInsets.all(10),
                            height: 35,
                            //height: 35,
                            width: size.width*0.12,
                            decoration: boxDecoration(Colors.white, 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.access_time, size: 20,),
                                gapWC(5),
                                tc(_dateTime == null
                                    ? ''
                                    : formatDate2.format(_dateTime!).toString(),Colors.black,15)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    gapWC(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        tc('Time To', Colors.black, 12),
                        gapHC(5),
                        GestureDetector(
                          onTap: (){
                            _selectTime(context,'T');
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 15),
                            padding: EdgeInsets.all(10),
                            height: 35,
                            //height: 35,
                            width: size.width*0.12,
                            decoration: boxDecoration(Colors.white, 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.access_time, size: 20,),
                                gapWC(5),
                                tc(timeTo_Drawer == null
                                    ? ''
                                    :timeTo_Drawer!.format(context).toString(),Colors.black,15)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                gapHC(10),


                Row(
                  children: [
                    RoundedInputField(
                      hintText: 'Area',
                      labelColor: Colors.black,
                      labelYn: 'Y',
                      txtRadius: 5,
                      txtWidth: 0.12,
                      txtController: txtArea_D,
                      suffixIcon: Icons.search,
                      suffixIconOnclick: (){
                        fnLookup('AREA_','');
                      },
                    ),
                    gapWC(10),
                    Container(
                      height: 40,
                      width: size.width*0.12,
                      // padding: const EdgeInsets.only(left: 30,),
                      decoration: boxBaseDecoration(blueLight, 5),
                      child:  Center(
                        child: DropdownButton<String>(
                          value: lstrSelectedStatusMode,
                          icon: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Icon(Icons.arrow_drop_down),
                          ),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(color: Colors.black, fontSize: 15),
                          underline: Container(
                            height: 0,
                            color: Colors.black26,
                          ),
                          onChanged: (data) {
                            setState(() {
                              lstrSelectedStatusMode = data.toString();
                              if(data.toString() != "STATUS"){
                                if(lstrSelectedStatusMode=='PENDING'){
                                  setState(() {
                                    lstrSelectedMode_Drawer ='P';
                                  });

                                }if(lstrSelectedStatusMode=='COMPLETED'){
                                  setState(() {
                                    lstrSelectedMode_Drawer ='C';
                                  });

                                }


                              }else{
                                lstrSelectedMode_Drawer = "";
                              }
                            });
                          },
                          items: lstrSelectedStatus.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),

                    ),
                  ],
                ),



                gapHC(30),
                Container(

                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          fnClearView();
                        },
                        child: Container(
                          width: size.width * 0.09,
                          height: 40,
                          decoration: boxDecoration(Colors.red, 30),

                          child: Center(child: tc('Clear', Colors.white, 14)),
                        ),
                      ),
                      gapWC(10),
                      GestureDetector(
                        onTap: (){
                          setState(() {
                            if (scaffoldKey.currentState!.isDrawerOpen) {
                              scaffoldKey.currentState?.openEndDrawer();
                              fnFilterItem();
                            }
                          });
                        },
                        child: Container(
                          width: size.width * 0.15,
                          height: 40,
                          decoration: boxDecoration(Colors.green, 30),

                          child: Center(child: tc('Apply Filter', Colors.white, 14)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: size.height,
                    width: size.width*0.7,
                    padding: EdgeInsets.only(top: 30,left: 10,right: 10,bottom: 10),
                    child: SingleChildScrollView(
                      child:wstrPageMode == "VIEW"?
                      (lstrBookingMode == "V"?
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start  ,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          gapHC(10),
                          tc('Booking Details', Colors.black, 25),
                          gapHC(15),
                          Row(
                            children: [
                              scheduleCard('A','ALL'),
                              scheduleCard('T','TODAY'),
                              scheduleCard('U','UPCOMING'),
                              scheduleCard('C','COMPLETED'),
                              scheduleCard('P','PENDING'),
                              scheduleCard('F','FILTER'),
                              /*gapWC(10),
                              GestureDetector(
                                  onTap: (){
                                    if(!clickFilter){
                                      setState(() {
                                        clickFilter = true;
                                      });
                                    }else{
                                      setState(() {
                                        clickFilter = false;
                                      });
                                    }

                                    setState(() {
                                      lstrScheduleSelection = 'F';
                                      scaffoldKey.currentState?.openDrawer();
                                    }); 
                                  },
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                    decoration: boxDecoration(blackYellow, 5),
                                  child: Row(
                                    children: [
                                      ts('FILTER',Colors.black,15),
                                      Icon(
                                        Icons.filter_list_outlined,
                                        size: 25,
                                        color : blackBlue
                                      ),
                                    ],
                                  ),
                                ),
                              )*/

                            ],
                          ),
                          gapHC(20),
                          Container(
                            height: size.height*0.8,
                            child: FutureBuilder<dynamic>(
                              future: futureGetBooking,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return bookingView(snapshot,size);
                                } else if (snapshot.hasError) {
                                  return Container();
                                }
                                // By default, show a loading spinner.
                                return Center(
                                  child: Container(),
                                );
                              },
                            ),
                          )

                        ],
                      ):
                      Container(
                        height: size.height*0.8,
                        child: FutureBuilder<dynamic>(
                          future: futureGetBookingDet,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return bookingInvoiceView(snapshot);
                            } else if (snapshot.hasError) {
                              return Container();
                            }
                            // By default, show a loading spinner.
                            return Center(
                              child: Container(),
                            );
                          },
                        ),
                      )

                      ):
                      Column (
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          tc(wstrPageMode == "ADD"?'New Booking':'Update Booking',Colors.black,25),
                          gapHC(10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(

                                  padding: EdgeInsets.all(10),
                                  width:size.width*.4,
                                  height: size.height*0.85,
                                  decoration: boxBaseDecoration(Colors.white, 15),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        tc('BOOKING#  '+ lstrSelectedBookingNo,Colors.black,15),
                                        gapHC(10),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Visibility(
                                              visible: true,
                                              child:  RoundedInputField(
                                                hintText: 'Search',
                                                labelYn: 'Y',
                                                txtRadius: 5,
                                                txtWidth: 0.36,
                                                txtController: txtBPartyCode,
                                                suffixIcon: Icons.search,
                                                suffixIconOnclick: (){
                                                  fnLookup('PARTYCODE','');
                                                },
                                              ),),

                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: size.width * 0.05,
                                              margin: EdgeInsets.only(right: 10),
                                              decoration: boxBaseDecoration(Colors.amber, 5),
                                              child: Center(
                                                child: tc(lstrMobArea,Colors.black,13),
                                              ),
                                            ),
                                            RoundedInputField(
                                                hintText: 'Mobile No',
                                                labelYn: 'Y',
                                                txtRadius: 5,
                                                txtWidth: 0.3,
                                                maxLength: 10,
                                                textType: TextInputType.number,
                                                txtController: txtBMobileNo,
                                                suffixIcon: Icons.search,
                                                suffixIconOnclick: (){
                                                  fnGetGuest();
                                                },
                                                numberFormat :'Y'
                                            ),
                                          ],
                                        ),
                                        RoundedInputField(
                                          hintText: 'Party Name',
                                          labelYn: 'Y',
                                          txtRadius: 5,
                                          txtController: txtBPartyName,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            RoundedInputField(
                                                hintText: 'Mobile 2',
                                                labelYn: 'Y',
                                                txtRadius: 5,
                                                txtWidth: 0.18,
                                                maxLength: 10,
                                                textType: TextInputType.number,
                                                txtController: txtBMobile2,
                                                numberFormat :'Y'
                                            ),
                                            RoundedInputField(
                                              hintText: 'Telephone',
                                              labelYn: 'Y',
                                              txtRadius: 5,
                                              txtWidth: 0.18,
                                              textType: TextInputType.number,
                                              txtController: txtBTele,
                                              numberFormat: 'Y',
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            RoundedInputField(
                                              hintText: 'Email',
                                              labelYn: 'Y',
                                              txtRadius: 5,
                                              txtWidth: 0.24,
                                              textType: TextInputType.emailAddress,
                                              txtController: txtBEmail,
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                _selectDob(context);
                                              },
                                              child: RoundedInputField(
                                                hintText: 'Dob',
                                                labelYn: 'Y',
                                                txtRadius: 5,
                                                txtWidth: 0.12,
                                                enablests: false,
                                                txtController: txtBDob,
                                              ),
                                            )
                                            ,
                                          ],
                                        ),


                                        RoundedInputField(
                                          hintText: 'Address',
                                          labelYn: 'Y',
                                          txtRadius: 5,
                                          txtController: txtBAddress,
                                        ),
                                        RoundedInputField(
                                          hintText: 'Remarks',
                                          labelYn: 'Y',
                                          txtRadius: 5,
                                          txtController: txtBRemarks,
                                        ),


                                      ],
                                    ),
                                  )
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                width: size.width*.25,
                                height: size.height*0.85,
                                decoration: boxBaseDecoration(Colors.white, 15),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: size.height*0.4,
                                        child: FutureBuilder<dynamic>(
                                          future: futureEvents,
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return   eventView(snapshot) ;
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
                                      gapHC(5),
                                      RoundedInputField(
                                        hintText: 'Area',
                                        labelYn: 'Y',
                                        txtRadius: 5,
                                        txtWidth: 0.2,
                                        txtController: txtArea,
                                        suffixIcon: Icons.search,
                                        suffixIconOnclick: (){
                                          fnLookup('AREA','');
                                        },
                                      ),
                                      tc('Event Date', Colors.black, 12),
                                      gapHC(5),

                                      GestureDetector(
                                        onTap: (){
                                          _selectDate(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(10),
                                          height: 35,
                                          decoration: boxBaseDecoration(blueLight, 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Icon(Icons.event_sharp, size: 20,),
                                              tc(formatDate2.format(currentDate).toString(),Colors.black,15)
                                            ],
                                          ),
                                        ),
                                      ),

                                      gapHC(5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              tc('Time From ', Colors.black, 12),
                                              gapHC(5),
                                              GestureDetector(
                                                onTap: (){
                                                  _selectTimeFrom(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  height: 35,
                                                  width: size.width*0.1,
                                                  decoration: boxBaseDecoration(blueLight, 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Icon(Icons.access_time, size: 20,),
                                                      gapWC(5),
                                                      tc(timeFrom.format(context).toString(),Colors.black,15)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              tc('Time To ', Colors.black, 12),
                                              gapHC(5),
                                              GestureDetector(
                                                onTap: (){
                                                  _selectTimeTo(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(10),
                                                  height: 35,
                                                  width: size.width*0.1,
                                                  decoration: boxBaseDecoration(blueLight, 5),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Icon(Icons.access_time, size: 20,),
                                                      gapWC(5),
                                                      tc(timeTo.format(context).toString(),Colors.black,15)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),

                                      gapHC(10),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          RoundedInputField(
                                            hintText: 'No.Of. Person',
                                            labelYn: 'Y',
                                            txtWidth: 0.15,
                                            txtRadius: 5,
                                            txtController: txtNoOfPerson,
                                            textType: TextInputType.number,
                                          ),
                                          GestureDetector(
                                            onTap: (){

                                              setState(() {
                                                if(txtNoOfPerson.text.isNotEmpty){
                                                  lstrNoOfPersons = int.parse(txtNoOfPerson.text.toString());
                                                }else{
                                                  lstrNoOfPersons = 0;
                                                }
                                                if(lstrNoOfPersons >1){
                                                  lstrNoOfPersons -=1;
                                                  txtNoOfPerson.text = lstrNoOfPersons.toString();
                                                }
                                              });
                                            },
                                            onLongPress: (){
                                              setState(() {
                                                lstrNoOfPersons =1;
                                                txtNoOfPerson.text = lstrNoOfPersons.toString();
                                              });
                                            },
                                            child:  Container(
                                              height: 40,
                                              width: 50,
                                              decoration: boxBaseDecoration(Colors.amber , 5),
                                              child: Center(
                                                child: Icon(Icons.remove_circle_outline,size: 15,),
                                              ),
                                            ),
                                          )
                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      decoration: boxDecoration(Colors.white, 0),
                      padding: EdgeInsets.only(top: 30,left: 10,right: 10,bottom: 10),
                      height: size.height,
                      width: size.width*0.3,
                      child:  SingleChildScrollView(
                        child: wstrPageMode =="VIEW"?
                        (lstrBookingMode == "V"? Column(
                          children: [
                            Container(
                                child: lstrSelectedBookingNo.isEmpty?
                                Container(
                                  height:  size.height*0.9,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      gapHC(10),
                                      Column(
                                        children: [
                                          Image.asset("assets/icons/ticket.png",
                                            width: 200,),
                                          gapHC(10),
                                          ts("  Select Booking".toString(),greyLight,15),

                                        ],
                                      ),
                                      Column(
                                        children: [
                                          // GestureDetector(
                                          //   onTap: (){
                                          //
                                          //     fnPageMode("ADD");
                                          //   },
                                          //   child:  Container(
                                          //     height: 40,
                                          //     decoration: boxDecoration(Colors.amber, 30),
                                          //     child: Center(
                                          //       child: ts('New Booking',Colors.black,18),
                                          //     ),
                                          //   ),
                                          // ),
                                          gapHC(10),
                                          GestureDetector(
                                            onTap: (){
                                              fnClose();
                                            },
                                            child:  Container(
                                              height: 40,
                                              decoration: boxDecoration(PrimaryColor, 30),
                                              child: Center(
                                                child: tc('Close',Colors.white,18),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ):
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        tc('Order #' +lstrSelectedBookingNo.toString() , Colors.black, 15),
                                        tc('BOOKING' , PrimaryColor, 15),
                                      ],
                                    ),
                                    gapHC(5),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.sticky_note_2_outlined,size: 13,),
                                            gapWC(5),
                                            ts(lstrSelectedBookingUser.toString(),Colors.black,12),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time_sharp,size: 13,),
                                            gapWC(5),
                                            ts(lstrSelectedBookingDate.toString(),Colors.black,12),
                                          ],
                                        ),
                                      ],
                                    ),
                                    gapHC(5),
                                    line(),
                                    Container(
                                        height: size.height*0.5,
                                        child: bookingItemView()
                                    ),
                                    line(),
                                    gapHC(5),
                                    g.fnValCheck(lstrSelectedBookingTables)?
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        tc('Selected Tables',Colors.black,15),
                                        gapHC(5),
                                        Container(
                                          height: 30,
                                          child: bookingTablesView(),
                                        ),
                                      ],
                                    ):gapHC(0),
                                    gapHC(5),
                                    Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              tc('ADVANCE PAYMENT', Colors.black, 10),
                                              tc(lstrAdvanceAmt.toString(), Colors.red, 12),
                                            ],
                                          ),
                                          gapHC(5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              tc('BILL AMOUNT', Colors.black, 10),
                                              tc(lstrBillAmt.toString(), Colors.red, 12),
                                            ],
                                          ),
                                        //
                                          gapHC(5),
                                          line(),
                                          gapHC(5),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              lstrSelectedBookingSts == "D"?
                                              tc( 'PAID '+lstrBillAmt.toString(), Colors.red, 25):
                                              tc( 'TOTAL '+lstrBkgBalanceAmt.toString(), Colors.red, 25),
                                            ],
                                          ),
                                        ],
                                      ),

                                    ),
                                    gapHC(10),
                                    line(),
                                    gapHC(10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: (){
                                            if(lstrSelectedBookingSts == "D" && lstrSelectedInvDocno !=""){
                                              fnPrintBookingInvoice(lstrSelectedInvDocno);
                                            }else{
                                              fnPrintBooking(lstrSelectedBookingNo,lstrSelectedBookingDocType);
                                            }

                                          },
                                          child: Container(
                                            height: 30,
                                            width: size.width*0.09,
                                            decoration: boxBaseDecoration(greyLight, 5),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.print,size: 15,),
                                                  ts('PRINT',Colors.black,15)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ) ,
                                        lstrSelectedBookingSts == "D"?
                                        gapWC(0):
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              lstrAdvAmount = lstrOldAdvanceAmt;
                                            });

                                            fnPageMode("EDIT");
                                          },
                                          child: Container(
                                            height: 30,
                                            width: size.width*0.09,
                                            decoration: boxBaseDecoration(greyLight, 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.edit,size: 15,),
                                                ts('EDIT',Colors.black,15)
                                              ],
                                            ),
                                          ) ,
                                        ),
                                        lstrSelectedBookingSts == "D"?
                                        gapWC(0) :
                                        GestureDetector(
                                          onTap: (){
                                            fnDeleteAlert();
                                          },
                                          child:  Container(
                                            height: 30,
                                            width: size.width*0.09,
                                            decoration: boxBaseDecoration(greyLight, 5),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.delete,size: 15,),
                                                ts('DELETE',Colors.black,15)
                                              ],
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                    gapHC(10),

                                    lstrSelectedBookingSts != "D" ?
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          lstrBookingMode = "G";
                                        });
                                        fnFinalBillCalc();
                                      },
                                      child: Container(
                                        height: 40,
                                        decoration: boxBaseDecoration(Colors.green, 30),
                                        child: Center(
                                          child: ts('Invoice Summary',Colors.white,18),
                                        ),
                                      ),
                                    ) :
                                    Container(),
                                    gapHC(10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // GestureDetector(
                                        //   onTap: (){
                                        //     fnPageMode("ADD");
                                        //   },
                                        //   child:  Container(
                                        //     height: 40,
                                        //     width: size.width*.18,
                                        //     decoration: boxBaseDecoration(Colors.amber, 30),
                                        //     child: Center(
                                        //       child: ts('New Booking',Colors.black,15),
                                        //     ),
                                        //   ),
                                        // ),
                                        GestureDetector(
                                          onTap: (){
                                            fnClose();
                                          },
                                          child:  Container(
                                            height: 40,
                                            width: size.width*.1,
                                            decoration: boxBaseDecoration(PrimaryColor, 30),
                                            child: Center(
                                              child: tc('Close',Colors.white,15),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),


                                  ],
                                )),
                          ],
                        ):
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                tc('Invoice #' +lstrSelectedBookingInvNo.toString() , Colors.black, 15),
                                tc("" , PrimaryColor, 15),
                              ],
                            ),
                            gapHC(5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.sticky_note_2_outlined,size: 13,),
                                    gapWC(5),
                                    ts(lstrSelectedUser,Colors.black,12),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.access_time_sharp,size: 13,),
                                    gapWC(5),
                                    ts(lstrSelectedDate,Colors.black,12),
                                  ],
                                ),
                              ],
                            ),
                            gapHC(5),
                            line(),
                            Container(
                                height: size.height*0.45,
                                child: rslItemView()
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  gapHC(5),
                                  line(),

                                  gapHC(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ts('Taxable Amount', Colors.black, 16),
                                      ts(lstrTaxable.toStringAsFixed(2), Colors.black, 16)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ts('Vat Amount', Colors.black, 16),
                                      ts(lstrLastVat.toStringAsFixed(2), Colors.black, 16)
                                    ],
                                  ),
                                  gapHC(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ts('Additional Amount', Colors.black, 16),
                                      ),
                                      tc(lstrLastAddlAmount.toStringAsFixed(2),Colors.black,15)
                                    ],
                                  ),
                                  gapHC(10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      tc('Bill Amount', Colors.black, 18),
                                      tc(lstrLastTotal.toStringAsFixed(2), Colors.black, 18)
                                    ],
                                  ),
                                  gapHC(5),
                                  line(),
                                  gapHC(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      tc('Total Invoice Amount', Colors.black, 18),
                                      tc(lstrFinalBillAmount.toStringAsFixed(2), Colors.black, 18)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ts('Advance Amount', Colors.black, 18),
                                      ts(lstrFinalBillAdvAmount.toStringAsFixed(2), Colors.black, 18)
                                    ],
                                  ),
                                  gapHC(5),
                                  line(),
                                  gapHC(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      tc(lstrFinalBillBalance.toStringAsFixed(2),Colors.red,30)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      tc('FINAL BILL AMOUNT',Colors.black,15)
                                    ],
                                  ),
                                  gapHC(15),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            lstrBookingMode = "V";
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                          height: 40,
                                          width: size.width*0.1,
                                          decoration: boxBaseDecoration(greyLight, 30),
                                          child: Center(
                                            child: tc(' Close',Colors.black,15),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            lstrBookingMode = "V";

                                          });

                                          fnGetBooking(null, null, null, lstrScheduleSelection);
                                          fnFinalBill();
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                          height: 40,
                                          width: size.width*0.15,
                                          decoration: boxBaseDecoration(PrimaryColor, 30),
                                          child: Center(
                                            child: tc(' FINAL BILL',Colors.white,15),
                                          ),
                                        ),
                                      )

                                    ],
                                  )

                                  // Container(
                                  //   padding: EdgeInsets.all(5),
                                  //   color: greyLight,
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       tc('Total Amount', Colors.red, 18),
                                  //       gapW(),
                                  //       tc(lstrOrderAmountV.toStringAsFixed(2), Colors.red, 20),
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                            gapHC(5),


                          ],
                        )

                        ):
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            line(),
                            Container(
                                height: size.height*0.43,
                                child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: lastOrder.length,
                                    itemBuilder: (context, index) {
                                      var dataList = lastOrder[index];
                                      var itemCode = dataList['DISHCODE'] ??'';
                                      var itemName = dataList['DISHDESCP']??'';
                                      var waitingTime = dataList['WAITINGTIME']??'';
                                      var itemPrice = dataList['PRICE1']??'0.0';
                                      var itemQty = dataList['QTY']??'0.0';
                                      var itemSts = '';
                                      var itemClearedQty = 0;
                                      var itemClearedQtyS = '';
                                      var itemNote = dataList['NOTE']??'';
                                      itemSts = dataList["OLD_STATUS"].toString();
                                      itemClearedQty = g.mfnInt(dataList["CLEARED_QTY"]);
                                      itemClearedQtyS = itemClearedQty == 0 ? '' :itemClearedQty.toString();

                                      return GestureDetector(
                                        onTap: (){
                                          fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
                                        },
                                        onLongPress: (){
                                          //double.parse(itemQty) > 0? fnShowNotePopupSelected(dataList):'';
                                          //fnGetAddOnCombo('ADDON',itemCode,dataList);
                                        },
                                        child: Container(
                                          height: 60,
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(bottom: 5),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[

                                                    Expanded(child: GestureDetector(
                                                      child: Container(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            tc(itemName.toString() + '   x ' + itemQty.toString(),Colors.black,15),
                                                            gapHC(2),
                                                            ts('AED  ' + itemPrice.toString(),PrimaryColor,14),
                                                            //catS('AED  ' + itemPrice.toString()),
                                                            gapHC(2),

                                                          ],
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                        child:  GestureDetector(
                                                          onTap: (){
                                                            double.parse(itemQty) > 0?
                                                            fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty):''
                                                            ;
                                                          },
                                                          onLongPress: (){
                                                            fnRemoveItemSelected(dataList);
                                                            // fnRemoveItemSelected(dataList,orderData);
                                                          },
                                                          child: Container(
                                                            width:60,
                                                            height:40,
                                                            margin: EdgeInsets.all(10),
                                                            decoration: boxDecoration(double.parse(itemQty) >0? Colors.white: Colors.red, 5),
                                                            child: Center(
                                                              child: Icon(Icons.remove_circle_outline_outlined,color: Colors.black,size: 25,),
                                                            ),
                                                          ),
                                                        )
                                                    )
                                                  ],
                                                ),
                                                itemNote == ""?Container():
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                  child:  ts('Note : '+itemNote,Colors.black,15),
                                                )
                                              ],
                                            ),
                                          ),
                                          decoration: boxBaseDecoration(blueLight, 7),
                                        ),
                                      );
                                    })
                            ),
                            Container(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  gapHC(5),
                                  line(),
                                  gapHC(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      tc('Selected Items', Colors.black, 16),
                                      gapW(),
                                      tc((lastOrder.length).toString(), Colors.black, 18),
                                    ],
                                  ),
                                  gapHC(5),
                                  line(),
                                  gapHC(5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ts('Taxable Amount', Colors.black, 16),
                                      ts(lstrTaxable.toStringAsFixed(2), Colors.black, 16)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ts('Vat Amount', Colors.black, 16),
                                      ts(lstrLastVat.toStringAsFixed(2), Colors.black, 16)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ts('Advance Amount', Colors.black, 16),
                                      GestureDetector(
                                        onTap: (){
                                          print('SSSSSSSSSSSSSSSSSSSSSSSSS');
                                          print(lstrAdvAmount);
                                          fnAdvanceAmount();
                                        },
                                        child: Container(
                                          width: 100,
                                          padding: EdgeInsets.only(top: 8,bottom: 8),
                                          decoration: boxBaseDecoration(greyLight, 2),
                                          child:  Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              tc(lstrAdvAmount.toStringAsFixed(2), Colors.black, 16)
                                            ],
                                          ),
                                        ),
                                      )

                                    ],
                                  ),

                                  gapHC(10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      tc('Net Amount', Colors.black, 18),
                                      tc(lstrLastTotal.toStringAsFixed(2), PrimaryColor, 18)
                                    ],
                                  ),
                                  gapHC(10),


                                  // Container(
                                  //   padding: EdgeInsets.all(5),
                                  //   color: greyLight,
                                  //   child: Row(
                                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       tc('Total Amount', Colors.red, 18),
                                  //       gapW(),
                                  //       tc(lstrOrderAmountV.toStringAsFixed(2), Colors.red, 20),
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: (){
                                    g.wstrTableUpdateMode = 'B';
                                    Navigator.push(context, NavigationController().fnRoute(7));
                                  },
                                  child: Container(
                                    height: 30,
                                    width: size.width*.14,
                                    decoration: boxBaseDecoration(Colors.amber, 5),
                                    child: Center(
                                      child: ts('ADD TABLE',Colors.black,15),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    fnAddItem();
                                  },
                                  child: Container(
                                    height: 30,
                                    width: size.width*.14,
                                    decoration: boxBaseDecoration(Colors.amber, 5),
                                    child: Center(
                                      child: ts('ADD ITEM',Colors.black,15),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            gapHC(10),
                            GestureDetector(
                              onTap: (){
                                saveSts ?fnBookingSaveAlert():'';
                              },
                              child: Container(
                                height: 40,
                                decoration: boxBaseDecoration(Colors.green, 30),
                                child: Center(
                                  child: tc('SAVE',Colors.white,15),
                                ),
                              ),
                            ),
                            gapHC(10),
                            GestureDetector(
                              onTap: (){
                                fnClose();
                              },
                              child: Container(
                                height: 40,
                                decoration: boxBaseDecoration(PrimaryColor, 30),
                                child: Center(
                                  child: tc('Close',Colors.white,15),
                                ),
                              ),
                            )

                          ],
                        ),
                      )
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ), onWillPop: () async{
      return fnClose();
    });
  }

  //============================WIDGET UI ================================
  Widget bookingView(snapshot,Size size){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio:  .6,
            crossAxisSpacing: 15,
            mainAxisSpacing: 10),
        itemCount:  snapshot.data['Table1'].length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data['Table1'][index];
          var bookingNo = dataList['DOCNO']??'';
          var bookingDocType = dataList['DOCTYPE']??'';
          var bookingYearcode = dataList['YEARCODE']??'';
          var partyCode = dataList['PARTYCODE']??'';
          var partyName = dataList['PARTYNAME']??'';
          var advAmount = dataList['ADV_AMT']??'';

          var partyMobile = dataList['PARTY_MOBILE']??'';
          var bookingDate = dataList['BOOKING_DATE']??'';
          var bookingTimeFrom = dataList['BOOKING_TIME_FROM']??'';
          var bookingTimeTo = dataList['BOOKING_TIME_TO']??'';
          var eventCode = dataList['EVENT_CODE']??'';
          var eventName = dataList['EVENT_DESCP']??'';
          var area = dataList['AREA_DESCP']??'';
          var createUser = dataList['CREATE_USER']??'';
          var noOfPersons = dataList['NO_PERSON']??'';
          var sts = dataList['STATUS']??'';
          var adv = g.mfnDbl(dataList['ADV_AMT']);
          var net = g.mfnDbl(dataList['NETAMT']);
          var billAmount = g.mfnDbl(dataList['TOTAL_BILL_AMT']);  // dataList['ADV_AMT']??'';
          var balanceAmount = billAmount - adv;  // dataList['ADV_AMT']??'';
          var invdocno = dataList['INV_DOCNO']??"";
          print('STATUS________1'+sts);
          print('STATUS________2'+lstrScheduleSelection);

          return  GestureDetector(
            onTap: (){

              setState(() {
                lstrSelectedBookingTables = [];
                lstrSelectedBooking =[];
                lstrSelectedBookingItems = [];
                lstrSelectedBookingAllItems= [];
                lstrSelectedBookingInvoice = [];
                lstrSelectedBookingInvoices = [];
                lstrSelectedBookingNo = bookingNo;
                lstrSelectedBookingSts = sts;
                lstrSelectedBookingDocType = bookingDocType;
                lstrSelectedBookingYearcode = bookingYearcode;
                lstrSelectedBookingDate = formatDate2.format(DateTime.parse(bookingDate.toString()));
                lstrSelectedBookingUser = createUser;
                wstrDoctype= bookingDocType;
                lstrAdvanceAmt = adv;
                lstrBillAmt = billAmount;
                lstrBkgBalanceAmt = balanceAmount;
                lstrOldAdvanceAmt =   dataList['ADV_AMT'] ??0.0;
                print('-----------------------------------++++++++++++++++++++++-----------------');
                print(lstrOldAdvanceAmt);

              });
              fnGetBookingDet(bookingNo);



            },
            child: ClipPath(
              clipper: MovieTicketClipper(),
              child: Container(
                height: size.height * 0.2,
                padding: EdgeInsets.all(10),
                decoration: boxDecoration(lstrSelectedBookingNo ==bookingNo? blueLight: Colors.white, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        th('#' +bookingNo.toString(),Colors.red,13),
                        Container(
                          padding: EdgeInsets.only(top: 2,bottom: 2,left: 6,right: 6),
                          decoration: boxDecoration(sts == "D"? Colors.green:Colors.orange, 30),
                          child:  tcn(sts == "D"? "Payment Done":"Pending" ,Colors.white,10),
                        ),
                      ],
                    ),

                    gapHC(5),
                    Row(
                      children: [
                        Expanded(child:   tc(partyName.toString(), Colors.black, 12),)
                      ],
                    ),
                    gapHC(5),
                    Row(
                      children: [
                        Expanded(child:   tc('Event : '+eventName.toString(), Colors.black, 12),)
                      ],
                    ),
                    gapHC(5),
                    Row(
                      children: [
                        Expanded(child:   tc('Area : '+area.toString(), Colors.black, 12),)
                      ],
                    ),
                    gapHC(5),
                    invdocno != ""?
                    Row(
                      children: [
                        Expanded(child:   tc('INVOICE# : '+invdocno.toString(), Colors.black, 12),)
                      ],
                    ):gapHC(0),
                    gapHC(5),
                    line(),
                    gapHC(2),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,size: 10,),
                        gapWC(5),
                        ts(formatDate2.format(DateTime.parse(bookingDate.toString())), Colors.black, 12)
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time_outlined,size: 10,),
                        gapWC(5),
                        ts(bookingTimeFrom.toString(), Colors.black, 12),
                        ts('  to  ', Colors.black, 12),
                        ts(bookingTimeTo.toString(), Colors.black, 12),
                      ],
                    ),
                    gapHC(2),
                    line(),
                    gapHC(5),
                    tc('Details', Colors.black, 12),
                    gapHC(5),
                    Row(
                      children: [
                        Icon(Icons.people_outline_rounded,size: 12,color: Colors.black,),
                        gapWC(5),
                        ts(noOfPersons.toString(), Colors.black, 12),
                      ],
                    ),
                    gapHC(2),
                    Row(
                      children: [
                        Icon(Icons.phone,size: 12,color: Colors.black),
                        gapWC(5),
                        ts(partyMobile.toString(), Colors.black, 12),
                      ],
                    ),

                    gapHC(5),
                    line(),
                    gapHC(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tc('ADVANCE PAYMENT', Colors.black, 10),
                        tc(advAmount.toString(), Colors.red, 12),
                      ],
                    ),
                    gapHC(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        tc('BILL AMOUNT', Colors.black, 10),
                        tc(billAmount.toString(), Colors.red, 12),
                      ],
                    ),
                    gapHC(5),
                    line(),
                    gapHC(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        tc(sts == "D"?'PAID AMOUNT':'BALANCE TO PAY', Colors.black, 10),
                      ],
                    ),
                    gapHC(2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        tc(sts == "D"?billAmount.toString(): balanceAmount.toString(), Colors.red, 30),
                      ],
                    ),




                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 30,
                          width: 120,
                          decoration: boxBaseDecoration(sts == "D"?Colors.green:Colors.amber, 5),
                          child: Center(
                            child: tc(sts == "D"? "PAYMENT DONE":"VIEW", sts == "D"?Colors.white:Colors.black, 10),
                          ),
                        )
                      ],
                    )*/

                  ],
                ),
              ),
            ),
          );
        });
  }
  Widget bookingItemView(){
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: lstrSelectedBookingAllItems.length,
        itemBuilder: (context, index) {
          var dataList = lstrSelectedBookingAllItems[index];
          var lstrOrderNo  =  dataList["DOCNO"];
          var itemCode = dataList['STKCODE'];
          var itemName = dataList['STKDESCP'];
          var itemQty = dataList['QTY1'].toString();
          var itemStatus = dataList['STATUS'].toString();
          var itemRate = dataList['RATE'].toString();
          var itemTotal = double.parse(itemQty)  * double.parse(itemRate);
          return GestureDetector(
            onTap: (){

            },
            child: itemStatus == 'C' ? Container():  Container(
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              margin: EdgeInsets.only(bottom: 5),
              decoration: boxBaseDecoration(greyLight, 3),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: tc((index+1).toString() +'. '+itemName,Colors.black,14),),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        child: tc(itemRate.toString() ,Colors.black,13),
                      ),
                      Container(
                        width: 50,
                        child: tc('x'+itemQty.toString(),Colors.black,13),
                      ),
                      Container(
                        width: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            tc(itemTotal.toString(),PrimaryColor,14),
                          ],
                        )
                      ),

                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
  Widget bookingTablesView(){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: lstrSelectedBookingTables.length,
        itemBuilder: (context, index) {
          var dataList = lstrSelectedBookingTables[index];
          var code = dataList['TABLE_CODE']??'';
          var tableDescp = dataList['TABLE_DESCP']??'';
          return tableDescp != ""? GestureDetector(
            onTap: (){
            },
            child:  Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              margin: EdgeInsets.only(right:10),
              decoration: boxBaseDecoration( blueLight , 5),
              child: Center(
                child: tc(tableDescp, Colors.black,15),
              ),
            ),
          ):Container();
        });
  }
  Widget eventView(snapshot){

    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data[index];
          var eventCode = dataList['CODE'] ??'';
          var eventDescp = dataList['DESCP']??'';
          return GestureDetector(
            onTap: (){
              fnEventRadioClick(eventCode,eventDescp,index);
            },
            child: Container(
              height: 35,
              decoration: boxDecoration(Colors.amber, 30),
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                children: [
                  Radio<int>(
                    value: index,
                    groupValue: valueSelect = fnCheckSelectedEvent(snapshot.data),
                    onChanged: (value) {
                      fnEventRadioClick(eventCode,eventDescp,index);
                      setState(() => valueSelect = value!);
                    },
                  ),
                  GestureDetector(
                    onTap: (){
                      fnEventRadioClick(eventCode,eventDescp,index);
                    },
                    child: ts(eventDescp,Colors.black,12),
                  )

                  /*Transform.scale(scale: 0.7,
                    child: new Radio(
                      value: index,
                      groupValue: _radioValue = fnCheckSelectedEvent(index,eventCode), //assignment and checking code
                      onChanged: (value){
                        fnEventRadioClick(eventCode,eventDescp,_radioValue);
                        print(_radioValue);
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      fnEventRadioClick(eventCode,eventDescp,index);
                    },
                    child: ts(eventDescp,Colors.black,12),
                  )*/
                ],
              ),
            ),
          );
        });
  }
  fnCheckSelectedEvent(var list){

    var INDEX = 0;
    print(list.length);

    for(var i in list){
      var code = i['CODE'];
      if(code == lstrSelectedEvent){
        valueSelect =INDEX;
      }else{
        valueSelect =0;
      }
      INDEX ++;
    }

    return valueSelect;
  }
  Widget bookingInvoiceView(snapshot){
    return ListView.builder(

        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data['Table4'].length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data['Table4'][index];
          var invoiceNo = dataList['DOCNO']??'';
          var doctype = dataList['DOCTYPE']??'';
          var netAmount = dataList['NETAMT']??'';
          var createUser = dataList['CREATE_USER']??'';
          var createDate = dataList['CREATE_DATE']??'';
          var taxable = dataList['TAXABLE_AMT'];
          var tax = dataList['TAX_AMT'];
          var addl = dataList['ADDL_AMT'];
          var total = dataList['NETAMT'];

          return GestureDetector(
            onTap: (){
              setState(() {
                lstrSelectedBookingInvNo = invoiceNo;
                lstrTaxable = taxable??0.0;
                lstrLastVat = tax??0.0;
                lstrLastDiscount = addl??0.0;
                lstrLastTotal = total??0.0;
                lstrSelectedRslItems = fnCheckInvoiceItem(invoiceNo);
                lstrSelectedUser = createUser;
                lstrSelectedDate = formatDate.format(DateTime.parse(createDate.toString()));
                wstrDoctype= doctype;
              });
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.all(10),
              decoration: boxBaseDecoration(lstrSelectedBookingInvNo ==invoiceNo? blueLight: Colors.white, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      tc((index+1).toString() + '. #' +invoiceNo.toString(),Colors.red,15),
                    ],
                  ),
                  gapHC(2),
                  Row(
                    children: [
                      Icon(Icons.person,size: 10,),
                      gapWC(5),
                      ts(createUser.toString(), Colors.black, 12)
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,size: 10,),
                      gapWC(5),
                      ts(formatDate.format(DateTime.parse(createDate.toString())), Colors.black, 12)
                    ],
                  ),
                  gapHC(5),
                  line(),
                  gapHC(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ts('BILL AMOUNT', Colors.black, 15),
                      tc(netAmount.toString(), Colors.red, 20),
                    ],
                  ),


                ],
              ),
            ),
          );
        });
  }
  Widget rslItemView(){
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: lstrSelectedRslItems.length,
        itemBuilder: (context, index) {
          var dataList = lstrSelectedRslItems[index];
          var lstrOrderNo  =  dataList["DOCNO"];

          var itemCode = dataList['STKCODE'];
          var itemName = dataList['STKDESCP'];
          var itemQty = dataList['QTY1'].toString();
          var itemStatus = dataList['STATUS'].toString();
          var itemRate = dataList['RATE'].toString();
          var itemTotal = double.parse(itemQty)  * double.parse(itemRate);
          var returnSts  =   dataList['RETURNED_YN'].toString();
          return GestureDetector(
            onTap: (){

            },
            child: itemStatus == 'C' ? Container():  Container(
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
              margin: EdgeInsets.only(bottom: 5),
              decoration: boxBaseDecoration(returnSts == "Y"?Colors.red:greyLight, 3),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: tc((index+1).toString() +'. '+itemName,Colors.black,14),),
                  Row(
                    children: [
                      Container(
                        width: 50,
                        child: tc(itemRate.toString() ,Colors.black,12),
                      ),
                      Container(
                        width: 50,
                        child: tc('x'+itemQty.toString(),Colors.black,12),
                      ),
                      Container(
                          width: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              tc(itemTotal.toString(),PrimaryColor,12),
                            ],
                          )
                      ),

                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
  GestureDetector scheduleCard(mode,text) => GestureDetector(

    onTap: (){

      if(mode == 'F'){
        setState(() {
          lstrScheduleSelection = mode;
          // header
          lstrSelectedBookingNo = '';
          lstrSelectedBookingSts ='';
          lstrSelectedBookingTables = [];
          lstrSelectedBooking =[];
          lstrSelectedBookingItems = [];
          lstrSelectedBookingAllItems= [];
          lstrSelectedBookingInvoice = [];
          lstrSelectedBookingInvoices = [];
          lstrSelectedBookingDocType = '';
          lstrSelectedBookingYearcode = '';
          lstrSelectedBookingDate ='';
          lstrSelectedBookingUser = '';
          wstrDoctype= '';
          lstrOldAdvanceAmt =0.0;
          // details
          lstrSelectedBookingAllItems = [];
          lstrSelectedBooking =[];
          lstrSelectedBookingItems =[];
          lstrSelectedBookingTables =[];
        });
        setState(() {
          lstrScheduleSelection = 'F';
          scaffoldKey.currentState?.openDrawer();
        });
      }else{
        setState(() {
          lstrScheduleSelection = mode;
          // header
          lstrSelectedBookingNo = '';
          lstrSelectedBookingSts ='';
          lstrSelectedBookingTables = [];
          lstrSelectedBooking =[];
          lstrSelectedBookingItems = [];
          lstrSelectedBookingAllItems= [];
          lstrSelectedBookingInvoice = [];
          lstrSelectedBookingInvoices = [];
          lstrSelectedBookingDocType = '';
          lstrSelectedBookingYearcode = '';
          lstrSelectedBookingDate ='';
          lstrSelectedBookingUser = '';
          wstrDoctype= '';
          lstrOldAdvanceAmt =0.0;
          // details
          lstrSelectedBookingAllItems = [];
          lstrSelectedBooking =[];
          lstrSelectedBookingItems =[];
          lstrSelectedBookingTables =[];
        });
        fnGetBooking(null, null, null, lstrScheduleSelection);
      }
      },
     child: Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: boxDecoration(lstrScheduleSelection == mode ? Colors.amber:Colors.white, 30),
      height: 35,
      child: Center(
        child: Row(
          children: [
            ts(text,Colors.black,15),
            gapWC(5),
            mode == 'F' ? Icon(Icons.filter_list_outlined,size: 13,) :Container()
          ],
        ),
      ),
    ),
  );

  //============================LOOKUP====================================

  fnLookup(mode,lookupMode) {
    if (mode == 'PARTYCODE') {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'GUEST_CODE', 'Display': 'Code'},
        {'Column': 'GUEST_NAME', 'Display': 'Name'},
        {'Column': 'MOBILE', 'Display': 'Mobile'},
        {'Column': 'EMAIL', 'Display': 'Email'},
        {'Column': 'TEL', 'Display': 'Telephone'},
        {'Column': 'CONTACT_MOBILE', 'Display': 'Mobile 2'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {'sourceColumn': 'GUEST_CODE','contextField': txtBPartyCode,'context': 'window'},
        {'sourceColumn': 'GUEST_NAME','contextField': txtBPartyName,'context': 'window'},
        {'sourceColumn': 'EMAIL','contextField': txtBEmail,'context': 'window'},
        {'sourceColumn': 'TEL','contextField': txtBTele,'context': 'window'},
        {'sourceColumn': 'CONTACT_MOBILE','contextField': txtBMobile2,'context': 'window'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtBPartyCode,
        oldValue: txtBPartyCode.text,
        lstrTable: 'GUESTMASTER',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100000',
        lstrFilter: [],
        keyColumn: 'GUEST_CODE',
        layoutName: "B",
        mode: lookupMode,
        callback: fnLookupPartyCallBack,
      ), 'Party ');
    }
    if (mode == 'CUST') {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'GUEST_CODE', 'Display': 'Code'},
        {'Column': 'GUEST_NAME', 'Display': 'Name'},
        {'Column': 'MOBILE', 'Display': 'Mobile'},
        {'Column': 'EMAIL', 'Display': 'Email'},
        {'Column': 'TEL', 'Display': 'Telephone'},
        {'Column': 'CONTACT_MOBILE', 'Display': 'Mobile 2'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {'sourceColumn': 'GUEST_CODE','contextField': txtCustomerCode,'context': 'window'},
        {'sourceColumn': 'GUEST_NAME','contextField': txtCustomerName,'context': 'window'},
        {'sourceColumn': 'MOBILE','contextField': txtCustMobileNo,'context': 'window'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtCustomerCode,
        oldValue: txtCustomerCode.text,
        lstrTable: 'GUESTMASTER',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100000',
        lstrFilter: [],
        keyColumn: 'GUEST_CODE',
        layoutName: "B",
        mode: lookupMode,
        callback: fnLookupCallBack,
      ), 'Party ');
    }
    else if (mode == 'AREA') {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {'sourceColumn': 'CODE','contextField': txtArea,'context': 'window'},
        {'sourceColumn': 'DESCP','contextField': lstrAreaDescp,'context': 'variable'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtArea,
        oldValue: txtArea.text,
        lstrTable: 'AREAMASTER',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100000',
        lstrFilter: [],
        keyColumn: 'CODE',
        mode: lookupMode,
        layoutName: "B",
        callback: fnLookupAreaCallBack,
      ), 'Area ');
    }
    else if (mode == 'PARTYCODE_') {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'GUEST_CODE', 'Display': 'Code'},
        {'Column': 'GUEST_NAME', 'Display': 'Name'},
        {'Column': 'MOBILE', 'Display': 'Mobile'},
        {'Column': 'EMAIL', 'Display': 'Email'},
        {'Column': 'TEL', 'Display': 'Telephone'},
        {'Column': 'CONTACT_MOBILE', 'Display': 'Mobile 2'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {'sourceColumn': 'GUEST_CODE','contextField': txtGuestCode,'context': 'window'},
        //{'sourceColumn': 'GUEST_NAME','contextField': txtBPartyName,'context': 'window'},
       // {'sourceColumn': 'EMAIL','contextField': txtBEmail,'context': 'window'},
       // {'sourceColumn': 'TEL','contextField': txtBTele,'context': 'window'},
       // {'sourceColumn': 'CONTACT_MOBILE','contextField': txtMobile_D,'context': 'window'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtGuestCode,
        oldValue: txtGuestCode.text,
        lstrTable: 'GUESTMASTER',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100000',
        lstrFilter: [],
        keyColumn: 'GUEST_CODE',
        layoutName: "B",
        mode: lookupMode,
        callback: fnLookupPartyCallBack_,
      ), 'Party ');
    }
    else if (mode == 'AREA_') {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {'sourceColumn': 'CODE','contextField': txtArea_D,'context': 'window'},
        {'sourceColumn': 'DESCP','contextField': lstrAreaDescp_,'context': 'variable'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtArea_D,
        oldValue: txtArea_D.text,
        lstrTable: 'AREAMASTER',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100000',
        lstrFilter: [],
        keyColumn: 'CODE',
        mode: lookupMode,
        layoutName: "B",
        callback: fnLookupAreaCallBack_,
      ), 'Area ');
    }
    else if (mode == 'DOC_NUM') {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'DOCNO', 'Display': 'Doc Num'},
        {'Column': 'GUESTCODE', 'Display': 'Guest Code'},
        {'Column': 'GUESTNAME', 'Display': 'Guest Name'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {'sourceColumn': 'DOCNO','contextField': txtDocNum_D,'context': 'window'},
        //{'sourceColumn': 'GUEST_CODE','contextField': txtGuestCode,'context': 'window'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtDocNum_D,
        oldValue: txtDocNum_D.text,
        lstrTable: 'RSL_BOOKING',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100000',
        lstrFilter: [],
        keyColumn: 'DOCNO',
        mode: lookupMode,
        layoutName: "B",
        callback: fnLookupDocNumCallBack_,
      ), 'Doc Num ');
    }
  }
  fnLookupDocNumCallBack_(data){
    if(g.fnValCheck(data)){
      setState(() {
        txtGuestCode.text = data["GUESTCODE"] ?? '';
      });
    }
  }
  fnLookupCallBack(data){

  }
  fnLookupPartyCallBack(data){
    if(g.fnValCheck(data)){
      setState(() {
        txtBMobileNo.text = data["MOBILE"].toString().replaceAll("+971", "");
      });
    }
  }

  fnLookupPartyCallBack_(data){
    if(g.fnValCheck(data)){
      setState(() {
        lstrGuestMobile = data["CONTACT_MOBILE"].toString().replaceAll("+971", "");
      });
    }
  }
  fnLookupAreaCallBack(data){
    if(g.fnValCheck(data)){
      setState(() {
        lstrAreaDescp = data["DESCP"] ?? '';
      });
    }
  }

  fnLookupAreaCallBack_(data){
    if(g.fnValCheck(data)){
      setState(() {
        lstrAreaDescp_ = data["DESCP"] ?? '';
      });
    }
  }

  //============================PAGE / OTHER FUNCTION============================

  fnGetPageData(){

    fnGetBooking(null, null, null, lstrScheduleSelection);
  }
  fnPageMode(mode){

    setState(() {
      wstrPageMode = mode;
    });
    fnClear();
    if(mode == "EDIT"){
      if(g.fnValCheck(lstrSelectedBooking)){
        var dataList =  lstrSelectedBooking[0];
        txtBPartyCode.text = dataList["GUESTCODE"].toString();
        txtBPartyName.text = dataList["GUESTNAME"].toString();
        txtBTele.text = dataList["TEL"].toString();
        txtBMobileNo.text = dataList["PARTY_MOBILE"].toString().replaceAll("+971", "");
        txtBEmail.text = dataList["EMAIL"].toString();
        txtBAddress.text = dataList["ADD1"].toString();
        txtArea.text = dataList["AREA_CODE"].toString();
        txtNoOfPerson.text = dataList["NO_PERSON"].toString();
        lstrAreaDescp = dataList["AREA_DESCP"].toString();
        lstrSelectedEvent = dataList["EVENT_CODE"].toString();
        lstrSelectedEventDescp = dataList["EVENT_DESCP"].toString();
        wstrDoctype = dataList["DOCTYPE"].toString();
        currentDate =  DateTime.parse(dataList["BOOKING_DATE"].toString());
        lstrAdvAmount = lstrOldAdvanceAmt;
        if(dataList["BOOKING_TIME_FROM"] != "" || dataList["BOOKING_TIME_FROM"] != null){

          timeFrom = TimeOfDay(hour:int.parse(dataList["BOOKING_TIME_FROM"].split(":")[0]),minute: int.parse(dataList["BOOKING_TIME_FROM"].split(":")[1]));

        }
        if(dataList["BOOKING_TIME_FROM"] != "" || dataList["BOOKING_TIME_FROM"] != null){
          timeTo = TimeOfDay(hour:int.parse(dataList["BOOKING_TIME_TO"].split(":")[0]),minute: int.parse(dataList["BOOKING_TIME_TO"].split(":")[1]));

        }
      }



      if(g.fnValCheck(lstrSelectedBookingAllItems)){
        setState(() {
          if(g.fnValCheck(lstrSelectedBookingAllItems)){
            for (var e in lstrSelectedBookingAllItems){
              lastOrder.add({
                "DISHCODE":e['STKCODE'].toString(),
                "DISHDESCP":e['STKDESCP'].toString(),
                "QTY":e['QTY1'].toString(),
                "PRICE1":e["RATE"].toString(),
                "WAITINGTIME":"",
                "NOTE":e["REF1"],
                "PRINT_CODE":null,
                "REMARKS":"",
                "UNIT1":e['UNIT'],
                "KITCHENCODE":e['KITCHENCODE'],
                "ADDON_YN":"",
                "ADDON_STKCODE":"",
                "CLEARED_QTY":"0",
                "NEW":"Y",
                "OLD_STATUS":"",
                "TAXINCLUDE_YN":e['RATE_INCLUDE_TAX'],
                "VAT":e['TAXPERC'],
                "TAX_AMT":0,
                "STATUS":"P"
              });
            }
          }
        });
      }
      fnOrderCalc();


      // api call for guest master =====================================================================
      futureGuest = apiCall.getGuestMaster(g.wstrCompany,txtBPartyCode.text);
      futureGuest.then((value) => fnGuestMasterSuccess(value));
    }

    fnGetEvents();
  }
  fnGuestMasterSuccess(value){

    print('-------------- RESULT ------------------------');
    print(value);

    if(g.fnValCheck(value)){
      var dataList =  value['Table1'][0]/*[0]*/;
      txtBPartyName.text = (dataList["GUEST_NAME"]??"").toString();
      txtBMobileNo.text = (dataList["MOBILE"]??"").toString().replaceAll("+971", "");
      txtBMobile2.text = (dataList["CONTACT_MOBILE"]??"").toString().replaceAll("+971", "");
      txtBTele.text = (dataList["TEL"]??"").toString();
      txtBEmail.text = (dataList["EMAIL"]??"").toString();
      txtBAddress.text = (dataList["ADD1"]??"").toString();
      txtBDob.text = (dataList["DOB"]??"").toString().isEmpty ? '' : formatDate2.format(DateTime.parse(dataList["DOB"].toString()));

    }
  }
  fnClear(){
    setState(() {

      finalBillYn = "N";
      lstrBookingMode = "V";
      txtBPartyCode.clear();
      txtBMobileNo.clear();
      txtBPartyName.clear();
      txtBMobile2.clear();
      txtBTele.clear();
      txtBEmail.clear();
      txtBAddress.clear();
      txtBRemarks.clear();
      txtBDob.clear();
      txtNoOfPerson.clear();
      txtArea.clear();

      txtCustMobileNo.clear();
      txtCustomerCode.clear();
      txtCustomerName.clear();

      currentDate = DateTime.now();
      dob = DateTime.now();
      timeFrom = TimeOfDay(hour: 7, minute: 15);
      timeTo = TimeOfDay(hour: 7, minute: 15);
      lstrNoOfPersons = 1;
      _radioValue = 0 ;
      lstrSelectedEvent = '' ;
      lstrSelectedEventDescp = '' ;
      lstrAreaDescp = '' ;
      if(wstrPageMode != "EDIT"){

        lstrSelectedBookingNo = '';
        lstrSelectedBookingSts ='';
        lstrSelectedBookingDocType = '';
        lstrSelectedBookingYearcode = '';
        lstrSelectedBookingDate = '';
        lstrSelectedBookingUser = '';
        lstrSelectedBookingTables = [];
        lstrSelectedBookingItems = [];
        lstrSelectedBooking= [];
      }
      lastOrder= [];
      lstrSelectedBill= [];
      lstrRetailPay = [];
      lstrPaymentList = [];

      lstrRsl = [];
      lstrRslDet=[];
      lstrRslBooking = [];
      lstrRslDetBooking =[];
      lstrRslBookingTable =[];
      lstrRslVoid = [];
      lstrRslVoidDet = [];
      lstrRslAddlCharge = [];
      lstrBookingGuest = [];

      lstrOrderQtyV = 0;
      lstrLastGross = 0.00;
      lstrLastVat = 0.00;
      lstrLastTotal = 0.00;
      lstrLastDiscount = 0.00;
      lstrLastAddlAmount = 0.00;
      lstrTaxable = 0.00;
      lstrPaidAmt = 0.00;
      lstrBalanceAmt = 0.00;
      lstrAdvAmount = 0.00;
      lstrAdvanceAmt = 0.0;
      lstrBillAmt = 0.0;
      lstrBkgBalanceAmt = 0.0;


    });
  }
  fnBookingSaveAlert(){

    if(lstrAdvAmount > 0 && wstrPageMode !='EDIT'){
      lstrRetailPay = [];
      fnBookingPayPopup();

    }else if(wstrPageMode=='EDIT' && lstrOldAdvanceAmt != lstrAdvAmount ){
      fnBookingPayPopup();
    }else {
      PageDialog().saveDialog(context, fnBookingSave);
    }

  }
  fnBookingSave(){


    Navigator.pop(context);

    lstrRsl = [];
    lstrRslBooking = [];
    lstrRslDetBooking = [];
    lstrRslBookingTable = [];
    lstrRslDet=[];
    lstrRslVoid = [];
    lstrRslVoidDet = [];
    lstrRslAddlCharge = [];
    lstrBookingGuest = [];
    var srno = 0;


    var templstrLastTotal = 0.0  ;
    var templstrLastGross = 0.0 ;
    var templstrTaxable = 0.0 ;
    var templstrLastVat = 0.0 ;


    if(txtBMobileNo.text.isEmpty){
      showToast( 'Please enter mobile no');
      return false;
    }


    if(lstrAdvAmount > 0 && lstrRetailPay.length == 0 && lstrOldAdvanceAmt != lstrAdvAmount ){
      showToast( 'Please check your payment');
      fnBookingPayPopup();
      return false;
    }

    setState(() {
      saveSts = false;
    });

    if(g.fnValCheck(lastOrder)){
      var totalAmount = 0.0;
      var grossAmount = 0.0;
      var totalQty = 0.0;
      var vatAmount = 0.0;
      var taxableAmount = 0.0;
      var totalAmt  = 0.0;
      var discount = 0.0;
      for(var e in lastOrder){
        var qty = double.parse(e["QTY"].toString());
        if(qty  > 0){
          var price = e["PRICE1"].toString();
          var total = (qty *  double.parse(price));
          totalAmt = totalAmt +total;
        }
      }

      //AddlAmount
      for(var e in lastOrder){
        srno = srno + 1;
        var vatSts = e["TAXINCLUDE_YN"];
        var vatP = e["VAT"]??0.0;

        var qty = double.parse(e["QTY"].toString());
        if(qty > 0){
          var price = e["PRICE1"].toString();
          var amt = (qty *  double.parse(price)) ;
          var headerDiscount = (amt / totalAmt) * lstrLastDiscount;
          var headerAddlAmount  = (amt / totalAmt) * lstrLastAddlAmount;
          var total = amt - headerDiscount;
          var taxableAmt = 0.00;
          var vat = 0.0;
          var vatA = 0.0;
          if(vatSts == 'Y' && vatP > 0){
            var dvd = 100 /(100+vatP);
            vat =  total * dvd;
            vatA = total - vat;
            taxableAmt = total - vatA;
            taxableAmount = (taxableAmount + total) - vatA;
            totalAmount = totalAmount +total ;
          }else{
            vat = (vatP)/100;
            vatA = total * vat;
            taxableAmt =total;
            taxableAmount = (taxableAmount +total);
            totalAmount =totalAmount +total + vatA;
          }
          grossAmount = grossAmount + amt;
          vatAmount = vatA + vatAmount;
          totalQty = totalQty + qty;
          lstrRslDetBooking.add({
            "COMPANY":g.wstrCompany,
            "YEARCODE":g.wstrYearcode,
            "DOCNO":lstrSelectedBookingNo,
            "DOCTYPE":wstrDoctype,
            "SRNO":srno,
            "STKCODE":e["DISHCODE"],
            "STKDESCP":e["DISHDESCP"],
            "UNIT1":e["UNIT1"],
            "QTY1":e["QTY"],
            "RATE":e["PRICE1"],
            "RATEFC":e["PRICE1"],
            "REF1":e["NOTE"],
            "GRAMT":double.parse(amt.toStringAsFixed(5)) ,
            "GRAMTFC": double.parse(amt.toStringAsFixed(5)) ,
            "DISC_AMT":double.parse(headerDiscount.toStringAsFixed(5)),
            "DISC_AMTFC":double.parse(headerDiscount.toStringAsFixed(5)),
            "AMT": double.parse(amt.toStringAsFixed(5)),
            "AMTFC":double.parse(amt.toStringAsFixed(5)),
            "ADDL_AMT":headerAddlAmount,
            "ADDL_AMTFC":headerAddlAmount * g.wstrCurrencyRate,
            "PRVDOCSRNO":0,
            "PRVDOCQTY":0,
            "PRVDOCPENDINGQTY":0,
            "PENDINGQTY":0,
            "CLEARED_QTY":0,
            "HEADER_DISC_AMT": double.parse(headerDiscount.toStringAsFixed(5)),
            "HEADER_DISC_AMTFC":double.parse(headerDiscount.toStringAsFixed(5)) * g.wstrCurrencyRate,
            "TOT_TAX_AMT": double.parse(vatA.toStringAsFixed(5))  ,
            "TOT_TAX_AMTFC": double.parse(vatA.toStringAsFixed(5)) * g.wstrCurrencyRate,
            "RATE_INCLUDE_TAX":e["TAXINCLUDE_YN"],
            "TAXABLE_AMT":  double.parse(taxableAmt.toStringAsFixed(2))  ,
            "TAXABLE_AMTFC":double.parse(taxableAmt.toStringAsFixed(2)) * g.wstrCurrencyRate,
            "ORDER_TYPE":lstrSelectedOrderType
          });
        }
      }

      setState(() {

        templstrLastTotal = double.parse(totalAmount.toStringAsFixed(3))  ;
        templstrLastGross = double.parse(grossAmount.toStringAsFixed(3)) ;
        templstrTaxable = double.parse(taxableAmount.toStringAsFixed(3)) ;
        templstrLastVat = double.parse(vatAmount.toStringAsFixed(3)) ;
        templstrLastTotal =  lstrLastAddlAmount  + lstrLastTotal;


        lstrLastTotal = double.parse(totalAmount.toStringAsFixed(2))  ;
        lstrLastGross = double.parse(grossAmount.toStringAsFixed(2)) ;
        lstrTaxable = double.parse(taxableAmount.toStringAsFixed(2)) ;
        lstrLastVat = double.parse(vatAmount.toStringAsFixed(2)) ;
        lstrLastTotal =  lstrLastAddlAmount  + lstrLastTotal;
      });


    }
    lstrRslBooking.add({
      "COMPANY":g.wstrCompany,
      "YEARCODE":g.wstrYearcode,
      "DOCNO":lstrSelectedBookingNo,
      "DOCTYPE":wstrDoctype,
      "PARTYCODE":txtBPartyCode.text,
      "PARTYNAME":txtBPartyName.text,
      "GUESTCODE":txtBPartyCode.text,
      "GUESTNAME":txtBPartyName.text,
      "CURR":g.wstrCurrency,
      "CURRATE":g.wstrCurrencyRate,
      "GRAMT":templstrLastGross,
      "GRAMTFC":templstrLastGross,
      "ADDL_AMT":lstrLastAddlAmount,
      "ADDL_AMTFC":lstrLastAddlAmount * g.wstrCurrencyRate,
      "PAID_AMT1":0,
      "PAID_AMT1FC":0,
      "PAID_AMT2":0,
      "PAID_AMT2FC":0,
      "DISC_AMT": double.parse(lstrLastDiscount.toStringAsFixed(5)) ,
      "DISC_AMTFC":double.parse(lstrLastDiscount.toStringAsFixed(5)) ,
      "CHG_AMT":0,
      "CHG_AMTFC":0,
      "EXHDIFF_AMT":0,
      "NETAMT":templstrLastTotal,
      "NETAMTFC":templstrLastTotal * g.wstrCurrencyRate,
      "PAID_AMT":double.parse(lstrPaidAmt.toStringAsFixed(5))  ,
      "PAID_AMTFC":double.parse(lstrPaidAmt.toStringAsFixed(5)) * g.wstrCurrencyRate,
      "BAL_AMT":double.parse(lstrBalanceAmt.toStringAsFixed(5)),
      "BAL_AMTFC":double.parse(lstrBalanceAmt.toStringAsFixed(5)) * g.wstrCurrencyRate,
      "AC_AMTFC":0,
      "AC_AMT":0,
      "REMARKS":txtBRemarks.text,
      "EDIT_USER":g.wstrUserCd,
      "SHIFNO":g.wstrShifNo.toString(),
      "COUNTER_NO":g.wstrDeivceId,
      "MACHINENAME":g.wstrDeviceName,
      "CREATE_USER":g.wstrUserCd,
      "TAX_AMT": double.parse(templstrLastVat.toStringAsFixed(5))  ,
      "TAX_AMTFC": double.parse(templstrLastVat.toStringAsFixed(5)) * g.wstrCurrencyRate  ,
      "TAXABLE_AMT": double.parse(templstrTaxable.toStringAsFixed(5)) ,
      "TAXABLE_AMTFC": double.parse(templstrTaxable.toStringAsFixed(5))  * g.wstrCurrencyRate,
      "ADV_AMT" : lstrAdvAmount,
      "ADV_AMTFC" : lstrAdvAmount,
      "BOOKING_DATE" : formatDateDB.format(currentDate),
      "BOOKING_TIME_FROM" : timeFrom.format(context),
      "BOOKING_TIME_TO" : timeTo.format(context),
      "EVENT_CODE" : lstrSelectedEvent,
      "EVENT_DESCP" : lstrSelectedEventDescp,
      "NO_PERSON" : txtNoOfPerson.text.isEmpty ? 1 : txtNoOfPerson.text,
      "PARTY_MOBILE" : txtBMobileNo.text.contains("+971") ?txtBMobileNo.text: lstrMobArea.toString() + txtBMobileNo.text ,
      "STATUS" : "A",
      "AREA_CODE" : txtArea.text,
      "AREA_DESCP" : lstrAreaDescp,
    });
    lstrBookingGuest.add({
      "GUEST_CODE" : txtBPartyCode.text,
      "GUEST_NAME" : txtBPartyName.text,
      "DOCNO":lstrSelectedBookingNo,
      "DOCTYPE":wstrDoctype,
      "ADD1" : txtBAddress.text,
      "TEL" : txtBTele.text,
      "MOBILE" :  txtBMobileNo.text.contains("+971") ?txtBMobileNo.text: lstrMobArea.toString() + txtBMobileNo.text ,
      "EMAIL" : txtBEmail.text,
      "CONTACT_NAME" : txtBPartyName.text,
      "CONTACT_MOBILE" : txtBMobile2.text,
      "DOB" : formatDateDB.format(dob),
      "CREATE_BY" : g.wstrUserCd,
    });
    srno  = 0;
    if(g.fnValCheck(g.wstrLastSelectedTables)){
      for(var e in g.wstrLastSelectedTables){
        srno = srno +1;
        lstrRslBookingTable.add({
          "COMPANY":g.wstrCompany.toString(),
          "YEARCODE":g.wstrYearcode.toString(),
          "DOCNO":lstrSelectedBookingNo,
          "DOCTYPE":wstrDoctype,
          "SRNO":srno,
          "TABLE_CODE":e["TABLE_CODE"],
          "TABLE_DESCP":e["TABLE_DESCP"],
          "GUEST_NO":0,
        });
      }
    }

    if(lstrOldAdvanceAmt != lstrAdvAmount &&  lstrAdvAmount >0 && lstrRetailPay.length >0){

      lstrRsl.add({
        "COMPANY":g.wstrCompany,
        "YEARCODE":g.wstrYearcode,
        "DOCNO":lstrSelectedBookingNo,
        "DOCNO":lstrSelectedBookingNo,
        "CURR":g.wstrCurrency,
        "CURRATE":g.wstrCurrencyRate,
        "GRAMT":lstrAdvAmount,
        "GRAMTFC":lstrAdvAmount,
        "ADDL_AMT":0,
        "ADDL_AMTFC":0,
        "PAID_AMT1":0,
        "PAID_AMT1FC":0,
        "PAID_AMT2":0,
        "PAID_AMT2FC":0,
        "DISC_PERCENT":0,
        "DISC_AMT": 0 ,
        "DISC_AMTFC":0 ,
        "CHG_AMT":0,
        "CHG_AMTFC":0,
        "EXHDIFF_AMT":0,
        "NETAMT":lstrAdvAmount,
        "NETAMTFC":lstrAdvAmount,
        "PAID_AMT":lstrAdvAmount  ,
        "PAID_AMTFC":lstrAdvAmount,
        "BAL_AMT":0,
        "BAL_AMTFC":0,
        "AC_AMTFC":0,
        "AC_AMT":0,
        "EDIT_USER":g.wstrUserCd,
        "SHIFNO":g.wstrShifNo.toString(),
        "COUNTER_NO":g.wstrDeivceId,
        "MACHINENAME":g.wstrDeviceName,
        "TAX_AMT": 0  ,
        "TAX_AMTFC": 0 ,
        "TAXABLE_AMT": 0 ,
        "TAXABLE_AMTFC": 0,
      });
      lstrRslDet.add({
        "COMPANY":g.wstrCompany,
        "YEARCODE":g.wstrYearcode,
        "DOCNO":lstrSelectedBookingNo,
        "DOCTYPE":wstrDoctype,
        "STKCODE":"ADV",
        "STKDESCP":"ADVANCE",
        "SRNO":srno,
        "QTY1":1,
        "RATE":lstrAdvAmount,
        "RATEFC":lstrAdvAmount,
        "GRAMT":lstrAdvAmount ,
        "GRAMTFC": lstrAdvAmount ,
        "DISC_AMT":0,
        "DISC_AMTFC":0,
        "DISCPERCENT":0,
        "AMT": lstrAdvAmount,
        "AMTFC":lstrAdvAmount,
        "ADDL_AMT":0,
        "ADDL_AMTFC":0,
        "PRVDOCSRNO":0,
        "PRVDOCQTY":0,
        "PRVDOCPENDINGQTY":0,
        "PENDINGQTY":0,
        "CLEARED_QTY":0,
        "HEADER_DISC_AMT": 0,
        "HEADER_DISC_AMTFC":0,
        "TOT_TAX_AMT": 0  ,
        "TOT_TAX_AMTFC": 0,
        "TAXABLE_AMT":  lstrAdvAmount,
        "TAXABLE_AMTFC":lstrAdvAmount,
        "ORDER_TYPE":"BOOKING"
      });
    }



    print(result_TIME);
    fnSaveBookingApi(wstrPageMode);



  }
  fnFilterItem(){
    
    // condition check -----------------------------------
    setState(() {
      // header
      lstrSelectedBookingNo = '';
      lstrSelectedBookingSts ='';
      lstrSelectedBookingTables = [];
      lstrSelectedBooking =[];
      lstrSelectedBookingItems = [];
      lstrSelectedBookingAllItems= [];
      lstrSelectedBookingInvoice = [];
      lstrSelectedBookingInvoices = [];
      lstrSelectedBookingDocType = '';
      lstrSelectedBookingYearcode = '';
      lstrSelectedBookingDate ='';
      lstrSelectedBookingUser = '';
      wstrDoctype= '';
      lstrOldAdvanceAmt =0.0;
      // details
      lstrSelectedBookingAllItems = [];
      lstrSelectedBooking =[];
      lstrSelectedBookingItems =[];
      lstrSelectedBookingTables =[];
    });

    print(currentDate_From);
    print(currentDate_To);
    print(timeFrom_Drawer);
    print(timeTo_Drawer);

    futureGetBooking =  apiCall.getBooking(g.wstrCompany, g.wstrYearcode, "RBK", txtDocNum_D.text, lstrSelectedMode_Drawer,
        currentDate_From == null
            ? ''
            : formatDateDB.format(currentDate_From!).toString(),
           currentDate_To == null
            ? ''
            :formatDateDB.format(currentDate_To!).toString(),
        txtGuestCode.text,txtArea_D.text,lstrGuestMobile,

        timeFrom_Drawer == null
            ? ''
            :timeFrom_Drawer!.format(context).toString(),

        timeTo_Drawer == null
            ? ''
            :timeTo_Drawer!.format(context).toString());
    futureGetBooking.then((value) => fnGetBookingSuccess(value));
   // fnClearView();
  }




  Future<void> _selectDob(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: dob,
        firstDate: DateTime(1900),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != dob) {
      setState(() {
        dob = pickedDate;
        txtBDob.text  = formatDate2.format(dob).toString();
      });
    }
  }
  Future<void> _selectTimeFrom(BuildContext context) async {
    var rS = '';
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: timeFrom,
    );
    if (newTime != null) {
      setState(() {
       // timeFrom = newTime;
        setState(() {



          rS =  fnTimeCompare(newTime,timeTo);
          print(rS);
          if(rS=='N'){
            timeFrom = newTime;
            showToast( 'Selected To Time is Less than From Time');
            return;
          }else{
            timeFrom = newTime;
          }
        });


      });
    }
  }
  Future<void> _selectTimeTo(BuildContext context) async {

    var rS = '';
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: timeTo,
    );

    if (newTime != null) {
      setState(() {
         rS =  fnTimeCompare(timeFrom,newTime);
         print(rS);
        if(rS=='N'){
          timeTo = newTime;
          showToast( 'Selected To Time is Less than From Time');
          return;
        }else{
          timeTo = newTime;
        }
      });
    }


  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2022),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      var sts ;
      var cmpDate = pickedDate;
      cmpDate = DateTime.parse(formatDateDB.format(cmpDate));
      if(cmpDate == lstrToday){
        sts = '1';
      }else{
        sts = cmpDate.compareTo(lstrToday).toString();
      }
      setState(() {
        if(sts == "-1"){
          showToast( 'Please choose correct date');
        }else{
          currentDate = pickedDate;
        }

      });
    }
  }
  fnEventRadioClick(code,name,index) async{
    setState(() {
      valueSelect = index;
      _radioValue = index;
      lstrSelectedEvent = code;
      lstrSelectedEventDescp = name;

      print('----------------------UPDATED VALUES -------------------------------');
      print(valueSelect.toString() +" "+lstrSelectedEvent+" "+lstrSelectedEventDescp);
    });
  }
  fnItemPress(dataList,qty,mode,sts,itemClearedQty) async{
    bool checkItem = false;
    bool checkQtyZero = false;
    var itemCode = dataList['DISHCODE'].toString();
    var itemName = dataList['DISHDESCP'];
    var waitingTime = dataList['WAITINGTIME'];
    var itemPrice = dataList['PRICE1'];

    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        var lqty = double.parse(e["QTY"].toString());
        if( itemCode == lcode ){
          checkItem = true;

          if(mode=='ADD'){
            var v =  lqty + qty;
            e["QTY"] = v.toString();
            e["STATUS"] = "P";
            e["PRINT_CODE"] = null;
          }else{
            var v =  lqty - qty;
            if(sts != 'R' && sts != 'D'){
              e["QTY"] = v.toString();
              e["STATUS"] = "P";
              e["PRINT_CODE"] = null;
              if(double.parse(e["QTY"].toString()) <= 0){
                fnRemoveItem(dataList,e);
              }
            }else{
              e["QTY"] = v.toString();
              e["STATUS"] = "P";
              e["PRINT_CODE"] = null;
              if(double.parse(e["QTY"].toString()) <= 0){
                fnRemoveItem(dataList,e);
              }

            }

          }

          break;
        }
      }
    }

    if(!checkItem){
      setState(() {
        lastOrder.add({
          "DISHCODE":dataList['DISHCODE'],
          "DISHDESCP":dataList['DISHDESCP'],
          "QTY":qty.toInt().toString(),
          "PRICE1":itemPrice.toString(),
          "WAITINGTIME":waitingTime.toString(),
          "NOTE":dataList["NOTE"],
          "PRINT_CODE":null,
          "REMARKS":itemPrice.toString(),
          "UNIT1":dataList['UNIT'],
          "KITCHENCODE":dataList['KITCHENCODE'],
          "ADDON_YN":"",
          "ADDON_STKCODE":"",
          "CLEARED_QTY":"0",
          "NEW":"Y",
          "OLD_STATUS":"",
          "TAXINCLUDE_YN":dataList['TAXINCLUDE_YN'],
          "VAT":dataList['VAT'],
          "TAX_AMT":0,
          "STATUS":"P"
        });
      });
    }

    setState(() {

    });
    print(lastOrder);
    fnOrderCalc();
    //Vibration.vibrate();

  }
  fnRemoveItem(dataList,selectedItem){

    var itemSts = '';
    itemSts = selectedItem["OLD_STATUS"].toString();
    var newItem = selectedItem['NEW'].toString();
    if(itemSts != 'R' && itemSts != 'D'){
      if(g.wstrOrderMode == 'ADD' ){
        setState(() {
          lastOrder.remove(selectedItem);
        });
      }else{
        if(newItem == "Y"){
          setState(() {
            lastOrder.remove(selectedItem);
          });
        }else{
          fnEditRemove(dataList);
        }

      }
    }else{
      showToast( g.fnStatus(itemSts));
    }



    print(lastOrder);
    fnOrderCalc();
  }
  fnRemoveItemSelected(selectedItem){

    var itemSts = '';
    itemSts = selectedItem["OLD_STATUS"].toString();
    var newItem = selectedItem['NEW'].toString();
    if(itemSts != 'R' && itemSts != 'D'){
      if(g.wstrOrderMode == 'ADD' ){
        setState(() {
          lastOrder.remove(selectedItem);
        });
      }else{
        if(newItem == "Y"){
          setState(() {
            lastOrder.remove(selectedItem);
          });
        }else{
          fnEditRemove(selectedItem);
        }

      }
    }else{
      showToast( g.fnStatus(itemSts));
    }


    print(lastOrder);
    fnOrderCalc();
  }
  fnEditRemove(dataList){
    var itemCode = dataList['DISHCODE'].toString();
    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( itemCode == lcode ){
          e["QTY"] = '0';
          e["STATUS"] = 'C';
          e["PRINT_CODE"] = null;
          break;
        }
      }
    }
  }

  fnOrderCalc(){
    //lastOrderHead
    if(g.fnValCheck(lastOrder)){
      var totalAmount = 0.0;
      var grossAmount = 0.0;
      var totalQty = 0.0;
      var vatAmount = 0.0;
      var taxableAmount = 0.0;
      var totalAmt  = 0.0;
      var discount = 0.0;
      for(var e in lastOrder){
        var qty = double.parse(e["QTY"].toString());
        if(qty  > 0){
          var price = e["PRICE1"].toString();
          var total = (qty  *  double.parse(price));
          totalAmt = totalAmt +total;
        }
      }


      for(var e in lastOrder){
        var sts =  e["STATUS"];
        var vatSts = e["TAXINCLUDE_YN"];
        var vatP = e["VAT"]??0.0;
        var qty = double.parse(e["QTY"].toString());
        if(qty > 0){
          var price = e["PRICE1"].toString();
          var amt = (qty *  double.parse(price)) ;
          var headerDiscount = (amt / totalAmt) * lstrLastDiscount;
          var total = amt - headerDiscount;
          var vat = 0.0;
          var vatA = 0.0;
          if(vatSts == 'Y' && vatP > 0){
            var dvd = 100 /(100+vatP);
            vat =  total * dvd;
            vatA = total - vat;
            taxableAmount = (taxableAmount + total) - vatA;
            totalAmount = totalAmount +total ;
          }else{
            vat = (vatP)/100;
            vatA = total * vat;
            taxableAmount = (taxableAmount +total);
            totalAmount =totalAmount +total + vatA;
          }
          grossAmount = grossAmount +amt;
          vatAmount = vatA + vatAmount;
          totalQty = totalQty + qty;
        }
      }

      setState(() {
        lstrLastTotal = totalAmount + lstrLastAddlAmount;
        lstrLastGross = grossAmount;
        lstrTaxable = taxableAmount;
        lstrLastVat = vatAmount;
       // lstrAdvAmount = lstrOldAdvanceAmt;
        if(finalBillYn == "Y"){
          lstrLastTotal = lstrLastTotal - lstrFinalBillAdvAmount;
        }
        if(g.fnValCheck(lstrSelectedBill)){
          lstrSelectedBill[0]["TOTAL_AMT"] =lstrLastTotal;
        }




      });



    }else{

      setState(() {
        lstrLastTotal = 0.00;
        lstrLastGross = 0.00;
        lstrLastVat = 0.00;
        lstrTaxable = 0.00;
        lstrLastDiscount = 0.00;
      });
    }
    fnPaidCalc();
  }
  fnPaidCalc(){
    if(g.fnValCheck(lstrSelectedBill)){
      var lcash = 0.0;
      var lcard = 0.0;
      var lpaid = 0.0;
      var lchangeto = 0.0;
      var data = lstrSelectedBill[0];
      lcard = data["CARD"]??0.0;
      lcash = data["CASH"]??0.0;
      lpaid = data["PAID_AMT"]??0.0;
      lchangeto = data["CHANGE_TO"]??0.0;


      setState(() {
        lstrPaidAmt = lpaid ;
        lstrBalanceAmt =  lchangeto > 0 ? 0.00: lchangeto;
      });
    }
  }

  fnAdvanceAmount(){
    var data = [];
    data.add({
      "TOTAL_AMT":lstrLastTotal
    });
    PageDialog().showL(context, Advance(
      fnCallBack: fnAdvanceCallBack, oldValue: lstrAdvAmount, lstrDataList: data,
    ), 'Advance');
  }
  fnAdvanceCallBack(amount){
    setState(() {
      lstrAdvAmount = amount;
    });
  }

  fnAddItem(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => QuickSale(
          datalist: lastOrder,
          mode: "B",
          fnCallBack: fnAddItemCallBack,
        )
    ));
  }
  fnAddItemCallBack(data){
    setState(() {
      lastOrder = data;
    });
    fnOrderCalc();
  }

  fnBookingPayPopup(){

    //fnSave();
    setState(() {
      lstrSelectedBill = [];
      lstrSelectedBill.add({
        "DOCNO":'NEW',
        "TYPE": "BOOKING",
        "USER" :g.wstrUserCd,
        "NAME" : '',
        "CASH" : 0.00,
        "CARD" : 0.00,
        "TOTAL_AMT":lstrAdvAmount,
        "PAID_AMT":0.00,
        "CHANGE_TO":0.00
      });

    });
    //Navigator.push(context, MaterialPageRoute(builder: (context) => Payment()));
    PageDialog().showL(context, Payment(
      lstrDataList: lstrSelectedBill,
      fnCallBack: fnBookingPayCallBack,
      lstrPaymentList: lstrPaymentList,
    ), 'Payment Details');
  }
  fnBookingPayCallBack(datalist,retailPay,paymentList){
    setState(() {
      lstrSelectedBill  = datalist;
      lstrRetailPay = retailPay;
      lstrPaymentList = paymentList;
    });
    saveSts? fnBookingSave():'';
  }

  fnCheckInvoiceItem(docno){
    var selectedData = g.mfnJson(lstrSelectedBookingInvoice);
    selectedData.retainWhere((i){
      return i["DOCNO"] == docno ;
    });
    return selectedData;
  }
  fnFinalBillCalc(){
    setState(() {
      lstrFinalBillAmount = 0.00;
      lstrFinalBillBalance = 0.00;
      lstrFinalBillAdvAmount = 0.00;
      if(g.fnValCheck(lstrSelectedBookingAllItems)){
        for (var e in lstrSelectedBookingAllItems ){
          var headerDiscount = g.mfnDbl(e["HEADER_DISC_AMTFC"]);
          var addlAmount = g.mfnDbl(e["ADDL_AMT"]);
          var amt = g.mfnDbl(e["AMT"]);
          var netAmt  =  (amt-headerDiscount)+addlAmount;
          lstrFinalBillAmount = lstrFinalBillAmount + netAmt;
        }
      }
      if(g.fnValCheck(lstrSelectedBooking)){
        lstrFinalBillAdvAmount = lstrSelectedBooking[0]["ADV_AMT"]??0.00;

      }
      lstrFinalBillBalance =  lstrFinalBillAmount - lstrFinalBillAdvAmount;
    });

  }

  fnFinalBill(){

    if(g.fnValCheck(lstrSelectedBookingAllItems)){
      setState(() {
        lastOrder = [];
        if(g.fnValCheck(lstrSelectedBookingAllItems)){
          for (var e in lstrSelectedBookingAllItems){
            lastOrder.add({
              "DISHCODE":e['STKCODE'].toString(),
              "DISHDESCP":e['STKDESCP'].toString(),
              "QTY":e['QTY1'].toString(),
              "PRICE1":e["RATE"].toString(),
              "WAITINGTIME":"",
              "NOTE":"",
              "PRINT_CODE":null,
              "REMARKS":"",
              "UNIT1":e['UNIT'],
              "KITCHENCODE":e['KITCHENCODE'],
              "ADDON_YN":"",
              "ADDON_STKCODE":"",
              "CLEARED_QTY":"0",
              "NEW":"Y",
              "OLD_STATUS":"",
              "TAXINCLUDE_YN":e['RATE_INCLUDE_TAX'],
              "VAT":e['TAXPERC'],
              "TAX_AMT":0,
              "STATUS":"P"
            });
          }
        }
      });
    }

    Navigator.push(context, MaterialPageRoute(
        builder: (context) => QuickSale(
          datalist: lastOrder,
          mode: "F",
          bookingNo: lstrSelectedBookingNo,
          bookingDoctype: wstrDoctype,
          advanceAmount: lstrFinalBillAdvAmount,
          fnCallBackVoid: fnFinalCallBackVoid,

        )
    ));
  }
  fnFinalCallBackVoid(){
    setState(() {
      lstrScheduleSelection = 'T';
      // header
      lstrSelectedBookingNo = '';
      lstrSelectedBookingSts ='';
      lstrSelectedBookingTables = [];
      lstrSelectedBooking =[];
      lstrSelectedBookingItems = [];
      lstrSelectedBookingAllItems= [];
      lstrSelectedBookingInvoice = [];
      lstrSelectedBookingInvoices = [];
      lstrSelectedBookingDocType = '';
      lstrSelectedBookingYearcode = '';
      lstrSelectedBookingDate ='';
      lstrSelectedBookingUser = '';
      wstrDoctype= '';
      lstrOldAdvanceAmt =0.0;
      // details
      lstrSelectedBookingAllItems = [];
      lstrSelectedBooking =[];
      lstrSelectedBookingItems =[];
      lstrSelectedBookingTables =[];
    });
    fnGetBooking(null, null, null, lstrScheduleSelection);
  }

  //============================API CALL==============================
  fnGetBooking(docno,dateFrom,dateTo,mode){
    futureGetBooking =  apiCall.getBooking(g.wstrCompany, g.wstrYearcode, "RBK", docno, mode, dateFrom, dateTo,
        null,null,null,
        null,null);
    futureGetBooking.then((value) => fnGetBookingSuccess(value));
  }
  fnGetBookingSuccess(value){
    if(mounted){
      setState(() {
      });
    }
    print(value);
  }

  fnGetBookingDet(docno){
    futureGetBookingDet =  apiCall.getBooking(g.wstrCompany, g.wstrYearcode, "RBK", docno, null, null, null,null,null,null,
        null,null);
    futureGetBookingDet.then((value) => fnGetBookingDetSuccess(value));
  }
  fnGetBookingDetSuccess(value){
    print(value);
    if(mounted){
      if(g.fnValCheck(value)){
        setState(() {
          lstrSelectedBookingAllItems = [];
          lstrSelectedBooking =value["Table1"];
          lstrSelectedBookingItems =value["Table2"];
          lstrSelectedBookingTables =value["Table3"];
          lstrSelectedBookingInvoice =value["Table5"];
          lstrSelectedBookingInvoices =value["Table4"];

          for(var e in lstrSelectedBookingItems){
            lstrSelectedBookingAllItems.add(e);

          }


          var stockCodeList  = [];

          try{
            lstrSelectedInvDocno = lstrSelectedBooking[0]["INV_DOCNO"];
          }catch(e){
            lstrSelectedInvDocno = '';
          }
          print('----------------------------------$lstrSelectedInvDocno');
          for(var e in lstrSelectedBookingAllItems){
            if(!stockCodeList.contains(e["STKCODE"])){
              stockCodeList.add(e["STKCODE"]);
            }

          }

          print(stockCodeList);

          var tempSelectedItems = [];
          for(var e in  stockCodeList){
            var selectedData = g.mfnJson(lstrSelectedBookingAllItems);
            selectedData.retainWhere((i){
              return i["STKCODE"] == e ;
            });
            var qty = 0.0;
            var gramt =  0.0;
            var taxamt =  0.0;
            var amtFc =  0.0;

            if(selectedData.length > 0){

              for(var f in selectedData){
                qty += g.mfnDbl(f["QTY1"].toString());
                amtFc += g.mfnDbl(f["AMTFC"].toString());
                gramt += g.mfnDbl(f["GRAMT"].toString());
                taxamt += g.mfnDbl(f["TAXABLE_AMT"].toString());
              }
              var arr =  selectedData[0];
              arr["QTY1"] = qty;
              arr["AMT"] =  amtFc;
              arr["AMTFC"] =  amtFc;
              arr["GRAMT"] =  gramt;
              arr["GRAMTFC"] =  gramt;
              arr["TAXABLE_AMT"] =  taxamt;
              arr["TAXABLE_AMTFC"] =  taxamt;
              tempSelectedItems.add(arr);
            }
          }

          setState(() {
            lstrSelectedBookingAllItems = tempSelectedItems;
          });


          for(var e in lstrSelectedBookingInvoice){
            //lstrSelectedBookingAllItems.add(e);
          }
        });


      }
    }
  }

  fnGetEvents(){
    futureEvents =  apiCall.getEventMast();
    futureEvents.then((value) => fnGetEventsSuccess(value));
  }
  fnGetEventsSuccess(value){

  }

  fnGetGuest(){
    futureGuest = apiCall.getGuest(txtBMobileNo.text.contains("+971") ?txtBMobileNo.text: lstrMobArea.toString() + txtBMobileNo.text );
    futureGuest.then((value) => fnGuestSuccess(value));
  }
  fnGuestSuccess(value){
    if(g.fnValCheck(value)){
      var dataList =  value[0];
      txtBPartyCode.text = dataList["GUEST_CODE"].toString();
      txtBPartyName.text = dataList["GUEST_NAME"].toString();
      txtBTele.text = dataList["TEL"].toString();
      txtBMobile2.text = dataList["CONTACT_MOBILE"].toString();
      txtBEmail.text = dataList["EMAIL"].toString();
      txtBAddress.text = dataList["ADD1"].toString();
      txtBDob.text = formatDate2.format(DateTime.parse(dataList["DOB"].toString()));
    }
  }

  fnSaveBookingApi(mode){

    print(result_TIME);
    if(result_TIME){
      setState(() {
        saveSts = true;
      });
      showToast( 'Check Selected From and To Time');
    }else{
      g.wstrContext = this.context;
      futureBooking =  apiCall.saveBooking(lstrRslBooking, lstrRslDetBooking, lstrRslBookingTable, lstrRsl, lstrRslDet, lstrRetailPay, lstrRslAddlCharge, lstrBookingGuest, mode,g.wstrPrinterPath);
      futureBooking.then((value) => fnSaveBookingApiSuccess(value));
      setState(() {
        saveSts = true;
      });
    }
  }
  fnSaveBookingApiSuccess(value){

    if(g.fnValCheck(value)){
      var sts = value[0]['STATUS'].toString();
      var msg = value[0]['MSG'];
      if(sts == '1'){
        showToast( msg);
        fnClear();
        if(mounted){
          setState(() {
            lstrSelectedBookingNo = '';
            lstrSelectedBookingSts ='';
            lstrSelectedBookingTables = [];
            lstrSelectedBooking =[];
            lstrSelectedBookingItems = [];
            lstrSelectedBookingAllItems= [];
            lstrSelectedBookingInvoice = [];
            lstrSelectedBookingInvoices = [];
            lstrSelectedBookingDocType = '';
            lstrSelectedBookingYearcode = '';
            lstrSelectedBookingDate ='';
            lstrSelectedBookingUser = '';
            wstrDoctype= '';
            lstrOldAdvanceAmt =0.0;
            // details
            lstrSelectedBookingAllItems = [];
            lstrSelectedBooking =[];
            lstrSelectedBookingItems =[];
            lstrSelectedBookingTables =[];

            fnGetBooking(null,null,null,"T");
            fnGetBookingDet(null);
            lstrScheduleSelection  =  'T';
            wstrPageMode = "VIEW";
          });
        }

      }
      showToast( msg);
    }

  }

  fnPrintBooking(docno,docType){
    print('-------------------------------BOOKING PRINT');
    g.wstrContext = this.context;
    futureBookingPrint = apiCall.printInvoiceBooking(g.wstrCompany, g.wstrYearcode, docno, docType, 1, g.wstrPrinterPath, g.wstrUserCd, g.wstrDeivceId);
    futureBookingPrint.then((value) => fnPrintBookingSuccess(value));
  }
  fnPrintBookingSuccess(value){
    if(g.fnValCheck(value)){
      showToast( 'Success');
    }
  }

  fnDeleteAlert(){
    PageDialog().deleteDialog(context, fnDeleteData);
  }

  fnDeleteData(){

    Navigator.pop(context);
    g.wstrContext = this.context;
    if(g.fnValCheck(lstrSelectedBooking)){
      var dataList =  lstrSelectedBooking[0];
      var DOCNO = dataList['DOCNO'].toString();
      var DOCTYPE = dataList['DOCTYPE'].toString();
      var PARTYCODE = dataList['PARTYCODE'].toString();
      var GUESTCODE = dataList['GUESTCODE'].toString();
      var DOCDATE = dataList['DOCDATE'].toString();
      futureBooking = apiCall.deleteBooking(g.wstrCompany,g.wstrYearcode,DOCNO,DOCTYPE,PARTYCODE);
      futureBooking.then((value) => fnBookingDeleteSuccess(value));
    }



  }
  fnBookingDeleteSuccess(value){


    if(value[0]['STATUS'].toString() == '1'){
      showToast( 'Successfully deleted');

      setState(() {
        // header
        lstrSelectedBookingNo = '';
        lstrSelectedBookingSts ='';
        lstrSelectedBookingTables = [];
        lstrSelectedBooking =[];
        lstrSelectedBookingItems = [];
        lstrSelectedBookingAllItems= [];
        lstrSelectedBookingInvoice = [];
        lstrSelectedBookingInvoices = [];
        lstrSelectedBookingDocType = '';
        lstrSelectedBookingYearcode = '';
        lstrSelectedBookingDate ='';
        lstrSelectedBookingUser = '';
        wstrDoctype= '';
        lstrOldAdvanceAmt =0.0;
        // details
        lstrSelectedBookingAllItems = [];
        lstrSelectedBooking =[];
        lstrSelectedBookingItems =[];
        lstrSelectedBookingTables =[];
      });
      fnGetBooking(null, null, null, lstrScheduleSelection);

    }else{
      showToast( value[0]['MSG']);
    }


  }

  fnPrintBookingInvoice(docno) async{
    print('-------------------------------INVOICE PRINT');
    if(printRslHistory){
      setState(() {
        printRslHistory = false;
      });
      futureBookingInvPrint =  apiCall.printInvoice(g.wstrCompany, g.wstrYearcode, docno, "RSL", 1, g.wstrPrinterPath,"");
      futureBookingInvPrint.then((value) => fnPrintHistorySuccess(value));

    }

  }
  fnPrintHistorySuccess(value){

    setState(() {
      printRslHistory = true;
    });
  }

  //============================NAVIGATION ===========================

  fnClose(){
    if(wstrPageMode != "VIEW"){
      PageDialog().clearDialog(context, fnBack);
    }else{
      Navigator.pop(context);
    }

  }
  fnBack(){
    Navigator.pop(context);
    if(wstrPageMode != "VIEW"){
      setState(() {
        wstrPageMode = "VIEW";
      });
    }else{
      Navigator.pop(context);
    }
  }

  fnTimeCheck(newTime){

  }

  fnTimeCompare(fromTime,toTime){

    var result='Y';

    // checking condition empty or not
    var lstrFromTime= '';
    var lstrToTime = '';

    try{
       lstrFromTime = fromTime.format(context).toString();
       lstrToTime = toTime.format(context).toString();


       final now = new DateTime.now();
       var Time_from = DateTime(now.year, now.month, now.day, fromTime.hour, fromTime.minute);
       var Time_to = DateTime(now.year, now.month, now.day, toTime.hour, toTime.minute);

       // ---------- chaging time into date time format
       DateTime dt1= Time_from;
       DateTime dt2=Time_to ;
       if(dt1.compareTo(dt2) == 0){
         setState(() {
           result = 'Y';
           result_TIME = false;
         });

       }

       if(dt1.compareTo(dt2) < 0){
         setState(() {
           result = 'Y';
           result_TIME = false;
         });
       }

       if(dt1.compareTo(dt2) > 0){
         setState(() {
           result = 'N';
           result_TIME = true;
         });
       }

    }catch (e){
      lstrFromTime= '';
      lstrToTime = '';

    }



    return result;
  }

  // Drawer -------------------- function

  Future<void> _selectDate_Drawer(BuildContext context,var tag) async {

    if(tag=='F'){
      final DateTime? pickedDate = await showDatePicker(
          context: context,
         // initialDate:currentDate_From!,
          initialDate:DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2050));
      if (pickedDate != null && pickedDate != currentDate_From ) {
        var sts ;
        var cmpDate = pickedDate;
        cmpDate = DateTime.parse(formatDate1.format(cmpDate));
        var fromDate =  cmpDate;
        var toDate = currentDate_To == null
            ? '' :  DateTime.parse(formatDate1.format(currentDate_To!));

        var result = fnCompareDate(fromDate,toDate);

        if(!result){
          setState(() {
            currentDate_From = pickedDate;
          });
        }else{
          showToast( 'Selected date is grater than from date');
        }


      }
    }else if(tag == 'T'){
      final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate:DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2050));
      if (pickedDate != null && pickedDate !=currentDate_To) {
        var sts ;
        var cmpDate = pickedDate;
        cmpDate = DateTime.parse(formatDate1.format(cmpDate));
        var fromDate = currentDate_From == null
            ? '' :   DateTime.parse(formatDate1.format(currentDate_From!));
        var toDate = cmpDate;

        var result = fnCompareDate(fromDate,toDate);

        if(!result){
          setState(() {
            currentDate_To = pickedDate;
          });
        }else{
          showToast( 'Selected date is grater than from date');
        }
      }
    }
  }


  Future<void> _selectTime(BuildContext context,var tag) async {




    if(tag=='F'){
      var rS = '';
      final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (newTime != null) {

        setState(() {
          timeFrom_Drawer = newTime;
        });
       /* if(timeTo_Drawer == null){
          setState(() {
            timeFrom_Drawer = newTime;
          });
        }else{

          rS =  fnTimeCompare(newTime,timeTo_Drawer);
          print(rS);
          if(rS=='N'){

            showToast( 'Selected To Time is Less than From Time');
            return;
          }else{
            setState(() {
              timeFrom_Drawer = newTime;
            });

          }
        }*/
      }
    }else if(tag == 'T'){
      var rS = '';
      final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime:TimeOfDay.now(),// timeTo_Drawer,
      );
      if (newTime != null) {
        setState(() {
          timeTo_Drawer = newTime;
        });


     /*   if(timeFrom_Drawer == null){

          setState(() {
            timeTo_Drawer = newTime;
          });

        }else{
          rS =  fnTimeCompare(timeFrom_Drawer,newTime);
          print(rS);
          if(rS=='N'){
            // timeTo_Drawer = newTime;
            showToast( 'Selected To Time is Less than From Time');
            return;
          }else{
            setState(() {
              timeTo_Drawer = newTime;
            });

          }
        }*/

      }
    }




  }
  fnClearView(){
    setState(() {
      txtGuestCode.text = '';
      txtDocNum_D.text = '';
      txtArea_D.text = '';
      timeFrom_Drawer = null;
      timeTo_Drawer   = null;
      currentDate_From = null;
      currentDate_To = null;
      lstrSelectedStatusMode = 'STATUS';

    });

  }

  // COMNPARING DATE
  fnCompareDate(fromDate,toDate){


    var result = false;

    try{
      DateTime dt1= fromDate;
      DateTime dt2=toDate ;
      // Date Compare---------------------------
      if(dt1.isBefore(dt2)){
        result = false;
      } else  if(dt1.isAfter(dt2)){
        result = true;
      }else if(dt1.isAtSameMomentAs(dt2)){
        result = false;
      }
    }catch(e){

    }
    return result;
  }

}
