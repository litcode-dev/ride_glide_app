import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../cubits/app_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';

class CallPage extends StatefulWidget {
  const CallPage({super.key});

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> with TickerProviderStateMixin {
  late final List<AnimationController> _ripples;
  late final AnimationController _fadeIn;
  late final Timer _connectTimer;
  late final Timer _tickTimer;

  bool _connected = false;
  bool _muted = false;
  bool _speaker = false;
  int _seconds = 0;

  static const _kBg = Color(0xFF0D0D0F);
  static const _kMuted = Color(0xFF8E8E93);

  @override
  void initState() {
    super.initState();

    _ripples = List.generate(3, (i) {
      final ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2200),
      );
      Future.delayed(Duration(milliseconds: i * 600), () {
        if (mounted) ctrl.repeat();
      });
      return ctrl;
    });

    _fadeIn = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();

    _connectTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _connected = true);
      _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _seconds++);
      });
    });

    // _tickTimer initialized lazily in _connectTimer — suppress late warning
  }

  @override
  void dispose() {
    for (final c in _ripples) {
      c.dispose();
    }
    _fadeIn.dispose();
    _connectTimer.cancel();
    if (_connected) _tickTimer.cancel();
    super.dispose();
  }

  String get _timerLabel {
    final m = _seconds ~/ 60;
    final s = _seconds % 60;
    return '${m.toString().padLeft(1, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _endCall(BuildContext context) {
    HapticFeedback.mediumImpact();
    context.read<AppCubit>().goTo(AppScreen.chatThread);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppCubit>().state;
    final driverName = state.activeDriverName ?? 'Driver';
    final driverHue = state.activeDriverHue ?? 22;
    final topPad = MediaQuery.of(context).padding.top;
    const accent = kAccent;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: FadeTransition(
        opacity: _fadeIn,
        child: Container(
          color: _kBg,
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                SizedBox(height: topPad + 16),

                // Status
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    _connected ? 'Connected · $_timerLabel' : 'Calling...',
                    key: ValueKey(_connected),
                    style: const TextStyle(
                      fontSize: 13,
                      color: _kMuted,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Driver name
                Text(
                  driverName,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),

                const Spacer(),

                // Ripple avatar
                SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ..._ripples.map((ctrl) => AnimatedBuilder(
                            animation: ctrl,
                            builder: (context, child) {
                              final scale = 1.0 + ctrl.value * 1.4;
                              final opacity = (1.0 - ctrl.value).clamp(0.0, 1.0);
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: accent.withValues(alpha: opacity * 0.45),
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              );
                            },
                          )),
                      GlideAvatar(size: 100, hue: driverHue),
                    ],
                  ),
                ),

                const Spacer(),

                // Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CallButton(
                        icon: _muted ? LucideIcons.micOff : LucideIcons.mic,
                        label: 'Mute',
                        active: _muted,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _muted = !_muted);
                        },
                      ),
                      _EndCallButton(onTap: () => _endCall(context)),
                      _CallButton(
                        icon: _speaker ? LucideIcons.volume2 : LucideIcons.speaker,
                        label: 'Speaker',
                        active: _speaker,
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _speaker = !_speaker);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CallButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _CallButton({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  static const _kCard = Color(0xFF1C1C1F);
  static const _kMuted = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? kAccent : _kCard,
            ),
            child: Icon(
              icon,
              color: active ? kAccentInk : Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _EndCallButton extends StatelessWidget {
  final VoidCallback onTap;

  const _EndCallButton({required this.onTap});

  static const _kMuted = Color(0xFF8E8E93);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFF3B30),
            ),
            child: const Icon(LucideIcons.phoneOff, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          const Text(
            'End call',
            style: TextStyle(fontSize: 12, color: _kMuted, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
