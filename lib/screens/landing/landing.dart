import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/screens/notification/notifications.dart';
import 'package:room_mates/screens/profile/profile.dart';
import 'package:room_mates/utils/constants.dart';
import 'package:room_mates/utils/strings.dart';
import 'package:room_mates/utils/text_utility.dart';

import '../../utils/colors.dart';
import '../home/home.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int selectedIndex = 1;
  List tabs = [
    const Notifications(),
    const Home(),
    const Profile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: Container(
        height: height(context) * 85,
        color: AppColors.primary,
        padding: EdgeInsets.only(
          left: width(context) * 15,
          right: width(context) * 18,
          bottom: height(context) * 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            bottomTab(
                0, Constants.notification, Strings.notifications, selectedIndex,
                () {
              setState(() {
                selectedIndex = 0;
              });
            }),
            bottomTab(1, Constants.home, Strings.home, selectedIndex, () {
              setState(() {
                selectedIndex = 1;
              });
            }),
            bottomTab(2, Constants.profile, Strings.profile, selectedIndex, () {
              setState(() {
                selectedIndex = 2;
              });
            })
          ],
        ),
      ),
    );
  }

  Widget bottomTab(int index, String icon, String tab, int selectedIndex,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: SizedBox(
        width: width(context) * 100,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(
            icon,
            height: height(context) * 25,
            color:
                selectedIndex == index ? AppColors.white : AppColors.headerText,
          ),
          SizedBox(
            height: height(context) * 4,
          ),
          TextUtility.mediumBodyText(
            context,
            tab,
            selectedIndex == index ? AppColors.white : AppColors.headerText,
          )
        ]),
      ),
    );
  }
}
