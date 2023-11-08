

import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';

class MoveableStackItemRound extends StatefulWidget {
  @override State<StatefulWidget> createState() {
    return _MoveableStackItemState();
  }
}
class _MoveableStackItemState extends State<MoveableStackItemRound> {
  double xPosition = 0;
  double yPosition = 0;
  Color color = Colors.green;
  @override
  void initState() {
    color = Colors.green;
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
          decoration: boxDecoration(Colors.green, 100),
          width: 100,
          height: 100,
        ),
      ),
    );
  }
}