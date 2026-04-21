import 'package:flutter/material.dart';
import 'register.dart';

class MyAboutPage extends StatefulWidget {
  const MyAboutPage({Key? key}) : super(key: key);

  @override
  State<MyAboutPage> createState() => _MyAboutPageState();
}

class _MyAboutPageState extends State<MyAboutPage>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _servicesController;
  late AnimationController _stepsController;
  late AnimationController _joinController;
  late AnimationController _iconRotationController;

  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;

  late Animation<double> _servicesFadeAnimation;
  late Animation<Offset> _servicesSlideAnimation;

  late Animation<double> _stepsFadeAnimation;
  late Animation<Offset> _stepsSlideAnimation;

  late Animation<double> _joinScaleAnimation;
  late Animation<double> _joinFadeAnimation;

  @override
  void initState() {
    super.initState();

    // Header animations
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Services animations
    _servicesController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    _servicesFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _servicesController, curve: Curves.easeOut),
    );
    _servicesSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _servicesController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Steps animations
    _stepsController = AnimationController(
      duration: const Duration(milliseconds: 1600),
      vsync: this,
    );
    _stepsFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _stepsController, curve: Curves.easeOut));
    _stepsSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _stepsController, curve: Curves.easeOutCubic),
        );

    // Join section animations
    _joinController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _joinScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _joinController, curve: Curves.easeOutBack),
    );
    _joinFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _joinController, curve: Curves.easeOut));

    // Icon rotation animation (continuous)
    _iconRotationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat();

    // Start animations in sequence
    _startAnimations();
  }

  void _startAnimations() async {
    await _headerController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    await _servicesController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    await _stepsController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    await _joinController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    _servicesController.dispose();
    _stepsController.dispose();
    _joinController.dispose();
    _iconRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?auto=format&fit=crop&w=1920&q=80',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFF5F7FA),
                        Color(0xFFE8F5E9),
                        Color(0xFFFFF9C4),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned.fill(child: Container(color: const Color(0x1FFFFFFF))),
          SingleChildScrollView(
            child: Column(
              children: [
                FadeTransition(
                  opacity: _headerFadeAnimation,
                  child: SlideTransition(
                    position: _headerSlideAnimation,
                    child: _buildHeader(context, isMobile),
                  ),
                ),
                FadeTransition(
                  opacity: _servicesFadeAnimation,
                  child: SlideTransition(
                    position: _servicesSlideAnimation,
                    child: _buildServicesSection(isMobile, screenWidth),
                  ),
                ),
                FadeTransition(
                  opacity: _stepsFadeAnimation,
                  child: SlideTransition(
                    position: _stepsSlideAnimation,
                    child: _buildHowItWorksSection(isMobile, screenWidth),
                  ),
                ),
                FadeTransition(
                  opacity: _joinFadeAnimation,
                  child: ScaleTransition(
                    scale: _joinScaleAnimation,
                    child: _buildJoinSection(isMobile, screenWidth),
                  ),
                ),
                _buildFooter(isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF27A745), const Color(0xFF1B5E20)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: isMobile ? 14 : 18,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: _iconRotationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale:
                        1.0 +
                        (0.1 *
                            (0.5 +
                                0.5 *
                                    (1 -
                                        (_iconRotationController.value - 0.5)
                                                .abs() *
                                            2))),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.grass,
                        color: Colors.white,
                        size: isMobile ? 28 : 36,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: isMobile ? 12 : 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Smart Agro',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 14 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Support',
                    style: TextStyle(
                      color: const Color(0xFFFFC107),
                      fontSize: isMobile ? 12 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1100),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.8 + (value * 0.2),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 12 : 20,
                          vertical: isMobile ? 8 : 12,
                        ),
                      ),
                      child: Text(
                        'হোম',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 12 : 14,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicesSection(bool isMobile, double screenWidth) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: isMobile ? 40 : 60,
      ),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.10)),
      child: Column(
        children: [
          // Section Title
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 32,
              vertical: isMobile ? 12 : 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF6A1B9A), const Color(0xFF8E24AA)],
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6A1B9A).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              'আমাদের সেবাসমূহ',
              style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            'কৃষক ও ক্রেতাদের জন্য বিশেষ সুবিধা',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isMobile ? 30 : 50),

          // Services Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 4,
            crossAxisSpacing: isMobile ? 16 : 24,
            mainAxisSpacing: isMobile ? 16 : 24,
            childAspectRatio: isMobile ? 1.3 : 0.9,
            children: [
              _buildAnimatedServiceCard(
                icon: '💰',
                title: 'ফসলের দাম',
                description: 'প্রতিদিন আপডেট হওয়া ফসলের বাজার মূল্য দেখুন',
                color: const Color(0xFF27A745),
                isMobile: isMobile,
                delay: 0,
              ),
              _buildAnimatedServiceCard(
                icon: '⛅',
                title: 'আবহাওয়া পরামর্শ',
                description: 'আবহাওয়া অনুযায়ী ফসলের যত্নের পরামর্শ পান',
                color: const Color(0xFF00BCD4),
                isMobile: isMobile,
                delay: 150,
              ),
              _buildAnimatedServiceCard(
                icon: '🛒',
                title: 'মার্কেটপ্লেস',
                description: 'ফসল সরাসরি ক্রেতার কাছে বিক্রি করুন',
                color: const Color(0xFFFFC107),
                isMobile: isMobile,
                delay: 300,
              ),
              _buildAnimatedServiceCard(
                icon: '💬',
                title: 'সরাসরি যোগাযোগ',
                description: 'কৃষক ও ক্রেতা দালাল ছাড়াই যুক্ত হন',
                color: const Color(0xFFE91E63),
                isMobile: isMobile,
                delay: 450,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard({
    required String icon,
    required String title,
    required String description,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(icon, style: TextStyle(fontSize: isMobile ? 40 : 50)),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedServiceCard({
    required String icon,
    required String title,
    required String description,
    required Color color,
    required bool isMobile,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1100 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: MouseRegion(
              onEnter: (_) {},
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.76),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 1400 + delay),
                      curve: Curves.elasticOut,
                      builder: (context, iconValue, child) {
                        return Transform.scale(
                          scale: iconValue,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              icon,
                              style: TextStyle(fontSize: isMobile ? 40 : 50),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: isMobile ? 16 : 20),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                    SizedBox(height: isMobile ? 8 : 12),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 20,
                      ),
                      child: Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 14,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHowItWorksSection(bool isMobile, double screenWidth) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: isMobile ? 40 : 60,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0x66E8F5E9), const Color(0x33FFFFFF)],
        ),
      ),
      child: Column(
        children: [
          // Section Title
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 32,
              vertical: isMobile ? 12 : 16,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFF00BCD4), const Color(0xFF00ACC1)],
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00BCD4).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Text(
              'কীভাবে কাজ করে?',
              style: TextStyle(
                fontSize: isMobile ? 24 : 32,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            'মাত্র চারটি ধাপে শুরু করুন',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isMobile ? 30 : 50),

          // Steps Grid
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 1 : 4,
            crossAxisSpacing: isMobile ? 16 : 24,
            mainAxisSpacing: isMobile ? 16 : 24,
            childAspectRatio: isMobile ? 1.5 : 1,
            children: [
              _buildAnimatedStepCard(
                stepNumber: '1',
                title: 'রেজিস্টার করুন',
                description: 'কৃষক বা ক্রেতা হিসেবে বিনামূল্যে করুন',
                color: const Color(0xFF00BCD4),
                isMobile: isMobile,
                delay: 0,
              ),
              _buildAnimatedStepCard(
                stepNumber: '2',
                title: 'ফসল পোস্ট করুন',
                description: 'কৃষক আপনার ফসলের তথ্য দিন',
                color: const Color(0xFF27A745),
                isMobile: isMobile,
                delay: 150,
              ),
              _buildAnimatedStepCard(
                stepNumber: '3',
                title: 'যোগাযোগ করুন',
                description: 'ক্রেতা কৃষকের সাথে সরাসরি যোগাযোগ করুন',
                color: const Color(0xFFFFC107),
                isMobile: isMobile,
                delay: 300,
              ),
              _buildAnimatedStepCard(
                stepNumber: '4',
                title: 'লেনদেন সম্পন্ন',
                description: 'দালাল ছাড়াই ব্যবসা করুন',
                color: const Color(0xFFE91E63),
                isMobile: isMobile,
                delay: 450,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({
    required String stepNumber,
    required String title,
    required String description,
    required Color color,
    required bool isMobile,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: isMobile ? 60 : 70,
            height: isMobile ? 60 : 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.7)]),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                stepNumber,
                style: TextStyle(
                  fontSize: isMobile ? 28 : 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 18 : 20,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: isMobile ? 8 : 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStepCard({
    required String stepNumber,
    required String title,
    required String description,
    required Color color,
    required bool isMobile,
    required int delay,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 1200 + delay),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.78),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 1700 + delay),
                    curve: Curves.elasticOut,
                    builder: (context, rotateValue, child) {
                      return Transform.rotate(
                        angle: (1 - rotateValue) * 3.14 * 2,
                        child: Container(
                          width: isMobile ? 60 : 70,
                          height: isMobile ? 60 : 70,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color, color.withOpacity(0.7)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: color.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              stepNumber,
                              style: TextStyle(
                                fontSize: isMobile ? 28 : 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: isMobile ? 16 : 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: isMobile ? 8 : 12),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 20,
                    ),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: Colors.black54,
                        height: 1.4,
                      ),
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

  Widget _buildJoinSection(bool isMobile, double screenWidth) {
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: isMobile ? 50 : 80,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF2E7D32), const Color(0xFF1B5E20)],
        ),
      ),
      child: Column(
        children: [
          Text(
            'আজই যোগ দিন Smart AgroSupport-এ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 28 : 42,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            'কৃষিতে নতুন যুগের সূচনা করুন',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isMobile ? 14 : 18,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isMobile ? 30 : 40),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 1400),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.9 + (value * 0.1),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFC107),
                        const Color(0xFFFFB300),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFC107).withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ),
                      );
                    },
                    icon: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1700),
                      curve: Curves.elasticOut,
                      builder: (context, iconValue, child) {
                        return Transform.rotate(
                          angle: iconValue * 6.28,
                          child: const Icon(Icons.rocket_launch),
                        );
                      },
                    ),
                    label: Text(
                      'এখনই শুরু করুন',
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black87,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 32 : 48,
                        vertical: isMobile ? 16 : 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isMobile) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 60,
        vertical: isMobile ? 20 : 30,
      ),
      color: const Color(0xFF1B5E20),
      child: Center(
        child: Text(
          '© 2026 Smart AgroSupport - সকল অধিকার সংরক্ষিত',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: isMobile ? 12 : 14),
        ),
      ),
    );
  }
}
