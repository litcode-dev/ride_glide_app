import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ride_app/core/errors/failures.dart';
import 'package:ride_app/core/usecases/usecase.dart';
import 'package:ride_app/domain/entities/chat_conversation.dart';
import 'package:ride_app/domain/entities/chat_message.dart';
import 'package:ride_app/domain/repositories/chat_repository.dart';
import 'package:ride_app/domain/usecases/get_chat_conversations.dart';

class _FakeChatRepository implements ChatRepository {
  final Either<Failure, List<ChatConversation>> result;
  _FakeChatRepository(this.result);

  @override
  Future<Either<Failure, List<ChatConversation>>> getConversations() async => result;

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String id) async =>
      const Right([]);
}

void main() {
  test('returns conversations from repository', () async {
    final conv = ChatConversation(
      id: 'c1', driverName: 'Joe', driverAvatarHue: 42,
      lastMessage: 'On my way', lastMessageTime: DateTime(2026, 5, 1),
      unreadCount: 2, tripId: 't1',
    );
    final useCase = GetChatConversations(_FakeChatRepository(Right([conv])));
    final result = await useCase(const NoParams());
    expect(result.getOrElse((_) => []), [conv]);
  });

  test('returns failure when repository fails', () async {
    final useCase = GetChatConversations(_FakeChatRepository(Left(ServerFailure())));
    final result = await useCase(const NoParams());
    expect(result.isLeft(), true);
  });
}
