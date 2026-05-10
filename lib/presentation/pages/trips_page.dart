// lib/presentation/pages/trips_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/trip.dart';
import '../../injection_container.dart' as di;
import '../cubits/app_cubit.dart';
import '../cubits/trip_history_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import '../widgets/tap_scale.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<TripHistoryCubit>()..load(),
      child: const _TripsView(),
    );
  }
}

class _TripsView extends StatefulWidget {
  const _TripsView();

  @override
  State<_TripsView> createState() => _TripsViewState();
}

class _TripsViewState extends State<_TripsView> {
  String? _expandedId;

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppCubit>().state;
    final tripState = context.watch<TripHistoryCubit>().state;
    final t = GlideTokens(dark: appState.darkMode);
    final appCubit = context.read<AppCubit>();
    final topPad = MediaQuery.of(context).padding.top;

    // Group trips by month
    final grouped = <String, List<Trip>>{};
    for (final trip in tripState.trips) {
      final key = DateFormat('MMMM yyyy').format(trip.date).toUpperCase();
      grouped.putIfAbsent(key, () => []).add(trip);
    }

    // Summary stats for current month
    final now = DateTime.now();
    final thisMonthKey = DateFormat('MMMM yyyy').format(now).toUpperCase();
    final thisMonthTrips = grouped[thisMonthKey] ?? [];
    final thisMonthSpend = thisMonthTrips
        .where((t) => t.status == TripStatus.completed)
        .fold(0.0, (sum, t) => sum + t.price);

    // 4-week data for chart (last 4 weeks)
    final weekSpend = List.generate(4, (i) {
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + (3 - i) * 7));
      final weekEnd = weekStart.add(const Duration(days: 6));
      return tripState.trips
          .where((trip) =>
              trip.status == TripStatus.completed &&
              !trip.date.isBefore(weekStart) &&
              !trip.date.isAfter(weekEnd))
          .fold(0.0, (sum, trip) => sum + trip.price);
    });

    final sections = grouped.entries.toList();

    return Container(
      color: t.bg,
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 0),
            child: Row(
              children: [
                GlideBackButton(onTap: () => appCubit.goTo(AppScreen.home), tokens: t),
                Expanded(
                  child: Center(
                    child: Text(
                      'Trips',
                      style: TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w700,
                        color: t.ink, letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Expanded(
            child: tripState.isLoading
                ? const SizedBox()
                : ListView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).padding.bottom + 110,
                    ),
                    children: [
                      // Summary card
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: t.accent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: t.accent.withValues(alpha: 0.3), width: 1),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          DateFormat('MMMM yyyy').format(now).toUpperCase(),
                                          style: TextStyle(
                                            fontSize: 11, fontWeight: FontWeight.w700,
                                            color: t.muted, letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '\$${thisMonthSpend.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 28, fontWeight: FontWeight.w800,
                                            color: t.ink, letterSpacing: -0.5,
                                          ),
                                        ),
                                        Text(
                                          '${thisMonthTrips.length} trips this month',
                                          style: TextStyle(fontSize: 13, color: t.muted),
                                        ),
                                      ],
                                    ),
                                  ),
                                  _SpendChart(weekSpend: weekSpend, tokens: t),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Grouped trip lists
                      for (final section in sections) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(22, 16, 22, 8),
                          child: Text(
                            section.key,
                            style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700,
                              color: t.muted, letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        for (final trip in section.value)
                          _TripRow(
                            trip: trip,
                            tokens: t,
                            expanded: _expandedId == trip.id,
                            onTap: () => setState(() =>
                                _expandedId = _expandedId == trip.id ? null : trip.id),
                            onBookAgain: () => appCubit.goTo(AppScreen.whereTo),
                          ),
                      ],
                    ],
                  ),
          ),

          GlideTabBar(
            active: 'history',
            tokens: t,
            onHome: () => appCubit.goTo(AppScreen.home),
            onSettings: () => appCubit.goTo(AppScreen.account),
            onTrips: () {},
            onChat: () => appCubit.goTo(AppScreen.chatInbox),
            isRideActive: appState.isRideActive,
          ),
        ],
      ),
    );
  }
}

