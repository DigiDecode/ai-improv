import 'package:flutter/material.dart';

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
    final navBackgroundColor = Theme.of(context).primaryColor.withOpacity(0.1);
    // The main content background color - typically white or Theme.of(context).scaffoldBackgroundColor
    final contentBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // Add background color to the leading icon button
        leading: Container(
          color: navBackgroundColor,
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
      body: Row(
        children: [
          // Side navigation - removed animation for instant transition
          Container(
            width: _isNavigationExpanded ? 200 : 55,
            color: navBackgroundColor,
            child: Column(
              children: [
                SizedBox(height: 16),
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
                  Icons.assignment,
                  'Situations',
                  '/situations',
                  contentBackgroundColor,
                ),
                _buildNavItem(
                  Icons.settings,
                  'Settings',
                  '/settings',
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
    final primaryColor = Theme.of(context).primaryColor;

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
            height: 56, // Standard height for consistency with ListTile
            child: Center(
              child: Icon(icon, color: isSelected ? primaryColor : null),
            ),
          ),
        ),
      );
    }
  }
}
