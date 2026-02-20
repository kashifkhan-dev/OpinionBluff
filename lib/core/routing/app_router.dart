import 'package:go_router/go_router.dart';
import 'package:opinion_bluff/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:opinion_bluff/presentation/screens/home/main_scaffold.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/home', builder: (context, state) => const MainScaffold()),
  ],
);
