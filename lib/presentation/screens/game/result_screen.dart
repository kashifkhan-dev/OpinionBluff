import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/result_provider.dart';
import 'package:opinion_bluff/presentation/widgets/vote_bar_chart.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ResultProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
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
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // Top Safe Area Padding
                SizedBox(height: MediaQuery.of(context).padding.top + 20),
                _buildWinnerHeader(viewModel),
                const SizedBox(height: 16),
                _buildPunishmentCard(viewModel.punishment, viewModel.isGroupWinner),
                const SizedBox(height: 40),

                // Custom Bar Chart
                VoteBarChart(
                  voteCounts: viewModel.voteCounts,
                  sortedPlayerIndices: viewModel.sortedPlayerIndices,
                  playerNames: viewModel.players.map((p) => p.name).toList(),
                  blufferIndex: viewModel.blufferIndex,
                ),

                const SizedBox(height: 40),

                // Votes Breakdown toggle
                _buildDetailsToggle(),

                if (_showDetails) ...[const SizedBox(height: 20), _buildBreakdownTable(viewModel)],

                const SizedBox(height: 40),
                _buildHomeButton(context),

                // Bottom Safe Area Padding
                SizedBox(height: MediaQuery.of(context).padding.bottom + 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerHeader(ResultProvider viewModel) {
    final bool groupWins = viewModel.isGroupWinner;

    return Column(
      children: [
        Image(
          image: AssetImage(groupWins ? 'assets/images/group_wins.png' : 'assets/images/bluffer_wins.png'),
          height: 250,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        Text(
          groupWins ? 'Group Wins!' : 'Bluffer Wins!',
          style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          groupWins ? 'The Bluffer was caught.' : 'The Bluffer was too convincing.',
          style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildPunishmentCard(String punishment, bool groupWins) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: LiquidGlassContainer(
        config: LiquidGlassConfig(effect: CNGlassEffect.regular, cornerRadius: 24, shape: CNGlassEffectShape.rect),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFFF3B30).withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFFF3B30), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'THE PUNISHMENT',
                    style: TextStyle(
                      color: Color(0xFFFF3B30),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                punishment,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                groupWins ? 'The Bluffer must pay the price!' : 'The Group must pay the price!',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsToggle() {
    return TextButton(
      onPressed: () {
        setState(() {
          _showDetails = !_showDetails;
        });
      },
      child: Text(
        _showDetails ? 'Hide Vote Details' : 'Show Vote Details',
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildBreakdownTable(ResultProvider viewModel) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          // Header Row
          _buildTableRow(['Player', 'Voted For', 'Result'], isHeader: true),
          const Divider(color: Colors.white10, height: 1),
          // Data Rows
          ...viewModel.allVotes.asMap().entries.map((entry) {
            final index = entry.key;
            final vote = entry.value;
            final voter = viewModel.players[vote.voterIndex];
            final votedFor = viewModel.players[vote.votedForIndex];
            final bool isCorrect = vote.votedForIndex == viewModel.blufferIndex;

            return Container(
              color: index.isEven ? Colors.transparent : Colors.white.withValues(alpha: 0.03),
              child: Column(
                children: [
                  _buildTableRow([voter.name, votedFor.name, isCorrect ? 'Correct' : 'Wrong'], isCorrect: isCorrect),
                  if (vote != viewModel.allVotes.last) const Divider(color: Colors.white10, height: 1),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableRow(List<String> cells, {bool isHeader = false, bool? isCorrect}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              cells[0],
              style: TextStyle(
                color: isHeader ? Colors.white38 : Colors.white,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              cells[1],
              style: TextStyle(
                color: isHeader ? Colors.white38 : Colors.white70,
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              cells[2],
              textAlign: TextAlign.right,
              style: TextStyle(
                color: isHeader ? Colors.white38 : (isCorrect == true ? const Color(0xFF34C759) : Colors.redAccent),
                fontWeight: FontWeight.bold,
                fontSize: isHeader ? 12 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: CNButton(
          label: 'Back to Lobby',
          config: CNButtonConfig(style: CNButtonStyle.prominentGlass),
          onPressed: () => context.go('/home'),
        ),
      ),
    );
  }
}
