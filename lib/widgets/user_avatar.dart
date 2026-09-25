import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String? imagePath;
  final double size;
  final VoidCallback? onTap;
  final bool showBorder;
  final Color? borderColor;
  final Color? backgroundColor;

  const UserAvatar({
    super.key,
    this.imagePath,
    this.size = 34,
    this.onTap,
    this.showBorder = true,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor =
        borderColor ?? AppColors.primary.withOpacity(0.25);
    final effectiveBgColor =
        backgroundColor ?? AppColors.primaryLight.withOpacity(0.5);

    final hasValidImage = imagePath != null &&
        imagePath!.isNotEmpty &&
        File(imagePath!).existsSync();

    Widget content;
    if (hasValidImage) {
      content = ClipOval(
        child: Image.file(
          File(imagePath!),
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      );
    } else {
      content = Center(
        child: Icon(
          Icons.person_rounded,
          color: AppColors.primary,
          size: size * 0.58,
        ),
      );
    }

    Widget avatarWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: effectiveBgColor,
        shape: BoxShape.circle,
        border: showBorder
            ? Border.all(
                color: effectiveBorderColor,
                width: size > 50 ? 2.5 : 1.5,
              )
            : null,
      ),
      child: content,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarWidget,
      );
    }
    return avatarWidget;
  }
}
