import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../domain/entities/location.dart';
import '../../injection_container.dart' as di;
import '../cubits/app_cubit.dart';
import '../cubits/where_to_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';

class WhereToPage extends StatelessWidget {
  const WhereToPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<WhereToCubit>()..load(),
      child: const _WhereToView(),
    );
  }
}

class _WhereToView extends StatefulWidget {
  const _WhereToView();

  @override
  State<_WhereToView> createState() => _WhereToViewState();
}

class _WhereToViewState extends State<_WhereToView> {
  final _pickupCtrl = TextEditingController();
  final _dropCtrl   = TextEditingController();
  final _pickupFocus = FocusNode();
  final _dropFocus   = FocusNode();
  bool _locating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppCubit>().state;
      if (appState.pickupAddress != null) {
        _pickupCtrl.text = appState.pickupAddress!;
      }
      if (appState.focusPickup) {
        _pickupFocus.requestFocus();
      } else {
        _dropFocus.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _pickupCtrl.dispose();
    _dropCtrl.dispose();
    _pickupFocus.dispose();
    _dropFocus.dispose();
    super.dispose();
  }

  Future<void> _detectLocation() async {
    setState(() => _locating = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      // Ignore if outside Nigeria's bounding box (avoids iOS Simulator SF default)
      final inNigeria = pos.latitude >= 4 && pos.latitude <= 14 &&
          pos.longitude >= 3 && pos.longitude <= 15;
      if (!inNigeria) return;

      if (mounted) {
        _pickupCtrl.text = 'Current Location';
        context.read<AppCubit>().setPickupLocation(
          lat: pos.latitude,
          lng: pos.longitude,
        );
        _dropFocus.requestFocus();
      }
    } catch (_) {
      // silently fall back
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  static IconData _iconFor(LocationType type) => switch (type) {
        LocationType.home    => LucideIcons.house,
        LocationType.work    => LucideIcons.briefcase,
        LocationType.landmark => LucideIcons.mapPin,
        LocationType.transit => LucideIcons.navigation2,
        LocationType.airport => LucideIcons.plane,
      };

  @override
  Widget build(BuildContext context) {
    final appState    = context.watch<AppCubit>().state;
    final whereToState = context.watch<WhereToCubit>().state;
    final t           = GlideTokens(dark: appState.darkMode);
    final appCubit    = context.read<AppCubit>();
    final topPad      = MediaQuery.of(context).padding.top;

    final pickupFocused = _pickupFocus.hasFocus;
    final query = pickupFocused
        ? _pickupCtrl.text.toLowerCase()
        : _dropCtrl.text.toLowerCase();

    final suggestions = query.isEmpty
        ? whereToState.suggestions
        : whereToState.suggestions.where((l) {
            return l.name.toLowerCase().contains(query) ||
                l.address.toLowerCase().contains(query);
          }).toList();

    return Container(
      color: t.bg,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GlideBackButton(onTap: () => appCubit.goTo(AppScreen.home), tokens: t),
                    const SizedBox(width: 12),
                    Text(
                      'Plan your ride',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: t.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: t.card,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: t.shadowSm,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: [
                      // ── Pickup row ──────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: t.accent, width: 2.5),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: TextField(
                                controller: _pickupCtrl,
                                focusNode: _pickupFocus,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: t.ink,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Where are you?',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: t.muted,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (_) => setState(() {}),
                                onTap: () => appCubit.goToWhereTo(focusPickup: true),
                              ),
                            ),
                            const SizedBox(width: 8),
                            _locating
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: t.accent,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: _detectLocation,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: t.accent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        LucideIcons.locateFixed,
                                        color: kAccentInk,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      Container(height: 1, color: t.hair),
                      // ── Drop-off row ────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: t.ink,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: TextField(
                                controller: _dropCtrl,
                                focusNode: _dropFocus,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: t.ink,
                                  fontWeight: FontWeight.w600,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Where to?',
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: t.muted,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (_) => setState(() {}),
                                onTap: () => appCubit.goToWhereTo(focusPickup: false),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Suggestions ────────────────────────────────────────────────
          Expanded(
            child: whereToState.isLoading
                ? const SizedBox()
                : suggestions.isEmpty
                    ? Center(
                        child: Text(
                          'No results',
                          style: TextStyle(color: t.muted, fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 32),
                        itemCount: suggestions.length,
                        itemBuilder: (_, i) {
                          final loc = suggestions[i];
                          return GestureDetector(
                            onTap: () {
                              if (pickupFocused) {
                                _pickupCtrl.text = loc.address;
                                appCubit.setPickup(loc.address);
                                _dropFocus.requestFocus();
                              } else {
                                appCubit.goTo(AppScreen.choose);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 13),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: i == 0 ? t.accent : t.card,
                                      borderRadius: BorderRadius.circular(12),
                                      border: i == 0
                                          ? null
                                          : Border.all(color: t.hair, width: 1),
                                    ),
                                    child: Icon(_iconFor(loc.type),
                                        color: i == 0 ? kAccentInk : t.ink, size: 18),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              loc.name,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: t.ink,
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                            if (loc.isFavorite) ...[
                                              const SizedBox(width: 6),
                                              Text(
                                                '★ Favorite',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: t.accentDeep,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        Text(
                                          loc.address,
                                          style: TextStyle(
                                              fontSize: 13, color: t.muted),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text('›',
                                      style: TextStyle(
                                          fontSize: 18, color: t.muted)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
