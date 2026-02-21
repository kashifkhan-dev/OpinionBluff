import 'package:flutter/material.dart';
import 'package:opinion_bluff/domain/entities/vote.dart';
import 'package:opinion_bluff/domain/entities/game_player.dart';

class VotingProvider extends ChangeNotifier {
  List<GamePlayer> _players = [];
  List<Vote> _votes = [];
  int _activeVoterIndex = 0;
  bool _isPassingDevice = true;
  bool _allVotesCompleted = false;

  List<GamePlayer> get players => _players;
  List<Vote> get votes => _votes;
  int get activeVoterIndex => _activeVoterIndex;
  bool get isPassingDevice => _isPassingDevice;
  bool get allVotesCompleted => _allVotesCompleted;
  GamePlayer? get currentVoter => _players.isNotEmpty ? _players[_activeVoterIndex] : null;

  void initialize(List<GamePlayer> players) {
    _players = players;
    _votes = [];
    _activeVoterIndex = 0;
    _isPassingDevice = true;
    _allVotesCompleted = false;
    notifyListeners();
  }

  void continueToVote() {
    _isPassingDevice = false;
    notifyListeners();
  }

  void castVote(int votedForIndex) {
    if (_allVotesCompleted) return;

    _votes.add(Vote(voterIndex: _activeVoterIndex, votedForIndex: votedForIndex));

    if (_activeVoterIndex < _players.length - 1) {
      _activeVoterIndex++;
      _isPassingDevice = true;
    } else {
      _allVotesCompleted = true;
    }
    notifyListeners();
  }

  bool hasPlayerVoted(int index) {
    return _votes.any((v) => v.voterIndex == index);
  }
}
