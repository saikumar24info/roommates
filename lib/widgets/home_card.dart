import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';

import '../utils/colors.dart';

Widget homeCard(
  BuildContext context,
  String title,
  String icon,
  VoidCallback onPress, {
  String? subtitle,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onPress,
      borderRadius: BorderRadius.circular(16),
      splashColor: AppColors.primarySoft,
      highlightColor: AppColors.primarySoft.withValues(alpha: 0.5),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            width(context) * 14,
            height(context) * 14,
            width(context) * 14,
            height(context) * 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height(context) * 80,
                width: width(context) * 80,
                margin: EdgeInsets.only(bottom: height(context) * 20),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  icon,
                  height: height(context) * 40,
                  color: AppColors.primary,
                ),
              ),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.headerText,
                  fontSize: fontSize(context) * 14,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
              if (subtitle != null && subtitle.isNotEmpty) ...[
                SizedBox(height: height(context) * 3),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.bodyText,
                    fontSize: fontSize(context) * 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ),
  );
}
