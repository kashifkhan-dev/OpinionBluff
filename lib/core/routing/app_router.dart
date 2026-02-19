import 'package:go_router/go_router.dart';
import 'package:opinion_bluff/presentation/screens/onboarding/welcome_screen.dart';
import 'package:opinion_bluff/presentation/screens/onboarding/preference_screen.dart';
import 'package:opinion_bluff/presentation/screens/onboarding/hype_screen.dart';
import 'package:opinion_bluff/main.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/preference', builder: (context, state) => const PreferenceScreen()),
    GoRoute(path: '/hype', builder: (context, state) => const HypeScreen()),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MyHomePage(title: 'Opinion Bluff'),
    ),
  ],
);
