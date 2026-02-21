import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';

// --- MOCK MODELS FOR DEMO ---
enum AppLanguage { english, french, spanish }

class LocaleViewModel extends ChangeNotifier {
  AppLanguage _language = AppLanguage.english;
  AppLanguage get language => _language;

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
  }
}

class AppColors {
  final Color card = Colors.white.withAlpha(20);
  final Color border = Colors.white.withAlpha(30);
  final Color surface = Colors.white.withAlpha(10);
  final Color textPrimary = Colors.white;
}

class AppLocalizations {
  String get language => 'Language';
  String get english => 'English';
  String get french => 'French';
  String get spanish => 'Spanish';
  String get change => 'Change';
}
// ----------------------------

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GameConfigViewModel>();
    final bool isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    // Local instances for demo purposes
    final colors = AppColors();
    final l10n = AppLocalizations();

    return ChangeNotifierProvider(
      create: (_) => LocaleViewModel(),
      child: Consumer<LocaleViewModel>(
        builder: (context, localeVm, _) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isIPad ? 42 : 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Language Selection Demo Tile
                  _buildLanguageTile(context, colors, localeVm, l10n),

                  const SizedBox(height: 32),
                  const Text('Player Names', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.playerNames.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return LiquidGlassContainer(
                        config: LiquidGlassConfig(
                          effect: CNGlassEffect.regular,
                          cornerRadius: 16,
                          shape: CNGlassEffectShape.rect,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: TextField(
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            decoration: InputDecoration(
                              icon: Icon(Icons.person_outline, color: Colors.white.withValues(alpha: 0.5)),
                              border: InputBorder.none,
                              hintText: 'Enter name...',
                              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                            ),
                            onChanged: (value) => viewModel.updatePlayerName(index, value),
                            controller: TextEditingController(text: viewModel.playerNames[index])
                              ..selection = TextSelection.fromPosition(
                                TextPosition(offset: viewModel.playerNames[index].length),
                              ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, AppColors colors, LocaleViewModel localeVm, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: colors.surface, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: const Text('🌍', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              l10n.language,
              style: TextStyle(fontSize: 17, color: colors.textPrimary, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildLanguageMenu(context, colors, localeVm, l10n),
        ],
      ),
    );
  }

  Widget _buildLanguageMenu(BuildContext context, AppColors colors, LocaleViewModel localeVm, AppLocalizations l10n) {
    final items = [
      CNPopupMenuItem(label: '🇺🇸 ${l10n.english}', icon: const CNSymbol('textformat', size: 12)),
      CNPopupMenuItem(label: '🇫🇷 ${l10n.french}', icon: const CNSymbol('textformat', size: 12)),
      CNPopupMenuItem(label: '🇪🇸 ${l10n.spanish}', icon: const CNSymbol('textformat', size: 12)),
    ];

    return CNPopupMenuButton(
      buttonLabel: 'Change',
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
