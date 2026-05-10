// lib/presentation/pages/chat_thread_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/chat_message.dart';
import '../cubits/app_cubit.dart';
import '../cubits/chat_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import '../widgets/tap_scale.dart';

class ChatThreadPage extends StatefulWidget {
  const ChatThreadPage({super.key});

  @override
  State<ChatThreadPage> createState() => _ChatThreadPageState();
}

class _ChatThreadPageState extends State<ChatThreadPage> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send(ChatCubit cubit, String body) {
    cubit.sendMessage(body);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppCubit>().state;
    final chatState = context.watch<ChatCubit>().state;
    final t = GlideTokens(dark: appState.darkMode);
    final appCubit = context.read<AppCubit>();
    final chatCubit = context.read<ChatCubit>();
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    final conv = chatState.conversations.where(
      (c) => c.id == appState.activeConversationId,
    ).firstOrNull;

    return Container(
      color: t.bg,
      child: Column(
        children: [
          // Top bar
          Padding(
            padding: EdgeInsets.fromLTRB(16, topPad + 14, 16, 12),
            child: Row(
              children: [
                GlideBackButton(
                  onTap: () => appCubit.goTo(AppScreen.chatInbox),
                  tokens: t,
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: conv != null ? () => appCubit.goTo(AppScreen.driver) : null,
                  child: Row(
                    children: [
                      if (conv != null) ...[
                        GlideAvatar(size: 34, hue: conv.driverAvatarHue, cardColor: t.card),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        conv?.driverName ?? 'Driver',
                        style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700,
                          color: t.ink, letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GlideIconPill(
                  icon: LucideIcons.phone,
                  tokens: t,
                  bgColor: t.accent,
                  iconColor: t.accentInk,
                  iconSize: 18,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    if (conv != null) {
                      context.read<AppCubit>().goToCall(
                            conversationId: conv.id,
                            driverName: conv.driverName,
                            driverHue: conv.driverAvatarHue,
                          );
                    }
                  },
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: chatState.isLoading
                ? const SizedBox()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: chatState.messages.length,
                    itemBuilder: (_, i) {
                      final msg = chatState.messages[i];
                      final isLast = i == chatState.messages.length - 1;
                      final showTime = isLast ||
                          chatState.messages[i + 1].isFromDriver != msg.isFromDriver;
                      return _MessageBubble(
                        message: msg,
                        showTime: showTime,
                        tokens: t,
                      );
                    },
                  ),
          ),

          // Quick replies + input
          Container(
            decoration: BoxDecoration(
              color: t.card,
              border: Border(top: BorderSide(color: t.hair)),
            ),
            padding: EdgeInsets.fromLTRB(16, 10, 16, bottomPad + 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick reply chips
                Wrap(
                  spacing: 8,
                  children: ['On my way', '5 minutes away', 'Thanks!'].map((reply) {
                    return TapScale(
                      onTap: () => _send(chatCubit, reply),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(
                          color: t.subtle,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: t.hair2),
                        ),
                        child: Text(
                          reply,
                          style: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w600, color: t.ink,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                // Input row
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: t.subtle,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: t.hair2),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          'Type a message…',
                          style: TextStyle(fontSize: 14, color: t.muted),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TapScale(
                      onTap: () => _send(chatCubit, 'Hey, just checking in!'),
                      child: Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: t.accent,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: t.accent.withValues(alpha: 0.35),
                              blurRadius: 10, offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(LucideIcons.sendHorizontal, color: t.accentInk, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatefulWidget {
  final ChatMessage message;
  final bool showTime;
  final GlideTokens tokens;

  const _MessageBubble({
    required this.message,
    required this.showTime,
    required this.tokens,
  });

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.tokens;
    final isDriver = widget.message.isFromDriver;
    final body = widget.message.body;
    final sentAt = widget.message.sentAt;

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.scale(scale: _scale.value, child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Column(
          crossAxisAlignment: isDriver ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isDriver ? t.card : t.accent,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isDriver ? 4 : 18),
                  bottomRight: Radius.circular(isDriver ? 18 : 4),
                ),
                boxShadow: t.shadowSm,
              ),
              child: Text(
                body,
                style: TextStyle(
                  fontSize: 14,
                  color: isDriver ? t.ink : t.accentInk,
                ),
              ),
            ),
            if (widget.showTime) ...[
              const SizedBox(height: 4),
              Text(
                DateFormat('h:mm a').format(sentAt),
                style: TextStyle(fontSize: 11, color: t.muted),
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
