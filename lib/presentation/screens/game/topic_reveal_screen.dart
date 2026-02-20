import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/reveal_provider.dart';
import 'package:opinion_bluff/domain/entities/game_player.dart';

class TopicRevealScreen extends StatelessWidget {
  const TopicRevealScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<RevealProvider>();
    final bool isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      body: Stack(
        children: [
          // Background (Vibrant Purple)
          Positioned.fill(child: Container(color: const Color(0xFF7B1FA2))),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Player Status List (Top Section)
                _buildPlayerStatusList(viewModel, isIPad),

                const Spacer(),

                // Main Reveal Card centerpiece
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        viewModel.activePlayer?.name ?? "...",
                        style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: isIPad ? 600 : 340, maxHeight: isIPad ? 700 : 450),
                        child: const RevealInteractionStack(),
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          viewModel.isSessionRevealed
                              ? "Revealed! Release to hide."
                              : "Hold at the top to reveal your topic.",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // 4 & 5. Correct End Flow: Next Player or Start Discussion
                _buildActionArea(context, viewModel),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerStatusList(RevealProvider viewModel, bool isIPad) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: viewModel.players.length,
        itemBuilder: (context, index) {
          final player = viewModel.players[index];
          final isCurrent = viewModel.activePlayerIndex == index;

          return GestureDetector(
            onTap: () => viewModel.setActivePlayer(index),
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrent ? Colors.white.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                      border: Border.all(color: isCurrent ? Colors.white : Colors.white24, width: isCurrent ? 2 : 1),
                    ),
                    child: Center(
                      child: player.isRevealed
                          ? const Icon(Icons.check_circle, color: Color(0xFF34C759), size: 24)
                          : Text(
                              player.name[0].toUpperCase(),
                              style: TextStyle(
                                color: isCurrent ? Colors.white : Colors.white38,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    player.name,
                    style: TextStyle(
                      color: isCurrent ? Colors.white : Colors.white38,
                      fontSize: 12,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionArea(BuildContext context, RevealProvider viewModel) {
    // Only show button if currently active player has revealed (permanently or session)
    // Actually, user says: "Reveal Last Player -> Primary button changes to 'Start Discussion'"

    // Check if current player is revealed
    final bool currentRevealed = viewModel.activePlayer?.isRevealed ?? false;
    if (!currentRevealed) return const SizedBox(height: 60);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: CNButton(
          label: viewModel.allPlayersRevealed ? 'Start Discussion' : 'Next Player',
          config: CNButtonConfig(style: CNButtonStyle.prominentGlass),
          onPressed: () {
            if (viewModel.allPlayersRevealed) {
              context.go('/timer');
            } else {
              viewModel.nextPlayer();
            }
          },
        ),
      ),
    );
  }
}

class RevealInteractionStack extends StatefulWidget {
  const RevealInteractionStack({super.key});

  @override
  State<RevealInteractionStack> createState() => _RevealInteractionStackState();
}

class _RevealInteractionStackState extends State<RevealInteractionStack> with SingleTickerProviderStateMixin {
  late AnimationController _springController;
  final ValueNotifier<double> _dragOffset = ValueNotifier<double>(0.0);

  final double _maxDrag = 180.0;
  final double _triggerThreshold = 175.0;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(vsync: this);
  }

  @override
  void didUpdateWidget(covariant RevealInteractionStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _springController.stop();
    _dragOffset.value = 0.0;
  }

  @override
  void dispose() {
    _springController.dispose();
    _dragOffset.dispose();
    super.dispose();
  }

  void _runSpringAnimation(double startValue, double endValue, double pixelsPerSecond) {
    _springController.stop();
    final simulation = SpringSimulation(
      const SpringDescription(mass: 1, stiffness: 350, damping: 20),
      startValue,
      endValue,
      pixelsPerSecond,
    );
    _springController.animateWith(simulation);
    _springController.addListener(() {
      _dragOffset.value = _springController.value;
    });
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final revealProvider = context.read<RevealProvider>();
    if (_springController.isAnimating) _springController.stop();

    _dragOffset.value = (_dragOffset.value + details.delta.dy).clamp(-_maxDrag, 0.0);

    if (_dragOffset.value.abs() >= _triggerThreshold) {
      if (!revealProvider.isSessionRevealed) {
        revealProvider.startLoading();
      }
    } else {
      revealProvider.cancelLoading();
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final revealProvider = context.read<RevealProvider>();

    // 4. Topic Visibility Rule: Always hide and reset loading on release
    revealProvider.cancelLoading();
    _runSpringAnimation(_dragOffset.value, 0.0, details.velocity.pixelsPerSecond.dy);
  }

  @override
  Widget build(BuildContext context) {
    final revealProvider = context.watch<RevealProvider>();
    final player = revealProvider.activePlayer;

    if (player == null) return const SizedBox.shrink();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Bottom Card
        Positioned.fill(child: _buildBottomCard(revealProvider, player)),

        // 3. Draggable Front Card
        ValueListenableBuilder<double>(
          valueListenable: _dragOffset,
          builder: (context, offset, child) {
            double dragPercent = (offset / _maxDrag).abs();
            double rotation = (-3 * dragPercent) * (pi / 180);

            return Transform(
              transform: Matrix4.translationValues(0.0, offset, 0.0)..rotateZ(rotation),
              alignment: Alignment.center,
              child: GestureDetector(
                onVerticalDragUpdate: _onVerticalDragUpdate,
                onVerticalDragEnd: _onVerticalDragEnd,
                child: _buildFrontCard(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomCard(RevealProvider revealProvider, GamePlayer player) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white, width: 4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, // 1. Bottom-aligned layout
            children: [
              SizedBox(
                height: 180, // Occupies lower ~40% of standard card height (450 * 0.4 = 180)
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: revealProvider.isSessionRevealed
                      ? _buildRevealedContent(player)
                      : _buildInteractionLayer(revealProvider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInteractionLayer(RevealProvider revealProvider) {
    return Column(
      key: const ValueKey('interaction'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (revealProvider.isLoading) ...[
          CircularProgressIndicator(
            value: revealProvider.progress,
            strokeWidth: 8,
            color: Colors.white,
            backgroundColor: Colors.white10,
          ),
          const SizedBox(height: 16),
          const Text(
            "REVEALING...",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ] else ...[
          const Icon(Icons.lock_outline, color: Colors.white24, size: 48),
          const SizedBox(height: 8),
          const Text(
            "LOCKED",
            style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ],
    );
  }

  Widget _buildRevealedContent(GamePlayer player) {
    return Column(
      key: const ValueKey('revealed'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "SECRET TOPIC:",
          style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Text(
          "\"${player.topic}\"",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1.2),
        ),
        if (player.isBluffer) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
            ),
            child: const Text(
              "BLUFF: Defend this strictly.",
              style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFrontCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3C),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 20, offset: Offset(0, 10))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/detective_spy.png',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.85)],
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white, size: 32),
                    Text(
                      "Hold at top",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
