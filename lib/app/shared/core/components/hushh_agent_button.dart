import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HushhLinearGradientButton extends StatelessWidget {
  final String text;
  final bool enabled;
  final IconData? icon;
  final Function() onTap;
  final double? radius;
  final double? height;
  final bool loader;

  const HushhLinearGradientButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.enabled = true,
      this.loader = false,
      this.icon,
      this.radius,
      this.height});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: height,
      child: InkWell(
        onTap: enabled ? onTap : null,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius ?? 43),
              color: enabled ? null : Colors.grey,
              gradient: enabled
                  ? const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                          Color(0xFFA342FF),
                          Color(0xFFE54D60),
                        ])
                  : null),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (icon != null) ...[
                Icon(
                  icon,
                  color: Colors.white,
                ),
                const SizedBox(width: 16),
              ],
              Text(
                text,
                style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
              if (loader) ...[
                const SizedBox(width: 8),
                const CupertinoActivityIndicator(color: Colors.white)
              ]
            ],
          ),
        ),
      ),
    );
  }
}
