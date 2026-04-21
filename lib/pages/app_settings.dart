import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppSettingsData {
  const AppSettingsData({
    this.notificationsEnabled = true,
    this.darkModeEnabled = false,
    this.selectedLanguage = 'বাংলা',
    this.verifiedSellersOnly = false,
    this.weatherAlertsEnabled = true,
    this.priceAlertsEnabled = true,
    this.autoLocationEnabled = true,
    this.fontScale = 1.0,
  });

  final bool notificationsEnabled;
  final bool darkModeEnabled;
  final String selectedLanguage;
  final bool verifiedSellersOnly;
  final bool weatherAlertsEnabled;
  final bool priceAlertsEnabled;
  final bool autoLocationEnabled;
  final double fontScale;

  AppSettingsData copyWith({
    bool? notificationsEnabled,
    bool? darkModeEnabled,
    String? selectedLanguage,
    bool? verifiedSellersOnly,
    bool? weatherAlertsEnabled,
    bool? priceAlertsEnabled,
    bool? autoLocationEnabled,
    double? fontScale,
  }) {
    return AppSettingsData(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      verifiedSellersOnly: verifiedSellersOnly ?? this.verifiedSellersOnly,
      weatherAlertsEnabled: weatherAlertsEnabled ?? this.weatherAlertsEnabled,
      priceAlertsEnabled: priceAlertsEnabled ?? this.priceAlertsEnabled,
      autoLocationEnabled: autoLocationEnabled ?? this.autoLocationEnabled,
      fontScale: fontScale ?? this.fontScale,
    );
  }
}

class AppSettingsStore extends ValueNotifier<AppSettingsData> {
  AppSettingsStore._() : super(const AppSettingsData());

  static final AppSettingsStore instance = AppSettingsStore._();

  static const _notificationsEnabledKey = 'settings.notificationsEnabled';
  static const _darkModeEnabledKey = 'settings.darkModeEnabled';
  static const _selectedLanguageKey = 'settings.selectedLanguage';
  static const _verifiedSellersOnlyKey = 'settings.verifiedSellersOnly';
  static const _weatherAlertsEnabledKey = 'settings.weatherAlertsEnabled';
  static const _priceAlertsEnabledKey = 'settings.priceAlertsEnabled';
  static const _autoLocationEnabledKey = 'settings.autoLocationEnabled';
  static const _fontScaleKey = 'settings.fontScale';

  static const List<String> supportedLanguages = [
    'বাংলা',
    'English',
    'हिन्दी',
    'اردو',
    'العربية',
    'Español',
    '中文',
  ];

  static Locale localeFor(String language) {
    switch (language) {
      case 'বাংলা':
        return const Locale('bn');
      case 'हिन्दी':
        return const Locale('hi');
      case 'اردو':
        return const Locale('ur');
      case 'العربية':
        return const Locale('ar');
      case 'Español':
        return const Locale('es');
      case '中文':
        return const Locale('zh');
      case 'English':
      default:
        return const Locale('en');
    }
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedFontScale = prefs.getDouble(_fontScaleKey);
    final savedLanguage = prefs.getString(_selectedLanguageKey);
    value = AppSettingsData(
      notificationsEnabled:
          prefs.getBool(_notificationsEnabledKey) ?? value.notificationsEnabled,
      darkModeEnabled:
          prefs.getBool(_darkModeEnabledKey) ?? value.darkModeEnabled,
      selectedLanguage: supportedLanguages.contains(savedLanguage)
          ? savedLanguage!
          : value.selectedLanguage,
      verifiedSellersOnly:
          prefs.getBool(_verifiedSellersOnlyKey) ?? value.verifiedSellersOnly,
      weatherAlertsEnabled:
          prefs.getBool(_weatherAlertsEnabledKey) ?? value.weatherAlertsEnabled,
      priceAlertsEnabled:
          prefs.getBool(_priceAlertsEnabledKey) ?? value.priceAlertsEnabled,
      autoLocationEnabled:
          prefs.getBool(_autoLocationEnabledKey) ?? value.autoLocationEnabled,
      fontScale: savedFontScale == null
          ? value.fontScale
          : savedFontScale.clamp(0.75, 1.8).toDouble(),
    );
  }

