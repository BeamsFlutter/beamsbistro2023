import 'dart:convert';

import 'package:beamsbistro/Controllers/Services/appExceptions.dart';
import 'package:beamsbistro/Controllers/Services/baseController.dart';
import 'apiManager.dart';

class ApiCall  with BaseController{

  //company
  Future<dynamic> userLogin(passcode,company) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'PASSWORD':passcode,
      'COMPANY':company,
    });

    var response = await ApiManager().postLoading('api/Login',request,'S').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });

    if (response == null) return;

    return response;
    //print(response);

  }
  Future<dynamic> getCompanyDetails(company) async{

    var response = await ApiManager().postLink('api/getCompanyDetails?COMPANY='+company).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getIP() async{

    var response = await ApiManager().postLink('api/GetDeviceIP').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //Lookup
  Future<dynamic> LookupSearch(lstrTable,lstrColumn,lstrPage,lstrPageSize,lstrFilter) async {

    var request = jsonEncode(<dynamic, dynamic>{
      "lstrTable" : lstrTable,
      "lstrSearchColumn" :lstrColumn,
      "lstrPage" : lstrPage,
      "lstrLimit": lstrPageSize,
      "lstrFilter" : lstrFilter
    });

    var response = await ApiManager().post('api/lookupSearch',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;

  }
  Future<dynamic> LookupValidate(lstrTable,lstrFilter) async {

    var request = jsonEncode(<dynamic, dynamic>{
      "lstrTable" : lstrTable,
      "lstrFilter" : lstrFilter
    });
    var response = await ApiManager().post('api/lookupValidate',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;

  }

  //Floor
  Future<dynamic> viewFloor(docNo,mode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'VIEW_TYPE':mode,
      'CODE':docNo
    });

    var response = await ApiManager().post('api/getFloorMast',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> saveFloor(docNo,descp,mode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      "CODE": docNo,
      "DESCP": descp,
      "STATUS": 'A',
      "MODE": mode,
    });

    var response = await ApiManager().post('api/saveFloorMast',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> deleteFloor(docNo) async{

    var request = jsonEncode(<dynamic, dynamic>{
      "CODE": docNo
    });

    var response = await ApiManager().post('api/deleteFloorMast',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //Table
  Future<dynamic> viewTable(docNo,mode,company) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'VIEW_TYPE':mode,
      'CODE':docNo,
      'COMPANY':company
    });

    var response = await ApiManager().post('api/getTableMast',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> saveTable(docNo,descp,mode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      "CODE": docNo,
      "DESCP": descp,
      "STATUS": 'A',
      "MODE": mode,
    });

    var response = await ApiManager().post('api/saveFloorMast',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getTables(company,yearcode,floorCode,usercd) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'FLOOR_CODE':floorCode,
      'USER_CD':usercd
    });

    var response = await ApiManager().post('api/GetTables',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getTableItems(company,yearcode,code,viewType) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'CODE':code,
      'VIEW_TYPE':viewType
    });

    var response = await ApiManager().post('api/GetTableItems',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }


  //Item
  Future<dynamic> getMenuItem(company,menuCode,menuGroup,d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,dishCode,user_cd,DeliveryMode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'MENUCODE':menuCode,
      'MENUGROUP':menuGroup,
      "DISHGP1": d1,
      "DISHGP2": d2,
      "DISHGP3": d3,
      "DISHGP4": d4,
      "DISHGP5": d5,
      "DISHGP6": d6,
      "DISHGP7": d7,
      "DISHGP8": d8,
      "DISHGP9": d9,
      "DISHGP10": d10,
      "DISHCODE": dishCode,
      "USER_CD":user_cd,
      "MODE":DeliveryMode
    });

    var response = await ApiManager().post('api/getMenuItem',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getComboAddon(mode,code) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'MODE':mode,
      'DISHCODE':code,
    });

    var response = await ApiManager().post('api/getComboAddon',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //MENU CHOICE getChoice
  Future<dynamic> getChoice(choiceCode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'CHOICE_CODE':choiceCode,
    });

    var response = await ApiManager().post('api/getChoice',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //KOT
  Future<dynamic> saveOrder(kot,kotDet,kotTable,lstrKotDelivryDet,mode,passcode,voidcode,voiddescp,kotChoice) async{

    var request = jsonEncode(<dynamic, dynamic>{
      "KOT": kot,
      "KOTDET": kotDet,
      "KOT_TABLEDET": kotTable,
      "KOT_ADDRESS": lstrKotDelivryDet,
      "PASSCODE": passcode,
      "VOID_REASON_CODE": voidcode,
      "VOID_REASON_DESCP": voiddescp,
      "MODE": mode,
      "KOT_CHOICE": kotChoice,
    });
    print('api/SaveOrder');
    print(request);
    var response = await ApiManager().postLoading('api/SaveOrder',request,'S').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    print(response);
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> saveOrderFromRsl(kot,kotDet,kotTable,lstrKotDelivryDet,mode,passcode,voidcode,voiddescp) async{

    var request = jsonEncode(<dynamic, dynamic>{
      "KOT": kot,
      "KOTDET": kotDet,
      "KOT_TABLEDET": kotTable,
      "KOT_ADDRESS": lstrKotDelivryDet,
      "PASSCODE": passcode,
      "VOID_REASON_CODE": voidcode,
      "VOID_REASON_DESCP": voiddescp,
      "MODE": mode,
    });

    var response = await ApiManager().post('api/SaveOrder',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> finishOrder(company,docno,doctype,yearcode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY":company,
      "DOCNO": docno,
      "DOCTYPE": doctype,
      "YEARCODE": yearcode,
    });

    var response = await ApiManager().post('api/KotComplete',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> kotQuickCompletion(company,docno,doctype,yearcode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY":company,
      "DOCNO": docno,
      "DOCTYPE": doctype,
      "YEARCODE": yearcode,
    });

    var response = await ApiManager().post('api/KotQuickComplete',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> printOrder(company,docno,doctype,yearcode,printCount,printPath) async{

    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY":company,
      "DOCNO": docno,
      "DOCTYPE": doctype,
      "YEARCODE": yearcode,
      "PRINT_COUNT": printCount,
      "PRINTER_PATH": printPath,
    });

    var response = await ApiManager().post('api/PrintInvoiceKot',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> updateKotDiscount(company,yearcode,docno,doctype,discAmt,KOTDET) async{

    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY":company,
      "YEARCODE": yearcode,
      "DOCNO": docno,
      "DOCTYPE": doctype,
      "DISC_AMT": discAmt,
      "KOTDET": KOTDET,

    });

    var response = await ApiManager().post('api/updateDiscount',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> updateKotAddl(company,yearcode,docno,doctype,discAmt,KOTDET,addlList) async{

    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY":company,
      "YEARCODE": yearcode,
      "DOCNO": docno,
      "DOCTYPE": doctype,
      "ADDL_AMT": discAmt,
      "KOTDET": KOTDET,
      "KOT_ADDL_CHARGE": addlList,

    });

    var response = await ApiManager().post('api/UpdateAddl',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }


  //Pos
  Future<dynamic> getKotInvoices(company,yearcode,docno,orderType,tableNo,orderMode,search) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DOCNO':docno,
      'ORDER_TYPE':orderType,
      'TABLE_CODE':tableNo,
      'ORDER_MODE':orderMode,
      'SEARCH':search
    });

    var response = await ApiManager().post('api/GetKotInvoices',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getKotInvoiceDet(company,yearcode,docno,orderType,tableNo,orderMode,search) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DOCNO':docno,
      'ORDER_TYPE':orderType,
      'TABLE_CODE':tableNo,
      'ORDER_MODE':orderMode,
      'SEARCH':search
    });

    var response = await ApiManager().postLoading('api/GetKotInvoices',request,"S").catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> saveInvoice(rsl,rslDet,rslVoid,rslVoidDet,retailPay,mode,addlCharge,closeBookingYn,printerpath,paymode,printyn,invmode,otherAmt,paymentDocno,paymentDoctype,paymentCrad,rslDetOther) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'RSL':rsl,
      'RSLDET':rslDet,
      'RSL_VOID':rslVoid,
      'RSL_VOIDDET':rslVoidDet,
      'RETAILPAY':retailPay,
      'RSL_ADDL_CHARGE':addlCharge,
      'MODE':mode,
      'CLOSE_BOOKING':closeBookingYn,
      "PRINTER_PATH":printerpath,
      "PAY_MODE":paymode,
      "PRINT_YN":printyn,
      "INV_MODE": invmode,
      "RSL_VOID_HISTORY":[],
      "RSL_VOID_HISTORY_DET":[],
      "RSL_OTHERCHARGE":otherAmt,
      "RSLDET_CHOICE":rslDetOther,
      "PAYMENT_DOCNO":paymentDocno,
      "PAYMENT_DOCTYPE":paymentDoctype,
      "PAYMENT_CARD":paymentCrad,
    });

    var response = await ApiManager().post('api/saveInvoice',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> saveCoupon(company,yearcode,rsl,rslDet) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'RSL':rsl,
      'RSLDET':rslDet,
      'COMPANY':company,
      'YEARCODE':yearcode
    });

    var response = await ApiManager().post('api/CouponRedeem',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }


  Future<dynamic> saveInvoiceVoid(rsl,rslDet,rslVoid,rslVoidDet,retailPay,mode,addlCharge,closeBookingYn,printerpath,paymode,printyn,invmode,voidApprovedUser,history,historyDet,otherAmount) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'RSL':rsl,
      'RSLDET':rslDet,
      'RSL_VOID':rslVoid,
      'RSL_VOIDDET':rslVoidDet,
      'RETAILPAY':retailPay,
      'RSL_ADDL_CHARGE':addlCharge,
      'MODE':mode,
      'CLOSE_BOOKING':closeBookingYn,
      "PRINTER_PATH":printerpath,
      "PAY_MODE":paymode,
      "PRINT_YN":printyn,
      "INV_MODE": invmode,
      "VOID_APPROVED_USER":voidApprovedUser,
      "RSL_VOID_HISTORY":history,
      "RSL_VOID_HISTORY_DET":historyDet,
      "RSL_OTHERCHARGE":otherAmount
    });

    var response = await ApiManager().post('api/saveInvoice',request).catchError((error){
      if (error is BadRequestException) {
       // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> saveInvoiceWithKot(rsl,rslDet,rslVoid,rslVoidDet,retailPay,mode,addlCharge,closeBookingYn,printerpath,paymode,printyn,invmode,kot,kotdet,kotyn) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'RSL':rsl,
      'RSLDET':rslDet,
      'RSL_VOID':rslVoid,
      'RSL_VOIDDET':rslVoidDet,
      'RETAILPAY':retailPay,
      'RSL_ADDL_CHARGE':addlCharge,
      'MODE':mode,
      'CLOSE_BOOKING':closeBookingYn,
      "PRINTER_PATH":printerpath,
      "PAY_MODE":paymode,
      "PRINT_YN":printyn,
      "INV_MODE": invmode,
      "KOT":kot,
      "KOTDET":kotdet,
      "KOT_YN":kotyn
    });

    var response = await ApiManager().post('api/saveInvoice',request).catchError((error){
      if (error is BadRequestException) {
       // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getInvoice(company,yearCode,docNo,orderType,dateFrom,dateTo,user,finishYn,kitchenCode,search,orderMode,pageNum) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearCode,
      'DOCNO':docNo,
      'ORDER_TYPE':orderType,
      'DATE_FROM':dateFrom,
      'DATE_TO':dateTo,
      'CREATE_USER':user,
      "FINISHED_YN":finishYn,
      "KITCHEN_CODE":kitchenCode,
      "SEARCH":search,
      "ORDER_MODE":orderMode,
      "PAGE_NUM":pageNum,
    });

    var response = await ApiManager().post('api/GetInvoice',request).catchError((error){
      if (error is BadRequestException) {
      //  var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> printInvoice(company,yearcode,docno,docType,printCount,path,paymode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DOCTYPE':docType,
      'DOCNO':docno,
      'PRINT_COUNT':printCount,
      'PRINTER_PATH':path,
      'PAYMODE':paymode
    });

    var response = await ApiManager().post('api/PrintInvoice',request).catchError((error){
      if (error is BadRequestException) {
       // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> printInvoiceBkd(company,yearcode,docno,docType,printCount,path,paymode,prvdocno) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DOCTYPE':docType,
      'PRVDOCNO':prvdocno,
      'DOCNO':docno,
      'PRINT_COUNT':printCount,
      'PRINTER_PATH':path,
      'PAYMODE':paymode
    });

    var response = await ApiManager().post('api/PrintInvoice',request).catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> printInvoiceVoid(company,yearcode,docno,docType,printCount,path,mode,paymode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DOCTYPE':docType,
      'DOCNO':docno,
      'PRINT_COUNT':printCount,
      'PRINTER_PATH':path,
      'MODE':mode,
      'PAYMODE':paymode
    });

    var response = await ApiManager().postLoading('api/PrintInvoice',request,"S").catchError((error){
      if (error is BadRequestException) {
       // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> openDrawer(path) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'PRINTER_PATH':path,
    });

    var response = await ApiManager().post('api/openDrawer',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getChargeType(company,category) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'CATEGORY':category,
    });

    var response = await ApiManager().post('api/getChargeType',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> geDiscountAuth(code,passcode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'DISC_GROUP':code,
      'PASSCODE':passcode,
    });

    var response = await ApiManager().post('api/DiscountAuth',request).catchError((error){
      if (error is BadRequestException) {
       // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> getDiscountList(docno,doctype,company,yearcode) async{

    var response = await ApiManager().postLink('api/getItemDiscount?COMPANY='+company+'&YEARCODE='+yearcode+'&DOCNO='+docno+'&DOCTYPE='+doctype).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //MERGE#
  Future<dynamic> SaveMergeOrder(kot,kotDet,mode,passcode,kotChoice,kotMerge) async{

    var request = jsonEncode(<dynamic, dynamic>{
      "KOT": kot,
      "KOTDET": kotDet,
      "PASSCODE": passcode,
      "MODE": mode,
      "KOT_CHOICE": kotChoice,
      "KOT_MERGE": kotMerge,
      "KOT_TABLEDET": [],
      "KOT_ADDRESS": [],
      "VOID_REASON_CODE": "",
      "VOID_REASON_DESCP": "",
    });

    var response = await ApiManager().postLoading('api/SaveMerge',request,'S').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //SPLIT#
  Future<dynamic> SaveSplitOrder(company,yearcode,docno,doctype,createuser,createmachineId,orders) async{

    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY": company,
      "YEARCODE": yearcode,
      "DOCNO": docno,
      "DOCTYPE": doctype,
      "CREATE_USER": createuser,
      "CREATE_MACHINEID": createmachineId,
      "ORDERS": orders,
    });

    var response = await ApiManager().postLoading('api/SaveSplit',request,'S').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //Kitchen
  Future<dynamic> getKitchenView(company,yearcode,kitchenCode,mode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'KITCHENCODE':kitchenCode,
      'MODE':mode,
    });

    var response = await ApiManager().post('api/kitchenView',request).catchError((error){
      if (error is BadRequestException) {
      //  var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> savePreparation(itemList) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'PREPDET':itemList,
    });

    var response = await ApiManager().post('api/SavePreparation',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getChef(shift) async{

    var request = jsonEncode(<dynamic, dynamic>{
        "SHIFT_CODE":shift
    });

    var response = await ApiManager().post('api/getChef',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getKitchenDetails() async{


    var response = await ApiManager().postLink('api/getKitchenDetails').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        ////showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //getCard
  Future<dynamic> getCardType(company) async{


    var response = await ApiManager().postLink('api/getCreditcards?COMPANY='+company).catchError((error){
      if (error is BadRequestException) {
       // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //shift
  Future<dynamic> getShift() async{

    var response = await ApiManager().postLink('api/getShifts').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> colckInOut(mode,user,company,shiftcode,yearcode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'MODE':mode,
      'USERCD':user,
      'COMPANY':company,
      'YEARCODE':yearcode,
      'SHIFT_CODE':shiftcode,
    });

    var response = await ApiManager().post('api/ClockInOut',request).catchError((error){
      if (error is BadRequestException) {
       // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //OpenCash
  Future<dynamic> saveOpenCash(company,yearcode,userid,shifNo,openAmt,addDeduct,macid,macName) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'USERID':userid,
      'SHIFNO':shifNo,
      'OPEN_AMT':openAmt,
      'ADD_DEDUCT':addDeduct,
      'MACHINEID':macid,
      'MACHINENAME':macName
    });

    var response = await ApiManager().post('api/SaveOpenCash',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getOpenCash(company,yearcode,userid,macid) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'USERID':userid,
      'MACHINEID':macid
    });

    var response = await ApiManager().post('api/getOpenCash',request).catchError((error){
      if (error is BadRequestException) {
       // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //shiftClosing
  Future<dynamic> getClosingData(company,yearcode,macid,usercd) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'USERCD':usercd,
      'MACHINEID':macid
    });

    var response = await ApiManager().post('api/GetClosingData',request).catchError((error){
      if (error is BadRequestException) {
       // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> saveClosing(dataList) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'DAILY_CLOSING':dataList,
      'MODE':"ADD"
    });

    var response = await ApiManager().post('api/saveClosingData',request).catchError((error){
      if (error is BadRequestException) {
       // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> printClosing(company,yearcode,docno,docType,printCount,path) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DOCTYPE':docType,
      'DOCNO':docno,
      'PRINT_COUNT':printCount,
      'PRINTER_PATH':path
    });

    var response = await ApiManager().post('api/PrintClosing',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //print
  Future<dynamic> getPrinters() async{

    var response = await ApiManager().postLink('api/getPrinters').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //Reason
  Future<dynamic> getReason() async{

    var response = await ApiManager().postLink('api/getReasonMaster').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //Refresh
  Future<dynamic> pageRefresh(company,yearcode,page,time) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'PAGE':page,
      'TIME':time
    });

    var response = await ApiManager().post('api/getRefresh',request).catchError((error){
      if (error is BadRequestException) {
       // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }


  //Booking
  Future<dynamic> getEventMast() async{


    var response = await ApiManager().postLink('api/getEventMast').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        ////showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getGuest(mobile) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'MOBILE':mobile,
    });

    var response = await ApiManager().post('api/getGuest',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> saveBooking(rslBooking,rslDetBooking,rslTable,rsl,rslDet,retailPay,rslAddlCharge,guest,mode,printerPath) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'RSL_BOOKING' : rslBooking,
      'RSLDET_BOOKING' : rslDetBooking,
      'RSLTABLE' : rslTable ,
      'RSL' : rsl,
      'RSLDET' : rslDet,
      'RETAILPAY' : retailPay,
      'RSL_ADDL_CHARGE' : rslAddlCharge,
      'GUEST' :guest,
      'MODE' :mode,
      'BOOKING_MODE' :"AREA",
      'PRINT_PATH' :printerPath,
    });

    var response = await ApiManager().postLoading('api/SaveBooking',request,'S').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getBooking(company,yearcode,doctype,docno,mode,dateFrom,dateTo,partyCode,areaCode,partyMobile,
      booking_time_from,booking_time_to) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY' : company,
      'YEARCODE' : yearcode,
      'DOCTYPE' : doctype ,
      'DOCNO' : docno,
      'MODE' : mode,
      'DATE_FROM' : dateFrom,
      'DATE_TO' : dateTo,
      'PARTYCODE' : partyCode,
      'AREA_CODE' : areaCode,
      'PARTY_MOBILE' : partyMobile,
      'BOOKING_TIME_FROM' : booking_time_from,
      'BOOKING_TIME_TO' : booking_time_to
    });

    var response = await ApiManager().post('api/GetBooking',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> saveInvoiceBooking(rsl,rslDet,mode,addlCharge,printpath) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'RSL':rsl,
      'RSLDET':rslDet,
      'RSL_ADDL_CHARGE':addlCharge,
      'PRINTER_PATH':printpath,
      'MODE':mode
    });

    var response = await ApiManager().post('api/saveInvoiceBooking',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> rslFinishSts(docno,doctype,yearcode,company) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DOCTYPE':doctype,
      'DOCNO':docno
    });

    var response = await ApiManager().postLoading('api/FinishRsl',request,'S').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> printSpotInvoice(company,yearcode,docno,docType,printCount,path,mode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DOCTYPE':docType,
      'DOCNO':docno,
      'PRINT_COUNT':printCount,
      'PRINTER_PATH':path,
      'MODE':mode
    });

    var response = await ApiManager().post('api/PrintSpot',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }



  Future<dynamic> printSpotInvoiceBooking(company,yearcode,docno,docType,printCount,path,mode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DOCTYPE':docType,
      'DOCNO':docno,
      'PRINT_COUNT':printCount,
      'PRINTER_PATH':path,
      'MODE':mode
    });

    var response = await ApiManager().post('api/BookingPrintSpot',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> checkReserve(company,yearcode,bookingDate,timeFrom,timeTo,table) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'BOOKING_DATE':bookingDate,
      'BOOKING_TIME_FROM':timeFrom,
      'BOOKING_TIME_TO':timeTo,
      'TABLE_CODE':table
    });

    var response = await ApiManager().post('api/CheckReserve',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getHoldInvoice(company,prvdocno,prvdoctype) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'PRVDOCNO':prvdocno,
      'PRVDOCTYPE':prvdoctype
    });

    var response = await ApiManager().post('api/GetHoldInvoice',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> printInvoiceBooking(company,yearcode,docno,docType,printCount,path,user,machineid) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DOCTYPE':docType,
      'DOCNO':docno,
      'PRINT_COUNT':printCount,
      'PRINTER_PATH':path,
      'USERCD':user,
      'MACHINEID':machineid,
    });

    var response = await ApiManager().postLoading('api/PrintInvoiceBooking',request,'S').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }


  //dashboard
  Future<dynamic> getDailySales(company,dateFrom,dateTo,counterNo,shiftNo,Hour,orderType) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'DATE_FROM':dateFrom,
      'DATE_TO':dateTo,
      'COUNTER_NO':counterNo,
      'SHIFT_NO':shiftNo,
      'HOUR':Hour,
      'ORDER_TYPE':orderType,
    });

    var response = await ApiManager().post('api/getDDailySales',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }


  //get guestmaster
  Future<dynamic> getGuestMaster(company,guestMasterCode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'GUEST_CODE':guestMasterCode,
    });
    var response = await ApiManager().postLoading('api/GetGuestMaster',request,'S').catchError((error){
      if (error is BadRequestException) {

      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //delete booking
  Future<dynamic> deleteBooking(company,yearCode,docNO,docType,partyCode) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearCode,
      'DOCNO':docNO,
      'DOCTYPE':docType,
      //'GUEST_CODE':partyCode,
    });
    var response = await ApiManager().postLoading('api/deleteBooking',request,'S').catchError((error){
      if (error is BadRequestException) {

      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> adminPermission(PASSCODE) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'PASSCODE':PASSCODE,
    });
    var response = await ApiManager().postLoading('api/adminPermission',request,'').catchError((error){
      if (error is BadRequestException) {

      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getBookingInvoice(company,yearCode,docNo,orderType,dateFrom,dateTo,user,search) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearCode,
      'DOCNO':docNo,
      'ORDER_TYPE':orderType,
      'DATE_FROM':dateFrom,
      'DATE_TO':dateTo,
      'CREATE_USER':user,
      'SEARCH':search,
    });

    var response = await ApiManager().post('api/GetBookingInvoice',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //Closing
  Future<dynamic> getClosingHistory(company,yearCode,docNo,docType,userCd,macId,dateFrom,dateTo) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearCode,
      'DOCNO':docNo,
      'DOCTYPE':docType,
      'USERCD':userCd,
      'MACHINEID':macId,
      'DATE_FROM':dateFrom,
      'DATE_TO':dateTo,
    });

    var response = await ApiManager().postLoading('api/GetClosingHistory',request,'').catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //COUPON - OPTIONS
  Future<dynamic> checkCouponValidity(company,couponNo) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'COUPON':couponNo
    });

    var response = await ApiManager().postLink('api/couponValidate?COMPANY='+company+'&COUPON='+couponNo).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> couponIssue(company,yearCode,coupon,userCd,macId,macName,issueCount,printPath) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearCode,
      'COUPON_CODE':coupon,
      'CREATE_USER':userCd,
      'CREATE_MACHINEID':macId,
      'CREATE_MACHINENAME':macName,
      'ISSUE_COUNT':issueCount,
      'PRINT_PATH':printPath,
    });

    var response = await ApiManager().postLoading('api/couponIssue',request,'').catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getCouponItems(company,couponNo) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'COUPON':couponNo
    });

    var response = await ApiManager().postLink('api/couponItems?COMPANY='+company+'&COUPON='+couponNo).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getCouponDetItems(company,couponNo) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'COUPON':couponNo
    });

    var response = await ApiManager().postLink('api/couponItemsDet?COMPANY='+company+'&COUPON='+couponNo).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  // Delivery modes
  Future<dynamic> getDeliveryModes() async{

    var response = await ApiManager().postLink('api/GetDeliveryModes').catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //=============================Reports
  Future<dynamic> getPosReport(company,yearcode,counter_no,usercd) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'MACHINEID':counter_no,
      'USERCD':usercd,
    });

    var response = await ApiManager().post('api/GetPosReport',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getPrintQuickReport(company,yearcode,counter_no,usercd,printPath) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'MACHINEID':counter_no,
      'USERCD':usercd,
      'PRINTER_PATH':usercd,
      'PRINTER_COUNT':1,
    });

    var response = await ApiManager().post('api/PrintPosReport',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> getRoomSalesReport(company,yearcode,dateFrom,dateTo,mode,orderRoom,orderRef,userCd,macid) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DATE_FROM':dateFrom,
      'DATE_TO':dateTo,
      'MODE':mode,//C,R,"" --  room,coupon,all
      'ORDER_ROOM':orderRoom,
      'ORDER_REF':orderRef,
      'USERCD':userCd,
      'MACHINEID':macid,
    });

    var response = await ApiManager().post('api/RoomDetSaleReport',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> printRoomSalesReport(company,yearcode,dateFrom,dateTo,mode,orderRoom,orderRef,userCd,macid) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DATE_FROM':dateFrom,
      'DATE_TO':dateTo,
      'MODE':mode,//C,R,"" --  room,coupon,all
      'ORDER_ROOM':orderRoom,
      'ORDER_REF':orderRef,
      'USERCD':userCd,
      'MACHINEID':macid,
    });

    var response = await ApiManager().post('api/PrintRoomDetSaleReport',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> printRoomSummaryReport(company,yearcode,dateFrom,dateTo,mode,orderRoom,orderRef,userCd,macid) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DATE_FROM':dateFrom,
      'DATE_TO':dateTo,
      'MODE':mode,//C,R,"" --  room,coupon,all
      'ORDER_ROOM':orderRoom,
      'ORDER_REF':orderRef,
      'USERCD':userCd,
      'MACHINEID':macid,
    });

    var response = await ApiManager().post('api/PrintRoomSummerySaleReport',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> getVoidReport(company,yearcode,dateFrom,dateTo,userCd,macid) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DATE_FROM':dateFrom,
      'DATE_TO':dateTo,
      'USERCD':userCd,
      'MACHINEID':macid,
    });

    var response = await ApiManager().post('api/VoidReport',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> printVoidReport(company,yearcode,dateFrom,dateTo,userCd,macid) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'DATE_FROM':dateFrom,
      'DATE_TO':dateTo,
      'USERCD':userCd,
      'MACHINEID':macid,
    });

    var response = await ApiManager().post('api/PrintVoidReport',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> printFinancial(company,yearcode,path) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'PRINTER_PATH':path,
    });

    var response = await ApiManager().post('api/printFinancial',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> printFinancialDay(company,yearcode,path,dateTo) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'PRINTER_PATH':path,
      'DATE_TO':dateTo,
    });

    var response = await ApiManager().post('api/printFinancialday',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }


  //============================86 menu
  Future<dynamic> getAvailableMenu(company,availableYn,search) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'SEARCH':search,
      'MENU_YN':availableYn,
    });

    var response = await ApiManager().post('api/GetItemNames',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> updateMenuAvailable(company,dishList) async{
  //DISHCODE,MENU_YN
    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'DISH_LIST':dishList
    });

    var response = await ApiManager().post('api/ChangeDishStatus',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //==========================validate order ref

  Future<dynamic> validateOrderRef(company,mode,orderref) async{
    var response = await ApiManager().postLink('api/validateOrderRef?COMPANY='+company+'&ORDER_MODE='+mode+'&ORDER_REF='+orderref).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }


 //==========================Other Amount
  Future<dynamic> apiGetRslOtherAmount() async{
    var response = await ApiManager().postLink('api/getotheramt').catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    print('api/getotheramt');
    print(response);
    if (response == null) return;
    return response;
    //print(response);
  }


  //======================================================card payment -- TAPING
  Future<dynamic> apiCardPayment(docdate,amount,fromDevice,toDevice,fromKey,createUser) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'BRNCODE':"",
      'COMPANY':"",
      'DOCDATE':docdate,
      'AMOUNT':amount,
      'FROM_DEVICE_ID':fromDevice,
      'TO_DEVICE_ID':toDevice,
      'FROM_KEY':fromKey,
      'CREATE_USER':createUser
    });
    var response = await ApiManager().post('api/tapPaymentTxn',request).catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> apiCheckPayment(docno,doctype) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO':docno,
      'DOCTYPE':doctype,
    });
    var response = await ApiManager().post('api/checkPaymentTxn',request).catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> apiGetTapDevices() async{

    var response = await ApiManager().postLink('api/getTapDevices').catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> apiCancelPayment(docno,doctype) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO':docno,
      'DOCTYPE':doctype,
    });
    var response = await ApiManager().post('api/cancelPayment',request).catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> apiPaymentRecall(docno,doctype,paidAmount,cardno) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO':docno,
      'DOCTYPE':doctype,
      'PAID_AMOUNT':paidAmount,
      'TRN_CARDNO':cardno,
    });
    var response = await ApiManager().post('api/paymentRecall',request).catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> apiPaymentSuccess(docno,doctype,paidAmount,cardno) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO':docno,
      'DOCTYPE':doctype,
      'PAID_AMOUNT':paidAmount,
      'TRN_CARDNO':cardno,
    });
    var response = await ApiManager().post('api/paymentSuccess',request).catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //=====================================================MRQ

  Future<dynamic> apiSaveMrq(mrq,mrqdet,mode) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'MRQ':mrq,
      'MRQDET':mrqdet,
      'MODE':mode,
    });
    var response = await ApiManager().post('api/SaveMrq',request).catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> apiGetMrq(company,brncode,mode) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'BRNCODE':brncode,
      'MODE':mode,
    });
    var response = await ApiManager().post('api/getMrq',request).catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }
  Future<dynamic> apiGetMrqDet(company,doctype,docno) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'DOCTYPE':doctype,
      'DOCNO':docno,
    });
    var response = await ApiManager().post('api/getMrqDet',request).catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> apiGetBranch() async{

    var response = await ApiManager().postLink('api/getBranch').catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //Dish Mster
  Future<dynamic> viewDish(docNo, mode, company) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'VIEW_TYPE': mode,
      'DISHCODE': docNo,
      'COMPANY': company
    });

    var response =
    await ApiManager().post('api/getDishMast', request).catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> saveDish(data) async {
    var request = jsonEncode(data);

    var response = await ApiManager()
        .post('api/saveDishMast', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> DeleteDish(data) async {
    var request = jsonEncode(data);

    var response = await ApiManager()
        .post('api/deleteDishMast', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //Kitchen Mster
  Future<dynamic> ViewKitchen(docNo, mode) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'VIEW_TYPE': mode,
      'CODE': docNo,
    });

    var response = await ApiManager()
        .post('api/getKitchenMast', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> SaveKitchen(CODE, DESCP, PRINT_CODE, MODE, USERCD) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'CODE': CODE,
      'DESCP': DESCP,
      'PRINT_CODE': PRINT_CODE,
      'MODE': MODE,
      'USERCD': USERCD
    });

    var response = await ApiManager()
        .post('api/saveKitchenMast', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> DeleteKitcken(CODE, USERCD) async {
    var request =
    jsonEncode(<dynamic, dynamic>{'CODE': CODE, 'USERCD': USERCD});

    var response = await ApiManager()
        .post('api/deleteKitchenMast', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //Dish GROUP

  Future<dynamic> ViewGroup(docNo, mode, GROUP) async {
    var request = jsonEncode(
        <dynamic, dynamic>{'VIEW_TYPE': mode, 'CODE': docNo, 'GROUP': GROUP});

    var response = await ApiManager()
        .post('api/getDishGroup', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> SaveCategory(CODE, DESCP, MODE, GROUP, USERCD) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'CODE': CODE,
      'DESCP': DESCP,
      'MODE': MODE,
      'GROUP': GROUP,
      'USERCD': USERCD
    });

    var response = await ApiManager()
        .post('api/saveDishGroup', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //Printer Mster
  Future<dynamic> ViewPrinter(docNo, mode) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'VIEW_TYPE': mode,
      'CODE': docNo,
    });

    var response = await ApiManager()
        .post('api/getPrintMast', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> SavePrinter(CODE, DESCP, PATH, MODE, USERCD) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'CODE': CODE,
      'NAME': DESCP,
      'PATH': PATH,
      'MODE': MODE,
      'USERCD': USERCD
    });

    var response = await ApiManager()
        .post('api/savePrintMast', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> DeletePrinter(CODE, USERCD) async {
    var request =
    jsonEncode(<dynamic, dynamic>{'CODE': CODE, 'USERCD': USERCD});

    var response = await ApiManager()
        .post('api/deletePrintMast', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  //Kitchen Printer Mster
  Future<dynamic> ViewKitchenPrinter(docNo, mode) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'VIEW_TYPE': mode,
      'CODE': docNo,
    });

    var response = await ApiManager()
        .post('api/getKitchenPrint', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> SaveKitchenPrinter(
      CODE, DESCP, KITCHEN_CODE, FLOOR, PRINTER_CODE, MODE, USERCD) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'CODE': CODE,
      'DESCP': DESCP,
      'KITCHEN_CODE': KITCHEN_CODE,
      'FLOOR': FLOOR,
      'PRINTER_CODE': PRINTER_CODE,
      'MODE': MODE,
      'USERCD': USERCD
    });

    var response = await ApiManager()
        .post('api/saveKitchenPrint', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> DeletekitchenPrinter(CODE, USERCD) async {
    var request =
    jsonEncode(<dynamic, dynamic>{'CODE': CODE, 'USERCD': USERCD});

    var response = await ApiManager()
        .post('api/deleteKitchenPrint', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }


  Future<dynamic> apiGetMultiLanguage() async {
    var response = await ApiManager()
        .postLink('api/getMultiLanguage')
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }

  Future<dynamic> apiGetKotPrint(docNo, doctype,yearcode,company) async {
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO': docNo,
      'DOCTYPE': doctype,
      'YEARCODE': yearcode,
      'COMPANY': company,
    });

    var response = await ApiManager()
        .post('api/fnGeKotPrint', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }


  Future<dynamic> apiUpdateKotDelivery(docNo,doctype,delManCode,vehicleNo) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'DOCNO': docNo,
      'DOCTYPE': doctype,
      'DEL_MAN_CODE': delManCode,
      'VEHICLE_NO': vehicleNo,
    });

    var response = await ApiManager()
        .post('api/KotDeliveryUpdate', request)
        .catchError((error) {
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //showToast( apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;
    //print(response);
  }


}