import 'package:room_mates/model/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

class AppLocalPrefs {
  static Future<void> setUserDetails({
    required String uid,
    required String displayName,
    required String email,
    String? photoURL,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.uid, uid);
    await prefs.setString(AppConstants.userName, displayName);
    await prefs.setString(AppConstants.token, uid);
    await prefs.setString(AppConstants.profileUrl, photoURL ?? '');
    await prefs.setString(AppConstants.email, email);
  }

  static Future<void> setProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.profileToken, profile.id);
    await prefs.setString(AppConstants.userName, profile.fullName);
    await prefs.setString(AppConstants.email, profile.email);
    await prefs.setString(AppConstants.jobTitle, profile.jobTitle ?? '');
    await prefs.setString(AppConstants.hostelId, profile.hostelId);
    await prefs.setString(AppConstants.hostelName, profile.hostelName);
    await prefs.setString(AppConstants.isAdmin, profile.isAdmin.toString());
    await prefs.setBool(AppConstants.isFilled, true);
  }

  static Future<Map<String, String?>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      AppConstants.userName: prefs.getString(AppConstants.userName),
      AppConstants.uid: prefs.getString(AppConstants.uid),
      AppConstants.token: prefs.getString(AppConstants.token),
      AppConstants.profileUrl: prefs.getString(AppConstants.profileUrl),
      AppConstants.email: prefs.getString(AppConstants.email),
      AppConstants.jobTitle: prefs.getString(AppConstants.jobTitle),
      AppConstants.hostelId: prefs.getString(AppConstants.hostelId),
      AppConstants.hostelName: prefs.getString(AppConstants.hostelName),
    };
  }

  static Future<bool> isAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.isAdmin) == 'true';
  }

  static Future<String?> getHostelId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.hostelId);
  }

  static Future<String?> getHostelName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.hostelName);
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
