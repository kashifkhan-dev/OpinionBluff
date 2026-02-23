import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/onboarding_view_model.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';

class PreferenceScreen extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;
  const PreferenceScreen({super.key, required this.onContinue, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<OnboardingViewModel>();
    final l10n = context.watch<LocaleViewModel>().l10n;
    final bool isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    final options = [
      {'label': l10n.get('friends'), 'image': 'assets/onboarding/selections/friend1.jpeg', 'color': Colors.blue},
      {'label': l10n.get('family'), 'image': 'assets/onboarding/selections/family2.jpeg', 'color': Colors.amber},
    ];

    return Stack(
      children: [
        // Title centered at the very top
        Positioned(
          top: 50,
          left: 40,
          right: 40,
          child: Text(
            l10n.get('who_play_with'),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
        ),
        // Main Content starting below the top section
        Padding(
          padding: EdgeInsets.fromLTRB(isIPad ? 64 : 24, 150, isIPad ? 64 : 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Selection Grid
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isIPad ? 800 : double.infinity),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: isIPad ? 32 : 16,
                        crossAxisSpacing: isIPad ? 32 : 16,
                        childAspectRatio: isIPad ? 1.1 : 0.9,
                      ),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final option = options[index];
                        final isSelected = viewModel.data.playerPreference == (option['label'] as String);
                        final isSomethingSelected = viewModel.data.playerPreference.isNotEmpty;
                        final double scale = isSelected ? 1.05 : (isSomethingSelected ? 0.92 : 1.0);

                        return _PreferenceOptionTile(
                          label: option['label'] as String,
                          image: option['image'] as String,
                          baseColor: option['color'] as Color,
                          isSelected: isSelected,
                          scale: scale,
                          onTap: () => viewModel.updatePlayerPreference(option['label'] as String),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Text(
                l10n.get('driver_instruction'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white38, fontSize: 13),
              ),
              const SizedBox(height: 24),
              // Continue Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isIPad ? 80 : 32),
                child: SizedBox(
                  height: 60,
                  child: CNButton(
                    label: l10n.get('continue'),
                    config: CNButtonConfig(
                      style: viewModel.isPreferenceSelected ? CNButtonStyle.prominentGlass : CNButtonStyle.glass,
                    ),
                    onPressed: viewModel.isPreferenceSelected ? onContinue : null,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreferenceOptionTile extends StatefulWidget {
  final String label;
  final String image;
  final Color baseColor;
  final bool isSelected;
  final double scale;
  final VoidCallback onTap;

  const _PreferenceOptionTile({
    required this.label,
    required this.image,
    required this.baseColor,
    required this.isSelected,
    required this.scale,
    required this.onTap,
  });

  @override
  State<_PreferenceOptionTile> createState() => _PreferenceOptionTileState();
}

class _PreferenceOptionTileState extends State<_PreferenceOptionTile> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (widget.isSelected) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(_PreferenceOptionTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: widget.scale,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            final t = _animation.value;
            // Interpolate colors and weights
            final borderAlpha = 0.1 + (0.5 * t);
            final gradientAlpha = 0.6 + (0.3 * t); // Darken by increasing opacity from 0.6 to 0.9
            final shadowBlur = 8.0 + (7.0 * t); // Stronger glow when selected

            return LiquidGlassContainer(
              config: LiquidGlassConfig(
                effect: widget.isSelected ? CNGlassEffect.prominent : CNGlassEffect.regular,
                cornerRadius: 28,
                interactive: true,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: widget.isSelected
                        ? widget.baseColor.withValues(alpha: borderAlpha)
                        : Colors.white.withValues(alpha: 0.1),
                    width: 1.5 + (4.5 * t), // Smoothly increase from 1.5 to 4.0
                  ),
                  boxShadow: t > 0
                      ? [BoxShadow(color: widget.baseColor.withValues(alpha: 0.3 * t), blurRadius: 15, spreadRadius: 1)]
                      : [],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background Image with 20% Zoom
                      Transform.scale(scale: 1.2, child: Image.asset(widget.image, fit: BoxFit.cover)),
                      // Animated Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.1 + (0.2 * t)), // Darker top when selected
                              widget.baseColor.withValues(alpha: gradientAlpha),
                            ],
                            stops: [0.4 - (0.1 * t), 1.0],
                          ),
                        ),
                      ),
                      // Label
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            widget.label,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: t > 0.5 ? FontWeight.w900 : FontWeight.w600,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5 + (0.3 * t)),
                                  blurRadius: shadowBlur,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Selection Checkmark (Top Right)
                      if (widget.isSelected)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Opacity(
                            opacity: t,
                            child: Icon(Icons.check_circle, color: widget.baseColor, size: 28),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
