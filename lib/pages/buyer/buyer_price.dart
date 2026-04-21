import 'package:flutter/material.dart';

class BuyerPricePage extends StatefulWidget {
  const BuyerPricePage({super.key});

  @override
  State<BuyerPricePage> createState() => _BuyerPricePageState();
}

class _BuyerPricePageState extends State<BuyerPricePage> {
  static const String _allCropsLabel = 'সব ফসল দেখুন';
  static const String _allDistrictsLabel = 'সব জেলা দেখুন';

  static const List<String> _districts = [
    'ঢাকা',
    'গাজীপুর',
    'নারায়ণগঞ্জ',
    'নরসিংদী',
    'মানিকগঞ্জ',
    'মুন্সিগঞ্জ',
    'টাঙ্গাইল',
    'ফরিদপুর',
    'গোপালগঞ্জ',
    'মাদারীপুর',
    'রাজবাড়ী',
    'শরীয়তপুর',
    'কিশোরগঞ্জ',
    'ময়মনসিংহ',
    'জামালপুর',
    'শেরপুর',
    'নেত্রকোনা',
    'চট্টগ্রাম',
    'কক্সবাজার',
    'কুমিল্লা',
    'ব্রাহ্মণবাড়িয়া',
    'চাঁদপুর',
    'নোয়াখালী',
    'ফেনী',
    'লক্ষ্মীপুর',
    'খাগড়াছড়ি',
    'রাঙ্গামাটি',
    'বান্দরবান',
    'রাজশাহী',
    'পাবনা',
    'নাটোর',
    'নওগাঁ',
    'চাঁপাইনবাবগঞ্জ',
    'সিরাজগঞ্জ',
    'বগুড়া',
    'জয়পুরহাট',
    'রংপুর',
    'দিনাজপুর',
    'কুড়িগ্রাম',
    'গাইবান্ধা',
    'নীলফামারী',
    'লালমনিরহাট',
    'পঞ্চগড়',
    'ঠাকুরগাঁও',
    'খুলনা',
    'যশোর',
    'সাতক্ষীরা',
    'বাগেরহাট',
    'কুষ্টিয়া',
    'ঝিনাইদহ',
    'মাগুরা',
    'নড়াইল',
    'চুয়াডাঙ্গা',
    'মেহেরপুর',
    'বরিশাল',
    'পটুয়াখালী',
    'ভোলা',
    'পিরোজপুর',
    'ঝালকাঠি',
    'বরগুনা',
    'সিলেট',
    'মৌলভীবাজার',
    'হবিগঞ্জ',
    'সুনামগঞ্জ',
  ];

  static const List<_CropTemplate> _cropTemplates = [
    _CropTemplate(name: 'ধান', unit: 'kg', emoji: '🌾', basePrice: 50),
    _CropTemplate(name: 'চাল', unit: 'kg', emoji: '🍚', basePrice: 58),
    _CropTemplate(name: 'গম', unit: 'kg', emoji: '🌾', basePrice: 44),
    _CropTemplate(name: 'আলু', unit: 'kg', emoji: '🥔', basePrice: 28),
    _CropTemplate(name: 'পেঁয়াজ', unit: 'kg', emoji: '🧅', basePrice: 75),
    _CropTemplate(name: 'রসুন', unit: 'kg', emoji: '🧄', basePrice: 132),
    _CropTemplate(name: 'আদা', unit: 'kg', emoji: '🫚', basePrice: 95),
    _CropTemplate(name: 'টমেটো', unit: 'kg', emoji: '🍅', basePrice: 42),
    _CropTemplate(name: 'বেগুন', unit: 'kg', emoji: '🍆', basePrice: 34),
    _CropTemplate(name: 'মরিচ', unit: 'kg', emoji: '🌶️', basePrice: 105),
    _CropTemplate(name: 'ডিম', unit: 'piece', emoji: '🥚', basePrice: 14),
    _CropTemplate(name: 'পাট', unit: 'mon', emoji: '🌿', basePrice: 2700),
  ];

  late final List<_CropPriceEntry> _allEntries;
  late List<_CropPriceEntry> _filteredEntries;
  String _selectedCrop = _allCropsLabel;
  String _selectedDistrict = _allDistrictsLabel;

