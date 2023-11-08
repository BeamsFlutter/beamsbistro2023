import 'dart:developer';
import 'dart:io';

import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../Controllers/Global/globalValues.dart';
import '../../../Controllers/Services/apiController.dart';
import '../../Components/common.dart';

class QrScanning extends StatefulWidget {

  final Function fnCallBack;
  final Function fnCallChangeMode;
  const QrScanning({Key? key,required this.fnCallBack, required this.fnCallChangeMode}) : super(key: key);

  @override
  _QrScanningState createState() => _QrScanningState();
}

class _QrScanningState extends State<QrScanning> {

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  TextEditingController txtCoupon = TextEditingController();
  Global g = Global();
  ApiCall apiCall = ApiCall();
  var lstrErrMsg = '';
  late Future<dynamic> futureCoupon;




  @override
  void initState() {
    super.initState();
    txtCoupon.addListener(() {
      final String text = txtCoupon.text.toLowerCase();
      print('CHANGED*****************************************************************************$text');
      fnApplyCoupon();
    });

  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }else{
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);

    return Container(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
      //   height: size.height ,
      child: SingleChildScrollView(
        child: Column(
          children: [
            gapHC(15),
            tc('SCAN COUPON CODE', Colors.black, 18),
            gapHC(10),
            Container(
              height: 300,
              width: 300,
              child: _buildQrView(context),
            ),
            // result != null ?
            // th(result!.code.toString(), Colors.black, 18):gapHC(0),
            gapHC(10),
            tcn(lstrErrMsg.toString(), Colors.red, 10),
            gapHC(5),
            Container(
              height: 40,
              child: TextField(
                readOnly: true,
                autofocus: true,
                controller: txtCoupon,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'COUPON',
                  // prefixText: lstrCouponPrefix,
                  // suffixText: lstrCouponSuffix
                ),
                onChanged: (text) {

                },
              ),
            ),
            gapHC(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Bounce(
                    child: Container(
                      height: 40,
                      width: 100,
                      padding: EdgeInsets.only(left: 10,right: 10),
                      decoration: boxBaseDecoration( greyLight, 5),
                      child: Center(child: Icon(Icons.cancel,size: 25,color: Colors.red,)),
                    ),
                    duration: Duration(milliseconds: 110),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                gapWC(5),
                Bounce(
                    child: Container(
                      height: 40,
                      width: 100,
                      decoration: boxBaseDecoration( Colors.amber, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.flip_camera_ios,size: 20,)
                        ],
                      ),
                    ),
                    duration: Duration(milliseconds: 110),
                    onPressed: () async{
                      await controller?.flipCamera();
                      setState(() {});
                    }),
                gapWC(5),
               Expanded(child: Bounce(
                   child: Container(
                     height: 40,
                     width: 100,
                     decoration: boxBaseDecoration( Colors.amber, 5),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         tc('123', Colors.black, 15)
                       ],
                     ),
                   ),
                   duration: Duration(milliseconds: 110),
                   onPressed: () async{
                     Navigator.pop(context);
                     widget.fnCallChangeMode();
                   }),)
              ],
            )

          ],
        ),
      ),

    );
  }

  //====================WIDGET UI===========================================

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = 250.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      cameraFacing: CameraFacing.front,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );


  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      controller.resumeCamera();

    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        txtCoupon.text = result!.code.toString();

      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }



  //====================API CALL===========================================

  fnApplyCoupon(){
    setState(() {
      lstrErrMsg = '';
    });
    if(txtCoupon.text.isEmpty){
      return false;
    }
    if(txtCoupon.text.length < 5){
      setState(() {
        lstrErrMsg ='Please enter valid coupon no!';
      });
      return false;
    }
    futureCoupon = apiCall.checkCouponValidity(g.wstrCompany, txtCoupon.text);
    futureCoupon.then((value) => fnApplyCouponSuccess(value));

  }
  fnApplyCouponSuccess(value){
    if(g.fnValCheck(value)){
      print(value);
      var sts = value[0]['STATUS'].toString();
      var msg = value[0]['MSG'];

      if(sts == '1'){
        Navigator.pop(context);
        widget.fnCallBack(txtCoupon.text);
      }else{
        setState(() {
          lstrErrMsg =msg??'Please enter valid coupon no!';
        });
      }
    }

  }


}
