import 'package:flutter/material.dart';
import 'package:room_mates/utils/colors.dart';
import 'package:room_mates/utils/constants.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;
  final double borderWidth;
  final bool showEditBadge;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.size,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
    this.borderWidth = 0,
    this.showEditBadge = false,
    this.onTap,
  });

  bool get _hasImage => imageUrl != null && imageUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final avatar = Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? AppColors.primarySoft,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor ?? AppColors.white,
                width: borderWidth,
              )
            : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: _hasImage
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              width: size,
              height: size,
              errorBuilder: (_, __, ___) => _placeholder(),
            )
          : _placeholder(),
    );

    final content = showEditBadge
        ? Stack(
            clipBehavior: Clip.none,
            children: [
              avatar,
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  height: size * 0.32,
                  width: size * 0.32,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.white, width: 2),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: size * 0.16,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          )
        : avatar;

    if (onTap == null) return content;
    return GestureDetector(onTap: onTap, child: content);
  }

  Widget _placeholder() {
    return Center(
      child: Image.asset(
        Constants.userProfile,
        height: size * 0.45,
        color: iconColor ?? AppColors.primary,
      ),
    );
  }
}
