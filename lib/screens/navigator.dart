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
  bool hasProfileToken = false;

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    try {
      String? userId = await AppLocalPrefs.getUserId();
      String? profileToken = await AppLocalPrefs.getProfileToken();

      setState(() {
        isLogged = userId != null && userId.isNotEmpty;
        hasProfileToken = profileToken != null && profileToken.isNotEmpty;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      debugPrint("Error fetching user data: $error");
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

    return hasProfileToken ? const Landing() : const Details(isFromLogin: true);
  }
}
