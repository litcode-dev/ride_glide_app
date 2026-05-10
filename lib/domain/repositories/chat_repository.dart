import 'package:fpdart/fpdart.dart';
import '../../core/errors/failures.dart';
import '../entities/chat_conversation.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatConversation>>> getConversations();
  Future<Either<Failure, List<ChatMessage>>> getMessages(String conversationId);
}
