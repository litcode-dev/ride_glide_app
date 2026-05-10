import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/usecases/usecase.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_chat_conversations.dart';
import '../../domain/usecases/get_chat_messages.dart';

class ChatState {
  final List<ChatConversation> conversations;
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.conversations = const [],
    this.messages = const [],
    this.isLoading = true,
    this.error,
  });

  ChatState copyWith({
    List<ChatConversation>? conversations,
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) =>
      ChatState(
        conversations: conversations ?? this.conversations,
        messages: messages ?? this.messages,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
      );
}

class ChatCubit extends Cubit<ChatState> {
  final GetChatConversations _getConversations;
  final GetChatMessages _getMessages;

  ChatCubit(this._getConversations, this._getMessages) : super(const ChatState());

  Future<void> loadConversations() async {
    final result = await _getConversations(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (conversations) => emit(state.copyWith(conversations: conversations, isLoading: false)),
    );
  }

  Future<void> loadMessages(String conversationId) async {
    emit(state.copyWith(isLoading: true));
    final result = await _getMessages(GetChatMessagesParams(conversationId));
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, error: failure.message)),
      (messages) => emit(state.copyWith(messages: messages, isLoading: false)),
    );
  }

  void sendMessage(String body) {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: '',
      body: body,
      isFromDriver: false,
      sentAt: DateTime.now(),
    );
    emit(state.copyWith(messages: [...state.messages, message]));
  }
}
