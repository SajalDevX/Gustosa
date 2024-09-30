import 'package:flutter/material.dart';

class ColoredButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const ColoredButton(
      {super.key,
        required this.onPressed,
        required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xff2020ED),
            Color(0xffE0055F),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor:
            Colors.transparent, // Make the button background transparent
            foregroundColor: Colors.white,
            elevation: 0, // Remove shadow/elevation
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            text,
            style:
            const TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}