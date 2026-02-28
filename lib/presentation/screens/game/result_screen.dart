import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:impostor/presentation/viewmodels/result_provider.dart';
import 'package:impostor/presentation/widgets/vote_bar_chart.dart';
import 'package:impostor/presentation/viewmodels/locale_view_model.dart';
import 'package:impostor/presentation/viewmodels/game_config_view_model.dart';
import 'package:impostor/presentation/widgets/quit_game_button.dart';
import 'package:impostor/presentation/widgets/player_avatar.dart';
import 'package:impostor/domain/entities/game_player.dart';

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
                  players: viewModel.players,
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

  Widget _buildWinnerHeader(ResultProvider viewModel) {
    final bool groupWins = viewModel.isGroupWinner;
    final l10n = context.watch<LocaleViewModel>().l10n;

    return Column(
      children: [
        Image(
          image: AssetImage(groupWins ? 'assets/images/group_wins.png' : 'assets/images/bluffer_wins.png'),
          height: 250,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            groupWins ? l10n.get('group_wins') : l10n.get('bluffer_wins'),
            style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w900),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            groupWins ? l10n.get('bluffer_caught_desc') : l10n.get('bluffer_convincing_desc'),
            style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildPunishmentCard(String punishment, bool groupWins) {
    final l10n = context.watch<LocaleViewModel>().l10n;
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Color(0xFFFF3B30), size: 20),
                  const SizedBox(width: 8),
                  Text(
                    l10n.get('the_punishment_label'),
                    style: const TextStyle(
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
                punishment.startsWith('punishment_') ? l10n.get(punishment) : punishment,
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                groupWins ? l10n.get('bluffer_pay_price') : l10n.get('group_pay_price'),
                style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              CNButton(
                label: l10n.get('change'),
                config: const CNButtonConfig(style: CNButtonStyle.tinted),
                onPressed: () => _showPunishmentPicker(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPunishmentPicker(BuildContext context) {
    final resultVm = context.read<ResultProvider>();
    final configVm = context.read<GameConfigViewModel>();
    final localeVm = context.read<LocaleViewModel>();
    final l10n = localeVm.l10n;

    final punishments = configVm.allPunishments.where((p) => p.difficulty == resultVm.difficulty).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1C1C1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.get('punishments'),
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: punishments.length,
                itemBuilder: (context, index) {
                  final p = punishments[index];
                  final isSelected = resultVm.punishment == p.name.getForLanguage(localeVm.currentLanguage);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: CNButton(
                      label: p.name.getForLanguage(localeVm.currentLanguage),
                      config: CNButtonConfig(style: isSelected ? CNButtonStyle.filled : CNButtonStyle.glass),
                      onPressed: () {
                        resultVm.updatePunishment(p.name.getForLanguage(localeVm.currentLanguage));
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsToggle() {
    final l10n = context.watch<LocaleViewModel>().l10n;
    return TextButton(
      onPressed: () {
        setState(() {
          _showDetails = !_showDetails;
        });
      },
      child: Text(
        _showDetails ? l10n.get('hide_vote_details') : l10n.get('show_vote_details'),
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
    final l10n = context.watch<LocaleViewModel>().l10n;
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
          _buildTableRow([
            l10n.get('player_table_header'),
            l10n.get('voted_for_table_header'),
            l10n.get('result_table_header'),
          ], isHeader: true),
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
                  _buildDataRow(
                    voter: voter,
                    votedFor: votedFor,
                    resultText: isCorrect ? l10n.get('correct_vote') : l10n.get('wrong_vote'),
                    isCorrect: isCorrect,
                  ),
                  if (vote != viewModel.allVotes.last) const Divider(color: Colors.white10, height: 1),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              cells[0],
              style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              cells[1],
              style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              cells[2],
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow({
    required GamePlayer voter,
    required GamePlayer votedFor,
    required String resultText,
    required bool isCorrect,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                PlayerAvatar(
                  avatarPath: voter.avatarPath,
                  isCustomAvatar: voter.isCustomAvatar,
                  name: voter.name,
                  size: 24,
                  borderWidth: 1,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    voter.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                PlayerAvatar(
                  avatarPath: votedFor.avatarPath,
                  isCustomAvatar: votedFor.isCustomAvatar,
                  name: votedFor.name,
                  size: 24,
                  borderWidth: 1,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    votedFor.name,
                    style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.normal, fontSize: 13),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              resultText,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: isCorrect ? const Color(0xFF34C759) : Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeButton(BuildContext context) {
    final l10n = context.watch<LocaleViewModel>().l10n;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: CNButton(
          label: l10n.get('back_to_lobby'),
          config: const CNButtonConfig(style: CNButtonStyle.prominentGlass),
          onPressed: () => context.go('/home'),
        ),
      ),
    );
  }
}
