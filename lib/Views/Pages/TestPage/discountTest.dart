

import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';

class Discount extends StatefulWidget {
  const Discount({Key? key}) : super(key: key);

  @override
  _DiscountState createState() => _DiscountState();
}

class _DiscountState extends State<Discount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            tc('Discount', Colors.black, 30),
            Row(
              children: [
                gapW(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
