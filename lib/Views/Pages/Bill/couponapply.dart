import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Coupon extends StatefulWidget {


  final Function fnCallBack;
  final Function fnCallChangeMode;

  const Coupon({Key? key,required this.fnCallBack, required this.fnCallChangeMode}) : super(key: key);

  @override
  _CouponState createState() => _CouponState();
}

class _CouponState extends State<Coupon> {

  late Future<dynamic> futureCoupon;
  Global g = Global();
  ApiCall apiCall = ApiCall();

  var numberSize = 50.0;
  TextEditingController txtCoupon = TextEditingController();

  var lstrToday = '';
  var lstrCouponPrefix = '';
  var lstrCouponSuffix = '';
  var lstrErrMsg = '';
  var formatDate=  DateFormat('dd-MM-yyyy');
  var formatDatePrefix=  DateFormat('ddMMyy');

  var maskFormatter ;

  @override
  void initState() {
    // TODO: implement initState

    var now = DateTime.now();
    lstrToday = formatDate.format(now);
    lstrCouponPrefix =  formatDatePrefix.format(now);
    lstrCouponSuffix ='/SPL';

    maskFormatter = new MaskTextInputFormatter(
        mask: '##-##-##',
        filter: { "#": RegExp(r'[0-9]') },
    );

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);



    return Container(
      padding: const EdgeInsets.only(left: 15.0,right: 15.0),
     //   height: size.height ,
       child: SingleChildScrollView(
          child: Column(
            children: [
              gapHC(20),
              tc('ENTER COUPON CODE', Colors.black, 18),
              tcn(lstrToday, Colors.black, 15),
              gapHC(10),
              tcn(lstrErrMsg.toString(), Colors.red, 10),
              gapHC(5),
              Row(
                children: [
                  Expanded(child: Container(
                    height: 40,
                    child: TextField(
                      obscureText: false,
                      enabled: false,
                      controller: txtCoupon,
                      inputFormatters: [maskFormatter],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'COUPON',
                        // prefixText: lstrCouponPrefix,
                        // suffixText: lstrCouponSuffix
                      ),
                      onChanged: (text){

                      },
                    ),
                  ),),
                  gapWC(10),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                      widget.fnCallChangeMode();
                    },
                    child: Container(
                      height: 40,
                      width: 80,
                      decoration: boxDecoration(Colors.blue, 10),
                      child: Center(
                        child:Icon(Icons.qr_code_outlined,color: Colors.white,),
                      ),
                    ),
                  )
                ],
              ),
              gapHC(20),
              Center(
                child: Container(
                /*  width: size.width,
                  height:  size.height,*/
                  margin: const EdgeInsets.only(left: 0.0,right: 0.0,top: 5.0,bottom: 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          numberPressMobile('1'),
                          gapWC(20),
                          numberPressMobile('2'),
                          gapWC(20),
                          numberPressMobile('3'),
                        ],
                      ),
                      gapHC(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          numberPressMobile('4'),
                          gapWC(20),
                          numberPressMobile('5'),
                          gapWC(20),
                          numberPressMobile('6'),
                        ],
                      ),
                      gapHC(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          numberPressMobile('7'),
                          gapWC(20),
                          numberPressMobile('8'),
                          gapWC(20),
                          numberPressMobile('9'),
                        ],
                      ),
                      gapHC(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 80,
                              height: 50,
                              decoration: boxDecoration(Colors.white,10),
                              child: Center(child: Icon(Icons.cancel,size: 25,color: Colors.red,)),
                            ),
                          ),
                          gapWC(20),

                          numberPressMobile('0'),
                          gapWC(20),
                          GestureDetector(
                            onTap: (){
                              fnRemove();
                            },
                            onLongPress: (){
                              setState(() {
                                txtCoupon.text = '';
                              });
                            },
                            child: Container(
                              width: 80,
                              height: 50,
                              decoration: boxDecoration(Colors.white,10),
                              child: Center(child: Icon(Icons.backspace,size: 25,color: Colors.black,)),
                            ),
                          ),

                        ],
                      ),
                      gapHC(10),
                    ],
                  ),
                ),
              ),
              Bounce(
                onPressed: (){
                  fnApply();
                },
                duration: Duration(milliseconds: 110),
                child: Container(
                  margin: const EdgeInsets.only(left: 0.0,right: 0.0,top: 15.0),
                  height: 50,
                  decoration: boxDecoration(Colors.green,05),
                  child: Center(child: tc('APPLY', Colors.white, 15)),
                ),
              ),



            ],
          ),
        ),

      );

  }


  Widget numberPressMobile(text) => Bounce(
    duration: Duration(milliseconds: 110),
    onPressed: (){
      fnEnterNumber(text);
    },
    child: Container(
      height: 50,
      width: 80,
      decoration: boxDecoration(Colors.amber, 10),
      child: Center(
        child: tc(text, Colors.black, 20),
      ),
    ),
  );


  fnEnterNumber(text){
   setState(() {
     if(txtCoupon.text.length  < 7){
       txtCoupon.text = txtCoupon.text+text;
     }
   });
  }

  fnRemove(){
    setState(() {
      if(txtCoupon.text.isNotEmpty){
        txtCoupon.text = txtCoupon.text.substring(0, txtCoupon.text.length - 1);
      }
    });
  }

  fnApply(){
    // Navigator.pop(context);
    // widget.fnCallBack();
    fnApplyCoupon();
  }


  //====================API CALL===========================================

  fnApplyCoupon(){
      setState(() {
        lstrErrMsg = '';
      });
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
