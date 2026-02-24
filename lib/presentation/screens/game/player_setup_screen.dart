import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opinion_bluff/presentation/viewmodels/player_setup_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/reveal_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';
import 'package:opinion_bluff/presentation/widgets/onboarding_background.dart';
import 'package:opinion_bluff/domain/entities/punishment.dart';
import 'package:opinion_bluff/presentation/widgets/app_colors.dart';
import 'package:opinion_bluff/domain/repositories/player_repository.dart';
import 'package:opinion_bluff/presentation/widgets/player_avatar.dart';

enum SetupStep { count, names, punishment }

class PlayerSetupScreen extends StatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  State<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends State<PlayerSetupScreen> {
  SetupStep _currentStep = SetupStep.count;
  final PageController _pageController = PageController();

  void _nextStep() {
    if (_currentStep == SetupStep.count) {
      setState(() => _currentStep = SetupStep.names);
      _pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
    } else if (_currentStep == SetupStep.names) {
      setState(() => _currentStep = SetupStep.punishment);
      _pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
    } else {
      _finishSetup();
    }
  }

  void _prevStep() {
    if (_currentStep == SetupStep.punishment) {
      setState(() => _currentStep = SetupStep.names);
      _pageController.previousPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
    } else if (_currentStep == SetupStep.names) {
      setState(() => _currentStep = SetupStep.count);
      _pageController.previousPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
    } else {
      context.pop();
    }
  }

  Future<void> _finishSetup() async {
    final setupVm = context.read<PlayerSetupViewModel>();
    final configVm = context.read<GameConfigViewModel>();
    final revealVm = context.read<RevealProvider>();
    final localeVm = context.read<LocaleViewModel>();

    await revealVm.initializeGame(
      setupVm.activePlayers,
      configVm.selectedPack,
      configVm.topicMode,
      configVm.selectedPunishment,
      configVm.selectedPunishmentDifficulty,
      localeVm.currentLanguage,
    );
    if (mounted) {
      context.go('/reveal');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.watch<LocaleViewModel>().l10n;

    return Scaffold(
      backgroundColor: const Color(0xFF070421),
      body: OnboardingBackground(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(l10n),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _PlayerCountStep(onNext: _nextStep),
                    _PlayerNamesStep(onNext: _nextStep, onBack: _prevStep),
                    _PunishmentStep(onNext: _nextStep, onBack: _prevStep),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Row(
        children: [
          CNButton.icon(
            icon: const CNSymbol('chevron.left', size: 24),
            config: const CNButtonConfig(style: CNButtonStyle.glass),
            onPressed: _prevStep,
          ),
          const Spacer(),
          Text(
            _getStepTitle(l10n),
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  String _getStepTitle(dynamic l10n) {
    switch (_currentStep) {
      case SetupStep.count:
        return l10n.get('player_count_title');
      case SetupStep.names:
        return l10n.get('player_names_title');
      case SetupStep.punishment:
        return l10n.get('punishments');
    }
  }
}

class _PlayerCountStep extends StatelessWidget {
  final VoidCallback onNext;
  const _PlayerCountStep({required this.onNext});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlayerSetupViewModel>();
    final l10n = context.watch<LocaleViewModel>().l10n;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.get('how_many_players'),
          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CounterButton(
              symbol: 'minus',
              onPressed: () => vm.setPlayerCount(vm.playerCount - 1),
              enabled: vm.playerCount > 3,
            ),
            const SizedBox(width: 32),
            Text(
              vm.playerCount.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 32),
            _CounterButton(
              symbol: 'plus',
              onPressed: () => vm.setPlayerCount(vm.playerCount + 1),
              enabled: vm.playerCount < 12,
            ),
          ],
        ),
        const SizedBox(height: 64),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: CNButton(
              label: l10n.get('next'),
              config: const CNButtonConfig(style: CNButtonStyle.prominentGlass),
              onPressed: onNext,
            ),
          ),
        ),
      ],
    );
  }
}

class _CounterButton extends StatelessWidget {
  final String symbol;
  final VoidCallback onPressed;
  final bool enabled;

  const _CounterButton({required this.symbol, required this.onPressed, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.3,
      child: CNButton.icon(
        icon: CNSymbol(symbol, size: 24),
        config: const CNButtonConfig(style: CNButtonStyle.glass),
        onPressed: enabled ? onPressed : () {},
      ),
    );
  }
}

class _PlayerNamesStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _PlayerNamesStep({required this.onNext, required this.onBack});

  @override
  State<_PlayerNamesStep> createState() => _PlayerNamesStepState();
}

class _PlayerNamesStepState extends State<_PlayerNamesStep> {
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    final vm = context.read<PlayerSetupViewModel>();
    _controllers = List.generate(vm.playerCount, (index) => TextEditingController(text: vm.players[index].name));
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlayerSetupViewModel>();
    final l10n = context.watch<LocaleViewModel>().l10n;

