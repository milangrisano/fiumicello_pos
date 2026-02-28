import 'package:flutter/material.dart';

class TabletScaffold extends StatelessWidget {
  final String? category;
  final Widget? body;
  const TabletScaffold({super.key, this.category, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Text('Tablet Scaffold'),
      ),
    );
  }
}
