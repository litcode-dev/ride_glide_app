// lib/presentation/pages/chat_inbox_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/app_cubit.dart';
import '../cubits/chat_cubit.dart';
import '../theme/glide_tokens.dart';
import '../widgets/common_widgets.dart';
import '../widgets/tap_scale.dart';

class ChatInboxPage extends StatelessWidget {
  const ChatInboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppCubit>().state;
    final chatState = context.watch<ChatCubit>().state;
    final t = GlideTokens(dark: appState.darkMode);
    final appCubit = context.read<AppCubit>();
    final topPad = MediaQuery.of(context).padding.top;

    return Container(
      color: t.bg,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, topPad + 14, 20, 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Messages',
                style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.w800,
                  color: t.ink, letterSpacing: -0.5,
                ),
              ),
            ),
          ),
          Expanded(
            child: chatState.isLoading
                ? const SizedBox()
                : chatState.conversations.isEmpty
                    ? Center(
                        child: Text(
                          'No messages yet',
                          style: TextStyle(fontSize: 15, color: t.muted),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom + 110,
                        ),
                        itemCount: chatState.conversations.length,
                        itemBuilder: (_, i) {
                          final conv = chatState.conversations[i];
                          final timeStr = DateFormat('MMM d').format(conv.lastMessageTime);
                          return TapScale(
                            onTap: () => appCubit.goToChat(conv.id),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                decoration: BoxDecoration(
                                  color: t.card,
                                  border: Border(bottom: BorderSide(color: t.hair)),
                                ),
                                child: Row(
                                  children: [
                                    GlideAvatar(size: 48, hue: conv.driverAvatarHue, cardColor: t.card),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            conv.driverName,
                                            style: TextStyle(
                                              fontSize: 15, fontWeight: FontWeight.w700,
                                              color: t.ink, letterSpacing: -0.2,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            conv.lastMessage,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 13, color: t.muted),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(timeStr, style: TextStyle(fontSize: 11, color: t.muted)),
                                        const SizedBox(height: 4),
                                        if (conv.unreadCount > 0)
                                          Container(
                                            width: 20, height: 20,
                                            decoration: BoxDecoration(
                                              color: t.accent,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${conv.unreadCount}',
                                              style: TextStyle(
                                                fontSize: 11, fontWeight: FontWeight.w800,
                                                color: t.accentInk,
                                              ),
                                            ),
                                          )
                                        else
                                          const SizedBox(width: 20, height: 20),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
          GlideTabBar(
            active: 'chat',
            tokens: t,
            onHome: () => appCubit.goTo(AppScreen.home),
            onSettings: () => appCubit.goTo(AppScreen.account),
            onTrips: () => appCubit.goTo(AppScreen.trips),
            onChat: () {},
            isRideActive: appState.isRideActive,
          ),
        ],
      ),
    );
  }
}