    // Ensure controllers list matches player count if it changes (though usually handled by step transition)
    if (_controllers.length != vm.playerCount) {
      for (var c in _controllers) {
        c.dispose();
      }
      _controllers = List.generate(vm.playerCount, (index) => TextEditingController(text: vm.players[index].name));
    }
    final firstEmptyIndex = vm.players.take(vm.playerCount).toList().indexWhere((p) => p.name.trim().isEmpty);
    final displayIndex = firstEmptyIndex != -1 ? firstEmptyIndex + 1 : 1;
    final instruction = l10n.get('enter_player_names_instr').replaceAll('{i}', '$displayIndex');

    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            instruction,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            itemCount: vm.playerCount,
            onReorder: (oldIndex, newIndex) {
              vm.reorderPlayers(oldIndex, newIndex);
              // Sync controllers with new order
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final controller = _controllers.removeAt(oldIndex);
                _controllers.insert(newIndex, controller);
              });
            },
            onReorderStart: (_) {
              FocusScope.of(context).unfocus();
            },
            proxyDecorator: (child, index, animation) {
              return AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  final double animValue = Curves.easeInOut.transform(animation.value);
                  final double elevation = animValue * 15.0;
                  return Material(
                    type: MaterialType.transparency,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.red.withValues(alpha: 0.15 * animValue),
                            blurRadius: elevation,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: child,
                    ),
                  );
                },
                child: child,
              );
            },
            itemBuilder: (context, index) {
              final player = vm.players[index];
              return Container(
                key: ValueKey('player_row_${_controllers[index].hashCode}'),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.drag_indicator, color: Colors.white24, size: 16),
                    const SizedBox(width: 8),
                    // Avatar
                    GestureDetector(
                      onTap: () => _showImageSourceActionSheet(context, vm, index),
                      child: PlayerAvatar(
                        avatarPath: player.customImagePath ?? player.avatarAssetPath,
                        isCustomAvatar: player.customImagePath != null,
                        name: player.name,
                        size: 60,
                        borderWidth: 3,
                        borderColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _controllers[index],
                        style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: l10n.get('enter_player_names_instr').replaceAll('{i}', '${index + 1}'),
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) => vm.updatePlayerName(index, val),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Gender Toggle Button
                    SizedBox(
                      height: 28,
                      child: CNButton(
                        label: player.gender == PlayerGender.male ? l10n.get('male') : l10n.get('female'),
                        config: const CNButtonConfig(
                          style: CNButtonStyle.glass,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onPressed: () => vm.toggleGender(index),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
          child: Column(
            children: [
              if (!vm.areNamesValid)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    l10n.get('all_names_required'),
                    style: const TextStyle(color: Color(0xFFFF3B30), fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: Opacity(
                  opacity: vm.areNamesValid ? 1.0 : 0.5,
                  child: CNButton(
                    label: l10n.get('next'),
                    config: const CNButtonConfig(style: CNButtonStyle.prominentGlass),
                    onPressed: vm.areNamesValid ? widget.onNext : () {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showImageSourceActionSheet(BuildContext context, PlayerSetupViewModel vm, int index) {
    final l10n = context.read<LocaleViewModel>().l10n;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.get('choose_avatar_source')),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              vm.pickImage(index, ImageSource.gallery);
            },
            child: Text(l10n.get('choose_from_gallery')),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              vm.pickImage(index, ImageSource.camera);
            },
            child: Text(l10n.get('take_photo')),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          isDefaultAction: true,
          child: Text(l10n.get('cancel')),
        ),
      ),
    );
  }
}

class _PunishmentStep extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _PunishmentStep({required this.onNext, required this.onBack});

  @override
  State<_PunishmentStep> createState() => _PunishmentStepState();
}

class _PunishmentStepState extends State<_PunishmentStep> {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameConfigViewModel>();
    final l10n = context.watch<LocaleViewModel>().l10n;
    final colors = AppColors();

    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            l10n.get('choose_punishment'),
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 40),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildDifficultyCard(
                  context,
                  PunishmentDifficulty.low,
                  l10n.get('difficulty_low'),
                  '🌱',
                  'Light & Fun',
                  vm,
                  colors,
                ),
                const SizedBox(height: 16),
                _buildDifficultyCard(
                  context,
                  PunishmentDifficulty.hard,
                  l10n.get('difficulty_hard'),
                  '🔥',
                  'Getting Serious',
                  vm,
                  colors,
                ),
                const SizedBox(height: 16),
                _buildDifficultyCard(
                  context,
                  PunishmentDifficulty.veryHard,
                  l10n.get('difficulty_very_hard'),
                  '💀',
                  'Extreme Challenges',
                  vm,
                  colors,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 40),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: CNButton(
              label: l10n.get('start_game'),
              config: const CNButtonConfig(style: CNButtonStyle.prominentGlass),
              onPressed: widget.onNext,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyCard(
    BuildContext context,
    PunishmentDifficulty difficulty,
    String title,
    String emoji,
    String subtitle,
    GameConfigViewModel vm,
    AppColors colors,
  ) {
    final isSelected = vm.selectedPunishmentDifficulty == difficulty;

    return GestureDetector(
      onTap: () => vm.updatePunishmentDifficulty(difficulty),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: LiquidGlassContainer(
          config: LiquidGlassConfig(
            effect: isSelected ? CNGlassEffect.prominent : CNGlassEffect.regular,
            cornerRadius: 24,
            interactive: true,
            shape: CNGlassEffectShape.rect,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: isSelected ? const Color(0xFFFF3B30).withValues(alpha: 0.5) : Colors.white10),
              gradient: isSelected
                  ? LinearGradient(
                      colors: [const Color(0xFFFF3B30).withValues(alpha: 0.15), Colors.transparent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFF3B30).withValues(alpha: 0.2) : Colors.white.withAlpha(5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 28)),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.white38, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFFF3B30), size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
