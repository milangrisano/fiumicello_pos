import 'package:flutter/material.dart';
import 'package:responsive_app/page/landing_page/landing_page.dart';

class DesktopScaffold extends StatelessWidget {
  final String? category;
  final Widget? body;
  const DesktopScaffold({super.key, this.category, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //NOTA: No esta siendo utilizado, borra en caso de que se decida no usarlo
      // appBar: const _DesktopAppBar(),
      body: body ?? LandingPage(category: category),
    );
  }
}

