import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';

Widget foodMenuCard(
  BuildContext context,
  String weekday,
  String time,
  String image,
  String title,
  String description,
  bool isVeg,
  int mealIndex,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (mealIndex == 0)
        Padding(
          padding: EdgeInsets.only(
            left: width(context) * 4,
            bottom: height(context) * 10,
            top: height(context) * 6,
          ),
          child: Text(
            weekday,
            style: TextStyle(
              fontSize: fontSize(context) * 17,
              fontWeight: FontWeight.w700,
              color: AppColors.headerText,
            ),
          ),
        )
      else
        SizedBox(height: height(context) * 8),
      Container(
        margin: EdgeInsets.only(bottom: height(context) * 4),
        padding: EdgeInsets.all(width(context) * 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.08),
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: height(context) * 64,
                width: height(context) * 64,
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.primarySoft,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.restaurant_outlined,
                      color: AppColors.primary,
                      size: height(context) * 26,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: width(context) * 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width(context) * 8,
                          vertical: height(context) * 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          time,
                          style: TextStyle(
                            fontSize: fontSize(context) * 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: width(context) * 8),
                      Container(
                        padding: EdgeInsets.all(height(context) * 2.5),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isVeg ? AppColors.green : AppColors.red,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: CircleAvatar(
                          radius: width(context) * 3.5,
                          backgroundColor:
                              isVeg ? AppColors.green : AppColors.red,
                        ),
                      ),
                      SizedBox(width: width(context) * 4),
                      Text(
                        isVeg ? Strings.veg : Strings.nonVeg,
                        style: TextStyle(
                          fontSize: fontSize(context) * 11,
                          color: AppColors.bodyText,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height(context) * 6),
                  Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: fontSize(context) * 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.headerText,
                    ),
                  ),
                  SizedBox(height: height(context) * 3),
                  Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: fontSize(context) * 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.bodyText,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
