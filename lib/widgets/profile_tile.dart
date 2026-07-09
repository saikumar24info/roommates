import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/constants.dart';
import 'package:room_mates/utils/text_utility.dart';

import '../utils/colors.dart';

Widget profileTile(
    BuildContext context, String icon, String title, VoidCallback onPress) {
  return GestureDetector(
    onTap: () => onPress(),
    child: Padding(
      padding: EdgeInsets.symmetric(
          vertical: height(context) * 5, horizontal: width(context) * 5),
      child: Container(
        padding: EdgeInsets.only(
            left: width(context) * 8,
            right: width(context) * 8,
            top: height(context) * 12,
            bottom: height(context) * 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(
            width: height(context) * 0.3,
            color: AppColors.bodyText,
          ),
          borderRadius: BorderRadius.circular(
            height(context) * 5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              child: Image.asset(
                icon,
                height: height(context) * 30,
                color: AppColors.headerText,
              ),
            ),
            TextUtility.titleText(context, title, AppColors.headerText),
            SizedBox(
              child: Image.asset(
                Constants.rightArrow,
                height: height(context) * 32,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
