import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../injection_container.dart' as di;
import '../cubits/account_cubit.dart';
import '../cubits/app_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AccountCubit>()..load(),
      child: const _AccountView(),
    );
  }
}

class _AccountView extends StatelessWidget {
  const _AccountView();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppCubit>().state;
    final accountState = context.watch<AccountCubit>().state;
    final t = GlideTokens(dark: appState.darkMode);
    final appCubit = context.read<AppCubit>();
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final profile = accountState.profile;

    final rows = [
      (icon: Icons.my_location_rounded, label: 'Location'),
      (icon: Icons.credit_card_outlined, label: 'Payment'),
      (icon: Icons.info_outline, label: 'Information'),
      (icon: Icons.shield_outlined, label: 'Security'),
    ];

    return Container(
      color: t.bg,
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: bottomPad + 110),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 0),
                  child: Row(
                    children: [
                      GlideBackButton(onTap: () => appCubit.goTo(AppScreen.home), tokens: t),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Account',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: t.card,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: t.shadowSm,
                    ),
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GlideAvatar(size: 62, hue: profile?.avatarHue ?? 22, cardColor: t.card),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    profile?.name ?? 'Alex Hales',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: t.ink,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    profile?.phone ?? '+46 16 755 7287',
                                    style: TextStyle(fontSize: 13, color: t.muted),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: t.accent.withValues(alpha: 0.27),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: kAccentDeep, size: 12),
                                  const SizedBox(width: 4),
                                  Text(
                                    profile != null ? profile.rating.toStringAsFixed(2) : '4.95',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: t.accentDeep,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: t.subtle,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'WALLET',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: t.muted,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  Text(
                                    profile != null
                                        ? '\$${profile.walletBalance.toStringAsFixed(2)}'
                                        : '\$29.00',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: t.ink,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: 1,
                                height: 30,
                                color: t.hair,
                                margin: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TRIPS',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: t.muted,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.4,
                                    ),
                                  ),
                                  Text(
                                    profile?.tripCount.toString() ?? '148',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: t.ink,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 36,
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: t.accent,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Top up',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: t.accentInk,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'PERSONAL INFORMATION',
                          style: TextStyle(
                            fontSize: 12,
                            color: t.muted,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...rows.asMap().entries.map((e) => _SettingsRow(
                              icon: e.value.icon,
                              label: e.value.label,
                              tokens: t,
                              showDivider: e.key > 0,
                            )),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(border: Border(top: BorderSide(color: t.hair))),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: t.subtle,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.local_offer_outlined, color: t.ink, size: 18),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  'Discount notifications',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: t.ink,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              _AccentToggle(value: true, tokens: t),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(border: Border(top: BorderSide(color: t.hair))),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: t.subtle,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  appState.darkMode
                                      ? Icons.light_mode_rounded
                                      : Icons.dark_mode_rounded,
                                  color: t.ink,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  'Dark mode',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: t.ink,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              _AccentToggle(
                                value: appState.darkMode,
                                tokens: t,
                                onChanged: (v) => appCubit.toggleDarkMode(v),
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
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlideTabBar(
              active: 'settings',
              tokens: t,
              onHome: () => appCubit.goTo(AppScreen.home),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final GlideTokens tokens;
  final bool showDivider;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.tokens,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: showDivider ? Border(top: BorderSide(color: t.hair)) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: t.subtle, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: t.ink, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: t.ink,
                letterSpacing: -0.2,
              ),
            ),
          ),
          Text('›', style: TextStyle(fontSize: 18, color: t.muted)),
        ],
      ),
    );
  }
}

class _AccentToggle extends StatelessWidget {
  final bool value;
  final GlideTokens tokens;
  final ValueChanged<bool>? onChanged;

  const _AccentToggle({required this.value, required this.tokens, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 46,
        height: 28,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? tokens.accent : tokens.hair2,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Align(
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: value ? tokens.card : tokens.muted.withValues(alpha: 0.4),
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Color(0x33000000), blurRadius: 3, offset: Offset(0, 1)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
