import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/glide_tokens.dart';

// ── Avatar ─────────────────────────────────────────────────────────────────
class GlideAvatar extends StatelessWidget {
  final double size;
  final int hue;
  final bool ring;
  final Color cardColor;

  const GlideAvatar({
    super.key,
    this.size = 36,
    this.hue = 22,
    this.ring = false,
    this.cardColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final topColor = HSVColor.fromAHSV(1.0, hue.toDouble(), 0.45, 0.80).toColor();
    final botColor = HSVColor.fromAHSV(1.0, (hue + 10).toDouble(), 0.60, 0.65).toColor();
    final skinColor = HSVColor.fromAHSV(1.0, hue.toDouble(), 0.08, 0.94).toColor();

    final List<BoxShadow> shadows = ring
        ? [
            BoxShadow(color: cardColor, blurRadius: 0, spreadRadius: 3),
            const BoxShadow(color: kAccent, blurRadius: 0, spreadRadius: 4.5),
          ]
        : [
            const BoxShadow(
              color: Color(0x14000000),
              blurRadius: 14,
              offset: Offset(0, -6),
            ),
          ];

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [topColor, botColor],
        ),
        boxShadow: shadows,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          Positioned(
            left: size * 0.5 - size * 0.21,
            top: size * 0.28 - size * 0.21,
            child: Container(
              width: size * 0.42,
              height: size * 0.42,
              decoration: BoxDecoration(shape: BoxShape.circle, color: skinColor),
            ),
          ),
          Positioned(
            left: size * 0.5 - size * 0.425,
            top: size * 0.70 - size * 0.425,
            child: Container(
              width: size * 0.85,
              height: size * 0.85,
              decoration: BoxDecoration(shape: BoxShape.circle, color: skinColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ── FAB ────────────────────────────────────────────────────────────────────
class GlideFAB extends StatefulWidget {
  final bool isRideActive;
  final double size;

  const GlideFAB({super.key, this.size = 56, this.isRideActive = false});

  @override
  State<GlideFAB> createState() => _GlideFABState();
}

class _GlideFABState extends State<GlideFAB> with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    if (widget.isRideActive) _pulse.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(GlideFAB old) {
    super.didUpdateWidget(old);
    if (widget.isRideActive && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.isRideActive && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        final scale = widget.isRideActive ? 1.0 + _pulse.value * 0.08 : 1.0;
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: kAccent,
          boxShadow: [
            BoxShadow(color: kAccent.withValues(alpha: 0.20), blurRadius: 0, spreadRadius: 6),
            BoxShadow(color: kAccent.withValues(alpha: 0.40), blurRadius: 18),
            const BoxShadow(color: Color(0x1F000000), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: const Icon(LucideIcons.carFront, color: kAccentInk, size: 26),
      ),
    );
  }
}

// ── Bottom Tab Bar ─────────────────────────────────────────────────────────
class GlideTabBar extends StatelessWidget {
  final String active;
  final GlideTokens tokens;
  final VoidCallback? onHome;
  final VoidCallback? onSettings;
  final VoidCallback? onTrips;
  final VoidCallback? onChat;
  final bool isRideActive;

  const GlideTabBar({
    super.key,
    this.active = 'home',
    required this.tokens,
    this.onHome,
    this.onSettings,
    this.onTrips,
    this.onChat,
    this.isRideActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: const [0.0, 0.55, 1.0],
          colors: [tokens.bg, tokens.bg, tokens.bg.withValues(alpha: 0)],
        ),
      ),
      padding: EdgeInsets.only(
        bottom: bottomPad > 0 ? bottomPad : 22,
        left: 16,
        right: 16,
        top: 18,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 76,
            decoration: BoxDecoration(
              color: tokens.card,
              borderRadius: BorderRadius.circular(28),
              boxShadow: tokens.shadowMd,
            ),
            child: Row(
              children: [
                _TabItem(
                  icon: LucideIcons.house,
                  label: 'Home',
                  active: active == 'home',
                  tokens: tokens,
                  onTap: onHome,
                ),
                _TabItem(
                  icon: LucideIcons.history,
                  label: 'Trips',
                  active: active == 'history',
                  tokens: tokens,
                  onTap: onTrips,
                ),
                Expanded(flex: 6, child: const SizedBox()),
                _TabItem(
                  icon: LucideIcons.messageCircle,
                  label: 'Chat',
                  active: active == 'chat',
                  tokens: tokens,
                  onTap: onChat,
                ),
                _TabItem(
                  icon: LucideIcons.user,
                  label: 'Account',
                  active: active == 'settings',
                  tokens: tokens,
                  onTap: onSettings,
                ),
              ],
            ),
          ),
          Positioned(top: -28, child: GlideFAB(isRideActive: isRideActive)),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final GlideTokens tokens;
  final VoidCallback? onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.tokens,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? tokens.ink : tokens.muted;
    return Expanded(
      flex: 5,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Back button ────────────────────────────────────────────────────────────
class GlideBackButton extends StatelessWidget {
  final VoidCallback onTap;
  final GlideTokens tokens;

  const GlideBackButton({super.key, required this.onTap, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: tokens.card,
          shape: BoxShape.circle,
          boxShadow: tokens.shadowSm,
        ),
        child: Icon(LucideIcons.chevronLeft, color: tokens.ink, size: 20),
      ),
    );
  }
}

// ── Icon pill button ───────────────────────────────────────────────────────
class GlideIconPill extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final GlideTokens tokens;
  final VoidCallback? onTap;
  final Color? bgColor;
  final Color? iconColor;
  final double size;

  const GlideIconPill({
    super.key,
    required this.icon,
    this.iconSize = 18,
    required this.tokens,
    this.onTap,
    this.bgColor,
    this.iconColor,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor ?? tokens.card,
          shape: BoxShape.circle,
          boxShadow: bgColor == null ? tokens.shadowSm : null,
          border: bgColor == null ? Border.all(color: tokens.hair, width: 1) : null,
        ),
        child: Icon(icon, color: iconColor ?? tokens.ink, size: iconSize),
      ),
    );
  }
}

// ── Mini action button (Safety / Share / Cancel) ───────────────────────────
class MiniButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final GlideTokens tokens;
  final VoidCallback? onTap;
  final bool isCancel;

  const MiniButton({
    super.key,
    required this.icon,
    required this.label,
    required this.tokens,
    this.onTap,
    this.isCancel = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isCancel ? tokens.cancelBg : tokens.card,
            borderRadius: BorderRadius.circular(14),
            border: isCancel ? null : Border.all(color: tokens.hair, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isCancel ? tokens.cancelInk : tokens.ink, size: 16),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isCancel ? tokens.cancelInk : tokens.ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Star rating ────────────────────────────────────────────────────────────
class StarRating extends StatelessWidget {
  final String label;
  final double fontSize;

  const StarRating({super.key, required this.label, this.fontSize = 12});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(LucideIcons.star, color: kAccentDeep, size: 13),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(color: const Color(0xFF8A8E94), fontSize: fontSize),
        ),
      ],
    );
  }
}

// ── Handle bar (drag indicator) ────────────────────────────────────────────
class SheetHandle extends StatelessWidget {
  final GlideTokens tokens;
  const SheetHandle({super.key, required this.tokens});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 42,
        height: 4,
        decoration: BoxDecoration(
          color: tokens.hair2,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

// ── Blinking cursor ────────────────────────────────────────────────────────
class BlinkingCursor extends StatefulWidget {
  final Color color;
  const BlinkingCursor({super.key, required this.color});

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, _) => Opacity(
        opacity: _ctrl.value < 0.5 ? 1.0 : 0.0,
        child: Container(width: 1.5, height: 18, color: widget.color),
      ),
    );
  }
}
