import 'package:flutter/material.dart';
import 'package:moneyflow/utils/constants/colors.dart';

class AppLogo extends StatelessWidget {
  final Color color;
  final double size;

  const AppLogo({
    super.key,
    this.color = AppColors.primaryColor,
    this.size = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      color: color,
      width: size,
      height: size,
    );
  }
}