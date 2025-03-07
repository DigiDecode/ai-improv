// base_page.dart
import 'package:flutter/material.dart';

import '../app_drawer.dart';

class BasePage extends StatelessWidget {
  final String title;
  final Widget child;

  const BasePage({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: AppDrawer(),
      body: child,
    );
  }
}
