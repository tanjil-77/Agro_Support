import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_settings.dart';
import '../login.dart';
import 'farmer_calendar.dart';
import 'farmer_crop_care.dart';
import 'farmer_crop_price.dart';
import 'farmer_knowledge.dart';
import 'farmer_my_posts.dart';
import 'farmer_post_crop.dart';
import 'farmer_weather.dart';

class FarmerDashboard extends StatefulWidget {
  final String uid;
  final String name;

  const FarmerDashboard({super.key, required this.uid, required this.name});

  @override
  State<FarmerDashboard> createState() => _FarmerDashboardState();
}

class _FarmerDashboardState extends State<FarmerDashboard> {
  int _selectedIndex = 0;
  final List<int> _history = [];

  final List<_NavItem> _items = const [
    _NavItem(Icons.dashboard, 'ড্যাশবোর্ড'),
    _NavItem(Icons.add_box, 'ফসল পোস্ট করুন'),
    _NavItem(Icons.list_alt, 'আমার পোস্ট'),
    _NavItem(Icons.trending_up, 'ফসলের দাম'),
    _NavItem(Icons.cloud, 'আবহাওয়া'),
    _NavItem(Icons.calendar_month, 'ক্যালেন্ডার'),
    _NavItem(Icons.menu_book, 'জ্ঞান ভান্ডার'),
    _NavItem(Icons.eco, 'পরিচর্যা গাইড'),
  ];

