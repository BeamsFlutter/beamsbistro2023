import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/bottomNavigator.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/lookup.dart';
import 'package:beamsbistro/Views/Components/lookup_alert.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfieldMline.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import '../../../Controllers/Navigation/navigationController.dart';

class DishMast extends StatefulWidget {
  const DishMast({Key? key}) : super(key: key);

  @override
  _DishMast createState() => _DishMast();
}

class _DishMast extends State<DishMast> {
  //api
  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic> futureTable;

  //textController
  var txtCode = new TextEditingController();
  var txtDescp = new TextEditingController();
  var txtArDescp = new TextEditingController();
  var txtUnit = new TextEditingController();
  var txtDishGroup = new TextEditingController();
  var txtAcgroup = new TextEditingController();
  var txtTaxAcgroup = new TextEditingController();
  var txtKitchenCode = new TextEditingController();
  var txtWaitingTime = new TextEditingController();
  var txtCalorie = new TextEditingController();
  var txtFat = new TextEditingController();
  var txtProtein = new TextEditingController();
  var txtPrepration = new TextEditingController();
  var txtPrice = new TextEditingController();
  var txtMinQty = new TextEditingController();
  var txtMaxQty = new TextEditingController();
  var txtCouponCode = new TextEditingController();
  // var chkFav = new TextEditingController();
  // var chkTaxinc = new TextEditingController();
  // var chkNotAvailable = new TextEditingController();

  var txtDishGp1 = new TextEditingController();
  var txtDishGp2 = new TextEditingController();
  var txtDishGp3 = new TextEditingController();
  var txtDishGp4 = new TextEditingController();
  var txtDishGp5 = new TextEditingController();
  var txtDishGp6 = new TextEditingController();
  var txtDishGp7 = new TextEditingController();
  var txtDishGp8 = new TextEditingController();
  var txtDishGp9 = new TextEditingController();
  var txtDishGp10 = new TextEditingController();

  var txtAddonPrice = new TextEditingController();
  var txtComboQty = new TextEditingController();

  var txtAddonDish = new TextEditingController();
  var txtComboDish = new TextEditingController();
  //varaibles
  var wstrPageMode = '';
  var lstrPageDocno = '';

