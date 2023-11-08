import 'dart:io';
import 'dart:typed_data';

import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/form_inputfield.dart';
import 'package:beamsbistro/Views/Components/lookup.dart';
import 'package:beamsbistro/Views/Components/lookup_alert.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:beamsbistro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class kitchenPrintes extends StatefulWidget {
  const kitchenPrintes({Key? key}) : super(key: key);

  @override
  State<kitchenPrintes> createState() => _kitchenPrintes();
}

class _kitchenPrintes extends State<kitchenPrintes> {
  //Global
  Global g = Global();
  ApiCall apiCall = ApiCall();

  late Future<dynamic> futureForm;
  late Future<dynamic> futureView;
  late Future<dynamic> futureAttachment;

  //Page Head Variable
  var wstrPageMode = "VIEW";
  var wstrPageForm = [];
  final _formKey = GlobalKey<FormState>();
  var lstrSearchResult = [];

  //Page Save Data
  var lstrDocCode = "";
  var lstrStatus = false;

  //Page Local Variable
  var lstrDocument = [];
  var lstrRemoveAttachment;

  //Controller
  var txtSearch = TextEditingController();
  var txtCode = TextEditingController();
  var txtDescp = TextEditingController();
  var txtKitCode = TextEditingController();
  var txtFloor = TextEditingController();
  var txtPrintCode = TextEditingController();

  var pagefocusNode = FocusNode();
  var pnCode = FocusNode();
  var pnDescp = FocusNode();
  var pnKitcode = FocusNode();

  var pnFloor = FocusNode();
  var pnPrintCode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    pagefocusNode.requestFocus();
    fnGetPageData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    txtSearch.dispose();
    txtCode.dispose();
    txtDescp.dispose();
    txtKitCode.dispose();

