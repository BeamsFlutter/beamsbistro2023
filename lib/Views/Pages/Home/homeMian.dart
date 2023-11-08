
import 'package:beamsbistro/Views/Components/responsiveHelper.dart';
import 'package:beamsbistro/Views/Pages/Home/homeWindow.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMainState createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        mobile: Home(),
        tab: Home(),
        windows: homeWindow()
    );
  }
}
