
import 'package:flutter/material.dart';

class QuickBill extends StatefulWidget {
  const QuickBill({Key? key}) : super(key: key);

  @override
  State<QuickBill> createState() => _QuickBillState();
}

class _QuickBillState extends State<QuickBill> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Row(
          children: [
            Container(
              color: Colors.red,
              width: size.width*0.2,
            ),
            Expanded(child: Container(),),
            Container(
              color: Colors.red,
              width: size.width*0.3,
            ),
          ],
        ),
      ),
    );
  }
}
