import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Color? buttonColor, textColor, borderColor;
  final String text;
  final double? height, width;
  final Widget? icon;

  const AppButton({
    Key? key,
    this.onTap,
    required this.text,
    this.buttonColor,
    this.textColor,
    this.height,
    this.width,
    this.icon,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: buttonColor ?? const Color(0xff000000),
          border: Border.all(
            color: borderColor ?? Colors.transparent,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon ?? const SizedBox(),
                icon != null
                    ? const SizedBox(
                        width: 10,
                      )
                    : const SizedBox(),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