class _TripRow extends StatelessWidget {
  final Trip trip;
  final GlideTokens tokens;
  final bool expanded;
  final VoidCallback onTap;
  final VoidCallback onBookAgain;

  const _TripRow({
    required this.trip,
    required this.tokens,
    required this.expanded,
    required this.onTap,
    required this.onBookAgain,
  });

  IconData get _rideIcon => switch (trip.rideType) {
        RideType.xl => LucideIcons.bus,
        RideType.lux => LucideIcons.star,
        RideType.eco => LucideIcons.leaf,
        _ => LucideIcons.carFront,
      };

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    final isCancelled = trip.status == TripStatus.cancelled;
    final dateStr = DateFormat('MMM d · h:mm a').format(trip.date);

    return TapScale(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 6),
        child: Container(
          decoration: BoxDecoration(
            color: t.card,
            borderRadius: BorderRadius.circular(20),
            boxShadow: t.shadowSm,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Avatar + ride type badge
                    Stack(
                      children: [
                        GlideAvatar(size: 46, hue: trip.driverAvatarHue, cardColor: t.card),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: t.card,
                              shape: BoxShape.circle,
                              border: Border.all(color: t.hair, width: 1),
                            ),
                            child: Icon(_rideIcon, size: 10, color: t.ink),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trip.destination,
                            style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700,
                              color: t.ink, letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$dateStr · ${trip.durationMinutes} min',
                            style: TextStyle(fontSize: 12, color: t.muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (isCancelled)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: t.cancelBg,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              'Cancelled',
                              style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w700, color: t.cancelInk,
                              ),
                            ),
                          )
                        else ...[
                          Text(
                            '\$${trip.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w700,
                              color: t.ink, letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          _StarDots(rating: trip.rating ?? 0, tokens: t),
                        ],
                        const SizedBox(height: 4),
                        Icon(
                          expanded ? LucideIcons.chevronUp : LucideIcons.chevronRight,
                          color: t.muted, size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Expandable detail
              AnimatedSize(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: expanded
                    ? Container(
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: t.hair)),
                        ),
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        child: Column(
                          children: [
                            // Mini route
                            Row(
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 10, height: 10,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: t.accent, width: 2.5),
                                      ),
                                    ),
                                    Container(width: 2, height: 24, color: t.hair2),
                                    Container(
                                      width: 10, height: 10,
                                      decoration: BoxDecoration(
                                        color: t.ink,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.originAddress,
                                        style: TextStyle(fontSize: 13, color: t.ink, fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(height: 14),
                                      Text(
                                        trip.destination,
                                        style: TextStyle(fontSize: 13, color: t.ink, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            GestureDetector(
                              onTap: onBookAgain,
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: t.accent,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: t.accent.withValues(alpha: 0.35),
                                      blurRadius: 12, offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  'Book again',
                                  style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w800,
                                    color: t.accentInk, letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StarDots extends StatelessWidget {
  final double rating;
  final GlideTokens tokens;

  const _StarDots({required this.rating, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) => Padding(
        padding: const EdgeInsets.only(left: 2),
        child: Container(
          width: 6, height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < rating.round() ? tokens.accent : tokens.hair2,
          ),
        ),
      )),
    );
  }
}

class _SpendChart extends StatelessWidget {
  final List<double> weekSpend;
  final GlideTokens tokens;

  const _SpendChart({required this.weekSpend, required this.tokens});

  @override
  Widget build(BuildContext context) {
    final maxVal = weekSpend.reduce((a, b) => a > b ? a : b).clamp(1.0, double.infinity);
    return SizedBox(
      width: 80, height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(weekSpend.length, (i) {
          final h = (weekSpend[i] / maxVal) * 40;
          final isCurrent = i == weekSpend.length - 1;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: i > 0 ? 4 : 0),
              child: Container(
                height: h.clamp(4, 40),
                decoration: BoxDecoration(
                  color: isCurrent ? tokens.accent : tokens.hair2,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
