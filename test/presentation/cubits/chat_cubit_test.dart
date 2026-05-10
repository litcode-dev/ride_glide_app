import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ride_app/core/errors/failures.dart';
import 'package:ride_app/domain/entities/chat_conversation.dart';
import 'package:ride_app/domain/entities/chat_message.dart';
import 'package:ride_app/domain/repositories/chat_repository.dart';
import 'package:ride_app/domain/usecases/get_chat_conversations.dart';
import 'package:ride_app/domain/usecases/get_chat_messages.dart';
import 'package:ride_app/presentation/cubits/chat_cubit.dart';

class _FakeChatRepository implements ChatRepository {
  @override
  Future<Either<Failure, List<ChatConversation>>> getConversations() async => Right([
        ChatConversation(
          id: 'c1',
          driverName: 'Joe',
          driverAvatarHue: 42,
          lastMessage: 'Hi',
          lastMessageTime: DateTime(2026, 5, 1),
          unreadCount: 1,
          tripId: 't1',
        ),
      ]);

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String id) async => Right([
        ChatMessage(
          id: 'm1',
          conversationId: id,
          body: 'Hello',
          isFromDriver: true,
          sentAt: DateTime(2026, 5, 1),
        ),
      ]);
}

void main() {
  ChatCubit makeCubit() {
    final repo = _FakeChatRepository();
    return ChatCubit(GetChatConversations(repo), GetChatMessages(repo));
  }

  test('loads conversations', () async {
    final cubit = makeCubit();
    await cubit.loadConversations();
    expect(cubit.state.conversations.length, 1);
    expect(cubit.state.isLoading, false);
  });

  test('loads messages for a conversation', () async {
    final cubit = makeCubit();
    await cubit.loadMessages('c1');
    expect(cubit.state.messages.length, 1);
    expect(cubit.state.messages.first.body, 'Hello');
  });

  test('sendMessage appends to messages list', () async {
    final cubit = makeCubit();
    await cubit.loadMessages('c1');
    cubit.sendMessage('Thanks!');
    expect(cubit.state.messages.length, 2);
    expect(cubit.state.messages.last.body, 'Thanks!');
    expect(cubit.state.messages.last.isFromDriver, false);
  });
}
