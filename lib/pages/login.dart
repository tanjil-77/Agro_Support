import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'register.dart';
import 'farmer/farmer_dashboard.dart';
import 'buyer/buyer_dashboard.dart';

class LoginPage extends StatefulWidget {
  final bool registrationSuccess;
  const LoginPage({Key? key, this.registrationSuccess = false})
    : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool isPasswordVisible = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _emailOrPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _animationController.forward();

    if (widget.registrationSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'রেজিস্ট্রেশন সফল হয়েছে! এখন লগইন করুন।',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF27A745),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailOrPhoneController.text.trim(),
        password: _passwordController.text,
      );
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get();
      if (!mounted) return;
      setState(() => _isLoading = false);
      final role = doc.data()?['role'] ?? 'buyer';
      final name = doc.data()?['name'] ?? '';
      if (role == 'farmer') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                FarmerDashboard(uid: credential.user!.uid, name: name),
          ),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) =>
                BuyerDashboard(uid: credential.user!.uid, name: name),
          ),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      String msg;
      switch (e.code) {
        case 'user-not-found':
          msg = 'এই ইমেইলে কোনো অ্যাকাউন্ট নেই।';
          break;
        case 'wrong-password':
          msg = 'পাসওয়ার্ড ভুল হয়েছে।';
          break;
        case 'invalid-email':
          msg = 'ইমেইল ঠিকানা সঠিক নয়।';
          break;
        case 'user-disabled':
          msg = 'এই অ্যাকাউন্ট নিষ্ক্রিয় করা হয়েছে।';
          break;
        default:
          msg = 'লগইন ব্যর্থ হয়েছে। আবার চেষ্টা করুন।';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('কিছু একটা সমস্যা হয়েছে। আবার চেষ্টা করুন।'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailOrPhoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFF1B5E20),
      body: Stack(
        children: [
          // Full-screen background image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1586771107445-d3ca888129ff?auto=format&fit=crop&w=1920&q=80',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1B5E20),
                      Color(0xFF2E7D32),
                      Color(0xFF388E3C),
                    ],
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1B5E20),
                      Color(0xFF2E7D32),
                      Color(0xFF388E3C),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFF1B5E20).withOpacity(0.55),
                    const Color(0xFF2E7D32).withOpacity(0.40),
                    const Color(0xFFFFC107).withOpacity(0.20),
                    const Color(0xFF1B5E20).withOpacity(0.55),
                  ],
                  stops: const [0.0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
          ),

          // Main content
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: screenHeight),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 20 : 100,
                      vertical: isMobile ? 40 : 60,
                    ),
                    child: Center(
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: SlideTransition(
                          position: _slideAnimation,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 550),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 40,
                                  spreadRadius: 2,
                                ),
                                BoxShadow(
                                  color: const Color(
                                    0xFF27A745,
                                  ).withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 1,
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.45),
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(isMobile ? 28 : 40),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _buildHeader(isMobile),
                                    SizedBox(height: isMobile ? 32 : 40),
                                    _buildInputFields(isMobile),
                                    SizedBox(height: isMobile ? 28 : 36),
                                    _buildLoginButton(isMobile),
                                    SizedBox(height: isMobile ? 20 : 24),
                                    _buildRegisterLink(isMobile),
                                    SizedBox(height: isMobile ? 12 : 16),
                                    _buildHomeLink(isMobile),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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

  Widget _buildHeader(bool isMobile) {
    return Column(
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF27A745), Color(0xFF1B5E20)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF27A745).withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.eco,
                  color: Colors.white,
                  size: isMobile ? 48 : 56,
                ),
              ),
            );
          },
        ),
        SizedBox(height: isMobile ? 20 : 24),
        Text(
          'লগইন করুন',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 26 : 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? 8 : 10),
        Text(
          'Smart AgroSupport System',
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: Colors.white.withOpacity(0.85),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInputFields(bool isMobile) {
    return Column(
      children: [
        _buildTextField(
          controller: _emailOrPhoneController,
          label: 'ইমেইল',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'ইমেইল দিন';
            if (!v.contains('@')) return 'সঠিক ইমেইল দিন';
            return null;
          },
          isMobile: isMobile,
        ),
        SizedBox(height: isMobile ? 18 : 22),
        _buildTextField(
          controller: _passwordController,
          label: 'পাসওয়ার্ড',
          icon: Icons.lock,
          isPassword: true,
          isPasswordVisible: isPasswordVisible,
          validator: (v) {
            if (v == null || v.isEmpty) return 'পাসওয়ার্ড দিন';
            if (v.length < 6) return 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষর হতে হবে';
            return null;
          },
          onTogglePassword: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          isMobile: isMobile,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    String? Function(String?)? validator,
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: isMobile ? 18 : 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 4),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.22),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isPassword && !isPasswordVisible,
            validator: validator,
            style: TextStyle(
              fontSize: isMobile ? 15 : 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 18,
                vertical: isMobile ? 14 : 16,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.8),
                        size: isMobile ? 22 : 24,
                      ),
                      onPressed: onTogglePassword,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(bool isMobile) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 900),
      tween: Tween(begin: 0.9, end: 1.0),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF27A745), Color(0xFF1B5E20)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF27A745).withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: isMobile ? 15 : 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.login,
                          color: Colors.white,
                          size: isMobile ? 22 : 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'লগইন করুন',
                          style: TextStyle(
                            fontSize: isMobile ? 17 : 19,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRegisterLink(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'নতুন ব্যবহারকারী? ',
          style: TextStyle(
            fontSize: isMobile ? 14 : 15,
            color: Colors.white.withOpacity(0.85),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const RegisterPage()),
              (route) => false,
            );
          },
          child: Text(
            'রেজিস্টার করুন',
            style: TextStyle(
              fontSize: isMobile ? 14 : 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFFC107),
              decoration: TextDecoration.underline,
              decorationColor: const Color(0xFFFFC107),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHomeLink(bool isMobile) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.home, color: Colors.white, size: isMobile ? 18 : 20),
          const SizedBox(width: 6),
          Text(
            'হোম ফিরে যান',
            style: TextStyle(
              fontSize: isMobile ? 14 : 15,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
