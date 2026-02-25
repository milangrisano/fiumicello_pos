import 'package:flutter/material.dart';
import 'package:responsive_app/page/landing_page.dart';

class TabletScaffold extends StatelessWidget {
  const TabletScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F0E8),
      body: LandingPage(),
    );
  }
}