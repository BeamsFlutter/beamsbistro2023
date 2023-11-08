


IP CHANGE

lib/Controllers/Services/apiManager.dart
var baseUrl = "http://192.168.1.205:1100/"; //splash


API CALL
lib/Controllers/Services/apiController.dart


PAGES
lib/Views/Pages

------------------------------------------------------SPLASH START
SPLASH SCREEN
lib/Views/Pages/QuickBill

1.TAKE ORDER
lib/Views/Pages/QuickBill/direct_rsl.dart

2.INVOICE
lib/Views/Pages/QuickBill/invoice.dart

3.KOT SCREEN
lib/Views/Pages/QuickBill/invoice_status.dart

4.BOOKING
lib/Views/Pages/Booking/booking.dart

5.DAILY CLOSING
lib/Views/Pages/Bill

6.OPEN CASH
lib/Views/Pages/Bill

7.ALL ALERT DIALOGS
lib/Views/Components/alertDialog.dart

------------------------------------------------------SPLASH END

-----------------------------------------------------NORMAL SCREENS

1.CASHIER LOGIN
lib/Views/Pages/Bill/billingPos.dart

2.CHEF LOGIN
lib/Views/Pages/Kitchen/kitchenDisplay.dart

3.WAITER
lib/Views/Pages/Home/waiterHomeL.dart

4.MENU
lib/Views/Pages/Menu/menuL.dart

-----------------------------------------------------NORMAL SCREENS END

  fnCheckDocDate(){
    var rtnSts = false;
    var wstrClockInDate;
    var lstrToday;
    var sts ;
    if(g.wstrClockInDate != null){

      var checkDate = DateTime.parse(formatDate2.format(DateTime.parse(g.wstrClockInDate).add(Duration(days:1))));
      var checkDateTime  =  DateTime(checkDate.year,checkDate.month,checkDate.day,g.wstrAutoClockOutTime,0,0);
      var now = DateTime.now();
      lstrToday = DateTime.parse(formatDate2.format(now));
      wstrClockInDate = DateTime.parse(formatDate2.format(DateTime.parse(g.wstrClockInDate).add(Duration(hours:24))));

      rtnSts  =  checkDateTime.isAfter(lstrToday);

      sts = lstrToday.compareTo(wstrClockInDate).toString();
    }
    // if(sts == "-1" || sts == "0"){
    //   rtnSts =  true;
    // }
    return rtnSts;
  }
