import 'package:flutter/material.dart';

class CustomTextFeild extends StatelessWidget {
  const CustomTextFeild({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.readOnly,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final bool? readOnly;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        readOnly: readOnly ?? false,
        controller: controller,
        focusNode: focusNode,
        decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          hintText: hint,
        ),
      ),
    );
  }
}
