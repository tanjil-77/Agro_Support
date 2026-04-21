import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'app_settings.dart';
import 'myabout.dart';
import 'register.dart';
import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return ValueListenableBuilder<AppSettingsData>(
      valueListenable: AppSettingsStore.instance,
      builder: (context, settings, _) {
        final isBangla = settings.selectedLanguage == 'বাংলা';
        return Scaffold(
          body: SafeArea(
            top: false,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?auto=format&fit=crop&w=1920&q=80',
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
                Positioned.fill(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xCC1B5E20),
                          Color(0xAA2E7D32),
                          Color(0x882E7D32),
                          Color(0xBB1B5E20),
                        ],
                        stops: [0.0, 0.3, 0.7, 1.0],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).padding.top,
                      color: Colors.black.withOpacity(0.25),
                    ),
                    _buildHeader(context, isMobile, isBangla),
                    Expanded(
                      child: SingleChildScrollView(
                        child: _buildHeroSection(
                          context,
                          isMobile,
                          screenWidth,
                          screenHeight,
                          isBangla,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile, bool isBangla) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF27A745), const Color(0xFF1B5E20)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
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
          // Logo with better styling
          Row(
            children: [
              Container(
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
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    isBangla ? 'সাপোর্ট' : 'Support',
                    style: TextStyle(
                      color: const Color(0xFFFFC107),
                      fontSize: isMobile ? 12 : 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Settings Icon
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AppSettingsPage()),
                );
              },
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: isMobile ? 22 : 26,
              ),
              tooltip: isBangla ? 'সেটিংস' : 'Settings',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    bool isMobile,
    double screenWidth,
    double screenHeight,
    bool isBangla,
  ) {
    return Container(
      width: screenWidth,
      constraints: BoxConstraints(minHeight: screenHeight * 1.2),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 20 : 60,
            vertical: isMobile ? 50 : 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Decorative top element
              Container(
                width: 60,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFC107),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              SizedBox(height: isMobile ? 20 : 32),

              // Main Heading
              Text(
                isBangla ? 'কৃষকের সাথী' : 'Farmer Partner',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 40 : 60,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),

              SizedBox(height: isMobile ? 8 : 16),

              // Secondary Heading
              Text(
                isBangla ? 'ক্রেতার বন্ধু' : 'Buyer Friend',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isMobile ? 32 : 52,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFFFC107),
                  height: 1.1,
                  letterSpacing: -0.3,
                ),
              ),

              SizedBox(height: isMobile ? 24 : 36),

              // Subtitle with better styling
              Container(
                width: isMobile ? screenWidth - 40 : 650,
                padding: EdgeInsets.all(isMobile ? 18 : 28),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.25),
                      blurRadius: 24,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: const Color(0xFFFFC107).withOpacity(0.15),
                      blurRadius: 30,
                      spreadRadius: 4,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.55),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  isBangla
                      ? 'Smart AgroSupport System — যেখানে কৃষক ও ক্রেতা সরাসরি যুক্ত হয়। এখানে পাবেন ফসলের সঠিক দাম, আবহাওয়ার নির্ভুল পরামর্শ এবং সর্বশেষ বাজার তথ্য।'
                      : 'Smart AgroSupport System connects farmers and buyers directly with crop prices, weather updates, and market insights.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 17,
                    color: Colors.white,
                    height: 1.6,
                    letterSpacing: 0.3,
                    fontWeight: FontWeight.w500,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: isMobile ? 36 : 50),

              // Action Buttons with enhanced design
              Wrap(
                spacing: isMobile ? 10 : 16,
                runSpacing: isMobile ? 12 : 16,
                alignment: WrapAlignment.center,
                children: [
                  _buildPrimaryButton(
                    label: isBangla
                        ? '👨‍🌾 কৃষক হিসেবে যোগ দিন'
                        : '👨‍🌾 Join as Farmer',
                    isMobile: isMobile,
                    onPressed: () {},
                  ),
                  _buildSecondaryButton(
                    label: isBangla
                        ? '🛒 ক্রেতা হিসেবে যোগ দিন'
                        : '🛒 Join as Buyer',
                    isMobile: isMobile,
                    onPressed: () {},
                  ),
                ],
              ),

              SizedBox(height: isMobile ? 40 : 56),

              // About Us Card
              Container(
                width: isMobile ? screenWidth - 40 : 520,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFC107).withOpacity(0.35),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFFFFC107).withOpacity(0.7),
                    width: 2,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyAboutPage(),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(20),
                    splashColor: const Color(0xFFFFC107).withOpacity(0.2),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 20 : 32,
                        vertical: isMobile ? 20 : 26,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC107).withOpacity(0.25),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFFC107).withOpacity(0.6),
                                width: 1.5,
                              ),
                            ),
                            child: Text(
                              '👥',
                              style: TextStyle(fontSize: isMobile ? 24 : 30),
                            ),
                          ),
                          SizedBox(width: isMobile ? 14 : 18),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isBangla ? 'আমাদের সম্পর্কে' : 'About Us',
                                style: TextStyle(
                                  fontSize: isMobile ? 15 : 17,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Smart AgroSupport Team',
                                style: TextStyle(
                                  fontSize: isMobile ? 11 : 12,
                                  color: const Color(0xFFFFC107),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC107).withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFFC107).withOpacity(0.5),
                                width: 1.5,
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: const Color(0xFFFFC107),
                              size: isMobile ? 16 : 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: isMobile ? 40 : 56),

              // Login & Register Buttons with enhanced styling
              Wrap(
                spacing: isMobile ? 10 : 14,
                runSpacing: isMobile ? 10 : 14,
                alignment: WrapAlignment.center,
                children: [
                  _buildLoginButton(isMobile, isBangla),
                  _buildRegisterButton(isMobile, isBangla),
                ],
              ),

              SizedBox(height: isMobile ? 30 : 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required bool isMobile,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC107), Color(0xFFFFB300)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFC107).withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 36,
            vertical: isMobile ? 14 : 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.black87,
            fontSize: isMobile ? 13 : 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required bool isMobile,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 36,
            vertical: isMobile ? 14 : 18,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 13 : 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(bool isMobile, bool isBangla) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        icon: const Icon(Icons.login_rounded),
        label: Text(isBangla ? 'লগইন' : 'Login'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: const Color(0xFF27A745),
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 22 : 28,
            vertical: isMobile ? 12 : 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(bool isMobile, bool isBangla) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFFC107), Color(0xFFFFB300)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFC107).withOpacity(0.35),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPage()),
          );
        },
        icon: const Icon(Icons.person_add_rounded),
        label: Text(isBangla ? 'রেজিস্টার' : 'Register'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 22 : 28,
            vertical: isMobile ? 12 : 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
