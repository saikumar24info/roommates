import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/screens/admin/admin_hub.dart';
import 'package:room_mates/screens/home/invite_friend.dart';
import 'package:room_mates/screens/home/my_stay.dart';
import 'package:room_mates/screens/login/login.dart';
import 'package:room_mates/screens/profile/account_details.dart';
import 'package:room_mates/screens/profile/bloc/profile_bloc.dart';
import 'package:room_mates/screens/profile/bloc/profile_event.dart';
import 'package:room_mates/screens/profile/bloc/profile_state.dart';
import 'package:room_mates/screens/profile/get_help.dart';
import 'package:room_mates/utils/app_role.dart';
import 'package:room_mates/utils/constants.dart';
import 'package:room_mates/widgets/profile_avatar.dart';
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
  AppRole role = AppRole.resident;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    final userDetails = await AppLocalPrefs.getUserDetails();
    final userRole = await AppLocalPrefs.getRole();
    if (!mounted) return;
    setState(() {
      user = userDetails;
      role = userRole;
    });
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(Strings.logoutConfirmTitle),
        content: const Text(Strings.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              Strings.cancel,
              style: TextStyle(color: AppColors.bodyText),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              Strings.logout,
              style: TextStyle(color: AppColors.red),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      profileBloc.add(ProfileLogoutEvent());
    }
  }

  Future<void> _showAvatarOptions() async {
    final hasPhoto =
        (user[AppConstants.profileUrl] ?? '').trim().isNotEmpty;

    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width(context) * 8,
              vertical: height(context) * 8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined,
                      color: AppColors.primary),
                  title: const Text(Strings.takePhoto),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndUpload(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined,
                      color: AppColors.primary),
                  title: const Text(Strings.chooseGallery),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAndUpload(ImageSource.gallery);
                  },
                ),
                if (hasPhoto)
                  ListTile(
                    leading: const Icon(Icons.delete_outline,
                        color: AppColors.red),
                    title: const Text(
                      Strings.removePhoto,
                      style: TextStyle(color: AppColors.red),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      profileBloc.add(ProfileRemoveAvatarEvent());
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null) return;
      profileBloc.add(ProfileUploadAvatarEvent(file: File(picked.path)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _open(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page))
        .then((_) => getUserDetails());
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) async {
            if (state is ProfileLogoutLoadingState ||
                state is ProfileAvatarLoadingState) {
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
            if (state is ProfileAvatarLoadedState) {
              utils.dismiss(context);
              await getUserDetails();
              if (!mounted) return;
              final messenger = ScaffoldMessenger.of(context);
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    state.avatarUrl.isEmpty
                        ? Strings.photoRemoved
                        : Strings.photoUpdated,
                  ),
                ),
              );
            }
            if (state is ProfileAvatarErrorState) {
              utils.dismiss(context);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          builder: (context, state) => buildView(context),
        ),
      ),
    );
  }

  Widget buildView(BuildContext context) {
    final name = user[AppConstants.userName] ?? Strings.noName;
    final jobTitle = (user[AppConstants.jobTitle]?.isNotEmpty == true)
        ? user[AppConstants.jobTitle]!
        : Strings.resident;
    final hostel = user[AppConstants.hostelName] ?? '';
    final email = user[AppConstants.email] ?? '';
    final avatarUrl = user[AppConstants.profileUrl];

    return Column(
      children: [
        _buildHeader(name, jobTitle, hostel, email, avatarUrl),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              width(context) * 16,
              height(context) * 18,
              width(context) * 16,
              height(context) * 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel(Strings.accountDetails),
                profileTile(
                  context,
                  Constants.userProfile,
                  Strings.accountDetails,
                  () => _open(const AccountDetailsScreen()),
                ),
                profileTile(
                  context,
                  Constants.myStay,
                  Strings.myStay,
                  () => _open(const MyStay()),
                ),
                SizedBox(height: height(context) * 8),
                if (role.canManageHostel) ...[
                  _sectionLabel(Strings.hostelManagement),
                  profileTile(
                    context,
                    Constants.home,
                    role.isSuperAdmin
                        ? Strings.superAdminConsole
                        : Strings.adminConsole,
                    () => _open(const AdminHub()),
                  ),
                  SizedBox(height: height(context) * 8),
                ],
                _sectionLabel(Strings.support),
                profileTile(
                  context,
                  Constants.inviteFriend,
                  Strings.inviteFriend,
                  () => _open(const InviteFriend()),
                ),
                profileTile(
                  context,
                  Constants.getHelp,
                  Strings.getHelp,
                  () => _open(const GetHelpScreen()),
                ),
                SizedBox(height: height(context) * 8),
                profileTile(
                  context,
                  Constants.logout,
                  Strings.logout,
                  _confirmLogout,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(
        left: width(context) * 4,
        bottom: height(context) * 8,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: fontSize(context) * 13,
          fontWeight: FontWeight.w600,
          color: AppColors.bodyText,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildHeader(
    String name,
    String jobTitle,
    String hostel,
    String email,
    String? avatarUrl,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            width(context) * 20,
            height(context) * 12,
            width(context) * 20,
            height(context) * 24,
          ),
          child: Column(
            children: [
              ProfileAvatar(
                imageUrl: avatarUrl,
                size: height(context) * 84,
                backgroundColor: AppColors.white.withValues(alpha: 0.18),
                iconColor: AppColors.white,
                borderColor: AppColors.white.withValues(alpha: 0.45),
                borderWidth: 2,
                showEditBadge: true,
                onTap: _showAvatarOptions,
              ),
              SizedBox(height: height(context) * 8),
              Text(
                Strings.changePhoto,
                style: TextStyle(
                  color: AppColors.mutedOnPrimary,
                  fontSize: fontSize(context) * 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: height(context) * 10),
              Text(
                name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize(context) * 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: height(context) * 4),
              Text(
                jobTitle,
                style: TextStyle(
                  fontSize: fontSize(context) * 14,
                  color: AppColors.mutedOnPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (email.isNotEmpty) ...[
                SizedBox(height: height(context) * 4),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: fontSize(context) * 13,
                    color: AppColors.mutedOnPrimary,
                  ),
                ),
              ],
              if (hostel.isNotEmpty) ...[
                SizedBox(height: height(context) * 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width(context) * 12,
                    vertical: height(context) * 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    hostel,
                    style: TextStyle(
                      fontSize: fontSize(context) * 12,
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              if (role.canManageHostel) ...[
                SizedBox(height: height(context) * 8),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width(context) * 12,
                    vertical: height(context) * 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    role.label,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: fontSize(context) * 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
