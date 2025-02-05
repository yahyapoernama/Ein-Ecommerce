import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHelper extends StatelessWidget {
  final Widget Function(BuildContext context) child;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerHelper({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFF666666),
    this.highlightColor = const Color(0xFF919191),
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: child(context),
    );
  }
}
