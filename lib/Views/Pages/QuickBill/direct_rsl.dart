
import 'dart:async';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/lookup.dart';
import 'package:beamsbistro/Views/Components/lookup_alert.dart';
import 'package:beamsbistro/Views/Components/responsiveHelper.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:beamsbistro/Views/Pages/Bill/addlAmount.dart';
import 'package:beamsbistro/Views/Pages/Bill/advance_amount.dart';
import 'package:beamsbistro/Views/Pages/Bill/discount.dart';
import 'package:beamsbistro/Views/Pages/Bill/openingCash.dart';
import 'package:beamsbistro/Views/Pages/Bill/payment.dart';
import 'package:beamsbistro/Views/Pages/Bill/printerSelection.dart';
import 'package:beamsbistro/Views/Pages/Bill/return.dart';
import 'package:beamsbistro/Views/Pages/Bill/shiftClosing.dart';
import 'package:beamsbistro/Views/Pages/Booking/booking.dart';
import 'package:beamsbistro/Views/Pages/Login/userLogin.dart';
import 'package:beamsbistro/Views/Pages/QuickBill/quicksale.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'invoice.dart';
import 'invoice_status.dart';

class DirectRSL extends StatefulWidget {
  const DirectRSL({Key? key}) : super(key: key);

  @override
  _DirectRSLState createState() => _DirectRSLState();
}

class _DirectRSLState extends State<DirectRSL> {

  //Global
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var g  =  Global();
  var apiCall  = ApiCall();
  late Future<dynamic> futureMenu;
  late Future<dynamic> futureOrderSave;
  late Future<dynamic> futurePrint;
  late Future<dynamic> futureRsl;
  late Future<dynamic> futureRslSts;
  late Future<dynamic> futureRslFinish;
  late Future<dynamic> futureEvents;
  late Future<dynamic> futureGuest;
  late Future<dynamic> futureBooking;
  late Future<dynamic> futureGetBooking;
  late Future<dynamic> futureGetBookingDet;
  late Future<dynamic> futureGetHoldRsl;

  //Page Variable
  var wstrPageMode = "ADD";
  var lastOrder = [];
  var lastOrderHead = [];
  var lastOrderTable = [];
  var lastOrderAddress = [];
  var lstrSelectedInstructions = [];
  var lstrLastInstructions = [];
  var lstrSelectedBill = [];
  var lstrPaymentList =[];
  var lstrRetailPay = [];
  var lstrSelectedCategoryList = [];
  var lstrSelectedRslItems = [];
  var lstrSelectedRsl = [];

  var lstrRsl = [];
  var lstrRslDet=[];
  var lstrRslBooking = [];
  var lstrRslDetBooking =[];
  var lstrRslBookingTable =[];
  var lstrRslVoid = [];
  var lstrRslVoidDet = [];
  var lstrRslAddlCharge = [];
  var lstrBookingGuest = [];

  var lstrHoldBill = [];
  var lstrHoldRsl = [];
  var lstrHoldRslDet = [];
  var lstrHoldAddl = [];


  //AddlAmount
  var lstrAddlAmount = [];
  var lstrSelectedAddlList  = [];

  var lastLevel= 0;
  var lstrMenuCode ;
  var lstrMenuGroup ;
  var lstrGp1 ;
  var lstrGp2 ;
  var lstrGp3 ;
  var lstrGp4 ;
  var lstrGp5 ;
  var lstrGp6 ;
  var lstrGp7 ;
  var lstrGp8 ;
  var lstrGp9 ;
  var lstrGp10 ;
  var lstrSearch;
  var txtSearchDishCode = new TextEditingController();
  var txtSearchBooking = new TextEditingController();

  var arrMenuCode ;
  var arrMenuGroup ;
  var arrGp1 ;
  var arrGp2 ;
  var arrGp3 ;
  var arrGp4 ;
  var arrGp5 ;
  var arrGp6 ;
  var arrGp7 ;
  var arrGp8 ;
  var arrGp9 ;
  var arrGp10 ;

  var lstrSelectedStkCode = '';
  var lstrSelectedStkDescp = '';
  var lstrSelectedDishGroup = '';
  var lstrSelectedRate = '';
  var lstrKitchenNote = '';
  var lstrSelectedQty = '';
  var lstrSelectedNote= '';
  var lstrSelectedCategory = '';
  var lstrSelectedOrderType = "A";
  var lstrPrintDocno  =  '';
  var lstrSelectedDocno  = '';
  var lstrSelectedUser  = '';
  var lstrSelectedDate = '';


  var formatDateD = new DateFormat('yyyy-MM-dd');
  var formatDate = new DateFormat('dd-MM-yyyy hh:mm');
  var formatTime = new DateFormat('hh:mm a');
  var formatTimeSecond = new DateFormat('hh:mm:ss a');
  var formatDate1 = new DateFormat('dd MMMM yyyy');
  var formatDate2 = new DateFormat('dd-MM-yyyy');
  var formatDateDb = new DateFormat('yyyy-MM-dd');

  //Booking
  DateTime currentDate = DateTime.now();
  DateTime dob = DateTime.now();
  TimeOfDay timeFrom = TimeOfDay(hour: 7, minute: 15);
  TimeOfDay timeTo = TimeOfDay(hour: 7, minute: 15);
  var lstrNoOfPersons = 1;
  var _radioValue = 0 ;
  var lstrSelectedEvent = '' ;
  var lstrSelectedEventDescp = '' ;
  var lstrAreaDescp = '' ;
  var lstrSelectedBookingNo = '';
  var finalBillYn = 'N';
  var lstrSelectedBookingDocType = '';
  var lstrSelectedBookingYearcode = '';
  var lstrSelectedBookingDate = '';
  var lstrSelectedBookingUser = '';
  var lstrSelectedBookingItems = [];
  var lstrSelectedBookingAllItems = [];
  var lstrSelectedBookingTables = [];
  var lstrSelectedBookingInvoices = [];
  var lstrSelectedBookingInvoice = [];
  var lstrSelectedBooking = [];
  var lstrSelectedBookingInvNo = '';
  var lstrFinalBillAmount = 0.00;
  var lstrFinalBillBalance = 0.00;
  var lstrFinalBillAdvAmount = 0.00;

  var lstrMenuSelection  =  "";
  var lstrMobArea = "+971";
  var lstrScheduleSelection  =  'T';
  var lstrSelectedInvoiceMode  =  'C';
  var lstrBookingMode  =  'A';
  var lstrTime ;
  late Timer timer;
  late Timer timerTime;

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

  //O- ORDERVIEW |
  var sidePageView = "O";

  //Controller
  var txtQty = new TextEditingController();
  var txtNote = new TextEditingController();
  var txtFullName = TextEditingController();
  var txtLastName = TextEditingController();
  var txtAddress1 = TextEditingController();
  var txtAddress2 = TextEditingController();
  var txtLandMark = TextEditingController();
  var txtMob1 = TextEditingController();
  var txtMob2 = TextEditingController();
  var txtDeliveryNote = TextEditingController();
  var txtKitchenNote = TextEditingController();
  var txtAddNote = TextEditingController();
  var txtVehicleNo = TextEditingController();
  var txtArea  =  TextEditingController();

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

  bool creditCheck =  false;
  bool saveSts  = true;
  bool printRsl  = true;
  bool printRslSpot  = true;
  bool printRslHistory  = true;

