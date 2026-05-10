import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class GetChatMessagesParams {
  final String conversationId;
  const GetChatMessagesParams(this.conversationId);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetChatMessagesParams &&
          runtimeType == other.runtimeType &&
          conversationId == other.conversationId;

  @override
  int get hashCode => conversationId.hashCode;
}

class GetChatMessages implements UseCase<List<ChatMessage>, GetChatMessagesParams> {
  final ChatRepository _repository;
  GetChatMessages(this._repository);

  @override
  Future<Either<Failure, List<ChatMessage>>> call(GetChatMessagesParams params) =>
      _repository.getMessages(params.conversationId);
}
