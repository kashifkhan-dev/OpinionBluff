import 'package:flutter/material.dart';
import 'package:opinion_bluff/domain/repositories/review_repository.dart';
import 'package:opinion_bluff/data/repositories/review_repository_impl.dart';
import 'package:provider/provider.dart';
import 'package:opinion_bluff/core/routing/app_router.dart';
import 'package:opinion_bluff/presentation/viewmodels/onboarding_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/reveal_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/discussion_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/voting_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/result_provider.dart';

import 'package:opinion_bluff/presentation/viewmodels/subscription_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<IReviewRepository>(create: (_) => ReviewRepositoryImpl()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        ChangeNotifierProvider(create: (_) => GameConfigViewModel()),
        ChangeNotifierProvider(create: (_) => RevealProvider()),
        ChangeNotifierProvider(create: (_) => DiscussionProvider()),
        ChangeNotifierProvider(create: (_) => VotingProvider()),
        ChangeNotifierProvider(create: (_) => ResultProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
        ChangeNotifierProvider(create: (_) => LocaleViewModel()),
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
