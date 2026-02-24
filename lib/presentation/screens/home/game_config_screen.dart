import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';
import 'package:opinion_bluff/data/repositories/opinion_repository.dart';
import 'package:opinion_bluff/presentation/viewmodels/subscription_provider.dart';
import 'package:opinion_bluff/domain/entities/topic_pack.dart';
import 'package:opinion_bluff/domain/entities/game_round.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';

class GameConfigScreen extends StatefulWidget {
  const GameConfigScreen({super.key});

  @override
  State<GameConfigScreen> createState() => _GameConfigScreenState();
}

class _GameConfigScreenState extends State<GameConfigScreen> {
  late Future<List<TopicPack>> _packsFuture;

  @override
  void initState() {
    super.initState();
    _packsFuture = OpinionRepository().loadPacks();
  }

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
                  const Text(
                    'Opinion Bluff',
                    style: TextStyle(
                      color: Color(0xFFFF3B30),
                      fontSize: 42,
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
    final l10n = context.watch<LocaleViewModel>().l10n;
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
                      isSubscribed ? l10n.get('subscription_rewards') : l10n.get('unlock_everything_title'),
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isSubscribed ? 'You have full access to all packs!' : l10n.get('unlock_everything_desc'),
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
    final l10n = context.watch<LocaleViewModel>().l10n;

    return Column(
      children: [
        _buildConfigGroup([
          _buildConfigRow(
            icon: Icons.timer_outlined,
            label: '${l10n.get('duration')} (${viewModel.durationUnit})',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CNButton.icon(
                  icon: const CNSymbol('minus', size: 24),
                  config: const CNButtonConfig(style: CNButtonStyle.glass),
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
                  config: const CNButtonConfig(style: CNButtonStyle.glass),
                  onPressed: viewModel.incrementDuration,
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          _buildConfigRow(
            icon: Icons.help_outline_rounded,
            label: l10n.get('how_to_play'),
            showChevron: true,
            onTap: () => context.push('/how-to-play'),
            onLongPress: () => context.go('/'),
          ),
          const Divider(color: Colors.white10),
          _buildConfigRow(
            icon: Icons.topic_outlined,
            label: l10n.get('topic_mode_title'),
            trailing: SizedBox(
              width: 260,
              child: CNSegmentedControl(
                labels: [l10n.get('same_topic'), l10n.get('mixed_topic')],
                selectedIndex: viewModel.topicMode == TopicMode.same ? 0 : 1,
                onValueChanged: (index) {
                  viewModel.updateTopicMode(index == 0 ? TopicMode.same : TopicMode.mixed);
                },
                color: const Color(0xFFFF3B30),
              ),
            ),
          ),
        ]),
        if (viewModel.topicMode == TopicMode.same) ...[
          const SizedBox(height: 16),
          _buildConfigGroup([_buildPackSelectionRow(viewModel)]),
        ],
      ],
    );
  }

  Widget _buildPackSelectionRow(GameConfigViewModel viewModel) {
    return Consumer<LocaleViewModel>(
      builder: (context, localeVm, _) {
        final l10n = localeVm.l10n;
        return FutureBuilder<List<TopicPack>>(
          future: _packsFuture,
          builder: (context, snapshot) {
            final packs = snapshot.data ?? [];
            return _buildConfigRow(
              icon: Icons.layers_rounded,
              label: l10n.get('topics_related_to'),
              trailing: CNPopupMenuButton(
                buttonLabel: snapshot.hasData
                    ? packs
                          .firstWhere(
                            (p) =>
                                p.title.getForLanguage(AppLanguage.english) == viewModel.selectedPack ||
                                p.id == viewModel.selectedPack,
                            orElse: () => packs.first,
                          )
                          .title
                          .getForLanguage(localeVm.currentLanguage)
                    : viewModel.selectedPack,
                buttonStyle: CNButtonStyle.glass,
                items: packs
                    .map((p) => CNPopupMenuItem(label: p.title.getForLanguage(localeVm.currentLanguage)))
                    .toList(),
                onSelected: (index) {
                  viewModel.updatePack(packs[index].title.getForLanguage(AppLanguage.english));
                },
              ),
            );
          },
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
    VoidCallback? onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
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
    final l10n = context.watch<LocaleViewModel>().l10n;

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
          onPressed: () => context.push('/player-setup'),
          child: Text(
            l10n.get('start_game'),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }

  void _showSubscriptionDialog(BuildContext context) {
    context.push('/subscription-unlimited');
  }
}
