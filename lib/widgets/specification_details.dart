import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/colors.dart';

Widget specificationDetails(
  BuildContext context,
  String icon,
  String title,
  String description,
) {
  return Container(
    margin: EdgeInsets.only(bottom: height(context) * 10),
    padding: EdgeInsets.symmetric(
      horizontal: width(context) * 14,
      vertical: height(context) * 14,
    ),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: AppColors.primary.withValues(alpha: 0.06),
      ),
      boxShadow: const [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height(context) * 48,
          width: height(context) * 48,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Image.asset(
            icon,
            height: height(context) * 24,
            width: height(context) * 24,
            color: AppColors.primary,
            errorBuilder: (_, __, ___) => Icon(
              Icons.check_circle_outline,
              color: AppColors.primary,
              size: height(context) * 24,
            ),
          ),
        ),
        SizedBox(width: width(context) * 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize(context) * 15,
                  color: AppColors.headerText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: height(context) * 4),
              Text(
                description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize(context) * 13,
                  color: AppColors.bodyText,
                  fontWeight: FontWeight.w400,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
