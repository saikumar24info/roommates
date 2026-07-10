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
import 'package:room_mates/widgets/profile_tile.dart';

import '../../utils/colors.dart';
import '../../utils/shared_prefs.dart';
import '../../utils/strings.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ProfileBloc profileBloc;
  Map<String, String?> user = {};
  bool isAdmin = false;

  @override
  void initState() {
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    final userDetails = await AppLocalPrefs.getUserDetails();
    final admin = await AppLocalPrefs.isAdmin();
    setState(() {
      user = userDetails;
      isAdmin = admin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
    final name = user[AppConstants.userName] ?? Strings.noName;
    final jobTitle = user[AppConstants.jobTitle] ?? 'Resident';
    final hostel = user[AppConstants.hostelName] ?? '';

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(
              width(context) * 20,
              height(context) * 48,
              width(context) * 20,
              height(context) * 28,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, Color(0xFF6B74E8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: height(context) * 42,
                  backgroundColor: AppColors.white.withValues(alpha: 0.2),
                  child: Image.asset(
                    Constants.userProfile,
                    color: AppColors.white,
                    height: height(context) * 50,
                  ),
                ),
                SizedBox(height: height(context) * 14),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: fontSize(context) * 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
                SizedBox(height: height(context) * 4),
                Text(
                  jobTitle,
                  style: TextStyle(
                    fontSize: fontSize(context) * 15,
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
                if (hostel.isNotEmpty) ...[
                  SizedBox(height: height(context) * 4),
                  Text(
                    hostel,
                    style: TextStyle(
                      fontSize: fontSize(context) * 13,
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
                if (isAdmin)
                  Container(
                    margin: EdgeInsets.only(top: height(context) * 10),
                    padding: EdgeInsets.symmetric(
                      horizontal: width(context) * 12,
                      vertical: height(context) * 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: fontSize(context) * 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width(context) * 12,
              vertical: height(context) * 20,
            ),
            child: Column(
              children: [
                if (isAdmin)
                  profileTile(
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
                  ),
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
                  Constants.getHelp,
                  Strings.getHelp,
                  () {},
                ),
                profileTile(
                  context,
                  Constants.logout,
                  Strings.logout,
                  () => profileBloc.add(ProfileLogoutEvent()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
