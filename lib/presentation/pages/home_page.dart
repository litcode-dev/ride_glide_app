import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/app_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import '../widgets/map_background.dart';
import '../widgets/tap_scale.dart';
import '../widgets/top_up_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppCubit>().state;
    final t = GlideTokens(dark: state.darkMode);
    final appCubit = context.read<AppCubit>();
    final size = MediaQuery.of(context).size;
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      color: t.bg,
      child: Stack(
        children: [
          MapBackground(dark: t.dark),

          Positioned(
            left: size.width * 0.46,
            top: size.height * 0.38,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: t.accent,
                border: Border.all(color: t.card, width: 3),
                boxShadow: [
                  BoxShadow(color: t.accent.withValues(alpha: 0.33), blurRadius: 0, spreadRadius: 7),
                  BoxShadow(color: t.accent.withValues(alpha: 0.13), blurRadius: 0, spreadRadius: 14),
                ],
              ),
            ),
          ),

          Positioned(
            top: topPad + 14,
            left: 16,
            right: 16,
            child: Row(
              children: [
                GlideAvatar(size: 44, hue: 22, cardColor: t.card),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: t.card,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: t.shadowSm,
                    ),
                    padding: const EdgeInsets.only(left: 14, right: 6),
                    child: Row(
                      children: [
                        Icon(Icons.credit_card_outlined, color: t.ink, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '\$29',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: t.ink,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('balance', style: TextStyle(fontSize: 13, color: t.muted)),
                        const Spacer(),
                        TapScale(
                          onTap: () => showTopUpSheet(context, t),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: t.accent,
                            ),
                            child: const Icon(Icons.add_rounded, color: kAccentInk, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: t.card,
                    shape: BoxShape.circle,
                    boxShadow: t.shadowSm,
                  ),
                  child: Icon(Icons.search_rounded, color: t.ink, size: 20),
                ),
              ],
            ),
          ),

          Positioned(
            left: size.width * 0.52,
            top: size.height * 0.30,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: t.accent,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [BoxShadow(color: t.accent.withValues(alpha: 0.40), blurRadius: 12)],
                  ),
                  child: Text(
                    '3 min',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: t.accentInk),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: t.card,
                    shape: BoxShape.circle,
                    boxShadow: t.shadowSm,
                  ),
                  child: Icon(Icons.local_taxi_rounded, color: t.ink, size: 20),
                ),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 130,
            child: Container(
              decoration: BoxDecoration(
                color: t.card,
                borderRadius: BorderRadius.circular(28),
                boxShadow: t.shadowMd,
              ),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: t.hair2,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: t.accent, width: 2.5),
                            ),
                          ),
                          Container(width: 2, height: 26, color: t.hair2),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: t.ink,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PICK UP',
                              style: TextStyle(
                                fontSize: 11,
                                color: t.muted,
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Where are you?',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: t.ink,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Container(
                              height: 1,
                              color: t.hair,
                              margin: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            Text(
                              'DROP OFF',
                              style: TextStyle(
                                fontSize: 11,
                                color: t.muted,
                                letterSpacing: 0.4,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => appCubit.goTo(AppScreen.whereTo),
                              child: Text(
                                'Where you want to go?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: t.ink,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlideTabBar(
              active: 'home',
              tokens: t,
              onHome: () {},
              onSettings: () => appCubit.goTo(AppScreen.account),
              onTrips: () => appCubit.goTo(AppScreen.trips),
              onChat: () => appCubit.goTo(AppScreen.chatInbox),
              isRideActive: state.isRideActive,
            ),
          ),
        ],
      ),
    );
  }
}
