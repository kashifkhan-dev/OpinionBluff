import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/discussion_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/reveal_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';

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
          Positioned.fill(child: Container(color: const Color(0xFF7B1FA2))),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildHeader(),
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

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          'Discussion',
          style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 4),
        Text(
          'Defend your opinion!',
          style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
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
    if (!viewModel.allCompleted) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: CNButton(
          label: 'Proceed to Voting',
          config: CNButtonConfig(style: CNButtonStyle.prominentGlass),
          onPressed: () {
            // Future navigation
          },
        ),
      ),
    );
  }
}

class DiscussionPlayerCard extends StatefulWidget {
  final DiscussionPlayer player;
  final int totalDurationSeconds;

  const DiscussionPlayerCard({super.key, required this.player, required this.totalDurationSeconds});

  @override
  State<DiscussionPlayerCard> createState() => _DiscussionPlayerCardState();
}

class _DiscussionPlayerCardState extends State<DiscussionPlayerCard> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.totalDurationSeconds),
    );

    if (widget.player.isActive) {
      _progressController.forward(from: widget.player.progress);
    }
  }

  @override
  void didUpdateWidget(covariant DiscussionPlayerCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Sync duration if it changed
    if (oldWidget.totalDurationSeconds != widget.totalDurationSeconds) {
      _progressController.duration = Duration(seconds: widget.totalDurationSeconds);
    }

    if (widget.player.isActive) {
      if (!_progressController.isAnimating) {
        // Start or resume
        _progressController.forward(from: widget.player.progress);
      }
    } else {
      if (_progressController.isAnimating) {
        _progressController.stop();
      }
      if (widget.player.hasCompleted) {
        _progressController.value = 1.0;
      } else {
        _progressController.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.player.isActive;
    final bool isCompleted = widget.player.hasCompleted;
    final viewModel = context.read<DiscussionProvider>();

    return GestureDetector(
      onTap: () => viewModel.selectPlayer(widget.player.index),
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
                            widget.player.name[0].toUpperCase(),
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
                        widget.player.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: isActive ? FontWeight.w900 : FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      _buildStatusLabel(),
                    ],
                  ),
                ),
                if (isActive)
                  CNButton(
                    label: 'Skip',
                    config: CNButtonConfig(
                      style: CNButtonStyle.prominentGlass,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onPressed: () => viewModel.skip(),
                  ),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 16),
              AnimatedBuilder(
                animation: _progressController,
                builder: (context, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _progressController.value,
                      minHeight: 6,
                      backgroundColor: Colors.white10,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusLabel() {
    String text = 'Waiting';
    Color color = Colors.white38;

    if (widget.player.isActive) {
      text = 'Discussing';
      color = const Color(0xFF34C759);
    } else if (widget.player.hasCompleted) {
      text = 'Completed';
      color = Colors.white60;
    }

    return Text(
      text,
      style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold),
    );
  }
}