  List<String> get _cropOptions => [
    _allCropsLabel,
    ..._cropTemplates.map((c) => c.name),
  ];

  @override
  void initState() {
    super.initState();
    _allEntries = _generateEntries();
    _filteredEntries = _allEntries;
  }

  void _applyFilter() {
    setState(() {
      _filteredEntries = _allEntries.where((entry) {
        final cropMatch = _selectedCrop == _allCropsLabel
            ? true
            : entry.cropName == _selectedCrop;
        final districtMatch = _selectedDistrict == _allDistrictsLabel
            ? true
            : entry.district == _selectedDistrict;
        return cropMatch && districtMatch;
      }).toList();
    });
  }

  List<_CropPriceEntry> _generateEntries() {
    final now = DateTime.now();
    final entries = <_CropPriceEntry>[];

    for (final district in _districts) {
      for (final crop in _cropTemplates) {
        final seed = (district.hashCode.abs() + crop.name.hashCode.abs()) % 31;
        final avg = crop.basePrice + (seed - 15) * 0.9;
        final minPrice = (avg * 0.88).clamp(1, 100000).toDouble();
        final maxPrice = (avg * 1.12).clamp(1, 100000).toDouble();
        final trend = seed % 3 == 0
            ? TrendDirection.down
            : seed % 3 == 1
            ? TrendDirection.up
            : TrendDirection.stable;

        entries.add(
          _CropPriceEntry(
            cropName: crop.name,
            district: district,
            unit: crop.unit,
            emoji: crop.emoji,
            minPrice: minPrice,
            maxPrice: maxPrice,
            avgPrice: avg,
            trend: trend,
            updatedAt: now.subtract(Duration(days: seed % 3)),
          ),
        );
      }
    }

    return entries;
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(2);
  }

