import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:go_router/go_router.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/subscription_provider.dart';

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

    final packs = [
      PackItem(id: 'mystery', title: 'Mystery Pack', emoji: '🎁', isSelected: viewModel.selectedPack == 'Mystery Pack'),
      PackItem(
        id: 'animals',
        title: 'Animals & Nature',
        emoji: '🦁',
        isLocked: false,
        isSelected: viewModel.selectedPack == 'Animals & Nature',
      ),
      PackItem(
        id: 'daily_life',
        title: 'Daily Life',
        emoji: '⏰',
        isUpdated: true,
        isSelected: viewModel.selectedPack == 'Daily Life',
      ),
      PackItem(
        id: 'adults',
        title: 'Adults Only',
        emoji: '🌶️',
        isLocked: !subProvider.isSubscribed,
        isEighteenPlus: true,
      ),
      PackItem(id: 'anime', title: 'Anime', emoji: '🧑‍🎤', isLocked: !subProvider.isSubscribed),
      PackItem(id: 'health', title: 'Body & Health', emoji: '❤️', isLocked: !subProvider.isSubscribed),
      PackItem(id: 'brands', title: 'Brands', emoji: '🥤', isLocked: !subProvider.isSubscribed),
      PackItem(id: 'characters', title: 'Characters', emoji: '🧙‍♂️', isLocked: !subProvider.isSubscribed),
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
                            label: 'Create',
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
                      const Text(
                        'Select Packs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'More packs, more chaos — pick your favorites!',
                        style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.w500),
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
                child: const Text(
                  'Updated',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
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
