import 'package:ai_improv/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'side_navigation.dart';

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    const homePage = HomePage();
    return MaterialApp(
      title: 'AI Improv',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => SideNavigation(title: 'Home', body: homePage),
        '/characters':
            (context) => SideNavigation(
              title: 'Characters',
              body: Center(child: Text('Characters Content')),
            ),
        '/situations':
            (context) => SideNavigation(
              title: 'Situations',
              body: Center(child: Text('Situations Content')),
            ),
        '/settings':
            (context) => SideNavigation(
              title: 'Settings',
              body: Center(child: Text('Settings Content')),
            ),
      },
    );
  }
}
