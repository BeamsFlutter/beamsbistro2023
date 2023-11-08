import 'package:beamsbistro/Views/Components/common.dart';
import 'package:flutter/material.dart';

class TextFieldContainerMline extends StatelessWidget {
  final Widget? child;
  final double? txtWidth;
  final double? txtHeight;
  final double? txtRadius;
  final String? labelName;
  final String? labelYn;
  final Color? labelColor;

  const TextFieldContainerMline({
    Key? key,
    this.child,
    this.txtWidth,
    this.txtRadius,
    this.labelName,
    this.labelYn,
    this.txtHeight,
    this.labelColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelYn == 'Y'
              ? tc_normal(labelName, labelColor ?? Colors.black, 12)
              : Container(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            width: size.width * txtWidth!,
            decoration: boxOutlineDecoration(Colors.white, txtRadius ?? 0),
            child: child,
          ),
        ],
      ),
    );
  }
}
