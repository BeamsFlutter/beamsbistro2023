import 'package:beamsbistro/Controllers/Global/globalValues.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Pages/Master/area_master.dart';
import 'package:beamsbistro/Views/Pages/Master/categorymast.dart';
import 'package:beamsbistro/Views/Pages/Master/dishMast.dart';
import 'package:beamsbistro/Views/Pages/Master/kitchenPrintes.dart';
import 'package:beamsbistro/Views/Pages/Master/printMaster.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:beamsbistro/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';

class MasterHomev2 extends StatefulWidget {
  const MasterHomev2({Key? key}) : super(key: key);

  @override
  State<MasterHomev2> createState() => _MasterHomeState();
}

class _MasterHomeState extends State<MasterHomev2> {
  Global g = Global();

  var lstrSelectedMaster = 'KITCHEN';
  var lstrMasterList = [];

  @override
  void initState() {
    // TODO: implement initState
    fnGetPageData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              height: 50,
              decoration: boxDecoration(Colors.white, 10),
              child: masterListView(),
            ),
            gapHC(10),
            Expanded(child: masterWiseView())
          ],
        ),
      ),
    );
  }

//==========================================================WIDGET

  Widget masterListView() {
    return Row(
      children: [
        GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.navigate_before,
              color: Colors.black,
            )),
        th('     MASTERS     ', PrimaryColor, 15),
        gapWC(20),
        Expanded(
            child: ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: lstrMasterList.length,
              itemBuilder: (context, index) {
                var dataList = lstrMasterList[index];
                var code = dataList["CODE"];
                var descp = dataList["DESCP"] ?? "";
                var icon = dataList["ICON"];
                return Bounce(
                  onPressed: () {
                    setState(() {
                      lstrSelectedMaster = code;
                    });
                  },
                  duration: const Duration(milliseconds: 110),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    margin: const EdgeInsets.only(right: 10),
                    decoration: boxBaseDecoration(
                        lstrSelectedMaster == code
                            ? PrimaryColor
                            : Colors.white,
                        5),
                    child: Row(
                      children: [
                        Icon(
                          icon,
                          color: lstrSelectedMaster == code
                              ? Colors.white
                              : PrimaryColor,
                          size: 15,
                        ),
                        gapWC(10),
                        tcn(
                            descp.toString(),
                            lstrSelectedMaster == code
                                ? Colors.white
                                : PrimaryColor,
                            13)
                      ],
                    ),
                  ),
                );
              }),
        ))
      ],
    );
  }

  Widget masterWiseView() {
    return lstrSelectedMaster == "KITCHEN"
        ? const AreaMaster()
        : lstrSelectedMaster == "DISH"
            ? DishMast()
            : lstrSelectedMaster == "CAT"
                ? CategoryMaster(
                    wstrGroup: '0',
                  )
                : lstrSelectedMaster == "PRINTER"
                    ? const printMaster()
                    : lstrSelectedMaster == "KITPRINTER"
                        ? const kitchenPrintes()
                        : Container(
                            decoration: boxBaseDecoration(blueLight, 10),
                          );
  }

//==========================================================PAGEFN

  fnGetPageData() {
    lstrMasterList = [];
    setState(() {
      lstrMasterList.add({
        "CODE": "DISH",
        "DESCP": "Dish Master",
        "ICON": Icons.category,
      });

      lstrMasterList.add({
        "CODE": "CAT",
        "DESCP": "Dish Category",
        "ICON": Icons.list,
      });
      lstrMasterList.add({
        "CODE": "KITCHEN",
        "DESCP": "Kitchen Master",
        "ICON": Icons.assignment,
      });
      lstrMasterList.add({
        "CODE": "PRINTER",
        "DESCP": "Printer Master",
        "ICON": Icons.print,
      });
      lstrMasterList.add({
        "CODE": "KITPRINTER",
        "DESCP": "Kitchen Printer",
        "ICON": Icons.print_sharp,
      });
    });
  }

//==========================================================APICALL
}
