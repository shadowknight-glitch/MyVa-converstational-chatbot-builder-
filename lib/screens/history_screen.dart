import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bot_model.dart';
import '../models/chat_history_model.dart';
import '../services/chat_history_service.dart';
import 'chat_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  late Stream<List<ChatHistoryModel>> _chatHistoryStream;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    print('History Screen: initState() - User: ${_user?.uid}');
    
    try {
      // Create a more reliable stream that waits for auth state
      _chatHistoryStream = _createChatHistoryStream();
      
      // Listen to auth state changes
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (mounted) {
          setState(() {
            print('History: Auth state changed, updating stream. User: ${user?.uid}');
            _chatHistoryStream = _createChatHistoryStream();
          });
        }
      });
    } catch (e) {
      print('History: Error in initState: $e');
      _chatHistoryStream = Stream.value([]);
    }
  }

  Future<void> _refreshHistory() async {
    setState(() {
      _isRefreshing = true;
    });
    
    // Force refresh by recreating the stream
    setState(() {
      _chatHistoryStream = _createChatHistoryStream();
    });
    
    // Wait a moment for the refresh to complete
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  Stream<List<ChatHistoryModel>> _createChatHistoryStream() {
    try {
      if (_user == null) {
        print('History: No user found, returning empty stream');
        return Stream.value([]);
      }
      
      print('History: Creating chat history stream for userId: ${_user!.uid}');
      
      // First, let's try a simple query to see if we can access the collection
      return FirebaseFirestore.instance
          .collection('chat_history')
          .where('userId', isEqualTo: _user!.uid)
          .snapshots()
          .map((snapshot) {
            print('History: Raw snapshot received');
            print('History: Snapshot metadata: ${snapshot.metadata}');
            print('History: Snapshot docs length: ${snapshot.docs.length}');
            
            // If no docs found with userId filter, let's check if there are any docs at all
            if (snapshot.docs.isEmpty) {
              print('History: No docs found for user ${_user!.uid}, checking all docs...');
              FirebaseFirestore.instance
                  .collection('chat_history')
                  .limit(5)
                  .get()
                  .then((allDocs) {
                    print('History: Total docs in collection: ${allDocs.docs.length}');
                    for (var doc in allDocs.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      print('History: Sample doc userId: ${data['userId']} vs current: ${_user!.uid}');
                    }
                  });
            }
            
            // Log each document ID and basic info
            for (var doc in snapshot.docs) {
              print('History: Found document ID: ${doc.id}');
              final data = doc.data() as Map<String, dynamic>;
              print('History: Document keys: ${data.keys.toList()}');
              print('History: Document userId: ${data['userId']}');
              print('History: Document botName: ${data['botName']}');
            }
            
            final List<ChatHistoryModel> chatHistories = [];
            for (var doc in snapshot.docs) {
              try {
                final chatHistory = ChatHistoryModel.fromFirestore(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                );
                if (chatHistory != null) {
                  chatHistories.add(chatHistory);
                  print('History: Added chat history: ${chatHistory.botName}');
                }
              } catch (e) {
                print('History: Error parsing chat history document ${doc.id}: $e');
                print('History: Document data: ${doc.data()}');
              }
            }
            
            // Sort by most recent first (client-side only for now)
            chatHistories.sort((a, b) {
              // First try to sort by lastMessageTime
              if (a.lastMessageTime != null && b.lastMessageTime != null) {
                return b.lastMessageTime!.compareTo(a.lastMessageTime!);
              }
              // If lastMessageTime is null, sort by createdAt
              if (a.createdAt != null && b.createdAt != null) {
                return b.createdAt!.compareTo(a.createdAt!);
              }
              // If both are null, sort by bot name
              return a.botName.compareTo(b.botName);
            });
            
            print('History: Successfully parsed ${chatHistories.length} chat histories');
            return chatHistories;
          })
          .handleError((error) {
            print('History: Stream error in getUserChatHistories: $error');
            return <ChatHistoryModel>[]; // Return empty list on error
          });
    } catch (e) {
      print('History: Error creating chat history stream: $e');
      return Stream.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Techy Background Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: HistoryTechPatternPainter(),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor.withOpacity(0.8),
                          Theme.of(context).primaryColor,
                          Colors.cyan.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).primaryColor.withOpacity(0.4),
                          spreadRadius: 6,
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.history,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chat History',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Continue your previous conversations',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: IconButton(
                                icon: _isRefreshing 
                                    ? Container(
                                        width: 20,
                                        height: 20,
                                        child: const CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.refresh,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                onPressed: _isRefreshing ? null : _refreshHistory,
                                tooltip: 'Refresh history',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // History List
                  Expanded(
                    child: StreamBuilder<List<ChatHistoryModel>>(
                      stream: _chatHistoryStream,
                      builder: (context, snapshot) {
                        print('=== HISTORY SCREEN DEBUG ===');
                        print('Current User ID: ${_user?.uid}');
                        print('History Stream State: ${snapshot.connectionState}');
                        print('History Has Data: ${snapshot.hasData}');
                        print('History Has Error: ${snapshot.hasError}');
                        if (snapshot.hasData) {
                          print('History Data Length: ${snapshot.data!.length}');
                          for (int i = 0; i < snapshot.data!.length; i++) {
                            print('History Item $i: ${snapshot.data![i].botName} (User: ${snapshot.data![i].userId})');
                          }
                        }
                        if (snapshot.hasError) {
                          print('History Error: ${snapshot.error}');
                        }
                        
                        // Show loading only for the first 2 seconds, then show empty state
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return FutureBuilder(
                            future: Future.delayed(const Duration(seconds: 2)),
                            builder: (context, timerSnapshot) {
                              if (timerSnapshot.connectionState == ConnectionState.waiting) {
                                return Center(
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor.withOpacity(0.2),
                                          Theme.of(context).primaryColor.withOpacity(0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                                        width: 2,
                                      ),
                                    ),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                );
                              } else {
                                // After 2 seconds, show empty state
                                return _buildEmptyState('No history here to show', Icons.chat_outlined);
                              }
                            },
                          );
                        }
                        
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(40),
                                    border: Border.all(
                                      color: Colors.red.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.error_outline,
                                    size: 40,
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error loading history',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Please try again later',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return _buildEmptyState('No history here to show', Icons.chat_outlined);
                        }

                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            ChatHistoryModel chatHistory = snapshot.data![index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.05),
                                    Colors.white.withOpacity(0.02),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(20),
                                leading: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Theme.of(context).primaryColor.withOpacity(0.2),
                                        Colors.cyan.withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.smart_toy_outlined,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                title: Text(
                                  chatHistory.botName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      chatHistory.messages.isNotEmpty 
                                          ? chatHistory.messages.last['text'] as String? ?? 'No messages'
                                          : 'No messages yet',
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            chatHistory.botCategory,
                                            style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.cyan.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: Colors.cyan.withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            _formatDateTime(chatHistory.lastMessageTime),
                                            style: const TextStyle(
                                              color: Colors.cyan,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: PopupMenuButton<String>(
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onSelected: (value) {
                                      if (value == 'continue') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              existingChat: chatHistory,
                                            ),
                                          ),
                                        );
                                      } else if (value == 'delete') {
                                        _deleteChatHistory(chatHistory.id);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'continue',
                                        child: Row(
                                          children: [
                                            Icon(Icons.chat, size: 20, color: Colors.cyan),
                                            SizedBox(width: 12),
                                            Text('Continue Chat'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete, size: 20, color: Colors.red),
                                            SizedBox(width: 12),
                                            Text('Delete', style: TextStyle(color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(
                                        existingChat: chatHistory,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 50,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Future<void> _deleteChatHistory(String chatHistoryId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Delete Chat History',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this conversation? This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.cyan),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ChatHistoryService.deleteChatHistory(chatHistoryId);
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Chat history deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting chat history: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Custom painter for history screen tech pattern
class HistoryTechPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw diagonal lines
    for (int i = -size.height.toInt(); i < size.width.toInt(); i += 55) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset((i + size.height).toDouble(), size.height),
        paint,
      );
    }

    // Draw tech dots
    final dotPaint = Paint()
      ..color = Colors.purple.withOpacity(0.03)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 18; i++) {
      final x = (i * 85) % size.width;
      final y = (i * 125) % size.height;
      canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
