import 'package:flutter/material.dart';

class MobileScaffold extends StatelessWidget {
  final String? category;
  final Widget? body;
  const MobileScaffold({super.key, this.category, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Mobile Scaffold'),
      ),
    );
  }
}
