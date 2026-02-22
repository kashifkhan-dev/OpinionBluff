import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';
import 'package:opinion_bluff/presentation/widgets/app_colors.dart';

class AppLocalizations {
  String get language => 'Language';
  String get english => 'English';
  String get french => 'French';
  String get spanish => 'Spanish';
  String get change => 'Change';
}

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
                  _buildSettingsTile(
                    icon: Icons.help_outline_rounded,
                    label: 'How To Play',
                    onTap: () => context.push('/how-to-play'),
                    colors: colors,
                  ),

                  const SizedBox(height: 32),
                  const Text('Punishments', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 16),
                  _buildPunishmentsList(context, viewModel, colors),
                  const SizedBox(height: 12),
                  CNButton(
                    label: '+ Add Custom Punishment',
                    config: CNButtonConfig(style: CNButtonStyle.tinted),
                    onPressed: () => _showAddPunishmentDialog(context, viewModel),
                  ),

                  const SizedBox(height: 32),
                  const Text('Player Names', style: TextStyle(color: Colors.white70, fontSize: 16)),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: viewModel.playerNames.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: colors.card,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: colors.border),
                        ),
                        child: TextField(
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                            icon: Icon(Icons.person_outline, color: Colors.white.withValues(alpha: 0.5)),
                            border: InputBorder.none,
                            hintText: 'Enter name...',
                            hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                            suffixIcon: const Icon(Icons.edit_note_rounded, color: Colors.white24, size: 22),
                          ),
                          onChanged: (value) => viewModel.updatePlayerName(index, value),
                          controller: TextEditingController(text: viewModel.playerNames[index])
                            ..selection = TextSelection.fromPosition(
                              TextPosition(offset: viewModel.playerNames[index].length),
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
          _buildLanguageMenu(context, colors, localeVm),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required AppColors colors,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              child: Icon(icon, color: Colors.blue, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 17, color: colors.textPrimary, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }

  Widget _buildPunishmentsList(BuildContext context, GameConfigViewModel viewModel, AppColors colors) {
    return Column(
      children: viewModel.allPunishments.map((p) {
        final isSelected = viewModel.selectedPunishment == p;
        final isCustom = viewModel.customPunishments.contains(p);

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: GestureDetector(
            onTap: () => viewModel.updatePunishment(p),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF3B30).withValues(alpha: 0.1) : colors.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isSelected ? const Color(0xFFFF3B30) : colors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      p,
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? Colors.white : colors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFFF3B30), size: 20),
                  if (isCustom) ...[
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () => viewModel.deleteCustomPunishment(p),
                      child: const Icon(Icons.delete_outline, color: Colors.white24, size: 20),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showAddPunishmentDialog(BuildContext context, GameConfigViewModel viewModel) {
    final controller = TextEditingController();
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Add Punishment'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            controller: controller,
            placeholder: 'Type punishment here...',
            style: const TextStyle(color: Colors.white),
            cursorColor: const Color(0xFFFF3B30),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(child: const Text('Cancel'), onPressed: () => Navigator.pop(context)),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Add', style: TextStyle(color: Color(0xFFFF3B30))),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                viewModel.addCustomPunishment(controller.text);
                Navigator.pop(context);
              }
            },
          ),
        ],
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
