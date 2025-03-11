import 'package:ai_improv/pages/providers/home_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_navigator.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => HomeStateProvider())],
      child: const AppNavigator(),
    ),
  );
}
