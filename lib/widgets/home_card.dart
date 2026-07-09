import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/text_utility.dart';

import '../utils/colors.dart';

Widget homeCard(
    BuildContext context, String title, String icon, VoidCallback onPress) {
  return GestureDetector(
    onTap: () => onPress(),
    child: Card(
      elevation: 1,
      shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Container(
        height: height(context) * 80,
        width: width(context) * 80,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.1,
            color: AppColors.bodyText,
          ),
          borderRadius: BorderRadiusDirectional.circular(5),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                height: height(context) * 48,
                color: AppColors.primary,
              ),
              Padding(
                padding: EdgeInsets.all(height(context) * 10),
                child:
                    TextUtility.subTitleText(context, title, AppColors.primary),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
