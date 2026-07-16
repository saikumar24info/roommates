import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/constants.dart';

import '../utils/colors.dart';

Widget profileTile(
  BuildContext context,
  String icon,
  String title,
  VoidCallback onPress, {
  bool isDestructive = false,
}) {
  final Color accent =
      isDestructive ? AppColors.red : AppColors.primary;
  final Color iconBg = isDestructive
      ? AppColors.red.withValues(alpha: 0.1)
      : AppColors.primarySoft;

  return Padding(
    padding: EdgeInsets.only(bottom: height(context) * 10),
    child: Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        onTap: onPress,
        borderRadius: BorderRadius.circular(14),
        splashColor: iconBg,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width(context) * 14,
              vertical: height(context) * 14,
            ),
            child: Row(
              children: [
                Container(
                  height: height(context) * 40,
                  width: height(context) * 40,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    icon,
                    height: height(context) * 20,
                    color: accent,
                  ),
                ),
                SizedBox(width: width(context) * 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isDestructive
                          ? AppColors.red
                          : AppColors.headerText,
                      fontSize: fontSize(context) * 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Image.asset(
                  Constants.rightArrow,
                  height: height(context) * 18,
                  color: AppColors.navInactive,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
