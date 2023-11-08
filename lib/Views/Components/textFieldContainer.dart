
import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget ? child;
  final double ? txtWidth;
  final double ? txtHeight;
  final double ? txtRadius;
  final String ? labelName;
  final String ? labelYn;
  final Color ? labelColor;


  const TextFieldContainer({
    Key ?  key,
    this.child  ,
    this.txtWidth,
    this.txtRadius,
    this.labelName,
    this.labelYn,
    this.txtHeight,
    this.labelColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Container(
      height: labelYn == 'Y'? 70: 55,
      margin: EdgeInsets.only(bottom: 0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelYn == 'Y'? tc_normal(labelName, labelColor??Colors.black,12) : Container(),
          Container(
            height: txtHeight??40,

            margin: EdgeInsets.symmetric(vertical: 2),
            padding: EdgeInsets.symmetric(horizontal:5, vertical: 0),
            width: size.width * txtWidth!,
            decoration: boxOutlineDecoration(Colors.white, txtRadius??0),
            child: child,
          ),
        ],
      ),
    );
  }
}