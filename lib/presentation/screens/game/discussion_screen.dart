import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/discussion_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/reveal_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final revealProvider = context.read<RevealProvider>();
      final configViewModel = context.read<GameConfigViewModel>();
      context.read<DiscussionProvider>().initialize(revealProvider.players, configViewModel.duration);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DiscussionProvider>();
    final bool isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF070421), Color(0xFF000000)],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(context),
                const SizedBox(height: 20),
                Expanded(child: _buildPlayerGrid(viewModel, isIPad)),
                _buildActionArea(context, viewModel),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final l10n = context.watch<LocaleViewModel>().l10n;
    return Column(
      children: [
        Text(
          l10n.get('discussion_title'),
          style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.get('defend_opinion_tagline'),
          style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildPlayerGrid(DiscussionProvider viewModel, bool isIPad) {
    if (isIPad) {
      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 2.2,
        ),
        itemCount: viewModel.players.length,
        itemBuilder: (context, index) =>
            DiscussionPlayerCard(player: viewModel.players[index], totalDurationSeconds: viewModel.durationSeconds),
      );
    } else {
      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        itemCount: viewModel.players.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) =>
            DiscussionPlayerCard(player: viewModel.players[index], totalDurationSeconds: viewModel.durationSeconds),
      );
    }
  }

  Widget _buildActionArea(BuildContext context, DiscussionProvider viewModel) {
    if (!viewModel.allCompleted) return const SizedBox(height: 60);

    final l10n = context.watch<LocaleViewModel>().l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: CNButton(
          label: l10n.get('proceed_to_voting'),
          config: const CNButtonConfig(style: CNButtonStyle.prominentGlass),
          onPressed: () {
            context.go('/voting');
          },
        ),
      ),
    );
  }
}

class DiscussionPlayerCard extends StatelessWidget {
  final DiscussionPlayer player;
  final int totalDurationSeconds;

  const DiscussionPlayerCard({super.key, required this.player, required this.totalDurationSeconds});

  String _formatTime(double seconds) {
    int total = seconds.toInt();
    int m = total ~/ 60;
    int s = total % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = player.isActive;
    final bool isCompleted = player.hasCompleted;
    final viewModel = context.read<DiscussionProvider>();
    final double progress = player.getProgress(totalDurationSeconds);

    return GestureDetector(
      onTap: () => viewModel.selectPlayer(player.index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isActive ? Colors.white : (isCompleted ? Colors.white24 : Colors.white10),
            width: isActive ? 2 : 1,
          ),
          boxShadow: isActive ? [BoxShadow(color: Colors.white.withValues(alpha: 0.1), blurRadius: 15)] : null,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(color: Colors.white38),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check_circle, color: Color(0xFF34C759), size: 28)
                        : Text(
                            player.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: isActive ? FontWeight.w900 : FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      _buildStatusLabel(context),
                    ],
                  ),
                ),
                if (isActive) ...[
                  Text(
                    '${_formatTime(player.elapsedTime)} / ${_formatTime(totalDurationSeconds.toDouble())}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(width: 12),
                  CNButton(
                    label: context.watch<LocaleViewModel>().l10n.get('skip'),
                    config: const CNButtonConfig(
                      style: CNButtonStyle.prominentGlass,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    onPressed: () => viewModel.skip(),
                  ),
                ],
              ],
            ),
            if (isActive || isCompleted) ...[
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.white10,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusLabel(BuildContext context) {
    final l10n = context.watch<LocaleViewModel>().l10n;
    String text = l10n.get('waiting');
    Color color = Colors.white38;

    if (player.isActive) {
      text = l10n.get('discussing');
      color = const Color(0xFF34C759);
    } else if (player.hasCompleted) {
      text = l10n.get('completed');
      color = Colors.white60;
    }

    return Text(
      text,
      style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold),
    );
  }
}
