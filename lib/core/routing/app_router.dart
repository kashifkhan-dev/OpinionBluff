import 'package:go_router/go_router.dart';
import 'package:opinion_bluff/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:opinion_bluff/presentation/screens/home/main_scaffold.dart';
import 'package:opinion_bluff/presentation/screens/game/topic_reveal_screen.dart';
import 'package:opinion_bluff/presentation/screens/game/discussion_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/home', builder: (context, state) => const MainScaffold()),
    GoRoute(path: '/reveal', builder: (context, state) => const TopicRevealScreen()),
    GoRoute(path: '/timer', builder: (context, state) => const DiscussionScreen()),
  ],
);
