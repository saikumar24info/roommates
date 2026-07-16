import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/screens/notification/notifications.dart';
import 'package:room_mates/screens/profile/profile.dart';
import 'package:room_mates/utils/constants.dart';
import 'package:room_mates/utils/strings.dart';

import '../../utils/colors.dart';
import '../home/home.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int selectedIndex = 1;
  final List tabs = [
    const Notifications(),
    const Home(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: tabs[selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width(context) * 12,
              vertical: height(context) * 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                bottomTab(
                  0,
                  Constants.notification,
                  Strings.notifications,
                  selectedIndex,
                  () => setState(() => selectedIndex = 0),
                ),
                bottomTab(
                  1,
                  Constants.home,
                  Strings.home,
                  selectedIndex,
                  () => setState(() => selectedIndex = 1),
                ),
                bottomTab(
                  2,
                  Constants.profile,
                  Strings.profile,
                  selectedIndex,
                  () => setState(() => selectedIndex = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomTab(
    int index,
    String icon,
    String tab,
    int selectedIndex,
    VoidCallback onTap,
  ) {
    final bool isSelected = selectedIndex == index;
    final Color color =
        isSelected ? AppColors.primary : AppColors.navInactive;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: width(context) * 14,
          vertical: height(context) * 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySoft : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon,
              height: height(context) * 22,
              color: color,
            ),
            SizedBox(height: height(context) * 4),
            Text(
              tab,
              style: TextStyle(
                color: color,
                fontSize: fontSize(context) * 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
