import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/screens/home/invite_friend.dart';
import 'package:room_mates/screens/login/login.dart';
import 'package:room_mates/screens/notification/add_notification.dart';
import 'package:room_mates/screens/profile/bloc/profile_bloc.dart';
import 'package:room_mates/screens/profile/bloc/profile_event.dart';
import 'package:room_mates/screens/profile/bloc/profile_state.dart';
import 'package:room_mates/utils/constants.dart';
import 'package:room_mates/utils/text_utility.dart';
import 'package:room_mates/widgets/profile_tile.dart';

import '../../utils/colors.dart';
import '../../utils/shared_prefs.dart';
import '../../utils/strings.dart';
import '../details/details.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileBloc profileBloc;
  Map<String, String?> user = {};

  @override
  void initState() {
    profileBloc = BlocProvider.of<ProfileBloc>(context);
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
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLogoutLoadingState) {
            utils.show(context);
          }
          if (state is ProfileLogoutLoadedState) {
            utils.dismiss(context);
            if (state.isLoggedOut == true) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false,
              );
            }
          }
          if (state is ProfileLogoutErrorState) {
            utils.dismiss(context);
          }
        },
        builder: (context, state) {
          return buildView(context);
        },
      ),
    );
  }

  Widget buildView(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: height(context) * 120,
          ),
          SizedBox(
            child: Image.asset(
              Constants.userProfile,
              color: AppColors.bodyText,
              height: height(context) * 85,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height(context) * 15),
            child: TextUtility.headerText(
                context,
                user[AppConstants.userName] != null
                    ? user[AppConstants.userName]!
                    : Strings.noName,
                AppColors.headerText),
          ),
          Padding(
            padding: EdgeInsets.only(top: height(context) * 5),
            child: TextUtility.titleText(
                context, 'Software Engineer', AppColors.headerText),
          ),
          SizedBox(
            height: height(context) * 35,
          ),
          user[AppConstants.userName] == 'sai kumar'
              ? profileTile(
                  context,
                  Constants.userProfile,
                  Strings.accountDetails,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Details(isFromLogin: false),
                      ),
                    );
                  },
                )
              : Container(),
          user[AppConstants.userName] == 'sai kumar'
              ? profileTile(
                  context,
                  Constants.notification,
                  Strings.addNotification,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddNotification(),
                      ),
                    );
                  },
                )
              : Container(),
          profileTile(
            context,
            Constants.inviteFriend,
            Strings.inviteFriend,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InviteFriend(),
              ),
            ),
          ),
          profileTile(
            context,
            Constants.selectLanguage,
            Strings.selectLanguage,
            () => {},
          ),
          profileTile(
            context,
            Constants.getHelp,
            Strings.getHelp,
            () => {},
          ),
          profileTile(context, Constants.logout, Strings.logout, () async {
            profileBloc.add(ProfileLogoutEvent());
          }),
        ],
      ),
    );
  }
}
