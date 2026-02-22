import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';

class NamesScreen extends StatelessWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const NamesScreen({super.key, required this.onContinue, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<GameConfigViewModel>();
    final bool isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isIPad ? 120 : 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Who is Playing?',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Add at least 3 players to start.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),

          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: viewModel.playerNames.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: TextField(
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      icon: Icon(Icons.person_outline, color: Colors.white.withValues(alpha: 0.5)),
                      border: InputBorder.none,
                      hintText: 'Enter name...',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                      suffixIcon: const Icon(Icons.edit_note_rounded, color: Colors.white24, size: 22),
                    ),
                    onChanged: (value) => viewModel.updatePlayerName(index, value),
                    controller: TextEditingController(text: viewModel.playerNames[index])
                      ..selection = TextSelection.fromPosition(
                        TextPosition(offset: viewModel.playerNames[index].length),
                      ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: SizedBox(
              width: 200,
              child: CNButton(
                label: 'Continue',
                config: CNButtonConfig(style: CNButtonStyle.prominentGlass),
                onPressed: onContinue,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
