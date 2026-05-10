// lib/presentation/widgets/glide_toast.dart
import 'package:flutter/material.dart';
import '../theme/glide_tokens.dart';

void showGlideToast(BuildContext context, String message, GlideTokens tokens) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (context) => _GlideToastOverlay(
      message: message,
      tokens: tokens,
      onDone: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
}

class _GlideToastOverlay extends StatefulWidget {
  final String message;
  final GlideTokens tokens;
  final VoidCallback onDone;

  const _GlideToastOverlay({
    required this.message,
    required this.tokens,
    required this.onDone,
  });

  @override
  State<_GlideToastOverlay> createState() => _GlideToastOverlayState();
}

class _GlideToastOverlayState extends State<_GlideToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) _ctrl.reverse().then((_) => widget.onDone());
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Positioned(
      left: 24,
      right: 24,
      bottom: bottomPad + 110,
      child: SlideTransition(
        position: _slide,
        child: FadeTransition(
          opacity: _opacity,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: widget.tokens.ink,
                borderRadius: BorderRadius.circular(16),
                boxShadow: widget.tokens.shadowMd,
              ),
              child: Text(
                widget.message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.tokens.bg,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
