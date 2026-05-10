// lib/data/datasources/local/chat_local_datasource.dart
import '../../../domain/entities/chat_conversation.dart';
import '../../../domain/entities/chat_message.dart';

abstract class ChatLocalDatasource {
  Future<List<ChatConversation>> getConversations();
  Future<List<ChatMessage>> getMessages(String conversationId);
}

class ChatLocalDatasourceImpl implements ChatLocalDatasource {
  static final _conversations = [
    ChatConversation(
      id: 'c1', driverName: 'Joe Smith', driverAvatarHue: 42,
      lastMessage: 'See you in 2 minutes!', lastMessageTime: DateTime(2026, 5, 8, 14, 21),
      unreadCount: 2, tripId: 't1',
    ),
    ChatConversation(
      id: 'c2', driverName: 'Maria Lopez', driverAvatarHue: 200,
      lastMessage: 'Have a great flight!', lastMessageTime: DateTime(2026, 5, 5, 7, 8),
      unreadCount: 0, tripId: 't2',
    ),
    ChatConversation(
      id: 'c3', driverName: 'Chris Park', driverAvatarHue: 310,
      lastMessage: 'Thanks! 5 stars for sure.', lastMessageTime: DateTime(2026, 5, 2, 19, 2),
      unreadCount: 0, tripId: 't3',
    ),
  ];

  static final _messages = {
    'c1': [
      ChatMessage(id: 'm1', conversationId: 'c1', body: 'Hi, I\'m on my way!', isFromDriver: true, sentAt: DateTime(2026, 5, 8, 14, 10)),
      ChatMessage(id: 'm2', conversationId: 'c1', body: 'On my way', isFromDriver: false, sentAt: DateTime(2026, 5, 8, 14, 11)),
      ChatMessage(id: 'm3', conversationId: 'c1', body: 'I\'m the white Tesla, plate NJ 7M3 K42', isFromDriver: true, sentAt: DateTime(2026, 5, 8, 14, 15)),
      ChatMessage(id: 'm4', conversationId: 'c1', body: 'Got it, thanks!', isFromDriver: false, sentAt: DateTime(2026, 5, 8, 14, 16)),
      ChatMessage(id: 'm5', conversationId: 'c1', body: 'I\'ll be at the corner in 2 min', isFromDriver: true, sentAt: DateTime(2026, 5, 8, 14, 20)),
      ChatMessage(id: 'm6', conversationId: 'c1', body: 'See you in 2 minutes!', isFromDriver: true, sentAt: DateTime(2026, 5, 8, 14, 21)),
    ],
    'c2': [
      ChatMessage(id: 'm7', conversationId: 'c2', body: 'Good morning! Ready when you are.', isFromDriver: true, sentAt: DateTime(2026, 5, 5, 7, 0)),
      ChatMessage(id: 'm8', conversationId: 'c2', body: '5 minutes away', isFromDriver: false, sentAt: DateTime(2026, 5, 5, 7, 1)),
      ChatMessage(id: 'm9', conversationId: 'c2', body: 'No rush, I\'m right outside terminal 2', isFromDriver: true, sentAt: DateTime(2026, 5, 5, 7, 3)),
      ChatMessage(id: 'm10', conversationId: 'c2', body: 'Which terminal are you parked at?', isFromDriver: false, sentAt: DateTime(2026, 5, 5, 7, 4)),
      ChatMessage(id: 'm11', conversationId: 'c2', body: 'Terminal 4 departure drop-off', isFromDriver: true, sentAt: DateTime(2026, 5, 5, 7, 6)),
      ChatMessage(id: 'm12', conversationId: 'c2', body: 'Have a great flight!', isFromDriver: true, sentAt: DateTime(2026, 5, 5, 7, 8)),
    ],
    'c3': [
      ChatMessage(id: 'm13', conversationId: 'c3', body: 'Arrived at Penn Station, have a good evening!', isFromDriver: true, sentAt: DateTime(2026, 5, 2, 19, 0)),
      ChatMessage(id: 'm14', conversationId: 'c3', body: 'Thanks!', isFromDriver: false, sentAt: DateTime(2026, 5, 2, 19, 1)),
      ChatMessage(id: 'm15', conversationId: 'c3', body: 'Great ride, very smooth', isFromDriver: false, sentAt: DateTime(2026, 5, 2, 19, 1)),
      ChatMessage(id: 'm16', conversationId: 'c3', body: 'Appreciate it! Safe travels.', isFromDriver: true, sentAt: DateTime(2026, 5, 2, 19, 2)),
      ChatMessage(id: 'm17', conversationId: 'c3', body: 'Thanks! 5 stars for sure.', isFromDriver: false, sentAt: DateTime(2026, 5, 2, 19, 2)),
    ],
  };

  @override
  Future<List<ChatConversation>> getConversations() async => _conversations;

  @override
  Future<List<ChatMessage>> getMessages(String conversationId) async =>
      _messages[conversationId] ?? [];
}
