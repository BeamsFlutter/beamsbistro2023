

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {

  static final Global _instance = Global._internal();

  // passes the instantiation to the _instance object
  factory Global() => _instance;

  //initialize variables in here
  Global._internal() {
    _wstrCompany = '';
    _wstrYearcode = '';
    _wstrUserCd = '';
    _wstrUserName = '';
    _wstrRoleCode = '';
    _wstrTableView = '';
    _wstrMenuMode= '';
    _wstrLastMenuItems= [];
    _wstrLastSelectedTables= [];
    _wstrTableUpdateMode= '';
    _wstrOrderMode= '';
    _wstrOrderType= '';
    _wstrLastSelectedKot = [];
    _wstrLastSelectedKotDocno = '';
    _wstrLastSelectedKotDocType = '';
    _wstrLastSelectedAdd = [];
    _wstrCurrency= 'AED';
    _wstrCurrencyRate = 1;
    _wstrGuestNo = 0;
    _wstrShifNo  = '';
    _wstrClockInDate  = '';
    _wstrShifDescp ='';
    _wstrDeivceId = '';
    _wstrDeviceName = '';
    _wstrSelectedkitchen = '';
    _wstrSelectedkitchenDescp = '';
    _wstrDiscountYn =  false;
    _wstrToken = '';
    _wstrOrderScreenMode = '';
    _wstrPrinterCode = '';
    _wstrPrinterName = '';
    _wstrPrinterPath = '';
    _wstrIp = '';
    _wstrMenuGroup  ='';
    _wstrDiscountGroup = '';
    _wstrDiscountType = '';
    _wstrDiscountMaxPerc = 0.0;
    _wstrDeliveryMode = '';
    _wstrRoomPriceList  ='';
    _wstrRoomMode  ='';
    _wstrAutoClockOutTime = 0;
    _wstrTapDeviceId = "";
    _wstrTapDeviceName = "";
    _wstrPolDisplay = "COM15";
    _wstrUserBrnCode = "";
    _wstrQuickBillYN = "";
    _wstrLanguage = [];
    _wstrLanguageList = [];
    _wstrBistroLng = "ENGLISH";
    _wstrCompanyDet = [];
    _wstrDirectPrintYn = "";
    _wstrBaseUrl = '';
  }
  var _wstrToken  = '';
  var _wstrCompany = '';
  var _wstrDeivceId = '';
  var _wstrDeviceName = '';
  var _wstrYearcode = '';
  var _wstrUserCd = '';
  var _wstrUserName = '';
  var _wstrUserBrnCode = "";
  var _wstrRoleCode = '';
  var _wstrTableView = '';
  var _wstrMenuMode= '';
  var _wstrOrderMode= '';
  var _wstrOrderType= '';
  var _wstrLastMenuItems = [];
  var _wstrLastSelectedTables = [];
  var _wstrLastSelectedKot = [];
  var _wstrLastSelectedAdd = [];
  var _wstrCurrency= 'AED';
  var _wstrCurrencyRate = 1;
  var _wstrGuestNo = 0;
  var _wstrShifNo  = '';
  var _wstrShifDescp  = '';
  var _wstrClockInDate  = '';
  var _wstrSelectedInstructions = [];
  var _wstrSelectedkitchen = '';
  var _wstrSelectedkitchenDescp = '';
  var _wstrLastSelectedKotDocno = '' ;
  var _wstrLastSelectedKotDocType = '' ;
  var _wstrTableUpdateMode = '';
  var _wstrOrderScreenMode;
  var _wstrPrinterCode = '';
  var _wstrPrinterName = '';
  var _wstrPrinterPath = '';
  var _wstrIp = '';
  var _wstrBaseUrl = '';
  var _wstrMenuGroup  ='';
  var _wstrDeliveryMode  ='';
  var _wstrRoomYN  ='';
  var _wstrRoomPriceList  ='';

  var _wstrDiscountYn;
  var _wstrDiscountGroup = '';
  var _wstrDiscountType = '';
  var _wstrDiscountMaxPerc = 0.0;

  var _wstrLanguage = [];
  var _wstrLanguageList = [];
  var _wstrCompanyDet = [];

  var _wstrContext;

  var _wstrDeviceIP;
  var _wstrRoomMode ;
  var _wstrAutoClockOutTime = 0 ;

  var _wstrTapDeviceId = "";
  var _wstrTapDeviceName = "";

  var _wstrPolDisplay = "COM15";
  var _wstrQuickBillYN = "Y";
  var _wstrBistroLng = "ENGLISH";

  var _wstrDirectPrintYn = "Y";
  var _wstrImgYn = "Y";


  var _wstrSPLIT_YN = "";
  var _wstrMERGE_YN = "";
  var _wstrE86ITEM_YN = "";
  var _wstrDINE_IN_YN = "";
  var _wstrTAKEAWAY_YN = "";
  var _wstrDELIVERY_YN = "";
  var _wstrTABLE_YN = "";
  var _wstrFLOOR_YN = "";
  var _wstrHIDE_CLOSING_YN = "";

  get wstrHIDE_CLOSING_YN => _wstrHIDE_CLOSING_YN;

  set wstrHIDE_CLOSING_YN(value) {
    _wstrHIDE_CLOSING_YN = value;
  }

  get wstrDELIVERY_YN => _wstrDELIVERY_YN;

  set wstrDELIVERY_YN(value) {
    _wstrDELIVERY_YN = value;
  }

  get wstrSPLIT_YN => _wstrSPLIT_YN;

  set wstrSPLIT_YN(value) {
    _wstrSPLIT_YN = value;
  }

  get wstrLanguageList => _wstrLanguageList;

  set wstrLanguageList(value) {
    _wstrLanguageList = value;
  }

  get wstrLanguage => _wstrLanguage;

  set wstrLanguage(value) {
    _wstrLanguage = value;
  }

  get wstrBistroLng => _wstrBistroLng;

  set wstrBistroLng(value) {
    _wstrBistroLng = value;
  }

  get wstrQuickBillYN => _wstrQuickBillYN;

  set wstrQuickBillYN(value) {
    _wstrQuickBillYN = value;
  }

  get wstrUserBrnCode => _wstrUserBrnCode;

  set wstrUserBrnCode(value) {
    _wstrUserBrnCode = value;
  }

  get wstrPolDisplay => _wstrPolDisplay;

  set wstrPolDisplay(value) {
    _wstrPolDisplay = value;
  }

  get wstrTapDeviceId => _wstrTapDeviceId;

  set wstrTapDeviceId(value) {
    _wstrTapDeviceId = value;
  }

  get wstrAutoClockOutTime => _wstrAutoClockOutTime;

  set wstrAutoClockOutTime(value) {
    _wstrAutoClockOutTime = value;
  }

  get wstrRoomMode => _wstrRoomMode;

  set wstrRoomMode(value) {
    _wstrRoomMode = value;
  }

  get wstrRoomPriceList => _wstrRoomPriceList;

  set wstrRoomPriceList(value) {
    _wstrRoomPriceList = value;
  }

  get wstrDeliveryMode => _wstrDeliveryMode;

  set wstrDeliveryMode(value) {
    _wstrDeliveryMode = value;
  }

  get wstrRoomYN => _wstrRoomYN;

  set wstrRoomYN(value) {
    _wstrRoomYN = value;
  }

  get wstrDeviceIP => _wstrDeviceIP;

  set wstrDeviceIP(value) {
    _wstrDeviceIP = value;
  }

  get wstrContext => _wstrContext;

  set wstrContext(value) {
    _wstrContext = value;
  }

  get wstrDiscountGroup => _wstrDiscountGroup;

  set wstrDiscountGroup(value) {
    _wstrDiscountGroup = value;
  }

  get wstrMenuGroup => _wstrMenuGroup;

  set wstrMenuGroup(value) {
    _wstrMenuGroup = value;
  }

  get wstrIp => _wstrIp;

  set wstrIp(value) {
    _wstrIp = value;
  }

  get wstrPrinterPath => _wstrPrinterPath;

  set wstrPrinterPath(value) {
    _wstrPrinterPath = value;
  }

  get wstrPrinterCode => _wstrPrinterCode;

  set wstrPrinterCode(value) {
    _wstrPrinterCode = value;
  }

  get wstrOrderScreenMode => _wstrOrderScreenMode;

  set wstrOrderScreenMode(value) {
    _wstrOrderScreenMode = value;
  }

  get wstrToken => _wstrToken;

  set wstrToken(value) {
    _wstrToken = value;
  }

  get wstrDiscountYn => _wstrDiscountYn;

  set wstrDiscountYn(value) {
    _wstrDiscountYn = value;
  }

  get wstrSelectedkitchenDescp => _wstrSelectedkitchenDescp;

  set wstrSelectedkitchenDescp(value) {
    _wstrSelectedkitchenDescp = value;
  }

  get wstrSelectedkitchen => _wstrSelectedkitchen;

  set wstrSelectedkitchen(value) {
    _wstrSelectedkitchen = value;
  }

  get wstrDeivceId => _wstrDeivceId;

  get wstrShifDescp => _wstrShifDescp;

  set wstrShifDescp(value) {
    _wstrShifDescp = value;
  }

  set wstrDeivceId(value) {
    _wstrDeivceId = value;
  }

  get wstrDeviceName => _wstrDeviceName;


  set wstrDeviceName(value) {
    _wstrDeviceName = value;
  }

  get wstrShifNo => _wstrShifNo;

  set wstrShifNo(value) {
    _wstrShifNo = value;
  }



  get wstrGuestNo => _wstrGuestNo;

  set wstrGuestNo(value) {
    _wstrGuestNo = value;
  }

  get wstrCurrency => _wstrCurrency;

  set wstrCurrency(value) {
    _wstrCurrency = value;
  }

  get wstrLastSelectedAdd => _wstrLastSelectedAdd;

  set wstrLastSelectedAdd(value) {
    _wstrLastSelectedAdd = value;
  }

  get wstrOrderType => _wstrOrderType;

  set wstrOrderType(value) {
    _wstrOrderType = value;
  }

  get wstrLastSelectedKotDocType => _wstrLastSelectedKotDocType;

  set wstrLastSelectedKotDocType(value) {
    _wstrLastSelectedKotDocType = value;
  }

  get wstrLastSelectedKotDocno => _wstrLastSelectedKotDocno;

  set wstrLastSelectedKotDocno(value) {
    _wstrLastSelectedKotDocno = value;
  }

  get wstrLastSelectedKot => _wstrLastSelectedKot;

  set wstrLastSelectedKot(value) {
    _wstrLastSelectedKot = value;
  }


  get wstrOrderMode => _wstrOrderMode;

  set wstrOrderMode(value) {
    _wstrOrderMode = value;
  }

  get wstrTableUpdateMode => _wstrTableUpdateMode;

  set wstrTableUpdateMode(value) {
    _wstrTableUpdateMode = value;
  }

  get wstrLastSelectedTables => _wstrLastSelectedTables;

  set wstrLastSelectedTables(value) {
    _wstrLastSelectedTables = value;
  }

  get wstrLastMenuItems => _wstrLastMenuItems;

  set wstrLastMenuItems(value) {
    _wstrLastMenuItems = value;
  }

  get wstrMenuMode => _wstrMenuMode;

  set wstrMenuMode(value) {
    _wstrMenuMode = value;
  }

  get wstrTableView => _wstrTableView;

  set wstrTableView(value) {
    _wstrTableView = value;
  }

  set wstrRoleCode(value) {
    _wstrRoleCode = value;
  }

  set wstrUserName(value) {
    _wstrUserName = value;
  }

  set wstrUserCd(value) {
    _wstrUserCd = value;
  }

  set wstrYearcode(value) {
    _wstrYearcode = value;
  }

  set wstrCompany(value) {
    _wstrCompany = value;
  }

  get wstrCompany => _wstrCompany;

  get wstrYearcode => _wstrYearcode;

  get wstrUserCd => _wstrUserCd;

  get wstrUserName => _wstrUserName;

  get wstrRoleCode => _wstrRoleCode;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool fnValCheck(value){
    try{
      if(value == null){
        return false;
      }else{
        if(value.length > 0){
          return true;
        }else{
          return false;
        }
      }
    }catch(e){
      return false;
    }
  }

  fnGrep(array,code,value){
    if(array == null){

    }else{
      if(array.length > 0){

      }else{
      }
    }
  }

  fnStatus(sts){
     var msg;
     msg = sts  == 'P'? 'Pending' : sts  == 'R'? 'Preparing' : sts  == 'D'? 'Completed' : sts  == 'C'? 'Canceled' :  sts  == 'H'? 'Hold' : '';
     return msg;
  }
  fnStatusColor(sts){
    var msgColor;
    msgColor = sts  == 'P'? Colors.black : sts  == 'R'? Colors.amber : sts  == 'D'? Colors.green : sts  == 'C'? Colors.red :  sts  == 'H'? Colors.yellow : Colors.black;
    return msgColor;
  }


  mfnDbl(dbl){
    var lstrDbl = 0.0;

    try {
      lstrDbl =  double.parse((dbl??'0.0').toString());
    }
    catch(e){
      lstrDbl= 0.00;
    }
    return lstrDbl;
  }
  mfnInt(dbl){
    var lstrInt = 0;
    try {
      lstrInt =  int.parse((dbl??'0.0').toString());
    }
    catch(e){
      lstrInt= 0;
    }
    return lstrInt;
  }

  mfnJson(arr){
    var tempArray;
    if(fnValCheck(arr)){
      String tempString = jsonEncode(arr);
      tempArray  =  jsonDecode(tempString);
    }
    return tempArray;
  }

  get wstrCurrencyRate => _wstrCurrencyRate;

  set wstrCurrencyRate(value) {
    _wstrCurrencyRate = value;
  }

  get wstrClockInDate => _wstrClockInDate;

  set wstrClockInDate(value) {
    _wstrClockInDate = value;
  }

  get wstrSelectedInstructions => _wstrSelectedInstructions;

  set wstrSelectedInstructions(value) {
    _wstrSelectedInstructions = value;
  }

  get wstrPrinterName => _wstrPrinterName;

  set wstrPrinterName(value) {
    _wstrPrinterName = value;
  }

  get wstrDiscountType => _wstrDiscountType;

  set wstrDiscountType(value) {
    _wstrDiscountType = value;
  }

  get wstrDiscountMaxPerc => _wstrDiscountMaxPerc;

  set wstrDiscountMaxPerc(value) {
    _wstrDiscountMaxPerc = value;
  }

  mfnCurr(amount){
    var lstrDbl = 0.0;

    try {
      lstrDbl =  double.parse((amount??'0.0').toString());
    }
    catch(e){
      lstrDbl= 0.00;
    }
    var amt = NumberFormat.simpleCurrency(name:"").format(lstrDbl);
    return amt;

  }




  get wstrTapDeviceName => _wstrTapDeviceName;

  set wstrTapDeviceName(value) {
    _wstrTapDeviceName = value;
  }

  get wstrCompanyDet => _wstrCompanyDet;

  set wstrCompanyDet(value) {
    _wstrCompanyDet = value;
  }

  get wstrDirectPrintYn => _wstrDirectPrintYn;

  set wstrDirectPrintYn(value) {
    _wstrDirectPrintYn = value;
  }

  get wstrImgYn => _wstrImgYn;

  set wstrImgYn(value) {
    _wstrImgYn = value;
  }

  get wstrBaseUrl => _wstrBaseUrl;

  set wstrBaseUrl(value) {
    _wstrBaseUrl = value;
  }

  get wstrMERGE_YN => _wstrMERGE_YN;

  set wstrMERGE_YN(value) {
    _wstrMERGE_YN = value;
  }

  get wstrE86ITEM_YN => _wstrE86ITEM_YN;

  set wstrE86ITEM_YN(value) {
    _wstrE86ITEM_YN = value;
  }

  get wstrDINE_IN_YN => _wstrDINE_IN_YN;

  set wstrDINE_IN_YN(value) {
    _wstrDINE_IN_YN = value;
  }

  get wstrTAKEAWAY_YN => _wstrTAKEAWAY_YN;

  set wstrTAKEAWAY_YN(value) {
    _wstrTAKEAWAY_YN = value;
  }

  get wstrTABLE_YN => _wstrTABLE_YN;

  set wstrTABLE_YN(value) {
    _wstrTABLE_YN = value;
  }

  get wstrFLOOR_YN => _wstrFLOOR_YN;

  set wstrFLOOR_YN(value) {
    _wstrFLOOR_YN = value;
  }
}