import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Techy Background Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: PrivacyTechPatternPainter(),
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
                            Colors.cyan.withOpacity(0.8),
                            Colors.cyan,
                            Theme.of(context).primaryColor.withOpacity(0.6),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withOpacity(0.4),
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
                                  Icons.privacy_tip_outlined,
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
                                      'Privacy Policy',
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
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Last updated: February 20, 2026',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Privacy Sections
                    _buildSection(
                      '1. Information We Collect',
                      '1.1 Account Information: When you create an account, we collect your email address, display name, and gender preferences.\n1.2 Usage Data: We collect information about how you use our service, including chatbot creation and interaction patterns.\n1.3 Technical Data: We automatically collect certain technical information when you visit our service, including IP address, browser type, and device information.',
                    ),
                    _buildSection(
                      '2. How We Use Your Information',
                      '2.1 Service Provision: We use your information to provide, maintain, and improve our chatbot building service.\n2.2 Personalization: We use your preferences to personalize your experience.\n2.3 Communication: We may send you service-related communications and updates.\n2.4 Analytics: We analyze usage patterns to improve our service.',
                    ),
                    _buildSection(
                      '3. Information Sharing',
                      '3.1 We do not sell, trade, or otherwise transfer your personal information to third parties.\n3.2 Service Providers: We may share information with trusted service providers who assist in operating our service.\n3.3 Legal Requirements: We may disclose information when required by law or to protect our rights.\n3.4 Business Transfers: Information may be transferred in connection with mergers, acquisitions, or asset sales.',
                    ),
                    _buildSection(
                      '4. Data Security',
                      '4.1 Encryption: We use industry-standard encryption to protect your data.\n4.2 Access Controls: We implement appropriate technical and organizational measures to protect your information.\n4.3 Regular Audits: We regularly review our security practices and systems.',
                    ),
                    _buildSection(
                      '5. Data Retention',
                      '5.1 User Accounts: We retain your account information while your account is active.\n5.2 Chat History: We retain your chat history and bot configurations until you delete them.\n5.3 Deletion: You may request deletion of your account and associated data at any time.',
                    ),
                    _buildSection(
                      '6. Your Rights',
                      '6.1 Access: You have the right to access and update your personal information.\n6.2 Portability: You can request a copy of your data in a structured, machine-readable format.\n6.3 Deletion: You have the right to request deletion of your personal information.\n6.4 Correction: You can request correction of inaccurate personal information.',
                    ),
                    _buildSection(
                      '7. Cookies and Tracking',
                      '7.1 Essential Cookies: We use essential cookies to provide basic functionality and security.\n7.2 Analytics: We use analytics tools to understand how our service is used.\n7.3 Preferences: You can control cookie settings through your browser preferences.',
                    ),
                    _buildSection(
                      '8. Children\'s Privacy',
                      'Our service is not intended for children under 13. We do not knowingly collect personal information from children under 13.',
                    ),
                    _buildSection(
                      '9. International Data Transfers',
                      'Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place.',
                    ),
                    _buildSection(
                      '10. Changes to This Policy',
                      'We may update this privacy policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last updated" date.',
                    ),
                    _buildSection(
                      '11. Contact Us',
                      'If you have any questions about this Privacy Policy, please contact us:\nEmail: privacy@myva.com\nWebsite: www.myva.com',
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Footer Notice
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan.withOpacity(0.1),
                            Colors.cyan.withOpacity(0.05),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.cyan.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'By using MyVA, you acknowledge that you have read and understood this Privacy Policy.',
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

// Custom painter for privacy screen tech pattern
class PrivacyTechPatternPainter extends CustomPainter {
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
    
    for (int i = 0; i < 22; i++) {
      final x = (i * 80) % size.width;
      final y = (i * 120) % size.height;
      canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
