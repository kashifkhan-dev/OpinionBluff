import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';

class GameConfigScreen extends StatelessWidget {
  const GameConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: isIPad ? 300 : 200,
                    height: isIPad ? 300 : 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.red.withValues(alpha: 0.15), blurRadius: 40, spreadRadius: 10),
                      ],
                    ),
                    child: Image.asset('assets/images/detective_spy.png', fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Opinion Bluff',
                    style: TextStyle(
                      color: const Color(0xFFFF3B30),
                      fontSize: isIPad ? 52 : 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.5,
                      shadows: [Shadow(color: Colors.black45, offset: Offset(0, 4), blurRadius: 8)],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Unlock Banner
            _buildUnlockBanner(),
            const SizedBox(height: 16),

            // Settings Cards
            _buildSettingsSection(context),
            const SizedBox(height: 24),

            // Start Game Button
            _buildStartGameButton(),
            const SizedBox(height: 120), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockBanner() {
    return LiquidGlassContainer(
      config: LiquidGlassConfig(effect: CNGlassEffect.prominent, cornerRadius: 22, shape: CNGlassEffectShape.rect),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF5E3A), Color(0xFFFF2D55)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF2D55).withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.card_giftcard_rounded, color: Colors.orangeAccent, size: 28),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Unlock everything!',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Get all packs, create custom words, remove ads.',
                    style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white70, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final viewModel = context.watch<GameConfigViewModel>();

    return Column(
      children: [
        _buildConfigGroup([
          _buildConfigRow(
            icon: Icons.people_rounded,
            label: 'Players',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildIconButton(Icons.remove, viewModel.decrementPlayers),
                const SizedBox(width: 12),
                Text(
                  viewModel.players.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                _buildIconButton(Icons.add, viewModel.incrementPlayers),
              ],
            ),
          ),
          const Divider(color: Colors.white10),
          _buildConfigRow(icon: Icons.timer_outlined, label: 'Duration', value: viewModel.duration, showChevron: true),
          const Divider(color: Colors.white10),
          _buildConfigRow(icon: Icons.help_outline_rounded, label: 'Help', showChevron: true),
        ]),
        const SizedBox(height: 16),
        _buildConfigGroup([
          _buildConfigRow(icon: Icons.layers_rounded, label: 'Packs', value: viewModel.selectedPack, showChevron: true),
        ]),
      ],
    );
  }

  Widget _buildConfigRow({
    required IconData icon,
    required String label,
    String? value,
    Widget? trailing,
    bool showChevron = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white70)),
          ),
          if (value != null) ...[Text(value, style: const TextStyle(color: Colors.white))],
          if (showChevron) ...[const SizedBox(width: 4), const Icon(Icons.chevron_right, color: Colors.white38)],
          if (trailing != null) ...[trailing],
        ],
      ),
    );
  }

  Widget _buildConfigGroup(List<Widget> children) {
    return LiquidGlassContainer(
      config: LiquidGlassConfig(effect: CNGlassEffect.regular, cornerRadius: 16, shape: CNGlassEffectShape.rect),
      child: Column(children: children),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildStartGameButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: const Color(0xFF34C759).withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 64,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF34C759),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            elevation: 0,
          ),
          onPressed: () {},
          child: const Text(
            'Start Game',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }
}