    pagefocusNode.dispose();
    pnCode.dispose();
    pnDescp.dispose();
    pnKitcode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Focus(
      autofocus: true,
      focusNode: pagefocusNode,
      onFocusChange: (hasFocus) {
        if (!hasFocus) {
          pagefocusNode.requestFocus();
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: boxBaseDecoration(blueLight, 10),
        child: Row(
          children: [
            Flexible(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: boxBaseDecoration(Colors.white, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(),
                      th('Kitchen Printers', PrimaryColor, 17),
                      gapHC(5),
                      lineC(1.0, greyLight),
                      gapHC(10),
                      Container(
                        height: 45,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: boxBaseDecoration(greyLight, 5),
                        child: TextFormField(
                          controller: txtSearch,
                          decoration: const InputDecoration(
                              hintText: 'Search',
                              border: InputBorder.none,
                              suffixIcon:
                                  Icon(Icons.search, color: PrimaryColor)),
                          onChanged: (value) {
                            apiSearchArea();
                          },
                        ),
                      ),
                      gapHC(10),
                      Expanded(child: viewSearchResult())
                    ],
                  ),
                )),
            gapWC(10),
            Flexible(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: boxBaseDecoration(Colors.white, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: boxBaseDecoration(blueLight, 5),
                        child: Row(
                          children: [
                            Expanded(child: masterMenu(fnMenu, wstrPageMode))
                          ],
                        ),
                      ),
                      gapHC(20),
                      Expanded(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormInput(
                                txtController: txtCode,
                                hintText: "Code",
                                focusNode: pnCode,
                                txtWidth: 0.2,
                                enablests: wstrPageMode == "ADD" ? true : false,
                                emptySts: txtCode.text.isEmpty ? false : true,
                                onClear: () {
                                  setState(() {
                                    txtCode.clear();
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                validate: true,
                              ),
                              FormInput(
                                txtController: txtDescp,
                                hintText: "Description",
                                focusNode: pnDescp,
                                txtWidth: 0.2,
                                enablests:
                                    wstrPageMode != "VIEW" ? true : false,
                                emptySts: txtDescp.text.isEmpty ? false : true,
                                onClear: () {
                                  setState(() {
                                    txtDescp.clear();
                                  });
                                },
                                onChanged: (value) {
                                  setState(() {});
                                },
                                validate: true,
                              ),
                              FormInput(
                                txtController: txtKitCode,
                                hintText: "Kitchen Code",
                                focusNode: pnKitcode,
                                txtWidth: 0.2,
                                enablests:
                                    wstrPageMode != "VIEW" ? true : false,
                                emptySts:
                                    txtKitCode.text.isEmpty ? false : true,
                                onClear: () {
                                  setState(() {
                                    txtKitCode.clear();
                                  });
                                },
                                suffixIcon: wstrPageMode != 'VIEW'
                                    ? Icons.search
                                    : null,
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
                                validate: true,
                              ),
                              FormInput(
                                txtController: txtFloor,
                                hintText: "Floor",
                                focusNode: pnFloor,
                                txtWidth: 0.2,
                                enablests:
                                    wstrPageMode != "VIEW" ? true : false,
                                emptySts: txtFloor.text.isEmpty ? false : true,
                                onClear: () {
                                  setState(() {
                                    txtFloor.clear();
                                  });
                                },
                                suffixIcon: wstrPageMode != 'VIEW'
                                    ? Icons.search
                                    : null,
                                suffixIconOnclick: () {
                                  wstrPageMode != 'VIEW'
                                      ? fnLookup('FLOOR')
                                      : '';
                                },
                                onChanged: (value) {
                                  wstrPageMode != 'VIEW'
                                      ? fnLookup('FLOOR')
                                      : '';
                                },
                                validate: true,
                              ),
                              FormInput(
                                txtController: txtPrintCode,
                                hintText: "Printer",
                                focusNode: pnPrintCode,
                                txtWidth: 0.2,
                                enablests:
                                    wstrPageMode != "VIEW" ? true : false,
                                emptySts:
                                    txtPrintCode.text.isEmpty ? false : true,
                                onClear: () {
                                  setState(() {
                                    txtPrintCode.clear();
                                  });
                                },
                                suffixIcon: wstrPageMode != 'VIEW'
                                    ? Icons.search
                                    : null,
                                suffixIconOnclick: () {
                                  wstrPageMode != 'VIEW'
                                      ? fnLookup('PRINTMAST')
                                      : '';
                                },
                                onChanged: (value) {
                                  wstrPageMode != 'VIEW'
                                      ? fnLookup('PRINTMAST')
                                      : '';
                                },
                                validate: true,
                              ),
                              gapHC(10),
                            ],
                          ),
                        ),
                      ),
                      wstrPageMode == "ADD" || wstrPageMode == "EDIT"
                          ? Container(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Bounce(
                                    onPressed: () {
                                      fnCancel();
                                    },
                                    duration: Duration(milliseconds: 110),
                                    child: closeButton(),
                                  ),
                                  gapWC(10),
                                  Bounce(
                                    onPressed: () {
                                      fnSave();
                                    },
                                    duration: Duration(milliseconds: 110),
                                    child: saveButton(),
                                  ),
                                ],
                              ),
                            )
                          : gapHC(0)
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }

//=======================================================WIDGET.

  Widget viewSearchResult() {
    return ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: lstrSearchResult.length,
            itemBuilder: (context, index) {
              var dataList = lstrSearchResult[index];
              var code = dataList["CODE"] ?? "";
              var descp = dataList["DESCP"] ?? "";

              return Bounce(
                onPressed: () {
                  apiViewKitchenPrinter(code, "");
                },
                duration: const Duration(milliseconds: 110),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: boxBaseDecoration(Colors.white, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      th(code.toString(), Colors.black, 12),
                      Row(
                        children: [
                          const Icon(
                            Icons.info,
                            color: PrimaryColor,
                            size: 15,
                          ),
                          gapWC(10),
                          Expanded(
                            child: tcn(descp.toString(), Colors.black, 12),
                          )
                        ],
                      ),
                      gapHC(5),
                      lineC(1.0, greyLight),
                      gapHC(5),
                    ],
                  ),
                ),
              );
            }));
  }

