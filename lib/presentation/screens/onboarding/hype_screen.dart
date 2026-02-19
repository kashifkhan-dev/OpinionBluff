import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cupertino_native_better/cupertino_native_better.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/share_strings.dart';

class HypeScreen extends StatefulWidget {
  final VoidCallback onBack;
  const HypeScreen({super.key, required this.onBack});

  @override
  State<HypeScreen> createState() => _HypeScreenState();
}

class _HypeScreenState extends State<HypeScreen> {
  late ScrollController _scrollController;
  Timer? _timer;
  Timer? _resumeTimer;
  final double _scrollSpeed = 0.8;
  List<Map<String, dynamic>> _reviews = [];
  bool _isUserInteracting = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadReviews();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  Future<void> _loadReviews() async {
    try {
      final String response = await DefaultAssetBundle.of(context).loadString('assets/reviews.json');
      final data = json.decode(response);
      if (mounted) {
        setState(() {
          _reviews = List<Map<String, dynamic>>.from(data['reviews']);
        });
      }
    } catch (e) {
      debugPrint('Error loading reviews: $e');
    }
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_isUserInteracting) return;

      if (_scrollController.hasClients && _reviews.isNotEmpty) {
        if (_scrollController.position.maxScrollExtent > 0) {
          final currentScroll = _scrollController.offset;
          if (currentScroll >= _scrollController.position.maxScrollExtent) {
            _scrollController.jumpTo(0);
          } else {
            _scrollController.jumpTo(currentScroll + _scrollSpeed);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _resumeTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Title centered at the very top
        Positioned(
          top: 62,
          left: 40,
          right: 40,
          child: const Text(
            'Are you ready\nto party?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
        ),
        // Back navigation button
        Positioned(
          top: 2,
          left: 24,
          child: CNButton.icon(
            icon: CNSymbol('chevron.left', size: 20),
            config: CNButtonConfig(style: CNButtonStyle.glass),
            onPressed: widget.onBack,
          ),
        ),
        // Main Content
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 172, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Main Review Card (Regular Liquid Glass)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: LiquidGlassContainer(
                  config: LiquidGlassConfig(
                    effect: CNGlassEffect.regular,
                    shape: CNGlassEffectShape.rect,
                    cornerRadius: 20,
                    interactive: true,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                              Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                              Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                              Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                              Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '“This is honestly just so cool and fun — literally saves every night.”',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '#1 Party App Worldwide',
                          style: TextStyle(
                            color: Color(0xFF00C7FF),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Horizontal Infinite Reviews
              SizedBox(
                height: 154,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is ScrollStartNotification) {
                      if (notification.dragDetails != null) {
                        setState(() => _isUserInteracting = true);
                        _resumeTimer?.cancel();
                      }
                    } else if (notification is ScrollEndNotification) {
                      _resumeTimer?.cancel();
                      _resumeTimer = Timer(const Duration(seconds: 3), () {
                        if (mounted) {
                          setState(() => _isUserInteracting = false);
                        }
                      });
                    }
                    return false;
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _reviews.isEmpty ? 0 : 1000,
                    itemBuilder: (context, index) {
                      final review = _reviews[index % _reviews.length];
                      return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 24 : 12, right: index == 999 ? 24 : 0),
                        child: SizedBox(
                          width: 280,
                          child: LiquidGlassContainer(
                            config: LiquidGlassConfig(
                              cornerRadius: 20,
                              effect: CNGlassEffect.regular,
                              shape: CNGlassEffectShape.rect,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.5),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8.5),
                                          child: CachedNetworkImage(
                                            imageUrl: review['url'],
                                            width: 36,
                                            height: 36,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(color: Colors.white12),
                                            errorWidget: (context, url, error) => const Icon(Icons.person, size: 20),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              review['name'],
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.2,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Row(
                                              children: [
                                                Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                                                Text(
                                                  ' 5.0 Rating',
                                                  style: TextStyle(
                                                    color: Colors.white60,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    review['review'],
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 13,
                                      height: 1.4,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Spacer(),
              // Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: CNButton(
                        label: '    Invite Friends',
                        icon: CNSymbol('person.badge.plus', size: 16),
                        config: CNButtonConfig(style: CNButtonStyle.glass, imagePlacement: CNImagePlacement.leading),
                        onPressed: () {
                          SharePlus.instance.share(
                            ShareParams(text: ShareStrings.inviteMessage, subject: ShareStrings.inviteTitle),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 60,
                      child: CNButton(
                        label: 'Let’s Go',
                        config: CNButtonConfig(style: CNButtonStyle.prominentGlass),
                        onPressed: () => context.go('/home'),
                      ),
                    ),
                  ],
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
