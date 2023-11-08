

import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';
class homeWindow extends StatefulWidget {
  const homeWindow({Key? key}) : super(key: key);

  @override
  _homeWindowState createState() => _homeWindowState();
}

class _homeWindowState extends State<homeWindow> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          child: SingleChildScrollView(
            child: Container(
                child: Column(
                  children: [
                    h1('Windows'),
                  ],
                ),
            ),
          ),
        ),
    );
  }
}
