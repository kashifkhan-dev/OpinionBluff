import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';
import 'package:opinion_bluff/presentation/widgets/app_colors.dart';
import 'package:opinion_bluff/domain/entities/punishment.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GameConfigViewModel>();
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
            Text(l10n.get('punishments'), style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 16),
            _buildPunishmentsList(context, viewModel, colors),
            const SizedBox(height: 12),
            CNButton(
              label: l10n.get('add_custom_punishment'),
              config: CNButtonConfig(style: CNButtonStyle.tinted),
              onPressed: () => _showAddPunishmentDialog(context, viewModel),
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageTile(BuildContext context, AppColors colors, LocaleViewModel localeVm) {
    final l10n = localeVm.l10n;
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
              l10n.get('language'),
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

  Widget _buildPunishmentsList(BuildContext context, GameConfigViewModel viewModel, AppColors colors) {
    final categorized = viewModel.categorizedPunishments;
    final l10n = context.watch<LocaleViewModel>().l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCategorySection(
          context,
          l10n.get('difficulty_low'),
          categorized[PunishmentDifficulty.low]!,
          viewModel,
          colors,
        ),
        const SizedBox(height: 24),
        _buildCategorySection(
          context,
          l10n.get('difficulty_hard'),
          categorized[PunishmentDifficulty.hard]!,
          viewModel,
          colors,
        ),
        const SizedBox(height: 24),
        _buildCategorySection(
          context,
          l10n.get('difficulty_very_hard'),
          categorized[PunishmentDifficulty.veryHard]!,
          viewModel,
          colors,
        ),
      ],
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    String title,
    List<Punishment> punishments,
    GameConfigViewModel viewModel,
    AppColors colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1),
          ),
        ),
        ...punishments.map((p) {
          final isSelected = viewModel.selectedPunishmentId == p.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () => viewModel.updatePunishment(p.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
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
                        p.name.startsWith('punishment_') ? context.watch<LocaleViewModel>().l10n.get(p.name) : p.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? Colors.white : colors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFFF3B30), size: 20),
                    if (p.isCustom) ...[
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => viewModel.deleteCustomPunishment(p.id),
                        child: const Icon(Icons.delete_outline, color: Colors.white24, size: 20),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showAddPunishmentDialog(BuildContext context, GameConfigViewModel viewModel) {
    final controller = TextEditingController();
    final l10n = context.read<LocaleViewModel>().l10n;
    PunishmentDifficulty selectedDifficulty = PunishmentDifficulty.low;

    showCupertinoDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          bool isValid = controller.text.trim().isNotEmpty;
          controller.addListener(() {
            final nowValid = controller.text.trim().isNotEmpty;
            if (nowValid != isValid) {
              setDialogState(() => isValid = nowValid);
            }
          });

          return CupertinoAlertDialog(
            title: Text(l10n.get('add')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                CupertinoTextField(
                  controller: controller,
                  placeholder: l10n.get('type_punishment_here'),
                  style: const TextStyle(color: Colors.white),
                  cursorColor: const Color(0xFFFF3B30),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                Text(l10n.get('select_difficulty'), style: const TextStyle(fontSize: 13, color: Colors.white70)),
                const SizedBox(height: 8),
                CNSegmentedControl(
                  labels: [l10n.get('difficulty_low'), l10n.get('difficulty_hard'), l10n.get('difficulty_very_hard')],
                  selectedIndex: selectedDifficulty.index,
                  onValueChanged: (index) {
                    setDialogState(() {
                      selectedDifficulty = PunishmentDifficulty.values[index];
                    });
                  },
                  color: const Color(0xFFFF3B30),
                ),
              ],
            ),
            actions: [
              CupertinoDialogAction(child: Text(l10n.get('cancel')), onPressed: () => Navigator.pop(context)),
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: isValid
                    ? () {
                        viewModel.addCustomPunishment(controller.text.trim(), selectedDifficulty);
                        Navigator.pop(context);
                      }
                    : null,
                child: Text(l10n.get('add'), style: TextStyle(color: isValid ? const Color(0xFFFF3B30) : Colors.grey)),
              ),
            ],
          );
        },
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
