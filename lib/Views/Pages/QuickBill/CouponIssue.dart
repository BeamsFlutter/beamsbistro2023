
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:oktoast/oktoast.dart';
import 'package:get/get.dart';

import '../../../Controllers/Global/globalValues.dart';
import '../../Components/lookup.dart';
import '../../Components/lookup_alert.dart';
import '../../Styles/colors.dart';

class CouponIssue extends StatefulWidget {
  const CouponIssue({Key? key}) : super(key: key);

  @override
  State<CouponIssue> createState() => _CouponIssueState();
}

class _CouponIssueState extends State<CouponIssue> {

  //Global
  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic> futureCouponIssue;


  TextEditingController txtCoupon = new TextEditingController();
  TextEditingController txtCouponDescp = new TextEditingController();
  TextEditingController txtCouponQty = new TextEditingController();
  var lstrCouponName = '';
  var lstrCouponItems = [];
  var lstrCouponIssue = [];
  var lstrCouponCombo = [];

  @override
  void initState() {
    // TODO: implement initState

    fnGetPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(35),
        height: size.height,
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(

              children: [
                GestureDetector(
                  child: Container(
                    child: Icon(Icons.arrow_back,size: 40,),
                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                ),
                gapWC(10),
                tcn('Coupon Generation', Colors.black, 25),
              ],
            ),
            gapHC(20),

            Expanded(
                child: Column(
                  children: [
                    Container(
                      
                      padding: EdgeInsets.all(10),
                      decoration: boxDecoration(Colors.white, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              RoundedInputField(
                                txtRadius:0,
                                txtWidth: 0.2,
                                hintText: 'Coupon',
                                labelYn: 'Y',
                                suffixIcon: Icons.search,
                                txtController: txtCoupon,
                                suffixIconOnclick: (){
                                  fnLookup("COUPON","S");
                                },
                              ),

                              gapWC(10),

                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  RoundedInputField(
                                    txtRadius:0,
                                    txtWidth: 0.4,
                                    enablests: false,
                                    hintText: 'Coupon Name',
                                    labelYn: 'Y',
                                    txtController: txtCouponDescp,
                                    suffixIcon: Icons.qr_code_sharp,
                                  ),
                                  gapWC(10),
                                  RoundedInputField(
                                    txtRadius:0,
                                    txtWidth: 0.2,
                                    hintText: 'Issue Count',
                                    labelYn: 'Y',
                                    txtController: txtCouponQty,
                                    suffixIcon: Icons.confirmation_number_outlined,
                                    textType: TextInputType.number,
                                    numberFormat :'Y',
                                    onChanged: (value){

                                    },

                                  ),
                                ],
                              ),
                              gapWC(10),
                              Bounce(
                                  child: Container(
                                    decoration: boxDecoration(Colors.green, 10),
                                    padding: EdgeInsets.all(10),
                                    width: 200,
                                    child: Center(
                                      child: tcn('COUPON ISSUE', Colors.white, 15),
                                    ),
                                  ), duration: Duration(milliseconds: 110),
                                  onPressed: (){
                                    fnCouponIssue();
                                  })
                            ],
                          )

                        ],),
                    ),
                    gapHC(10),
                    Expanded(child:
                    Container(
                      width: size.width,
                      decoration: boxDecoration(Colors.white, 5),
                      child: couponComboView(),
                    ))
                  ],
                )
            )
          ],
        ),
      ),
    );
  }

  //================================WIDGET===========================
  Widget couponComboView(){
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: lstrCouponCombo.length,
        itemBuilder: (context, index) {
          var dataList = lstrCouponCombo[index];
          var comboCode = dataList['GROUP'] ??'';
          var comboName  = 'OPTION '+ (index+1).toString();

          return GestureDetector(
            onTap: (){

            },
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 2),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){

                            },
                            child: th(comboName.toString(), PrimaryColor, 16),
                          ),

                        ],
                      )
                  ),
                  lineC(0.2, Colors.black),
                  gapHC(5),
                  Column(
                    children: _buildCouponItems(comboCode),
                  )

                ],
              ),

            ),
          );
        });
  }


  _buildCouponItems(group) {
    List<Widget> choices = [];
    var selectedData = g.mfnJson(lstrCouponItems);
    if(g.fnValCheck(selectedData)){
      selectedData.retainWhere((i){
        return i["GROUP"] == group ;
      });
      var srno =1;
      selectedData.forEach((e) {

        var qty = 0.0;

        var redeemQty = g.mfnDbl(e["REDEEMED_QTY"]);
        var blanceQty = g.mfnDbl(e["QTY"]) - g.mfnDbl(e["REDEEMED_QTY"]);

        choices.add(
            Bounce(
                child: Container(
                  padding: const EdgeInsets.only(top: 10,bottom: 5,left: 10,right: 10),
                  decoration: boxBaseDecoration(Colors.white, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            tc(srno.toString()+'. '+ (e["STKDESCP"]??'') + ' (@ '+e["PRICE"].toString() +'  QTY : '+e["QTY"].toString()+')' , Colors.black, 13),
                            gapHC(5),
                          ],
                        ),),
                      gapWC(10),
                    ],
                  ),
                ),
                duration: Duration(milliseconds: 110),
                onPressed: (){
                })
        );
        srno++;
      });
    }




    return choices;
  }


  //==========================Page Fn ==========================

  fnGetPageData(){
    setState(() {
      txtCouponQty.text = '1';
    });
  }

  //============================LOOKUP====================================

  fnLookup(mode,lookupMode) {
    if (mode == 'COUPON') {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Name'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {'sourceColumn': 'CODE','contextField': txtCoupon,'context': 'window'},
        {'sourceColumn': 'DESCP','contextField': txtCouponDescp,'context': 'window'},
      ];

      LookupAlert().showLookup(context, Lookup(
        txtControl: txtCoupon,
        oldValue: txtCoupon.text,
        lstrTable: 'RST_COUPON_MAST',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100000',
        lstrFilter: [],
        keyColumn: 'CODE',
        layoutName: "B",
        mode: lookupMode,
        callback: fnLookupCallBack,
      ), 'Coupon ');
    }

  }
  fnLookupCallBack(data){
    if(g.fnValCheck(data)){
      setState(() {
        lstrCouponName = data["DESCP"] ?? '';
      });
      fnGetCouponItems(data["CODE"]??'');
    }
  }
  //===========================api call=================================

  fnGetCouponItems(couponNo){
    if(couponNo == ''){
      return;
    }
    setState(() {
      lstrCouponItems = [];
      lstrCouponCombo = [];
      lstrCouponIssue = [];
    });
    futureCouponIssue = apiCall.getCouponDetItems(g.wstrCompany, couponNo);
    futureCouponIssue.then((value) => fnGetCouponItemsSuccess(value));
  }
  fnGetCouponItemsSuccess(value){
    print(value);
    if(g.fnValCheck(value)){
      print(value);
      setState(() {
         lstrCouponCombo = value["Table2"];
         lstrCouponIssue = value["Table1"];
         lstrCouponItems = value["Table3"];

      });
    }
  }


  fnCouponIssue(){
    if(txtCoupon.text.isEmpty){
      return;
    }
    if(g.mfnDbl(txtCouponQty.text) <= 0){
      return;
    }

    futureCouponIssue = apiCall.couponIssue(g.wstrCompany, g.wstrYearcode, txtCoupon.text, g.wstrUserCd, g.wstrDeivceId, g.wstrDeviceName, g.mfnInt(txtCouponQty.text),g.wstrPrinterPath);
    futureCouponIssue.then((value) => futureCouponIssueSuccess(value));
  }
  futureCouponIssueSuccess(value){
    if(g.fnValCheck(value)){
      // var msg  = value["MSG"];
      // var sts  = value["STATUS"];
      showToast( 'SUCCESS');
      Navigator.pop(context);
    }
  }
}
