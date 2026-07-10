import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: height(context) * 12, top: height(context) * 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize(context) * 18,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: height(context) * 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: fontSize(context) * 13,
                color: AppColors.bodyText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool showBackButton;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, Color(0xFF6B74E8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              width(context) * 16,
              height(context) * 12,
              width(context) * 20,
              height(context) * 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (showBackButton)
                      Padding(
                        padding: EdgeInsets.only(right: width(context) * 10),
                        child: IconButton(
                          onPressed: () => Navigator.maybePop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          color: AppColors.white,
                          iconSize: height(context) * 22,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          style: IconButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: fontSize(context) * 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height(context) * 6),
                Padding(
                  padding: EdgeInsets.only(left: width(context) * 30),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: fontSize(context) * 14,
                      color: AppColors.white.withValues(alpha: 0.92),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
