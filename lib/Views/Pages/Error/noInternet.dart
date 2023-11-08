import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  _NoInternetState createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       body: Container(
         height: size.height,
         width: size.width,
         child: Center(
           child: h1('No Internet'),
         ),

       ),
    );
  }
}
