import 'package:flutter/material.dart';

class TrueFalseChoose extends StatelessWidget {
  final String? selectedTrueFalse;
  final void Function(String?)? onChange;
  final double? width;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final String? hintText;
  final IconData? prefixIcon;
  final Color? fillColor;
  final Color focusBorderColor;
  final bool? hidePassword;
  final Widget? suffixIcon;
  final Color errorBorderColor;
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final Color? labelText;
  final Color? labelColor;
  const TrueFalseChoose(
      {super.key,
      required this.selectedTrueFalse,
      required this.onChange,
      this.width,
      this.controller,
      this.validate,
      this.hintText,
      this.prefixIcon,
      this.fillColor,
      required this.focusBorderColor,
      this.hidePassword = false,
      this.suffixIcon,
      required this.errorBorderColor,
      this.suffixIconColor,
      this.keyboardType,
      this.labelText,
      this.labelColor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          labelStyle: TextStyle(color: labelColor),
          hintText: hintText,
          filled: true,
          fillColor: fillColor,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              borderSide: BorderSide(
                width: 2.0,
                style: BorderStyle.solid,
                strokeAlign: BorderSide.strokeAlignOutside,
              )),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
            borderSide: BorderSide(
              color: focusBorderColor,
              width: 2.0,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
            borderSide: BorderSide(
              color: errorBorderColor,
              width: 2.0,
              style: BorderStyle.solid,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          labelText: 'TrueFalse',
        ),
        value: selectedTrueFalse,
        items: ['True','False']
            .map((trueFalse) => DropdownMenuItem(
                  value: trueFalse,
                  child: Text(trueFalse),
                ))
            .toList(),
        onChanged: onChange,
        validator: (value) => value == null ? 'Please select a trueFalse' : null,
      ),
    );
  }
}
