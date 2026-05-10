import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/chat_conversation.dart';
import '../repositories/chat_repository.dart';

class GetChatConversations implements UseCase<List<ChatConversation>, NoParams> {
  final ChatRepository _repository;
  GetChatConversations(this._repository);

  @override
  Future<Either<Failure, List<ChatConversation>>> call(NoParams params) =>
      _repository.getConversations();
}
