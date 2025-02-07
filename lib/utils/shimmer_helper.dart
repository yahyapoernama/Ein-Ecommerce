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

class ShimmerContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final Widget? child;
  final EdgeInsets? margin;

  const ShimmerContainer({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    required this.child,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: child,
    );
  }
}
