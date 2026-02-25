import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTextStyles {
  // Headings
  static TextStyle w500({
    double fontSize = 14, 
    Color color = Colors.white,
    double? height,
    }) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
    color: color,
    height: height,
  );

  static TextStyle pageTitle({
    double fontSize = 14,
    Color color = Colors.white,
    double? height,
    }) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.w300,
    color: color,
    height: height,
  ); 

  static TextStyle text({
    double fontSize = 14,
    Color color = Colors.white,
    double? height,
    }) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.normal,
    color: color,
    height: height,
  );

  static TextStyle bold({
    double fontSize = 14,
    Color color = Colors.white,
    double? height,
    }) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
    color: color,
    height: height,
  );

}