  Future<void> update(AppSettingsData next) async {
    value = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, next.notificationsEnabled);
    await prefs.setBool(_darkModeEnabledKey, next.darkModeEnabled);
    await prefs.setString(_selectedLanguageKey, next.selectedLanguage);
    await prefs.setBool(_verifiedSellersOnlyKey, next.verifiedSellersOnly);
    await prefs.setBool(_weatherAlertsEnabledKey, next.weatherAlertsEnabled);
    await prefs.setBool(_priceAlertsEnabledKey, next.priceAlertsEnabled);
    await prefs.setBool(_autoLocationEnabledKey, next.autoLocationEnabled);
    await prefs.setDouble(_fontScaleKey, next.fontScale);
  }
}

class AppSettingsPage extends StatefulWidget {
  const AppSettingsPage({super.key});

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  AppSettingsStore get _store => AppSettingsStore.instance;

  Future<void> _save(AppSettingsData data) async {
    await _store.update(data);
  }

  Future<void> _openUrl(String url) async {
    final launched = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('লিংক খোলা যায়নি')));
    }
  }

  void _snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    return ValueListenableBuilder<AppSettingsData>(
      valueListenable: _store,
      builder: (context, settings, _) {
        final bn = settings.selectedLanguage == 'বাংলা';
        return Scaffold(
          appBar: AppBar(
            title: Text(bn ? 'অ্যাপ সেটিংস' : 'App Settings'),
            centerTitle: true,
            backgroundColor: const Color(0xFF1B5E20),
            foregroundColor: Colors.white,
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE8F5E9),
                  Color(0xFFF1F8E9),
                  Color(0xFFFFF8E1),
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 12 : 28,
                  16,
                  isMobile ? 12 : 28,
                  24,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 900),
                    child: Column(
                      children: [
                        _section(
                          title: bn ? 'দ্রুত অ্যাকশন' : 'Quick Actions',
                          icon: Icons.manage_accounts,
                          child: Column(
                            children: [
                              _actionTile(
                                icon: Icons.login_rounded,
                                title: bn ? 'লগইন' : 'Login',
                                subtitle: bn
                                    ? 'লগইন স্ক্রিনে যান'
                                    : 'Open login screen',
                                onTap: () => Navigator.pop(context),
                              ),
                              _actionTile(
                                icon: Icons.person_add_alt_1_rounded,
                                title: bn ? 'রেজিস্টার' : 'Register',
                                subtitle: bn
                                    ? 'রেজিস্টার স্ক্রিনে যান'
                                    : 'Open register screen',
                                onTap: () => Navigator.pop(context),
                              ),
                              _actionTile(
                                icon: Icons.info_outline_rounded,
                                title: bn ? 'আমাদের সম্পর্কে' : 'About Us',
                                subtitle: bn
                                    ? 'অ্যাপ সম্পর্কিত তথ্য'
                                    : 'App details',
                                onTap: () => _snack(
                                  bn ? 'About section' : 'About section',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _section(
                          title: bn
                              ? 'সাধারণ পছন্দসমূহ'
                              : 'General Preferences',
                          icon: Icons.tune_rounded,
                          child: Column(
                            children: [
                              _switchTile(
                                title: bn ? 'নোটিফিকেশন' : 'Notifications',
                                subtitle: bn
                                    ? 'পুশ নোটিফিকেশন চালু/বন্ধ'
                                    : 'Turn push notifications on/off',
                                value: settings.notificationsEnabled,
                                onChanged: (v) => _save(
                                  settings.copyWith(notificationsEnabled: v),
                                ),
                              ),
                              _switchTile(
                                title: bn ? 'ডার্ক মোড' : 'Dark Mode',
                                subtitle: bn
                                    ? 'পুরো অ্যাপের থিম বদলান'
                                    : 'Change the app theme',
                                value: settings.darkModeEnabled,
                                onChanged: (v) => _save(
                                  settings.copyWith(darkModeEnabled: v),
                                ),
                              ),
                              _switchTile(
                                title: bn ? 'অটো লোকেশন' : 'Auto Location',
                                subtitle: bn
                                    ? 'লোকেশন ব্যবহার করে কাছের তথ্য দেখান'
                                    : 'Use location for nearby data',
                                value: settings.autoLocationEnabled,
                                onChanged: (v) => _save(
                                  settings.copyWith(autoLocationEnabled: v),
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.language),
                                title: Text(bn ? 'ভাষা নির্বাচন' : 'Language'),
                                subtitle: Text(
                                  bn ? 'অ্যাপের ভাষা' : 'App language',
                                ),
                                trailing: DropdownButton<String>(
                                  value: settings.selectedLanguage,
                                  items: AppSettingsStore.supportedLanguages
                                      .map(
                                        (language) => DropdownMenuItem(
                                          value: language,
                                          child: Text(language),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    _save(
                                      settings.copyWith(
                                        selectedLanguage: value,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: const Icon(Icons.format_size_rounded),
                                title: Text(bn ? 'ফন্ট সাইজ' : 'Font Size'),
                                subtitle: Text(
                                  bn
                                      ? 'পুরো অ্যাপের লেখা বড়/ছোট করুন'
                                      : 'Increase or decrease app text size',
                                ),
                              ),
                              Slider(
                                value: settings.fontScale,
                                min: 0.75,
                                max: 1.8,
                                divisions: 21,
                                label: '${(settings.fontScale * 100).round()}%',
                                onChanged: (value) {
                                  _save(settings.copyWith(fontScale: value));
                                },
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  bn
                                      ? 'বর্তমান: ${(settings.fontScale * 100).round()}%'
                                      : 'Current: ${(settings.fontScale * 100).round()}%',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _section(
                          title: bn
                              ? 'ক্রেতা ও কৃষক ফিচার'
                              : 'Buyer & Farmer Features',
                          icon: Icons.agriculture_rounded,
                          child: Column(
                            children: [
                              _switchTile(
                                title: bn
                                    ? 'আবহাওয়া সতর্কতা'
                                    : 'Weather Alerts',
                                subtitle: bn
                                    ? 'বৃষ্টি/ঝড়/তাপমাত্রা অ্যালার্ট'
                                    : 'Rain, storm, temperature alerts',
                                value: settings.weatherAlertsEnabled,
                                onChanged: (v) => _save(
                                  settings.copyWith(weatherAlertsEnabled: v),
                                ),
                              ),
                              _switchTile(
                                title: bn ? 'দামের সতর্কতা' : 'Price Alerts',
                                subtitle: bn
                                    ? 'ফসলের দাম পরিবর্তনে জানানো হবে'
                                    : 'Notify when prices change',
                                value: settings.priceAlertsEnabled,
                                onChanged: (v) => _save(
                                  settings.copyWith(priceAlertsEnabled: v),
                                ),
                              ),
                              _switchTile(
                                title: bn
                                    ? 'শুধু verified seller'
                                    : 'Verified sellers only',
                                subtitle: bn
                                    ? 'ক্রেতার জন্য নিরাপদ বিক্রেতা ফিল্টার'
                                    : 'Show only verified sellers',
                                value: settings.verifiedSellersOnly,
                                onChanged: (v) => _save(
                                  settings.copyWith(verifiedSellersOnly: v),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        _section(
                          title: bn ? 'সাপোর্ট ও অ্যাকশন' : 'Support & Actions',
                          icon: Icons.security_rounded,
                          child: Column(
                            children: [
                              _actionTile(
                                icon: Icons.privacy_tip_outlined,
                                title: bn ? 'প্রাইভেসি নীতি' : 'Privacy Policy',
                                subtitle: bn
                                    ? 'ডাটা কিভাবে ব্যবহার হয়'
                                    : 'How your data is used',
                                onTap: () => _snack(
                                  bn ? 'প্রাইভেসি নীতি' : 'Privacy policy',
                                ),
                              ),
                              _actionTile(
                                icon: Icons.description_outlined,
                                title: bn ? 'শর্তাবলি' : 'Terms',
                                subtitle: bn
                                    ? 'অ্যাপ ব্যবহারের নিয়ম'
                                    : 'App usage terms',
                                onTap: () => _snack(bn ? 'শর্তাবলি' : 'Terms'),
                              ),
                              _actionTile(
                                icon: Icons.help_outline_rounded,
                                title: bn
                                    ? 'সাপোর্ট সেন্টার'
                                    : 'Support Center',
                                subtitle: bn
                                    ? 'হেল্প পেতে খুলুন'
                                    : 'Open for help',
                                onTap: () => _openUrl('https://flutter.dev'),
                              ),
                              _actionTile(
                                icon: Icons.call_outlined,
                                title: bn ? 'হেল্পলাইন কল' : 'Call Helpline',
                                subtitle: 'tel:+8801700000000',
                                onTap: () => _openUrl('tel:+8801700000000'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _snack(
                              bn ? 'সেটিংস সেভ হয়েছে' : 'Settings saved',
                            ),
                            icon: const Icon(Icons.save_rounded),
                            label: Text(
                              bn ? 'সব সেটিংস সেভ করুন' : 'Save All Settings',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF1B5E20)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _switchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: onChanged,
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: const Color(0xFF1B5E20)),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}
