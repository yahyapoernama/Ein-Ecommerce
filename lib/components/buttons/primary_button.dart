import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? textSize;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.black12,
    this.foregroundColor = Colors.white,
    this.textSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(backgroundColor),
        foregroundColor: WidgetStateProperty.all(foregroundColor),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 10, vertical: 5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: textSize,
        ),
      ),
    );
  }
}
