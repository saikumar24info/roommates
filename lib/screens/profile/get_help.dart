import 'package:flutter/material.dart';
import 'package:room_mates/global.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class GetHelpScreen extends StatelessWidget {
  const GetHelpScreen({super.key});

  Future<void> _launch(BuildContext context, Uri uri) async {
    try {
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open this action')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open this action')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: false,
        leading: IconButton(
          color: AppColors.white,
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, size: height(context) * 26),
        ),
        title: Text(
          Strings.getHelp,
          style: TextStyle(
            fontSize: fontSize(context) * 20,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(width(context) * 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(width(context) * 18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.support,
                    style: TextStyle(
                      fontSize: fontSize(context) * 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.headerText,
                    ),
                  ),
                  SizedBox(height: height(context) * 8),
                  Text(
                    Strings.helpSubtitle,
                    style: TextStyle(
                      fontSize: fontSize(context) * 14,
                      color: AppColors.bodyText,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height(context) * 16),
            _actionCard(
              context,
              icon: Icons.email_outlined,
              title: Strings.emailSupport,
              subtitle: Strings.supportEmail,
              onTap: () => _launch(
                context,
                Uri(
                  scheme: 'mailto',
                  path: Strings.supportEmail,
                  query: 'subject=RoomMates Support',
                ),
              ),
            ),
            _actionCard(
              context,
              icon: Icons.phone_outlined,
              title: Strings.callSupport,
              subtitle: Strings.supportPhone,
              onTap: () => _launch(
                context,
                Uri(scheme: 'tel', path: Strings.supportPhone.replaceAll(' ', '')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: height(context) * 10),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width(context) * 14,
                vertical: height(context) * 14,
              ),
              child: Row(
                children: [
                  Container(
                    height: height(context) * 44,
                    width: height(context) * 44,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppColors.primary),
                  ),
                  SizedBox(width: width(context) * 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: fontSize(context) * 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.headerText,
                          ),
                        ),
                        SizedBox(height: height(context) * 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: fontSize(context) * 13,
                            color: AppColors.bodyText,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.navInactive,
                    size: height(context) * 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
