import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _WhereToView extends StatelessWidget {
  const _WhereToView();

  static IconData _iconFor(LocationType type) {
    return switch (type) {
      LocationType.home => LucideIcons.house,
      LocationType.work => LucideIcons.briefcase,
      LocationType.landmark => LucideIcons.mapPin,
      LocationType.transit => LucideIcons.navigation2,
      LocationType.airport => LucideIcons.plane,
    };
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppCubit>().state;
    final whereToState = context.watch<WhereToCubit>().state;
    final t = GlideTokens(dark: appState.darkMode);
    final appCubit = context.read<AppCubit>();
    final topPad = MediaQuery.of(context).padding.top;
    final screenH = MediaQuery.of(context).size.height;
    final keyboardH = screenH * 0.35;

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
                      _InputRow(
                        leading: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: t.accent, width: 2.5),
                          ),
                        ),
                        text: '128 Mt Prospect Ave',
                        hint: 'Current',
                        tokens: t,
                        showCursor: false,
                      ),
                      Container(height: 1, color: t.hair),
                      _InputRow(
                        leading: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: t.ink,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        text: '47 Spring',
                        hint: 'Drop off',
                        tokens: t,
                        showCursor: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: whereToState.isLoading
                ? const SizedBox()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    itemCount: whereToState.suggestions.length,
                    itemBuilder: (_, i) {
                      final loc = whereToState.suggestions[i];
                      return GestureDetector(
                        onTap: () => appCubit.goTo(AppScreen.choose),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: i == 0 ? t.accent : t.card,
                                  borderRadius: BorderRadius.circular(12),
                                  border: i == 0 ? null : Border.all(color: t.hair, width: 1),
                                ),
                                child: Icon(_iconFor(loc.type), color: t.ink, size: 18),
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
                                      style: TextStyle(fontSize: 13, color: t.muted),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Text('›', style: TextStyle(fontSize: 18, color: t.muted)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            height: keyboardH,
            color: t.keyTray,
            child: _FakeKeyboard(tokens: t, onGo: () => appCubit.goTo(AppScreen.choose)),
          ),
        ],
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  final Widget leading;
  final String text;
  final String hint;
  final GlideTokens tokens;
  final bool showCursor;

  const _InputRow({
    required this.leading,
    required this.text,
    required this.hint,
    required this.tokens,
    required this.showCursor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 14),
          Expanded(
            child: Row(
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 15,
                    color: tokens.ink,
                    fontWeight: showCursor ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (showCursor) ...[
                  const SizedBox(width: 2),
                  BlinkingCursor(color: tokens.accent),
                ],
              ],
            ),
          ),
          Text(hint, style: TextStyle(fontSize: 12, color: tokens.muted)),
        ],
      ),
    );
  }
}

class _FakeKeyboard extends StatelessWidget {
  final GlideTokens tokens;
  final VoidCallback onGo;

  const _FakeKeyboard({required this.tokens, required this.onGo});

  @override
  Widget build(BuildContext context) {
    const rows = ['QWERTYUIOP', 'ASDFGHJKL', 'ZXCVBNM'];
    final suggestions = ['Spring', 'Springfield', 'Sprinter'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < suggestions.length; i++) ...[
                if (i > 0) Text(' · ', style: TextStyle(color: tokens.muted, fontSize: 14)),
                Text(suggestions[i], style: TextStyle(color: tokens.ink, fontSize: 14)),
              ],
            ],
          ),
        ),
        for (int ri = 0; ri < rows.length; ri++)
          Padding(
            padding: EdgeInsets.fromLTRB(
              ri == 1 ? 18 : ri == 2 ? 12 : 4,
              3,
              ri == 1 ? 18 : ri == 2 ? 12 : 4,
              3,
            ),
            child: Row(
              children: rows[ri]
                  .split('')
                  .map(
                    (k) => Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        height: 38,
                        decoration: BoxDecoration(
                          color: tokens.keyBg,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(color: Color(0x2E000000), blurRadius: 0, offset: Offset(0, 1)),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(k, style: TextStyle(fontSize: 16, color: tokens.ink)),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 3, 4, 6),
          child: Row(
            children: [
              Flexible(
                flex: 20,
                child: Container(
                  height: 38,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  decoration: BoxDecoration(
                    color: tokens.hair2,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              Flexible(
                flex: 60,
                child: Container(
                  height: 38,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  decoration: BoxDecoration(
                    color: tokens.keyBg,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: const [
                      BoxShadow(color: Color(0x2E000000), blurRadius: 0, offset: Offset(0, 1)),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text('space', style: TextStyle(fontSize: 14, color: tokens.ink)),
                ),
              ),
              Flexible(
                flex: 20,
                child: GestureDetector(
                  onTap: onGo,
                  child: Container(
                    height: 38,
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    decoration: BoxDecoration(
                      color: tokens.accent,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'go',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: tokens.accentInk,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
