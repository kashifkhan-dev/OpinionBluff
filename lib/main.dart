import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:opinion_bluff/core/routing/app_router.dart';
import 'package:opinion_bluff/presentation/viewmodels/onboarding_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/reveal_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/discussion_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => GameConfigViewModel()),
        ChangeNotifierProvider(create: (_) => RevealProvider()),
        ChangeNotifierProvider(create: (_) => DiscussionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Opinion Bluff',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF2E1A47),
      ),
      routerConfig: appRouter,
    );
  }
}
