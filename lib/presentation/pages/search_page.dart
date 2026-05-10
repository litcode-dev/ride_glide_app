import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../domain/entities/location.dart';
import '../../injection_container.dart' as di;
import '../cubits/app_cubit.dart';
import '../cubits/where_to_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<WhereToCubit>()..load(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  final _controller = TextEditingController();
  String _query = '';

  static const _recents = [
    (name: 'Victoria Island', address: 'Victoria Island, Lagos'),
    (name: 'Lekki Phase 1', address: 'Lekki Phase 1, Lagos'),
    (name: 'Ikeja City Mall', address: 'Alausa, Ikeja, Lagos'),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppCubit>().state;
    final whereToState = context.watch<WhereToCubit>().state;
    final t = GlideTokens(dark: appState.darkMode);
    final appCubit = context.read<AppCubit>();
    final topPad = MediaQuery.of(context).padding.top;

    final suggestions = _query.isEmpty
        ? whereToState.suggestions
        : whereToState.suggestions.where((l) {
            final q = _query.toLowerCase();
            return l.name.toLowerCase().contains(q) || l.address.toLowerCase().contains(q);
          }).toList();

    return Container(
      color: t.bg,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, topPad + 14, 16, 12),
            child: Row(
              children: [
                GlideBackButton(onTap: () => appCubit.goTo(AppScreen.home), tokens: t),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: t.card,
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: t.shadowSm,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Icon(LucideIcons.search, color: t.muted, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            autofocus: true,
                            style: TextStyle(
                              fontSize: 15,
                              color: t.ink,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search destination',
                              hintStyle: TextStyle(color: t.muted, fontSize: 15),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (v) => setState(() => _query = v),
                          ),
                        ),
                        if (_query.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              _controller.clear();
                              setState(() => _query = '');
                            },
                            child: Icon(LucideIcons.x, color: t.muted, size: 16),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              children: [
                if (_query.isEmpty) ...[
                  _SectionHeader(label: 'RECENT', tokens: t),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: t.card,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: t.shadowSm,
                    ),
                    child: Column(
                      children: _recents.asMap().entries.map((e) {
                        return _ResultRow(
                          icon: LucideIcons.clock,
                          name: e.value.name,
                          address: e.value.address,
                          tokens: t,
                          showDivider: e.key > 0,
                          onTap: () => appCubit.goTo(AppScreen.choose),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionHeader(label: 'SAVED PLACES', tokens: t),
                  const SizedBox(height: 8),
                ],
                if (suggestions.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      color: t.card,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: t.shadowSm,
                    ),
                    child: Column(
                      children: suggestions.asMap().entries.map((e) {
                        final loc = e.value;
                        return _ResultRow(
                          icon: _iconFor(loc.type),
                          name: loc.name,
                          address: loc.address,
                          tokens: t,
                          showDivider: e.key > 0,
                          accent: loc.isFavorite,
                          onTap: () => appCubit.goTo(AppScreen.choose),
                        );
                      }).toList(),
                    ),
                  ),
                if (_query.isNotEmpty && suggestions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 48),
                    child: Center(
                      child: Text(
                        'No results for "$_query"',
                        style: TextStyle(color: t.muted, fontSize: 14),
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

  static IconData _iconFor(LocationType type) => switch (type) {
        LocationType.home => LucideIcons.house,
        LocationType.work => LucideIcons.briefcase,
        LocationType.landmark => LucideIcons.mapPin,
        LocationType.transit => LucideIcons.navigation2,
        LocationType.airport => LucideIcons.plane,
      };
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final GlideTokens tokens;

  const _SectionHeader({required this.label, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: tokens.muted,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final IconData icon;
  final String name;
  final String address;
  final GlideTokens tokens;
  final bool showDivider;
  final bool accent;
  final VoidCallback onTap;

  const _ResultRow({
    required this.icon,
    required this.name,
    required this.address,
    required this.tokens,
    required this.onTap,
    this.showDivider = false,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
        decoration: BoxDecoration(
          border: showDivider ? Border(top: BorderSide(color: t.hair)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accent ? t.accent : t.subtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accent ? kAccentInk : t.ink, size: 17),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: t.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  Text(
                    address,
                    style: TextStyle(fontSize: 12, color: t.muted),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, color: t.muted, size: 16),
          ],
        ),
      ),
    );
  }
}
