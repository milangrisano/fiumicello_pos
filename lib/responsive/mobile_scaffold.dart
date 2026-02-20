import 'package:flutter/material.dart';
import 'package:responsive_app/shared/custom_drawer_header.dart';
import 'package:responsive_app/shared/drawer_list_tile.dart';
import 'package:responsive_app/page/landing_page.dart';

class MobileScaffold extends StatelessWidget {
  const MobileScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const Drawer(
        backgroundColor: Color(0xFF2C2C2C),
        child: Column(
          children: [
            CustomDrawerHeader(),
            DrawerListTile(
              icon: Icons.home,
              name: Text('Home', style: TextStyle(color: Colors.white)),
            ),
            DrawerListTile(
              icon: Icons.people,
              name: Text('About', style: TextStyle(color: Colors.white)),
            ),
            DrawerListTile(
              icon: Icons.money,
              name: Text('Pricing', style: TextStyle(color: Colors.white)),
            ),
            DrawerListTile(
              icon: Icons.mail_outline_outlined,
              name: Text('Contact', style: TextStyle(color: Colors.white)),
            ),
            DrawerListTile(
              icon: Icons.location_on,
              name: Text('Location', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
      body: const LandingPage(),
    );
  }
}