  var lstrToday;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetRsl(null, null, null, null);
    fnGetMenu();
    fnGetEvents();
    lstrMenuSelection = 'H';
    sidePageView = "H";
    var now = DateTime.now();
    lstrToday = DateTime.parse(formatDateD.format(now));
   // timerTime = Timer.periodic(Duration(seconds: 1), (Timer t) => fnUpdateTime());

  }
  @override
  void dispose() {

    //timer.cancel();
   // timerTime.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    g.wstrContext = context;
    return WillPopScope(child: Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 16),
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height*0.1,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: boxBaseDecoration(Colors.white, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset("assets/icons/bislogo.png",
                          width: 100,),
                        gapWC(10),
                      ],
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        tc(g.wstrUserName.toString(), Colors.blueGrey, 18),
                        gapW(),
                        tc(lstrTime??'',Colors.blueGrey,18),
                        gapWC(20),
                        tc(g.wstrShifDescp.toString().toUpperCase(),Colors.blueGrey,18),
                        gapWC(20),

                        GestureDetector(
                          onTap: (){
                            fnClockOut();
                          },
                          child: Container(
                            height: 30,
                            width: 80,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(PrimaryColor, 30),
                            child: Icon(Icons.access_time_outlined,color: Colors.white,size: 20,),
                          ),
                        ),

                        GestureDetector(
                          onTap: (){
                             fnOpeningCash();
                          },
                          child: Container(
                            height: 30,
                            width: 80,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(Colors.green, 30),
                            child: Icon(Icons.payments_outlined,color: Colors.white,size: 20,),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            fnChoosePrinter();
                          },
                          child: Container(
                            height: 40,
                            width: 50,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(Colors.amber, 10),
                            child: Icon(Icons.print,color: Colors.black,size: 20,),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            fnSysytemInfo();
                          },
                          child: Container(
                            height: 40,
                            width: 50,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(Colors.amber, 10),
                            child: Icon(Icons.computer_sharp,color: Colors.black,size: 20,),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            fnLogout();
                          },
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: boxBaseDecoration(greyLight, 10),
                            child: Icon(Icons.power_settings_new,color: Colors.red,size: 30,),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: size.height*0.87,
                child: Row(
                  children: [
                    Container(
                      decoration: boxBaseDecoration(Colors.white, 0),
                      padding: EdgeInsets.only(top: 50),
                      width: size.width*0.08,
                      height: size.height*0.86,
                      child: SingleChildScrollView(
                        child:  Column(
                          children: [
                            menuCard("T", "Take Order",Icons.add_circle_outline_outlined),
                            //menuCard("N", "New",Icons.add_circle_outline_outlined),
                            menuCard("H", "Invoice",Icons.wysiwyg_rounded),
                            menuCard("I", "Invoice Status",Icons.assignment_turned_in_rounded),
                            menuCard("BT", "Booking",Icons.event_available_sharp),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      height: size.height*0.86,
                      width: size.width*.62,
                      child: lstrMenuSelection == "N"?
                      menuScreenView(size):
                      lstrMenuSelection == "H"?
                      Container(
                        decoration: boxBaseDecoration(greyLight, 0  ),
                        width: size.width*0.55,
                        padding: EdgeInsets.all(10),
                        child: Column(
                            children: [
                              Row(
                                  children: [
                                    invoiceCard('C','COMPLETED'),
                                    invoiceCard('H','HOLD'),
                                  ],
                              ),
                              lstrSelectedInvoiceMode == "C"?
                              Container(
                                decoration: boxBaseDecoration(greyLight, 0  ),
                                height: size.height*0.7,
                                child: FutureBuilder<dynamic>(
                                  future: futureRsl,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return   rslView(snapshot) ;
                                    } else if (snapshot.hasError) {
                                      return Container();
                                    }
                                    // By default, show a loading spinner.
                                    return Center(
                                      child: Container(),
                                    );
                                  },
                                ),
                              ):Container(
                                decoration: boxBaseDecoration(greyLight, 0  ),
                                height: size.height*0.7,
                                  child: rslHoldView()
                              )

                            ],
                        ),
                      ):
                      lstrMenuSelection == "I"?
                      Container(
                        decoration: boxBaseDecoration(greyLight, 0  ),
                        width: size.width*0.55,
                        padding: EdgeInsets.all(10),
                        // child: FutureBuilder<dynamic>(
                        //   future: futureRslSts,
                        //   builder: (context, snapshot) {
                        //     if (snapshot.hasData) {
                        //       return   rslStsView(snapshot) ;
                        //     } else if (snapshot.hasError) {
                        //       return Container();
                        //     }
                        //     // By default, show a loading spinner.
                        //     return Center(
                        //       child: Container(),
                        //     );
                        //   },
                        // ),
                      ):
                      lstrMenuSelection == "T"?
                      Container():
                      lstrBookingMode == "S"?
                      Container(
                        padding: EdgeInsets.all(10),
                        height: size.height*0.86,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  tc('Booking Details',Colors.black,25),
                                  RoundedInputField(
                                    hintText: 'Search.',
                                    txtRadius: 10,
                                    txtWidth: 0.3,
                                    txtController: txtSearchBooking,
                                    suffixIcon: Icons.cancel_outlined,
                                    suffixIconOnclick: (){
                                      fnClearSearch();
                                    },
                                    onChanged: (value){
                                      fnSearchDishCode();
                                    },
                                  )
                                ],
                              ),

                              gapHC(10),
                              Row(
                                children: [
                                  scheduleCard('T','TODAY'),
                                  scheduleCard('U','UPCOMING'),
                                  scheduleCard('C','COMPLETED'),
                                  scheduleCard('P','PENDING'),
                                ],
                              ),
                              gapHC(10),
                              Container(
                                height: size.height*0.6,
                                child: FutureBuilder<dynamic>(
                                  future: futureGetBooking,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return bookingView(snapshot);
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
                          ),
                        ),
                      ):
                      lstrBookingMode == "N"?
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
                      ):
                      lstrBookingMode == "A"?
                      Container(
                        height: size.height*0.86,
                        width: size.width*.6,
                        child: SingleChildScrollView(
                          child: Column (
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              tc('New Booking',Colors.black,25),
                              gapHC(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(

                                      padding: EdgeInsets.all(10),
                                      width:size.width*.35,
                                      height: size.height*0.75,
                                      decoration: boxBaseDecoration(Colors.white, 15),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Visibility(
                                                  visible: true,
                                                  child:  RoundedInputField(
                                                    hintText: 'Search',
                                                    labelYn: 'Y',
                                                    txtRadius: 5,
                                                    txtWidth: 0.31,
                                                    txtController: txtBPartyCode,
                                                    suffixIcon: Icons.search,
                                                    suffixIconOnclick: (){
                                                      fnLookup('PARTYCODE');
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
                                                  txtWidth: 0.25,
                                                  maxLength: 10,
                                                  textType: TextInputType.number,
                                                  txtController: txtBMobileNo,
                                                  suffixIcon: Icons.search,
                                                  suffixIconOnclick: (){
                                                    fnGetGuest();
                                                  },
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
                                                  txtWidth: 0.16,
                                                  maxLength: 10,
                                                  textType: TextInputType.number,
                                                  txtController: txtBMobile2,
                                                ),
                                                RoundedInputField(
                                                  hintText: 'Telephone',
                                                  labelYn: 'Y',
                                                  txtRadius: 5,
                                                  txtWidth: 0.16,
                                                  textType: TextInputType.number,
                                                  txtController: txtBTele,
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
                                                    txtWidth: 0.2,
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
                                    width: size.width*.2,
                                    height: size.height*0.75,
                                    decoration: boxBaseDecoration(Colors.white, 15),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: size.height*0.32,
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
                                          RoundedInputField(
                                            hintText: 'Area',
                                            labelYn: 'Y',
                                            txtRadius: 5,
                                            txtWidth: 0.2,
                                            txtController: txtArea,
                                            suffixIcon: Icons.search,
                                            suffixIconOnclick: (){
                                              fnLookup('AREA');
                                            },
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              RoundedInputField(
                                                hintText: 'No.Of. Person',
                                                labelYn: 'Y',
                                                txtWidth: 0.1,
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

                                  gapWC(0),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                      :lstrBookingMode == "I"?
                      menuScreenView(size):
                      Container(),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      color: Colors.white,
                      height:  size.height*0.86,
                      width: size.width*.3,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            sidePageView == "O"?
                            (lastOrder.length==0 ?
                            Container(
                              height:  size.height*0.86,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    gapHC(10),
                                    Column(
                                      children: [
                                        Image.asset("assets/icons/ticket.png",
                                          width: 200,),
                                        gapHC(10),
                                        ts("  Choose Items...".toString(),greyLight,15),
                                      ],
                                    ),
                                    // GestureDetector(
                                    //   onTap: (){
                                    //     fnCancelAddMode();
                                    //   },
                                    //   child: Container(
                                    //     width: size.width*0.3,
                                    //     height: 50,
                                    //     decoration: boxDecoration(PrimaryColor, 10),
                                    //     child: Center(
                                    //       child: tc('Close',Colors.white,20),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                            ):
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                lstrSelectedBookingNo.isEmpty?Container():
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    tc('Booking #' +'' , Colors.black, 15),
                                    Row(
                                        children: [
                                          tc(lstrSelectedBookingNo.toString() , PrimaryColor, 15),
                                          gapWC(5),
                                          GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  lstrSelectedBookingNo = "";
                                                });
                                              },
                                              child:  Icon(Icons.cancel_outlined,size: 20,),
                                          )
                                        ],
                                    )
                                  ],
                                ),
                                gapHC(5),
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
                                          itemClearedQty = int.parse(dataList["CLEARED_QTY"].toString());
                                          itemClearedQtyS = itemClearedQty == 0 ? '' :itemClearedQty.toString();

                                          return GestureDetector(
                                            onTap: (){
                                              fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
                                            },
                                            onLongPress: (){
                                              double.parse(itemQty) > 0? fnShowNotePopupSelected(dataList):'';
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
                                                                th(itemName.toString() + '   x ' + itemQty.toString(),Colors.black,15),
                                                                gapHC(2),
                                                                tcn('AED  ' + itemPrice.toString(),PrimaryColor,14),
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
                                          ts(lstrTaxable.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Vat Amount', Colors.black, 16),
                                          ts(lstrLastVat.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      g.wstrDiscountYn?
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Discount', Colors.black, 16),
                                          GestureDetector(
                                            onTap: (){
                                              fnDiscount();
                                            },
                                            child: Container(
                                              height: 20,
                                              width: size.width*0.15,
                                              decoration: boxBaseDecoration(greyLight,0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  tc(lstrLastDiscount.toStringAsFixed(3),Colors.black,15)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ):gapHC(0),
                                      gapHC(5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: ts('Additional Amount', Colors.black, 16),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              fnAddlAmount();
                                            },
                                            child: Container(
                                              height: 20,
                                              width: size.width*0.15,
                                              decoration: boxBaseDecoration(greyLight,0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  tc(lstrLastAddlAmount.toStringAsFixed(3),Colors.black,15)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      finalBillYn =="Y"? Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Advance Amount', Colors.black, 16),
                                          ts(lstrFinalBillAdvAmount.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ):gapHC(5),
                                      gapHC(5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          tc('Net Amount', Colors.black, 18),
                                          tc(lstrLastTotal.toStringAsFixed(3), PrimaryColor, 18)
                                        ],
                                      ),
                                      gapHC(10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Paid Amount', Colors.black, 16),
                                          ts(lstrPaidAmt.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Change to', Colors.black, 16),
                                          ts(lstrBalanceAmt.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      // Container(
                                      //   padding: EdgeInsets.all(5),
                                      //   color: greyLight,
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       tc('Total Amount', Colors.red, 18),
                                      //       gapW(),
                                      //       tc(lstrOrderAmountV.toStringAsFixed(3), Colors.red, 20),
                                      //     ],
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                                gapHC(5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        fnCancelAddMode();
                                      },
                                      child: Container(
                                        width: size.width*0.03,
                                        height: 40,
                                        decoration: boxBaseDecoration(greyLight, 10),
                                        child: Center(
                                          child: Icon(Icons.cancel_outlined,size: 20,),
                                        ),
                                      ),
                                    ),
                                    creditCheck ? Container():
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          sidePageView = "A";
                                        });
                                        fnGetBooking(null, null, null, "T");
                                      },
                                      child: Container(
                                        width: size.width*0.04,
                                        height: 40,
                                        decoration: boxBaseDecoration(greyLight, 10),
                                        child: Center(
                                          child: Icon(Icons.confirmation_number_rounded,size: 20,),
                                        ),
                                      ),
                                    ),
                                    lstrSelectedBookingNo.isEmpty ?
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          sidePageView = "G";
                                        });
                                        fnGetBooking(null, null, null, "T");
                                      },
                                      child: Container(
                                        width: size.width*0.04,
                                        height: 40,
                                        decoration: boxBaseDecoration(greyLight, 10),
                                        child: Center(
                                          child: Icon(Icons.person,size: 20,),
                                        ),
                                      ),
                                    ):Container(),
                                
                                    GestureDetector(
                                      onTap: (){
                                        if(lstrSelectedBookingNo.isEmpty || finalBillYn ==  "Y"){
                                          if(!creditCheck){
                                            fnPayPopup();
                                          }else{
                                            fnSave();
                                          }
                                        }else{
                                          fnSave();
                                        }
                                      },
                                      child: Container(
                                        width: size.width*0.14,
                                        height: 40,
                                        decoration: boxBaseDecoration(PrimaryColor, 30),
                                        child: Center(
                                          child: tc('PAY NOW',Colors.white,13),
                                        ),
                                      ),
                                    )
                                  ],
                                )

                              ],
                            )):
                            sidePageView == "D"?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.menu_book),
                                        gapW(),
                                        h1(lstrSelectedStkDescp.toString())
                                      ],
                                    ),
                                    tc('AED  '+lstrSelectedRate.toString() ,PrimaryColor,15),
                                    gapHC(10),
                                    ts('Qty',Colors.black,15),
                                    gapHC(5),
                                    Container(
                                      height: 45,
                                      width: size.width*0.1,
                                      padding: EdgeInsets.all(3),
                                      decoration: boxBaseDecoration(greyLight, 5),
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(fontSize: 18.0),
                                        maxLines: 10,
                                        controller: txtQty,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    // tc('x ' + lstrSelectedQty.toString() ,Colors.black,20),
                                    gapHC(10),
                                    ts('Note',Colors.black,15),
                                    gapHC(5),
                                    Row(
                                      children: [
                                        Container(
                                          height: 120,
                                          width: size.width*0.2,
                                          padding: EdgeInsets.all(10),
                                          decoration: boxBaseDecoration(greyLight, 5),
                                          child: TextField(
                                            keyboardType: TextInputType.multiline,
                                            style: TextStyle(fontSize: 18.0),
                                            maxLines: 10,
                                            controller: txtNote,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        gapWC(10),
                                        GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              txtNote.text = '';
                                            });
                                          },
                                          child: Container(
                                            decoration: boxBaseDecoration(blueLight, 5),
                                            height: 120,
                                            width: 50,
                                            child: Center(
                                              child: Icon(Icons.delete_sweep_sharp),
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                    gapHC(10),
                                    g.fnValCheck(lstrLastInstructions)?
                                    Container(
                                      height: 100,
                                      child: GridView.builder(
                                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                              maxCrossAxisExtent: 200,
                                              childAspectRatio:  6,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20),
                                          itemCount:  lstrLastInstructions.length,
                                          itemBuilder: (BuildContext ctx, index) {
                                            var dataList = lstrLastInstructions[index];
                                            var code = dataList['CODE'] ??'';
                                            var descp = dataList['DESCP']??'';
                                            var dishGrop = dataList['DISH_GROUP']??'';
                                            var sts = true;
                                            // if(lstrSelectedDishGroup == dishGrop){
                                            //   sts = true;
                                            // }

                                            return sts ? GestureDetector(
                                              onTap: (){
                                                fnUpdateNoteText(descp);
                                              },
                                              child: Container(
                                                height: 30,
                                                decoration: boxBaseDecoration(Colors.amber, 5),
                                                padding: EdgeInsets.all(3),
                                                child: Center(
                                                  child: tc(descp.toString(),Colors.black,15),
                                                ),
                                              ),
                                            ):Container() ;
                                          }),
                                    ) : Container(),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          if(lstrMenuSelection == "N"){
                                            sidePageView = "O";
                                          }
                                          if(lstrMenuSelection == "B"){
                                            sidePageView = "";
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 40,
                                        width: size.width*0.06,
                                        decoration: boxBaseDecoration(greyLight, 5),
                                        child: Center(
                                          child: tc('Close',Colors.black,15),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        fnItemNoteCallBack(lstrSelectedStkCode,txtNote.text.toString(),txtQty.text);
                                      },
                                      child: Container(
                                        height: 40,
                                        width: size.width*0.2,
                                        decoration: boxDecoration(PrimaryColor, 5),
                                        child: Center(
                                          child: tc('ADD',Colors.white,15),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ):
                            sidePageView == "A"?
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: size.height*0.7,
                                  padding: EdgeInsets.all(5),
                                  child: FutureBuilder<dynamic>(
                                    future: futureGetBooking,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return bookingNoSelectionView(snapshot);
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
                                GestureDetector(

                                  onTap: (){
                                    setState(() {
                                      sidePageView = "O";
                                    });
                                    //Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 40,
                                    decoration: boxDecoration(PrimaryColor, 5),
                                    child: Center(
                                      child: tc('CLOSE',Colors.white,20),
                                    ),
                                  ),
                                )

                              ],
                            ):
                            sidePageView == "G"?
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: size.height*0.7,
                                  padding: EdgeInsets.all(5),
                                  child: Column(
                                      children: [
                                        RoundedInputField(
                                          hintText: 'Search',
                                          labelYn: 'Y',
                                          txtRadius: 5,
                                          txtWidth: 0.3,
                                          txtController: txtCustomerCode,
                                          suffixIcon: Icons.search,
                                          suffixIconOnclick: (){
                                            fnLookup('CUST');
                                          },
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
                                              txtWidth: 0.2,
                                              maxLength: 9,
                                              textType: TextInputType.number,
                                              txtController: txtCustMobileNo,
                                              suffixIcon: Icons.search,
                                              suffixIconOnclick: (){
                                                fnGetCustomer();
                                              },
                                            ),
                                          ],
                                        ),
                                        RoundedInputField(
                                          hintText: 'Customer Name',
                                          labelYn: 'Y',
                                          txtRadius: 5,
                                          txtWidth: 0.3,
                                          txtController: txtCustomerName,
                                        ),

                                        Row(
                                            children: [
                                              Checkbox(
                                                  activeColor: Colors.green,
                                                  value: creditCheck,
                                                  onChanged: (value){
                                                    setState(() {
                                                      if(creditCheck){
                                                        creditCheck= false;
                                                      }else{
                                                        if(txtCustMobileNo.text.isEmpty){
                                                          showToast( 'Please enter mobile no');
                                                        }else{
                                                          creditCheck= true;
                                                        }

                                                      }
                                                    });
                                              }),

                                              GestureDetector(
                                                  onTap: (){
                                                    setState(() {
                                                      if(creditCheck){
                                                        creditCheck= false;
                                                      }else{
                                                        if(txtCustMobileNo.text.isEmpty){
                                                          showToast( 'Please enter mobile no');
                                                        }else{
                                                          creditCheck= true;
                                                        }
                                                      }
                                                    });
                                                  },
                                                 child: tc('HOLD BILL',Colors.black,20),
                                              )
                                            ],
                                        )
                                      ],
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            txtCustomerName.clear();
                                            txtCustomerCode.clear();
                                            txtCustMobileNo.clear();
                                            sidePageView = "O";
                                            creditCheck =  false;
                                          });
                                          //Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 40,
                                          width:size.width*0.05,
                                          decoration: boxBaseDecoration(Colors.amber, 5),
                                          child: Center(
                                            child: Icon(Icons.clear),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            sidePageView = "O";
                                          });
                                          //Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 40,
                                          width:size.width*0.22,
                                          decoration: boxDecoration(PrimaryColor, 5),
                                          child: Center(
                                            child: tc('DONE',Colors.white,20),
                                          ),
                                        ),
                                      )
                                    ],
                                )
                              ],
                            ):
                            lstrMenuSelection == "H"?
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    tc('Order #' +lstrSelectedDocno.toString() , Colors.black, 15),
                                    tc(lstrSelectedOrderType , PrimaryColor, 15),
                                  ],
                                ),
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
                                          ts(lstrTaxable.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Vat Amount', Colors.black, 16),
                                          ts(lstrLastVat.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      g.wstrDiscountYn?
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Discount', Colors.black, 16),
                                          GestureDetector(
                                            onTap: (){
                                              //fnDiscount();
                                            },
                                            child: Container(
                                              height: 20,
                                              width: size.width*0.15,
                                              decoration: boxBaseDecoration(greyLight,0),
                                              child:
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  tc(lstrLastDiscount.toStringAsFixed(3),Colors.black,15)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ):gapHC(0),
                                      gapHC(5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: ts('Additional Amount', Colors.black, 16),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              //fnAddlAmount();
                                            },
                                            child: Container(
                                              height: 20,
                                              width: size.width*0.15,
                                              decoration: boxBaseDecoration(greyLight,0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  tc(lstrLastAddlAmount.toStringAsFixed(3),Colors.black,15)
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
                                          tc(lstrLastTotal.toStringAsFixed(3), PrimaryColor, 18)
                                        ],
                                      ),
                                      gapHC(10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Paid Amount', Colors.black, 16),
                                          ts(lstrPaidAmt.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Change to', Colors.black, 16),
                                          ts(lstrBalanceAmt.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      gapHC(10),
                                      GestureDetector(
                                        onTap: (){
                                          fnReturnBill();
                                        },
                                        child: Container(
                                          height: 35,
                                          decoration: boxDecoration(PrimaryColor, 30),
                                          child: Center(
                                            child: tc('REOPEN BILL',Colors.white,15),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                gapHC(5),


                              ],
                            ):
                            lstrMenuSelection == "I"?
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    tc('Order #' +lstrSelectedDocno.toString() , Colors.black, 15),
                                    tc(lstrSelectedOrderType , PrimaryColor, 15),
                                  ],
                                ),
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
                                line(),
                                Container(
                                    height: size.height*0.53,
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
                                          ts(lstrTaxable.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Vat Amount', Colors.black, 16),
                                          ts(lstrLastVat.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      g.wstrDiscountYn?
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Discount', Colors.black, 16),
                                          GestureDetector(
                                            onTap: (){
                                              //fnDiscount();
                                            },
                                            child: Container(
                                              height: 20,
                                              width: size.width*0.15,
                                              decoration: boxBaseDecoration(greyLight,0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  tc(lstrLastDiscount.toStringAsFixed(3),Colors.black,15)
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ):gapHC(0),
                                      gapHC(10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: ts('Additional Amount', Colors.black, 16),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              fnAddlAmount();
                                            },
                                            child: Container(
                                              height: 20,
                                              width: size.width*0.15,
                                              decoration: boxBaseDecoration(greyLight,0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  tc(lstrLastAddlAmount.toStringAsFixed(3),Colors.black,15)
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
                                          tc(lstrLastTotal.toStringAsFixed(3), PrimaryColor, 18)
                                        ],
                                      ),
                                      gapHC(10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Paid Amount', Colors.black, 16),
                                          ts(lstrPaidAmt.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Change to', Colors.black, 16),
                                          ts(lstrBalanceAmt.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      // Container(
                                      //   padding: EdgeInsets.all(5),
                                      //   color: greyLight,
                                      //   child: Row(
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       tc('Total Amount', Colors.red, 18),
                                      //       gapW(),
                                      //       tc(lstrOrderAmountV.toStringAsFixed(3), Colors.red, 20),
                                      //     ],
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                                gapHC(5),


                              ],
                            ):
                            lstrMenuSelection == "B"?
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
                                          itemClearedQty = int.parse(dataList["CLEARED_QTY"].toString());
                                          itemClearedQtyS = itemClearedQty == 0 ? '' :itemClearedQty.toString();

                                          return GestureDetector(
                                            onTap: (){
                                              fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
                                            },
                                            onLongPress: (){
                                              double.parse(itemQty) > 0? fnShowNotePopupSelected(dataList):'';
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
                                          ts(lstrTaxable.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Vat Amount', Colors.black, 16),
                                          ts(lstrLastVat.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Advance Amount', Colors.black, 16),
                                          GestureDetector(
                                            onTap: (){
                                              fnAdvanceAmount();
                                            },
                                              child: Container(
                                                width: 100,
                                                padding: EdgeInsets.only(top: 8,bottom: 8),
                                                decoration: boxBaseDecoration(greyLight, 2),
                                                child:  Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    tc(lstrAdvAmount.toStringAsFixed(3), Colors.black, 16)
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
                                          tc(lstrLastTotal.toStringAsFixed(3), PrimaryColor, 18)
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
                                      //       tc(lstrOrderAmountV.toStringAsFixed(3), Colors.red, 20),
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
                                        height: 35,
                                        width: size.width*.1,
                                        decoration: boxBaseDecoration(Colors.amber, 5),
                                        child: Center(
                                          child: tc('ADD TABLE',Colors.black,15),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        fnClearAll();
                                        fnGetMenu();
                                        setState(() {
                                          lstrBookingMode = "I";
                                        });
                                      },
                                      child: Container(
                                        height: 35,
                                        width: size.width*.1,
                                        decoration: boxBaseDecoration(Colors.amber, 5),
                                        child: Center(
                                          child: tc('ADD ITEM',Colors.black,15),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          lstrBookingMode = "A";
                                        });
                                      },
                                      child: Container(
                                        width: size.width*0.07,
                                        height: 35,
                                        decoration: boxBaseDecoration(Colors.amber, 5),
                                        child: Center(
                                          child: Icon(Icons.person_add_alt_1_rounded),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                gapHC(10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: (){

                                      },
                                      child: Container(
                                        width: size.width*0.05,
                                        height: 40,
                                        decoration: boxBaseDecoration(greyLight, 10),
                                        child: Center(
                                          child: Icon(Icons.cancel_outlined),
                                        ),
                                      ),
                                    ),



                                    GestureDetector(
                                      onTap: (){
                                        saveSts ?  fnBookingSaveAlert():'';
                                      },
                                      child: Container(
                                        width: size.width*0.2,
                                        height: 40,
                                        decoration: boxBaseDecoration(PrimaryColor, 10),
                                        child: Center(
                                          child: tc('SAVE',Colors.white,15),
                                        ),
                                      ),
                                    )
                                  ],
                                )

                              ],
                            ):
                            lstrBookingMode == "S"?(
                            lstrSelectedBookingNo.isEmpty?
                            Container(
                              height:  size.height*0.86,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                  // GestureDetector(
                                  //   onTap: (){
                                  //     setState(() {
                                  //       fnGetEvents();
                                  //       lstrBookingMode = "A";
                                  //       g.wstrLastSelectedTables = [];
                                  //       currentDate =  DateTime.now();
                                  //       sidePageView = "B";
                                  //     });
                                  //   },
                                  //   child: Container(
                                  //     width: size.width*0.3,
                                  //     height: 50,
                                  //     decoration: boxDecoration(Colors.green, 10),
                                  //     child: Center(
                                  //       child: tc('NEW BOOKING',Colors.white,20),
                                  //     ),
                                  //   ),
                                  // ),
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
                                  tc('Selected Tables',Colors.black,15),
                                  gapHC(5),
                                  Container(
                                    height: 40,
                                      child: bookingTablesView(),
                                  ),
                                  gapHC(15),
                                  // Container(
                                  //   height: 40,
                                  //   decoration: boxDecoration(Colors.amber, 5),
                                  //   child: Center(
                                  //     child: tc('Update', Colors.black, 15),
                                  //   ),
                                  // ),
                                  gapHC(20),
                                  GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        lstrBookingMode = "N";
                                        lstrSelectedBookingInvNo = '';
                                        lstrSelectedRslItems = [];
                                        lstrSelectedRsl = [];
                                        lstrSelectedUser = '';
                                        lstrSelectedDate = '';
                                        lstrTaxable = 0.0;
                                        lstrLastVat = 0.0;
                                        lstrLastDiscount = 0.0;
                                        lstrLastTotal = 0.0;
                                      });
                                      fnFinalBillCalc();
                                    },
                                      child: Container(
                                        height: 40,
                                        decoration: boxBaseDecoration(Colors.green, 5),
                                        child: Center(
                                          child: tc('GENERATE INVOICE', Colors.white, 15),
                                        ),
                                      ),
                                  ),

                                  gapHC(5),
                                  // Container(
                                  //   height: 40,
                                  //   decoration: boxBaseDecoration(greyLight , 5),
                                  //   child: Center(
                                  //     child: tc('Cancel', Colors.black, 15),
                                  //   ),
                                  // ),

                                ],
                            )):
                            lstrBookingMode == "N"?
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
                                    height: size.height*0.3,
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
                                          ts(lstrTaxable.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Vat Amount', Colors.black, 16),
                                          ts(lstrLastVat.toStringAsFixed(3), Colors.black, 16)
                                        ],
                                      ),
                                      gapHC(5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: ts('Additional Amount', Colors.black, 16),
                                          ),
                                          tc(lstrLastAddlAmount.toStringAsFixed(3),Colors.black,15)
                                        ],
                                      ),
                                      gapHC(10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          tc('Bill Amount', Colors.black, 18),
                                          tc(lstrLastTotal.toStringAsFixed(3), Colors.black, 18)
                                        ],
                                      ),
                                      gapHC(5),
                                      line(),
                                      gapHC(5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          tc('Total Invoice Amount', Colors.black, 18),
                                          tc(lstrFinalBillAmount.toStringAsFixed(3), Colors.black, 18)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          ts('Advance Amount', Colors.black, 18),
                                          ts(lstrFinalBillAdvAmount.toStringAsFixed(3), Colors.black, 18)
                                        ],
                                      ),
                                      gapHC(5),
                                      line(),
                                      gapHC(5),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          tc(lstrFinalBillBalance.toStringAsFixed(3),Colors.red,30)
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
                                                    lstrBookingMode = "S";
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                                  height: 40,
                                                  width: size.width*0.1,
                                                  decoration: boxBaseDecoration(greyLight, 5),
                                                  child: Center(
                                                    child: tc(' Close',Colors.black,15),
                                                  ),
                                                ),
                                            ),
                                            GestureDetector(
                                                onTap: (){
                                                  setState(() {
                                                    sidePageView = "O";
                                                    lstrBookingMode = "I";
                                                  });
                                                  fnFinalBill();
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                                                  height: 40,
                                                  width: size.width*0.15,
                                                  decoration: boxBaseDecoration(PrimaryColor, 5),
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
                                      //       tc(lstrOrderAmountV.toStringAsFixed(3), Colors.red, 20),
                                      //     ],
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ),
                                gapHC(5),


                              ],
                            ):
                            Container(),
                          ],
                        ),
                      )

                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ), onWillPop: () async{
      return false;
    });
  }

  //======================WIDGET UI================

  GestureDetector menuCard(mode,text,icon) => GestureDetector(
    onTap: (){
      fnClear();
      setState(() {

        lstrMenuSelection = mode;
      });
      if(mode =="N"){
         setState(() {
           sidePageView = "O";
         });
         fnAddNew();
         // Navigator.push(context, MaterialPageRoute(
         //     builder: (context) => QuickSale()
         // ));

      }else if(mode == "H"){
        // setState(() {
        //   lstrSelectedRslItems = [];
        //   lstrSelectedRsl =[];
        //   lstrSelectedDocno = '';
        //   lastOrder = [];
        //   lstrSelectedInvoiceMode = 'C';
        //   sidePageView = "H";
        // });
        // fnGetRsl(null, null, null, null);

        Navigator.push(context, MaterialPageRoute(
            builder: (context) => InvoiceHistory()
        ));
      }else if(mode == "I"){

        //fnGetRslSts(null, null, null, null);

        Navigator.push(context, MaterialPageRoute(
            builder: (context) => InvoiceStatus()
        ));
      } else if (mode  == "B"){
        setState(() {
          fnGetEvents();
          lstrBookingMode = "A";
          g.wstrLastSelectedTables = [];
          currentDate =  DateTime.now();
          sidePageView = "B";
        });

      } else if(mode == "S"){
        setState(() {
          fnGetBooking(null,null,null,"T");
          fnGetBookingDet(null);
          lstrBookingMode = "S";
          lstrScheduleSelection  =  'T';
        });
      }else if(mode =="T"){
        setState(() {
          lstrSelectedRslItems = [];
          lstrSelectedRsl =[];
          lstrSelectedDocno = '';
          lastOrder = [];
          lstrSelectedInvoiceMode = 'C';
          sidePageView = "H";
          lstrMenuSelection = "H";
        });
        //fnGetRsl(null, null, null, null);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => QuickSale()
        ));
      }else if(mode =="BT"){
        setState(() {
          lstrSelectedRslItems = [];
          lstrSelectedRsl =[];
          lstrSelectedDocno = '';
          lastOrder = [];
          lstrSelectedInvoiceMode = 'C';
          sidePageView = "H";
          lstrMenuSelection = "H";
        });
        //fnGetRsl(null, null, null, null);
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Booking()
        ));
      }
    },
    child: Container(
      margin: EdgeInsets.only(bottom: 6),
      decoration: boxBaseDecoration(lstrMenuSelection == mode ?SubColor : Colors.white,5),
      height: 70,
      width: 90,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center ,
        children: [
          Icon(icon,size: 23,),
          tc(text,Colors.black,10)
        ],
      ),
    ),
  );
  GestureDetector scheduleCard(mode,text) => GestureDetector(
    onTap: (){
      fnClear();
      setState(() {

        lstrScheduleSelection = mode;
      });
      fnGetBooking(null, null, null, lstrScheduleSelection);
    },
    child: Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: boxBaseDecoration(lstrScheduleSelection == mode ? Colors.amber:Colors.white, 5),
      height: 40,
      child: Center(
        child: tc(text,Colors.black,15),
      ),
    ),
  );
  GestureDetector invoiceCard(mode,text) => GestureDetector(
    onTap: (){
      fnClear();
      setState(() {
        lstrSelectedInvoiceMode = mode;
      });
      if(lstrSelectedInvoiceMode== "C"){
        fnGetRsl(null, null, null, null);
      }else if(lstrSelectedInvoiceMode== "H"){
        fnGetHoldRsl();
      }
    },
    child: Container(
      margin: EdgeInsets.only(right: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: boxBaseDecoration(lstrSelectedInvoiceMode == mode ? Colors.amber:Colors.white, 5),
      height: 40,
      child: Center(
        child: tc(text,Colors.black,15),
      ),
    ),
  );

  SingleChildScrollView menuScreenView(Size size) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RoundedInputField(
                hintText: 'Search.',
                txtRadius: 5,
                txtWidth: 0.4,
                txtController: txtSearchDishCode,
                suffixIcon: Icons.cancel_outlined,
                suffixIconOnclick: (){
                  fnClearSearch();
                },
                onChanged: (value){
                  fnSearchDishCode();
                },
              ),
              gapWC(15),



            ],
          ),
          lstrMenuGroup != null ?
          Container(
            padding: EdgeInsets.only(left: 10,right: 10),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      fnBackButton();
                    },
                    onLongPress: (){
                      fnBackLongPress();
                    },
                    child:  Container(
                      decoration: boxDecoration(SecondaryColor, 5),
                      width: 60,
                      height: 40,
                      child: Center(
                        child: Icon(Icons.arrow_back_ios_rounded,size: 25,),
                      ),
                    ),
                  )
                  ,
                  Container(
                    height: 40,
                    width: size.width*0.5,
                    child: new FutureBuilder<dynamic>(
                      future: futureMenu,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return menuGroupView(snapshot);
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
              )
          ):
          Container(),
          gapHC(10),
          tc(lstrSelectedCategory.toString(),Colors.black,20),
          gapHC(10),
          Container(
            height: size.height*0.65,
            child: futureMenuview(),
          )
        ],
      ),
    );
  }
  Widget menuGroupView(snapshot){
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data['Table2'].length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data['Table2'][index];
          var code = dataList['CODE']??'';
          var menuGroupName = dataList['DESCP']??'';
          return menuGroupName != ""? GestureDetector(
            onTap: (){
              fnUpdateTable(code,menuGroupName);
            },
            child:  Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              margin: EdgeInsets.only(right:10),
              decoration: boxBaseDecoration(lstrMenuGroup == code ? PrimaryColor :blueLight, 5),
              child: Center(
                child: tc(menuGroupName, lstrMenuGroup == code ? Colors.white : PrimaryText,15),
              ),
            ),
          ):Container();
        });
  }
  Widget itemView(snapshot){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio:  2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15),
        itemCount:  snapshot.data['Table1'].length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data['Table1'][index];
          var itemCode = dataList['DISHCODE'] ??'';
          var itemName = dataList['DISHDESCP']??'';
          var waitingTime = dataList['WAITINGTIME']??'';
          var itemPrice = dataList['PRICE1']??'0.0';

          var itemSts = '';
          var itemClearedQty = 0;
          var itemClearedQtyS = '';
          var orderData = fnCheckItem(itemCode);
          bool orderSts  = false;

          if(g.fnValCheck(orderData)){
            var qty = double.parse(orderData["QTY"].toString());
            itemSts = orderData["OLD_STATUS"].toString();
            itemClearedQty = int.parse(orderData["CLEARED_QTY"].toString());
            itemClearedQtyS = itemClearedQty == 0 ? '' :itemClearedQty.toString();
            if(qty > 0){
              orderSts = true;
            }

          }

          return GestureDetector(
            onTap: (){
              setState(() {
               if(lstrMenuSelection == "N"){
                 sidePageView = "O";
               }
              });
              fnItemPress(dataList,1,'ADD',itemSts,itemClearedQty);
            },
            onLongPress: (){

              //orderSts ==true ? fnShowNotePopup(dataList,orderData):'';
            },
            child: Container(
              height: 60,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(left: 15),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            gapHC(10),

                            menuNameS(itemName.toString()),
                            catS('AED  ' + itemPrice.toString()),

                            gapHC(5),
                            tc(orderSts ? 'x ' + orderData["QTY"].toString() : '',Colors.black,20),
                          ],
                        ),
                      ),
                    ),
                  )),
                  orderSts ?
                  Container(
                      child:  GestureDetector(
                        onTap: (){
                          setState(() {
                            if(lstrMenuSelection == "N"){
                              sidePageView = "O";
                            }
                          });
                          fnItemPress(dataList,1,'MINUS',itemSts,itemClearedQty);
                        },
                        onLongPress: (){
                          setState(() {
                            if(lstrMenuSelection == "N"){
                              sidePageView = "O";
                            }
                          });
                          fnRemoveItem(dataList,orderData);
                        },
                        child: Container(
                          width:50,
                          margin: EdgeInsets.all(10),
                          decoration: boxGradientDecoration(12, 15),
                          child: Center(
                            child: Icon(Icons.remove_circle_outline_outlined,color: Colors.white,size: 30,),
                          ),
                        ),
                      )
                  )
                      :Container()
                ],
              ),
              decoration: boxDecoration(Colors.white, 15),
            ),
          );
        });
  }
  Widget catView(snapshot){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio:  1.6,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemCount:  snapshot.data['Table2'].length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data['Table2'][index];
          var code = dataList['CODE']??'';
          var menuGroupName = dataList['DESCP']??'';

          return code != null? GestureDetector(
            onTap: (){
              fnUpdateTable(code,menuGroupName);
            },
            child: Container(
              margin: EdgeInsets.all(2),
              height: 60,
              width: 200,
              alignment: Alignment.center,
              child: Center(
                child:tc(menuGroupName.toString(), Colors.black, 15),
              ),
              decoration: boxDecoration(Colors.amber, 5),
            ),
          ):Container();
        });
  }
  Widget bookingView(snapshot){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250,
            childAspectRatio:  .65,
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

          return  GestureDetector(
            onTap: (){
              if(sts == "A"){
                setState(() {
                  sidePageView ="";
                  lstrSelectedBookingTables = [];
                  lstrSelectedBooking =[];
                  lstrSelectedBookingItems = [];
                  lstrSelectedBookingAllItems= [];
                  lstrSelectedBookingInvoice = [];
                  lstrSelectedBookingInvoices = [];
                  lstrSelectedBookingNo = bookingNo;
                  lstrSelectedBookingDocType = bookingDocType;
                  lstrSelectedBookingYearcode = bookingYearcode;
                  lstrSelectedBookingDate = formatDate2.format(DateTime.parse(bookingDate.toString()));
                  lstrSelectedBookingUser = createUser;
                });
                fnGetBookingDet(bookingNo);
              }

            },
            child: ClipPath(
              clipper: MovieTicketClipper(),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: boxDecoration(lstrSelectedBookingNo ==bookingNo? blueLight: Colors.white, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    tc('#' +bookingNo.toString(),Colors.red,15),
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
                    gapHC(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ts('ADVANCE PAYMENT', Colors.black, 10),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        tc(advAmount.toString(), Colors.red, 25),
                      ],
                    ),
                    gapHC(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 30,
                          width: 120,
                          decoration: boxBaseDecoration(sts == "D"? Colors.green: Colors.amber, 5),
                          child: Center(
                            child: tc( sts == "D" ?"PAYMENT DONE":'View', sts == "D"? Colors.white: Colors.black, 10),
                          ),
                        )
                      ],
                    )



                  ],
                ),
              ),
            ),
          );
        });
  }
  Widget bookingNoSelectionView(snapshot){
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data['Table1'].length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data['Table1'][index];
          var bookingNo = dataList['DOCNO']??'';
          var bookingDocType  = dataList['DOCTYPE']??'';
          var bookingYearCode  = dataList['YEARCODE']??'';
          var partyCode = dataList['PARTYCODE']??'';
          var partyName = dataList['PARTYNAME']??'';
          var advAmount = dataList['ADV_AMT']??'';
          var partyMobile = dataList['PARTY_MOBILE']??'';
          var bookingDate = dataList['BOOKING_DATE']??'';
          var bookingTimeFrom = dataList['BOOKING_TIME_FROM']??'';
          var bookingTimeTo = dataList['BOOKING_TIME_TO']??'';
          var eventCode = dataList['EVENT_CODE']??'';
          var eventName = dataList['EVENT_DESCP']??'';
          var createUser = dataList['CREATE_USER']??'';
          var noOfPersons = dataList['NO_PERSON']??'';

          return GestureDetector(
            onTap: (){
              setState(() {
                lstrSelectedBookingNo = bookingNo;
                lstrSelectedBookingDocType = bookingDocType;
                lstrSelectedBookingYearcode = bookingYearCode;
                sidePageView = "O";
              });
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
              decoration: boxBaseDecoration(blueLight, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  tc('#'+bookingNo.toString(),Colors.red,15),
                  gapHC(5),
                  line(),
                  gapHC(5),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,size: 10,),
                      gapWC(5),
                      ts(formatDate2.format(DateTime.parse(bookingDate.toString())), Colors.black, 12),
                      gapWC(5),
                      Row(
                        children: [
                          Icon(Icons.access_time_outlined,size: 10,),
                          gapWC(5),
                          ts(bookingTimeFrom.toString(), Colors.black, 12),
                          ts('  to  ', Colors.black, 12),
                          ts(bookingTimeTo.toString(), Colors.black, 12),
                        ],
                      ),
                    ],
                  ),

                  gapHC(5),
                  line(),
                  gapHC(5),
                  Row(
                    children: [
                      Icon(Icons.person,size: 12,),
                      gapWC(5),
                      tc(partyName.toString(),Colors.black,12)
                    ],
                  ),

                  gapHC(5),
                  Row(
                    children: [
                      Icon(Icons.phone,size: 12,),
                      gapWC(5),
                      tc(partyMobile.toString(),Colors.black,12)
                    ],
                  )
                ],
              ),
            )
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
                  Expanded(child: tc((index+1).toString() +'. '+itemName,Colors.black,15),),
                  Row(
                    children: [
                      tc(itemRate.toString() ,Colors.black,15),
                      gapW(),
                      tc('x'+itemQty.toString(),Colors.black,15),
                      gapW(),
                      gapW(),
                      tc(itemTotal.toString(),PrimaryColor,15),
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
  Widget bookingInvoiceView(snapshot){
    return ListView.builder(

        physics: AlwaysScrollableScrollPhysics(),
        itemCount: snapshot.data['Table4'].length,
        itemBuilder: (context, index) {
          var dataList = snapshot.data['Table4'][index];
          var invoiceNo = dataList['DOCNO']??'';
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
                 lstrSelectedRslItems = fnCheckInvoiceItem(invoiceNo);
                 lstrSelectedUser = createUser;
                 lstrSelectedDate = formatDate.format(DateTime.parse(createDate.toString()));
                 lstrTaxable = taxable??0.0;
                 lstrLastVat = tax??0.0;
                 lstrLastDiscount = addl??0.0;
                 lstrLastTotal = total??0.0;
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
  FutureBuilder<dynamic> futureMenuview() {
    return new FutureBuilder<dynamic>(
      future: futureMenu,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return lastLevel == 0? catView(snapshot) :
          itemView(snapshot);
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
  Widget rslView(snapshot){
    return ResponsiveWidget(
        mobile: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio:1.4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount:  snapshot.data.length,
            itemBuilder: (BuildContext ctx, index) {
              var dataList = snapshot.data[index];
              var rsl = dataList['RSL'];
              var rslDet = dataList['RSLDET'];
              var rslVoid = dataList['RSL_VOID'];
              var rslVoidDet = dataList['RSL_VOIDDET'];

              var rslDocNo = '';
              var lstrRslType = '' ;
              var lstrCreateUser ='' ;
              var lstrCreateDate  = '';
              var lstrNetAmount  = '';
              var lstrCustomerName = '' ;
              var lstrCustomerMob  = '';

              if(g.fnValCheck(rsl)){
                rslDocNo = rsl[0]["DOCNO"];
                lstrRslType = rsl[0]["DOCNO"];
                lstrCreateUser = rsl[0]["CREATE_USER"];
                lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
                lstrNetAmount = rsl[0]["NETAMT"].toString();
                lstrCustomerName = rsl[0]["DOCNO"];
                lstrCustomerMob = rsl[0]["DOCNO"];
              }

              var lstrTableNo = '';

              return rslCardView(dataList, rslDocNo, lstrRslType, lstrTableNo, lstrNetAmount, lstrCreateUser,lstrCreateDate);
            }),
        tab: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio:1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount:  snapshot.data.length,
            itemBuilder: (BuildContext ctx, index) {
              var dataList = snapshot.data[index];
              var rsl = dataList['RSL'];
              var rslDet = dataList['RSLDET'];
              var rslVoid = dataList['RSL_VOID'];
              var rslVoidDet = dataList['RSL_VOIDDET'];

              var rslDocNo = '';
              var lstrRslType = '' ;
              var lstrCreateUser ='' ;
              var lstrCreateDate  = '';
              var lstrNetAmount  = '';
              var lstrCustomerName = '' ;
              var lstrCustomerMob  = '';

              if(g.fnValCheck(rsl)){
                rslDocNo = rsl[0]["DOCNO"];
                lstrRslType = rsl[0]["DOCNO"];
                lstrCreateUser = rsl[0]["CREATE_USER"];
                lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
                lstrNetAmount = rsl[0]["NETAMT"].toString();
                lstrCustomerName = rsl[0]["DOCNO"];
                lstrCustomerMob = rsl[0]["DOCNO"];
              }

              var lstrTableNo = '';

              return  rslCardView(dataList,rslDocNo, lstrRslType, lstrTableNo, lstrNetAmount, lstrCreateUser,lstrCreateDate);
            }),
        windows: GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 350,
                childAspectRatio:1.4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20),
            itemCount:  snapshot.data.length,
            itemBuilder: (BuildContext ctx, index) {
              var dataList = snapshot.data[index];
              var rsl = dataList['RSL'];
              var rslDet = dataList['RSLDET'];
              var rslVoid = dataList['RSL_VOID'];
              var rslVoidDet = dataList['RSL_VOIDDET'];

              var rslDocNo = '';
              var lstrRslType = '' ;
              var lstrCreateUser ='' ;
              var lstrCreateDate  = '';
              var lstrNetAmount  = '';
              var lstrCustomerName = '' ;
              var lstrCustomerMob  = '';

              if(g.fnValCheck(rsl)){
                rslDocNo = rsl[0]["DOCNO"];
                lstrRslType = rsl[0]["DOCNO"];
                lstrCreateUser = rsl[0]["CREATE_USER"];
                lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
                lstrNetAmount = rsl[0]["NETAMT"].toString();
                lstrCustomerName = rsl[0]["DOCNO"];
                lstrCustomerMob = rsl[0]["DOCNO"];
              }

              var lstrTableNo = '';

              return rslCardView(dataList,rslDocNo, lstrRslType, lstrTableNo, lstrNetAmount, lstrCreateUser,lstrCreateDate);
            }));
  }
  Widget rslHoldView(){
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio:1.3,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  lstrHoldBill.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = lstrHoldBill[index];
          var guestCode = '';
          var guestName = '';
          var amt = 0.0;
          var mobile = '';
          var prvdocno = '';
          var prvdoctype = '';
          if(g.fnValCheck(dataList)){
            guestCode = dataList["GUESTCODE"];
            guestName = dataList["GUESTNAME"];
            amt = g.mfnDbl(dataList["NETAMTFC"]);
            mobile = dataList["REMARKS"].toString();
            prvdocno = dataList["PRVDOCNO"].toString();
            prvdoctype = dataList["PRVDOCTYPE"].toString();
          }

          var lstrTableNo = '';
          return  GestureDetector(
            onTap: (){
              setState(() {
                lstrSelectedBookingNo = prvdocno;
                lstrSelectedBookingDocType = prvdoctype;
              });
              fnGetHoldRslDet(prvdocno,prvdoctype);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: boxDecoration(  Colors.white, 5),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(Icons.person,size: 13,),
                      gapWC(5),
                      Expanded(child: tc(guestName.toString(),Colors.black,15),)
                    ],
                  ),
                  gapHC(5),
                  Row(
                    children: [
                      Icon(Icons.phone_android_rounded,size: 13,),
                      gapWC(5),
                      Expanded(child: tc(mobile.toString(),Colors.black,13),)
                    ],
                  ),
                  gapHC(5),
                  line(),
                  gapHC(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      tc(amt.toStringAsFixed(3),Colors.red,30)
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
  Widget rslStsView(snapshot){
    return  GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio:1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20),
        itemCount:  snapshot.data.length,
        itemBuilder: (BuildContext ctx, index) {
          var dataList = snapshot.data[index];
          var rsl = dataList['RSL'];
          var rslDet = dataList['RSLDET'];
          var rslVoid = dataList['RSL_VOID'];
          var rslVoidDet = dataList['RSL_VOIDDET'];

          var rslDocNo = '';
          var lstrRslType = '' ;
          var lstrRslDoctype = '' ;
          var lstrRslYearcode = '' ;
          var lstrCreateUser ='' ;
          var lstrCreateDate  = '';
          var lstrNetAmount  = '';
          var lstrCustomerName = '' ;
          var lstrCustomerMob  = '';

          if(g.fnValCheck(rsl)){
            rslDocNo = rsl[0]["DOCNO"];
            lstrRslType = rsl[0]["DOCNO"];
            lstrRslDoctype = rsl[0]["DOCTYPE"] ;
            lstrRslYearcode = rsl[0]["YEARCODE"] ;
            lstrCreateUser = rsl[0]["CREATE_USER"];
            lstrCreateDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"]));
            lstrNetAmount = rsl[0]["NETAMT"].toString();
            lstrCustomerName = rsl[0]["DOCNO"];
            lstrCustomerMob = rsl[0]["DOCNO"];
          }

          var lstrTableNo = '';

          return GestureDetector(
            onTap: (){
              fnRslClick(dataList,rslDocNo);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: boxDecoration(lstrSelectedDocno ==rslDocNo? blueLight : Colors.white, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      tc('Order ' +  rslDocNo,Colors.black,15),
                      tc(lstrRslType == 'T' ?'Table   ' + lstrTableNo : lstrRslType == 'A' ? 'Takeaway' : lstrRslType == 'D' ? 'Delivery' : '',PrimaryColor,15),

                    ],
                  ),
                  gapHC(5),
                  ts( 'AED '+ lstrNetAmount,PrimaryColor,14),
                  gapHC(5),
                  Row(
                    children: [
                      Icon(Icons.person_rounded,size: 13,),
                      gapWC(5),
                      ts(lstrCreateUser,Colors.black,12),
                    ],
                  ),
                  gapHC(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      GestureDetector(
                        onTap: (){
                          fnFinishRsl(rslDocNo,lstrRslDoctype,lstrRslYearcode);
                        },
                        child: Container(
                          width: 100,
                          height: 30,
                          decoration: boxBaseDecoration(Colors.green, 5),
                          child: Center(
                            child: tc('FINISH',Colors.white,15),
                          ),
                        ),
                      )

                    ],
                  )


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
                  Expanded(child: tc((index+1).toString() +'. '+itemName.toString(),returnSts == "Y"?Colors.white:Colors.black,15),),
                  Row(
                    children: [
                      tc(itemRate.toString() ,returnSts == "Y"?Colors.white: Colors.black,15),
                      gapW(),
                      tc('x'+itemQty.toString(),returnSts == "Y"?Colors.white:Colors.black,15),
                      gapW(),
                      gapW(),
                      tc(itemTotal.toString(),returnSts == "Y"?Colors.white:PrimaryColor,15),
                    ],
                  )
                ],
              ),
            ),
          );
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
          return Container(
            child: Container(
              child: Row(
                children: [
                  Transform.scale(scale: 1,
                    child: new Radio(
                      value: index,
                      groupValue: _radioValue,
                      onChanged: (value){
                        fnEventRadioClick(eventCode,eventDescp,index);

                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      fnEventRadioClick(eventCode,eventDescp,index);
                    },
                    child: tc(eventDescp,Colors.black,15),
                  )
                ],
              ),
            ),
          );
        });
  }
  GestureDetector rslCardView(dataList,String rslDocNo, String lstrRslType, String lstrTableNo, String lstrNetAmount, String lstrCreateUser,String lstrCreateDate) {
    return GestureDetector(
      onTap: (){
        fnRslClick(dataList,rslDocNo);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: boxDecoration(lstrSelectedDocno ==rslDocNo? blueLight : Colors.white, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                tc('Order ' +  rslDocNo,Colors.black,15),
                tc(lstrRslType == 'T' ?'Table   ' + lstrTableNo : lstrRslType == 'A' ? 'Takeaway' : lstrRslType == 'D' ? 'Delivery' : '',PrimaryColor,15),

              ],
            ),
            gapHC(5),
            ts( 'AED '+ lstrNetAmount,PrimaryColor,14),
            Row(
              children: [
                Icon(Icons.watch_later_outlined,size: 13,),
                gapWC(5),
                ts(lstrCreateDate.toString(),Colors.black,12),
              ],
            ),
            gapHC(5),
            Row(
              children: [
                Icon(Icons.person_rounded,size: 13,),
                gapWC(5),
                ts(lstrCreateUser,Colors.black,12),
              ],
            ),
            gapHC(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                GestureDetector(
                  onTap: (){
                    setState(() {
                      lstrPrintDocno =rslDocNo;
                    });
                    PageDialog().printDialog(context, fnPrintHistory);
                  },
                  child: Container(
                    width: 100,
                    height: 30,
                    decoration: boxBaseDecoration(Colors.amber, 5),
                    child: Center(
                      child: Icon(Icons.print,color: Colors.black,size: 20,),
                    ),
                  ),
                )

              ],
            )


          ],
        ),
      ),
    );
  }

  //===================OTHER FUNCTION===================

  fnRslClick(dataList,code){
    setState(() {
      lstrBalanceAmt = 0.00;
      lstrPaidAmt=0.00;
      lstrLastGross = 0.00;
      lstrLastVat = 0.00;
      lstrLastTotal = 0.00;
      lstrTaxable = 0.00;
      lstrLastDiscount = 0.00;
      lstrLastAddlAmount = 0.00;
      lastOrder= [];
    });


    fnClear();
    var rsl  = dataList['RSL'];
    var rslDet  = dataList['RSLDET'];
    var lstrCreateUser  =  rsl[0]["CREATE_USER"];

    setState(() {
      lstrSelectedDocno = code??'';
      lstrSelectedRsl = rsl;
      lstrSelectedRslItems = rslDet;
      lstrSelectedUser = lstrCreateUser??'';
      lstrSelectedDate = formatDate.format(DateTime.parse(rsl[0]["CREATE_DATE"].toString()))  ;
      lstrTaxable = rsl[0]["TAXABLE_AMTFC"]??0.0;
      lstrLastVat = rsl[0]["TAX_AMT"]??0.0;
      lstrLastDiscount = rsl[0]["DISC_AMT"]??0.0;
      lstrLastTotal = rsl[0]["NETAMT"]??0.0;
      lstrPaidAmt = rsl[0]["PAID_AMT"]??0.0;
      lstrLastAddlAmount = rsl[0]["ADDL_AMT"]??0.0;
      lstrBalanceAmt =  lstrLastTotal - lstrPaidAmt;
      lstrLastGross = rsl[0]["TAXABLE_AMTFC"]??0.0;
    });

  }
  fnAddNew(){
    fnClear();
    setState(() {
      lstrMenuSelection = "N";
      wstrPageMode = "ADD";
      lastOrder = [];
      lastOrderTable = [];
      lastOrderAddress = [];
      lstrSelectedInstructions = [];
      lstrLastInstructions = [];
      lstrSelectedBill = [];
      lstrPaymentList =[];
      lstrRetailPay = [];
      lstrAddlAmount = [];
      lstrSelectedBookingNo = "";
      lstrSelectedBookingDocType = "";
      finalBillYn = "N";

      lstrOrderQtyV = 0;
      lstrLastGross = 0.00;
      lstrLastVat = 0.00;
      lstrLastTotal = 0.00;
      lstrLastDiscount = 0.00;
      lstrLastAddlAmount = 0.00;
      lstrTaxable = 0.00;
      lstrPaidAmt = 0.00;
      lstrBalanceAmt = 0.00;


    });
    fnClearAll();
    fnGetMenu();

  }
  fnUpdateTime(){
    var now = DateTime.now();
   setState(() {

     lstrTime = formatTimeSecond.format(now) ;
   });
  }
  fnBackButton(){

    setState(() {
      switch (lastLevel) {
        case 0:
          break;
        case 1:
          fnClearAll();
          break;
        case 2:
          lstrGp1 = null;
          lstrSelectedCategoryList[1] = null;
          break;
        case 3:
          lstrGp2 = null;
          lstrSelectedCategoryList[2] = null;
          break;
        case 4:
          lstrGp3 = null;
          lstrSelectedCategoryList[3] = null;
          break;
        case 5:
          lstrGp4 = null;
          lstrSelectedCategoryList[4] = null;
          break;
        case 6:
          lstrGp5 = null;
          lstrSelectedCategoryList[5] = null;
          break;
        case 7:
          lstrGp6 = null;
          lstrSelectedCategoryList[6] = null;
          break;
        case 8:
          lstrGp7 = null;
          lstrSelectedCategoryList[7] = null;
          break;
        case 9:
          lstrGp8 = null;
          lstrSelectedCategoryList[8] = null;
          break;
        case 10:
          lstrGp9 = null;
          lstrSelectedCategoryList[9] = null;
          break;
        default:
          break;
      }
    });
    fnUpdateCategory();
    fnGetMenu();
  }
  fnBackLongPress(){
    fnClearAll();
    fnGetMenu();
  }
  fnClearAll(){
    lstrSelectedCategoryList.clear();
    lstrSelectedCategory = '';
    setState(() {
      lstrMenuCode = null ;
      lstrMenuGroup  = null ;
      lstrGp1  = null ;
      lstrGp2  = null ;
      lstrGp3  = null ;
      lstrGp4  = null ;
      lstrGp5  = null ;
      lstrGp6  = null ;
      lstrGp7  = null ;
      lstrGp8  = null ;
      lstrGp9  = null ;
      lstrGp10  = null ;
    });
    fnUpdateCategory();
  }
  fnUpdateCategory(){
    setState(() {
      lstrSelectedCategory = '';
    });
    var i = 0;
    if(g.fnValCheck(lstrSelectedCategoryList)){
      for(var e in lstrSelectedCategoryList){
        setState(() {
          if (e != null ){
            lstrSelectedCategory = i == 0? e.toString() : lstrSelectedCategory +  '  >  ' + e.toString();

          }
          i =i+1;
        });
      }
    }else{
      setState(() {
        lstrSelectedCategory = '';
      });
    }
  }
  fnUpdateTable(code,descp) {
    setState(() {
      lstrSelectedCategoryList.add(descp);
      switch (lastLevel) {
        case 0:
          lstrMenuGroup = code;
          break;
        case 1:
          lstrGp1 = code;
          break;
        case 2:
          lstrGp2 = code;
          break;
        case 3:
          lstrGp3 = code;
          break;
        case 4:
          lstrGp4 = code;
          break;
        case 5:
          lstrGp5 = code;
          break;
        case 6:
          lstrGp6 = code;
          break;
        case 7:
          lstrGp7 = code;
          break;
        case 8:
          lstrGp8 = code;
          break;
        case 9:
          lstrGp9 = code;
          break;
        case 10:
          lstrGp10 = code;
          break;
        default:

          break;
      }
      fnUpdateCategory();
      fnGetMenu();
    });
  }
  fnCheckItem(itemCode){
    var selectedData ;
    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( itemCode == lcode ){
          selectedData = e;
          break;
        }
      }
    }
    return selectedData;
  }
  fnCheckInvoiceItem(docno){
    var selectedData = [] ;
    if(g.fnValCheck(lstrSelectedBookingInvoice)){
      for (var e in lstrSelectedBookingInvoice) {
        var lcode = e["DOCNO"].toString();
        if( docno == lcode ){
          selectedData.add(e);
        }
      }
    }
    return selectedData;
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
          "NOTE":"",
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
  fnShowNotePopupSelected(dataList){

    var itemCode = dataList['DISHCODE'] ??'';
    var itemName = dataList['DISHDESCP']??'';
    var waitingTime = dataList['WAITINGTIME']??'';
    var itemPrice = dataList['PRICE']??'0.0';
    //fnGetDetails(itemCode);

    setState(() {

      lstrSelectedStkCode = itemCode??'';
      lstrSelectedStkDescp = itemName??'';
      lstrSelectedRate = itemPrice.toString();
      lstrKitchenNote = '';
      lstrSelectedQty=dataList['QTY'].toString();
      lstrSelectedNote=dataList['NOTE'].toString();
      txtNote.text = lstrSelectedNote;
      sidePageView = "D";
      txtQty.text = lstrSelectedQty;

    });
    // PageDialog().showNote(context, ItemDetails(
    //   fnCallBack: fnItemNoteCallBack,
    //   lstrDataList: lstrSelectedItem,
    //   qty: lstrSelectedQty,
    //   note: lstrSelectedNote.toString(),
    //
    // ), 'Item Details');
    // PageDialog().showNote(context, kitchenNoteColumn(), 'Item Details');
  }
  fnUpdateNoteText(note){
    setState(() {
      txtNote.text = txtNote.text +'  ' + note.toString();
    });
  }
  fnItemNoteCallBack(itemCode,note,qty){
    if(g.fnValCheck(lastOrder)){
      for (var e in lastOrder) {
        var lcode = e["DISHCODE"].toString();
        if( itemCode == lcode ){
          e["NOTE"]=note.toString();
          e["QTY"]=qty;
          break;
        }
      }
    }
    setState(() {
      if(lstrMenuSelection == "N"){
        sidePageView = "O";
      }
      if(lstrMenuSelection == "B"){
        sidePageView = "";
      }

    });
    print(lastOrder);
    fnOrderCalc();
  }
  fnPayPopup(){

    setState(() {
      lstrSelectedBill= [];
      lstrSelectedBill.add({
        "DOCNO":'NEW',
        "TYPE": lstrSelectedOrderType,
        "USER" :g.wstrUserCd,
        "NAME" : '',
        "CASH" : 0.00,
        "CARD" : 0.00,
        "TOTAL_AMT":lstrLastTotal,
        "PAID_AMT":0.00,
        "CHANGE_TO":0.00
      });
    });
    //fnSave();
    //Navigator.push(context, MaterialPageRoute(builder: (context) => Payment()));
    PageDialog().showL(context, Payment(
      lstrDataList: lstrSelectedBill,
      fnCallBack: fnPaymentCallBack,
      lstrPaymentList: lstrPaymentList,
    ), 'Payment Details');
  }
  fnPaymentCallBack(datalist,retailPay,paymentList){
    setState(() {
      lstrSelectedBill  = datalist;
      lstrRetailPay = retailPay;
      lstrPaymentList = paymentList;
    });
    fnPaidCalc();
    saveSts? fnSave():'';
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
  fnSearchDishCode(){
    if(txtSearchDishCode.text.isEmpty){
      setState(() {
        lstrSearch = null;
      });
    }else{
      setState(() {
        lstrSearch = txtSearchDishCode.text.toString();

      });
    }
    fnGetMenu();
  }
  fnClearSearch(){
    setState(() {
      txtSearchDishCode.clear();
      lstrSearch = null;
    });
    fnGetMenu();
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
      cmpDate = DateTime.parse(formatDateD.format(cmpDate));
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
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: timeFrom,
    );
    if (newTime != null) {
      setState(() {
        timeFrom = newTime;
      });
    }
  }
  Future<void> _selectTimeTo(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: timeTo,
    );
    if (newTime != null) {
      setState(() {
        timeTo = newTime;
      });
    }
  }
  fnEventRadioClick(code,name,index) async{
    setState(() {
      _radioValue = index;
      lstrSelectedEvent = code;
      lstrSelectedEventDescp = name;
    });
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
    setState(() {
      lastOrder = [];
      finalBillYn = "Y";
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
    fnOrderCalc();
  }


  fnOpeningCash(){
    PageDialog().showL(context, OpeningCash(
      fnCallBack: fnOpeningCashCallBack,
    ), 'Opening Cash');
  }
  fnOpeningCashCallBack(){

    }

  fnClockOut(){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => ShiftClosing()
    ));
  }
  fnAddlAmount(){
    PageDialog().showL(context, AddlAmount(
      lstrDataList: lstrSelectedBill,
      fnCallBack: fnAddlCallBack,
      lstrAddlList: lstrSelectedAddlList,
    ), 'Additional Amount');
  }
  fnAddlCallBack(addlList,amount,addlDataList){
    setState(() {
      lstrAddlAmount = addlList;
      lstrLastAddlAmount = amount;
      lstrSelectedAddlList =  addlDataList;
    });
    fnOrderCalc();
  }


  fnDiscount(){
    setState(() {
      lstrSelectedBill= [];
      lstrSelectedBill.add({
        "DOCNO":'NEW',
        "TYPE": lstrSelectedOrderType,
        "USER" :g.wstrUserCd,
        "NAME" : '',
        "CASH" : 0.00,
        "CARD" : 0.00,
        "TOTAL_AMT":lstrLastTotal+lstrLastDiscount,
        "PAID_AMT":0.00,
        "CHANGE_TO":0.00
      });
    });


    PageDialog().showL(context, Discount(
      fnCallBack: fnDiscountCallBack, oldValue: lstrLastDiscount, lstrDataList: lstrSelectedBill,
    ), 'Discount');
  }
  fnDiscountCallBack(amount){
    setState(() {
      lstrLastDiscount = amount;
    });
    fnOrderCalc();
  }


  fnReturnBill(){

    setState(() {
      lstrSelectedBill= [];
      lstrSelectedBill.add({
        "DOCNO":lstrSelectedDocno,
        "TYPE": lstrSelectedOrderType,
        "USER" :g.wstrUserCd,
        "NAME" : '',
        "DISCOUNT":lstrLastDiscount,
        "ADDL_AMT":lstrLastAddlAmount,
        "TAXABLE_AMT":lstrTaxable,
        "TOTAL_AMT":lstrLastTotal,
      });
    });

    PageDialog().showL(context, ReturnBill(
      lstrDataList: lstrSelectedBill,
      fnCallBack: fnReturnBillCallBack,
      lstrDataListDet: lstrSelectedRslItems,
      lstrRslHeader: lstrSelectedRsl,
    ), 'REOPEN BILL');
  }
  fnReturnBillCallBack(rsl,rsldet,retailpay){
    setState(() {
      saveSts = true;
    });
    fnSaveInvoiceReturn(rsl,rsldet,retailpay);
  }

  fnChoosePrinter(){
    PageDialog().showS(context, PrinterSelection(
    ), 'Choose Printer');
  }

  

  //===================Page Function  ================
  fnSave(){

    lstrRsl = [];
    lstrRslDet=[];
    lstrRslVoid = [];
    lstrRslVoidDet = [];
    lstrRslAddlCharge = [];
    var srno = 0;


    var prvDocno  = '';
    var prvDoctype = '';

    if(lstrPaidAmt < lstrLastTotal && lstrSelectedBookingNo.isEmpty && !creditCheck )
    {
      showToast( 'Please check your amount');
      return;
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
          lstrRslDet.add({
            "COMPANY":g.wstrCompany,
            "YEARCODE":g.wstrYearcode,
            "SRNO":srno,
            "DUEDATE":"",
            "STKCODE":e["DISHCODE"],
            "STKDESCP":e["DISHDESCP"],
            "STKBARCODE":"",
            "RETURNED_YN":"",
            "FOC_YN":"",
            "LOC":"",
            "UNIT1":e["UNIT1"],
            "QTY1":e["QTY"],
            "UNITCF":e["UNITCF"],
            "RATE":e["PRICE1"],
            "RATEFC":e["PRICE1"],
            "GRAMT":double.parse(amt.toStringAsFixed(5)) ,
            "GRAMTFC": double.parse(amt.toStringAsFixed(5)) ,
            "DISC_AMT":double.parse(headerDiscount.toStringAsFixed(5)),
            "DISC_AMTFC":double.parse(headerDiscount.toStringAsFixed(5)),
            "DISCPERCENT":e["DISCPERCENT"],
            "AMT": double.parse(amt.toStringAsFixed(5)),
            "AMTFC":double.parse(amt.toStringAsFixed(5)),
            "ADDL_AMT":headerAddlAmount,
            "ADDL_AMTFC":headerAddlAmount * g.wstrCurrencyRate,
            "AC_AMT":"",
            "AC_AMTFC":"",
            "PRVDOCTABLE":"",
            "PRVYEARCODE":lstrSelectedBookingYearcode,
            "PRVDOCNO":lstrSelectedBookingNo,
            "PRVDOCTYPE":lstrSelectedBookingDocType,
            "PRVDOCSRNO":0,
            "PRVDOCQTY":0,
            "PRVDOCPENDINGQTY":0,
            "PENDINGQTY":0,
            "CLEARED_QTY":0,
            "REF1":"",
            "REF2":"",
            "REF3":"",
            "EXPIRYDATE":"",
            "AVGCOST":"",
            "AVGCOSTFC":"",
            "LASTCOST":"",
            "LASTCOSTFC":"",
            "HEADER_DISC_AMT": double.parse(headerDiscount.toStringAsFixed(5)),
            "HEADER_DISC_AMTFC":double.parse(headerDiscount.toStringAsFixed(5)) * g.wstrCurrencyRate,
            "HEADER_GIFT_VOUCHER_AMT":"",
            "HEADER_GIFT_VOUCHER_AMTFC":"",
            "TOT_TAX_AMT": double.parse(vatA.toStringAsFixed(5))  ,
            "TOT_TAX_AMTFC": double.parse(vatA.toStringAsFixed(5)) * g.wstrCurrencyRate,
            "GIFT_VOUCHER_NO":"",
            "GIFT_VOUCHER_AMT":"",
            "GIFT_VOUCHER_AMTFC":"",
            "HEADER_DISC_TAX_AMTFC":"",
            "HEADER_DISC_TAX_AMT":"",
            "RATE_INCLUDE_TAX":e["TAXINCLUDE_YN"],
            "EX_VATAMTFC":"",
            "EX_VATAMT":"",
            "ADVANCE_AMTFC":"",
            "ADVANCE_AMT":"",
            "TAXABLE_AMT":  double.parse(taxableAmt.toStringAsFixed(3))  ,
            "TAXABLE_AMTFC":double.parse(taxableAmt.toStringAsFixed(3)) * g.wstrCurrencyRate,
            "ORDER_TYPE":lstrSelectedOrderType
          });
        }
      }

      setState(() {
        lstrLastTotal = double.parse(totalAmount.toStringAsFixed(3))  ;
        lstrLastGross = double.parse(grossAmount.toStringAsFixed(3)) ;
        lstrTaxable = double.parse(taxableAmount.toStringAsFixed(3)) ;
        lstrLastVat = double.parse(vatAmount.toStringAsFixed(3)) ;
        lstrLastTotal =  lstrLastAddlAmount  + lstrLastTotal;
      });


    }

    var discPerc =  0.0;
    if(g.mfnDbl(lstrLastDiscount) > 0){
      discPerc = (lstrLastDiscount/(lstrLastTotal+lstrLastDiscount))*100;
    }
    lstrRsl.add({
      "COMPANY":g.wstrCompany,
      "YEARCODE":g.wstrYearcode,
      "DUEDATE":null,
      "PARTYCODE":"",
      "PARTYNAME":"",
      "GUESTCODE":txtCustomerCode.text,
      "GUESTNAME":txtCustomerName.text,
      "PRVDOCNO":lstrSelectedBookingNo,
      "PRVDOCTYPE":lstrSelectedBookingDocType,
      "CASH_CREDIT":creditCheck?"CR":"",
      "CURR":g.wstrCurrency,
      "CURRATE":g.wstrCurrencyRate,
      "GRAMT":lstrLastGross,
      "GRAMTFC":lstrLastGross,
      "ADDL_AMT":lstrLastAddlAmount,
      "ADDL_AMTFC":lstrLastAddlAmount * g.wstrCurrencyRate,
      "PAID_MOD1":"",
      "PAID_AMT1":0,
      "PAID_AMT1FC":0,
      "PAID_MOD2":"",
      "PAID_AMT2":0,
      "PAID_AMT2FC":0,
      "DISC_PERCENT":discPerc,
      "DISC_AMT": double.parse(lstrLastDiscount.toStringAsFixed(5)) ,
      "DISC_AMTFC":double.parse(lstrLastDiscount.toStringAsFixed(5)) ,
      "CHG_CODE":"",
      "CHG_AMT":0,
      "CHG_AMTFC":0,
      "EXHDIFF_AMT":0,
      "NETAMT":lstrLastTotal,
      "NETAMTFC":lstrLastTotal * g.wstrCurrencyRate,
      "PAID_AMT":double.parse(lstrPaidAmt.toStringAsFixed(5))  ,
      "PAID_AMTFC":double.parse(lstrPaidAmt.toStringAsFixed(5)) * g.wstrCurrencyRate,
      "BAL_AMT":double.parse(lstrBalanceAmt.toStringAsFixed(5)),
      "BAL_AMTFC":double.parse(lstrBalanceAmt.toStringAsFixed(5)) * g.wstrCurrencyRate,
      "AC_AMTFC":0,
      "AC_AMT":0,
      "REMARKS":txtCustMobileNo.text,
      "REF1":"",
      "REF2":"",
      "REF3":"",
      "REF4":"",
      "REF5":"",
      "REF6":"",
      "EDIT_USER":g.wstrUserCd,
      "SHIFNO":g.wstrShifNo.toString(),
      "GUEST_TEL":"",
      "CARD_TYPE":"",
      "CARDHOLDER_NAME":"",
      "CARD_AC":"",
      "CARD_DETAILS":"",
      "NOOF_PRINT":"",
      "GIFT_VOUCHER_NO":"",
      "GIFT_VOUCHER_AMT":"",
      "GIFT_VOUCHER_AMTFC":"",
      "LOYALTY_CARD_NO":"",
      "VAT_PERC":"",
      "COUNTER_NO":g.wstrDeivceId,
      "MACHINENAME":g.wstrDeviceName,
      "DOCUMENT_STATUS":"",
      "TAX_AMT": double.parse(lstrLastVat.toStringAsFixed(5))  ,
      "TAX_AMTFC": double.parse(lstrLastVat.toStringAsFixed(5)) * g.wstrCurrencyRate  ,
      "TAXABLE_AMT": double.parse(lstrTaxable.toStringAsFixed(5)) ,
      "TAXABLE_AMTFC": double.parse(lstrTaxable.toStringAsFixed(5))  * g.wstrCurrencyRate,
    });

    if(lstrSelectedBookingNo.isEmpty || finalBillYn == "Y"){
      if(!creditCheck){
        fnSaveInvoice();
      }else{
        fnSaveInvoiceBooking();
      }
    }else{
      fnSaveInvoiceBooking();
    }


  }
  fnBookingSaveAlert(){

    if(lstrAdvAmount > 0){
      lstrRetailPay = [];
      fnBookingPayPopup();
    }else{
      PageDialog().saveDialog(context, fnBookingSave);
    }
  }
  fnBookingSave(){
    if(lstrAdvAmount <= 0){
      Navigator.pop(context);
    }
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


    if(txtBMobileNo.text.isEmpty){
      showToast( 'Please enter mobile no');
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
        var vatP = e["VAT"];

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
            "SRNO":srno,
            "STKCODE":e["DISHCODE"],
            "STKDESCP":e["DISHDESCP"],
            "UNIT1":e["UNIT1"],
            "QTY1":e["QTY"],
            "RATE":e["PRICE1"],
            "RATEFC":e["PRICE1"],
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
            "TAXABLE_AMT":  double.parse(taxableAmt.toStringAsFixed(3))  ,
            "TAXABLE_AMTFC":double.parse(taxableAmt.toStringAsFixed(3)) * g.wstrCurrencyRate,
            "ORDER_TYPE":lstrSelectedOrderType
          });
        }
      }

      setState(() {
        lstrLastTotal = double.parse(totalAmount.toStringAsFixed(3))  ;
        lstrLastGross = double.parse(grossAmount.toStringAsFixed(3)) ;
        lstrTaxable = double.parse(taxableAmount.toStringAsFixed(3)) ;
        lstrLastVat = double.parse(vatAmount.toStringAsFixed(3)) ;
        lstrLastTotal =  lstrLastAddlAmount  + lstrLastTotal;
      });


    }
    lstrRslBooking.add({
      "COMPANY":g.wstrCompany,
      "YEARCODE":g.wstrYearcode,
      "PARTYCODE":txtBPartyCode.text,
      "PARTYNAME":txtBPartyName.text,
      "GUESTCODE":txtBPartyCode.text,
      "GUESTNAME":txtBPartyName.text,
      "CURR":g.wstrCurrency,
      "CURRATE":g.wstrCurrencyRate,
      "GRAMT":lstrLastGross,
      "GRAMTFC":lstrLastGross,
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
      "NETAMT":lstrLastTotal,
      "NETAMTFC":lstrLastTotal * g.wstrCurrencyRate,
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
      "TAX_AMT": double.parse(lstrLastVat.toStringAsFixed(5))  ,
      "TAX_AMTFC": double.parse(lstrLastVat.toStringAsFixed(5)) * g.wstrCurrencyRate  ,
      "TAXABLE_AMT": double.parse(lstrTaxable.toStringAsFixed(5)) ,
      "TAXABLE_AMTFC": double.parse(lstrTaxable.toStringAsFixed(5))  * g.wstrCurrencyRate,
      "ADV_AMT" : lstrAdvAmount,
      "ADV_AMTFC" : lstrAdvAmount,
      "BOOKING_DATE" : formatDateDb.format(currentDate),
      "BOOKING_TIME_FROM" : timeFrom.format(context),
      "BOOKING_TIME_TO" : timeFrom.format(context),
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
      "ADD1" : txtBAddress.text,
      "TEL" : txtBTele.text,
      "MOBILE" :  txtBMobileNo.text.contains("+971") ?txtBMobileNo.text: lstrMobArea.toString() + txtBMobileNo.text ,
      "EMAIL" : txtBEmail.text,
      "CONTACT_NAME" : txtBPartyName.text,
      "CONTACT_MOBILE" : txtBMobile2.text,
      "DOB" : formatDateDb.format(dob),
      "CREATE_BY" : g.wstrUserCd,
    });
    srno  = 0;
    if(g.fnValCheck(g.wstrLastSelectedTables)){
       for(var e in g.wstrLastSelectedTables){
         srno = srno +1;
         lstrRslBookingTable.add({
           "COMPANY":g.wstrCompany.toString(),
           "YEARCODE":g.wstrYearcode.toString(),
           "SRNO":srno,
           "TABLE_CODE":e["TABLE_CODE"],
           "TABLE_DESCP":e["TABLE_DESCP"],
           "GUEST_NO":0,
         });
       }
    }

    if(lstrAdvAmount > 0){
      lstrRsl.add({
        "COMPANY":g.wstrCompany,
        "YEARCODE":g.wstrYearcode,
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

    fnSaveBookingApi("ADD");

  }
  fnClear(){
    setState(() {
      lstrRsl = [];
      lstrRslDet=[];
      lstrRslVoid = [];
      lstrRslVoidDet = [];
      lstrRslBooking = [];
      lstrRslBookingTable = [];
      lstrRslDetBooking = [];
      lastOrder = [];
      lstrSelectedAddlList = [];
      lstrSelectedRslItems = [];
      lstrPaymentList =[];
      lstrRetailPay = [];
      lstrAddlAmount = [];

      finalBillYn = "N";

      lstrSelectedBill =[];

      txtQty.clear();
      txtNote.clear();
      txtFullName.clear();
      txtLastName.clear();
      txtAddress1.clear();
      txtAddress2.clear();
      txtLandMark.clear();
      txtMob1.clear();
      txtMob2.clear();
      txtDeliveryNote.clear();
      txtKitchenNote.clear();
      txtAddNote.clear();
      txtVehicleNo.clear();
      txtSearchDishCode.clear();

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
      lstrSelectedBookingNo = '';
      lstrSelectedBookingDocType = '';
      lstrSelectedBookingYearcode = '';
      lstrSelectedBookingDate = '';
      lstrSelectedBookingUser = '';
      lstrSelectedBookingTables = [];
      lstrSelectedBookingItems = [];
      lstrSelectedBooking= [];

      creditCheck =  false;
      saveSts  = true;
      printRsl  = true;
      printRslHistory  = true;

      lstrBalanceAmt = 0.00;
      lstrPaidAmt=0.00;
      lstrLastGross = 0.00;
      lstrLastVat = 0.00;
      lstrLastTotal = 0.00;
      lstrTaxable = 0.00;
      lstrLastDiscount = 0.00;
      lstrLastAddlAmount = 0.00;
      lstrAdvAmount = 0.00;
      lstrFinalBillAmount = 0.00;
      lstrSelectedDocno = '';
      lstrSelectedDate= '';

    });
  }
  fnLookup(mode) {
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
        layoutName: "B",
        callback: fnLookupAreaCallBack,
      ), 'Area ');
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
  fnLookupAreaCallBack(data){
     if(g.fnValCheck(data)){
       setState(() {
         lstrAreaDescp = data["DESCP"];
       });
     }
  }


  //===================ApiCall ===============

  fnGetMenu() async{
    futureMenu =  apiCall.getMenuItem(g.wstrCompany, lstrMenuCode, lstrMenuGroup, lstrGp1, lstrGp2, lstrGp3, lstrGp4, lstrGp5, lstrGp6, lstrGp7, lstrGp8, lstrGp9, lstrGp10, lstrSearch,g.wstrUserCd,g.wstrDeliveryMode);
    futureMenu.then((value) => fnGetMenuSuccess(value));
  }
  fnGetMenuSuccess(value){
    if(g.fnValCheck(value)){
      if(g.fnValCheck(value['Table2'])){
        var dataList = value['Table2'][0];
        lastLevel = int.parse(dataList['LEVEL'].toString());
      }else{
        setState(() {
          lastLevel =lastLevel +1;
        });
      }
      if(g.fnValCheck(value['Table3'])){
        lstrSelectedInstructions = value['Table3'];
      }

    }else{

      showToast( '');
    }
  }

  fnSaveInvoice() {
    futureOrderSave =  apiCall.saveInvoice(lstrRsl,lstrRslDet,lstrRslVoid,lstrRslVoidDet,lstrRetailPay,wstrPageMode,lstrAddlAmount,finalBillYn == "N"?"":finalBillYn,g.wstrPrinterPath,"","","",[],"","","",[]);
    futureOrderSave.then((value) => fnSaveInvoiceSuccess(value));
  }
  fnSaveInvoiceSuccess(value){
    setState(() {
      saveSts = true;
    });
    if(g.fnValCheck(value)){
      var sts = value[0]['STATUS'].toString();
      var msg = value[0]['MSG'];
      if(sts == '1'){
        showToast( msg);
        var printmode  = "N";
        if(finalBillYn == "Y"){
          printmode = "Y";
        }
        fnAddNew();
        setState(() {
          lstrPrintDocno = value[0]['CODE'];
        });
        fnPrint(printmode);
        //PageDialog().printDialog(context, fnPrint);
      }
      showToast( msg);
    }

  }

  fnSaveInvoiceReturn(rsl,rsldet,retailpay) {

    if(saveSts){
      setState(() {
        saveSts = false;
      });
      futureOrderSave =  apiCall.saveInvoice(rsl,rsldet,[],[],retailpay,"EDIT",[],"",g.wstrPrinterPath,"","","VOID",[],"","","",[]);
      futureOrderSave.then((value) => fnSaveInvoiceReturnSuccess(value));

    }

  }
  fnSaveInvoiceReturnSuccess(value){
    setState(() {
      saveSts = true;
    });
    if(g.fnValCheck(value)){
      var sts = value[0]['STATUS'].toString();
      var msg = value[0]['MSG'];
      if(sts == '1'){
        showToast( msg);
        fnAddNew();
        setState(() {
          lstrPrintDocno = value[0]['CODE'];
        });
        fnPrint("N");
        //PageDialog().printDialog(context, fnPrint);
      }
      showToast( msg);
    }

  }

  fnSaveInvoiceBooking() async{
    futureOrderSave =  apiCall.saveInvoiceBooking(lstrRsl,lstrRslDet,wstrPageMode,lstrAddlAmount,g.wstrPrinterPath);
    futureOrderSave.then((value) => fnSaveInvoiceBookingSuccess(value));
  }
  fnSaveInvoiceBookingSuccess(value){
    setState(() {
      saveSts = true;
    });
    if(g.fnValCheck(value)){
      var sts = value[0]['STATUS'].toString();
      var msg = value[0]['MSG'];
      if(sts == '1'){

        showToast( msg);
        fnAddNew();
        setState(() {
          lstrPrintDocno = value[0]['CODE'];
        });
        fnPrint("N");
        //PageDialog().printDialog(context, fnPrint);
      }
      showToast( msg);
    }

  }

  fnPrint(printmode) async{

    if(printRsl){
      //Navigator.pop(context);
      setState(() {
        printRsl = false;
      });

      futurePrint =  apiCall.printInvoice(g.wstrCompany, g.wstrYearcode, lstrPrintDocno, "RSL", 1, g.wstrPrinterPath,"");
      futurePrint.then((value) => fnPrintSuccess(value,printmode));

    }

  }
  fnPrintSuccess(value,printmode){
    setState(() {
      printRsl = true;
    });
    if(printmode != "Y"){
      fnPrintKitchenSpot();
    }
  }

  fnPrintKitchenSpot() async{

    if(printRslSpot){
      //Navigator.pop(context);
      setState(() {
        printRslSpot = false;
      });
      futurePrint =  apiCall.printSpotInvoice(g.wstrCompany, g.wstrYearcode, lstrPrintDocno, "RSL", 1, "","");
      futurePrint.then((value) => fnPrintKitchenSuccess(value));

    }

  }
  fnPrintKitchenSuccess(value){

    setState(() {
      lstrPrintDocno = '';
      printRslSpot = true;
    });
  }

  fnPrintHistory() async{

    if(printRslHistory){
      Navigator.pop(context);
      setState(() {
        printRslHistory = false;
      });
      futurePrint =  apiCall.printInvoice(g.wstrCompany, g.wstrYearcode, lstrPrintDocno, "RSL", 1, g.wstrPrinterPath,"");
      futurePrint.then((value) => fnPrintHistorySuccess(value));

    }

  }
  fnPrintHistorySuccess(value){

    setState(() {
      printRslHistory = true;
    });
  }

  fnGetRsl(code,type,dateFrom,dateTo) async{
    futureRsl=  apiCall.getInvoice(g.wstrCompany,g.wstrYearcode,code,type,dateFrom,dateTo,g.wstrUserCd,'','','',"",1);
    futureRsl.then((value) => fnGetRslSuccess(value));
  }
  fnGetRslSuccess(value){
    if(g.fnValCheck(value)){

    }

  }

  fnGetHoldRsl() async{
    futureGetHoldRsl=  apiCall.getHoldInvoice(g.wstrCompany,'','');
    futureGetHoldRsl.then((value) => fnGetHoldRslSuccess(value));
  }
  fnGetHoldRslSuccess(value){
    print(value);
    if(g.fnValCheck(value)){
     setState(() {
       lstrHoldBill= value["HOLD_RSL"];
     });
    }
  }

  fnGetHoldRslDet(docno,doctype) async{
    setState(() {
      lstrHoldRsl = [];
      lstrHoldRslDet = [];
      lstrHoldAddl = [];
    });
    futureGetHoldRsl=  apiCall.getHoldInvoice(g.wstrCompany,docno,doctype);
    futureGetHoldRsl.then((value) => fnGetHoldRslDetSuccess(value));
  }
  fnGetHoldRslDetSuccess(value){
    print(value);
    if(g.fnValCheck(value)){
      setState(() {
        lstrHoldRsl = value["RSL"];
        lstrHoldRslDet = value["RSLDET"];
        lstrHoldAddl = value["ADDL_CHARGES"];
        lstrBookingMode = "N";
        lstrSelectedBookingInvNo = '';
        lstrSelectedRslItems = [];
        lstrSelectedRsl = [];
        lstrSelectedUser = '';
        lstrSelectedDate = '';
        lstrTaxable = 0.0;
        lstrLastVat = 0.0;
        lstrLastDiscount = 0.0;
        lstrLastTotal = 0.0;
        lstrAdvAmount = 0.0;
        sidePageView = "O";
        lstrSelectedBookingInvoice = lstrHoldRslDet;
        fnFinalBill();
      });
    }
  }

  fnGetRslSts(code,type,dateFrom,dateTo) async{
    futureRslSts=  apiCall.getInvoice(g.wstrCompany,g.wstrYearcode,code,type,dateFrom,dateTo,g.wstrUserCd,'Y','','',"",1);
    futureRslSts.then((value) => fnGetRslStsSuccess(value));
  }
  fnGetRslStsSuccess(value){
    setState(() {

    });
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

  fnGetCustomer(){
    futureGuest = apiCall.getGuest(txtCustMobileNo.text.toString());
    futureGuest.then((value) => fnGetCustomerSuccess(value));
  }
  fnGetCustomerSuccess(value){
    if(g.fnValCheck(value)){
      var dataList =  value[0];
      txtCustomerName.text = dataList["GUEST_NAME"].toString();
      txtCustomerCode.text = dataList["GUEST_CODE"].toString();
    }
  }

  fnGetBooking(docno,dateFrom,dateTo,mode){
    futureGetBooking =  apiCall.getBooking(g.wstrCompany, g.wstrYearcode, "RBK", docno, mode, dateFrom, dateTo,null,null,null,null,null);
    futureGetBooking.then((value) => fnGetBookingSuccess(value));
  }
  fnGetBookingSuccess(value){


  }

  fnGetBookingDet(docno){
    futureGetBookingDet =  apiCall.getBooking(g.wstrCompany, g.wstrYearcode, "RBK", docno, null, null, null,null,null,null,null,null);
    futureGetBookingDet.then((value) => fnGetBookingDetSuccess(value));
  }
  fnGetBookingDetSuccess(value){
      print(value);
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
          for(var e in lstrSelectedBookingInvoice){
            lstrSelectedBookingAllItems.add(e);
          }
        });


      }
  }

  fnSaveBookingApi(mode){
    futureBooking =  apiCall.saveBooking(lstrRslBooking, lstrRslDetBooking, lstrRslBookingTable, lstrRsl, lstrRslDet, lstrRetailPay, lstrRslAddlCharge, lstrBookingGuest, mode,g.wstrPrinterPath);
    futureBooking.then((value) => fnSaveBookingApiSuccess(value));
  }
  fnSaveBookingApiSuccess(value){
    setState(() {
      saveSts = true;
    });
    if(g.fnValCheck(value)){
      var sts = value[0]['STATUS'].toString();
      var msg = value[0]['MSG'];
      if(sts == '1'){
        showToast( msg);
        fnClear();
        setState(() {
          fnGetBooking(null,null,null,"T");
          fnGetBookingDet(null);
          lstrBookingMode = "S";
          lstrMenuSelection = "S";
          lstrScheduleSelection  =  'T';
        });
      }
      showToast( msg);
    }

  }

  fnFinishRsl(docno,doctype,yearcode){
    futureRslFinish = apiCall.rslFinishSts(docno, doctype, yearcode, g.wstrCompany);
    futureRslFinish.then((value) => fnFinishRslSuccess(value));
  }
  fnFinishRslSuccess(value){
    fnGetRslSts(null, null, null, null);
  }

  //=================Navigation=============

  fnCancelAddMode(){

  }

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
  fnSysytemInfo(){
    PageDialog().showSysytemInfo(context, Container(
      child: Column(

        children: [

          Row(
            children: [
              Icon(Icons.person_outline,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrUserName.toString(),Colors.black,20)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.access_time_outlined,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrShifDescp.toString(),Colors.black,20)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.laptop,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrDeviceName.toString(),Colors.black,20)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.confirmation_number_outlined,size: 20,color: Colors.black,),
              gapWC(10),
              tc(g.wstrDeivceId.toString(),Colors.black,20)
            ],
          ),
          gapHC(10),
          Row(
            children: [
              Icon(Icons.print,size: 20,color: Colors.black,),
              gapWC(10),
              Expanded(child: tc((g.wstrPrinterName + " | " +g.wstrPrinterPath).toString(),Colors.black,20))
            ],
          )
        ],
      ),
    ), 'System Info');
  }



}