  String _monthShort(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  String _formatDate(DateTime dt) {
    return '${dt.day} ${_monthShort(dt.month)} ${dt.year}';
  }

  IconData _trendIcon(TrendDirection trend) {
    switch (trend) {
      case TrendDirection.up:
        return Icons.arrow_upward_rounded;
      case TrendDirection.down:
        return Icons.arrow_downward_rounded;
      case TrendDirection.stable:
        return Icons.remove_rounded;
    }
  }

  Color _trendColor(TrendDirection trend) {
    switch (trend) {
      case TrendDirection.up:
        return const Color(0xFFDB3A34);
      case TrendDirection.down:
        return const Color(0xFF2E7D32);
      case TrendDirection.stable:
        return const Color(0xFFEF6C00);
    }
  }

  @override
  Widget build(BuildContext context) {
    final districts = [_allDistrictsLabel, ..._districts];

    return Column(
      children: [
        const _BuyerPageTitle(icon: Icons.trending_up, title: 'ফসলের দাম'),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  'https://thumbs.dreamstime.com/b/smart-agriculture-technology-digital-farming-agritech-solutions-field-precision-324410581.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(child: Container(color: const Color(0x26FFFFFF))),
              ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xF266C18C), Color(0xF25AC5B5)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.show_chart_rounded,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'ফসলের বাজার দর',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 32,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'নিজের এলাকায় আজকের সর্বশেষ দাম তথ্য দেখুন',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF6FC194),
                        width: 2,
                      ),
                      color: const Color(0xAAFFFFFF),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'ফসল ও জেলা ভিত্তিক খুঁজুন',
                          style: TextStyle(
                            color: Color(0xFF1E8F5A),
                            fontWeight: FontWeight.w800,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'ফসল ও জেলা নির্বাচন করে বাজার দর দেখুন',
                          style: TextStyle(
                            color: Color(0xFF4B5563),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth > 780;
                            final dropDownStyle = InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD1D5DB),
                                ),
                              ),
                            );

                            final cropDropdown =
                                DropdownButtonFormField<String>(
                                  value: _selectedCrop,
                                  decoration: dropDownStyle.copyWith(
                                    labelText: 'ফসল নির্বাচন',
                                    prefixIcon: const Icon(
                                      Icons.eco_outlined,
                                      size: 18,
                                    ),
                                  ),
                                  items: _cropOptions
                                      .map(
                                        (crop) => DropdownMenuItem(
                                          value: crop,
                                          child: Text(crop),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() => _selectedCrop = value);
                                  },
                                );

                            final districtDropdown =
                                DropdownButtonFormField<String>(
                                  value: _selectedDistrict,
                                  decoration: dropDownStyle.copyWith(
                                    labelText: 'জেলা নির্বাচন',
                                    prefixIcon: const Icon(
                                      Icons.location_on_outlined,
                                      size: 18,
                                    ),
                                  ),
                                  items: districts
                                      .map(
                                        (district) => DropdownMenuItem(
                                          value: district,
                                          child: Text(district),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) {
                                    if (value == null) return;
                                    setState(() => _selectedDistrict = value);
                                  },
                                );

                            final searchButton = SizedBox(
                              height: 48,
                              child: ElevatedButton.icon(
                                onPressed: _applyFilter,
                                icon: const Icon(Icons.search_rounded),
                                label: const Text('খুঁজুন'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D6EFD),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            );

                            if (isWide) {
                              return Row(
                                children: [
                                  Expanded(child: cropDropdown),
                                  const SizedBox(width: 10),
                                  Expanded(child: districtDropdown),
                                  const SizedBox(width: 10),
                                  SizedBox(width: 160, child: searchButton),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                cropDropdown,
                                const SizedBox(height: 10),
                                districtDropdown,
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: double.infinity,
                                  child: searchButton,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'মোট ফলাফল: ${_filteredEntries.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final isCompactMobile = width < 430;
                      final crossAxisCount = width >= 1180
                          ? 3
                          : width >= 700
                          ? 2
                          : 1;
                      final cardMainAxisExtent = width >= 1180
                          ? 430.0
                          : width >= 700
                          ? 445.0
                          : 470.0;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredEntries.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: cardMainAxisExtent,
                        ),
                        itemBuilder: (context, i) {
                          final entry = _filteredEntries[i];

                          return Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Color(0xFF8ECDA8),
                                width: 1.5,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF63C58B),
                                        Color(0xFF58C9BE),
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${entry.emoji} ${entry.cropName}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          fontSize: isCompactMobile ? 18 : 20,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD54C53),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          '📍${entry.district}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    color: const Color(0xFFF5F8F6),
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      children: [
                                        _PriceMetaRow(
                                          title: 'সর্বনিম্ন দাম',
                                          value: _formatCurrency(
                                            entry.minPrice,
                                          ),
                                          icon: Icons.arrow_downward_rounded,
                                          color: const Color(0xFF2E7D32),
                                        ),
                                        const SizedBox(height: 8),
                                        _PriceMetaRow(
                                          title: 'সর্বোচ্চ দাম',
                                          value: _formatCurrency(
                                            entry.maxPrice,
                                          ),
                                          icon: _trendIcon(entry.trend),
                                          color: _trendColor(entry.trend),
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF7B625),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              const Text(
                                                'প্রতি গড় দাম',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '৳${_formatCurrency(entry.avgPrice)}',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: isCompactMobile
                                                      ? 30
                                                      : 34,
                                                  height: 1,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                'প্রতি ${entry.unit}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF2F8BE8),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              '🗓 আপডেট: ${_formatDate(entry.updatedAt)}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BuyerPageTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _BuyerPageTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF27A745), size: 24),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceMetaRow extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _PriceMetaRow({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5ED),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4B5563),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          Text(
            '৳$value',
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}

enum TrendDirection { up, down, stable }

class _CropTemplate {
  final String name;
  final String unit;
  final String emoji;
  final double basePrice;

  const _CropTemplate({
    required this.name,
    required this.unit,
    required this.emoji,
    required this.basePrice,
  });
}

class _CropPriceEntry {
  final String cropName;
  final String district;
  final String unit;
  final String emoji;
  final double minPrice;
  final double maxPrice;
  final double avgPrice;
  final TrendDirection trend;
  final DateTime updatedAt;

  const _CropPriceEntry({
    required this.cropName,
    required this.district,
    required this.unit,
    required this.emoji,
    required this.minPrice,
    required this.maxPrice,
    required this.avgPrice,
    required this.trend,
    required this.updatedAt,
  });
}
