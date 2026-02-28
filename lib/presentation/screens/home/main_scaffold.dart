import 'package:flutter/material.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:impostor/presentation/screens/home/game_config_screen.dart';
import 'package:impostor/presentation/screens/settings/settings_screen.dart';
import 'package:impostor/presentation/viewmodels/locale_view_model.dart';
import 'package:provider/provider.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [const GameConfigScreen(), const SettingsScreen()];

  @override
  Widget build(BuildContext context) {
    final bool isIPad = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF070421), Color(0xFF000000)],
                ),
              ),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isIPad ? 600 : double.infinity),
                child: _pages[_currentIndex],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, isIPad ? 40 : 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: CNTabBar(
                  currentIndex: _currentIndex,
                  onTap: (index) => setState(() => _currentIndex = index),
                  items: [
                    CNTabBarItem(
                      label: context.watch<LocaleViewModel>().l10n.get('game'),
                      icon: const CNSymbol('gamecontroller'),
                      activeIcon: const CNSymbol('gamecontroller.fill'),
                    ),
                    CNTabBarItem(
                      label: context.watch<LocaleViewModel>().l10n.get('settings'),
                      icon: const CNSymbol('gearshape'),
                      activeIcon: const CNSymbol('gearshape.fill'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
