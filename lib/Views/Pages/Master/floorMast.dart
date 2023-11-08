import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Controllers/Services/apiController.dart';
import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/bottomNavigator.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Components/lookup.dart';
import 'package:beamsbistro/Views/Components/lookup_alert.dart';
import 'package:beamsbistro/Views/Components/rounded_inputfield.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

class FloorMast extends StatefulWidget {
  const FloorMast({Key? key}) : super(key: key);

  @override
  _FloorMastState createState() => _FloorMastState();
}

class _FloorMastState extends State<FloorMast> {
  //api
  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic> futureFloor;

  //textController
  var txtCode = new TextEditingController();
  var txtDescp = new TextEditingController();

  //varaibles
  var wstrPageMode = '';
  var lstrPageDocno = '';

  @override
  void initState() {
    // TODO: implement initState
    wstrPageMode = 'VIEW';
    fnPageData('', 'LAST');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return pageMenuScreen(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            h1('Floor Master'),
            gapH(),
            RoundedInputField(
              hintText: 'Code',
              txtRadius: 5,
              txtWidth: 0.4,
              suffixIcon: wstrPageMode == 'VIEW' ? Icons.search : null,
              txtController: txtCode,
              suffixIconOnclick: () {
                wstrPageMode == 'VIEW' ? fnLookup('FLOOR') : '';
              },
              onChanged: (value) {
                wstrPageMode == 'VIEW' ? fnLookup('FLOOR') : '';
              },
              enablests: wstrPageMode == 'EDIT' ? false : true,
            ),
            RoundedInputField(
              hintText: 'Description',
              txtRadius: 5,
              txtController: txtDescp,
              enablests: wstrPageMode == 'VIEW' ? false : true,
            )
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
        ),
        fnBack);
  }

  //ButtonClicks
  fnAdd() {
    txtCode.clear();
    txtDescp.clear();
    setState(() {
      wstrPageMode = 'ADD';
    });
  }

  fnEdit() {
    setState(() {
      wstrPageMode = 'EDIT';
    });
  }

  fnCancel() {
    setState(() {
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
    if (txtCode.text.isEmpty) {
      showToast('Please fill data');
      return;
    } else {
      futureFloor =
          apiCall.saveFloor(txtCode.text, txtDescp.text, wstrPageMode);
      futureFloor.then((value) => fnSaveCallBack(value));
    }
  }

  fnDelete() {
    PageDialog().deleteDialog(context, fnDeleteApi);
  }

  fnDeleteApi() {
    futureFloor = apiCall.deleteFloor(txtCode.text);
    futureFloor.then((value) {
      if (g.fnValCheck(value)) {
        var sts = value[0]['STATUS'];
        var msg = value[0]['MSG'];
        if (sts == '1') {
          showToast(msg);
          fnPageData(txtCode.text, 'PREVIOUS');
        } else {
          showToast(msg);
          fnPageData(txtCode.text, '');
        }
      }
    });
    Navigator.pop(context);
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
    futureFloor = apiCall.viewFloor(docNo, mode);
    futureFloor.then((value) => fnFillData(value));
  }

  fnFillData(value) {
    if (g.fnValCheck(value)) {
      lstrPageDocno = value[0]['CODE'];
      txtCode.text = value[0]['CODE'];
      txtDescp.text = value[0]['DESCP'];
    }
  }

  //lookup
  fnLookup(mode) {
    if (mode == 'FLOOR') {
      final List<Map<String, dynamic>> lookupColumns = [
        {'Column': 'CODE', 'Display': 'Floor Code'},
        {'Column': 'DESCP', 'Display': 'Floor Name'}
      ];
      final List<Map<String, dynamic>> lookupFillData = [
        {'sourceColumn': 'CODE', 'contextField': txtCode, 'context': 'window'},
        {'sourceColumn': 'DESCP', 'contextField': txtDescp, 'context': 'window'}
      ];

      LookupAlert().showLookup(
          context,
          Lookup(
            txtControl: txtCode,
            oldValue: txtCode.text,
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
    setState(() {
      lstrPageDocno = data['CODE'];
    });
  }

  fnBack() {}
}
