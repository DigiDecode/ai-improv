// app_drawer.dart
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).primaryColor, // Use your app's theme color
            ),
            child: SizedBox(
              width: double.infinity,
              child: Text(
                'AI Improv',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              Navigator.pushNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Characters'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/characters');
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Situations'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/situations');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
