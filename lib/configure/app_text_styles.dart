import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle text({
    double fontSize = 14,
    Color color = Colors.white,
    FontWeight weight = FontWeight.w400,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
  }) {
    return GoogleFonts.outfit(
      fontSize: fontSize,
      color: color,
      fontWeight: weight,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  static TextStyle w500({
    double fontSize = 14,
    Color color = Colors.white,
    double? height,
  }) =>
      GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: color,
        height: height,
      );

  static TextStyle pageTitle({
    double fontSize = 14,
    Color color = Colors.white,
    double? height,
  }) =>
      GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: FontWeight.w300,
        color: color,
        height: height,
      );

  static TextStyle bold({
    double fontSize = 14,
    Color color = Colors.white,
    double? height,
  }) =>
      GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        height: height,
      );
}
