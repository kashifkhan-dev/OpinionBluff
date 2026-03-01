import 'package:flutter/material.dart';
import 'package:impostor/presentation/viewmodels/game_config_view_model.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:impostor/presentation/viewmodels/voting_provider.dart';
import 'package:impostor/presentation/viewmodels/reveal_provider.dart';
import 'package:impostor/presentation/viewmodels/result_provider.dart';
import 'package:impostor/domain/entities/game_player.dart';
import 'package:impostor/presentation/viewmodels/locale_view_model.dart';
import 'package:impostor/domain/entities/punishment.dart';
import 'package:impostor/presentation/widgets/quit_game_button.dart';
import 'package:impostor/presentation/widgets/player_avatar.dart';

class VotingScreen extends StatefulWidget {
  const VotingScreen({super.key});

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int? _selectedPlayerIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final revealProvider = context.read<RevealProvider>();
      context.read<VotingProvider>().initialize(revealProvider.players);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<VotingProvider>();

    return Scaffold(
      body: Stack(
        children: [
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
          SafeArea(child: viewModel.isPassingDevice ? _buildPassDeviceUI(viewModel) : _buildVotingUI(viewModel)),
          Positioned(
            top: 0,
            right: 0,
            child: SafeArea(
              child: Padding(padding: const EdgeInsets.only(top: 8.0, right: 16.0), child: QuitGameButton()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassDeviceUI(VotingProvider viewModel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.phonelink_setup, color: Colors.white70, size: 80),
            const SizedBox(height: 32),
            Text(
              '${context.watch<LocaleViewModel>().l10n.get('pass_phone_to')}\n${viewModel.currentVoter?.name ?? "Player"}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: CNButton(
                label: context.watch<LocaleViewModel>().l10n.get('continue'),
                config: const CNButtonConfig(style: CNButtonStyle.prominentGlass),
                onPressed: () {
                  setState(() {
                    _selectedPlayerIndex = null;
                  });
                  viewModel.continueToVote();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVotingUI(VotingProvider viewModel) {
    final List<GamePlayer> otherPlayers = viewModel.players
        .where((p) => p.index != viewModel.activeVoterIndex)
        .toList();

    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          context
              .watch<LocaleViewModel>()
              .l10n
              .get('player_vote_title')
              .replaceAll('{name}', viewModel.currentVoter?.name ?? ''),
          style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 16),
        _buildVotingProgress(viewModel),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            context.watch<LocaleViewModel>().l10n.get('who_is_bluffer'),
            style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildPlayerGrid(otherPlayers, viewModel)),
        _buildActionArea(viewModel),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildVotingProgress(VotingProvider viewModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: viewModel.players.map((p) {
          final voted = viewModel.hasPlayerVoted(p.index);
          final bool isActiveVoter = viewModel.activeVoterIndex == p.index;

          final child = Stack(
            children: [
              PlayerAvatar(
                avatarPath: p.avatarPath,
                isCustomAvatar: p.isCustomAvatar,
                name: p.name,
                size: 32,
                borderWidth: isActiveVoter ? 2 : 1,
                borderColor: isActiveVoter ? Colors.white : Colors.white24,
                backgroundColor: voted ? const Color(0xFF34C759) : (isActiveVoter ? Colors.white24 : Colors.white10),
              ),
              if (voted)
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.check_circle, color: Color(0xFF34C759), size: 14),
                  ),
                ),
            ],
          );

          if (isActiveVoter && !voted) {
            return _PulsingAvatar(child: child);
          }
          return child;
        }).toList(),
      ),
    );
  }

  Widget _buildPlayerGrid(List<GamePlayer> players, VotingProvider viewModel) {
    final bool isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isIPad ? 3 : 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: players.length,
      itemBuilder: (context, index) {
        final player = players[index];
        return _buildPlayerVoteCard(player, viewModel);
      },
    );
  }

  Widget _buildPlayerVoteCard(GamePlayer player, VotingProvider viewModel) {
    final bool isSelected = _selectedPlayerIndex == player.index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPlayerIndex = player.index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? Colors.white : Colors.white10, width: isSelected ? 3 : 1),
          boxShadow: isSelected ? [BoxShadow(color: Colors.white.withValues(alpha: 0.1), blurRadius: 15)] : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PlayerAvatar(
              avatarPath: player.avatarPath,
              isCustomAvatar: player.isCustomAvatar,
              name: player.name,
              size: 70, // Making cards larger as requested
              borderWidth: isSelected ? 3 : 1,
              borderColor: isSelected ? Colors.white : Colors.white24,
            ),
            const SizedBox(height: 12),
            Text(
              player.name,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionArea(VotingProvider viewModel) {
    if (viewModel.allVotesCompleted) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: CNButton(
            label: context.watch<LocaleViewModel>().l10n.get('show_results'),
            config: const CNButtonConfig(style: CNButtonStyle.prominentGlass),
            onPressed: () {
              final resultProvider = context.read<ResultProvider>();
              final revealProvider = context.read<RevealProvider>();
              final configProvider = context.read<GameConfigViewModel>();
              final localeProvider = context.read<LocaleViewModel>();

              final difficulty = revealProvider.currentRound?.punishmentDifficulty ?? PunishmentDifficulty.low;
              final randomPunishment = configProvider.getRandomPunishmentForDifficulty(
                difficulty,
                localeProvider.currentLanguage,
              );

              resultProvider.calculateResults(viewModel.players, viewModel.votes, randomPunishment, difficulty);
              context.go('/results');
            },
          ),
        ),
      );
    }

    if (_selectedPlayerIndex != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: CNButton(
            label: context.watch<LocaleViewModel>().l10n.get('confirm_vote'),
            config: const CNButtonConfig(style: CNButtonStyle.prominentGlass),
            onPressed: () {
              viewModel.castVote(_selectedPlayerIndex!);
              setState(() {
                _selectedPlayerIndex = null;
              });
            },
          ),
        ),
      );
    }

    return const SizedBox(height: 60);
  }
}

class _PulsingAvatar extends StatefulWidget {
  final Widget child;
  const _PulsingAvatar({required this.child});

  @override
  State<_PulsingAvatar> createState() => _PulsingAvatarState();
}

class _PulsingAvatarState extends State<_PulsingAvatar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.25,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _scaleAnimation, child: widget.child);
  }
}
