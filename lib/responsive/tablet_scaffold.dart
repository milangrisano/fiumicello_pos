import 'package:flutter/material.dart';

class TabletScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Text('Tablet'),
      ),
    );
  }
}
