import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTextStyles {
  // Headings
  static TextStyle header({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
  );

  static TextStyle pageTitle({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.w300,
  );

  static TextStyle sectionTitle({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
  );

  // Body / Content
  static TextStyle body({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
  );

  static TextStyle bodyBold({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
  );

  static TextStyle label({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
  );
  
  static TextStyle labelLarge({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
  );

  static TextStyle labelMuted({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
  );

  // Special
  static TextStyle orderId({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
  );

  static TextStyle price({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
  );

  static TextStyle goldValue({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
  );

  static TextStyle totalValue({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
  );

  static TextStyle buttonText({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
  );

  // Tab Bar (Main Navigation)
  static TextStyle navLabel({double fontSize = 14}) => GoogleFonts.outfit(
    fontWeight: FontWeight.bold,
    fontSize: fontSize,
  );

  static TextStyle navLabelUnselected({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.normal,
  );

  // Filter Tabs (Sub Navigation)
  static TextStyle filterLabel({double fontSize = 14}) => GoogleFonts.outfit(
    fontWeight: FontWeight.bold,
    fontSize: fontSize,
  );

  static TextStyle filterLabelUnselected({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.normal,
  );
}
