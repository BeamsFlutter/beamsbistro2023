

import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';

class MoveableStackItemLong extends StatefulWidget {
  @override State<StatefulWidget> createState() {
    return _MoveableStackItemState();
  }
}
class _MoveableStackItemState extends State<MoveableStackItemLong> {
  double xPosition = 0;
  double yPosition = 0;
  Color color = Colors.blue;
  @override
  void initState() {
    color = Colors.blue;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;
          });
        },
        child: Container(
          decoration: boxDecoration(Colors.blue, 100),
          width: 200,
          height: 100,
        ),
      ),
    );
  }
}