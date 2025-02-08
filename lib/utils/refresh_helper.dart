import 'package:ein_ecommerce/constants/app_colors.dart';
import 'package:flutter/material.dart';

class RefreshHelper extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;

  const RefreshHelper({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      displacement: 20,
      color: color ?? AppColors.primary,
      backgroundColor: backgroundColor ?? Colors.white,
      child: child,
    );
  }
}
