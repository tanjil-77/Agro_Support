import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool isFarmer = true;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Create user with Firebase Auth
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );

      // Save extra info to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': _phoneController.text.trim(),
            'location': _locationController.text.trim(),
            'role': isFarmer ? 'farmer' : 'buyer',
            'createdAt': FieldValue.serverTimestamp(),
          });

      if (!mounted) return;
      // Stop loading BEFORE navigating
      setState(() => _isLoading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginPage(registrationSuccess: true),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'এই ইমেইলটি আগে থেকে ব্যবহার হচ্ছে।';
          break;
        case 'weak-password':
          message = 'পাসওয়ার্ড কমপক্ষে ৬ অক্ষরের হতে হবে।';
          break;
        case 'invalid-email':
          message = 'ইমেইল ঠিকানা সঠিক নয়।';
          break;
        default:
          message = 'রেজিস্ট্রেশন ব্যর্থ হয়েছে: ${e.message}';
      }
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
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
          content: Text('কিছু একটা সমস্যা হয়েছে: $e'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
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
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen background image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1920&q=80',
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
                    const Color(0xFFFFC107).withOpacity(0.25),
                    const Color(0xFF1B5E20).withOpacity(0.55),
                  ],
                  stops: const [0.0, 0.35, 0.65, 1.0],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 100,
                  vertical: isMobile ? 20 : 40,
                ),
                child: Center(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
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
                              color: const Color(0xFF27A745).withOpacity(0.3),
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
                          padding: EdgeInsets.all(isMobile ? 24 : 40),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildHeader(isMobile),
                                SizedBox(height: isMobile ? 24 : 32),
                                _buildUserTypeToggle(isMobile),
                                SizedBox(height: isMobile ? 20 : 28),
                                _buildInputFields(isMobile),
                                SizedBox(height: isMobile ? 24 : 32),
                                _buildRegisterButton(isMobile),
                                SizedBox(height: isMobile ? 16 : 20),
                                _buildLoginLink(isMobile),
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
        SizedBox(height: isMobile ? 16 : 20),
        Text(
          'নতুন অ্যাকাউন্ট তৈরি করুন',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: isMobile ? 22 : 28,
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
        SizedBox(height: isMobile ? 6 : 8),
        Text(
          'Smart AgroSupport System',
          style: TextStyle(
            fontSize: isMobile ? 13 : 15,
            color: Colors.white.withOpacity(0.85),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildUserTypeToggle(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.person_outline,
              color: Colors.white,
              size: isMobile ? 18 : 20,
            ),
            const SizedBox(width: 8),
            Text(
              'আপনি কে?',
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
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isFarmer = true;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 14),
                    decoration: BoxDecoration(
                      color: isFarmer
                          ? const Color(0xFF27A745)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.agriculture,
                          color: isFarmer ? Colors.white : Colors.black54,
                          size: isMobile ? 20 : 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'কৃষক',
                          style: TextStyle(
                            color: isFarmer ? Colors.white : Colors.black54,
                            fontSize: isMobile ? 15 : 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 1.5,
                height: isMobile ? 40 : 44,
                color: Colors.white.withOpacity(0.4),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isFarmer = false;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 12 : 14),
                    decoration: BoxDecoration(
                      color: !isFarmer
                          ? const Color(0xFFFFC107)
                          : Colors.transparent,
                      borderRadius: const BorderRadius.horizontal(
                        right: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: !isFarmer ? Colors.black87 : Colors.black54,
                          size: isMobile ? 20 : 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'ক্রেতা',
                          style: TextStyle(
                            color: !isFarmer ? Colors.black87 : Colors.black54,
                            fontSize: isMobile ? 15 : 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputFields(bool isMobile) {
    return Column(
      children: [
        _buildTextField(
          controller: _nameController,
          label: 'নাম',
          icon: Icons.person,
          isMobile: isMobile,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'নাম লিখুন' : null,
        ),
        SizedBox(height: isMobile ? 14 : 16),
        _buildTextField(
          controller: _emailController,
          label: 'ইমেইল',
          icon: Icons.email,
          keyboardType: TextInputType.emailAddress,
          isMobile: isMobile,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'ইমেইল লিখুন';
            if (!v.contains('@')) return 'সঠিক ইমেইল লিখুন';
            return null;
          },
        ),
        SizedBox(height: isMobile ? 14 : 16),
        _buildTextField(
          controller: _phoneController,
          label: 'মোবাইল নম্বর',
          icon: Icons.phone,
          keyboardType: TextInputType.phone,
          hint: '01XXXXXXXXX',
          isMobile: isMobile,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'মোবাইল নম্বর লিখুন';
            if (v.trim().length < 11) return 'সঠিক মোবাইল নম্বর লিখুন';
            return null;
          },
        ),
        SizedBox(height: isMobile ? 14 : 16),
        _buildTextField(
          controller: _locationController,
          label: 'এলাকা/জেলা',
          icon: Icons.location_on,
          hint: 'যেমন: ঢাকা, চট্টগ্রাম',
          isMobile: isMobile,
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'এলাকা লিখুন' : null,
        ),
        SizedBox(height: isMobile ? 14 : 16),
        _buildTextField(
          controller: _passwordController,
          label: 'পাসওয়ার্ড',
          icon: Icons.lock,
          isPassword: true,
          isPasswordVisible: isPasswordVisible,
          onTogglePassword: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
          isMobile: isMobile,
          validator: (v) {
            if (v == null || v.isEmpty) return 'পাসওয়ার্ড লিখুন';
            if (v.length < 6) return 'কমপক্ষে ৬ অক্ষর দিন';
            return null;
          },
        ),
        SizedBox(height: isMobile ? 14 : 16),
        _buildTextField(
          controller: _confirmPasswordController,
          label: 'পাসওয়ার্ড নিশ্চিত করুন',
          icon: Icons.lock_outline,
          isPassword: true,
          isPasswordVisible: isConfirmPasswordVisible,
          onTogglePassword: () {
            setState(() {
              isConfirmPasswordVisible = !isConfirmPasswordVisible;
            });
          },
          isMobile: isMobile,
          validator: (v) {
            if (v == null || v.isEmpty) return 'পাসওয়ার্ড নিশ্চিত করুন';
            if (v != _passwordController.text) return 'পাসওয়ার্ড মিলছে না';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? hint,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
    required bool isMobile,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white, size: isMobile ? 16 : 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 4),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
              fontSize: isMobile ? 14 : 15,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: isMobile ? 13 : 14,
              ),
              errorStyle: TextStyle(
                color: const Color(0xFFFFE082),
                fontSize: isMobile ? 11 : 12,
                fontWeight: FontWeight.w600,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: isMobile ? 14 : 16,
                vertical: isMobile ? 12 : 14,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white.withOpacity(0.8),
                        size: isMobile ? 20 : 22,
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

  Widget _buildRegisterButton(bool isMobile) {
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
                colors: [Color(0xFFFFC107), Color(0xFFFFB300)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFC107).withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: isMobile ? 14 : 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.black87,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_add,
                          color: Colors.black87,
                          size: isMobile ? 20 : 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'রেজিস্টার করুন',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
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

  Widget _buildLoginLink(bool isMobile) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'ইতিমধ্যে অ্যাকাউন্ট আছে? ',
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                color: Colors.white.withOpacity(0.85),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
              child: Text(
                'লগইন করুন',
                style: TextStyle(
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFFC107),
                  decoration: TextDecoration.underline,
                  decorationColor: const Color(0xFFFFC107),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isMobile ? 12 : 16),
        GestureDetector(
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
                  fontSize: isMobile ? 13 : 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
