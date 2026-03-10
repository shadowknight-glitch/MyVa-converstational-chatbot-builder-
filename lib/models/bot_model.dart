import 'package:cloud_firestore/cloud_firestore.dart';

class BotModel {
  final String id;
  final String name;
  final String description;
  final String purpose;
  final String category;
  final DateTime? createdAt;
  final String status;
  final String userId;
  final bool isPublic;

  BotModel({
    required this.id,
    required this.name,
    required this.description,
    required this.purpose,
    required this.category,
    this.createdAt,
    required this.status,
    required this.userId,
    this.isPublic = false,
  });

  factory BotModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    print('BotModel: Creating from firestore with documentId: $documentId');
    print('BotModel: Data keys: ${data.keys.toList()}');
    print('BotModel: Raw data: $data');
    
    // Check each field specifically
    print('BotModel: name field: ${data['name']} (type: ${data['name'].runtimeType})');
    print('BotModel: description field: ${data['description']} (type: ${data['description'].runtimeType})');
    print('BotModel: purpose field: ${data['purpose']} (type: ${data['purpose'].runtimeType})');
    print('BotModel: category field: ${data['category']} (type: ${data['category'].runtimeType})');
    print('BotModel: isPublic field: ${data['isPublic']} (type: ${data['isPublic'].runtimeType})');
    print('BotModel: userId field: ${data['userId']} (type: ${data['userId'].runtimeType})');
    print('BotModel: status field: ${data['status']} (type: ${data['status'].runtimeType})');
    print('BotModel: createdAt field: ${data['createdAt']} (type: ${data['createdAt'].runtimeType})');
    
    // Special check for isPublic field
    if (data['isPublic'] == null) {
      print('BotModel: WARNING - isPublic field is null!');
    } else {
      print('BotModel: isPublic value: ${data['isPublic']} == false? ${data['isPublic'] == false}');
    }
    
    try {
      final bot = BotModel(
        id: documentId,
        name: data['name'] ?? '',
        description: data['description'] ?? '',
        purpose: data['purpose'] ?? '',
        category: data['category'] ?? 'Other',
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        status: data['status'] ?? 'active',
        userId: data['userId'] ?? '',
        isPublic: data['isPublic'] ?? false,
      );
      print('BotModel: Successfully created bot: ${bot.name} (${bot.id})');
      print('BotModel: Bot isPublic: ${bot.isPublic}');
      print('BotModel: Bot object created successfully - all fields populated');
      return bot;
    } catch (e) {
      print('BotModel: Error creating bot: $e');
      print('BotModel: Stack trace: ${StackTrace.current}');
      print('BotModel: Error details - name: ${data['name']}, description: ${data['description']}, isPublic: ${data['isPublic']}');
      rethrow; // Re-throw the error to see the full stack trace
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'purpose': purpose,
      'category': category,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : Timestamp.now(),
      'status': status,
      'userId': userId,
      'isPublic': isPublic,
    };
  }
}
