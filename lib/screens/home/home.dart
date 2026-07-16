import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/screens/home/food_menu.dart';
import 'package:room_mates/screens/home/rent_payments.dart';
import 'package:room_mates/screens/home/service_requests.dart';
import 'package:room_mates/screens/home/specifications.dart';
import 'package:room_mates/utils/shared_prefs.dart';
import 'package:room_mates/widgets/home_card.dart';
import 'package:room_mates/widgets/profile_avatar.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';

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
    if (!mounted) return;
    setState(() {
      user = userDetails;
    });
  }

  String get _userName => user[AppConstants.userName] ?? '';
  String? get _avatarUrl => user[AppConstants.profileUrl];
  String get _hostelName => user[AppConstants.hostelName] ?? '';

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  width(context) * 16,
                  height(context) * 16,
                  width(context) * 16,
                  height(context) * 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height(context) * 12),
                    Expanded(
                      child: GridView.count(
                        physics: const BouncingScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: height(context) * 12,
                        crossAxisSpacing: width(context) * 12,
                        childAspectRatio: 1.0,
                        children: [
                          homeCard(
                            context,
                            Strings.specifications,
                            Constants.specifications,
                            () => _open(const Specificatons()),
                            subtitle: Strings.specsCardHint,
                          ),
                          homeCard(
                            context,
                            Strings.foodMenu,
                            Constants.foodMenu,
                            () => _open(const FoodMenu()),
                            subtitle: Strings.foodCardHint,
                          ),
                          homeCard(
                            context,
                            Strings.rentPayments,
                            Constants.myStay,
                            () => _open(const RentPaymentsScreen()),
                            subtitle: Strings.rentCardHint,
                          ),
                          homeCard(
                            context,
                            Strings.serviceRequests,
                            Constants.getHelp,
                            () => _open(const ServiceRequestsScreen()),
                            subtitle: Strings.serviceCardHint,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            width(context) * 20,
            height(context) * 14,
            width(context) * 20,
            height(context) * 22,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ProfileAvatar(
                    imageUrl: _avatarUrl,
                    size: height(context) * 52,
                    backgroundColor: AppColors.white.withValues(alpha: 0.18),
                    iconColor: AppColors.white,
                    borderColor: AppColors.white.withValues(alpha: 0.45),
                    borderWidth: 1.5,
                  ),
                  SizedBox(width: width(context) * 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Strings.welcomeGreeting,
                          style: TextStyle(
                            color: AppColors.mutedOnPrimary,
                            fontSize: fontSize(context) * 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: height(context) * 4),
                        Text(
                          _userName.isNotEmpty ? _userName : Strings.home,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: fontSize(context) * 22,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (_hostelName.isNotEmpty) ...[
                SizedBox(height: height(context) * 14),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width(context) * 12,
                    vertical: height(context) * 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.apartment_rounded,
                        color: AppColors.white,
                        size: height(context) * 18,
                      ),
                      SizedBox(width: width(context) * 8),
                      Flexible(
                        child: Text(
                          _hostelName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: fontSize(context) * 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
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
