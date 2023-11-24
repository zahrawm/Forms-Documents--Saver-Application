import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData prefixIconData;
  final Widget? suffixIcon;
  final String? Function(String?) validator;
  final bool obscureText;
  const CustomTextField(
      {Key? key,
      required this.controller,
      this.labelText,
      required this.hintText,
      required this.prefixIconData,
      this.suffixIcon,
      required this.validator,
      this.obscureText = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            prefixIcon: Icon(prefixIconData),
            suffixIcon: suffixIcon),
      ),
    );
  }
}
