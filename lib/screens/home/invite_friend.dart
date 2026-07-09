import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../global.dart';
import '../../utils/colors.dart';
import '../../utils/strings.dart';
import '../../utils/text_utility.dart';

class InviteFriend extends StatefulWidget {
  const InviteFriend({super.key});

  @override
  State<InviteFriend> createState() => _InviteFriendState();
}

class _InviteFriendState extends State<InviteFriend> {
  void shareLink() {
    Share.share('www.google.com', subject: 'Room Mates app');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: false,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back,
              size: height(context) * 30,
            )),
        title: TextUtility.headerText(
            context, Strings.inviteFriend, AppColors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: width(context) * 15, vertical: height(context) * 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextUtility.headerText(
                context,
                Strings.inviteFriend,
                AppColors.headerText,
              ),
              const SizedBox(height: 20.0),
              TextUtility.subTitleText(
                  context, Strings.shareAppTitle, AppColors.headerText,
                  maxLines: 3),
              const SizedBox(height: 15.0),
              TextUtility.subTitleText(
                  context, Strings.tokenOfAppreciation, AppColors.headerText,
                  maxLines: 3),
              const SizedBox(height: 35.0),
              TextUtility.headerText(
                  context, Strings.howItWorks, AppColors.headerText,
                  maxLines: 3),
              const SizedBox(height: 10.0),
              TextUtility.subTitleText(
                  context, Strings.workFlow, AppColors.headerText,
                  maxLines: 8),
              const SizedBox(height: 50.0),
              ElevatedButton.icon(
                onPressed: shareLink,
                icon: const Icon(Icons.share),
                label: TextUtility.headerText(
                    context, Strings.inviteNow, AppColors.white),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                      vertical: height(context) * 18,
                      horizontal: width(context) * 28),
                ),
              ),
              const SizedBox(height: 30.0),
              TextUtility.mediumBodyText(
                  context, Strings.thankYouMessage, AppColors.headerText),
            ],
          ),
        ),
      ),
    );
  }
}
