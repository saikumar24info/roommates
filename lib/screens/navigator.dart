import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:room_mates/screens/details/details.dart';
import 'package:room_mates/screens/landing/landing.dart';
import 'package:room_mates/screens/login/login.dart';
import '../utils/colors.dart';
import '../utils/shared_prefs.dart';

class NavigatorScreen extends StatefulWidget {
  const NavigatorScreen({super.key});

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  bool isLogged = false;
  bool isLoading = true;
  bool hasProfile = false;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    try {
      final userId = await AppLocalPrefs.getUserId();
      final filled = await AppLocalPrefs.getIsAccountDetailsFilled();

      setState(() {
        isLogged = userId != null && userId.isNotEmpty;
        hasProfile = filled;
        isLoading = false;
      });
    } catch (error) {
      setState(() => isLoading = false);
      debugPrint('Error fetching user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: SpinKitWave(
            color: AppColors.primary,
            type: SpinKitWaveType.start,
          ),
        ),
      );
    }

    if (!isLogged) {
      return const Login();
    }

    if (!hasProfile) {
      return const Details(isFromLogin: true);
    }

    return const Landing();
  }
}
