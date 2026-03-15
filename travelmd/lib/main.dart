import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:travelmd/presentation/routes/app_router.dart';
import 'package:travelmd/presentation/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'TravelMD',
      theme: buildAppTheme(),
      routerConfig: appRouter,
    );
  }
}

