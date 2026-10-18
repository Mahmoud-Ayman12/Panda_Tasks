import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testing_firebase/provMoadel/StateProv.dart';

class TextFieldWidgets extends StatelessWidget {
  const TextFieldWidgets({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.hint,
    required this.obscureText,
    required this.icon,
  });
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hint;
  final bool obscureText;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.read<Stateprov>().isArapicText(controller.text);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, val, child) {
        final isArabic = context.read<Stateprov>().isArapicText(val.text);
        return TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(50),
            ),
            hint: Text(hint, style: const TextStyle(color: Colors.grey)),
            suffixIcon: icon,
            suffixIconColor: Colors.grey,
          ),
        );
      },
    );
  }
}