//=======================================================PAGEFN

  fnGetPageData() {
    setState(() {
      wstrPageForm = [];
      wstrPageForm.add({
        "CONTROLLER": txtCode,
        "TYPE": "S",
        "VALIDATE": true,
        "ERROR_MSG": "Please fill CODE.",
        "FILL_CODE": "CODE",
        "PAGE_NODE": pnCode
      });
      wstrPageForm.add({
        "CONTROLLER": txtDescp,
        "TYPE": "S",
        "VALIDATE": true,
        "ERROR_MSG": "Please fill description",
        "FILL_CODE": "DESCP",
        "PAGE_NODE": pnDescp
      });
      wstrPageForm.add({
        "CONTROLLER": txtKitCode,
        "TYPE": "S",
        "VALIDATE": true,
        "ERROR_MSG": "Please Select Kitchen ",
        "FILL_CODE": "KITCHEN_CODE",
        "PAGE_NODE": pnKitcode
      });
      wstrPageForm.add({
        "CONTROLLER": txtFloor,
        "TYPE": "S",
        "VALIDATE": true,
        "ERROR_MSG": "Please Select Floor ",
        "FILL_CODE": "FLOOR",
        "PAGE_NODE": pnFloor
      });

      wstrPageForm.add({
        "CONTROLLER": txtPrintCode,
        "TYPE": "S",
        "VALIDATE": true,
        "ERROR_MSG": "Please Select Printer ",
        "FILL_CODE": "PRINTER_CODE",
        "PAGE_NODE": pnPrintCode
      });
    });
    apiSearchArea();
    apiViewKitchenPrinter("", "LAST");
  }

  fnClear() {
    if (mounted) {
      setState(() {
        for (var e in wstrPageForm) {
          e["CONTROLLER"].clear();
        }
        lstrDocCode = "";
        lstrStatus = true;
        lstrDocument = [];
      });
    }
  }

  fnFill(data) {
    fnClear();
    if (data != null) {
      if (mounted) {
        setState(() {
          wstrPageMode = "VIEW";
          for (var e in wstrPageForm) {
            e["CONTROLLER"].text = (data[e["FILL_CODE"]] ?? "").toString();
          }
        });
      }
    }

    apiSearchArea();
  }

  fnStatusChange(value) {
    if (wstrPageMode == "EDIT") {
      setState(() {
        lstrStatus = value;
      });
    }
  }

//=======================================================MENU

  fnMenu(mode) {
    switch (mode) {
      case "ADD":
        {
          fnAdd();
        }
        break;
      case "SAVE":
        {
          fnSave();
        }
        break;
      case "EDIT":
        {
          fnEdit();
        }
        break;
      case "DELETE":
        {
          fnDelete();
        }
        break;
      case "FIRST":
        {
          fnView("", "FIRST");
        }
        break;
      case "NEXT":
        {
          fnView(txtCode.text, "NEXT");
        }
        break;
      case "LAST":
        {
          fnView("", "LAST");
        }
        break;
      case "BACK":
        {
          fnView(txtCode.text, "PREVIOUS");
        }
        break;
      case "ATTACH":
        {}
        break;
      case "LOG":
        {
          fnLog();
        }
        break;
      case "HELP":
        {}
        break;
      case "CLOSE":
        {
          fnCancel();
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
  }

  fnAdd() {
    setState(() {
      wstrPageMode = "ADD";
    });
    fnClear();
    pnCode.requestFocus();
  }

  fnEdit() {
    setState(() {
      wstrPageMode = "EDIT";
    });
  }

  fnCancel() {
    fnClear();
    setState(() {
      wstrPageMode = "VIEW";
    });
    apiViewKitchenPrinter("", "LAST");
  }

  fnView(code, mode) {
    if (wstrPageMode == "VIEW") {
      apiViewKitchenPrinter(code, mode);
    }
  }

  fnSave() {
    if (wstrPageMode == "VIEW") {
      return;
    }

    var saveSts = true;
    for (var e in wstrPageForm) {
      var validate = e["VALIDATE"];
      if (validate) {
        if (e["CONTROLLER"].text == null || e["CONTROLLER"].text == "") {
          errorMsg(context, e["ERROR_MSG"].toString());
          saveSts = false;
          e["PAGE_NODE"].requestFocus();
          return;
        }
      }
    }

    if (!saveSts) {
      return;
    }

    apiSaveKitchenPrinter();
  }

  fnDelete() {
    if (wstrPageMode != "VIEW" || txtCode.text.isEmpty) {
      infoMsg(context, "No area selected");
      return;
    }
    PageDialog().deleteDialog(context, apiDeleteKitchenPrinter);
  }

  fnLog() {}
//lookup
  fnLookup(mode) {
    if (mode == 'PRINTMAST') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'NAME', 'Display': 'Name'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtPrintCode,
          'context': 'window'
        }
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtPrintCode,
            oldValue: txtPrintCode.text,
            lstrTable: 'RST_PRINTMAST',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: fnCallBack,
          ),
          'Choose Printer');
    }
    if (mode == 'KITCHEN') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'Descp', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtKitCode,
          'context': 'window'
        }
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtKitCode,
            oldValue: txtKitCode.text,
            lstrTable: 'KITCHENMAST',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: fnCallBack,
          ),
          'Choose Kitchen');
    }
    if (mode == 'FLOOR') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Description'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {'sourceColumn': 'CODE', 'contextField': txtFloor, 'context': 'window'}
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtFloor,
            oldValue: txtFloor.text,
            lstrTable: 'RST_FLOORMAST',
            lstrColumnList: lookupColumns,
            lstrFilldata: lookupFillData,
            lstrPage: '0',
            lstrPageSize: '1000',
            lstrFilter: [],
            keyColumn: 'CODE',
            layoutName: "B",
            callback: fnCallBack,
          ),
          'Choose Floor');
    }
  }

  fnCallBack(data) {
    setState(() {});
  }
