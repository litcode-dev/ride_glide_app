import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../domain/entities/ride_option.dart';
import '../../injection_container.dart' as di;
import '../cubits/app_cubit.dart';
import '../cubits/choose_ride_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import '../widgets/map_background.dart';
import '../widgets/tap_scale.dart';

class ChoosePage extends StatelessWidget {
  const ChoosePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<ChooseRideCubit>()..load(),
      child: const _ChooseView(),
    );
  }
}

class _ChooseView extends StatefulWidget {
  const _ChooseView();

  @override
  State<_ChooseView> createState() => _ChooseViewState();
}

class _ChooseViewState extends State<_ChooseView> {
  bool _confirming = false;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppCubit>().state;
    final chooseState = context.watch<ChooseRideCubit>().state;
    final t = GlideTokens(dark: appState.darkMode);
    final appCubit = context.read<AppCubit>();
    final chooseCubit = context.read<ChooseRideCubit>();
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      color: t.bg,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.50,
            child: MapBackground(dark: t.dark, route: true),
          ),

          Positioned(
            top: topPad + 14,
            left: 16,
            right: 16,
            child: Row(
              children: [
                GlideBackButton(onTap: () => appCubit.goTo(AppScreen.whereTo), tokens: t),
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
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: t.ink,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ),
                        Text('9 min · 3.4 mi', style: TextStyle(fontSize: 12, color: t.muted)),
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
            top: MediaQuery.of(context).size.height * 0.46,
            child: Container(
              decoration: BoxDecoration(
                color: t.card,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: const [
                  BoxShadow(color: Color(0x1A14161C), blurRadius: 40, offset: Offset(0, -10)),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  SheetHandle(tokens: t),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Choose a ride',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: t.ink,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const Spacer(),
                        Text('Prices update live', style: TextStyle(fontSize: 12, color: t.muted)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: chooseState.isLoading
                        ? const SizedBox()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            itemCount: chooseState.options.length,
                            itemBuilder: (_, i) => _RideTile(
                              ride: chooseState.options[i],
                              selected: i == chooseState.selectedIndex,
                              tokens: t,
                              onTap: () => chooseCubit.selectRide(i),
                            ),
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      18,
                      10,
                      18,
                      MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: t.subtle,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              children: [
                                Icon(LucideIcons.creditCard, color: t.ink, size: 18),
                                const SizedBox(width: 10),
                                Text(
                                  'Visa · 4242',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: t.ink,
                                  ),
                                ),
                                const Spacer(),
                                Text('Change ›', style: TextStyle(fontSize: 12, color: t.muted)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TapScale(
                          onTap: _confirming
                              ? null
                              : () async {
                                  setState(() => _confirming = true);
                                  await Future.delayed(const Duration(milliseconds: 150));
                                  if (mounted) appCubit.goTo(AppScreen.searching);
                                },
                          child: AnimatedOpacity(
                            opacity: _confirming ? 0.6 : 1.0,
                            duration: const Duration(milliseconds: 100),
                            child: Container(
                              height: 50,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: t.accent,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: t.accent.withValues(alpha: 0.40),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                chooseState.options.isEmpty
                                    ? 'Confirm'
                                    : 'Confirm ${chooseState.options[chooseState.selectedIndex].name}',
                                style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600,
                                  color: t.accentInk, letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

class _RideTile extends StatelessWidget {
  final RideOption ride;
  final bool selected;
  final GlideTokens tokens;
  final VoidCallback onTap;

  const _RideTile({
    required this.ride,
    required this.selected,
    required this.tokens,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? t.accent.withValues(alpha: 0.20) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: selected ? Border.all(color: t.accentDeep, width: 1.5) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? t.accent : t.subtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(LucideIcons.carFront, color: selected ? kAccentInk : t.ink, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        ride.name,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: t.ink,
                          letterSpacing: -0.2,
                        ),
                      ),
                      if (ride.badge.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: t.accent,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            ride.badge,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: t.accentInk,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${ride.eta} away · ${ride.subtitle}',
                    style: TextStyle(fontSize: 12, color: t.muted),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '₦${ride.price.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: t.ink,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text('incl. taxes', style: TextStyle(fontSize: 11, color: t.muted)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
