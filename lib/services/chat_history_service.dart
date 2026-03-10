import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_history_model.dart';

class ChatHistoryService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final CollectionReference _chatHistoryCollection = _firestore.collection('chat_history');

  // Create or update chat history
  static Future<void> saveChatHistory(ChatHistoryModel chatHistory) async {
    try {
      await _chatHistoryCollection.doc(chatHistory.id).set(chatHistory.toFirestore());
    } catch (e) {
      throw Exception('Failed to save chat history: $e');
    }
  }

  // Get chat history for a specific user and bot
  static Future<ChatHistoryModel?> getChatHistory(String userId, String botId) async {
    try {
      QuerySnapshot querySnapshot = await _chatHistoryCollection
          .where('userId', isEqualTo: userId)
          .where('botId', isEqualTo: botId)
          .orderBy('lastMessageTime', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return ChatHistoryModel.fromFirestore(
          querySnapshot.docs.first.data() as Map<String, dynamic>,
          querySnapshot.docs.first.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get chat history: $e');
    }
  }

  // Get all chat histories for a user
  static Stream<List<ChatHistoryModel>> getUserChatHistories(String userId) {
    try {
      print('Creating chat history stream for userId: $userId');
      return _chatHistoryCollection
          .where('userId', isEqualTo: userId)
          .orderBy('lastMessageTime', descending: true)
          .snapshots()
          .map((snapshot) {
            print('Chat History Snapshot: ${snapshot.docs.length} documents');
            final List<ChatHistoryModel> chatHistories = [];
            for (var doc in snapshot.docs) {
              try {
                final chatHistory = ChatHistoryModel.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                );
                if (chatHistory != null) {
                  chatHistories.add(chatHistory);
                }
              } catch (e) {
                print('Error parsing chat history document: $e');
              }
            }
            print('Successfully parsed ${chatHistories.length} chat histories');
            return chatHistories;
          })
          .handleError((error) {
            print('Stream error in getUserChatHistories: $error');
            return <ChatHistoryModel>[];
          });
    } catch (e) {
      print('Error creating chat history stream: $e');
      return Stream.value([]);
    }
  }

  // Add message to existing chat history
  static Future<void> addMessageToChatHistory(
    String chatHistoryId,
    Map<String, dynamic> message,
  ) async {
    try {
      await _chatHistoryCollection.doc(chatHistoryId).update({
        'messages': FieldValue.arrayUnion([message]),
        'lastMessageTime': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to add message to chat history: $e');
    }
  }

  // Delete chat history
  static Future<void> deleteChatHistory(String chatHistoryId) async {
    try {
      await _chatHistoryCollection.doc(chatHistoryId).delete();
    } catch (e) {
      throw Exception('Failed to delete chat history: $e');
    }
  }

  // Get chat history by ID
  static Future<ChatHistoryModel?> getChatHistoryById(String chatHistoryId) async {
    try {
      DocumentSnapshot doc = await _chatHistoryCollection.doc(chatHistoryId).get();
      if (doc.exists) {
        return ChatHistoryModel.fromFirestore(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get chat history: $e');
    }
  }

  // Clear all chat history for a user
  static Future<void> clearUserChatHistory(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _chatHistoryCollection
          .where('userId', isEqualTo: userId)
          .get();

      for (DocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Failed to clear chat history: $e');
    }
  }
}
