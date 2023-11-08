import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Pages/Login/userLogin.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:oktoast/oktoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftClosing extends StatefulWidget {
  const ShiftClosing({Key? key}) : super(key: key);

  @override
  _ShiftClosingState createState() => _ShiftClosingState();
}

class _ShiftClosingState extends State<ShiftClosing> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //api
  late Future<dynamic> futureGetClosing;
  late Future<dynamic> futureSaveClosing;
  late Future<dynamic> futurePrint;
  var lstrClosingData = [];

  //print
  var lstrSelectedDocno = '';
  var lstrSelectedDocType = '';
  var lstrSelectedYearcode = '';
  bool printSts = true;

  //CLOCKOUT
  late Future<dynamic> futureClockOut;
  bool clockoutStatus = true;

  ApiCall apiCall = ApiCall();
  Global g = Global();

  //Widget
  Widget closingWidget = Container() ;

  //summary
  var lstrGrossAmount = 0.00;
  var lstrRefundAmount = 0.00;
  var lstrDiscountAmount = 0.00;
  var lstrNetAmount = 0.00;
  var lstrAddlAmount = 0.00;
  var lstrCardAmount = 0.00;
  var lstrCashAmount = 0.00;
  var lstrVoidAmount = 0.00;
  var lstrCreditAmount = 0.00;

  //Counter Details
  var lstrOpenCash = 0.00;
  var lstrCashPayment = 0.00;
  var lstrCashRefund = 0.00;
  var lstrPaidIn = 0.00;
  var lstrPaidOut = 0.00;
  var lstrExpectedCash = 0.00;
  var lstrActualCash = 0.00;
  var lstrDiffrence = 0.00;

  var lstrSelectedEntry = '';
  var lstrSelectedEntryName = '';
  var lstrDenominationMode = '';
  var lstrEntryMode = 'C';
  var lstrCashEntry = '0.0';

  //Denominations
  var lstr1000c = 0;
  var lstr500c = 0;
  var lstr200c = 0;
  var lstr100c = 0;
  var lstr50c = 0;
  var lstr10c = 0;
  var lstr20c = 0;
  var lstr5c = 0;
  var lstr1c = 0;
  var lstr05c = 0;
  var lstr025c = 0;

  var lstr1000Amt = 0.00;
  var lstr500Amt = 0.00;
  var lstr200Amt = 0.00;
  var lstr100Amt = 0.00;
  var lstr50Amt = 0.00;
  var lstr10Amt = 0.00;
  var lstr20Amt = 0.00;
  var lstr5Amt = 0.00;
  var lstr1Amt = 0.00;
  var lstr05Amt = 0.00;
  var lstr025Amt = 0.00;

  var lstrDenomList = [];
  var lstrPayMode = [];

  var formatDate = new DateFormat('dd MMMM yyyy');
  var lstrShiftDate = '';

  //text
  var txtNote = new TextEditingController();

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
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.only(left:10),
          child: InkWell(
            onTap: (){
              fnPageBack();
            },
            child: Icon(Icons.arrow_back,color: Colors.black,size: 25,),
          ),
        ),
        title: tc(mfnLng('Counter Closing'),Colors.black,25),
        actions: [
          Container(
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.85,
                    width: size.width,
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Container(
                          decoration: boxDecoration(Colors.white, 10),
                          padding: EdgeInsets.all(10),
                          height: size.height * 0.85,
                          width: size.width * 0.3,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.sort),
                                    gapWC(10),
                                    tc(mfnLng('Counter Details'), Colors.black, 20)
                                  ],
                                ),

                                g.wstrHIDE_CLOSING_YN != "Y"?
                                Column(
                                  children: [
                                    amountHRow(mfnLng('Opening Cash'),
                                        lstrOpenCash.toStringAsFixed(2), 'P'),
                                    gapHC(2),

                                    amountHRow(mfnLng('Cash Payment'),
                                        lstrCashPayment.toStringAsFixed(2), 'B'),
                                    gapHC(2),
                                    amountHRow(mfnLng('Cash Refunds'),
                                        lstrCashRefund.toStringAsFixed(2), 'B'),
                                    gapHC(2),
                                  ],
                                ):gapHC(0),



                                amountRow(mfnLng('Paid In'),
                                    lstrPaidIn.toStringAsFixed(2), 'B', 'PI'),
                                gapHC(2),
                                amountRow(mfnLng('Paid Out'),
                                    lstrPaidOut.toStringAsFixed(2), 'B', 'PO'),
                                gapHC(2),
                                line(),
                                gapHC(5),
                                g.wstrHIDE_CLOSING_YN != "Y"?
                                amountHRow(mfnLng('Expected Cash'),
                                    lstrExpectedCash.toStringAsFixed(2), 'P'):gapHC(0),
                                gapHC(2),
                                amountRow(
                                    mfnLng('Actual Cash'),
                                    lstrActualCash.toStringAsFixed(2),
                                    'B',
                                    'AC'),
                                gapHC(2),
                                g.wstrHIDE_CLOSING_YN != "Y"?
                                amountHRow(mfnLng('Difference'),
                                    lstrDiffrence.toStringAsFixed(2), 'N'):gapHC(0),
                                line(),
                                gapHC(5),
                                g.wstrHIDE_CLOSING_YN != "Y"?
                                amountHRow(mfnLng('Gross Amount'),
                                    lstrGrossAmount.toStringAsFixed(2), 'B'):gapHC(0),
                                amountHRow(mfnLng('Refunds'),
                                    lstrRefundAmount.toStringAsFixed(2), 'B'),
                                amountHRow(mfnLng('Discounts'),
                                    lstrDiscountAmount.toStringAsFixed(2), 'B'),
                                amountHRow(mfnLng('Void Amount'),
                                    lstrVoidAmount.toStringAsFixed(2), 'B'),
                                amountHRow(mfnLng('Addl. Amount'),
                                    lstrAddlAmount.toStringAsFixed(2), 'B'),
                                g.wstrHIDE_CLOSING_YN != "Y"?
                                amountHRow(mfnLng('Net Sales'),
                                    lstrNetAmount.toStringAsFixed(2), 'B'):gapHC(0),
                                g.wstrHIDE_CLOSING_YN != "Y"?
                                amountHRow(mfnLng('Cash'),
                                    lstrCashAmount.toStringAsFixed(2), 'B'):gapHC(0),
                                amountHRow(mfnLng('Card'),
                                    lstrCardAmount.toStringAsFixed(2), 'B'),

                                line(),
                                Container(
                                  width: size.width,
                                  height: size.height * 0.3,
                                  margin: const EdgeInsets.only(top: 10.0),
                                  // color: Colors.blueGrey,
                                  child: ListView.builder(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: lstrPayMode.length,
                                      itemBuilder: (context, index) {
                                        var dataList = lstrPayMode[index];
                                        var paymentMode = dataList["PAYMODE"] ?? '';
                                        var paymentAmt = dataList["Column1"] ?? 0.0;

                                        return GestureDetector(
                                          onTap: () {},
                                          //h1(userName.toString())
                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 5),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                ts(paymentMode, Colors.black, 15) ,
                                                gapHC(20),
                                                tc(paymentAmt.toString(), Colors.black, 15)
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: Container(
                          height: size.height * 0.85,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: boxBaseDecoration(greyLight, 10),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: size.width * 0.1,
                                      child: tc(mfnLng('Note'), PrimaryColor, 20),
                                    ),
                                    Container(
                                      width: size.width * 0.1,
                                      child: tc(mfnLng('Count'), PrimaryColor, 20),
                                    ),
                                    Container(
                                      width: size.width * 0.1,
                                      child: tc(mfnLng('Amount'), PrimaryColor, 20),
                                    )
                                  ],
                                ),
                                gapHC(10),
                                DenominationRow('1000', lstr1000c.toString(),
                                    lstr1000Amt.toString(), 'B', size, '1000'),
                                gapHC(8),
                                DenominationRow('500', lstr500c.toString(),
                                    lstr500Amt.toString(), 'B', size, '500'),
                                gapHC(8),
                                DenominationRow('200', lstr200c.toString(),
                                    lstr200Amt.toString(), 'B', size, '200'),
                                gapHC(8),
                                DenominationRow('100', lstr100c.toString(),
                                    lstr100Amt.toString(), 'B', size, '100'),
                                gapHC(8),
                                DenominationRow('50', lstr50c.toString(),
                                    lstr50Amt.toString(), 'B', size, '50'),
                                gapHC(8),
                                DenominationRow('20', lstr20c.toString(),
                                    lstr20Amt.toString(), 'B', size, '20'),
                                gapHC(8),
                                DenominationRow('10', lstr10c.toString(),
                                    lstr10Amt.toString(), 'B', size, '10'),
                                gapHC(8),
                                DenominationRow('5', lstr5c.toString(),
                                    lstr5Amt.toString(), 'B', size, '5'),
                                gapHC(8),
                                DenominationRow('1', lstr1c.toString(),
                                    lstr1Amt.toString(), 'B', size, '1'),
                                gapHC(8),
                                DenominationRow('0.5', lstr05c.toString(),
                                    lstr05Amt.toString(), 'B', size, '05'),
                                gapHC(8),
                                DenominationRow('0.25', lstr025c.toString(),
                                    lstr025Amt.toString(), 'B', size, '025')
                              ],
                            ),
                          ),
                        ),),
                        Container(
                          width: size.width * 0.3,
                          height: size.height * 0.95,
                          padding: EdgeInsets.only(right: 10),
                          child: Container(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      tc(mfnLng("SHIFT NO"), Colors.black, 15),
                                      gapWC(10),
                                      tc(
                                          g.wstrShifDescp
                                              .toString()
                                              .toUpperCase()+'  |  '+lstrShiftDate.toString(),
                                          PrimaryColor,
                                          15),
                                    ],
                                  ),
                                  gapHC(10),
                                  ts(lstrSelectedEntryName, Colors.black, 15),
                                  gapHC(5),
                                  GestureDetector(
                                    onTap: () {
                                      //fnDone();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: size.width * 0.3,
                                      decoration:
                                      boxBaseDecoration(greyLight, 10),
                                      child: Center(
                                        child: tc(lstrCashEntry,
                                            PrimaryColor, 20),
                                      ),
                                    ),
                                  ),
                                  gapHC(20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      numberPress('1',size),
                                      numberPress('2',size),
                                      numberPress('3',size),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      numberPress('4',size),
                                      numberPress('5',size),
                                      numberPress('6',size),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      numberPress('7',size),
                                      numberPress('8',size),
                                      numberPress('9',size),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      numberPress('.',size),
                                      numberPress('0',size),
                                      numberPress('x',size),
                                    ],
                                  ),
                                  gapHC(20),
                                  s3('Note'),
                                  gapHC(10),
                                  Container(
                                    height: 100,
                                    padding: EdgeInsets.all(10),
                                    decoration:
                                        boxBaseDecoration(greyLight, 10),
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
                                  gapHC(20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: size.width * 0.14,
                                          decoration:
                                              boxDecoration(PrimaryColor, 30),
                                          child: Center(
                                            child:
                                                tc(mfnLng('CLOSE'), Colors.white, 15),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          fnSaveClosingData();
                                        },
                                        child: Container(
                                          height: 40,
                                          width: size.width * 0.14,
                                          decoration:
                                              boxDecoration(Colors.green, 30),
                                          child: Center(
                                            child: tc(mfnLng('DONE'), Colors.white, 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector numberPress(text,size) => GestureDetector(

        onLongPress: () {
          fnOnLongPress(text);
        },
        child: Bounce(
          child: Container(
            height: 60,
            width: size.width*0.09,
            margin: EdgeInsets.only(bottom: 5),
            decoration: boxDecoration(Colors.white, 10),
            child: Center(
              child: tc(text, titleSubText, 30),
            ),
          ),
          duration: Duration(milliseconds: 110),
          onPressed: () {
            fnOnPress(text);
          },
        ),
      );

  GestureDetector amountRow(title, amount, mode, code) {
    return GestureDetector(
      onTap: () {
        code == 'N' ? '' : fnChooseEntry(code, amount, title);
      },
      child: Container(
        height: 30,
        decoration: boxBaseDecoration(
            lstrSelectedEntry == code ? redLight : blueLight, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ts(title, Colors.black, 15),
            gapWC(10),
            tc(
                amount,
                mode == 'P'
                    ? Colors.green
                    : mode == 'N'
                        ? Colors.red
                        : Colors.black,
                15),
          ],
        ),
      ),
    );
  }

  Container amountHRow(title, amount, mode) {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ts(title, Colors.black, 15),
          gapWC(10),
          tc(
              amount,
              mode == 'P'
                  ? Colors.green
                  : mode == 'N'
                      ? Colors.red
                      : Colors.black,
              15),
        ],
      ),
    );
  }

  Container DenominationRow(title, count, amount, mode, size, code) {
    return Container(
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width * 0.1,
            child: ts(title, Colors.black, 15),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                lstrDenominationMode = 'C';
              });
              fnChooseEntry(code, count, title);
            },
            child: Container(
              decoration: boxBaseDecoration(
                  lstrDenominationMode == 'C'
                      ? lstrSelectedEntry == code
                          ? redLight
                          : Colors.white
                      : Colors.white,
                  5),
              width: size.width * 0.1,
              child: Center(
                child: tc(count, Colors.black, 15),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // setState(() {
              //   lstrDenominationMode = 'A';
              // });
              // fnChooseEntry(code,amount,title);
            },
            child: Container(
              decoration: boxBaseDecoration(
                  lstrDenominationMode == 'A'
                      ? lstrSelectedEntry == code
                          ? redLight
                          : Colors.white
                      : Colors.white,
                  5),
              width: size.width * 0.1,
              child: Center(
                child: tc(amount, Colors.black, 15),
              ),
            ),
          )
        ],
      ),
    );
  }

  //page
  fnGetPageData() {
    fnGetClosingData();

    setState(() {
      lstrShiftDate =  formatDate.format(DateTime.parse(g.wstrClockInDate.toString()));
      lstrDenomList.add({"CODE": "1000", "CCOUNT": 0, "CAMT": 0.00});
      lstrDenomList.add({"CODE": "500", "CCOUNT": 0, "CAMT": 0.00});
      lstrDenomList.add({"CODE": "100", "CCOUNT": 0, "CAMT": 0.00});
      lstrDenomList.add({"CODE": "200", "CCOUNT": 0, "CAMT": 0.00});
      lstrDenomList.add({"CODE": "50", "CCOUNT": 0, "CAMT": 0.00});
      lstrDenomList.add({"CODE": "20", "CCOUNT": 0, "CAMT": 0.00});
      lstrDenomList.add({"CODE": "10", "CCOUNT": 0, "CAMT": 0.00});
      lstrDenomList.add({"CODE": "5", "CCOUNT": 0, "CAMT": 0.00});
      lstrDenomList.add({"CODE": "1", "CCOUNT": 0, "CAMT": 0.00});
      lstrDenomList.add({"CODE": "05", "CCOUNT": 0, "CAMT": 0.00});
      lstrDenomList.add({"CODE": "025", "CCOUNT": 0, "CAMT": 0.00});
    });
  }

  //other
  fnOnPress(mode) {
    if (mode == 'x') {
      setState(() {
        lstrCashEntry = lstrCashEntry == '0.0' ? '' : lstrCashEntry;
        lstrCashEntry = lstrCashEntry == ''
            ? ''
            : lstrCashEntry.substring(0, lstrCashEntry.length - 1);
        lstrCashEntry = lstrCashEntry.isEmpty
            ? '0.0'
            : lstrCashEntry;
      });
    } else if (mode == '.') {
      if (lstrEntryMode == 'C') {
        if (!lstrCashEntry.contains('.', 0)) {
          setState(() {
            lstrCashEntry = lstrCashEntry == '0.0' ? '' : lstrCashEntry;
            lstrCashEntry = lstrCashEntry.toString() + mode.toString();
          });
        }
      }
    } else {
      if (lstrEntryMode == 'C') {
        setState(() {
          if (lstrCashEntry.length < 12) {
            lstrCashEntry = lstrCashEntry == '0.0' ? '' : lstrCashEntry;
            lstrCashEntry = lstrCashEntry.toString() + mode.toString();
          }
        });
      }
    }
    fnUpdateValue();
  }

  fnOnLongPress(mode) {
    if (mode == 'x') {
      setState(() {
        lstrCashEntry = '0.0';
      });
    }
    fnUpdateValue();
  }

  fnChooseEntry(mode, value, name) {
    setState(() {
      lstrSelectedEntry = mode;
      lstrCashEntry = value.toString();
      lstrSelectedEntryName = name.toString();
    });
  }

  fnUpdateValue() {
    var value = double.parse(lstrCashEntry.toString());
    switch (lstrSelectedEntry) {
      case 'PO':
        setState(() {
          lstrPaidOut = value;
        });
        break;
      case 'PI':
        setState(() {
          lstrPaidIn = value;
        });
        break;
      case 'AC':
        setState(() {
          lstrActualCash = value;
        });
        break;
      case '1000':
        setState(() {
          if (lstrDenominationMode == 'C') {
            lstr1000c = value.toInt();
            lstr1000Amt = lstr1000c * 1000;
          } else if (lstrDenominationMode == 'A') {
            lstr1000Amt = value;
          }
        });
        break;
      case '500':
        setState(() {
          if (lstrDenominationMode == 'C') {
            lstr500c = value.toInt();
            lstr500Amt = lstr500c * 500;
          } else if (lstrDenominationMode == 'A') {
            lstr500Amt = value;
          }
        });
        break;
      case '200':
        setState(() {
          if (lstrDenominationMode == 'C') {
            lstr200c = value.toInt();
            lstr200Amt = lstr200c * 200;
          } else if (lstrDenominationMode == 'A') {
            lstr200Amt = value;
          }
        });
        break;
      case '100':
        setState(() {
          if (lstrDenominationMode == 'C') {
            lstr100c = value.toInt();
            lstr100Amt = lstr100c * 100;
          } else if (lstrDenominationMode == 'A') {
            lstr100Amt = value;
          }
        });
        break;
      case '50':
        setState(() {
          if (lstrDenominationMode == 'C') {
            lstr50c = value.toInt();
            lstr50Amt = lstr50c * 50;
          } else if (lstrDenominationMode == 'A') {
            lstr50Amt = value;
          }
        });
        break;
      case '20':
        setState(() {
          if (lstrDenominationMode == 'C') {
            lstr20c = value.toInt();
            lstr20Amt = lstr20c * 20;
          } else if (lstrDenominationMode == 'A') {
            lstr20Amt = value;
          }
        });
        break;
      case '10':
        setState(() {
          if (lstrDenominationMode == 'C') {
            lstr10c = value.toInt();
            lstr10Amt = lstr10c * 10;
          } else if (lstrDenominationMode == 'A') {
            lstr10Amt = value;
          }
        });
        break;
      case '5':
        setState(() {
          if (lstrDenominationMode == 'C') {
            lstr5c = value.toInt();
            lstr5Amt = lstr5c * 5;
          } else if (lstrDenominationMode == 'A') {
            lstr5Amt = value;
          }
        });
        break;
      case '1':
        setState(() {
          if (lstrDenominationMode == 'C') {
            lstr1c = value.toInt();
            lstr1Amt = lstr1c * 1;
          } else if (lstrDenominationMode == 'A') {
            lstr1Amt = value;
          }
        });
        break;
      case '05':
        setState(() {
          if (lstrDenominationMode == 'C') {
            lstr05c = value.toInt();
            lstr05Amt = lstr05c * 0.5;
          } else if (lstrDenominationMode == 'A') {
            lstr05Amt = value;
          }
        });
        break;
      case '025':
        setState(() {
          if (lstrDenominationMode == 'C') {
            lstr025c = value.toInt();
            lstr025Amt = lstr025c * 0.25;
          } else if (lstrDenominationMode == 'A') {
            lstr025Amt = value;
          }
        });
        break;
      default:
        break;
    }

    fnCalc();
  }

  fnCalc() {
    setState(() {
      lstrExpectedCash = (lstrOpenCash + lstrCashPayment + lstrPaidIn) -
          (lstrCashRefund + lstrPaidOut);
      if (lstrSelectedEntry != "AC") {
        lstrActualCash = lstr1000Amt +
            lstr500Amt +
            lstr200Amt +
            lstr100Amt +
            lstr50Amt +
            lstr10Amt +
            lstr20Amt +
            lstr5Amt +
            lstr1Amt +
            lstr05Amt +
            lstr025Amt;
      }

      lstrDiffrence = lstrExpectedCash - lstrActualCash;
    });
  }

  //api
  fnGetClosingData() {
    fnClear();
    futureGetClosing = apiCall.getClosingData(
        g.wstrCompany, g.wstrYearcode, g.wstrDeivceId, g.wstrUserCd);
    futureGetClosing.then((value) => fnGetClosingSuccess(value));
  }

  fnGetClosingSuccess(value) {
    if (g.fnValCheck(value)) {
      print(value);
      var dataList = value['Table1'][0];

      setState(() {
        lstrOpenCash = g.mfnDbl(dataList["STARTING_AMT"]);
        lstrGrossAmount = g.mfnDbl(dataList["GROSS_AMT"]);
        lstrRefundAmount = g.mfnDbl(dataList["REFUND_AMT"]);
        lstrDiscountAmount = g.mfnDbl( dataList["DISCOUNT_AMT"]);
        lstrNetAmount = g.mfnDbl(dataList["NET_AMT"]);
        lstrAddlAmount = g.mfnDbl(dataList["ADDL_AMT"]);
        lstrCardAmount = g.mfnDbl(dataList["CARD_AMT"]);
        lstrCashAmount = g.mfnDbl(dataList["CASHT_AMT"]);
        lstrCashPayment = g.mfnDbl(dataList["CASHT_AMT"]);
        lstrVoidAmount = g.mfnDbl(dataList["VOID_AMT"]);
        lstrCreditAmount = g.mfnDbl(dataList["CREDIT_AMT"]??0);
      });

      var dataList2 = value['Table2'];
      print(dataList2);

      for (var e in dataList2) {
        lstrPayMode = dataList2;
      }
      var list = g.mfnJson(value);

      fnCalc();
    }
  }

  fnSaveClosingData() {
    if (lstrExpectedCash == 0 && lstrCardAmount == 0 && lstrNetAmount == 0 && lstrVoidAmount == 0 && lstrDiscountAmount == 0) {
      showToast( mfnLng('Cash amount is zero'));
      return;
    }
    if (lstrDiffrence != 0 && txtNote.text.isEmpty) {
      showToast( mfnLng('Please enter closing note!'));
      return;
    }

    lstrClosingData.clear();
    lstrClosingData.add({
      "COMPANY": g.wstrCompany,
      "YEARCODE": g.wstrYearcode,
      "USER_CD": g.wstrUserCd,
      "OPEN_CASH": lstrOpenCash,
      "CASH_PAYMENT": lstrCashPayment,
      "CASH_REFUND": lstrCashRefund,
      "PAID_IN": lstrPaidIn,
      "PAID_OUT": lstrPaidOut,
      "EXPECTED_CASH": lstrExpectedCash,
      "D1000_COUNT": lstr1000c,
      "D1000_AMT": lstr1000Amt,
      "D500_COUNT": lstr500c,
      "D500_AMT": lstr500Amt,
      "D200_COUNT": lstr200c,
      "D200_AMT": lstr200Amt,
      "D100_COUNT": lstr100c,
      "D100_AMT": lstr500Amt,
      "D50_COUNT": lstr50c,
      "D50_AMT": lstr50Amt,
      "D20_COUNT": lstr20c,
      "D20_AMT": lstr20Amt,
      "D10_COUNT": lstr10c,
      "D10_AMT": lstr10Amt,
      "D5_COUNT": lstr5c,
      "D5_AMT": lstr5Amt,
      "D1_COUNT": lstr1c,
      "D1_AMT": lstr1Amt,
      "D05_COUNT": lstr05c,
      "D05_AMT": lstr05Amt,
      "D025_COUNT": lstr025c,
      "D025_AMT": lstr025Amt,
      "ACTUAL_AMT": lstrActualCash,
      "DIFF_AMT": lstrDiffrence,
      "TOT_GROSS_SALE": lstrGrossAmount,
      "TOT_REFUND": lstrRefundAmount,
      "TOT_DISCOUNT": lstrDiscountAmount,
      "TOT_NET_SALE": lstrNetAmount,
      "TOT_CASH": lstrCashAmount,
      "TOT_CARD": lstrCardAmount,
      "MACHINEID": g.wstrDeivceId,
      "MACHINENAME": g.wstrDeviceName,
      "CREATED_USER": g.wstrUserCd,
      "REMARKS": txtNote.text,
      "ADDL_AMT": lstrAddlAmount,
      "VOID_AMT": lstrVoidAmount,
      "CREDIT_AMT": lstrCreditAmount,
      "MODE": "ADD"
    });
    fnSave(lstrCashAmount,lstrDiffrence);
  }

  fnSave(cash,diff) {
    futureSaveClosing = apiCall.saveClosing(lstrClosingData);
    futureSaveClosing.then((value) => fnSaveSuccess(value,cash,diff));
  }

  fnClear(){
    if(mounted){
      setState(() {
        lstrGrossAmount = 0.00;
        lstrRefundAmount = 0.00;
        lstrDiscountAmount = 0.00;
        lstrNetAmount = 0.00;
        lstrAddlAmount = 0.00;
        lstrCardAmount = 0.00;
        lstrCashAmount = 0.00;
        lstrVoidAmount = 0.00;
        lstrCreditAmount = 0.00;

        lstrOpenCash = 0.00;
        lstrCashPayment = 0.00;
        lstrCashRefund = 0.00;
        lstrPaidIn = 0.00;
        lstrPaidOut = 0.00;
        lstrExpectedCash = 0.00;
        lstrActualCash = 0.00;
        lstrDiffrence = 0.00;
        lstrSelectedEntry = '';
        lstrSelectedEntryName = '';
        lstrDenominationMode = '';
        lstrEntryMode = 'C';
        lstrCashEntry = '0.0';

        lstr1000c = 0;
        lstr500c = 0;
        lstr200c = 0;
        lstr100c = 0;
        lstr50c = 0;
        lstr10c = 0;
        lstr20c = 0;
        lstr5c = 0;
        lstr1c = 0;
        lstr05c = 0;
        lstr025c = 0;
        lstr1000Amt = 0.00;
        lstr500Amt = 0.00;
        lstr200Amt = 0.00;
        lstr100Amt = 0.00;
        lstr50Amt = 0.00;
        lstr10Amt = 0.00;
        lstr20Amt = 0.00;
        lstr5Amt = 0.00;
        lstr1Amt = 0.00;
        lstr05Amt = 0.00;
        lstr025Amt = 0.00;
        lstrDenomList = [];
        lstrPayMode = [];
        txtNote.clear();
      });
    }
  }

  fnBuildWidget(){

    PageDialog().showClosing(context, Container(
      decoration: boxDecoration(Colors.white, 10),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
         Expanded(child: Column(
           children: [
             Flexible(
               flex: 7,
               child: SingleChildScrollView(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Row(
                       children: [
                         Icon(Icons.sort),
                         gapWC(10),
                         tc(mfnLng('Counter Details'), Colors.black, 20)
                       ],
                     ),

                     amountHRow(mfnLng('Opening Cash'),
                         lstrOpenCash.toStringAsFixed(2), 'P'),
                     gapHC(2),

                     amountHRow(mfnLng('Cash Payment'),
                         lstrCashPayment.toStringAsFixed(2), 'B'),
                     gapHC(2),
                     amountHRow(mfnLng('Cash Refunds'),
                         lstrRefundAmount.toStringAsFixed(2), 'B'),
                     gapHC(2),
                     amountHRow(mfnLng('Paid In'),
                         lstrPaidIn.toStringAsFixed(2), 'B'),
                     gapHC(2),
                     amountHRow(mfnLng('Paid Out'),
                       lstrPaidOut.toStringAsFixed(2), 'B',),
                     gapHC(2),
                     line(),
                     gapHC(5),
                     amountHRow(mfnLng('Expected Cash'),
                         lstrExpectedCash.toStringAsFixed(2), 'P'),
                     gapHC(2),
                     amountHRow(
                         mfnLng('Actual Cash'),
                         lstrActualCash.toStringAsFixed(2),
                         'B'),
                     gapHC(2),
                     amountHRow(mfnLng('Difference'),
                         lstrDiffrence.toStringAsFixed(2), 'N'),
                     line(),
                     gapHC(5),

                     amountHRow(mfnLng('Gross Amount'),
                         lstrGrossAmount.toStringAsFixed(2), 'B'),
                     amountHRow(mfnLng('Refunds'),
                         lstrRefundAmount.toStringAsFixed(2), 'B'),
                     amountHRow(mfnLng('Discounts'),
                         lstrDiscountAmount.toStringAsFixed(2), 'B'),
                     amountHRow(mfnLng('Void Amount'),
                         lstrVoidAmount.toStringAsFixed(2), 'B'),
                     amountHRow(mfnLng('Addl. Amount'),
                         lstrAddlAmount.toStringAsFixed(2), 'B'),
                     amountHRow(mfnLng('Net Sales'),
                         lstrNetAmount.toStringAsFixed(2), 'B'),
                     g.wstrHIDE_CLOSING_YN != "Y"?
                     amountHRow(mfnLng('Cash'),
                         lstrCashAmount.toStringAsFixed(2), 'B'):gapHC(0),
                     amountHRow(mfnLng('Card'),
                         lstrCardAmount.toStringAsFixed(2), 'B'),

                     line(),

                   ],
                 ),
               ),
             ),
             // Flexible(
             //   flex: 3,
             //   child:  Container(
             //     margin: const EdgeInsets.only(top: 10.0),
             //     // color: Colors.blueGrey,
             //     child: ListView.builder(
             //         physics: AlwaysScrollableScrollPhysics(),
             //         itemCount: lstrPayMode.length,
             //         itemBuilder: (context, index) {
             //           var dataList = lstrPayMode[index];
             //           var paymentMode = dataList["PAYMODE"] ?? '';
             //           var paymentAmt = dataList["Column1"] ?? 0.0;
             //
             //           return GestureDetector(
             //             onTap: () {},
             //             //h1(userName.toString())
             //             child: Container(
             //               margin: EdgeInsets.only(bottom: 5),
             //               child: Row(
             //                 crossAxisAlignment: CrossAxisAlignment.start,
             //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
             //                 children: [
             //                   ts(paymentMode, Colors.black, 15) ,
             //                   gapHC(20),
             //                   tc(paymentAmt.toString(), Colors.black, 15)
             //                 ],
             //               ),
             //             ),
             //           );
             //         }),
             //   ),
             // ),
           ],
         )),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
              fnGetClosingData();
              var cd = formatDate.format(DateTime.parse(g.wstrClockInDate));
              PageDialog().clockOutDialog(context, fnClockOut, g.wstrShifDescp, cd);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: boxDecoration(PrimaryColor, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tc('Close', Colors.white, 15)
                ],
              ),
            ),
          )

        ],
      ),
    ), "Closing Summary",(){

    });
  }

  fnSaveSuccess(value,cash,diff) {
    if (g.fnValCheck(value)) {
      var data = value[0];
      var sts = data["STATUS"];
      var msg = data["MSG"];
      if (sts == "1") {
        setState(() {
          lstrSelectedDocno = data["CODE"];
          lstrSelectedDocType = data["DOCTYPE"];
          lstrSelectedYearcode = data["YEARCODE"];
        });
        fnBuildWidget();

        fnPrintCall();
      } else {}
      showToast( msg);
      // if(g.wstrHIDE_CLOSING_YN == "Y"){
      //   msgBox(context, "CASH $cash \n DIFFERENCE $diff", "S", Icons.done_all);
      // }
    }
  }

  fnPrintCall() {
    fnPrint();



    //PageDialog().printDialog(context, fnPrint);
  }

  fnPrint() {
    if (printSts) {
      printSts = false;
      futurePrint = apiCall.printClosing(g.wstrCompany, lstrSelectedYearcode,
          lstrSelectedDocno, lstrSelectedDocType, 1, g.wstrPrinterPath);
      futurePrint.then((value) => fnPrintSuccess(value));
    }
  }

  fnPrintSuccess(value) {
    if(mounted){
      setState(() {
        printSts = true;
      });
    }
  }

  fnClockOut() {
    if (clockoutStatus) {
      setState(() {
        clockoutStatus = false;
      });
      futureClockOut = apiCall.colckInOut(
          'OUT', g.wstrUserCd, g.wstrCompany, g.wstrShifNo, g.wstrYearcode);
      futureClockOut.then((value) => fnClockInSuccess(value));
    }
  }

  fnClockInSuccess(value) async {
    setState(() {
      clockoutStatus = true;
    });
    if (g.fnValCheck(value)) {
      var dataList = value['Table1'][0];
      var sts = dataList["STATUS"].toString();
      var msg = dataList["MSG"];
      Navigator.pop(context);

      if (sts == "1") {
        fnClockOutCallback();
      } else {
        var pendingList = value['Table2'];
        PageDialog().showSysytemInfo(
            context,
            Container(
              height: 200,
              child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: pendingList.length,
                  itemBuilder: (context, index) {
                    var dataList = pendingList[index];
                    var id = dataList["COUNTER_NO"] ?? "";
                    var name = dataList["MACHINENAME"] ?? "";
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 40,
                        margin:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        decoration: boxDecoration(Colors.amber, 10),
                        child: Center(
                          child: tc(name.toString(), Colors.black, 20),
                        ),
                      ),
                    );
                  }),
            ),
            g.mfnDbl('DAILY CLOSING IS PENDING'));
      }
      showToast( msg);
    }
  }

  fnClockOutCallback() async {
    final SharedPreferences prefs = await _prefs;

    prefs.setString('wstrUserCd', '');
    prefs.setString('wstrUserName', '');
    prefs.setString('wstrUserRole', '');
    prefs.setString('wstrCompany', g.wstrCompany);
    prefs.setString('wstrYearcode', g.wstrYearcode);
    prefs.setString('wstrLoginSts', 'N');
    prefs.setString('wstrTableView', '');

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  //nav
  fnPageBack() {
    Navigator.pop(context);
  }
}
