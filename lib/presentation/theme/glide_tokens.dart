import 'package:flutter/material.dart';

const Color kAccent = Color(0xFFC5F94B);
const Color kAccentDeep = Color(0xFFA8E024);
const Color kAccentInk = Color(0xFF0E1014);

class GlideTokens {
  final bool dark;
  const GlideTokens({this.dark = false});

  Color get bg => dark ? const Color(0xFF0B0C0E) : const Color(0xFFFAFAF7);
  Color get card => dark ? const Color(0xFF16181C) : Colors.white;
  Color get ink => dark ? const Color(0xFFF4F4F0) : const Color(0xFF0E1014);
  Color get ink2 => dark ? const Color(0xFFC5C7CC) : const Color(0xFF3A3F47);
  Color get muted => dark ? const Color(0xFF7A7E84) : const Color(0xFF8A8E94);
  Color get hair => dark ? const Color(0x0FFFFFFF) : const Color(0xFFEEEDE7);
  Color get hair2 => dark ? const Color(0x1AFFFFFF) : const Color(0xFFE5E4DD);
  Color get subtle => dark ? const Color(0x0DFFFFFF) : const Color(0xFFF5F4EE);
  Color get keyBg => dark ? const Color(0xFF2A2D33) : const Color(0xFFFBFBFB);
  Color get keyTray => dark ? const Color(0xFF16181C) : const Color(0xFFD1D5DB);
  Color get cancelBg => dark ? const Color(0x2EDC4B37) : const Color(0xFFFBE6E2);
  Color get cancelInk => dark ? const Color(0xFFFF8A78) : const Color(0xFFA12C1C);
  Color get accent => kAccent;
  Color get accentDeep => kAccentDeep;
  Color get accentInk => kAccentInk;

  List<BoxShadow> get shadowSm => dark
      ? [
          const BoxShadow(color: Color(0x66000000), blurRadius: 2, offset: Offset(0, 1)),
          const BoxShadow(color: Color(0x59000000), blurRadius: 14, offset: Offset(0, 4)),
        ]
      : [
          const BoxShadow(color: Color(0x0A14161C), blurRadius: 2, offset: Offset(0, 1)),
          const BoxShadow(color: Color(0x0D14161C), blurRadius: 14, offset: Offset(0, 4)),
        ];

  List<BoxShadow> get shadowMd => dark
      ? [
          const BoxShadow(color: Color(0x73000000), blurRadius: 6, offset: Offset(0, 2)),
          const BoxShadow(color: Color(0x8C000000), blurRadius: 38, offset: Offset(0, 14)),
        ]
      : [
          const BoxShadow(color: Color(0x0D14161C), blurRadius: 6, offset: Offset(0, 2)),
          const BoxShadow(color: Color(0x1A14161C), blurRadius: 38, offset: Offset(0, 14)),
        ];

  List<BoxShadow> get shadowLg => dark
      ? [
          const BoxShadow(color: Color(0x80000000), blurRadius: 12, offset: Offset(0, 4)),
          const BoxShadow(color: Color(0xB3000000), blurRadius: 80, offset: Offset(0, 30)),
        ]
      : [
          const BoxShadow(color: Color(0x1414161C), blurRadius: 12, offset: Offset(0, 4)),
          const BoxShadow(color: Color(0x2E14161C), blurRadius: 80, offset: Offset(0, 30)),
        ];
}
