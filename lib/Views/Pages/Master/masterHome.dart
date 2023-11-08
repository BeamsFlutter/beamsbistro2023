import 'package:beamsbistro/Controllers/Navigation/navigationController.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';

class MasterHome extends StatefulWidget {
  const MasterHome({Key? key}) : super(key: key);

  @override
  _MasterHomeState createState() => _MasterHomeState();
}

class _MasterHomeState extends State<MasterHome> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: navigationTitleAppBar(context, 'Masters', fnPageBack),
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
          padding: pagePadding(),
          margin: pageMargin(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: size.height * 0.9,
                  width: size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            masterCard('Menu', Icons.menu_book, 12, 1, size),
                            masterCard('Category', Icons.category, 12, 1, size),
                            masterCard('Dish Group', Icons.grading_outlined, 12,
                                1, size),
                            masterCard(
                                'Dish', Icons.fastfood_rounded, 12, 21, size),
                          ],
                        ),
                        gapH(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            masterCard('Table', Icons.table_chart_rounded, 11,
                                5, size),
                            masterCard(
                                'Floor', Icons.food_bank_outlined, 11, 4, size),
                            masterCard('Role', Icons.menu, 11, 1, size),
                            masterCard('Shift', Icons.access_time_outlined, 11,
                                1, size),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //widget
  GestureDetector masterCard(name, icon, color, route, size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, NavigationController().fnRoute(route));
      },
      child: Container(
        height: 110,
        width: size.width * 0.18,
        margin: EdgeInsets.only(right: 20),
        decoration: boxGradientDecoration(color, 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 50,
              ),
              tc(name, Colors.white, 15)
            ],
          ),
        ),
      ),
    );
  }

  fnPageBack() {}
}
