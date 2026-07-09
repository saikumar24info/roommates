import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/colors.dart';

Widget elevatedButton(BuildContext context,
    {double buttonHeight = 16,
    double buttonWidth = 80,
    Color backgroundColor = AppColors.primary,
    double fontSize = 12,
    String buttonText = '',
    Color textColor = AppColors.white,
    double borderRadius = 5,
    required VoidCallback onPress}) {
  return SizedBox(
    height: height(context) * buttonHeight,
    width: width(context) * buttonWidth,
    child: ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height(context) * 6),
        ),
        alignment: Alignment.center,
        textStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: () => onPress(),
      child: Text(
        buttonText,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor),
      ),
    ),
  );
}
