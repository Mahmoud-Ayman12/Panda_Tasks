import 'package:flutter/material.dart';

class BottomWidget extends StatelessWidget {
  const BottomWidget({super.key, required this.text, required this.click});
  final String text;
  final Function() click;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: MaterialButton(
        padding: EdgeInsets.symmetric(vertical: 15),
        color: Colors.blueGrey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: click,
        child: Text(text, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
