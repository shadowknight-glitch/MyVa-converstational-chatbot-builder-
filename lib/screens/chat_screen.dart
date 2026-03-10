import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../models/bot_model.dart';
import '../models/chat_history_model.dart';
import '../services/chat_history_service.dart';

class ChatScreen extends StatefulWidget {
  final BotModel? bot;
  final ChatHistoryModel? existingChat;
  
  const ChatScreen({super.key, this.bot, this.existingChat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  List<Map<String, dynamic>> _messages = [];
  ChatHistoryModel? _chatHistory;
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    if (widget.existingChat != null) {
      // Load existing chat history
      setState(() {
        _chatHistory = widget.existingChat;
        _messages = List.from(widget.existingChat!.messages);
      });
    } else {
      // Start new chat
      _addInitialMessages();
      await _createNewChatHistory();
    }
  }

  Future<void> _createNewChatHistory() async {
    if (_user == null || widget.bot == null) return;

    final chatHistory = ChatHistoryModel(
      id: '${_user!.uid}_${widget.bot!.id}_${DateTime.now().millisecondsSinceEpoch}',
      botId: widget.bot!.id,
      botName: widget.bot!.name,
      botDescription: widget.bot!.description,
      botCategory: widget.bot!.category,
      userId: _user!.uid,
      messages: _messages,
      lastMessageTime: DateTime.now(),
      createdAt: DateTime.now(),
    );

    setState(() {
      _chatHistory = chatHistory;
    });

    try {
      await ChatHistoryService.saveChatHistory(chatHistory);
    } catch (e) {
      // Handle error silently for now
    }
  }

  void _addInitialMessages() {
    String botName = widget.bot?.name ?? 'Customer Support Bot';
    setState(() {
      _messages = [
        {
          'text': 'Hello! I\'m $botName. How can I help you today?',
          'isUser': false,
          'timestamp': DateTime.now(),
        },
      ];
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _messageController.clear();

    final messageData = {
      'text': userMessage,
      'isUser': true,
      'timestamp': DateTime.now(),
    };

    setState(() {
      _messages.add(messageData);
      _isLoading = true;
    });

    _scrollToBottom();

    // Save user message to chat history
    if (_chatHistory != null) {
      try {
        await ChatHistoryService.addMessageToChatHistory(_chatHistory!.id, messageData);
      } catch (e) {
        // Handle error silently
      }
    }

    try {
      // Include bot context in the message
      String botPurpose = widget.bot?.purpose ?? 'I am a helpful assistant.';
      String contextualMessage = 'Bot Purpose: $botPurpose\n\nUser Message: $userMessage';
      
      // TODO: Replace with your Python backend URL
      final response = await http.post(
        Uri.parse('http://localhost:8000/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': contextualMessage}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final botResponse = responseData['response'] ?? 'I received your message but couldn\'t process it.';
        
        final botMessageData = {
          'text': botResponse,
          'isUser': false,
          'timestamp': DateTime.now(),
        };

        setState(() {
          _messages.add(botMessageData);
          _isLoading = false;
        });

        // Save bot message to chat history
        if (_chatHistory != null) {
          try {
            await ChatHistoryService.addMessageToChatHistory(_chatHistory!.id, botMessageData);
          } catch (e) {
            // Handle error silently
          }
        }

        _scrollToBottom();
      } else {
        // Handle error response
        final botMessageData = {
          'text': 'Sorry, I encountered an error. Please try again.',
          'isUser': false,
          'timestamp': DateTime.now(),
        };

        setState(() {
          _messages.add(botMessageData);
          _isLoading = false;
        });

        // Save bot message to chat history
        if (_chatHistory != null) {
          try {
            await ChatHistoryService.addMessageToChatHistory(_chatHistory!.id, botMessageData);
          } catch (e) {
            // Handle error silently
          }
        }
        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'text': 'Sorry, I encountered an error. Please try again.',
          'isUser': false,
          'timestamp': DateTime.now(),
        });
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
              painter: ChatTechPatternPainter(),
            ),
          ),
          
          // Main Content
          Column(
            children: [
              // Bot Profile Header
              SafeArea(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
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
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.white.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.smart_toy,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.bot?.name ?? widget.existingChat?.botName ?? 'Chat Bot',
                              style: TextStyle(
                                fontSize: 20,
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
                              widget.bot?.description ?? widget.existingChat?.botDescription ?? 'AI Assistant',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 14,
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
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Messages Area
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && _isLoading) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.cyan.withOpacity(0.2),
                                    Colors.cyan.withOpacity(0.1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.cyan.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const CircularProgressIndicator(
                                color: Colors.cyan,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                        );
                      }

                      final message = _messages[index];
                      final isUser = message['isUser'] as bool;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: isUser
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isUser) ...[
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.cyan.withOpacity(0.2),
                                      Theme.of(context).primaryColor.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.cyan.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.smart_toy_outlined,
                                  color: Colors.cyan,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Flexible(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                decoration: BoxDecoration(
                                  gradient: isUser
                                      ? LinearGradient(
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            Theme.of(context).primaryColor.withOpacity(0.8),
                                          ],
                                        )
                                      : LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.1),
                                            Colors.white.withOpacity(0.05),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: isUser
                                      ? null
                                      : Border.all(
                                          color: Colors.white.withOpacity(0.2),
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
                                child: Text(
                                  message['text'] as String,
                                  style: TextStyle(
                                    color: isUser ? Colors.white : Colors.white.withOpacity(0.9),
                                    fontSize: 16,
                                    height: 1.4,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                            if (isUser) ...[
                              const SizedBox(width: 12),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Message Input
              Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 4,
                      blurRadius: 20,
                      offset: const Offset(0, -8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            letterSpacing: 0.3,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 16,
                          ),
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan,
                            Theme.of(context).primaryColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.4),
                            spreadRadius: 4,
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: _sendMessage,
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for chat screen tech pattern
class ChatTechPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw diagonal lines
    for (int i = -size.height.toInt(); i < size.width.toInt(); i += 60) {
      canvas.drawLine(
        Offset(i.toDouble(), 0),
        Offset((i + size.height).toDouble(), size.height),
        paint,
      );
    }

    // Draw tech dots
    final dotPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.03)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 25; i++) {
      final x = (i * 90) % size.width;
      final y = (i * 130) % size.height;
      canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
