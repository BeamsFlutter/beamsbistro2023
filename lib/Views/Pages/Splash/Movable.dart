

import 'dart:math';

import 'package:beamsbistro/Views/Components/alertDialog.dart';
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';

class MoveableStackItem extends StatefulWidget {

  final bool mode;
  final int id;
  final double x;
  final double y;
  final Function fnCallBack;

  const MoveableStackItem({Key? key, required this.mode, required this.id, required this.x, required this.y, required this.fnCallBack}) : super(key: key);

  @override State<StatefulWidget> createState() {

    return _MoveableStackItemState();
  }
}
class _MoveableStackItemState extends State<MoveableStackItem> {
  double xPosition = 0;
  double yPosition = 0;
  late Color color;
  @override
  void initState() {
    color = Colors.red;
    xPosition = widget.x;
    yPosition =  widget.y;
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
            if(widget.mode){
              xPosition += tapInfo.delta.dx;
              yPosition += tapInfo.delta.dy;
              widget.fnCallBack(xPosition,yPosition,widget.id);
            }

          });
        },
        child: GestureDetector(
          onTap: (){
            PageDialog().showNote(context, Container(), widget.id.toString());
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: boxDecoration(Colors.green, 20),
            child: Center(
              child: tcn(widget.id.toString(), Colors.white, 15),
            ),
          ),
        )
      ),
    );
  }
}