  var lstrActivetab = 0;
  var lstrArrAddon = [];
  var lstrArrCombo = [];
  var lstrchkFav = false;
  var lstrchkTaxinc = false;
  var lstrchkNotAvailable = false;
  var lstrAddonDishDescp = '';
  var lstrComboDishDescp = '';
  @override
  void initState() {
    // TODO: implement initState
    wstrPageMode = 'VIEW';
    lstrActivetab = 1;
    fnPageData('', 'LAST');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    g.wstrCompany = '01';
    Size size = MediaQuery.of(context).size;
    return pageMenuScreen1(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                wtabcard('Basic', 1),
                gapWC(3),
                wtabcard('Group', 2),
                gapWC(3),
                wtabcard('Addons & Combos', 3),
              ],
            ),
            Divider(),
            lstrActivetab == 1
                ? Flexible(
                    child: Container(
                    child: Row(children: [
                      Flexible(
                          flex: 49,
                          child: Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RoundedInputField(
                                labelYn: 'Y',
                                hintText: 'Code',
                                txtRadius: 5,
                                txtWidth: 1,
                                suffixIcon: wstrPageMode == 'VIEW'
                                    ? Icons.search
                                    : null,
                                txtController: txtCode,
                                suffixIconOnclick: () {
                                  wstrPageMode == 'VIEW'
                                      ? fnLookup('DISHMAST')
                                      : '';
                                },
                                onChanged: (value) {
                                  wstrPageMode == 'VIEW'
                                      ? fnLookup('DISHMAST')
                                      : '';
                                },
                                enablests:
                                    wstrPageMode == 'EDIT' ? false : true,
                              ),
                              RoundedInputField(
                                labelYn: 'Y',
                                hintText: 'Description',
                                txtRadius: 5,
                                txtWidth: 1,
                                txtController: txtDescp,
                                enablests:
                                    wstrPageMode == 'VIEW' ? false : true,
                              ),
                              RoundedInputField(
                                labelYn: 'Y',
                                hintText: 'Arabic Description',
                                txtRadius: 5,
                                txtWidth: 1,
                                txtController: txtArDescp,
                                enablests:
                                    wstrPageMode == 'VIEW' ? false : true,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 49,
                                    child: Column(
                                      children: [
                                        RoundedInputField(
                                          labelYn: 'Y',
                                          hintText: 'Unit',
                                          txtRadius: 5,
                                          txtWidth: 1,
                                          suffixIcon: wstrPageMode != 'VIEW'
                                              ? Icons.search
                                              : null,
                                          txtController: txtUnit,
                                          suffixIconOnclick: () {
                                            wstrPageMode != 'VIEW'
                                                ? fnLookup('UNIT')
                                                : '';
                                          },
                                          onChanged: (value) {
                                            wstrPageMode != 'VIEW'
                                                ? fnLookup('UNIT')
                                                : '';
                                          },
                                          enablests: wstrPageMode != 'VIEW'
                                              ? true
                                              : false,
                                        ),
                                      ],
                                    ),
                                  ),
                                  gapWC(2),
                                  Flexible(
                                    flex: 49,
                                    child: Column(
                                      children: [
                                        RoundedInputField(
                                          labelYn: 'Y',
                                          hintText: 'Dish Group',
                                          txtRadius: 5,
                                          txtWidth: 1,
                                          suffixIcon: wstrPageMode != 'VIEW'
                                              ? Icons.search
                                              : null,
                                          txtController: txtDishGroup,
                                          suffixIconOnclick: () {
                                            wstrPageMode != 'VIEW'
                                                ? fnLookup('DISHGROUP')
                                                : '';
                                          },
                                          onChanged: (value) {
                                            wstrPageMode != 'VIEW'
                                                ? fnLookup('DISHGROUP')
                                                : '';
                                          },
                                          enablests: wstrPageMode != 'VIEW'
                                              ? true
                                              : false,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 49,
                                    child: Column(
                                      children: [
                                        RoundedInputField(
                                          labelYn: 'Y',
                                          hintText: 'A/C group',
                                          txtRadius: 5,
                                          txtWidth: 1,
                                          suffixIcon: wstrPageMode != 'VIEW'
                                              ? Icons.search
                                              : null,
                                          txtController: txtAcgroup,
                                          suffixIconOnclick: () {
                                            wstrPageMode != 'VIEW'
                                                ? fnLookup('ACGROUP')
                                                : '';
                                          },
                                          onChanged: (value) {
                                            wstrPageMode != 'VIEW'
                                                ? fnLookup('ACGROUP')
                                                : '';
                                          },
                                          enablests: wstrPageMode != 'VIEW'
                                              ? true
                                              : false,
                                        ),
                                      ],
                                    ),
                                  ),
                                  gapWC(2),
                                  Flexible(
                                    flex: 49,
                                    child: Column(
                                      children: [
                                        RoundedInputField(
                                          labelYn: 'Y',
                                          hintText: 'Tax A/C Group',
                                          txtRadius: 5,
                                          txtWidth: 1,
                                          suffixIcon: wstrPageMode != 'VIEW'
                                              ? Icons.search
                                              : null,
                                          txtController: txtTaxAcgroup,
                                          suffixIconOnclick: () {
                                            wstrPageMode != 'VIEW'
                                                ? fnLookup('TAXACROUP')
                                                : '';
                                          },
                                          onChanged: (value) {
                                            wstrPageMode != 'VIEW'
                                                ? fnLookup('TAXACGROUP')
                                                : '';
                                          },
                                          enablests: wstrPageMode != 'VIEW'
                                              ? true
                                              : false,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 49,
                                    child: Column(
                                      children: [
                                        RoundedInputField(
                                          labelYn: 'Y',
                                          hintText: 'Price',
                                          textType: TextInputType.number,
                                          numberFormat: 'Y',
                                          txtRadius: 5,
                                          txtWidth: 1,
                                          txtController: txtPrice,
                                          enablests: wstrPageMode == 'VIEW'
                                              ? false
                                              : true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  gapWC(2),
                                  Flexible(
                                    flex: 49,
                                    child: Column(
                                      children: [
                                        RoundedInputField(
                                          labelYn: 'Y',
                                          hintText: 'Kitchen',
                                          txtRadius: 5,
                                          txtWidth: 1,
                                          suffixIcon: wstrPageMode != 'VIEW'
                                              ? Icons.search
                                              : null,
                                          txtController: txtKitchenCode,
                                          suffixIconOnclick: () {
                                            wstrPageMode != 'VIEW'
                                                ? fnLookup('KITCHEN')
                                                : '';
                                          },
                                          onChanged: (value) {
                                            wstrPageMode != 'VIEW'
                                                ? fnLookup('KITCHEN')
                                                : '';
                                          },
                                          enablests: wstrPageMode != 'VIEW'
                                              ? true
                                              : false,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ))),
                      gapW(),
                      Flexible(
                          flex: 49,
                          child: Container(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    flex: 49,
                                    child: Column(
                                      children: [
                                        RoundedInputField(
                                          labelYn: 'Y',
                                          hintText: 'Waiting Time',
                                          textType: TextInputType.number,
                                          numberFormat: 'Y',
                                          txtRadius: 5,
                                          txtWidth: 1,
                                          txtController: txtWaitingTime,
                                          enablests: wstrPageMode == 'VIEW'
                                              ? false
                                              : true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  gapWC(2),
                                  Flexible(
                                    flex: 49,
                                    child: Column(
                                      children: [
                                        RoundedInputField(
                                          labelYn: 'Y',
                                          hintText: 'Calorie',
                                          textType: TextInputType.number,
                                          numberFormat: 'Y',
                                          txtRadius: 5,
                                          txtWidth: 1,
                                          txtController: txtCalorie,
                                          enablests: wstrPageMode == 'VIEW'
                                              ? false
                                              : true,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 49,
                                    child: Column(
                                      children: [
                                        RoundedInputField(
                                          labelYn: 'Y',
                                          hintText: 'Fat',
                                          textType: TextInputType.number,
                                          numberFormat: 'Y',
                                          txtRadius: 5,
                                          txtWidth: 1,
                                          txtController: txtFat,
                                          enablests: wstrPageMode == 'VIEW'
                                              ? false
                                              : true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  gapWC(2),
                                  Flexible(
                                    flex: 49,
                                    child: Column(
                                      children: [
                                        RoundedInputField(
                                          labelYn: 'Y',
                                          hintText: 'Protein',
                                          textType: TextInputType.number,
                                          numberFormat: 'Y',
                                          txtRadius: 5,
                                          txtWidth: 1,
                                          txtController: txtProtein,
                                          enablests: wstrPageMode == 'VIEW'
                                              ? false
                                              : true,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              RoundedInputFieldMline(
                                labelYn: 'Y',
                                hintText: 'Preparation',
                                txtRadius: 5,
                                txtWidth: 1,
                                txtController: txtPrepration,
                                enablests:
                                    wstrPageMode == 'VIEW' ? false : true,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 49,
                                    child: Column(
                                      children: [
                                        RoundedInputField(
                                          labelYn: 'Y',
                                          hintText: 'Min Qty',
                                          textType: TextInputType.number,
                                          numberFormat: 'Y',
                                          txtRadius: 5,
                                          txtWidth: 1,
                                          txtController: txtMinQty,
                                          enablests: wstrPageMode == 'VIEW'
                                              ? false
                                              : true,
                                        ),
                                      ],
                                    ),
                                  ),
                                  gapWC(2),
                                  Flexible(
                                    flex: 49,
                                    child: Column(
                                      children: [
                                        RoundedInputField(
                                          labelYn: 'Y',
                                          hintText: 'Max Qty',
                                          textType: TextInputType.number,
                                          numberFormat: 'Y',
                                          txtRadius: 5,
                                          txtWidth: 1,
                                          txtController: txtMaxQty,
                                          enablests: wstrPageMode == 'VIEW'
                                              ? false
                                              : true,
                                        )
                                      ],
                                    ),
                                  ),
                                  gapWC(2),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    flex: 25,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('Favourite Items'),
                                            Checkbox(
                                                value: lstrchkFav,
                                                onChanged: (val) {
                                                  setState(() {
                                                    lstrchkFav = (wstrPageMode !=
                                                            'VIEW'
                                                        ? val
                                                                .toString()
                                                                .toLowerCase() ==
                                                            'true'
                                                        : lstrchkFav);
                                                  });
                                                }),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 25,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('Incluce Tax'),
                                            Checkbox(
                                                value: lstrchkTaxinc,
                                                onChanged: (val) {
                                                  setState(() {
                                                    lstrchkTaxinc =
                                                        (wstrPageMode != 'VIEW'
                                                            ? val
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                'true'
                                                            : lstrchkTaxinc);
                                                  });
                                                })
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    flex: 25,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text('Not Available'),
                                            Checkbox(
                                                value: lstrchkNotAvailable,
                                                onChanged: (val) {
                                                  setState(() {
                                                    lstrchkNotAvailable =
                                                        (wstrPageMode != 'VIEW'
                                                            ? val
                                                                    .toString()
                                                                    .toLowerCase() ==
                                                                'true'
                                                            : lstrchkNotAvailable);
                                                  });
                                                })
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          )))
                    ]),
                  ))
                : lstrActivetab == 2
                    ? Flexible(
                        child: Container(
                        child: Row(children: [
                          Flexible(
                              flex: 49,
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RoundedInputField(
                                    labelYn: 'Y',
                                    hintText: 'Dish Gp 1',
                                    txtRadius: 5,
                                    txtWidth: 1,
                                    suffixIcon: wstrPageMode != 'VIEW'
                                        ? Icons.search
                                        : null,
                                    txtController: txtDishGp1,
                                    suffixIconOnclick: () {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP1')
                                          : '';
                                    },
                                    onChanged: (value) {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP1')
                                          : '';
                                    },
                                    enablests:
                                        wstrPageMode != 'VIEW' ? true : false,
                                  ),
                                  RoundedInputField(
                                    labelYn: 'Y',
                                    hintText: 'Dish Gp 2',
                                    txtRadius: 5,
                                    txtWidth: 1,
                                    suffixIcon: wstrPageMode != 'VIEW'
                                        ? Icons.search
                                        : null,
                                    txtController: txtDishGp2,
                                    suffixIconOnclick: () {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP2')
                                          : '';
                                    },
                                    onChanged: (value) {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP2')
                                          : '';
                                    },
                                    enablests:
                                        wstrPageMode != 'VIEW' ? true : false,
                                  ),
                                  RoundedInputField(
                                    labelYn: 'Y',
                                    hintText: 'Dish Gp 3',
                                    txtRadius: 5,
                                    txtWidth: 1,
                                    suffixIcon: wstrPageMode != 'VIEW'
                                        ? Icons.search
                                        : null,
                                    txtController: txtDishGp3,
                                    suffixIconOnclick: () {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP3')
                                          : '';
                                    },
                                    onChanged: (value) {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP3')
                                          : '';
                                    },
                                    enablests:
                                        wstrPageMode != 'VIEW' ? true : false,
                                  ),
                                  RoundedInputField(
                                    labelYn: 'Y',
                                    hintText: 'Dish Gp 4',
                                    txtRadius: 5,
                                    txtWidth: 1,
                                    suffixIcon: wstrPageMode != 'VIEW'
                                        ? Icons.search
                                        : null,
                                    txtController: txtDishGp4,
                                    suffixIconOnclick: () {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP4')
                                          : '';
                                    },
                                    onChanged: (value) {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP4')
                                          : '';
                                    },
                                    enablests:
                                        wstrPageMode != 'VIEW' ? true : false,
                                  ),
                                  RoundedInputField(
                                    labelYn: 'Y',
                                    hintText: 'Dish Gp 5',
                                    txtRadius: 5,
                                    txtWidth: 1,
                                    suffixIcon: wstrPageMode != 'VIEW'
                                        ? Icons.search
                                        : null,
                                    txtController: txtDishGp5,
                                    suffixIconOnclick: () {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP5')
                                          : '';
                                    },
                                    onChanged: (value) {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP5')
                                          : '';
                                    },
                                    enablests:
                                        wstrPageMode != 'VIEW' ? true : false,
                                  ),
                                ],
                              ))),
                          gapW(),
                          Flexible(
                              flex: 49,
                              child: Container(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RoundedInputField(
                                    labelYn: 'Y',
                                    hintText: 'Dish Gp 6',
                                    txtRadius: 5,
                                    txtWidth: 1,
                                    suffixIcon: wstrPageMode != 'VIEW'
                                        ? Icons.search
                                        : null,
                                    txtController: txtDishGp6,
                                    suffixIconOnclick: () {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP6')
                                          : '';
                                    },
                                    onChanged: (value) {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP6')
                                          : '';
                                    },
                                    enablests:
                                        wstrPageMode != 'VIEW' ? true : false,
                                  ),
                                  RoundedInputField(
                                    labelYn: 'Y',
                                    hintText: 'Dish Gp 7',
                                    txtRadius: 5,
                                    txtWidth: 1,
                                    suffixIcon: wstrPageMode != 'VIEW'
                                        ? Icons.search
                                        : null,
                                    txtController: txtDishGp7,
                                    suffixIconOnclick: () {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP7')
                                          : '';
                                    },
                                    onChanged: (value) {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP7')
                                          : '';
                                    },
                                    enablests:
                                        wstrPageMode != 'VIEW' ? true : false,
                                  ),
                                  RoundedInputField(
                                    labelYn: 'Y',
                                    hintText: 'Dish Gp 8',
                                    txtRadius: 5,
                                    txtWidth: 1,
                                    suffixIcon: wstrPageMode != 'VIEW'
                                        ? Icons.search
                                        : null,
                                    txtController: txtDishGp8,
                                    suffixIconOnclick: () {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP8')
                                          : '';
                                    },
                                    onChanged: (value) {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP8')
                                          : '';
                                    },
                                    enablests:
                                        wstrPageMode != 'VIEW' ? true : false,
                                  ),
                                  RoundedInputField(
                                    labelYn: 'Y',
                                    hintText: 'Dish Gp 9',
                                    txtRadius: 5,
                                    txtWidth: 1,
                                    suffixIcon: wstrPageMode != 'VIEW'
                                        ? Icons.search
                                        : null,
                                    txtController: txtDishGp9,
                                    suffixIconOnclick: () {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP9')
                                          : '';
                                    },
                                    onChanged: (value) {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP9')
                                          : '';
                                    },
                                    enablests:
                                        wstrPageMode != 'VIEW' ? true : false,
                                  ),
                                  RoundedInputField(
                                    labelYn: 'Y',
                                    hintText: 'Dish Gp 10',
                                    txtRadius: 5,
                                    txtWidth: 1,
                                    suffixIcon: wstrPageMode != 'VIEW'
                                        ? Icons.search
                                        : null,
                                    txtController: txtDishGp10,
                                    suffixIconOnclick: () {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP10')
                                          : '';
                                    },
                                    onChanged: (value) {
                                      wstrPageMode != 'VIEW'
                                          ? fnLookup('DISHGP10')
                                          : '';
                                    },
                                    enablests:
                                        wstrPageMode != 'VIEW' ? true : false,
                                  ),
                                ],
                              )))
                        ]),
                      ))
                    : Flexible(
                        child: Container(
                        child: Row(children: [
                          Flexible(
                              flex: 49,
                              child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: Column(
                                    children: [
                                      Row(),
                                      tc('Addon', Colors.black, 19),
                                      Divider(),
                                      Row(
                                        children: [
                                          gapWC(3),
                                          RoundedInputField(
                                            labelYn: 'Y',
                                            hintText: 'Dish Code',
                                            txtRadius: 5,
                                            txtWidth: .2,
                                            suffixIcon: wstrPageMode != 'VIEW'
                                                ? Icons.search
                                                : null,
                                            txtController: txtAddonDish,
                                            suffixIconOnclick: () {
                                              wstrPageMode != 'VIEW'
                                                  ? fnLookup('ADDON')
                                                  : '';
                                            },
                                            onChanged: (value) {
                                              wstrPageMode != 'VIEW'
                                                  ? fnLookup('ADDON')
                                                  : '';
                                            },
                                            enablests: wstrPageMode != 'VIEW'
                                                ? true
                                                : false,
                                          ),
                                          gapWC(5),
                                          RoundedInputField(
                                            labelYn: 'Y',
                                            hintText: 'Price',
                                            textType: TextInputType.number,
                                            numberFormat: 'Y',
                                            txtRadius: 5,
                                            txtWidth: .15,
                                            txtController: txtAddonPrice,
                                            enablests: wstrPageMode == 'VIEW'
                                                ? false
                                                : true,
                                          ),
                                          gapWC(5),
                                          IconButton(
                                              color: wstrPageMode == 'VIEW'
                                                  ? Colors.grey
                                                  : blackBlue,
                                              onPressed: wstrPageMode == 'VIEW'
                                                  ? () {}
                                                  : () {
                                                      fnaddAddon();
                                                    },
                                              icon:
                                                  Icon(Icons.add_box_outlined))
                                        ],
                                      ),
                                      Divider(),
                                      Table(children: [
                                        TableRow(children: [
                                          Center(
                                            child: tc("CODE", Colors.black, 13),
                                          ),
                                          Center(
                                              child: tc(
                                                  "DESCP", Colors.black, 13)),
                                          Center(
                                            child:
                                                tc("PRICE", Colors.black, 13),
                                          ),
                                          Center(
                                            child: Text(""),
                                          )
                                        ])
                                      ]),
                                      Expanded(
                                          child: ListView.builder(
                                        itemCount: lstrArrAddon.length,
                                        itemBuilder: (context, index) {
                                          final item = lstrArrAddon;
                                          if (lstrArrAddon.length > 0) {
                                            return Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 3),
                                              padding: EdgeInsets.all(5),
                                              decoration: boxOutlineDecoration(
                                                  Colors.transparent, 1),
                                              child: Table(children: [
                                                TableRow(children: [
                                                  Center(
                                                    child: Text((item[index]
                                                                ['DISHCODE'] ??
                                                            "")
                                                        .toString()),
                                                  ),
                                                  Center(
                                                    child: Text((item[index]
                                                                ['DISHDESCP'] ??
                                                            "")
                                                        .toString()),
                                                  ),
                                                  Center(
                                                    child: Text((item[index]
                                                                ['PRICE'] ??
                                                            "")
                                                        .toString()),
                                                  ),
                                                  Center(
                                                    child: IconButton(
                                                        color: wstrPageMode ==
                                                                'VIEW'
                                                            ? Colors.grey
                                                            : blackBlue,
                                                        onPressed:
                                                            wstrPageMode ==
                                                                    'VIEW'
                                                                ? () {}
                                                                : () {
                                                                    setState(
                                                                        () {
                                                                      lstrArrAddon
                                                                          .removeAt(
                                                                              index);
                                                                    });
                                                                  },
                                                        icon:
                                                            Icon(Icons.delete)),
                                                  ),
                                                ])
                                              ]),
                                            );
                                          }
                                          else{
                                            return Container();
                                          }
                                        },
                                      ))
                                    ],
                                  ))),
                          gapW(),
                          Flexible(
                              flex: 49,
                              child: Container(
                                  decoration:
                                      BoxDecoration(border: Border.all()),
                                  child: Column(
                                    children: [
                                      Row(),
                                      tc('Combo', Colors.black, 19),
                                      Divider(),
                                      Row(
                                        children: [
                                          gapWC(3),
                                          RoundedInputField(
                                            labelYn: 'Y',
                                            hintText: 'Dish Code',
                                            txtRadius: 5,
                                            txtWidth: .2,
                                            suffixIcon: wstrPageMode != 'VIEW'
                                                ? Icons.search
                                                : null,
                                            txtController: txtComboDish,
                                            suffixIconOnclick: () {
                                              wstrPageMode != 'VIEW'
                                                  ? fnLookup('COMBO')
                                                  : '';
                                            },
                                            onChanged: (value) {
                                              wstrPageMode != 'VIEW'
                                                  ? fnLookup('COMBO')
                                                  : '';
                                            },
                                            enablests: wstrPageMode != 'VIEW'
                                                ? true
                                                : false,
                                          ),
                                          gapWC(5),
                                          RoundedInputField(
                                            labelYn: 'Y',
                                            hintText: 'Qty',
                                            textType: TextInputType.number,
                                            numberFormat: 'Y',
                                            txtRadius: 5,
                                            txtWidth: .15,
                                            txtController: txtComboQty,
                                            enablests: wstrPageMode == 'VIEW'
                                                ? false
                                                : true,
                                          ),
                                          gapWC(5),
                                          IconButton(
                                              padding:
                                                  EdgeInsets.only(bottom: 10),
                                              onPressed: wstrPageMode == 'VIEW'
                                                  ? () {}
                                                  : () {
                                                      fnaddCombo();
                                                    },
                                              icon: Icon(
                                                Icons.add_box_outlined,
                                                size: 24,
                                                color: wstrPageMode == 'VIEW'
                                                    ? Colors.grey
                                                    : blackBlue,
                                              )),
                                        ],
                                      ),
                                      Divider(),
                                      Table(children: [
                                        TableRow(children: [
                                          Center(
                                            child: tc("CODE", Colors.black, 13),
                                          ),
                                          Center(
                                              child: tc(
                                                  "DESCP", Colors.black, 13)),
                                          Center(
                                            child: tc("QTY", Colors.black, 13),
                                          ),
                                          Center(
                                            child: Text(""),
                                          )
                                        ])
                                      ]),
                                      Expanded(
                                          child: ListView.builder(
                                        itemCount: lstrArrCombo.length,
                                        itemBuilder: (context, index) {
                                          final item = lstrArrCombo;

                                            return Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 3),
                                              padding: EdgeInsets.all(5),
                                              decoration: boxOutlineDecoration(
                                                  Colors.transparent, 1),
                                              child: Table(children: [
                                                TableRow(children: [
                                                  Center(
                                                    child: Text((item[index]
                                                                ['DISHCODE'] ??
                                                            "")
                                                        .toString()),
                                                  ),
                                                  Center(
                                                    child: Text((item[index]
                                                                ['DISHDESCP'] ??
                                                            "")
                                                        .toString()),
                                                  ),
                                                  Center(
                                                    child: Text((item[index]
                                                                ['QTY'] ??
                                                            "")
                                                        .toString()),
                                                  ),
                                                  Center(
                                                    child: IconButton(
                                                        color: wstrPageMode ==
                                                                'VIEW'
                                                            ? Colors.grey
                                                            : blackBlue,
                                                        onPressed:
                                                            wstrPageMode ==
                                                                    'VIEW'
                                                                ? () {}
                                                                : () {
                                                                    setState(
                                                                        () {
                                                                      lstrArrCombo
                                                                          .removeAt(
                                                                              index);
                                                                    });
                                                                  },
                                                        icon:
                                                            Icon(Icons.delete)),
                                                  ),
                                                ])
                                              ]),
                                            );


                                        },
                                      ))
                                    ],
                                  )))
                        ]),
                      ))
          ],
        ),
        size,
        context,
        BottomNavigation(
            mode: wstrPageMode,
            fnAdd: fnAdd,
            fnEdit: fnEdit,
            fnCancel: fnCancel,
            fnPage: fnPage,
            fnSave: fnSave,
            fnDelete: fnDelete,
            fnSaveas: fnSaveas),
        fnBack);
  }

  //ButtonClicks
  fnAdd() {
    fnClear();

    setState(() {
      wstrPageMode = 'ADD';
      lstrActivetab = 1;
    });
  }

  fnSaveas() {
    setState(() {
      wstrPageMode = 'ADD';
      txtCode.clear();
      lstrPageDocno = '';
    });
  }

  fnClear() {
    txtCode.clear();
    txtDescp.clear();
    txtCode.clear();
    txtDescp.clear();
    txtArDescp.clear();
    txtUnit.clear();
    txtDishGroup.clear();
    txtAcgroup.clear();
    txtTaxAcgroup.clear();
    txtKitchenCode.clear();
    txtWaitingTime.clear();
    txtCalorie.clear();
    txtFat.clear();
    txtProtein.clear();
    txtPrepration.clear();
    txtPrice.clear();
    txtMinQty.clear();
    txtMaxQty.clear();
    txtCouponCode.clear();
    lstrchkFav = false;
    lstrchkNotAvailable = false;
    lstrchkTaxinc = false;

    txtDishGp1.clear();
    txtDishGp2.clear();
    txtDishGp3.clear();
    txtDishGp4.clear();
    txtDishGp5.clear();
    txtDishGp6.clear();
    txtDishGp7.clear();
    txtDishGp8.clear();
    txtDishGp9.clear();
    txtDishGp10.clear();
    txtAddonPrice.clear();
    txtComboQty.clear();
    txtComboDish.clear();
    txtAddonDish.clear();
    lstrAddonDishDescp = '';
    lstrComboDishDescp = '';
    lstrArrAddon = [];
    lstrArrCombo = [];
  }

  fnEdit() {
    setState(() {
      wstrPageMode = 'EDIT';
      //lstrActivetab = 1;
    });
  }

  fnCancel() {
    setState(() {
      fnClear();
      wstrPageMode = 'VIEW';
      fnPageData(lstrPageDocno, '');
    });
  }

  fnPage(mode) {
    switch (mode) {
      case 'FIRST':
        fnPageData('', mode);
        break;
      case 'LAST':
        fnPageData('', mode);
        break;
      case 'NEXT':
        fnPageData(lstrPageDocno, mode);
        break;
      case 'PREVIOUS':
        fnPageData(lstrPageDocno, mode);
        break;
    }
  }

  fnSave() {
    if (txtAcgroup.text.isEmpty) {
      showToast('Account Group Cannot be Empty');
      return;
    }
    if (txtDescp.text.isEmpty) {
      showToast('Descroption Cannot be Empty');
      return;
    }
    var data = {
      'MODE': wstrPageMode,
      'TABLE_RST_DISH': [
        {
          'COMPANY': g.wstrCompany,
          'DISHCODE': txtCode.text,
          'DISHDESCP': txtDescp.text,
          'UNIT': txtUnit.text,
          'FAT': txtFat.text == '' ? 0 : txtFat.text,
          'CALORIE': txtCalorie.text == '' ? 0 : txtCalorie.text,
          'TYPE': '',
          'MENUGROUP': txtDishGroup.text,
          'PARTIECODE': '',
          'PROTIEN': txtProtein.text == '' ? 0 : txtProtein.text,
          'WAITINGTIME': txtWaitingTime.text == '' ? 0 : txtWaitingTime.text,
          'PREPARATION': txtPrepration.text,
          'PICPATH': '',
          'SPANISH_DESCP': '',
          'ITALIAN_DESCP': '',
          'FRENCH_DESCP': '',
          'GERMAN_DESCP': '',
          'CHINESE_DESCP': '',
          'RUSSIAN_DESCP': '',
          'ARABIC_DESCP': txtArDescp.text,
          'JAPANESE_DESCP': '',
          'SCOTTISH_DESCP': '',
          'INGR_TYPE': '',
          'INGR_SUBTYPE': '',
          'GPCODE': txtAcgroup.text,
          'NOT_AVALIABLE_YN': (lstrchkNotAvailable ? 'Y' : 'N'),
          'TAXACGROUP': txtTaxAcgroup.text,
          'PRICE1': txtPrice.text,
          'COMBO_YN': (lstrArrCombo.length > 0 ? 'Y' : 'N'),
          'ADDON_YN': (lstrArrAddon.length > 0 ? 'Y' : 'N'),
          'DISHGP1': txtDishGp1.text,
          'DISHGP2': txtDishGp2.text,
          'DISHGP3': txtDishGp3.text,
          'DISHGP4': txtDishGp4.text,
          'DISHGP5': txtDishGp5.text,
          'DISHGP6': txtDishGp6.text,
          'DISHGP7': txtDishGp7.text,
          'DISHGP8': txtDishGp8.text,
          'DISHGP9': txtDishGp9.text,
          'DISHGP10': txtDishGp10.text,
          'KITCHENCODE': txtKitchenCode.text,
          'TAXINCLUDE_YN': (lstrchkTaxinc ? 'Y' : 'N'),
          'FAVOURITE_YN': (lstrchkFav ? 'Y' : 'N'),
          'ADDON_MIN_QTY': txtMinQty.text == '' ? 0 : txtMinQty.text,
          'ADDON_MAX_QTY': txtMaxQty.text == '' ? 0 : txtMaxQty.text,
          'COUPON_CODE': ''
        }
      ],
      'TABLE_RST_DISH_ADDON': lstrArrAddon,
      'TABLE_RST_DISH_COMMBO': lstrArrCombo,
      'USERCD': g.wstrUserCd
    };

    futureTable = apiCall.saveDish(data);
    futureTable.then((value) => fnSaveCallBack(value));
  }

  fnDelete() {
    PageDialog().deleteDialog(context, fnDeleteOk);
  }

  fnDeleteOk() {
    Navigator.pop(context);
    var data = {
      'COMPANY': g.wstrCompany,
      'DISHCODE': lstrPageDocno,
      'USERCD': g.wstrUserCd
    };
    futureTable = apiCall.DeleteDish(data);
    futureTable.then((value) => fnDeleteDishCallBack(value));
  }

  fnDeleteDishCallBack(value) {
    if (g.fnValCheck(value)) {
      var sts = value[0]['STATUS'];
      var msg = value[0]['MSG'];
      if (sts == '1') {
        setState(() {
          wstrPageMode = 'VIEW';
          lstrPageDocno = value[0]['CODE'];
        });
        showToast(msg);
        fnPageData(lstrPageDocno, 'NEXT');
      } else {
        showToast(msg);
      }
    }
  }

  fnSaveCallBack(value) {
    if (g.fnValCheck(value)) {
      var sts = value[0]['STATUS'];
      var msg = value[0]['MSG'];
      if (sts == '1') {
        setState(() {
          wstrPageMode = 'VIEW';
          lstrPageDocno = value[0]['CODE'];
        });
        showToast(msg);
        fnPageData(lstrPageDocno, '');
      } else {
        showToast(msg);
      }
    }
  }

  //viewapi
  fnPageData(docNo, mode) {
    futureTable = apiCall.viewDish(docNo, mode, g.wstrCompany);
    futureTable.then((value) => fnPageDataCallback(value));
  }

  fnPageDataCallback(value) {
    if (g.fnValCheck(value)) {
      var data = value;
      fnFillData(data);
    }
  }

  fnFillData(data) {
    lstrPageDocno = data["Table1"][0]['DISHCODE'];
    txtCode.text = data["Table1"][0]['DISHCODE'];

    txtDescp.text = (data["Table1"][0]['DISHDESCP'] ?? "").toString();
    txtArDescp.text = (data["Table1"][0]['ARABIC_DESCP'] ?? "").toString();
    txtUnit.text = (data["Table1"][0]['UNIT'] ?? "").toString();
    txtDishGroup.text = (data["Table1"][0]['MENUGROUP'] ?? "").toString();
    txtAcgroup.text = (data["Table1"][0]['GPCODE'] ?? "").toString();
    txtTaxAcgroup.text = (data["Table1"][0]['TAXACGROUP'] ?? "").toString();
    txtKitchenCode.text = (data["Table1"][0]['KITCHENCODE'] ?? "").toString();
    txtWaitingTime.text = (data["Table1"][0]['WAITINGTIME'] ?? "").toString();
    txtCalorie.text = (data["Table1"][0]['CALORIE'] ?? "").toString();
    txtFat.text = (data["Table1"][0]['FAT'] ?? "").toString();
    txtProtein.text = (data["Table1"][0]['PROTIEN'] ?? "").toString();
    txtPrepration.text = (data["Table1"][0]['PREPARATION'] ?? "").toString();
    txtPrice.text = (data["Table1"][0]['PRICE1'] ?? "").toString();
    txtMinQty.text = (data["Table1"][0]['ADDON_MIN_QTY'] ?? "").toString();
    txtMaxQty.text = (data["Table1"][0]['ADDON_MAX_QTY'] ?? "").toString();
    txtCouponCode.text = (data["Table1"][0]['COUPON_CODE'] ?? "").toString();
    // chkFav.text = (data["Table1"][0]['FAVOURITE_YN'] ?? "").toString();
    // chkTaxinc.text = (data["Table1"][0]['TAXINCLUDE_YN'] ?? "").toString();
    // chkNotAvailable.text =
    //     (data["Table1"][0]['NOT_AVALIABLE_YN'] ?? "").toString();

    txtDishGp1.text = (data["Table1"][0]['DISHGP1'] ?? "").toString();
    txtDishGp2.text = (data["Table1"][0]['DISHGP2'] ?? "").toString();
    txtDishGp3.text = (data["Table1"][0]['DISHGP3'] ?? "").toString();
    txtDishGp4.text = (data["Table1"][0]['DISHGP4'] ?? "").toString();
    txtDishGp5.text = (data["Table1"][0]['DISHGP5'] ?? "").toString();
    txtDishGp6.text = (data["Table1"][0]['DISHGP6'] ?? "").toString();
    txtDishGp7.text = (data["Table1"][0]['DISHGP7'] ?? "").toString();
    txtDishGp8.text = (data["Table1"][0]['DISHGP8'] ?? "").toString();
    txtDishGp9.text = (data["Table1"][0]['DISHGP9'] ?? "").toString();
    txtDishGp10.text = (data["Table1"][0]['DISHGP10'] ?? "").toString();
    lstrArrCombo = data["Table2"];
    lstrArrAddon = data["Table3"];
    setState(() {
      lstrchkFav =
          ((data["Table1"][0]['FAVOURITE_YN'] ?? "").toString() == 'Y');
      lstrchkTaxinc =
          ((data["Table1"][0]['TAXINCLUDE_YN'] ?? "").toString() == 'Y');
      lstrchkNotAvailable =
          ((data["Table1"][0]['NOT_AVALIABLE_YN'] ?? "").toString() == 'Y');
    });
  }

  //lookup
  fnLookup(mode) {
    if (mode == 'DISHMAST') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'DISHCODE', 'Display': 'Dish Code'},
        {'Column': 'DISHDESCP', 'Display': 'Dish Name'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'DISHCODE',
          'contextField': txtCode,
          'context': 'window'
        },
        {
          'sourceColumn': 'DISHDESCP',
          'contextField': txtDescp,
          'context': 'window'
        }
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtCode,
            oldValue: txtCode.text,
            lstrTable: 'DISHMAST',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'DISHCODE',
            layoutName: "B",
            callback: fnCallBack,
          ),
          'Choose Dish');
    }

    if (mode == 'UNIT') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {'sourceColumn': 'CODE', 'contextField': txtUnit, 'context': 'window'},
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtUnit,
            oldValue: txtUnit.text,
            lstrTable: 'UNITMAST',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Choose Dish');
    }

    if (mode == 'DISHGROUP') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtDishGroup,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtDishGroup,
            oldValue: txtDishGroup.text,
            lstrTable: 'DISHGROUPMAST',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Choose Dish Group');
    }

    if (mode == 'ACGROUP') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtAcgroup,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtAcgroup,
            oldValue: txtAcgroup.text,
            lstrTable: 'INVACGPMASTER',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Choose A/C Group');
    }

    if (mode == 'TAXACROUP') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtTaxAcgroup,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtTaxAcgroup,
            oldValue: txtTaxAcgroup.text,
            lstrTable: 'TAX_ACGROUP',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Choose Tax A/C Group');
    }

    if (mode == 'KITCHEN') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtKitchenCode,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtKitchenCode,
            oldValue: txtKitchenCode.text,
            lstrTable: 'KITCHENMAST',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Choose Kitchen');
    }

    if (mode == 'COUPON') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtCouponCode,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtCouponCode,
            oldValue: txtCouponCode.text,
            lstrTable: 'RST_COUPON_MAST',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Choose Coupon');
    }

    if (mode == 'DISHGP1') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtDishGp1,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtDishGp1,
            oldValue: txtDishGp1.text,
            lstrTable: 'RST_DISHGP1',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Dish Group 1');
    }

    if (mode == 'DISHGP2') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtDishGp2,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtDishGp2,
            oldValue: txtDishGp2.text,
            lstrTable: 'RST_DISHGP2',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Dish Group 2');
    }

