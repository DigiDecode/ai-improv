import 'package:flutter/material.dart';
import 'dart:js_interop';

@JS('window.open')
external JSAny openUrl(String url, String target);

// Make this a global variable to persist across page changes
bool _isNavigationExpanded = false;

class SideNavigation extends StatefulWidget {
  final Widget body;
  final String title;

  const SideNavigation({super.key, required this.body, required this.title});

  @override
  State<SideNavigation> createState() => _SideNavigationState();
}

class _SideNavigationState extends State<SideNavigation> {
  @override
  Widget build(BuildContext context) {
    final navBackgroundColor = Theme.of(context).primaryColorDark;
    final contentBackgroundColor = Theme.of(context).highlightColor;

    return Scaffold(
      appBar: AppBar(
        title: Row(children: [Text(widget.title)]),
        // Custom leading widget that spans the full nav width when expanded
        leading: Container(
          width: _isNavigationExpanded ? 200 : 55,
          color: navBackgroundColor,
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  _isNavigationExpanded = !_isNavigationExpanded;
                });
              },
            ),
          ),
        ),
        leadingWidth: _isNavigationExpanded ? 200 : 55, // Match nav width
        actions: [
          // New "How it works?" button
          TextButton(
            onPressed: () {
              openUrl('https://youtu.be/buXTk-90NoI', '_blank');
            },
            child: const Text('How it works?'),
          ),
        ],
      ),
      body: Row(
        children: [
          // Side navigation - removed animation for instant transition
          Container(
            width: _isNavigationExpanded ? 200 : 55,
            color: navBackgroundColor,
            child: Column(
              children: [
                _buildNavItem(
                  Icons.home,
                  'Home',
                  '/home',
                  contentBackgroundColor,
                ),
                _buildNavItem(
                  Icons.people,
                  'Characters',
                  '/characters',
                  contentBackgroundColor,
                ),
                _buildNavItem(
                  Icons.chat,
                  'Chat Proviers',
                  '/chatproviders',
                  contentBackgroundColor,
                ),
                _buildNavItem(
                  Icons.record_voice_over,
                  'TTS Providers',
                  '/ttsproviders',
                  contentBackgroundColor,
                ),
              ],
            ),
          ),
          // Content area
          Expanded(child: widget.body),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label,
    String route,
    Color contentColor,
  ) {
    final bool isSelected = ModalRoute.of(context)?.settings.name == route;
    final primaryColor = Theme.of(context).appBarTheme.foregroundColor;

    if (_isNavigationExpanded) {
      // Expanded view - standard ListTile with icon and text
      return Container(
        // Use content background color for selected items to create tab effect
        color: isSelected ? contentColor : null,
        child: ListTile(
          leading: Icon(icon, color: isSelected ? primaryColor : null),
          title: Text(
            label,
            style: TextStyle(
              color: isSelected ? primaryColor : null,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != route) {
              Navigator.pushReplacementNamed(context, route);
            }
          },
        ),
      );
    } else {
      // Minimized view - centered icon
      return Container(
        // Use content background color for selected items to create tab effect
        color: isSelected ? contentColor : null,
        child: InkWell(
          onTap: () {
            if (ModalRoute.of(context)?.settings.name != route) {
              Navigator.pushReplacementNamed(context, route);
            }
          },
          child: SizedBox(
            height: 48, // Standard height for consistency with ListTile
            child: Center(
              child: Icon(icon, color: isSelected ? primaryColor : null),
            ),
          ),
        ),
      );
    }
  }
}
