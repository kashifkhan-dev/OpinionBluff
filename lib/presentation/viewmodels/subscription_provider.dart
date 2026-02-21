import 'package:flutter/material.dart';

enum SubscriptionPlan { none, trial, weekly, annual }

class SubscriptionProvider extends ChangeNotifier {
  SubscriptionPlan _currentPlan = SubscriptionPlan.none;

  SubscriptionPlan get currentPlan => _currentPlan;
  bool get isSubscribed => _currentPlan != SubscriptionPlan.none;

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
