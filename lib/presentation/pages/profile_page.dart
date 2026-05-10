import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../injection_container.dart' as di;
import '../cubits/account_cubit.dart';
import '../cubits/app_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import '../widgets/tap_scale.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AccountCubit>()..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppCubit>().state;
    final accountState = context.watch<AccountCubit>().state;
    final t = GlideTokens(dark: appState.darkMode);
    final appCubit = context.read<AppCubit>();
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final profile = accountState.profile;

    return Container(
      color: t.bg,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: bottomPad + 32),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 0),
              child: Row(
                children: [
                  GlideBackButton(onTap: () => appCubit.goTo(AppScreen.home), tokens: t),
                  const Spacer(),
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: t.ink,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  TapScale(
                    onTap: () => HapticFeedback.selectionClick(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: t.card,
                        shape: BoxShape.circle,
                        boxShadow: t.shadowSm,
                      ),
                      child: Icon(LucideIcons.penLine, color: t.ink, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            Stack(
              alignment: Alignment.bottomRight,
              children: [
                GlideAvatar(size: 96, hue: profile?.avatarHue ?? 22, ring: true, cardColor: t.bg),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: t.accent,
                    shape: BoxShape.circle,
                    border: Border.all(color: t.bg, width: 2.5),
                  ),
                  child: const Icon(LucideIcons.camera, color: kAccentInk, size: 14),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              profile?.name ?? 'Alex Hales',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: t.ink,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              profile?.phone ?? '+234 816 755 7287',
              style: TextStyle(fontSize: 14, color: t.muted),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: t.accent.withValues(alpha: 0.22),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.star, color: kAccentDeep, size: 13),
                  const SizedBox(width: 5),
                  Text(
                    profile != null ? profile.rating.toStringAsFixed(2) : '4.95',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kAccentDeep,
                    ),
                  ),
                  Text(' rating', style: TextStyle(fontSize: 13, color: t.accentDeep)),
                ],
              ),
            ),
            const SizedBox(height: 28),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: t.card,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: t.shadowSm,
                ),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    _StatCell(label: 'TRIPS', value: profile?.tripCount.toString() ?? '148', tokens: t),
                    _StatDivider(tokens: t),
                    _StatCell(
                      label: 'RATING',
                      value: profile != null ? profile.rating.toStringAsFixed(1) : '4.9',
                      tokens: t,
                    ),
                    _StatDivider(tokens: t),
                    _StatCell(label: 'SINCE', value: '2022', tokens: t),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: t.card,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: t.shadowSm,
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: LucideIcons.mail,
                      label: 'Email',
                      value: 'alex.hales@gmail.com',
                      tokens: t,
                      showDivider: false,
                    ),
                    _InfoRow(
                      icon: LucideIcons.phone,
                      label: 'Phone',
                      value: profile?.phone ?? '+234 816 755 7287',
                      tokens: t,
                    ),
                    _InfoRow(
                      icon: LucideIcons.mapPin,
                      label: 'City',
                      value: 'Lagos, Nigeria',
                      tokens: t,
                    ),
                    _InfoRow(
                      icon: LucideIcons.calendarDays,
                      label: 'Joined',
                      value: 'March 2022',
                      tokens: t,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TapScale(
                onTap: () => HapticFeedback.mediumImpact(),
                child: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    color: t.cancelBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(LucideIcons.logOut, color: t.cancelInk, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Sign out',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: t.cancelInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final GlideTokens tokens;

  const _StatCell({required this.label, required this.value, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: tokens.ink,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: tokens.muted,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  final GlideTokens tokens;
  const _StatDivider({required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: tokens.hair);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final GlideTokens tokens;
  final bool showDivider;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.tokens,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    return GestureDetector(
      onTap: () => HapticFeedback.selectionClick(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: t.muted,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: t.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            Icon(LucideIcons.chevronRight, color: t.muted, size: 18),
          ],
        ),
      ),
    );
  }
}
