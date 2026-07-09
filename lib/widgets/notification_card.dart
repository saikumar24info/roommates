import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/text_utility.dart';

import '../utils/colors.dart';

Widget notificationCard(BuildContext context, String image, String title,
    String time, String description) {
  return Card(
    elevation: 2,
    child: Container(
      decoration: BoxDecoration(
          color: AppColors.white, borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width(context) * 8, vertical: height(context) * 10),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: width(context) * 5, right: height(context) * 15),
              child: SizedBox(
                height: height(context) * 65,
                width: width(context) * 65,
                child: Image.network(
                  image,
                  height: height(context) * 45,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: height(context) * 2),
                    child: TextUtility.headerText(
                        context, title, AppColors.headerText),
                  ),
                  SizedBox(
                    width: width(context) * 320,
                    child: TextUtility.mediumBodyText(
                        context, description, AppColors.bodyText,
                        maxLines: 3),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
