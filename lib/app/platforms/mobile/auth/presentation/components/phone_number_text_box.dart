import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextBox extends StatelessWidget {
  final TextInputType keyboardType;
  final int maxLength;
  final double width;
  final String hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final int maxLines;
  final double height;
  final TextEditingController? controller;
  final String? errorText;

  const CustomTextBox({
    super.key,
    this.keyboardType = TextInputType.text,
    this.maxLength = 50,
    required this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.height = 54,
    this.controller,
    this.errorText,
    this.prefixText,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          height: height,
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            inputFormatters: [
              if (keyboardType == TextInputType.number)
                LengthLimitingTextInputFormatter(maxLength),
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.blueGrey),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              prefixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal:16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$prefixText' ?? '',
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              suffixIcon: suffixIcon,
            ),
            style:
            const TextStyle(color: Colors.black, fontSize: 16, height: 1.5),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
      ],
    );
  }
}
