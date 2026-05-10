// lib/domain/entities/chat_conversation.dart
class ChatConversation {
  final String id;
  final String driverName;
  final int driverAvatarHue;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final String tripId;

  const ChatConversation({
    required this.id,
    required this.driverName,
    required this.driverAvatarHue,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.tripId,
  });
}
