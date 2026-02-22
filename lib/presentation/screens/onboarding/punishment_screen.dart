import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:opinion_bluff/presentation/viewmodels/game_config_view_model.dart';

class PunishmentScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const PunishmentScreen({super.key, required this.onContinue, required this.onBack});

  @override
  State<PunishmentScreen> createState() => _PunishmentScreenState();
}

class _PunishmentScreenState extends State<PunishmentScreen> {
  final TextEditingController _customController = TextEditingController();

  void _showAddCustomDialog(BuildContext context, GameConfigViewModel viewModel) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Add Punishment'),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: CupertinoTextField(
            controller: _customController,
            placeholder: 'Type punishment here...',
            style: const TextStyle(color: Colors.white),
            cursorColor: const Color(0xFFFF3B30),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(child: const Text('Cancel'), onPressed: () => Navigator.pop(context)),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Add', style: TextStyle(color: Color(0xFFFF3B30))),
            onPressed: () {
              if (_customController.text.isNotEmpty) {
                viewModel.addCustomPunishment(_customController.text);
                _customController.clear();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

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
            'Choose Punishment',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'The Bluffer must do this if they get caught!',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                ...viewModel.allPunishments.map((p) {
                  final isSelected = viewModel.selectedPunishment == p;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => viewModel.updatePunishment(p),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFFF3B30).withValues(alpha: 0.2)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFFF3B30) : Colors.white.withValues(alpha: 0.1),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                p,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.white70,
                                  fontSize: 16,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFFF3B30), size: 22),
                          ],
                        ),
                      ),
                    ),
                  );
                }),

                CNButton(
                  label: '+ Add Custom Punishment',
                  config: CNButtonConfig(style: CNButtonStyle.tinted),
                  onPressed: () => _showAddCustomDialog(context, viewModel),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: SizedBox(
              width: 200,
              child: CNButton(
                label: 'Continue',
                config: CNButtonConfig(style: CNButtonStyle.prominentGlass),
                onPressed: widget.onContinue,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
