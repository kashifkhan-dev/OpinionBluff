import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/voting_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/reveal_provider.dart';
import 'package:opinion_bluff/presentation/viewmodels/result_provider.dart';
import 'package:opinion_bluff/domain/entities/game_player.dart';

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
              'Pass the phone to\n${viewModel.currentVoter?.name ?? "Player"}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: CNButton(
                label: 'Continue',
                config: CNButtonConfig(style: CNButtonStyle.prominentGlass),
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
          '${viewModel.currentVoter?.name}\'s Vote',
          style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 16),
        _buildVotingProgress(viewModel),
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Who is the Bluffer?',
            style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600),
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
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: voted ? const Color(0xFF34C759) : Colors.white10,
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(
              voted ? Icons.check : Icons.person_outline,
              size: 16,
              color: voted ? Colors.white : Colors.white24,
            ),
          );
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
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? Colors.white24 : Colors.white10),
              child: Center(
                child: Text(
                  player.name[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
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
            label: 'Show Results',
            config: CNButtonConfig(style: CNButtonStyle.prominentGlass),
            onPressed: () {
              final resultProvider = context.read<ResultProvider>();
              resultProvider.calculateResults(viewModel.players, viewModel.votes);
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
            label: 'Confirm Vote',
            config: CNButtonConfig(style: CNButtonStyle.prominentGlass),
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
