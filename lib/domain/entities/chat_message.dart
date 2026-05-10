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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          conversationId == other.conversationId &&
          body == other.body &&
          isFromDriver == other.isFromDriver &&
          sentAt == other.sentAt;

  @override
  int get hashCode =>
      id.hashCode ^
      conversationId.hashCode ^
      body.hashCode ^
      isFromDriver.hashCode ^
      sentAt.hashCode;
}
