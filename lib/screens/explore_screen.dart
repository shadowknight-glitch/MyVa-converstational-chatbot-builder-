import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bot_model.dart';
import 'chat_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  List<BotModel> get _templateBots => [
    BotModel(
      id: 'template_1',
      name: 'Customer Support',
      description: 'Handle customer inquiries and provide support',
      purpose: 'I am a customer support assistant. I help customers with their questions, resolve issues, and provide information about products and services.',
      category: 'Customer Support',
      createdAt: null,
      status: 'template',
      userId: '',
      isPublic: true,
    ),
    BotModel(
      id: 'template_2',
      name: 'Sales Assistant',
      description: 'Help with product recommendations and sales',
      purpose: 'I am a sales assistant. I help customers find the right products, answer questions about features, and guide them through the purchasing process.',
      category: 'Sales Assistant',
      createdAt: null,
      status: 'template',
      userId: '',
      isPublic: true,
    ),
    BotModel(
      id: 'template_3',
      name: 'FAQ Bot',
      description: 'Answer frequently asked questions',
      purpose: 'I am an FAQ bot. I provide answers to commonly asked questions, help users find information quickly, and guide them to relevant resources.',
      category: 'FAQ Bot',
      createdAt: null,
      status: 'template',
      userId: '',
      isPublic: true,
    ),
    BotModel(
      id: 'template_4',
      name: 'Booking Assistant',
      description: 'Manage appointments and bookings',
      purpose: 'I am a booking assistant. I help users schedule appointments, check availability, and manage their bookings.',
      category: 'Booking Assistant',
      createdAt: null,
      status: 'template',
      userId: '',
      isPublic: true,
    ),
    BotModel(
      id: 'template_5',
      name: 'Survey Bot',
      description: 'Collect user feedback and conduct surveys',
      purpose: 'I am a survey bot. I collect user feedback, conduct surveys, and help gather insights to improve services.',
      category: 'Survey Bot',
      createdAt: null,
      status: 'template',
      userId: '',
      isPublic: true,
    ),
    BotModel(
      id: 'template_6',
      name: 'Education Bot',
      description: 'Interactive learning assistant',
      purpose: 'I am an education bot. I help with learning, explain concepts, provide educational content, and answer academic questions.',
      category: 'Education Bot',
      createdAt: null,
      status: 'template',
      userId: '',
      isPublic: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BotModel> _filterBots(List<BotModel> bots) {
    if (_searchQuery.isEmpty) return bots;
    
    return bots.where((bot) {
      final query = _searchQuery.toLowerCase();
      return bot.name.toLowerCase().contains(query) ||
             bot.description.toLowerCase().contains(query) ||
             bot.category.toLowerCase().contains(query);
    }).toList();
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
              painter: ExploreTechPatternPainter(),
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
                                Icons.explore,
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
                                    'Discover Chatbots',
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
                                    'Explore pre-built templates and community creations',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search bots by name, description, or category...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          letterSpacing: 0.3,
                        ),
                        prefixIcon: Icon(
                          Icons.search_outlined,
                          color: Colors.white.withOpacity(0.6),
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
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
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Results Count
                  if (_searchQuery.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.cyan.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Searching for "$_searchQuery"',
                        style: const TextStyle(
                          color: Colors.cyan,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Bots List
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('bots')
                          .where('isPublic', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        print('Explore Stream State: ${snapshot.connectionState}');
                        print('Explore Has Data: ${snapshot.hasData}');
                        print('Explore Has Error: ${snapshot.hasError}');
                        if (snapshot.hasError) {
                          print('Explore Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
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
                                color: Colors.cyan,
                                strokeWidth: 3,
                              ),
                            ),
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
                                  'Error loading public bots',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Showing templates only',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final publicBots = snapshot.data?.docs ?? [];
                        print('Public bots count: ${publicBots.length}');
                        
                        // Combine template bots with public bots
                        final allBots = [..._templateBots];
                        
                        // Add public bots from Firestore
                        for (var doc in publicBots) {
                          try {
                            final botData = doc.data() as Map<String, dynamic>;
                            final bot = BotModel.fromFirestore(botData, doc.id);
                            // Only add active bots (filter manually since we removed status from query)
                            if (bot.status == 'active') {
                              allBots.add(bot);
                            }
                          } catch (e) {
                            print('Error parsing bot ${doc.id}: $e');
                          }
                        }

                        // Apply search filter
                        final filteredBots = _filterBots(allBots);
                        print('Filtered bots count: ${filteredBots.length}');

                        if (filteredBots.isEmpty) {
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
                                    _searchQuery.isEmpty 
                                        ? Icons.smart_toy_outlined 
                                        : Icons.search_off_outlined,
                                    size: 50,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  _searchQuery.isEmpty 
                                      ? 'No bots available'
                                      : 'No bots found for "$_searchQuery"',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (_searchQuery.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      'Try different keywords',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filteredBots.length,
                          itemBuilder: (context, index) {
                            final bot = filteredBots[index];
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
                                    color: Colors.cyan,
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
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
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
                                  ],
                                ),
                                trailing: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.cyan.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.cyan.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.cyan,
                                    size: 20,
                                  ),
                                ),
                                onTap: () {
                                  try {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(bot: bot),
                                      ),
                                    );
                                  } catch (e) {
                                    print('Error navigating to chat: $e');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error opening bot: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
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
}

// Custom painter for explore screen tech pattern
class ExploreTechPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw diagonal lines
    for (int i = -size.height.toInt(); i < size.width.toInt(); i += 50) {
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
    
    for (int i = 0; i < 20; i++) {
      final x = (i * 70) % size.width;
      final y = (i * 100) % size.height;
      canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
