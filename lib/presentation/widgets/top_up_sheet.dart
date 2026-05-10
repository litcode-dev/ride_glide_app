// lib/presentation/widgets/top_up_sheet.dart
import 'package:flutter/material.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import 'glide_toast.dart';

void showTopUpSheet(BuildContext context, GlideTokens tokens) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _TopUpSheet(tokens: tokens),
  );
}

class _TopUpSheet extends StatefulWidget {
  final GlideTokens tokens;
  const _TopUpSheet({required this.tokens});

  @override
  State<_TopUpSheet> createState() => _TopUpSheetState();
}

class _TopUpSheetState extends State<_TopUpSheet> {
  int _selectedIndex = 1;
  final _amounts = [10, 25, 50];

  GlideTokens get t => widget.tokens;

  @override
  Widget build(BuildContext context) {
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
          Text(
            'Top Up Wallet',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: t.ink,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Choose an amount to add',
            style: TextStyle(fontSize: 13, color: t.muted),
          ),
          const SizedBox(height: 20),
          Row(
            children: List.generate(_amounts.length, (i) {
              final selected = i == _selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: EdgeInsets.only(right: i < _amounts.length - 1 ? 10 : 0),
                    height: 54,
                    decoration: BoxDecoration(
                      color: selected ? t.accent : t.subtle,
                      borderRadius: BorderRadius.circular(16),
                      border: selected
                          ? null
                          : Border.all(color: t.hair2, width: 1.5),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '£${_amounts[i]}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: selected ? t.accentInk : t.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              final amount = _amounts[_selectedIndex];
              Navigator.of(context).pop();
              showGlideToast(context, '£$amount added to your wallet ✓', t);
            },
            child: Container(
              height: 52,
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
                'Add to wallet',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: t.accentInk,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
