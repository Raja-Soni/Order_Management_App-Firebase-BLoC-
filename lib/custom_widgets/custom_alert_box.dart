import 'package:flutter/material.dart';

import 'custom_text.dart';

class CustomAlertBox extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final Color? buttonTextColor;
  final IconData? titleIcon;
  final double? titleIconSize;
  final Color? titleIconColor;
  final Color? backgroundColor;
  final Color? confirmationButtonColor;

  const CustomAlertBox({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = "OK",
    this.buttonTextColor,
    this.titleIcon = Icons.info,
    this.titleIconSize = 30,
    this.titleIconColor = Colors.blue,
    this.backgroundColor,
    this.confirmationButtonColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      title: Row(
        spacing: 10,
        children: [
          Icon(titleIcon, color: titleIconColor, size: titleIconSize),
          CustomText(text: title, textSize: 25, textBoldness: FontWeight.bold),
        ],
      ),
      content: CustomText(text: message, textSize: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmationButtonColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: CustomText(text: confirmText, textColor: buttonTextColor),
        ),
      ],
    );
  }
}
