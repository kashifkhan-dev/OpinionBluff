import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:go_router/go_router.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/subscription_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';

class PackItem {
  final String id;
  final String title;
  final String emoji;
  final bool isLocked;
  final bool isUpdated;
  final bool isEighteenPlus;
  final bool isSelected;
  final String? badgeText;

  PackItem({
    required this.id,
    required this.title,
    required this.emoji,
    this.isLocked = false,
    this.isUpdated = false,
    this.isEighteenPlus = false,
    this.isSelected = false,
    this.badgeText,
  });
}

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GameConfigViewModel>();
    final subProvider = context.watch<SubscriptionProvider>();
    final isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    final l10n = context.watch<LocaleViewModel>().l10n;

    final packs = [
      PackItem(
        id: 'mystery',
        title: l10n.get('mystery_pack'),
        emoji: '🎁',
        isSelected: viewModel.selectedPack == l10n.get('mystery_pack'),
      ),
      PackItem(
        id: 'animals',
        title: l10n.get('animals_nature'),
        emoji: '🦁',
        isLocked: false,
        isSelected: viewModel.selectedPack == l10n.get('animals_nature'),
      ),
      PackItem(
        id: 'daily_life',
        title: l10n.get('daily_life'),
        emoji: '⏰',
        isUpdated: true,
        isSelected: viewModel.selectedPack == l10n.get('daily_life'),
      ),
      PackItem(
        id: 'adults',
        title: l10n.get('adults_only'),
        emoji: '🌶️',
        isLocked: !subProvider.isSubscribed,
        isEighteenPlus: true,
      ),
      PackItem(id: 'anime', title: l10n.get('anime'), emoji: '🧑‍🎤', isLocked: !subProvider.isSubscribed),
      PackItem(id: 'health', title: l10n.get('body_health'), emoji: '❤️', isLocked: !subProvider.isSubscribed),
      PackItem(id: 'brands', title: l10n.get('brands'), emoji: '🥤', isLocked: !subProvider.isSubscribed),
      PackItem(id: 'characters', title: l10n.get('characters'), emoji: '🧙‍♂️', isLocked: !subProvider.isSubscribed),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF070421),
      body: Stack(
        children: [
          // Background Gradient - Full Screen
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

          CustomScrollView(
            physics: const ClampingScrollPhysics(),
            slivers: [
              // Top Safe Area Padding
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.top)),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CNButton.icon(
                            icon: const CNSymbol('arrow.left', size: 20),
                            config: CNButtonConfig(style: CNButtonStyle.glass),
                            onPressed: () => context.pop(),
                          ),
                          CNButton(
                            label: l10n.get('create'),
                            icon: const CNSymbol('plus', size: 14),
                            config: CNButtonConfig(
                              style: CNButtonStyle.glass,
                              imagePlacement: CNImagePlacement.leading,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Text(
                        l10n.get('select_packs'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.get('select_packs_desc'),
                        style: const TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isIPad ? 3 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final pack = packs[index];
                    return _buildPackCard(context, pack, viewModel);
                  }, childCount: packs.length),
                ),
              ),
              // Bottom Padding to clear Home Indicator/Safe Area
              SliverToBoxAdapter(child: SizedBox(height: MediaQuery.of(context).padding.bottom + 100)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPackCard(BuildContext context, PackItem pack, GameConfigViewModel viewModel) {
    final bool isSelected = pack.isSelected;

    return GestureDetector(
      onTap: () {
        if (pack.isLocked) {
          _showSubscriptionDialog(context);
        } else {
          viewModel.updatePack(pack.title);
          context.pop();
        }
      },
      child: Stack(
        children: [
          LiquidGlassContainer(
            config: LiquidGlassConfig(
              effect: isSelected ? CNGlassEffect.prominent : CNGlassEffect.regular,
              cornerRadius: 24,
              shape: CNGlassEffectShape.rect,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected ? const Color(0xFFFF2D55) : Colors.white.withAlpha(20),
                  width: isSelected ? 2.5 : 1,
                ),
                gradient: pack.id == 'mystery'
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [const Color(0xFF5E1B1B).withAlpha(150), const Color(0xFF2E0A0A).withAlpha(150)],
                      )
                    : null,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(pack.emoji, style: const TextStyle(fontSize: 44)),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text(
                        pack.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (pack.isUpdated)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF34C759), borderRadius: BorderRadius.circular(8)),
                child: Text(
                  context.watch<LocaleViewModel>().l10n.get('updated'),
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (pack.isEighteenPlus)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFFF3B30), borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  '+18',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Positioned(
            top: 12,
            right: 12,
            child: pack.isLocked
                ? const Icon(Icons.lock_rounded, color: Colors.white38, size: 18)
                : (isSelected
                      ? Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: Color(0xFF34C759), shape: BoxShape.circle),
                          child: const Icon(Icons.check, color: Colors.white, size: 14),
                        )
                      : Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white24, width: 1.5),
                          ),
                        )),
          ),
          if (pack.id == 'mystery')
            const Positioned(top: 12, right: 12, child: Icon(Icons.videocam_rounded, color: Colors.white38, size: 20)),
        ],
      ),
    );
  }

  void _showSubscriptionDialog(BuildContext context) {
    context.push('/subscription-unlimited');
  }
}
