class ChatHistoryModel {
  final String id;
  final String botId;
  final String botName;
  final String botDescription;
  final String botCategory;
  final String userId;
  final List<Map<String, dynamic>> messages;
  final DateTime lastMessageTime;
  final DateTime createdAt;

  ChatHistoryModel({
    required this.id,
    required this.botId,
    required this.botName,
    required this.botDescription,
    required this.botCategory,
    required this.userId,
    required this.messages,
    required this.lastMessageTime,
    required this.createdAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'botId': botId,
      'botName': botName,
      'botDescription': botDescription,
      'botCategory': botCategory,
      'userId': userId,
      'messages': messages,
      'lastMessageTime': lastMessageTime,
      'createdAt': createdAt,
    };
  }

  // Create from Firestore document
  factory ChatHistoryModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return ChatHistoryModel(
      id: documentId,
      botId: data['botId'] ?? '',
      botName: data['botName'] ?? 'Unknown Bot',
      botDescription: data['botDescription'] ?? '',
      botCategory: data['botCategory'] ?? 'General',
      userId: data['userId'] ?? '',
      messages: List<Map<String, dynamic>>.from(data['messages'] ?? []),
      lastMessageTime: data['lastMessageTime']?.toDate() ?? DateTime.now(),
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
    );
  }

  // Create copy with updated fields
  ChatHistoryModel copyWith({
    String? id,
    String? botId,
    String? botName,
    String? botDescription,
    String? botCategory,
    String? userId,
    List<Map<String, dynamic>>? messages,
    DateTime? lastMessageTime,
    DateTime? createdAt,
  }) {
    return ChatHistoryModel(
      id: id ?? this.id,
      botId: botId ?? this.botId,
      botName: botName ?? this.botName,
      botDescription: botDescription ?? this.botDescription,
      botCategory: botCategory ?? this.botCategory,
      userId: userId ?? this.userId,
      messages: messages ?? this.messages,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
