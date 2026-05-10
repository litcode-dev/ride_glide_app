import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/local/chat_local_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatLocalDatasource _datasource;
  ChatRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<ChatConversation>>> getConversations() async {
    try {
      return Right(await _datasource.getConversations());
    } catch (_) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<ChatMessage>>> getMessages(String conversationId) async {
    try {
      return Right(await _datasource.getMessages(conversationId));
    } catch (_) {
      return Left(ServerFailure());
    }
  }
}
