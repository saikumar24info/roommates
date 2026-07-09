import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/text_utility.dart';

import '../utils/colors.dart';

Widget specificationTile(BuildContext context, String icon, String title) {
  return ListTile(
    leading: SizedBox(
      height: height(context) * 32,
      width: width(context) * 32,
      child: Image.asset(
        icon,
        fit: BoxFit.cover,
      ),
    ),
    title: TextUtility.mediumBodyText(context, title, AppColors.headerText),
  );
}