    if (mode == 'DISHGP3') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtDishGp3,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtDishGp3,
            oldValue: txtDishGp3.text,
            lstrTable: 'RST_DISHGP3',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Dish Group 3');
    }

    if (mode == 'DISHGP4') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtDishGp4,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtDishGp4,
            oldValue: txtDishGp4.text,
            lstrTable: 'RST_DISHGP4',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Dish Group 4');
    }

    if (mode == 'DISHGP5') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtDishGp5,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtDishGp5,
            oldValue: txtDishGp5.text,
            lstrTable: 'RST_DISHGP5',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Dish Group 5');
    }

    if (mode == 'DISHGP6') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtDishGp6,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtDishGp6,
            oldValue: txtDishGp6.text,
            lstrTable: 'RST_DISHGP6',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Dish Group 6');
    }

    if (mode == 'DISHGP7') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtDishGp7,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtDishGp7,
            oldValue: txtDishGp7.text,
            lstrTable: 'RST_DISHGP7',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Dish Group 7');
    }

    if (mode == 'DISHGP8') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtDishGp8,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtDishGp8,
            oldValue: txtDishGp8.text,
            lstrTable: 'RST_DISHGP8',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Dish Group 8');
    }

    if (mode == 'DISHGP9') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtDishGp9,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtDishGp9,
            oldValue: txtDishGp9.text,
            lstrTable: 'RST_DISHGP9',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Dish Group 9');
    }

    if (mode == 'DISHGP10') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtDishGp10,
          'context': 'window'
        },
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtDishGp10,
            oldValue: txtDishGp10.text,
            lstrTable: 'RST_DISHGP10',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: (data) {},
          ),
          'Dish Group 10');
    }

    if (mode == 'ADDON') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'DISHCODE', 'Display': 'Dish Code'},
        {'Column': 'DISHDESCP', 'Display': 'Dish Name'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'DISHCODE',
          'contextField': txtAddonDish,
          'context': 'window'
        }
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtAddonDish,
            oldValue: txtAddonDish.text,
            lstrTable: 'DISHMAST',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'DISHCODE',
            layoutName: "B",
            callback: (data) {
              setState(() {
                lstrAddonDishDescp = data['DISHDESCP'];
              });
            },
          ),
          'Choose Dish');
    }
    if (mode == 'COMBO') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'DISHCODE', 'Display': 'Dish Code'},
        {'Column': 'DISHDESCP', 'Display': 'Dish Name'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'DISHCODE',
          'contextField': txtComboDish,
          'context': 'window'
        }
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtComboDish,
            oldValue: txtComboDish.text,
            lstrTable: 'DISHMAST',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'DISHCODE',
            layoutName: "B",
            callback: (data) {
              setState(() {
                lstrComboDishDescp = data['DISHDESCP'];
              });
            },
          ),
          'Choose Dish');
    }
  }

  fnCallBack(data) {
    setState(() {
      lstrPageDocno = data['DISHCODE'];
      fnPageData(lstrPageDocno, '');
    });
  }

  fnBack() {
    Navigator.pushReplacement(context, NavigationController().fnRoute(3));
  }

  fnaddCombo() {
    setState(() {
      {
        var qty = (txtComboQty.text == '' ? 0 : txtComboQty.text).toString();

        var combo = {
          'CODE': '',
          'DESCP': '',
          'DISHCODE': txtComboDish.text,
          'DISHDESCP': lstrComboDishDescp,
          'QTY': double.parse(qty)
        };
        var ListFiltered =
            lstrArrCombo.where((e) => e['DISHCODE'] == combo['DISHCODE']);
        if (ListFiltered.length > 0) {
          showToast('This Dish Code Is already added');
        } else {
          if (combo['DISHCODE'] != '' && double.parse(qty) > 0) {
            lstrArrCombo.add(combo);
            lstrComboDishDescp = '';
            txtComboDish.text = '';
            txtComboQty.text = '0';
          } else {
            showToast('Select Dish / Check QTY');
          }
        }
      }
    });
  }

  fnaddAddon() {
    setState(() {
      var price =
          (txtAddonPrice.text == '' ? 0 : txtAddonPrice.text).toString();
      var addon = {
        'CODE': '',
        'DESCP': '',
        'DISHCODE': txtAddonDish.text,
        'DISHDESCP': lstrAddonDishDescp,
        'PRICE': double.parse(price)
      };

      var ListFiltered =
          lstrArrAddon.where((e) => e['DISHCODE'] == addon['DISHCODE']);
      if (ListFiltered.length > 0) {
        showToast('This Dish Code Is already added');
      } else {
        if (addon['DISHCODE'] != '' && double.parse(price) >= 0) {
          lstrArrAddon.add(addon);
          lstrAddonDishDescp = '';
          txtAddonDish.text = '';
          txtAddonPrice.text = '0';
        } else {
          showToast('Select Dish / Check Price');
        }
      }
    });
  }

  Widget wtabcard(text, id) {
    return Flexible(
        flex: 10,
        child: GestureDetector(
          onTap: () {
            if (mounted) {
              setState(() {
                lstrActivetab = id;
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: lstrActivetab == id
                ? boxDecorationC(PrimaryColor, 10, 10, 0, 0)
                : boxDecorationC(Colors.white, 10, 10, 0, 0),
            child: tcn(
                text, lstrActivetab == id ? Colors.white : PrimaryColor, 15),
          ),
        ));
  }
}
