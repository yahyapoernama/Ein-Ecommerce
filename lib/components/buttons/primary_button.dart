import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? textSize;
  final IconData? icon;
  final EdgeInsets? padding;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFF212121),
    this.foregroundColor = Colors.white,
    this.textSize = 18,
    this.icon,
    this.padding = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
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
      child: icon == null
          ? Text(text, style: TextStyle(fontSize: textSize))
          : Container(
            padding: padding,
            child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon),
                  const SizedBox(width: 10),
                  Text(text, style: TextStyle(fontSize: textSize)),
                ],
              ),
          ),
    );
  }
}
