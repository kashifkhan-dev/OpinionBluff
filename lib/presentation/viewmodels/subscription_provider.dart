import 'package:flutter/material.dart';
import 'package:impostor/core/services/persistence_service.dart';

enum SubscriptionPlan { none, trial, weekly, annual }

class SubscriptionProvider extends ChangeNotifier {
  final PersistenceService _persistence = PersistenceService();
  SubscriptionPlan _currentPlan = SubscriptionPlan.none;
  int _gamesPlayed = 0;

  SubscriptionProvider() {
    _loadState();
  }

  SubscriptionPlan get currentPlan => _currentPlan;
  bool get isSubscribed => _currentPlan != SubscriptionPlan.none;
  int get gamesPlayed => _gamesPlayed;

  Future<void> _loadState() async {
    _gamesPlayed = await _persistence.getGameCount();
    notifyListeners();
  }

  bool get canPlay {
    // If subscribed, can always play
    if (isSubscribed) return true;
    // Otherwise, check if they have played more than the limit (1 game)
    return _gamesPlayed < 1;
  }

  Future<void> recordGamePlayed() async {
    await _persistence.incrementGameCount();
    _gamesPlayed = await _persistence.getGameCount();
    notifyListeners();
  }

  void subscribe(SubscriptionPlan plan) {
    _currentPlan = plan;
    notifyListeners();
  }

  void restorePurchase() {
    // Mock restore
    _currentPlan = SubscriptionPlan.trial;
    notifyListeners();
  }
}
