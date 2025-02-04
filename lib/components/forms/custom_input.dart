import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String inputName;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool withLabel;
  final CrossAxisAlignment alignment;
  final Widget? suffixIcon;

  const CustomInput({
    super.key,
    required this.inputName,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    this.obscureText = false,
    this.validator,
    this.withLabel = false,
    this.alignment = CrossAxisAlignment.start,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        if (withLabel)
        ...[
          Text(
            inputName,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
        ],
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(focusNode);
          },
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            suffixIcon: suffixIcon,
          ),
          obscureText: obscureText,
          obscuringCharacter: '⬤',
          validator: validator,
        ),
      ],
    );
  }
}
