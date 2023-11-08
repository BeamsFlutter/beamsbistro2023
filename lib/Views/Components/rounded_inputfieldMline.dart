import 'package:beamsbistro/Views/Components/TextFieldContainerMline.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'textFieldContainer.dart';

class RoundedInputFieldMline extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final IconData? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final TextInputType? textType;
  final TextEditingController? txtController;
  final double? txtWidth;
  final double? txtHeight;
  final double? txtRadius;
  final int? maxLength;
  final FocusNode? focusNode;
  final Function? suffixIconOnclick;
  final bool? enablests;
  final bool? autoFocus;
  final String? labelYn;
  final String? numberFormat;
  final Color? labelColor;

  const RoundedInputFieldMline(
      {Key? key,
      required this.hintText,
      this.icon,
      this.onChanged,
      this.textType,
      this.txtController,
      this.txtWidth,
      this.txtRadius,
      this.suffixIcon,
      this.onSubmit,
      this.focusNode,
      this.suffixIconOnclick,
      this.enablests,
      this.autoFocus,
      this.labelYn,
      this.txtHeight,
      this.maxLength,
      this.numberFormat,
      this.labelColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainerMline(
      txtRadius: txtRadius == null ? 29 : txtRadius,
      txtWidth: txtWidth == null ? 0.8 : txtWidth,
      labelName: hintText ?? '',
      labelYn: labelYn ?? 'N',
      labelColor: labelColor,
      child: TextFormField(
          enabled: enablests == null ? true : enablests,
          focusNode: focusNode,
          controller: txtController,
          onChanged: onChanged,
          cursorColor: PrimaryColor,
          maxLength: maxLength ?? 100000,
          maxLines: 6,
          decoration: InputDecoration(
            counterText: "",
            suffixIcon: InkWell(
              onTap: suffixIconOnclick ?? fn(),
              child: Icon(
                suffixIcon,
                color: Colors.black,
              ),
            ),
            hintText: hintText,
            border: InputBorder.none,
          ),
          keyboardType: textType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            }
            return null;
          },
          onFieldSubmitted: onSubmit,
          inputFormatters: numberFormat == 'Y'
              ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
              : <TextInputFormatter>[]),
    );
  }

  fn() {}
}
