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

class printMaster extends StatefulWidget {
  const printMaster({Key? key}) : super(key: key);

  @override
  State<printMaster> createState() => _printMaster();
}

class _printMaster extends State<printMaster> {
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

  var txtPrintCode = TextEditingController();

  var pagefocusNode = FocusNode();
  var pnCode = FocusNode();
  var pnDescp = FocusNode();
  var pnPrintcode = FocusNode();

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
    txtPrintCode.dispose();

    pagefocusNode.dispose();
    pnCode.dispose();
    pnDescp.dispose();
    pnPrintcode.dispose();

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
                      th('Printer Master', PrimaryColor, 17),
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
                                txtController: txtPrintCode,
                                hintText: "Path",
                                focusNode: pnPrintcode,
                                enablests:
                                    wstrPageMode != "VIEW" ? true : false,
                                txtWidth: 0.2,
                                emptySts:
                                    txtPrintCode.text.isEmpty ? false : true,
                                onClear: () {
                                  setState(() {
                                    txtPrintCode.clear();
                                  });
                                },
                                onChanged: (value) {},
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
              var descp = dataList["NAME"] ?? "";
              //var invReportName = dataList["INVITATION_RPT"] ?? "";
              var printCode = dataList["PATH"] ?? "";

              return Bounce(
                onPressed: () {
                  apiViewPrinter(code, "");
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
                      Row(
                        children: [
                          Icon(
                            Icons.print,
                            color: PrimaryColor,
                            size: 15,
                          ),
                          gapWC(10),
                          Expanded(
                            child: tcn(printCode.toString(), Colors.black, 12),
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
        "FILL_CODE": "NAME",
        "PAGE_NODE": pnDescp
      });
      wstrPageForm.add({
        "CONTROLLER": txtPrintCode,
        "TYPE": "N",
        "VALIDATE": false,
        "ERROR_MSG": "Please enter Path",
        "FILL_CODE": "PATH",
        "PAGE_NODE": pnPrintcode
      });
    });
    apiSearchArea();
    apiViewPrinter("", "LAST");
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
    apiViewPrinter("", "LAST");
  }

  fnView(code, mode) {
    if (wstrPageMode == "VIEW") {
      apiViewPrinter(code, mode);
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

    apiSavePrinter();
  }

  fnDelete() {
    if (wstrPageMode != "VIEW" || txtCode.text.isEmpty) {
      infoMsg(context, "No area selected");
      return;
    }
    PageDialog().deleteDialog(context, apiDeletePrinter);
  }

  fnLog() {}

//=======================================================APICALL

  apiViewPrinter(code, mode) {
    futureForm = apiCall.ViewPrinter(code, mode);
    futureForm.then((value) => apiViewPrinterRes(value));
  }

  apiViewPrinterRes(value) {
    if (g.fnValCheck(value)) {
      fnFill(value[0]);
    }
  }

  apiSavePrinter() {
    futureForm = apiCall.SavePrinter(txtCode.text, txtDescp.text,
        txtPrintCode.text, wstrPageMode, g.wstrUserCd);
    futureForm.then((value) => apiSavePrinterRes(value));
  }

  apiSavePrinterRes(value) {
    //[{STATUS: 1, MSG: AREA SAVED, CODE: 02}]
    if (g.fnValCheck(value)) {
      var sts = value[0]["STATUS"];
      var msg = value[0]["MSG"];
      if (sts == "1") {
        //call fill api with code;
        successMsg(context, "Saved");
        apiViewPrinter("", "LAST");
        apiSearchArea();
      } else {
        errorMsg(context, msg);
      }
    } else {
      errorMsg(context, "Please try again!");
    }
  }

  apiDeletePrinter() {
    Navigator.pop(context);
    futureForm = apiCall.DeletePrinter(txtCode.text, g.wstrUserCd);
    futureForm.then((value) => apiDeletePrinterRes(value));
  }

  apiDeletePrinterRes(value) {
    if (g.fnValCheck(value)) {
      var sts = value[0]["STATUS"];
      var msg = value[0]["MSG"];
      if (sts == "1") {
        //call fill api with code;
        customMsg(context, "Deleted", Icons.delete_sharp);
        apiViewPrinter("", "LAST");
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
      {'Column': 'NAME'},
      {'Column': 'PATH'},
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
        "RST_PRINTMAST", columnListTemp, 0, 100, filterVal);
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
