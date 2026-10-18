import 'package:flutter/material.dart';

class ImageSinginWidget extends StatelessWidget {
  const ImageSinginWidget({super.key, required this.url});
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(width: 1, color: const Color(0xFFE2E2E2)),
      ),
      child: Center(
        child: Image.asset("$url", width: 35, height: 35, fit: BoxFit.contain),
      ),
    );
  }
}
