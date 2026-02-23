import 'package:flutter/material.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/player_setup_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/reveal_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';
import 'package:opinion_bluff/presentation/widgets/onboarding_background.dart';
import 'package:opinion_bluff/domain/entities/game_round.dart';

enum SetupStep { count, names, topicMode }

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
      setState(() => _currentStep = SetupStep.topicMode);
      _pageController.nextPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
    } else {
      _finishSetup();
    }
  }

  void _prevStep() {
    if (_currentStep == SetupStep.names) {
      setState(() => _currentStep = SetupStep.count);
      _pageController.previousPage(duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
    } else if (_currentStep == SetupStep.topicMode) {
      setState(() => _currentStep = SetupStep.names);
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
      setupVm.activePlayerNames,
      configVm.selectedPack,
      configVm.topicMode,
      configVm.selectedPunishment,
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
                    _TopicModeStep(onNext: _nextStep, onBack: _prevStep),
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
      case SetupStep.topicMode:
        return l10n.get('topic_mode_title');
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
        icon: CNSymbol(symbol, size: 32),
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
    _controllers = List.generate(vm.playerCount, (index) => TextEditingController(text: vm.playerNames[index]));
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
      _controllers = List.generate(vm.playerCount, (index) => TextEditingController(text: vm.playerNames[index]));
    }
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            l10n.get('enter_player_names_instr'),
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
              return Container(
                key: ValueKey('player_row_${_controllers[index].hashCode}'),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.drag_indicator, color: Colors.white24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _controllers[index],
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '${l10n.get('player')} ${index + 1}',
                          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.2)),
                        ),
                        onChanged: (val) => vm.updatePlayerName(index, val),
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
}

class _TopicModeStep extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const _TopicModeStep({required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameConfigViewModel>();
    final l10n = context.watch<LocaleViewModel>().l10n;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.get('choose_topic_mode'),
          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            l10n.get('topic_mode_desc'),
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 64),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              _ModeTile(
                title: l10n.get('same_topic'),
                isSelected: vm.topicMode == TopicMode.same,
                onTap: () => vm.updateTopicMode(TopicMode.same),
              ),
              const SizedBox(height: 16),
              _ModeTile(
                title: l10n.get('mixed_topic'),
                isSelected: vm.topicMode == TopicMode.mixed,
                onTap: () => vm.updateTopicMode(TopicMode.mixed),
              ),
            ],
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
          child: SizedBox(
            width: double.infinity,
            height: 64,
            child: CNButton(
              label: l10n.get('start_game'),
              config: const CNButtonConfig(style: CNButtonStyle.prominentGlass),
              onPressed: onNext,
            ),
          ),
        ),
      ],
    );
  }
}

class _ModeTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeTile({required this.title, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF3B30).withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFFFF3B30) : Colors.white10, width: 2),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 20,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFFF3B30), size: 28),
          ],
        ),
      ),
    );
  }
}
