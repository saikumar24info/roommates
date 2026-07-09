import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class AppLocalPrefs {
  static setUserDetails(User? user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.userName, user?.displayName ?? '');
    prefs.setString(AppConstants.uid, user?.uid ?? '');
    prefs.setString(AppConstants.token, user?.refreshToken ?? '');
    prefs.setString(AppConstants.profileUrl, user?.photoURL ?? '');
  }

  static Future<Map<String, String?>> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      AppConstants.userName: prefs.getString(AppConstants.userName),
      AppConstants.uid: prefs.getString(AppConstants.uid),
      AppConstants.token: prefs.getString(AppConstants.token),
      AppConstants.profileUrl: prefs.getString(AppConstants.profileUrl),
    };
  }

  static setProfileToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.profileToken, token!);
  }

  static getProfileToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.profileToken);
  }

  static getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.uid);
  }

  static clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static setIsAccountDetailsFilled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.isFilled, true);
  }

  static Future<bool> getIsAccountDetailsFilled() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(AppConstants.isFilled) ?? false;
  }
}
