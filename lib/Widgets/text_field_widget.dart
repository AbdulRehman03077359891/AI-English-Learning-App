import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFieldWidget extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final width,
      controller,
      validate,
      hintText,
      prefixIcon,
      fillColor,
      focusBorderColor,
      hidePassword,
      suffixIcon,
      errorBorderColor,
      suffixIconColor,
      keyboardType,
      labelText,
      labelColor,
      lines,
      textColor,
      textCapitalization,
      hintColor,
      onchange;

  const TextFieldWidget(
      {super.key,
      this.width,
      this.controller,
      this.validate,
      this.hintText,
      this.prefixIcon,
      this.fillColor = Colors.white,
      required this.focusBorderColor,
      this.hidePassword = false,
      this.suffixIcon,
      this.errorBorderColor,
      this.suffixIconColor,
      this.keyboardType,
      this.labelText,
      this.labelColor,
      this.lines=1, 
      this.textColor, 
      this.textCapitalization = TextCapitalization.none, 
      this.hintColor,
      this.onchange
    });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        onChanged: onchange,
        textCapitalization: textCapitalization,
        style: TextStyle(color: textColor),
        minLines: lines,
        maxLines: lines,
        keyboardType: keyboardType,
        obscureText: hidePassword,
        controller: controller,
        validator: validate,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
          labelStyle: TextStyle(color: labelColor),
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor,fontWeight: FontWeight.w300),
          suffixIcon: suffixIcon,
          suffixIconColor: suffixIconColor,
          prefixIcon: prefixIcon,
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
        ),
      ),
    );
  }
}