//=======================================================APICALL

  apiViewKitchenPrinter(code, mode) {
    futureForm = apiCall.ViewKitchenPrinter(code, mode);
    futureForm.then((value) => apiViewKitchenPrinterRes(value));
  }

  apiViewKitchenPrinterRes(value) {
    if (g.fnValCheck(value)) {
      fnFill(value[0]);
    }
  }

  apiSaveKitchenPrinter() {
    futureForm = apiCall.SaveKitchenPrinter(
        txtCode.text,
        txtDescp.text,
        txtKitCode.text,
        txtFloor.text,
        txtPrintCode.text,
        wstrPageMode,
        g.wstrUserCd);
    futureForm.then((value) => apiSaveKitchenPrinterRes(value));
  }

  apiSaveKitchenPrinterRes(value) {
    //[{STATUS: 1, MSG: AREA SAVED, CODE: 02}]
    if (g.fnValCheck(value)) {
      var sts = value[0]["STATUS"];
      var msg = value[0]["MSG"];
      if (sts == "1") {
        //call fill api with code;
        successMsg(context, "Saved");
        apiViewKitchenPrinter("", "LAST");
        apiSearchArea();
      } else {
        errorMsg(context, msg);
      }
    } else {
      errorMsg(context, "Please try again!");
    }
  }

  apiDeleteKitchenPrinter() {
    Navigator.pop(context);
    futureForm = apiCall.DeletekitchenPrinter(txtCode.text, g.wstrUserCd);
    futureForm.then((value) => apiDeleteKitchenPrinterRes(value));
  }

  apiDeleteKitchenPrinterRes(value) {
    if (g.fnValCheck(value)) {
      var sts = value[0]["STATUS"];
      var msg = value[0]["MSG"];
      if (sts == "1") {
        //call fill api with code;
        customMsg(context, "Deleted", Icons.delete_sharp);
        apiViewKitchenPrinter("", "LAST");
        apiSearchArea();
      } else {
        errorMsg(context, msg);
      }
    } else {
      errorMsg(context, "Please try again!");
    }
  }

  apiSearchArea() {
    var filterVal = [];
    final List<Map<String, dynamic>> columnList = [
      {'Column': 'CODE'},
      {'Column': 'DESCP'},
    ];
    var columnListTemp;
    for (var e in columnList) {
      filterVal.add({
        "Column": e['Column'],
        "Operator": "LIKE",
        "Value": txtSearch.text,
        "JoinType": "OR"
      });
      columnListTemp == null
          ? columnListTemp = e['Column'] + "|"
          : columnListTemp += e['Column'] + "|";
    }

    futureView = apiCall.LookupSearch(
        "KITCHEN_PRINT_MAST", columnListTemp, 0, 100, filterVal);
    futureView.then((value) => apiSearchAreaRes(value));
  }

  apiSearchAreaRes(value) {
    if (mounted) {
      setState(() {
        lstrSearchResult = [];
        if (g.fnValCheck(value)) {
          lstrSearchResult = value;
        }
      });
    }
  }
}
