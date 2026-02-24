import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';
import 'package:opinion_bluff/presentation/widgets/app_colors.dart';

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
}
