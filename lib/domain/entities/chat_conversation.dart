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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConversation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          driverName == other.driverName &&
          driverAvatarHue == other.driverAvatarHue &&
          lastMessage == other.lastMessage &&
          lastMessageTime == other.lastMessageTime &&
          unreadCount == other.unreadCount &&
          tripId == other.tripId;

  @override
  int get hashCode =>
      id.hashCode ^
      driverName.hashCode ^
      driverAvatarHue.hashCode ^
      lastMessage.hashCode ^
      lastMessageTime.hashCode ^
      unreadCount.hashCode ^
      tripId.hashCode;
}
