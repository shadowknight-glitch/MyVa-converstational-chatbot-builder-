import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatefulWidget {
  const TermsOfServiceScreen({super.key});

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Techy Background Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: TermsTechPatternPainter(),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                padding: const EdgeInsets.all(24),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.8),
                            Theme.of(context).primaryColor,
                            Colors.cyan.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).primaryColor.withOpacity(0.4),
                            spreadRadius: 4,
                            blurRadius: 15,
                            offset: const Offset(0, 6),
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
                                  Icons.description_outlined,
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
                                      'Terms of Service',
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
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Last Updated
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
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
                        'Last updated: February 20, 2026',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.cyan,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Terms Sections
                    _buildSection(
                      '1. Acceptance of Terms',
                      'By accessing and using MyVA Chatbot Builder ("the Service"), you accept and agree to be bound by the terms and provision of this agreement.',
                    ),
                    _buildSection(
                      '2. Description of Service',
                      'MyVA is a no-code platform that allows users to create, customize, and deploy AI-powered chatbots using our web-based interface and backend services.',
                    ),
                    _buildSection(
                      '3. User Accounts',
                      '3.1 You must provide accurate and complete information when creating an account.\n3.2 You are responsible for safeguarding your account credentials.\n3.3 You must be at least 13 years old to use this service.',
                    ),
                    _buildSection(
                      '4. Acceptable Use',
                      'You agree not to:\n4.1 Use the service for any illegal or unauthorized purpose\n4.2 Create chatbots that violate applicable laws or regulations\n4.3 Generate harmful, offensive, or inappropriate content\n4.4 Attempt to gain unauthorized access to our systems',
                    ),
                    _buildSection(
                      '5. Intellectual Property',
                      '5.1 The service and its original content are owned by MyVA and are protected by intellectual property laws.\n5.2 You retain ownership of the chatbots you create, but grant us a license to provide the service.\n5.3 You may not use our trademarks without prior written consent.',
                    ),
                    _buildSection(
                      '6. Privacy and Data Protection',
                      'Your privacy is important to us. Please review our Privacy Policy, which also governs your use of the Service, to understand our practices.',
                    ),
                    _buildSection(
                      '7. Service Availability',
                      '7.1 We strive to maintain high service availability but do not guarantee uninterrupted access.\n7.2 We may temporarily suspend or permanently terminate the service for maintenance or other reasons.',
                    ),
                    _buildSection(
                      '8. Limitation of Liability',
                      'To the maximum extent permitted by law, MyVA shall not be liable for any indirect, incidental, special, or consequential damages resulting from your use of the service.',
                    ),
                    _buildSection(
                      '9. Termination',
                      'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including if you breach the Terms.',
                    ),
                    _buildSection(
                      '10. Changes to Terms',
                      'We reserve the right to modify these terms at any time. Changes will be effective immediately upon posting.',
                    ),
                    _buildSection(
                      '11. Contact Information',
                      'If you have any questions about these Terms, please contact us at:\nEmail: support@myva.com\nWebsite: www.myva.com',
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Footer Notice
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.1),
                            Theme.of(context).primaryColor.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'By continuing to use MyVA, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.03),
            Colors.white.withOpacity(0.01),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for terms screen tech pattern
class TermsTechPatternPainter extends CustomPainter {
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
      ..color = Colors.purple.withOpacity(0.03)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 22; i++) {
      final x = (i * 80) % size.width;
      final y = (i * 120) % size.height;
      canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
