import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.validator,
    this.textInputAction,
  });

  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth * 0.02;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        textInputAction: textInputAction,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText,
        ),
      ),
    );
  }
}
