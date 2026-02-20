import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_app/page/landing_page.dart'; // Ensure this matches the file path

class DesktopScaffold extends StatelessWidget {
  const DesktopScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        leading: const Icon(Icons.person, color: Color(0xFFD4AF37)), // Gold icon
        title: Text(
          'Fiumicello',
          style: GoogleFonts.greatVibes( // Using a script font if available, or fallback to Outfit
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: const LandingPage(),
    );
  }
}
