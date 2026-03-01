import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:impostor/presentation/viewmodels/game_config_view_model.dart';
import 'package:impostor/presentation/viewmodels/locale_view_model.dart';
import 'package:impostor/presentation/viewmodels/subscription_provider.dart';
import 'package:impostor/presentation/widgets/app_colors.dart';
import 'package:impostor/domain/entities/punishment.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeVm = context.watch<LocaleViewModel>();
    final l10n = localeVm.l10n;
    final bool isIPad = MediaQuery.of(context).size.shortestSide >= 600;
    final colors = AppColors();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              l10n.get('settings'),
              style: TextStyle(
                color: Colors.white,
                fontSize: isIPad ? 42 : 34,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 24),

            // Language Selection
            _buildLanguageTile(context, colors, localeVm),

            const SizedBox(height: 32),
            Text(l10n.get('sound_controls'), style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 16),
            _buildSoundToggle(
              context,
              l10n.get('sound_effects'),
              'speaker.wave.2.fill',
              context.watch<GameConfigViewModel>().soundEffectsEnabled,
              () => context.read<GameConfigViewModel>().toggleSoundEffects(),
              colors,
            ),
            const SizedBox(height: 12),
            _buildSoundToggle(
              context,
              l10n.get('haptics'),
              'hand.tap.fill',
              context.watch<GameConfigViewModel>().hapticsEnabled,
              () => context.read<GameConfigViewModel>().toggleHaptics(),
              colors,
            ),

            const SizedBox(height: 32),
            Text(l10n.get('subscription_rewards'), style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 16),
            _buildSubscriptionStatus(context, colors),

            const SizedBox(height: 32),
            Center(
              child: TextButton(
                onPressed: () => _showPunishmentsSheet(context, context.read<GameConfigViewModel>()),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white30,
                  textStyle: const TextStyle(fontSize: 13, decoration: TextDecoration.underline),
                ),
                child: Text(l10n.get('show_punishments')),
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundToggle(
    BuildContext context,
    String label,
    String iconSymbol,
    bool value,
    VoidCallback onToggle,
    AppColors colors,
  ) {
    return LiquidGlassContainer(
      config: LiquidGlassConfig(
        effect: CNGlassEffect.regular,
        shape: CNGlassEffectShape.capsule,
        cornerRadius: 999,
        interactive: true,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Colors.white.withAlpha(15), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: CNIcon(symbol: CNSymbol(iconSymbol, size: 20, color: Colors.white)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            CNSwitch(value: value, color: const Color(0xFF34C759), onChanged: (_) => onToggle()),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, AppColors colors, LocaleViewModel localeVm) {
    final l10n = localeVm.l10n;
    return LiquidGlassContainer(
      config: LiquidGlassConfig(
        effect: CNGlassEffect.regular,
        shape: CNGlassEffectShape.capsule,
        cornerRadius: 999,
        interactive: true,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: Colors.white.withAlpha(15), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Text('🌍', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                l10n.get('language'),
                style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            _buildLanguageMenu(context, colors, localeVm),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageMenu(BuildContext context, AppColors colors, LocaleViewModel localeVm) {
    final items = [
      const CNPopupMenuItem(label: '🇺🇸 English', icon: CNSymbol('textformat', size: 12)),
      const CNPopupMenuItem(label: '🇫🇷 French', icon: CNSymbol('textformat', size: 12)),
      const CNPopupMenuItem(label: '🇪🇸 Spanish', icon: CNSymbol('textformat', size: 12)),
    ];

    return CNPopupMenuButton(
      buttonLabel: 'Change', // This button text remains constant as requested in past conversations
      items: items,
      onSelected: (index) {
        if (index == 0) {
          localeVm.setLanguage(AppLanguage.english);
        } else if (index == 1) {
          localeVm.setLanguage(AppLanguage.french);
        } else if (index == 2) {
          localeVm.setLanguage(AppLanguage.spanish);
        }
      },
    );
  }

  Widget _buildSubscriptionStatus(BuildContext context, AppColors colors) {
    final subProvider = context.watch<SubscriptionProvider>();
    final l10n = context.read<LocaleViewModel>().l10n;
    final isSubscribed = subProvider.isSubscribed;

    return LiquidGlassContainer(
      config: LiquidGlassConfig(
        effect: CNGlassEffect.regular,
        shape: CNGlassEffectShape.rect,
        cornerRadius: 16,
        interactive: true,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: (isSubscribed ? const Color(0xFF34C759) : const Color(0xFFFF9500)).withAlpha(30),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSubscribed ? Icons.verified_user_rounded : Icons.star_rounded,
                    color: isSubscribed ? const Color(0xFF34C759) : const Color(0xFFFF9500),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isSubscribed ? l10n.get('unlimited_access_title') : 'Free Trial',
                        style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isSubscribed ? 'All features unlocked' : '1 free game remaining',
                        style: const TextStyle(color: Colors.white54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: CNButton(
                label: isSubscribed ? l10n.get('manage') : l10n.get('upgrade'),
                config: CNButtonConfig(style: isSubscribed ? CNButtonStyle.glass : CNButtonStyle.filled),
                onPressed: () {
                  context.push('/subscription-unlimited');
                },
              ),
            ),
            if (!isSubscribed) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => subProvider.restorePurchase(),
                child: Text(l10n.get('restore_purchase'), style: const TextStyle(color: Colors.white38, fontSize: 12)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPunishmentsSheet(BuildContext context, GameConfigViewModel viewModel) {
    final localeVm = context.read<LocaleViewModel>();
    final l10n = localeVm.l10n;
    final categorized = viewModel.categorizedPunishments;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Material(
        color: Colors.transparent,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Color(0xFF1C1C1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                l10n.get('punishments'),
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildPunishmentCategory(
                      l10n.get('difficulty_low'),
                      categorized[PunishmentDifficulty.low] ?? [],
                      localeVm.currentLanguage,
                    ),
                    _buildPunishmentCategory(
                      l10n.get('difficulty_hard'),
                      categorized[PunishmentDifficulty.hard] ?? [],
                      localeVm.currentLanguage,
                    ),
                    _buildPunishmentCategory(
                      l10n.get('difficulty_very_hard'),
                      categorized[PunishmentDifficulty.veryHard] ?? [],
                      localeVm.currentLanguage,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: CNButton(
                  label: l10n.get('got_it'),
                  config: const CNButtonConfig(style: CNButtonStyle.prominentGlass),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPunishmentCategory(String title, List<Punishment> items, AppLanguage language) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Color(0xFFFF3B30),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...items.map(
          (p) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(color: Colors.white.withAlpha(15), borderRadius: BorderRadius.circular(12)),
            child: Text(
              p.getNameForLanguage(language),
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
