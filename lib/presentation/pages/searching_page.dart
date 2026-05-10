import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/app_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import '../widgets/map_background.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({super.key});

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> with TickerProviderStateMixin {
  late final List<AnimationController> _rings;
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    _rings = List.generate(3, (i) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2600),
      );
      Future.delayed(Duration(milliseconds: (i + 1) * 700), () {
        if (mounted) ctrl.repeat();
      });
      return ctrl;
    });

    _autoTimer = Timer(const Duration(milliseconds: 4500), () {
      if (mounted) context.read<AppCubit>().goTo(AppScreen.driver);
    });
  }

  @override
  void dispose() {
    for (final c in _rings) {
      c.dispose();
    }
    _autoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppCubit>().state;
    final t = GlideTokens(dark: state.darkMode);
    final topPad = MediaQuery.of(context).padding.top;
    final size = MediaQuery.of(context).size;

    return Container(
      color: t.bg,
      child: Stack(
        children: [
          MapBackground(dark: t.dark),

          Positioned(
            top: topPad + 14,
            left: 16,
            right: 16,
            child: Row(
              children: [
                GlideBackButton(onTap: () => context.read<AppCubit>().goTo(AppScreen.home), tokens: t),
                Expanded(
                  child: Center(
                    child: Text(
                      'Searching for driver',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: t.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          Positioned(
            top: topPad + 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: t.accent,
                    boxShadow: [
                      BoxShadow(color: t.accent.withValues(alpha: 0.20), blurRadius: 0, spreadRadius: 8),
                      BoxShadow(color: t.accent.withValues(alpha: 0.10), blurRadius: 0, spreadRadius: 16),
                    ],
                  ),
                  child: const Icon(LucideIcons.carFront, color: kAccentInk, size: 26),
                ),
                const SizedBox(height: 14),
                Text(
                  'Finding your ride',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: t.ink,
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Usually under 90 seconds · 3 drivers nearby',
                  style: TextStyle(fontSize: 13, color: t.muted),
                ),
              ],
            ),
          ),

          Positioned(
            top: size.height * 0.46 - 160,
            left: size.width / 2 - 160,
            child: SizedBox(
              width: 320,
              height: 320,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  for (int i = 0; i < 3; i++)
                    _PulseRing(
                      controller: _rings[i],
                      baseSize: [320.0, 220.0, 120.0][i],
                      color: t.accent,
                    ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: t.card,
                      shape: BoxShape.circle,
                      boxShadow: t.shadowMd,
                    ),
                    child: Icon(LucideIcons.carFront, color: t.ink, size: 30),
                  ),
                  Positioned(
                    left: 30,
                    top: 200,
                    child: GlideAvatar(size: 40, hue: 42, ring: true, cardColor: t.card),
                  ),
                  Positioned(
                    right: 20,
                    top: 110,
                    child: GlideAvatar(size: 36, hue: 200, ring: true, cardColor: t.card),
                  ),
                  Positioned(
                    right: 40,
                    bottom: 30,
                    child: GlideAvatar(size: 42, hue: 310, ring: true, cardColor: t.card),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            top: size.height * 0.34,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: t.card,
                borderRadius: BorderRadius.circular(20),
                boxShadow: t.shadowSm,
              ),
              child: Row(
                children: [
                  GlideAvatar(size: 42, hue: 42, cardColor: t.card),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Joe Smith',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: t.ink,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const StarRating(label: '4.92 · 200 m away'),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: t.accent.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Likely match',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: t.accentDeep,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).padding.bottom + 30,
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: t.card,
                borderRadius: BorderRadius.circular(999),
                boxShadow: t.shadowSm,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.read<AppCubit>().goTo(AppScreen.home),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: t.hair, shape: BoxShape.circle),
                      child: Icon(LucideIcons.x, color: t.ink, size: 18),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '›› Slide to cancel',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t.muted),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulseRing extends StatelessWidget {
  final AnimationController controller;
  final double baseSize;
  final Color color;

  const _PulseRing({
    required this.controller,
    required this.baseSize,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final t = controller.value;
        final scale = 0.6 + t * 1.0;
        final opacity = t < 0.2 ? (t / 0.2) * 0.75 : ((1.0 - t) / 0.8) * 0.75;
        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: baseSize,
              height: baseSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
            ),
          ),
        );
      },
    );
  }
}
