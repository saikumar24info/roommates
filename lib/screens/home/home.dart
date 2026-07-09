import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/screens/home/food_menu.dart';
import 'package:room_mates/screens/home/invite_friend.dart';
import 'package:room_mates/screens/home/my_stay.dart';
import 'package:room_mates/screens/home/specifications.dart';
import 'package:room_mates/utils/shared_prefs.dart';
import 'package:room_mates/widgets/home_card.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';
import '../../utils/text_utility.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, String?> user = {};
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    Map<String, String?> userDetails = await AppLocalPrefs.getUserDetails();
    setState(() {
      user = userDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.primary,
        leading: Padding(
          padding: EdgeInsets.only(left: width(context) * 23),
          child: Image.asset(
            Constants.userProfile,
            color: AppColors.white,
          ),
        ),
        title: TextUtility.headerText(
            context,
            user[AppConstants.userName] != null
                ? Strings.welcome + user[AppConstants.userName]!
                : Strings.welcome,
            AppColors.white),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width(context) * 5, vertical: height(context) * 10),
        child: GridView.count(
          mainAxisSpacing: height(context) * 5,
          crossAxisSpacing: width(context) * 5,
          crossAxisCount: 2,
          shrinkWrap: true,
          children: [
            homeCard(
              context,
              Strings.specifications,
              Constants.specifications,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Specificatons(),
                ),
              ),
            ),
            homeCard(context, Strings.foodMenu, Constants.foodMenu, () async {
              // await hostelManagement.createHostelData();
              // await notificationService.createNotification();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FoodMenu(),
                ),
              );
            }),
            homeCard(
              context,
              Strings.myStay,
              Constants.myStay,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyStay(),
                ),
              ),
            ),
            homeCard(
              context,
              Strings.inviteFriend,
              Constants.invite,
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InviteFriend(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
