import 'package:flutter/material.dart';
import 'package:responsive_app/configure/app_text_styles.dart';

class ButtonCard extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final bool isLoading;
  final double elevation;

  const ButtonCard({
    super.key,
    required this.text,
    this.onPressed,
    this.width = double.infinity,
    this.height = 32,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 11,
    this.fontWeight = FontWeight.w400,
    this.borderRadius = 6,
    this.isLoading = false,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bg =
        backgroundColor ?? Theme.of(context).colorScheme.primaryContainer;
    final txtColor = textColor ?? Theme.of(context).colorScheme.tertiary;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: txtColor,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.zero,
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white70,
                ),
              )
            : Text(
                text,
                style: AppTextStyles.text(
                  fontSize: fontSize,
                  color: txtColor,
                  weight: fontWeight,
                ),
              ),
      ),
    );
  }
}
