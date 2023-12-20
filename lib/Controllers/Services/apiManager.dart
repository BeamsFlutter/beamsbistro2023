
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/appExceptions.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ApiManager {
 // var baseUrl = "http://laptop-vi4dgus9:1103/"; //lap
//  var baseUrl = "http://192.168.0.103:1103/"; //lap
  //var baseUrl = "http://192.168.0.104:1106/"; //lap
  //var baseUrl = "http://POS3:1100/"; //Dubai Mall
  //var baseUrl = "http://localhost:19695/"; //lap
  //var baseUrl = "http://beamsdts-001-site2.atempurl.com/"; //demo
  //var baseUrl = "http://192.168.1.117:2200/"; //Splash New 09.12.2022
  //var baseUrl = "http://beamsprogrammer-002-site1.itempurl.com/"; //demo
  //var baseUrl = "http://192.168.0.190:1100/"; //wish
  //var baseUrl = "http://10.255.254.30:1100/"; //wishnew
  //var baseUrl = "http://192.168.1.205:1100/"; //splash Old
  //var baseUrl = "http://SHIHAS:1103/"; //Shihas
  //var baseUrl = "http://ead6-217-165-100-201.ngrok.io/"; //ngrok
  //var baseUrl = "http://192.168.1.252:1100/"; //Blooms ava
  //var baseUrl = "http://10.39.1.84:1100/"; //QASR
  //var baseUrl = "http://DESKTOP-A6IQ07D:1100/"; //CHINA
  //var baseUrl = "https://beams.hambana.co/"; //aLAIN

  //var baseUrl = "http://server:1100/"; //MANDI
  //var baseUrl = "http://10.255.254.100:1100/"; //MANDI IP

  var baseUrl = "http://localhost:19695/"; // HAKKEEM PC

  var company = Global().wstrCompany;
  var yearcode = Global().wstrYearcode;
  var token = Global().wstrToken;
  var wstrIp = Global().wstrIp;
  var wstrContext =  Global().wstrContext;

  Future<dynamic> get(String api) async {
    if(wstrIp != ""){
      baseUrl = wstrIp;
    }
    var uri = Uri.parse(baseUrl + api);
    try {
      var response = await http.get(uri);
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException('Server Connection Lost', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }
  }
  //POST
  Future<dynamic> post(String api, dynamic body) async {
    if(wstrIp != ""){
      baseUrl = wstrIp;
    }
    var uri = Uri.parse(baseUrl + api);
    var payload = body;
    print(uri);
    print(body);
    try {
      var response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'COMPANY' : company,
            'YEARCODE' : yearcode,
            'Authorization': 'Bearer $token'
          },
          body: payload);
      print(_processResponse(response));
      return _processResponse(response);
    } on SocketException {

      throw FetchDataException('Server Connection Lost', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }
  }
  Future<dynamic> postLink(String api) async {
    if(wstrIp != ""){
      baseUrl = wstrIp;
    }
    var uri = Uri.parse(baseUrl + api);
    print(uri);
    try {
      var response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'COMPANY' : company,
            'YEARCODE' : yearcode,
            'Authorization': 'Bearer $token'
          },);
      print(response);
      return _processResponse(response);

    } on SocketException {

      throw FetchDataException('Server Connection Lost', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }
  }
  Future<dynamic> postLoading(String api, dynamic body,var isLoad) async {

    if(isLoad =='S' && wstrContext!=null){
      PageDialog().fnShow(wstrContext);
    }

    if(wstrIp != ""){
      baseUrl = wstrIp;
    }
    var uri = Uri.parse(baseUrl + api);
    var payload = body;
    try {
      var response = await http.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'COMPANY' : company,
            'YEARCODE' : yearcode,
            'Authorization': 'Bearer $token'
          },
          body: payload);
      if(isLoad =='S' && wstrContext!=null){
        PageDialog().closeAlert(wstrContext);
      }
      return _processResponse(response);
    } on SocketException {
      if(isLoad =='S' && wstrContext!=null){
        PageDialog().closeAlert(wstrContext);
      }
      throw FetchDataException('Server Connection Lost', uri.toString());
    } on TimeoutException {
      if(isLoad =='S' && wstrContext!=null){
        PageDialog().closeAlert(wstrContext);
      }
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }

  }
  Future<dynamic> mfnGetToken() async{
    if(wstrIp != ""){
      baseUrl = wstrIp;
    }
    Map<String, dynamic> body = {
      'userName': 'user@beamserp.com',
      'Password': '123456',
      'grant_type': 'password'
    };
    var uri = Uri.parse(baseUrl+'/token');
    try {
      var response = await http.post(
          uri,
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Access-Control-Allow-Origin": "*", // Required for CORS support to work
            "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
            "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods": "POST, OPTIONS"
          },
          body: body,
          encoding: Encoding.getByName("utf-8")
      );
      return _processResponse(response);
    } on SocketException {

      throw FetchDataException('Server Connection Lost', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }

  }
  Future<dynamic> mfnGetTokenTest(baseUrlIP) async{

    Map<String, dynamic> body = {
      'userName': 'user@beamserp.com',
      'Password': '123456',
      'grant_type': 'password'
    };
    var uri = Uri.parse(baseUrlIP+'/token');
    try {
      var response = await http.post(
          uri,
          headers: <String, String>{
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded",
            "Access-Control-Allow-Origin": "*", // Required for CORS support to work
            "Access-Control-Allow-Credentials": 'true', // Required for cookies, authorization headers with HTTPS
            "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods": "POST, OPTIONS"
          },
          body: body,
          encoding: Encoding.getByName("utf-8")
      );
      return _processResponse(response);
    } on SocketException {

      throw FetchDataException('Server Connection Lost', uri.toString());
    } on TimeoutException {
      throw ApiNotRespondingException('API not responded in time', uri.toString());
    }

  }


  //==========================================================================NOTIFICATION

  sendNotificationToUser(token,docno,doctype,expDate,date,amount) async {
    //Our API Key
    //var serverKey = "AAAAW1HFjuI:APA91bGgZJ2r5MFWozacZmoz4t9L7wLmQtN-ah6xXjKmEXnAZWaiVFw58h_2a4fr3zM0Zqgr88Fwh2fLLHN7A7N2Ng1UFlH9By2GCj5RvMxhwXxoPFI9n1h1BnR-UOkZx4miX7xkR4vI";
    var serverKey = "AAAAH-4Qwxg:APA91bHfqMcAkE-56AuQDmVaTM66wsfLpYZ7gQVp3fAE5vxchZ5BSQ_Eb8O_R7niGroJRiGCR3rpbxAhVukePSzSZOaAbVWUKAbw-1VXLcaQ1EEskp0y0qi1Qm3-JdM6Bhy82X8eCKWY";

    //Create Message with Notification Payload
    String constructFCMPayload(String token) {
      var exp  = "";
      try{
        exp = setDate(1, DateTime.parse(expDate));
      }catch(e){
        exp = "";
      }
      return jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': "Click & Pay",
            'title':amount,
          },
          'data': <String, dynamic>{
            'DATE': setDate(1, date),
            'EXP_DATE': exp,
            'DOCNO': docno,
            'DOCTYPE': doctype,
            'AMOUNT':amount,
          },
          'to': token
        },
      );
    }

    if (token.isEmpty) {
      return log('Unable to send FCM message, no token exists.');
    }

    try {
      //Send  Message
      http.Response response =
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'key=$serverKey',
          },
          body: constructFCMPayload(token));

      log("status: ${response.statusCode} | Message Sent Successfully!");
    } catch (e) {
      log("error push notification $e");
    }
  }
  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = jsonDecode(response.body);
        return responseJson;
        break;
      case 201:
        var responseJson = jsonDecode(response.body);
        return responseJson;
        break;
      case 204:
        var responseJson = jsonDecode(response.body);
        return responseJson;
        break;
      case 400:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 401:
        throw UnAuthorizedException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 403:
        throw UnAuthorizedException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 422:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      case 500:
        throw BadRequestException(utf8.decode(response.bodyBytes), response.request!.url.toString());
      default:
        throw FetchDataException('BE100', response.request!.url.toString());
    }
  }

  //==========================================================================IMAGE

  Future<File> getFileFromUrl(String url, {name}) async {
    var fileName = 'testonline';
    if (name != null) {
      fileName = name;
    }
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File("${dir.path}/" + fileName + ".pdf");
      print(dir.path);
      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

}