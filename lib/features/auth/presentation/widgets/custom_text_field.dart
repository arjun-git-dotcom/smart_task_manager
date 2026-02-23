import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? toggleIcon;
  final String ?hintText;

  const CustomTextField({
    required this.controller,
    this.toggleIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.hintText,

    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,

      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: hintText,
        suffixIcon: IconButton(
          onPressed: () {
            toggleIcon?.call();
          },
          icon: Icon(suffixIcon),
        ),
      ),
    );
  }
}
