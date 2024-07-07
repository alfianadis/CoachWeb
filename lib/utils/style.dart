import 'package:coach_web/utils/colors.dart';
import 'package:flutter/material.dart';

class PrimaryText extends StatelessWidget {
  final double size;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final double height;

  const PrimaryText({
    required this.text,
    this.fontWeight = FontWeight.w400,
    this.color = AppColors.primary,
    this.size = 20,
    this.height = 1.3,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        height: height,
        fontFamily: 'Poppins',
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}

class AppIcons {
  static const String emailIcon = 'assets/images/EmailIcon.png';
  static const String lockIcon = 'assets/images/lockIcon.png';
  static const String eyeIcon = 'assets/images/EyeIcon.png';
}
