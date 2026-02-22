import 'package:flutter/material.dart';
import 'package:opinion_bluff/domain/entities/vote.dart';
import 'package:opinion_bluff/domain/entities/game_player.dart';
import 'dart:math';

class ResultProvider extends ChangeNotifier {
  Map<int, int> _voteCounts = {};
  int _blufferIndex = -1;
  bool _isGroupWinner = false;
  List<int> _sortedPlayerIndices = [];
  List<Vote> _allVotes = [];
  List<GamePlayer> _players = [];
  String _punishment = '';

  Map<int, int> get voteCounts => _voteCounts;
  int get blufferIndex => _blufferIndex;
  bool get isGroupWinner => _isGroupWinner;
  List<int> get sortedPlayerIndices => _sortedPlayerIndices;
  List<Vote> get allVotes => _allVotes;
  List<GamePlayer> get players => _players;
  String get punishment => _punishment;

  void calculateResults(List<GamePlayer> players, List<Vote> votes, String punishment) {
    _punishment = punishment;
    _players = players;
    _allVotes = votes;
    _voteCounts = {};
    for (var p in players) {
      _voteCounts[p.index] = 0;
    }

    for (var v in votes) {
      _voteCounts[v.votedForIndex] = (_voteCounts[v.votedForIndex] ?? 0) + 1;
    }

    _blufferIndex = players.firstWhere((p) => p.isBluffer).index;

    int maxVotes = _voteCounts.values.reduce(max);
    // Group wins if bluffer is among those with the most votes (or the single most)
    // User said: "If bluffer has highest vote count -> Group wins."
    _isGroupWinner = _voteCounts[_blufferIndex] == maxVotes && maxVotes > 0;

    // Sorting order for chart:
    // 1. Bluffer (always first)
    // 2. Others descending by vote count
    List<int> others = players.map((p) => p.index).where((idx) => idx != _blufferIndex).toList();

    others.sort((a, b) => (_voteCounts[b] ?? 0).compareTo(_voteCounts[a] ?? 0));

    _sortedPlayerIndices = [_blufferIndex, ...others];

    notifyListeners();
  }
}