  void _navigate(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _history.add(_selectedIndex);
      _selectedIndex = index;
    });
  }

  bool _handleBack() {
    if (_history.isEmpty) return true;
    setState(() => _selectedIndex = _history.removeLast());
    return false;
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Widget _page() {
    switch (_selectedIndex) {
      case 0:
        return _FarmerHome(
          uid: widget.uid,
          name: widget.name,
          onNavigate: _navigate,
        );
      case 1:
        return FarmerPostCropPage(
          uid: widget.uid,
          farmerName: widget.name,
          onNavigate: _navigate,
        );
      case 2:
        return FarmerMyPostsPage(uid: widget.uid, onNavigate: _navigate);
      case 3:
        return const FarmerCropPricePage();
      case 4:
        return const FarmerWeatherPage();
      case 5:
        return const FarmerCalendarPage();
      case 6:
        return const FarmerKnowledgePage();
      case 7:
        return const FarmerCropCarePage();
      default:
        return _FarmerHome(
          uid: widget.uid,
          name: widget.name,
          onNavigate: _navigate,
        );
    }
  }

  @override
       Widget build(BuildContext context) {
    return ValueListenableBuilder<AppSettingsData>(
      valueListenable: AppSettingsStore.instance,
      builder: (context, settings, _) {
        final isBn = settings.selectedLanguage == 'বাংলা';
        final activeAlerts =
            (settings.weatherAlertsEnabled ? 1 : 0) +
            (settings.priceAlertsEnabled ? 1 : 0);

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (!didPop) _handleBack();
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF1B5E20),
              foregroundColor: Colors.white,
              title: Text(isBn ? 'কৃষক প্যানেল' : 'Farmer Panel'),
              actions: [
                if (settings.notificationsEnabled)
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isBn
                                    ? 'আপনার $activeAlerts টি সক্রিয় অ্যালার্ট আছে'
                                    : 'You have $activeAlerts active alerts',
                              ),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      if (activeAlerts > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$activeAlerts',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                else
                  IconButton(
                    icon: const Icon(Icons.notifications_off),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isBn
                                ? 'সেটিংস থেকে নোটিফিকেশন বন্ধ করা আছে'
                                : 'Notifications are disabled from settings',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                PopupMenuButton<String>(
                  tooltip: isBn ? 'প্রোফাইল মেনু' : 'Profile menu',
                  onSelected: (value) {
                    if (value == 'logout') {
                      _logout();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem<String>(
                      value: 'account',
                      enabled: false,
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 14,
                            backgroundColor: Color(0xFFE5E7EB),
                            child: Icon(
                              Icons.person,
                              color: Color(0xFF4B5563),
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(widget.name),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Row(
                        children: [
                          const Icon(Icons.logout, size: 18),
                          const SizedBox(width: 8),
                          Text(isBn ? 'লগ আউট' : 'Logout'),
                        ],
                      ),
                    ),
                  ],
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4, right: 12),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: Color(0x66FFFFFF),
                          child: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            drawer: Drawer(
              child: SafeArea(
                child: Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(
                        widget.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        isBn ? 'কৃষক অ্যাকাউন্ট' : 'Farmer account',
                      ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _items.length,
                        itemBuilder: (context, index) {
                          final item = _items[index];
                          return ListTile(
                            selected: _selectedIndex == index,
                            leading: Icon(item.icon),
                            title: Text(item.label),
                            onTap: () {
                              _navigate(index);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl:
                        'https://images.unsplash.com/photo-1625246333195-78d9c38ad449?auto=format&fit=crop&w=1920&q=80',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        Container(color: const Color(0xFF1B5E20)),
                  ),
                ),
                Positioned.fill(
                  child: Container(color: Colors.black.withOpacity(0.35)),
                ),
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: KeyedSubtree(
                      key: ValueKey(_selectedIndex),
                      child: _page(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem(this.icon, this.label);
}

class _FarmerHome extends StatelessWidget {
  final String uid;
  final String name;
  final Function(int) onNavigate;

  const _FarmerHome({
    required this.uid,
    required this.name,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppSettingsData>(
      valueListenable: AppSettingsStore.instance,
      builder: (context, settings, _) {
        final bn = settings.selectedLanguage == 'বাংলা';
        final width = MediaQuery.of(context).size.width;
        final isWide = width >= 980;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.agriculture_rounded,
                      color: Color(0xFF1B5E20),
                      size: 24,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        bn ? 'কৃষক ড্যাশবোর্ড' : 'Farmer Dashboard',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ),
                    Text(
                      '${bn ? 'স্বাগতম' : 'Hello'}, $name',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('crops')
                    .where('farmerId', isEqualTo: uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  final docs = snapshot.data?.docs ?? [];
                  final active = docs
                      .where((d) => (d.data() as Map)['status'] == 'active')
                      .length;
                  final sold = docs
                      .where((d) => (d.data() as Map)['status'] == 'sold')
                      .length;

                  final latestPosts = docs.take(5).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _GradientStatCard(
                              title: bn ? 'মোট পোস্ট' : 'Total Posts',
                              value: '${docs.length}',
                              colors: const [
                                Color(0xFFD1FAE5),
                                Color(0xFFB7E4D3),
                              ],
                              icon: Icons.eco,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _GradientStatCard(
                              title: bn ? 'সক্রিয় পোস্ট' : 'Active Posts',
                              value: '$active',
                              colors: const [
                                Color(0xFFDBEAFE),
                                Color(0xFFBFDBFE),
                              ],
                              icon: Icons.check_circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _GradientStatCard(
                              title: bn ? 'বিক্রি' : 'Sold',
                              value: '$sold',
                              colors: const [
                                Color(0xFFDFF5FB),
                                Color(0xFFBCE5F1),
                              ],
                              icon: Icons.done_all,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        bn ? '⚡ দ্রুত কাজ' : '⚡ Quick Actions',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _DashboardActionButton(
                            icon: Icons.add,
                            label: bn ? 'নতুন ফসল পোস্ট করুন' : 'Post New Crop',
                            background: const Color(0xFF50B96C),
                            onTap: () => onNavigate(1),
                          ),
                          _DashboardActionButton(
                            icon: Icons.show_chart_rounded,
                            label: bn ? 'ফসলের দাম দেখুন' : 'View Prices',
                            background: const Color(0xFF3B82F6),
                            onTap: () => onNavigate(3),
                          ),
                          _DashboardActionButton(
                            icon: Icons.format_list_bulleted,
                            label: bn ? 'আমার পোস্ট দেখুন' : 'View My Posts',
                            background: const Color(0xFFEABE36),
                            foreground: const Color(0xFF111827),
                            onTap: () => onNavigate(2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF7DD3FC)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bn ? '🌦 আবহাওয়া পরামর্শ' : '🌦 Weather Advice',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 8),
                            _AlertTile(
                              background: const Color(0xFFFDE2E1),
                              borderColor: const Color(0xFFF87171),
                              title: bn ? 'খরা' : 'Drought',
                              subtitle: bn
                                  ? 'নিয়মিত সেচ দিন। ফসলের পানির চাহিদা পূরণ করুন।'
                                  : 'Irrigate regularly and meet crop water requirements.',
                            ),
                            const SizedBox(height: 8),
                            _AlertTile(
                              background: const Color(0xFFFEF3C7),
                              borderColor: const Color(0xFFFBBF24),
                              title: bn ? 'মাঝারি বৃষ্টি' : 'Moderate Rain',
                              subtitle: bn
                                  ? 'ফসলের জন্য ভালো। প্রয়োজন অনুযায়ী সার প্রয়োগ করুন।'
                                  : 'Good for crops. You can apply fertilizer as needed.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _TodayPricesPanel(
                                    bn: bn,
                                    onShowAll: () => onNavigate(3),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _RecentPostsPanel(
                                    bn: bn,
                                    docs: latestPosts,
                                    onShowAll: () => onNavigate(2),
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                _TodayPricesPanel(
                                  bn: bn,
                                  onShowAll: () => onNavigate(3),
                                ),
                                const SizedBox(height: 12),
                                _RecentPostsPanel(
                                  bn: bn,
                                  docs: latestPosts,
                                  onShowAll: () => onNavigate(2),
                                ),
                              ],
                            ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _GradientStatCard extends StatelessWidget {
  final String title;
  final String value;
  final List<Color> colors;
  final IconData icon;

  const _GradientStatCard({
    required this.title,
    required this.value,
    required this.colors,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Icon(icon, color: Colors.white.withOpacity(0.65), size: 22),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 34,
              height: 1,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  const _DashboardActionButton({
    required this.icon,
    required this.label,
    required this.background,
    this.foreground = Colors.white,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: background,
        foregroundColor: foreground,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

class _AlertTile extends StatelessWidget {
  final Color background;
  final Color borderColor;
  final String title;
  final String subtitle;

  const _AlertTile({
    required this.background,
    required this.borderColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayPricesPanel extends StatelessWidget {
  final bool bn;
  final VoidCallback onShowAll;

  const _TodayPricesPanel({required this.bn, required this.onShowAll});

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['মিষ্টি কুমড়া', 'Thakurgaon', '৳55.00/kg'],
      ['লাউ', 'Thakurgaon', '৳55.00/kg'],
      ['শশা', 'Thakurgaon', '৳55.00/kg'],
      ['শিম', 'Thakurgaon', '৳55.00/kg'],
      ['মরিচ', 'Thakurgaon', '৳55.00/kg'],
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bn ? '📈 আজকের ফসলের দাম' : '📈 Today Crop Prices',
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.4),
                1: FlexColumnWidth(1.4),
                2: FlexColumnWidth(1.2),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFF3F4F6)),
                  children: [
                    _TableCell(bn ? 'ফসল' : 'Crop', isHeader: true),
                    _TableCell(bn ? 'অবস্থান' : 'Location', isHeader: true),
                    _TableCell(bn ? 'মূল্য' : 'Price', isHeader: true),
                  ],
                ),
                ...rows.map(
                  (r) => TableRow(
                    children: [
                      _TableCell(r[0]),
                      _TableCell(r[1]),
                      _TableCell(r[2]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onShowAll,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(bn ? 'সব দাম দেখুন' : 'See All Prices'),
          ),
        ],
      ),
    );
  }
}

class _RecentPostsPanel extends StatelessWidget {
  final bool bn;
  final List<QueryDocumentSnapshot> docs;
  final VoidCallback onShowAll;

  const _RecentPostsPanel({
    required this.bn,
    required this.docs,
    required this.onShowAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            bn ? '🌱 আমার সাম্প্রতিক পোস্ট' : '🌱 My Recent Posts',
            style: const TextStyle(
              color: Color(0xFF1F2937),
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: docs.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      bn ? 'কোন পোস্ট পাওয়া যায়নি' : 'No posts found',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : Column(
                    children: docs.take(3).map((d) {
                      final m = d.data() as Map<String, dynamic>;
                      final crop = (m['cropName'] ?? m['name'] ?? 'ফসল')
                          .toString();
                      final qty = (m['quantity'] ?? m['amount'] ?? '0')
                          .toString();
                      final price = (m['price'] ?? m['expectedPrice'] ?? '0')
                          .toString();
                      final status = (m['status'] ?? 'active').toString();

                      return Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.fromLTRB(10, 8, 10, 0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                crop,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              '$qty kg',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '৳$price',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF34D399),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: onShowAll,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF50B96C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(bn ? 'সব পোস্ট দেখুন' : 'See All Posts'),
          ),
        ],
      ),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isHeader;

  const _TableCell(this.text, {this.isHeader = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isHeader ? FontWeight.w800 : FontWeight.w700,
          color: isHeader ? const Color(0xFF374151) : const Color(0xFF111827),
        ),
      ),
    );
  }
}
