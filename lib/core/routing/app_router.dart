import 'package:go_router/go_router.dart';
import 'package:opinion_bluff/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:opinion_bluff/presentation/screens/home/main_scaffold.dart';
import 'package:opinion_bluff/presentation/screens/game/topic_reveal_screen.dart';
import 'package:opinion_bluff/presentation/screens/game/discussion_screen.dart';
import 'package:opinion_bluff/presentation/screens/game/voting_screen.dart';
import 'package:opinion_bluff/presentation/screens/game/result_screen.dart';

import 'package:opinion_bluff/presentation/screens/home/topics_screen.dart';

import 'package:opinion_bluff/presentation/screens/onboarding/how_to_play_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/home', builder: (context, state) => const MainScaffold()),
    GoRoute(path: '/reveal', builder: (context, state) => const TopicRevealScreen()),
    GoRoute(path: '/timer', builder: (context, state) => const DiscussionScreen()),
    GoRoute(path: '/voting', builder: (context, state) => const VotingScreen()),
    GoRoute(path: '/results', builder: (context, state) => const ResultScreen()),
    GoRoute(path: '/topics', builder: (context, state) => const TopicsScreen()),
    GoRoute(path: '/how-to-play', builder: (context, state) => const HowToPlayScreen(isStandalone: true)),
  ],
);
