// lib/domain/entities/chat_message.dart
class ChatMessage {
  final String id;
  final String conversationId;
  final String body;
  final bool isFromDriver;
  final DateTime sentAt;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.body,
    required this.isFromDriver,
    required this.sentAt,
  });
}
