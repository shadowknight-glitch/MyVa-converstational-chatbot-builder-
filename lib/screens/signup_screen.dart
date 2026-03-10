import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Passwords do not match'),
          backgroundColor: Colors.red.withOpacity(0.8),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      // Create user document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': _emailController.text.trim(),
        'displayName': _usernameController.text.trim(),
        'gender': 'other',
        'darkMode': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update Firebase Auth display name
      await userCredential.user!.updateDisplayName(_usernameController.text.trim());
      
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/dashboard');
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Signup failed'),
          backgroundColor: Colors.red.withOpacity(0.8),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Techy Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1E293B),
                  Color(0xFF334155),
                ],
              ),
            ),
            child: _buildTechPattern(),
          ),
          
          // Main Content
          SafeArea(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                             MediaQuery.of(context).padding.top - 
                             MediaQuery.of(context).padding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // App Icon and Title
                        TweenAnimationBuilder(
                          duration: const Duration(milliseconds: 800),
                          tween: Tween<double>(begin: 0, end: 1),
                          builder: (context, double value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Column(
                                children: [
                                  // App Icon
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Theme.of(context).primaryColor,
                                          Theme.of(context).primaryColor.withOpacity(0.7),
                                          Colors.cyan.withOpacity(0.6),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(context).primaryColor.withOpacity(0.4),
                                          spreadRadius: 6,
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                        BoxShadow(
                                          color: Colors.cyan.withOpacity(0.2),
                                          spreadRadius: 3,
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.person_add,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 24),
                                  
                                  // App Name
                                  Text(
                                    'MyVA',
                                    style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      shadows: [
                                        Shadow(
                                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  // Subtitle
                                  Text(
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).primaryColor,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  
                                  const SizedBox(height: 8),
                                  
                                  Text(
                                    'Join the AI chatbot revolution',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white.withOpacity(0.7),
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Form Content with Side Decorations
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Left Tech Decoration
                            Expanded(
                              flex: 1,
                              child: _buildSideDecoration('left'),
                            ),
                            
                            // Center Form Fields
                            SizedBox(
                              width: 320,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // Username Field
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                          width: 1,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _usernameController,
                                        decoration: InputDecoration(
                                          labelText: 'Username',
                                          labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.person_outline,
                                            color: Theme.of(context).primaryColor.withOpacity(0.8),
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.all(14),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a username';
                                          }
                                          if (value.length < 3) {
                                            return 'Username must be at least 3 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 12),
                                    
                                    // Email Field
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                          width: 1,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email Address',
                                          labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                            color: Theme.of(context).primaryColor.withOpacity(0.8),
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.all(14),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your email address';
                                          }
                                          if (!value.contains('@')) {
                                            return 'Please enter a valid email';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 12),
                                    
                                    // Password Field
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                          width: 1,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: Theme.of(context).primaryColor.withOpacity(0.8),
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.all(14),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter your password';
                                          }
                                          if (value.length < 6) {
                                            return 'Password must be at least 6 characters';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 12),
                                    
                                    // Confirm Password Field
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                          width: 1,
                                        ),
                                      ),
                                      child: TextFormField(
                                        controller: _confirmPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Confirm Password',
                                          labelStyle: TextStyle(
                                            color: Colors.white.withOpacity(0.7),
                                            fontWeight: FontWeight.w500,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
                                            color: Theme.of(context).primaryColor.withOpacity(0.8),
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.all(14),
                                        ),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please confirm your password';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Sign Up Button
                                    Container(
                                      height: 56,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context).primaryColor,
                                            Colors.cyan,
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(28),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context).primaryColor.withOpacity(0.4),
                                            spreadRadius: 4,
                                            blurRadius: 20,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(28),
                                          onTap: _isLoading ? null : _signup,
                                          child: Center(
                                            child: _isLoading
                                                ? const SizedBox(
                                                    width: 24,
                                                    height: 24,
                                                    child: CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 3,
                                                    ),
                                                  )
                                                : const Text(
                                                    'INITIALIZE ACCOUNT',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                      letterSpacing: 1.5,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 12),
                                    
                                    // Login Link
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Already registered? ',
                                            style: TextStyle(
                                              color: Colors.white.withOpacity(0.7),
                                              fontSize: 14,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Access System',
                                              style: TextStyle(
                                                color: Theme.of(context).primaryColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            
                            // Right Tech Decoration
                            Expanded(
                              flex: 1,
                              child: _buildSideDecoration('right'),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechPattern() {
    return Positioned.fill(
      child: CustomPaint(
        painter: SignupTechPatternPainter(),
      ),
    );
  }

  Widget _buildSideDecoration(String side) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Tech Circles
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.2),
                Colors.cyan.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Icon(
            side == 'left' ? Icons.person_add : Icons.app_registration,
            color: Colors.white.withOpacity(0.6),
            size: 20,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Tech Lines
        Container(
          width: 50,
          height: 2,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.3),
                Colors.cyan.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(1),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Tech Dots Pattern
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.4),
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
        
        const SizedBox(height: 12),
        
        // Hexagon-like decoration
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.cyan.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            side == 'left' ? Icons.how_to_reg : Icons.verified,
            color: Colors.cyan.withOpacity(0.6),
            size: 15,
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Animated Pulse Circle
        TweenAnimationBuilder(
          duration: const Duration(seconds: 2),
          tween: Tween<double>(begin: 0.8, end: 1.2),
          builder: (context, double value, child) {
            return Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(0.2 * value),
                  width: 1,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Custom painter for signup screen tech pattern
class SignupTechPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw diagonal lines
    for (double i = -size.height; i < size.width; i += 60) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }

    // Draw some tech circles
    final circlePaint = Paint()
      ..color = Colors.cyan.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    // Add some floating circles in different positions
    canvas.drawCircle(Offset(size.width * 0.15, size.height * 0.25), 45, circlePaint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.35), 25, circlePaint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.85), 40, circlePaint);
    canvas.drawCircle(Offset(size.width * 0.25, size.height * 0.75), 30, circlePaint);
    
    // Add some tech dots
    final dotPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.02)
      ..style = PaintingStyle.fill;
    
    for (int i = 0; i < 20; i++) {
      final x = (i * 50) % size.width;
      final y = (i * 80) % size.height;
      canvas.drawCircle(Offset(x.toDouble(), y.toDouble()), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
