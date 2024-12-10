import 'package:flutter/material.dart';

class GenderChoose extends StatelessWidget {
  final String? selectedGender;
  final void Function(String?)? onChange;
  final double? width;
  final TextEditingController? controller;
  final String? Function(String?)? validate;
  final String? hintText;
  final Widget? prefixIcon;
  final Color? fillColor;
  final Color focusBorderColor;
  final bool? hidePassword;
  final Widget? suffixIcon;
  final Color errorBorderColor;
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final Color? labelText;
  final Color? labelColor;
  const GenderChoose(
      {super.key,
      required this.selectedGender,
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
          labelText: 'Gender',
        ),
        value: selectedGender,
        items: ['Male', 'Female', 'Other']
            .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ))
            .toList(),
        onChanged: onChange,
        validator: (value) => value == null ? 'Please select a gender' : null,
      ),
    );
  }
}
