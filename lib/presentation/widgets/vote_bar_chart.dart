import 'package:flutter/material.dart';
import 'package:impostor/domain/entities/game_player.dart';
import 'package:impostor/presentation/widgets/player_avatar.dart';

class VoteBarChart extends StatelessWidget {
  final Map<int, int> voteCounts;
  final List<int> sortedPlayerIndices;
  final List<GamePlayer> players;
  final int blufferIndex;

  const VoteBarChart({
    super.key,
    required this.voteCounts,
    required this.sortedPlayerIndices,
    required this.players,
    required this.blufferIndex,
  });

  @override
  Widget build(BuildContext context) {
    int maxVotes = voteCounts.values.fold(1, (prev, element) => element > prev ? element : prev);

    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: sortedPlayerIndices.length,
        itemBuilder: (context, index) {
          final playerIdx = sortedPlayerIndices[index];
          final votes = voteCounts[playerIdx] ?? 0;
          final isBluffer = playerIdx == blufferIndex;

          return _BarItem(
            player: players.firstWhere((p) => p.index == playerIdx),
            votes: votes,
            maxVotes: maxVotes,
            isBluffer: isBluffer,
          );
        },
      ),
    );
  }
}

class _BarItem extends StatefulWidget {
  final GamePlayer player;
  final int votes;
  final int maxVotes;
  final bool isBluffer;

  const _BarItem({required this.player, required this.votes, required this.maxVotes, required this.isBluffer});

  @override
  State<_BarItem> createState() => _BarItemState();
}

class _BarItemState extends State<_BarItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    _heightAnimation = Tween<double>(
      begin: 0,
      end: widget.votes.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PlayerAvatar(
            avatarPath: widget.player.avatarPath,
            isCustomAvatar: widget.player.isCustomAvatar,
            name: widget.player.name,
            size: 44,
            borderWidth: 2,
            borderColor: widget.isBluffer ? Colors.redAccent : Colors.white24,
          ),
          const SizedBox(height: 8),
          // Vote Count Label
          Text(
            widget.votes.toString(),
            style: TextStyle(
              color: widget.isBluffer ? Colors.redAccent : Colors.white70,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          // Animated Bar
          AnimatedBuilder(
            animation: _heightAnimation,
            builder: (context, child) {
              double ratio = widget.maxVotes > 0 ? (_heightAnimation.value / widget.maxVotes) : 0;
              double barHeight = 150 * ratio;

              return Container(
                width: 44,
                height: barHeight.clamp(4.0, 150.0),
                decoration: BoxDecoration(
                  color: widget.isBluffer ? Colors.redAccent : const Color(0xFF6200EE),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(4, 0))],
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          // Player Name Label
          Text(
            widget.player.name,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
