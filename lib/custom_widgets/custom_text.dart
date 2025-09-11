import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color? textColor;
  final double textSize;
  final int? maxLinesAllowed;
  final FontWeight textBoldness;
  final TextAlign? alignment;
  final TextOverflow? textOverflow;

  const CustomText({
    super.key,
    required this.text,
    this.textColor,
    this.textSize = 18.0,
    this.alignment,
    this.textBoldness = FontWeight.normal,
    this.maxLinesAllowed,
    this.textOverflow,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: textOverflow,
      maxLines: maxLinesAllowed,
      textAlign: alignment,
      text,
      style: TextStyle(
        color: textColor,
        fontSize: textSize,
        fontWeight: textBoldness,
      ),
    );
  }
}
