import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/reveal_provider.dart';
import 'package:opinion_bluff/domain/entities/game_round.dart';
import 'package:opinion_bluff/data/repositories/opinion_repository.dart';
import 'package:opinion_bluff/presentation/viewmodels/subscription_provider.dart';

class GameConfigScreen extends StatelessWidget {
  const GameConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: isIPad ? 300 : 200,
                    height: isIPad ? 300 : 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.red.withValues(alpha: 0.15), blurRadius: 40, spreadRadius: 10),
                      ],
                    ),
                    child: Image.asset('assets/images/detective_spy.png', fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Opinion Bluff',
                    style: TextStyle(
                      color: const Color(0xFFFF3B30),
                      fontSize: isIPad ? 52 : 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      shadows: [Shadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 8)],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Unlock Banner
            _buildUnlockBanner(context),
            const SizedBox(height: 16),

            // Settings Cards
            _buildSettingsSection(context),
            const SizedBox(height: 24),

            // Start Game Button
            _buildStartGameButton(context),
            const SizedBox(height: 120), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockBanner(BuildContext context) {
    final subProvider = context.watch<SubscriptionProvider>();
    final isSubscribed = subProvider.isSubscribed;

    return GestureDetector(
      onTap: () => _showSubscriptionDialog(context),
      child: LiquidGlassContainer(
        config: LiquidGlassConfig(effect: CNGlassEffect.prominent, cornerRadius: 22, shape: CNGlassEffectShape.rect),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isSubscribed
                  ? [const Color(0xFF34C759), const Color(0xFF30D158)]
                  : [const Color(0xFF00C7FF), const Color(0xFF007AFF)],
            ),
            boxShadow: [
              BoxShadow(
                color: (isSubscribed ? const Color(0xFF34C759) : const Color(0xFF007AFF)).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSubscribed ? Icons.verified_rounded : Icons.card_giftcard_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isSubscribed ? 'Premium Unlocked' : 'Unlock everything!',
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isSubscribed
                          ? 'You have full access to all packs!'
                          : 'Get all packs, create custom words, remove ads.',
                      style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.white70, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final viewModel = context.watch<GameConfigViewModel>();

    return Column(
      children: [
        _buildConfigGroup([
          _buildConfigRow(
            icon: Icons.people_rounded,
            label: 'Players',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CNButton.icon(
                  icon: const CNSymbol('minus', size: 24),
                  config: CNButtonConfig(style: CNButtonStyle.glass),
                  onPressed: viewModel.decrementPlayers,
                ),
                const SizedBox(width: 16),
                Text(
                  viewModel.players.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                CNButton.icon(
                  icon: const CNSymbol('plus', size: 24),
                  config: CNButtonConfig(style: CNButtonStyle.glass),
                  onPressed: viewModel.incrementPlayers,
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          _buildConfigRow(
            icon: Icons.timer_outlined,
            label: 'Duration (${viewModel.durationUnit})',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CNButton.icon(
                  icon: const CNSymbol('minus', size: 24),
                  config: CNButtonConfig(style: CNButtonStyle.glass),
                  onPressed: viewModel.decrementDuration,
                ),
                const SizedBox(width: 16),
                Text(
                  viewModel.durationValue,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 16),
                CNButton.icon(
                  icon: const CNSymbol('plus', size: 24),
                  config: CNButtonConfig(style: CNButtonStyle.glass),
                  onPressed: viewModel.incrementDuration,
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          _buildConfigRow(
            icon: Icons.help_outline_rounded,
            label: 'How to Play?',
            showChevron: true,
            onTap: () => context.push('/how-to-play'),
          ),
        ]),
        const SizedBox(height: 16),
        _buildConfigGroup([
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Topic Mode',
                  style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                CNSegmentedControl(
                  labels: const ['Same Topic', 'Mixed Topic'],
                  selectedIndex: viewModel.topicMode == TopicMode.same ? 0 : 1,
                  onValueChanged: (i) => viewModel.updateTopicMode(i == 0 ? TopicMode.same : TopicMode.mixed),
                  color: const Color(0xFFFF3B30),
                ),
              ],
            ),
          ),
          if (viewModel.topicMode == TopicMode.same) ...[
            const Divider(color: Colors.white10),
            _buildPackSelectionRow(viewModel),
          ],
        ]),
      ],
    );
  }

  Widget _buildPackSelectionRow(GameConfigViewModel viewModel) {
    return FutureBuilder<List<TopicPack>>(
      future: OpinionRepository().loadPacks(),
      builder: (context, snapshot) {
        final packs = snapshot.data ?? [];
        return _buildConfigRow(
          icon: Icons.layers_rounded,
          label: 'Topics Related to: ',
          trailing: CNPopupMenuButton(
            buttonLabel: viewModel.selectedPack,
            buttonStyle: CNButtonStyle.glass,
            items: packs.map((p) => CNPopupMenuItem(label: p.title)).toList(),
            onSelected: (index) {
              viewModel.updatePack(packs[index].title);
            },
          ),
        );
      },
    );
  }

  Widget _buildConfigRow({
    required IconData icon,
    required String label,
    String? value,
    Widget? trailing,
    bool showChevron = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 16),
            Expanded(
              child: Text(label, style: const TextStyle(color: Colors.white70)),
            ),
            if (value != null) ...[Text(value, style: const TextStyle(color: Colors.white))],
            if (showChevron) ...[const SizedBox(width: 4), const Icon(Icons.chevron_right, color: Colors.white38)],
            if (trailing != null) ...[trailing],
          ],
        ),
      ),
    );
  }

  Widget _buildConfigGroup(List<Widget> children) {
    return LiquidGlassContainer(
      config: LiquidGlassConfig(effect: CNGlassEffect.regular, cornerRadius: 16, shape: CNGlassEffectShape.rect),
      child: Column(children: children),
    );
  }

  Widget _buildStartGameButton(BuildContext context) {
    final configViewModel = context.read<GameConfigViewModel>();
    final revealProvider = context.read<RevealProvider>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: const Color(0xFF34C759).withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 64,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF34C759),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            elevation: 0,
          ),
          onPressed: () async {
            await revealProvider.initializeGame(
              configViewModel.playerNames,
              configViewModel.selectedPack,
              configViewModel.topicMode,
              configViewModel.selectedPunishment,
            );
            if (context.mounted) {
              context.push('/reveal');
            }
          },
          child: const Text(
            'Start Game',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }

  void _showSubscriptionDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withAlpha(200),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: FadeTransition(
            opacity: animation,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: LiquidGlassContainer(
                  config: LiquidGlassConfig(
                    effect: CNGlassEffect.prominent,
                    cornerRadius: 32,
                    shape: CNGlassEffectShape.rect,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withAlpha(30)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Icon(Icons.close, color: Colors.white38, size: 24),
                            ),
                          ],
                        ),
                        const Icon(Icons.auto_awesome_rounded, color: Color(0xFF00C7FF), size: 48),
                        const SizedBox(height: 24),
                        const Text(
                          'Unlock All Packs',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Access every topic pack and remove restrictions.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildSubscriptionOption(
                          context,
                          title: '3-Day Free Trial',
                          subtitle: '3 days free, then annual subscription',
                          isPrimary: true,
                          onTap: () {
                            context.read<SubscriptionProvider>().subscribe(SubscriptionPlan.trial);
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildSubscriptionOption(
                          context,
                          title: 'Weekly Plan',
                          subtitle: '\$5 per week',
                          isPrimary: false,
                          onTap: () {
                            context.read<SubscriptionProvider>().subscribe(SubscriptionPlan.weekly);
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () {
                            context.read<SubscriptionProvider>().restorePurchase();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Restore Purchase',
                            style: TextStyle(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSubscriptionOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF007AFF) : Colors.white.withAlpha(20),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isPrimary
              ? [BoxShadow(color: const Color(0xFF007AFF).withAlpha(100), blurRadius: 20, offset: const Offset(0, 8))]
              : null,
        ),
        child: Column(
          children: [
            Text(
              isPrimary ? 'Start Free Trial' : 'Weekly \$5',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: isPrimary ? Colors.white70 : Colors.white38,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
