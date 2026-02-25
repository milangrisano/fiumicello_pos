import 'package:flutter/material.dart';
import 'package:responsive_app/page/landing_page.dart';

class MobileScaffold extends StatelessWidget {
  const MobileScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F0E8),
      body: LandingPage(),
    );
  }
}
