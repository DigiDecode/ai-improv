import 'package:ai_improv/pages/characters_page.dart';
import 'package:ai_improv/pages/chat_providers_page.dart';
import 'package:ai_improv/pages/home_page.dart';
import 'package:ai_improv/pages/tts_providers_page.dart';
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
            (context) =>
                SideNavigation(title: 'Characters', body: CharactersPage()),
        '/chatproviders':
            (context) => SideNavigation(
              title: 'Chat Providers',
              body: ChatProvidersPage(),
            ),
        '/ttsproviders':
            (context) => SideNavigation(
              title: 'TTS Providers',
              body: TTSProvidersPage(),
            ),
      },
    );
  }
}
