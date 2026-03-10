import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/bot_model.dart';
import 'edit_bot_screen.dart';
import 'chat_screen.dart';
import 'dashboard_screen.dart';

class MyBotsScreen extends StatefulWidget {
  const MyBotsScreen({super.key});

  @override
  State<MyBotsScreen> createState() => _MyBotsScreenState();
}

class _MyBotsScreenState extends State<MyBotsScreen> {
  final User? _user = FirebaseAuth.instance.currentUser;
  late Stream<QuerySnapshot> _botsStream;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    print('My Bots Screen: initState() - User: ${_user?.uid}');
    
    try {
      // Create a more reliable stream that waits for auth state
      _botsStream = _createBotsStream();
      
      // Listen to auth state changes
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (mounted) {
          setState(() {
            print('My Bots: Auth state changed, updating stream. User: ${user?.uid}');
            _botsStream = _createBotsStream();
          });
        }
      });
    } catch (e) {
      print('My Bots: Error in initState: $e');
      _botsStream = Stream.empty();
    }
  }

  Future<void> _refreshBots() async {
    setState(() {
      _isRefreshing = true;
    });
    
    // Force refresh by recreating the stream
    setState(() {
      _botsStream = _createBotsStream();
    });
    
    // Wait a moment for the refresh to complete
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (mounted) {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  Stream<QuerySnapshot> _createBotsStream() {
    try {
      if (_user == null) {
        print('My Bots: No user, returning empty stream');
        return Stream.empty();
      }
      
      print('My Bots: Creating stream for user ${_user!.uid}');
      return FirebaseFirestore.instance
          .collection('bots')
          .where('userId', isEqualTo: _user!.uid)
          .snapshots()
          .map((snapshot) {
            print('My Bots Raw Snapshot: ${snapshot.docs.length} documents');
            return snapshot;
          })
          .handleError((error) {
            print('My Bots Stream Error: $error');
            return <QuerySnapshot>[]; // Return empty list on error
          });
    } catch (e) {
      print('My Bots: Error creating stream: $e');
      return Stream.empty();
    }
  }

  Future<void> _deleteBot(String botId) async {
    bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Delete Bot',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to delete this bot? This action cannot be undone.',
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
      await FirebaseFirestore.instance.collection('bots').doc(botId).delete();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Bot deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting bot: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
              painter: MyBotsTechPatternPainter(),
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
                          Colors.cyan.withOpacity(0.8),
                          Colors.cyan,
                          Theme.of(context).primaryColor.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.4),
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
                            // Back Button
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const DashboardScreen(),
                                  ),
                                );
                              },
                              child: Container(
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
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
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
                                Icons.smart_toy,
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
                                    'My Bots',
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
                                    'Manage your created chatbots',
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
                                onPressed: _isRefreshing ? null : _refreshBots,
                                tooltip: 'Refresh bots',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Bots List
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _botsStream,
                      builder: (context, snapshot) {
                        print('=== MY BOTS SCREEN DEBUG ===');
                        print('Current User ID: ${_user?.uid}');
                        print('My Bots Stream State: ${snapshot.connectionState}');
                        print('My Bots Has Data: ${snapshot.hasData}');
                        print('My Bots Has Error: ${snapshot.hasError}');
                        if (snapshot.hasData) {
                          print('Number of bots found: ${snapshot.data?.docs.length}');
                          for (int i = 0; i < (snapshot.data?.docs.length ?? 0); i++) {
                            final botData = snapshot.data!.docs[i].data() as Map<String, dynamic>;
                            print('Bot Item $i: ${botData['name']} (User: ${botData['userId']})');
                          }
                        }
                        if (snapshot.hasError) {
                          print('My Bots Error: ${snapshot.error}');
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
                                          Colors.cyan.withOpacity(0.2),
                                          Colors.cyan.withOpacity(0.1),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: Colors.cyan.withOpacity(0.3),
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
                                return _buildEmptyState('No bots here to show', Icons.smart_toy_outlined);
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
                                  'Error loading bots',
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

                        final bots = snapshot.data?.docs ?? [];

                        if (bots.isEmpty) {
                          return _buildEmptyState('No bots here to show', Icons.smart_toy_outlined);
                        }

                        return ListView.builder(
                          itemCount: bots.length,
                          itemBuilder: (context, index) {
                            final botDoc = bots[index];
                            print('Processing bot document: ${botDoc.id}');
                            
                            try {
                              final bot = BotModel.fromFirestore(
                                botDoc.data() as Map<String, dynamic>,
                                botDoc.id,
                              );
                              print('My Bots: Successfully parsed bot: ${bot.name}');
                              print('My Bots: Bot ID: ${bot.id}');
                              print('My Bots: Bot description: ${bot.description}');
                              print('My Bots: Bot purpose: ${bot.purpose}');
                              print('My Bots: Bot category: ${bot.category}');
                              print('My Bots: Bot isPublic: ${bot.isPublic}');
                              print('My Bots: Bot userId: ${bot.userId}');
                              print('My Bots: Bot createdAt: ${bot.createdAt}');
                              
                              // Check if bot has all required fields
                              if (bot.id.isEmpty) {
                                print('My Bots: ERROR - Bot ID is empty!');
                              }
                              if (bot.name.isEmpty) {
                                print('My Bots: ERROR - Bot name is empty!');
                              }
                              
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
                                        Colors.cyan.withOpacity(0.2),
                                        Theme.of(context).primaryColor.withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.cyan.withOpacity(0.3),
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
                                  bot.name,
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
                                      bot.description,
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
                                            bot.category,
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
                                            color: bot.status == 'active' 
                                                ? Colors.green.withOpacity(0.2)
                                                : Colors.orange.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(12),
                                            border: Border.all(
                                              color: bot.status == 'active' 
                                                  ? Colors.green.withOpacity(0.3)
                                                  : Colors.orange.withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: Text(
                                            bot.status == 'active' ? 'Active' : 'Inactive',
                                            style: TextStyle(
                                              color: bot.status == 'active' 
                                                  ? Colors.green
                                                  : Colors.orange,
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
                                      switch (value) {
                                        case 'chat':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ChatScreen(bot: bot),
                                            ),
                                          );
                                          break;
                                        case 'edit':
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                print('My Bots: About to navigate to EditBotScreen');
                                                print('My Bots: Bot object is null: ${bot == null}');
                                                if (bot == null) {
                                                  print('My Bots: ERROR - Bot is null before navigation!');
                                                  return const Scaffold(
                                                    body: Center(
                                                      child: Text('Error: Bot data is null'),
                                                    ),
                                                  );
                                                }
                                                print('My Bots: Navigating to EditBotScreen with bot: ${bot.name} (${bot.id})');
                                                return EditBotScreen(bot: bot);
                                              },
                                            ),
                                          );
                                          break;
                                        case 'delete':
                                          _deleteBot(bot.id);
                                          break;
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      const PopupMenuItem(
                                        value: 'chat',
                                        child: Row(
                                          children: [
                                            Icon(Icons.chat, size: 20, color: Colors.cyan),
                                            SizedBox(width: 12),
                                            Text('Chat'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Row(
                                          children: [
                                            Icon(Icons.edit, size: 20, color: Colors.cyan),
                                            SizedBox(width: 12),
                                            Text('Edit'),
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
                                      builder: (context) {
                                        print('My Bots: About to navigate to EditBotScreen (tap navigation)');
                                        print('My Bots: Bot object is null: ${bot == null}');
                                        if (bot == null) {
                                          print('My Bots: ERROR - Bot is null before navigation!');
                                          return const Scaffold(
                                            body: Center(
                                              child: Text('Error: Bot data is null'),
                                            ),
                                          );
                                        }
                                        print('My Bots: Navigating to EditBotScreen with bot: ${bot.name} (${bot.id})');
                                        return EditBotScreen(bot: bot);
                                      },
                                    ),
                                  );
                                },
                              ),
                            );
                            } catch (e) {
                              print('Error parsing bot document: $e');
                              return Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(20),
                                  leading: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.red.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.error_outline,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                  title: const Text(
                                    'Error loading bot',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.red,
                                    ),
                                  ),
                                  subtitle: const Text(
                                    'Bot data could not be parsed',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              );
                            }
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
}

// Custom painter for my bots screen tech pattern
class MyBotsTechPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw diagonal lines
    for (int i = -size.height.toInt(); i < size.width.toInt(); i += 45) {
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
    
    for (int i = 0; i < 22; i++) {
      final x = (i * 75) % size.width;
      final y = (i * 115) % size.height;
      canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
