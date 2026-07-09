import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';

class TextUtility {
  static Widget headerText(BuildContext context, String text, Color color,
      {int maxLines = 1}) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: fontSize(context) * 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget titleText(BuildContext context, text, Color color,
      {int maxLines = 1}) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontSize(context) * 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  static Widget subTitleText(BuildContext context, text, Color color,
      {int maxLines = 1}) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontSize(context) * 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static Widget mediumBodyText(BuildContext context, text, Color color,
      {int maxLines = 1}) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      style: TextStyle(
        color: color,
        fontSize: fontSize(context) * 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  static Widget bodyText(BuildContext context, String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize(context) * 14,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
