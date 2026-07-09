import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';
import 'package:room_mates/utils/text_utility.dart';

Widget foodMenuCard(BuildContext context, weekday, String time, String image,
    String title, String description, bool isVeg, int mealIndex) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      mealIndex == 0
          ? Padding(
              padding: EdgeInsets.only(
                  left: width(context) * 5,
                  bottom: height(context) * 5,
                  top: height(context) * 5),
              child: TextUtility.headerText(
                  context, weekday, AppColors.headerText),
            )
          : SizedBox(
              height: height(context) * 10,
            ),
      Card(
        elevation: 1,
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: width(context) * 15, vertical: height(context) * 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height(context) * 6),
              border: Border.all(
                  color: AppColors.primary, width: height(context) * 0.5)),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: width(context) * 25,
                child: ClipOval(child: Image.network(image)),
              ),
              SizedBox(
                width: width(context) * 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: width(context) * 3),
                          padding: EdgeInsets.all(height(context) * 3),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: isVeg ? Colors.green : Colors.red),
                              borderRadius:
                                  BorderRadius.circular(width(context) * 0.8)),
                          child: CircleAvatar(
                              radius: width(context) * 4,
                              backgroundColor:
                                  isVeg ? Colors.green : Colors.red),
                        ),
                        TextUtility.mediumBodyText(
                            context,
                            isVeg ? Strings.veg : Strings.nonVeg,
                            AppColors.bodyText)
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: height(context) * 4),
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: height(context) * 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.headerText),
                      ),
                    ),
                    Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: height(context) * 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.bodyText),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
