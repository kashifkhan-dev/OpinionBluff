import 'package:flutter/material.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:go_router/go_router.dart';
import 'package:opinion_bluff/presentation/viewmodels/locale_view_model.dart';
import 'package:opinion_bluff/core/localization/app_localizations.dart';
import 'package:provider/provider.dart';

class HowToPlayScreen extends StatefulWidget {
  final bool isStandalone;
  final VoidCallback? onComplete;
  const HowToPlayScreen({super.key, this.isStandalone = false, this.onComplete});

  @override
  State<HowToPlayScreen> createState() => _HowToPlayScreenState();
}

class _HowToPlayScreenState extends State<HowToPlayScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, dynamic>> _getSegments(AppLocalizations l10n) => [
    {
      'title': l10n.get('htp_overview_title'),
      'description': l10n.get('htp_overview_desc'),
      'detail': l10n.get('htp_overview_detail'),
      'icon': 'doc.text.magnifyingglass',
      'image': 'assets/images/onboarding_results.png',
    },
    {
      'title': l10n.get('htp_reveal_title'),
      'description': l10n.get('htp_reveal_desc'),
      'detail': l10n.get('htp_reveal_detail'),
      'icon': 'hand.raised.fill',
      'image': 'assets/images/onboarding_reveal.png',
    },
    {
      'title': l10n.get('htp_discussion_title'),
      'description': l10n.get('htp_discussion_desc'),
      'detail': l10n.get('htp_discussion_detail'),
      'icon': 'bubble.left.and.bubble.right.fill',
      'image': 'assets/images/onboarding_discussion.png',
    },
    {
      'title': l10n.get('htp_voting_title'),
      'description': l10n.get('htp_voting_desc'),
      'detail': l10n.get('htp_voting_detail'),
      'icon': 'checkmark.seal.fill',
      'image': 'assets/images/onboarding_voting.png',
    },
  ];

  void _nextPage() {
    final l10n = context.read<LocaleViewModel>().l10n;
    final segments = _getSegments(l10n);
    if (_currentPage < segments.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutCubic);
    } else {
      if (widget.onComplete != null) {
        widget.onComplete!();
      } else if (widget.isStandalone) {
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isIPad = MediaQuery.of(context).size.shortestSide >= 600;
    final l10n = context.watch<LocaleViewModel>().l10n;
    final segments = _getSegments(l10n);

    return Scaffold(
      backgroundColor: widget.isStandalone ? const Color(0xFF070421) : Colors.transparent,
      body: Stack(
        children: [
          if (widget.isStandalone)
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
            child: Column(
              children: [
                if (widget.isStandalone)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12),
                    child: Row(
                      children: [
                        CNButton.icon(
                          icon: const CNSymbol('arrow.left', size: 20),
                          config: const CNButtonConfig(style: CNButtonStyle.glass),
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 10),
                // Progress indicator
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isIPad ? 120 : 40, vertical: 20),
                  child: Row(
                    children: List.generate(segments.length, (index) {
                      return Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: index <= _currentPage ? const Color(0xFFFF3B30) : Colors.white24,
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: index <= _currentPage
                                ? [BoxShadow(color: const Color(0xFFFF3B30).withValues(alpha: 0.3), blurRadius: 8)]
                                : [],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemCount: segments.length,
                    itemBuilder: (context, index) {
                      final segment = segments[index];
                      final isCurrent = index == _currentPage;

                      return AnimatedOpacity(
                        duration: const Duration(milliseconds: 600),
                        opacity: isCurrent ? 1.0 : 0.0,
                        curve: Curves.easeOut,
                        child: AnimatedSlide(
                          duration: const Duration(milliseconds: 600),
                          offset: isCurrent ? Offset.zero : const Offset(0, 0.05),
                          curve: Curves.easeOutCubic,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: isIPad ? 120 : 40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 40),
                                  Hero(
                                    tag: 'detective_$index',
                                    child: Container(
                                      height: 240,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.red.withValues(alpha: 0.1),
                                            blurRadius: 50,
                                            spreadRadius: 10,
                                          ),
                                        ],
                                      ),
                                      child: Image.asset(segment['image']!, fit: BoxFit.contain),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  CNIcon(symbol: CNSymbol(segment['icon']!, size: 40, color: const Color(0xFFFF3B30))),
                                  const SizedBox(height: 16),
                                  Text(
                                    segment['title']!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isIPad ? 42 : 32,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    segment['description']!,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: isIPad ? 22 : 18,
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    segment['detail']!,
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: isIPad ? 18 : 15,
                                      fontStyle: FontStyle.italic,
                                      height: 1.4,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(isIPad ? 120 : 40, 20, isIPad ? 120 : 40, 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 64,
                    child: CNButton(
                      label: _currentPage == segments.length - 1 ? l10n.get('got_it') : l10n.get('next'),
                      config: const CNButtonConfig(style: CNButtonStyle.prominentGlass),
                      onPressed: _nextPage,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
