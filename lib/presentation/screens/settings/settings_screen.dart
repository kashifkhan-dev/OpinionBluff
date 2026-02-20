import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GameConfigViewModel>();
    final bool isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: isIPad ? 42 : 34,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            const Text('Player Names', style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 24),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.playerNames.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return LiquidGlassContainer(
                  config: LiquidGlassConfig(
                    effect: CNGlassEffect.regular,
                    cornerRadius: 16,
                    shape: CNGlassEffectShape.rect,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: InputDecoration(
                        icon: Icon(Icons.person_outline, color: Colors.white.withValues(alpha: 0.5)),
                        border: InputBorder.none,
                        hintText: 'Enter name...',
                        hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      onChanged: (value) => viewModel.updatePlayerName(index, value),
                      controller: TextEditingController(text: viewModel.playerNames[index])
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: viewModel.playerNames[index].length),
                        ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 120), // Space for bottom nav
          ],
        ),
      ),
    );
  }
}
