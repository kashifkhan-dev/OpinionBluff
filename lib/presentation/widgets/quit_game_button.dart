import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class QuitGameButton extends StatelessWidget {
  const QuitGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.watch<LocaleViewModel>().l10n;
    return TextButton(
      onPressed: () => _showQuitDialog(context),
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFFFF3B30).withValues(alpha: 0.7),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        l10n.get('quit').toUpperCase(),
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.5),
      ),
    );
  }

  void _showQuitDialog(BuildContext context) {
    final l10n = context.read<LocaleViewModel>().l10n;

    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(l10n.get('quit_confirm_title')),
        content: Text(l10n.get('quit_confirm_message')),
        actions: [
          CupertinoDialogAction(onPressed: () => Navigator.pop(context), child: Text(l10n.get('cancel'))),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              context.go('/home');
            },
            child: Text(l10n.get('confirm_quit')),
          ),
        ],
      ),
    );
  }
}
