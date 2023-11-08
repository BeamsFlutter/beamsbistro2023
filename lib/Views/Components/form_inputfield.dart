import 'package:beamsbistro/Views/Components/common.dart';
import 'package:beamsbistro/Views/Styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class FormInput extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final IconData? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final VoidCallback? onEditingComplete;
  final TextInputType? textType;
  final TextEditingController? txtController;
  final double? txtHeight;
  final double? txtWidth;
  final double? txtRadius;
  final int? txtLength;
  final FocusNode? focusNode;
  final Function? suffixIconOnclick;
  final Function? onClear;
  final bool? enablests;
  final bool? autoFocus;
  final bool? validate;
  final bool? emptySts;
  final bool? passwordYn;
  final String? errorMsg;
  final String? labelYn;
  final Color? labelColor;
  final double? fontSize;
  final bool? focusSts;
  const FormInput(
      {Key? key,
      this.hintText,
      this.icon,
      this.suffixIcon,
      this.onChanged,
      this.onSubmit,
      this.onEditingComplete,
      this.textType,
      this.txtController,
      this.txtHeight,
      this.txtWidth,
      this.txtRadius,
      this.focusNode,
      this.suffixIconOnclick,
      this.onClear,
      this.enablests,
      this.autoFocus,
      this.validate,
      this.emptySts,
      this.errorMsg,
      this.labelYn,
      this.labelColor,
      this.fontSize,
      this.txtLength,
      this.passwordYn,
      this.focusSts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<TextInputFormatter> inputFormatters = [];
    if (textType == TextInputType.number) {
      inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelYn != "N"
            ? tcn(hintText ?? "", labelColor ?? Colors.black, 12)
            : gapHC(0),
        gapHC(2),
        Container(
          alignment: Alignment.topCenter,
          height: txtHeight ?? 33,
          width: size.width * txtWidth!,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: boxOutlineInput(enablests ?? true, focusSts ?? false),
          child: TextFormField(
            focusNode: focusNode,
            maxLength: txtLength,
            minLines: 1,
            controller: txtController,
            autofocus: autoFocus ?? false,
            enabled: enablests ?? true,
            keyboardType: textType,
            onChanged: onChanged ?? fn(),
            cursorColor: PrimaryColor,
            onFieldSubmitted: onSubmit ?? fn(),
            inputFormatters: inputFormatters,
            obscureText: passwordYn ?? false,
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.black),
            decoration: InputDecoration(
              counterText: "",
              hintText: hintText.toString(),
              border: InputBorder.none,
              suffixIcon: suffixIcon != null
                  ? InkWell(
                      onTap: suffixIconOnclick ?? fn(),
                      child: Icon(
                        suffixIcon,
                        color: PrimaryColor,
                        size: 15,
                      ),
                    )
                  : GestureDetector(
                      onTap: onClear ?? fn(),
                      child: (emptySts ?? true)
                          ? Icon(Icons.cancel_outlined,
                              size: 15, color: Colors.grey.withOpacity(0.6))
                          : Icon(
                              Icons.cancel_outlined,
                              size: 15,
                              color: greyLight,
                            ),
                    ),
            ),
            validator: (value) {
              if (validate ?? false) {
                if (value == null || value.isEmpty) {
                  //return errorMsg;
                }
              }
              return null;
            },
          ),
        ),
        gapHC(2),
        (validate ?? false) && !emptySts! && (errorMsg ?? "").isNotEmpty
            ? tcn(errorMsg ?? "", PrimaryColor, 12)
            : gapHC(0),
      ],
    );
  }

  fn() {}
}
