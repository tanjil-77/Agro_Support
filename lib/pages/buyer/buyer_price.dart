import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BuyerPricePage extends StatefulWidget {
  const BuyerPricePage({super.key});

  @override
  State<BuyerPricePage> createState() => _BuyerPricePageState();
}

class _BuyerPricePageState extends State<BuyerPricePage> {
  static const Color _bannerStart = Color(0xFF6FCF97);
  static const Color _bannerEnd = Color(0xFF43B07C);
  static const Color _cardGreenStart = Color(0xFF76C893);
  static const Color _cardGreenEnd = Color(0xFF52B69A);
  static const Color _priceOrange = Color(0xFFF5A524);
  static const Color _accentBlue = Color(0xFF1D4ED8);
  static const String _allCropsLabel = 'ফসল নির্বাচন করুন';
  static const String _allDistrictsLabel = 'জেলা নির্বাচন করুন';

  static const List<String> _marketNames = [
    'সদর বাজার',
    'নতুন বাজার',
    'পুরাতন বাজার',
    'কাঁচাবাজার',
    'পাইকারি বাজার',
    'কৃষক বাজার',
    'হাট বাজার',
  ];

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
    return _toBnDigits(amount.toStringAsFixed(2));
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
    final day = _toBnDigits(dt.day.toString());
    final year = _toBnDigits(dt.year.toString());
    return '$day ${_monthShort(dt.month)} $year';
  }

  String _toBnDigits(String input) {
    const map = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };
    final buffer = StringBuffer();
    for (final char in input.split('')) {
      buffer.write(map[char] ?? char);
    }
    return buffer.toString();
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

  int _gridCountForWidth(double width) {
    if (width >= 1200) {
      return 4;
    }
    if (width >= 900) {
      return 3;
    }
    if (width >= 600) {
      return 2;
    }
    return 1;
  }

  String _trendLabel(TrendDirection trend) {
    switch (trend) {
      case TrendDirection.up:
        return 'উর্ধ্বমুখী';
      case TrendDirection.down:
        return 'নিম্নমুখী';
      case TrendDirection.stable:
        return 'স্থিতিশীল';
    }
  }

  String _unitLabel(String unit) {
    switch (unit) {
      case 'kg':
        return 'কেজি';
      case 'piece':
        return 'পিস';
      case 'mon':
        return 'মণ';
      default:
        return unit;
    }
  }

  String _marketForEntry(_CropPriceEntry entry) {
    final seed = entry.cropName.hashCode.abs() + entry.district.hashCode.abs();
    return _marketNames[seed % _marketNames.length];
  }

  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _bannerStart.withOpacity(0.62),
            _bannerEnd.withOpacity(0.62),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_graph_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'ফসলের বাজার দর',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'বিভিন্ন জেলা অনুযায়ী ফসলের সর্বশেষ মূল্য তথ্য দেখুন',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.75),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard(
    double width,
    List<String> cropOptions,
    List<String> districtOptions,
  ) {
    final isWide = width >= 760;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F2EA).withOpacity(0.55),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF148F60),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ফসল ও জেলা ভিত্তিক খুঁজুন',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'সর্বশেষ বাজার দর দেখতে আপনার পছন্দের তথ্য দিন',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (isWide)
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'ফসল নির্বাচন করুন',
                    value: _selectedCrop,
                    items: cropOptions,
                    icon: Icons.eco_rounded,
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() => _selectedCrop = value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    label: 'জেলা নির্বাচন করুন',
                    value: _selectedDistrict,
                    items: districtOptions,
                    icon: Icons.location_on_rounded,
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() => _selectedDistrict = value);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(width: 140, height: 48, child: _buildSearchButton()),
              ],
            )
          else
            Column(
              children: [
                _buildDropdown(
                  label: 'ফসল নির্বাচন করুন',
                  value: _selectedCrop,
                  items: cropOptions,
                  icon: Icons.eco_rounded,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() => _selectedCrop = value);
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                  label: 'জেলা নির্বাচন করুন',
                  value: _selectedDistrict,
                  items: districtOptions,
                  icon: Icons.location_on_rounded,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() => _selectedDistrict = value);
                  },
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: _buildSearchButton(),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton.icon(
      onPressed: _applyFilter,
      icon: const Icon(Icons.search_rounded),
      label: const Text('খুঁজুন'),
      style: ElevatedButton.styleFrom(
        backgroundColor: _accentBlue,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18),
        filled: true,
        fillColor: Colors.white.withOpacity(0.4),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF60A5FA)),
        ),
      ),
    );
  }

  Widget _buildResultHeader(int count) {
    return Row(
      children: [
        const Icon(Icons.grid_view_rounded, color: Color(0xFF0F172A)),
        const SizedBox(width: 8),
        const Text(
          'সর্বশেষ বাজার দর',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '${_toBnDigits(count.toString())} টি ফলাফল',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 34,
            color: Color(0xFF94A3B8),
          ),
          const SizedBox(height: 8),
          const Text(
            'কোনো ফলাফল পাওয়া যায়নি',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'অন্য ফসল বা জেলা বেছে নিয়ে আবার খুঁজুন',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard(_CropPriceEntry entry) {
    final unitLabel = _unitLabel(entry.unit);
    final marketName = _marketForEntry(entry);
    final lastPrice = _formatCurrency(
      entry.avgPrice > 1 ? entry.avgPrice - 1 : entry.avgPrice,
    );
    final marketPrice = _formatCurrency(entry.avgPrice);
    final highestPrice = _formatCurrency(entry.maxPrice);
    final lowestPrice = _formatCurrency(entry.minPrice);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _cardGreenStart.withOpacity(0.7),
                  _cardGreenEnd.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.emoji} ${entry.cropName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE11D48).withOpacity(0.75),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            entry.district,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.store_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            marketName,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.payments_rounded,
                        size: 14,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'সর্বশেষ দর',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '৳$lastPrice',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward_rounded,
                        size: 14,
                        color: Color(0xFF16A34A),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'সর্বোচ্চ ৳$highestPrice',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        _formatDate(entry.updatedAt),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.arrow_downward_rounded,
                        size: 14,
                        color: Color(0xFFDC2626),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'সর্বনিম্ন ৳$lowestPrice',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: _priceOrange.withOpacity(0.72),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'প্রতি $unitLabel',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '৳$marketPrice',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final gridCount = _gridCountForWidth(width);
    final cardHeight = width < 600 ? 260.0 : 240.0;
    final cropOptions = _cropOptions;
    final districtOptions = [_allDistrictsLabel, ..._districts];

    return Column(
      children: [
        const _BuyerPageTitle(icon: Icons.trending_up, title: 'ফসলের দাম'),
        Expanded(
          child: Stack(
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
                child: Container(color: Colors.black.withOpacity(0.2)),
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeroBanner(),
                    const SizedBox(height: 16),
                    _buildSearchCard(width, cropOptions, districtOptions),
                    const SizedBox(height: 16),
                    _buildResultHeader(_filteredEntries.length),
                    const SizedBox(height: 12),
                    if (_filteredEntries.isEmpty)
                      _buildEmptyState()
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredEntries.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          mainAxisExtent: cardHeight,
                        ),
                        itemBuilder: (context, i) {
                          return _buildPriceCard(_filteredEntries[i]);
                        },
                      ),
                  ],
                ),
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
