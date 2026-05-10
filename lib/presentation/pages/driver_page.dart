import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart' as di;
import '../cubits/app_cubit.dart';
import '../cubits/driver_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import '../widgets/map_background.dart';

class DriverPage extends StatelessWidget {
  const DriverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<DriverCubit>()..load(),
      child: const _DriverView(),
    );
  }
}

class _DriverView extends StatelessWidget {
  const _DriverView();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppCubit>().state;
    final driverState = context.watch<DriverCubit>().state;
    final t = GlideTokens(dark: appState.darkMode);
    final appCubit = context.read<AppCubit>();
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final size = MediaQuery.of(context).size;
    final driver = driverState.driver;

    return Container(
      color: t.bg,
      child: Stack(
        children: [
          MapBackground(dark: t.dark, route: true),

          Positioned(
            left: size.width * 0.40,
            top: size.height * 0.24,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: t.accent,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    driver != null ? '${driver.etaMinutes} min' : '2 min',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: t.accentInk),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 38,
                  height: 38,
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
            top: topPad + 14,
            left: 16,
            right: 16,
            child: Row(
              children: [
                GlideBackButton(onTap: () => appCubit.goTo(AppScreen.home), tokens: t),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: t.card,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: t.shadowSm,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(color: t.ink, borderRadius: BorderRadius.circular(2)),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '47 Spring St',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: t.ink),
                          ),
                        ),
                        Text('ETA 9:54', style: TextStyle(fontSize: 12, color: t.muted)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: t.card,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: const [
                  BoxShadow(color: Color(0x1A14161C), blurRadius: 40, offset: Offset(0, -10)),
                ],
              ),
              padding: EdgeInsets.fromLTRB(22, 14, 22, bottomPad + 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SheetHandle(tokens: t),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: t.accent,
                          boxShadow: [
                            BoxShadow(color: t.accent.withValues(alpha: 0.33), blurRadius: 0, spreadRadius: 4),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'DRIVER ARRIVING',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: t.ink,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const Spacer(),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: '${driver?.etaMinutes ?? 2} ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: t.ink,
                              letterSpacing: -0.5,
                            ),
                          ),
                          TextSpan(
                            text: 'min',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: t.muted),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      height: 6,
                      color: t.hair,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: 0.72,
                          child: Container(color: t.accent),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      GlideAvatar(size: 56, hue: driver?.avatarHue ?? 42, cardColor: t.card),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              driver?.name ?? 'Joe Smith',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: t.ink,
                                letterSpacing: -0.3,
                              ),
                            ),
                            StarRating(
                              label: driver != null
                                  ? '${driver.rating} · ${driver.tripCount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} trips'
                                  : '4.92 · 1,284 trips',
                            ),
                          ],
                        ),
                      ),
                      GlideIconPill(icon: Icons.chat_bubble_outline_rounded, tokens: t),
                      const SizedBox(width: 8),
                      GlideIconPill(
                        icon: Icons.phone_rounded,
                        tokens: t,
                        bgColor: t.accent,
                        iconColor: t.accentInk,
                        iconSize: 18,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: t.subtle,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: t.card,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.local_taxi_rounded, color: t.ink, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                driver?.vehicle.description ?? 'White Tesla Model 3',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: t.ink,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              Text(
                                'Pickup: ${driver?.vehicle.pickup ?? '128 Mt Prospect Ave'}',
                                style: TextStyle(fontSize: 11, color: t.muted),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: t.ink,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            driver?.vehicle.plate ?? 'NJ · 7M3 K42',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 1.4,
                              fontFamily: 'Courier',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      MiniButton(icon: Icons.verified_user_outlined, label: 'Safety', tokens: t),
                      const SizedBox(width: 8),
                      MiniButton(icon: Icons.ios_share_rounded, label: 'Share trip', tokens: t),
                      const SizedBox(width: 8),
                      MiniButton(
                        icon: Icons.close_rounded,
                        label: 'Cancel',
                        tokens: t,
                        onTap: () => appCubit.goTo(AppScreen.home),
                        isCancel: true,
                      ),
                    ],
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
