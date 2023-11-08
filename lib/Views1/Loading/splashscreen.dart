

import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(),
          Container(
            decoration: boxDecoration(Colors.white, 10),
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                
              ],
            ),
          )
        ],
      ),
    );
  }
}
