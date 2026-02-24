import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/subscription_provider.dart';
import 'subscription_widgets.dart';

class WelcomeOfferScreen extends StatelessWidget {
  final SubscriptionPlan selectedPlan;

  const WelcomeOfferScreen({super.key, required this.selectedPlan});

  @override
  Widget build(BuildContext context) {
    final l10n = context.watch<LocaleViewModel>().l10n;
    final isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF9100FF), Color(0xFF7000E0)],
          ),
        ),
        child: Stack(
          children: [
            // Fireworks Decorative Icons (Simulated)
            Positioned(top: 100, left: 40, child: _buildFirework()),
            Positioned(top: 100, right: 40, child: _buildFirework()),

            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Lottie Gift
                          Lottie.asset('assets/jumping gift.json', height: isIPad ? 300 : 200, fit: BoxFit.contain),
                          const SizedBox(height: 20),
                          // Title
                          Text(
                            l10n.get('welcome_offer_title'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Offer Box
                          _buildOfferBox(context, l10n),
                          const SizedBox(height: 32),
                          // Feature List
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SubscriptionFeatureRow(
                                  text: l10n.get('feature_unlock_all'),
                                  icon: const Text('🔒', style: TextStyle(fontSize: 18)),
                                ),
                                SubscriptionFeatureRow(
                                  text: l10n.get('feature_create_topics'),
                                  icon: const Text('✨', style: TextStyle(fontSize: 18)),
                                ),
                                SubscriptionFeatureRow(
                                  text: l10n.get('feature_regular_updates'),
                                  icon: const Text('🎭', style: TextStyle(fontSize: 18)),
                                ),
                                SubscriptionFeatureRow(
                                  text: l10n.get('feature_no_ads'),
                                  icon: const Text('🚫', style: TextStyle(fontSize: 18)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Unique Offer Footer
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('⚡ ', style: TextStyle(fontSize: 18)),
                                Text(
                                  l10n.get('unique_offer'),
                                  style: const TextStyle(
                                    color: Color(0xFFFFB800),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
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
                          context.read<SubscriptionProvider>().subscribe(selectedPlan);
                          Navigator.pop(context); // Pop welcome
                          Navigator.pop(context); // Pop unlimited
                        },
                        child: Text(
                          l10n.get('activate_offer'),
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
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
      ),
    );
  }

  Widget _buildOfferBox(BuildContext context, dynamic l10n) {
    final bool isAnnual = selectedPlan == SubscriptionPlan.annual;
    final strikePrice = isAnnual ? l10n.get('price_per_year') : l10n.get('price_per_week_weekly');
    final offerPrice = isAnnual ? l10n.get('only_price_annual') : l10n.get('only_price');
    final discount = isAnnual ? l10n.get('save_67') : l10n.get('save_86');
    final subtitle = isAnnual ? l10n.get('welcome_offer_subtitle_annual') : l10n.get('welcome_offer_subtitle');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF4A00B0).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFB800), width: 2),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: -42,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFFFB800), borderRadius: BorderRadius.circular(20)),
              child: Text(
                discount,
                style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 8),
              Text(
                strikePrice,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: Colors.red,
                  decorationThickness: 2,
                ),
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('🎉 ', style: TextStyle(fontSize: 24)),
                    Text(
                      offerPrice,
                      style: const TextStyle(color: Color(0xFFFFB800), fontSize: 32, fontWeight: FontWeight.w900),
                    ),
                    const Text(' 🎉', style: TextStyle(fontSize: 24)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFirework() {
    return const Text('🎇', style: TextStyle(fontSize: 40, color: Colors.white24));
  }
}
