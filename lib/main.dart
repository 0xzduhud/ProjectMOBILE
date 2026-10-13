import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'navigation/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GerakInApp());
}

class GerakInApp extends StatelessWidget {
  const GerakInApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerak.in',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const AppRouter(),
    );
  }
}
