import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../app_settings.dart';
import '../login.dart';
import 'buyer_price.dart';
import 'buyer_shared_widgets.dart';

class BuyerDashboard extends StatefulWidget {
  final String uid;
  final String name;

  const BuyerDashboard({super.key, required this.uid, required this.name});

  @override
  State<BuyerDashboard> createState() => _BuyerDashboardState();
}

class _BuyerDashboardState extends State<BuyerDashboard> {
  int _selectedIndex = 0;

  final List<_BNavItem> _navItems = const [
    _BNavItem(icon: Icons.shopping_cart, label: 'মার্কেটপ্লেস'),
    _BNavItem(icon: Icons.trending_up, label: 'ফসলের দাম'),
  ];

  Widget _buildPage(AppSettingsData settings) {
    switch (_selectedIndex) {
      case 0:
        return BuyerMarketplacePage(
          name: widget.name,
          verifiedOnly: settings.verifiedSellersOnly,
        );
      case 1:
        return const BuyerPricePage();
      default:
        return BuyerMarketplacePage(
          name: widget.name,
          verifiedOnly: settings.verifiedSellersOnly,
        );
    }
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

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppSettingsData>(
      valueListenable: AppSettingsStore.instance,
      builder: (context, settings, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F7F5),
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1565C0), Color(0xFF27A745)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.white, size: 22),
                SizedBox(width: 8),
                Text(
                  'ক্রেতা প্যানেল',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            actions: [
              GestureDetector(
                onTap: () => _showProfileMenu(context),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          drawer: Drawer(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF27A745)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white.withOpacity(0.25),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC107),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'ক্রেতা',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _navItems.length,
                    itemBuilder: (context, i) {
                      final isSelected = _selectedIndex == i;
                      return ListTile(
                        selected: isSelected,
                        selectedTileColor: const Color(
                          0xFF1565C0,
                        ).withOpacity(0.1),
                        leading: Icon(
                          _navItems[i].icon,
                          color: isSelected
                              ? const Color(0xFF1565C0)
                              : Colors.grey.shade600,
                        ),
                        title: Text(
                          _navItems[i].label,
                          style: TextStyle(
                            color: isSelected
                                ? const Color(0xFF1565C0)
                                : const Color(0xFF333333),
                            fontWeight: isSelected
                                ? FontWeight.w800
                                : FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        onTap: () {
                          setState(() => _selectedIndex = i);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'লগআউট',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  onTap: _logout,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Stack(
              key: ValueKey(_selectedIndex),
              children: [
                Positioned.fill(
                  child: Image.network(
                    'https://img.freepik.com/premium-photo/smart-agriculture-system-enhancing-farm-productivity_932138-38804.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/buyer_bg.jpg',
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.03),
                          Colors.black.withOpacity(0.10),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(child: _buildPage(settings)),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: const Color(0xFF1565C0).withOpacity(0.15),
              child: const Icon(
                Icons.person,
                color: Color(0xFF1565C0),
                size: 36,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            const Text(
              'ক্রেতা অ্যাকাউন্ট',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                _logout();
              },
              icon: const Icon(Icons.logout),
              label: const Text('লগআউট'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyerMarketplacePage extends StatefulWidget {
  final String name;
  final bool verifiedOnly;

  const BuyerMarketplacePage({
    super.key,
    required this.name,
    this.verifiedOnly = false,
  });

  @override
  State<BuyerMarketplacePage> createState() => _BuyerMarketplacePageState();
}

class _BuyerMarketplacePageState extends State<BuyerMarketplacePage> {
  String _searchCrop = '';
  String _searchLocation = '';
  String? _selectedDetail;
  List<String> _cropOptions = [];
  final _cropController = TextEditingController();
  final _locationController = TextEditingController();

  static const List<String> _predefinedCrops = [
    'আখ',
    'আলু',
    'গম',
    'টমেটো',
    'ধান',
    'পাট',
    'পেঁয়াজ',
    'পেঁপে',
    'বেগুন',
    'ভুট্টা',
    'মরিচ',
    'মসুর ডাল',
    'মিষ্টি কুমড়া',
    'রসুন',
    'লাউ',
    'শিম',
    'ফুলকপি',
    'বাঁধাকপি',
    'করলা',
    'ঢেঁড়স',
    'পালং শাক',
    'আদা',
    'হলুদ',
  ];

  static const List<String> _allDistricts = [
    'ঢাকা',
    'ফরিদপুর',
    'গাজীপুর',
    'গোপালগঞ্জ',
    'কিশোরগঞ্জ',
    'মাদারীপুর',
    'মানিকগঞ্জ',
    'মুন্সিগঞ্জ',
    'নারায়ণগঞ্জ',
    'নরসিংদী',
    'রাজবাড়ী',
    'শরীয়তপুর',
    'টাঙ্গাইল',
    'বাগেরহাট',
    'চুয়াডাঙ্গা',
    'যশোর',
    'ঝিনাইদহ',
    'খুলনা',
    'কুষ্টিয়া',
    'মাগুরা',
    'মেহেরপুর',
    'নড়াইল',
    'সাতক্ষীরা',
    'বান্দরবান',
    'ব্রাহ্মণবাড়িয়া',
    'চাঁদপুর',
    'চট্টগ্রাম',
    'কুমিল্লা',
    'কক্সবাজার',
    'ফেনী',
    'খাগড়াছড়ি',
    'লক্ষ্মীপুর',
    'নোয়াখালী',
    'রাঙ্গামাটি',
    'বরগুনা',
    'বরিশাল',
    'ভোলা',
    'ঝালকাঠি',
    'পটুয়াখালী',
    'পিরোজপুর',
    'বগুড়া',
    'চাঁপাইনবাবগঞ্জ',
    'জয়পুরহাট',
    'নওগাঁ',
    'নাটোর',
    'পাবনা',
    'রাজশাহী',
    'সিরাজগঞ্জ',
    'দিনাজপুর',
    'গাইবান্ধা',
    'কুড়িগ্রাম',
    'লালমনিরহাট',
    'নীলফামারী',
    'পঞ্চগড়',
    'রংপুর',
    'ঠাকুরগাঁও',
    'হবিগঞ্জ',
    'মৌলভীবাজার',
    'সুনামগঞ্জ',
    'সিলেট',
    'জামালপুর',
    'ময়মনসিংহ',
    'নেত্রকোণা',
    'শেরপুর',
  ];

  @override
  void initState() {
    super.initState();
    _loadCropOptions();
  }

  @override
  void dispose() {
    _cropController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _loadCropOptions() async {
    try {
      final snap = await FirebaseFirestore.instance
          .collection('crops')
          .where('status', isEqualTo: 'active')
          .get();
      final firestoreNames = snap.docs
          .map((d) => (d.data()['cropName'] ?? '').toString().trim())
          .where((n) => n.isNotEmpty)
          .toSet();
      final merged = <String>{..._predefinedCrops, ...firestoreNames};
      final sorted = merged.toList()..sort();
      if (mounted) setState(() => _cropOptions = sorted);
    } catch (_) {
      if (mounted)
        setState(() => _cropOptions = List.from(_predefinedCrops)..sort());
    }
  }

  Widget _buildCropField() {
    return Autocomplete<String>(
      optionsBuilder: (value) {
        if (value.text.isEmpty) return const [];
        return _cropOptions.where(
          (c) => c.toLowerCase().contains(value.text.toLowerCase()),
        );
      },
      onSelected: (val) => _cropController.text = val,
      fieldViewBuilder: (ctx, ctrl, focusNode, onSubmit) {
        ctrl.text = _cropController.text;
        ctrl.selection = TextSelection.collapsed(offset: ctrl.text.length);
        ctrl.addListener(() => _cropController.text = ctrl.text);
        return TextField(
          controller: ctrl,
          focusNode: focusNode,
          style: const TextStyle(color: Color(0xFF0E3966), fontSize: 13),
          decoration: InputDecoration(
            hintText: 'ফসল লিখুন',
            hintStyle: const TextStyle(color: Color(0xCC3B5E84), fontSize: 13),
            prefixIcon: const Icon(
              Icons.grass,
              color: Color(0xCC3B5E84),
              size: 18,
            ),
            filled: true,
            fillColor: const Color(0x78EAF3FF),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
      optionsViewBuilder: (ctx, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          color: const Color(0xFF1565C0),
          borderRadius: BorderRadius.circular(8),
          elevation: 4,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 180),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: options
                  .map(
                    (opt) => ListTile(
                      dense: true,
                      title: Text(
                        opt,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      onTap: () => onSelected(opt),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationField() {
    return Autocomplete<String>(
      optionsBuilder: (value) {
        if (value.text.isEmpty) return const [];
        return _allDistricts.where(
          (d) => d.toLowerCase().contains(value.text.toLowerCase()),
        );
      },
      onSelected: (val) => _locationController.text = val,
      fieldViewBuilder: (ctx, ctrl, focusNode, onSubmit) {
        ctrl.text = _locationController.text;
        ctrl.selection = TextSelection.collapsed(offset: ctrl.text.length);
        ctrl.addListener(() => _locationController.text = ctrl.text);
        return TextField(
          controller: ctrl,
          focusNode: focusNode,
          style: const TextStyle(color: Color(0xFF0E3966), fontSize: 13),
          decoration: InputDecoration(
            hintText: 'জেলা লিখুন',
            hintStyle: const TextStyle(color: Color(0xCC3B5E84), fontSize: 13),
            prefixIcon: const Icon(
              Icons.location_on,
              color: Color(0xCC3B5E84),
              size: 18,
            ),
            filled: true,
            fillColor: const Color(0x78EAF3FF),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
      optionsViewBuilder: (ctx, onSelected, options) => Align(
        alignment: Alignment.topLeft,
        child: Material(
          color: const Color(0xFF1565C0),
          borderRadius: BorderRadius.circular(8),
          elevation: 4,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 180),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: options
                  .map(
                    (opt) => ListTile(
                      dense: true,
                      title: Text(
                        opt,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      onTap: () => onSelected(opt),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [const Color(0x66E3F0FD), const Color(0x52CFE3F7)],
            ),
            border: const Border(
              bottom: BorderSide(color: Color(0x66B5CBE3), width: 0.9),
            ),
            boxShadow: const [
              BoxShadow(color: Color(0x1F103E68), blurRadius: 8),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shopping_cart,
                    color: Color(0xFF1565C0),
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'স্বাগতম, ${widget.name}!',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0E4D8B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('crops')
                    .where('status', isEqualTo: 'active')
                    .snapshots(),
                builder: (ctx, snap) {
                  final rawDocs = snap.data?.docs ?? [];
                  final crops = widget.verifiedOnly
                      ? rawDocs.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return data['isVerified'] == true ||
                              (data['farmerPhone'] ?? '')
                                  .toString()
                                  .trim()
                                  .isNotEmpty;
                        }).toList()
                      : rawDocs;
                  final farmerIds = crops
                      .map((d) => (d.data() as Map)['farmerId'])
                      .toSet()
                      .length;
                  return Row(
                    children: [
                      Expanded(
                        child: BuyerStatCard(
                          label: 'উপলব্ধ ফসল',
                          value: '${crops.length}',
                          icon: Icons.grass,
                          gradient: const [
                            Color(0xFF27A745),
                            Color(0xFF66BB6A),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BuyerStatCard(
                          label: 'মোট কৃষক',
                          value: '$farmerIds',
                          icon: Icons.people,
                          gradient: const [
                            Color(0xFFE91E8C),
                            Color(0xFFAB47BC),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6F8ED8).withOpacity(0.15),
                const Color(0xFF48A1DB).withOpacity(0.12),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x55CCE0F5), width: 1.0),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F243D63),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.filter_alt, color: Color(0xFF0E3966), size: 18),
                  SizedBox(width: 6),
                  Text(
                    'ফিল্টার করুন',
                    style: TextStyle(
                      color: Color(0xFF0E3966),
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildCropField()),
                  const SizedBox(width: 8),
                  Expanded(child: _buildLocationField()),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => setState(() {
                        _searchCrop = _cropController.text.trim().toLowerCase();
                        _searchLocation = _locationController.text
                            .trim()
                            .toLowerCase();
                      }),
                      icon: const Icon(Icons.search, size: 18),
                      label: const Text('খুঁজুন'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF27A745),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _searchCrop = '';
                      _searchLocation = '';
                      _cropController.clear();
                      _locationController.clear();
                    }),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0x8FD7E6F7),
                      foregroundColor: const Color(0xFF0D4A7A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('রিসেট'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('crops')
                .where('status', isEqualTo: 'active')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF27A745)),
                );
              }
              var docs = snapshot.data?.docs ?? [];
              if (widget.verifiedOnly) {
                docs = docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return data['isVerified'] == true ||
                      (data['farmerPhone'] ?? '').toString().trim().isNotEmpty;
                }).toList();
              }
              if (_searchCrop.isNotEmpty) {
                docs = docs.where((d) {
                  final name = ((d.data() as Map)['cropName'] ?? '')
                      .toString()
                      .toLowerCase();
                  return name.contains(_searchCrop);
                }).toList();
              }
              if (_searchLocation.isNotEmpty) {
                docs = docs.where((d) {
                  final loc = ((d.data() as Map)['location'] ?? '')
                      .toString()
                      .toLowerCase();
                  return loc.contains(_searchLocation);
                }).toList();
              }
              if (docs.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('😔', style: TextStyle(fontSize: 40)),
                      SizedBox(height: 10),
                      Text(
                        'কোনো ফসল পাওয়া যায়নি',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: docs.length,
                itemBuilder: (ctx, i) {
                  final d = docs[i].data() as Map<String, dynamic>;
                  final docId = docs[i].id;
                  return BuyerCropCard(
                    data: d,
                    docId: docId,
                    isExpanded: _selectedDetail == docId,
                    onToggle: () {
                      setState(
                        () => _selectedDetail = _selectedDetail == docId
                            ? null
                            : docId,
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BNavItem {
  final IconData icon;
  final String label;

  const _BNavItem({required this.icon, required this.label});
}
