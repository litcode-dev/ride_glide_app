// lib/presentation/widgets/safety_sheet.dart
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';

void showSafetySheet(BuildContext context, GlideTokens tokens) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _SafetySheet(tokens: tokens),
  );
}

class _SafetySheet extends StatelessWidget {
  final GlideTokens tokens;
  const _SafetySheet({required this.tokens});

  static const _contacts = [
    (name: 'Emergency Services', phone: '911', hue: 0),
    (name: 'Sarah Hales', phone: '+1 (555) 248-1132', hue: 160),
    (name: 'Marcus Johnson', phone: '+1 (555) 879-4400', hue: 240),
  ];

  @override
  Widget build(BuildContext context) {
    final t = tokens;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: t.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(22, 14, 22, bottomPad + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SheetHandle(tokens: t),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: t.cancelBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(LucideIcons.shieldCheck, color: t.cancelInk, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'Safety',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  color: t.ink,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Emergency contacts',
            style: TextStyle(fontSize: 13, color: t.muted),
          ),
          const SizedBox(height: 16),
          ..._contacts.map((c) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: t.subtle,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    GlideAvatar(size: 42, hue: c.hue, cardColor: t.card),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: t.ink,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text(c.phone, style: TextStyle(fontSize: 12, color: t.muted)),
                        ],
                      ),
                    ),
                    GlideIconPill(
                      icon: LucideIcons.phone,
                      tokens: t,
                      bgColor: t.accent,
                      iconColor: t.accentInk,
                      iconSize: 16,
                      size: 38,
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: t.subtle,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: t.hair2),
              ),
              alignment: Alignment.center,
              child: Text(
                'Close',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: t.ink,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
