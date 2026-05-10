// test/domain/usecases/get_chat_messages_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:ride_app/core/errors/failures.dart';
import 'package:ride_app/domain/entities/chat_conversation.dart';
import 'package:ride_app/domain/entities/chat_message.dart';
import 'package:ride_app/domain/repositories/chat_repository.dart';
import 'package:ride_app/domain/usecases/get_chat_messages.dart';

class _FakeChatRepository implements ChatRepository {
  final Either<Failure, List<ChatMessage>> result;
  _FakeChatRepository(this.result);

  @override
  Future<Either<Failure, List<ChatConversation>>> getConversations() async =>
      const Right([]);

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String conversationId) async =>
      result;
}

void main() {
  test('returns messages for a conversation', () async {
    final msg = ChatMessage(
      id: 'm1', conversationId: 'c1',
      body: 'Hello', isFromDriver: true, sentAt: DateTime(2026, 5, 1),
    );
    final useCase = GetChatMessages(
      _FakeChatRepository(Right([msg])),
    );
    final result = await useCase(const GetChatMessagesParams('c1'));
    expect(result.isRight(), true);
    result.fold(
      (failure) => fail('Expected Right but got Left'),
      (messages) {
        expect(messages.length, 1);
        expect(messages[0], msg);
      },
    );
  });

  test('passes conversationId to repository', () async {
    final repo = _CaptureIdRepo();
    final useCase = GetChatMessages(repo);
    await useCase(const GetChatMessagesParams('conv-xyz'));
    expect(repo.lastId, 'conv-xyz');
  });

  test('returns failure when repository fails', () async {
    final useCase = GetChatMessages(
      _FakeChatRepository(Left(ServerFailure())),
    );
    final result = await useCase(const GetChatMessagesParams('c1'));
    expect(result.isLeft(), true);
  });
}

class _CaptureIdRepo implements ChatRepository {
  String? lastId;

  @override
  Future<Either<Failure, List<ChatConversation>>> getConversations() async =>
      const Right([]);

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String conversationId) async {
    lastId = conversationId;
    return const Right([]);
  }
}
