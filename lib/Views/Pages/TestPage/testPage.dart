

import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';

class Drag extends StatefulWidget {
  Drag({Key ?key}) : super(key: key);
  @override
  _DragState createState() => _DragState();
}
class _DragState extends State<Drag> {
  double top = 0;
  double left = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Draggable(
          child: Container(
            padding: EdgeInsets.only(top: top, left: left),
            child: fnDragItem(2),
          ),
          feedback: Container(
            padding: EdgeInsets.only(top: top, left: left),
            child: fnDragItem(2),
          ),
          childWhenDragging: Container(
            padding: EdgeInsets.only(top: top, left: left),
            child: fnDragItem(2),
          ),
          onDragCompleted: () {},
          onDragEnd: (drag) {
            setState(() {
              top = top + drag.offset.dy < 0 ? 0 : top + drag.offset.dy;
              left = left + drag.offset.dx < 0 ? 0 : left + drag.offset.dx;
            });
          },
        ),
      ),
    );
  }

  fnDragItem(num){
    if(num == 1){
      return Container(
        height: 150,
        width: 150,
        decoration: boxDecoration(Colors.amber, 150),
      );
    }else{
      return Container(
        height: 150,
        width: 150,
        decoration: boxDecoration(Colors.red, 150),
      );
    }

  }
}
class DragItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: boxDecoration(Colors.green, 30),
    );
  }
}