import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/subscription_provider.dart';
import 'subscription_widgets.dart';

class UnlimitedAccessScreen extends StatefulWidget {
  const UnlimitedAccessScreen({super.key});

  @override
  State<UnlimitedAccessScreen> createState() => _UnlimitedAccessScreenState();
}

class _UnlimitedAccessScreenState extends State<UnlimitedAccessScreen> {
  SubscriptionPlan _selectedPlan = SubscriptionPlan.annual;

  @override
  Widget build(BuildContext context) {
    final l10n = context.watch<LocaleViewModel>().l10n;
    final isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFF01060C),
      body: Stack(
        children: [
          // Background Elements
          Positioned(
            top: 40,
            left: 20,
            child: Opacity(
              opacity: 0.1,
              child: Transform.rotate(angle: -0.2, child: const Text('🎭', style: TextStyle(fontSize: 100))),
            ),
          ),
          Positioned(
            top: 60,
            right: 40,
            child: Opacity(
              opacity: 0.1,
              child: Transform.rotate(
                angle: 0.3,
                child: const Text(
                  '?',
                  style: TextStyle(color: Colors.white, fontSize: 120, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Positioned(
            top: 180,
            left: 40,
            child: Opacity(
              opacity: 0.1,
              child: Transform.rotate(angle: -0.4, child: const Text('🔍', style: TextStyle(fontSize: 80))),
            ),
          ),
          Positioned(
            top: 220,
            right: 60,
            child: Opacity(
              opacity: 0.1,
              child: Transform.rotate(
                angle: 0.2,
                child: const Text(
                  '?',
                  style: TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Character Image
                          Transform.scale(
                            scale: 1.2,
                            child: Image.asset(
                              'assets/images/detective_spy.png',
                              height: isIPad ? 350 : 220,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Title
                          Text(
                            l10n.get('unlimited_access_title').toUpperCase(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFFFB800),
                              fontSize: 34,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Features List
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SubscriptionFeatureRow(
                                text: l10n.get('feature_unlock_all'),
                                icon: const Text('🔒', style: TextStyle(fontSize: 20)),
                              ),
                              SubscriptionFeatureRow(
                                text: l10n.get('feature_create_topics'),
                                icon: const Text('✨', style: TextStyle(fontSize: 20)),
                              ),
                              SubscriptionFeatureRow(
                                text: l10n.get('feature_regular_updates'),
                                icon: const Text('🎭', style: TextStyle(fontSize: 20)),
                              ),
                              SubscriptionFeatureRow(
                                text: l10n.get('feature_no_ads'),
                                icon: const Text('🚫', style: TextStyle(fontSize: 20)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Pricing Cards
                          SubscriptionPricingCard(
                            title: l10n.get('annual'),
                            description: l10n.get('annual_plan_desc_offer'),
                            badgeText: l10n.get('save_97'),
                            pricePerWeek: l10n.get('price_per_week_annual_offer'),
                            isSelected: _selectedPlan == SubscriptionPlan.annual,
                            onTap: () => setState(() => _selectedPlan = SubscriptionPlan.annual),
                          ),
                          const SizedBox(height: 12),
                          SubscriptionPricingCard(
                            title: l10n.get('weekly_plan_label'),
                            description: l10n.get('weekly_plan_desc_offer'),
                            pricePerWeek: l10n.get('price_per_week_weekly_offer'),
                            isSelected: _selectedPlan == SubscriptionPlan.weekly,
                            onTap: () => setState(() => _selectedPlan = SubscriptionPlan.weekly),
                          ),
                          const SizedBox(height: 40),
                          // Footer Text
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/wheat_ear.png', height: 40, color: Colors.white24),
                                const SizedBox(width: 12),
                                Column(
                                  children: [
                                    Text(
                                      l10n.get('best_party_game').toUpperCase(),
                                      style: const TextStyle(
                                        color: Color(0xFFFFB800),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      l10n.get('fun_for_any_group'),
                                      style: const TextStyle(
                                        color: Colors.white38,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Transform.flip(
                                  flipX: true,
                                  child: Image.asset('assets/images/wheat_ear.png', height: 40, color: Colors.white24),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                // Bottom Button
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00D261),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        elevation: 0,
                      ),
                      onPressed: () {
                        context.push('/subscription-welcome', extra: _selectedPlan);
                      },
                      child: Text(
                        l10n.get('continue').toUpperCase(),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Close Button
          Positioned(top: 50, right: 24, child: CloseButtonCircular(onTap: () => Navigator.pop(context))),
        ],
      ),
    );
  }
}
