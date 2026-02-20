import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppTextStyles {
  // Headings
  static TextStyle w500({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.w500,
  );

  static TextStyle pageTitle({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.w300,
  ); 

  static TextStyle text({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bold({double fontSize = 14}) => GoogleFonts.outfit(
    fontSize: fontSize,
    fontWeight: FontWeight.bold,
  );

}
