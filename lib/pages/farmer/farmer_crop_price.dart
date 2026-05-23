import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'farmer_shared_widgets.dart';

class FarmerCropPricePage extends StatefulWidget {
  const FarmerCropPricePage({super.key});

  @override
  State<FarmerCropPricePage> createState() => _FarmerCropPricePageState();
}

class _FarmerCropPricePageState extends State<FarmerCropPricePage> {
  static const Color _bannerStart = Color(0xFF6FCF97);
  static const Color _bannerEnd = Color(0xFF43B07C);
  static const Color _cardGreenStart = Color(0xFF76C893);
  static const Color _cardGreenEnd = Color(0xFF52B69A);
  static const Color _priceOrange = Color(0xFFF5A524);
  static const Color _accentBlue = Color(0xFF1D4ED8);
  static const String _allCrops = 'ফসল নির্বাচন করুন ';
  static const String _allDistricts = 'জেলা নির্বাচন করুন';

  static const List<String> _districtList = [
    'ঢাকা',
    'গাজীপুর',
    'নারায়ণগঞ্জ',
    'নরসিংদী',
    'মুন্সিগঞ্জ',
    'মানিকগঞ্জ',
    'টাঙ্গাইল',
    'কিশোরগঞ্জ',
    'শরীয়তপুর',
    'মাদারীপুর',
    'ফরিদপুর',
    'গোপালগঞ্জ',
    'রাজবাড়ী',
    'চট্টগ্রাম',
    'কুমিল্লা',
    'ফেনী',
    'ব্রাহ্মণবাড়িয়া',
    'রাঙ্গামাটি',
    'নোয়াখালী',
    'চাঁদপুর',
    'লক্ষ্মীপুর',
    'কক্সবাজার',
    'খাগড়াছড়ি',
    'বান্দরবান',
    'রাজশাহী',
    'সিরাজগঞ্জ',
    'পাবনা',
    'বগুড়া',
    'নাটোর',
    'নওগাঁ',
    'জয়পুরহাট',
    'চাঁপাইনবাবগঞ্জ',
    'খুলনা',
    'বাগেরহাট',
    'সাতক্ষীরা',
    'যশোর',
    'ঝিনাইদহ',
    'নড়াইল',
    'মাগুরা',
    'কুষ্টিয়া',
    'চুয়াডাঙ্গা',
    'মেহেরপুর',
    'বরিশাল',
    'ঝালকাঠি',
    'পটুয়াখালী',
    'পিরোজপুর',
    'ভোলা',
    'বরগুনা',
    'সিলেট',
    'মৌলভীবাজার',
    'হবিগঞ্জ',
    'সুনামগঞ্জ',
    'রংপুর',
    'দিনাজপুর',
    'কুড়িগ্রাম',
    'গাইবান্ধা',
    'লালমনিরহাট',
    'নীলফামারী',
    'ঠাকুরগাঁও',
    'পঞ্চগড়',
    'ময়মনসিংহ',
    'জামালপুর',
    'শেরপুর',
    'নেত্রকোনা',
  ];

  static const List<String> _marketNames = [
    'সদর বাজার',
    'নতুন বাজার',
    'পুরাতন বাজার',
    'কাঁচাবাজার',
    'পাইকারি বাজার',
    'কৃষক বাজার',
    'হাট বাজার',
  ];

  static const List<String> _timeLabels = [
    'আজ, সকাল ৮টা',
    'আজ, সকাল ৯টা',
    'আজ, সকাল ১০টা',
    'আজ, সকাল ১১টা',
    'আজ, দুপুর ১২টা',
    'আজ, দুপুর ১টা',
    'আজ, দুপুর ২টা',
    'আজ, বিকাল ৩টা',
    'আজ, বিকাল ৪টা',
    'আজ, বিকাল ৫টা',
    'আজ, সন্ধ্যা ৬টা',
  ];

  static const List<String> _seedCropPool = [
    'আখ',
    'আলু',
    'আম',
    'ইলিশ',
    'কলা',
    'গম',
    'টমেটো',
    'ধান',
    'পাট',
    'পেঁয়াজ',
    'পেপে',
    'বেগুন',
    'ভুট্টা',
    'মরিচ',
    'মসুর ডাল',
    'মিষ্টি কুমড়া',
    'রসুন',
    'শিম',
    'সরিষা',
  ];

  static const List<_CropPrice> _cropPrices = [
    _CropPrice(
      cropName: 'আলু',
      district: 'ঠাকুরগাঁও',
      market: 'রাণীশংকৈল',
      lastPrice: '৳৩২.০০',
      marketPrice: '৳৩৫.০০',
      highestPrice: '৳৩৮.০০',
      lowestPrice: '৳৩০.০০',
      unit: 'প্রতি কেজি',
      updatedAt: 'আজ, সকাল ৯টা',
    ),
    _CropPrice(
      cropName: 'পেঁয়াজ',
      district: 'নীলফামারী',
      market: 'ডোমার',
      lastPrice: '৳৬৮.০০',
      marketPrice: '৳৭২.০০',
      highestPrice: '৳৭৫.০০',
      lowestPrice: '৳৬৫.০০',
      unit: 'প্রতি কেজি',
      updatedAt: 'আজ, সকাল ১০টা',
    ),
    _CropPrice(
      cropName: 'টমেটো',
      district: 'বগুড়া',
      market: 'সারিয়াকান্দি',
      lastPrice: '৳৪০.০০',
      marketPrice: '৳৪৫.০০',
      highestPrice: '৳৪৮.০০',
      lowestPrice: '৳৩৮.০০',
      unit: 'প্রতি কেজি',
      updatedAt: 'আজ, সকাল ১১টা',
    ),
    _CropPrice(
      cropName: 'ধান',
      district: 'রাজশাহী',
      market: 'গোদাগাড়ী',
      lastPrice: '৳৩৪.০০',
      marketPrice: '৳৩৩.০০',
      highestPrice: '৳৩৬.০০',
      lowestPrice: '৳৩০.০০',
      unit: 'প্রতি কেজি',
      updatedAt: 'আজ, দুপুর ১২টা',
    ),
    _CropPrice(
      cropName: 'গম',
      district: 'কুষ্টিয়া',
      market: 'কুমারখালী',
      lastPrice: '৳৩৯.০০',
      marketPrice: '৳৪১.০০',
      highestPrice: '৳৪৪.০০',
      lowestPrice: '৳৩৮.০০',
      unit: 'প্রতি কেজি',
      updatedAt: 'আজ, দুপুর ১টা',
    ),
    _CropPrice(
      cropName: 'ভুট্টা',
      district: 'দিনাজপুর',
      market: 'নবাবগঞ্জ',
      lastPrice: '৳২৭.০০',
      marketPrice: '৳২৮.৫০',
      highestPrice: '৳৩০.০০',
      lowestPrice: '৳২৬.০০',
      unit: 'প্রতি কেজি',
      updatedAt: 'আজ, দুপুর ২টা',
    ),
    _CropPrice(
      cropName: 'মরিচ',
      district: 'যশোর',
      market: 'শার্শা',
      lastPrice: '৳১২৫.০০',
      marketPrice: '৳১৩০.০০',
      highestPrice: '৳১৪০.০০',
      lowestPrice: '৳১২০.০০',
      unit: 'প্রতি কেজি',
      updatedAt: 'আজ, দুপুর ২:৩০',
    ),
    _CropPrice(
      cropName: 'বেগুন',
      district: 'চট্টগ্রাম',
      market: 'হাটহাজারী',
      lastPrice: '৳৫৫.০০',
      marketPrice: '৳৫৮.০০',
      highestPrice: '৳৬২.০০',
      lowestPrice: '৳৫২.০০',
      unit: 'প্রতি কেজি',
      updatedAt: 'আজ, বিকাল ৩টা',
    ),
    _CropPrice(
      cropName: 'পাট',
      district: 'পাবনা',
      market: 'ঈশ্বরদী',
      lastPrice: '৳২৭০০.০০',
      marketPrice: '৳২৭৫০.০০',
      highestPrice: '৳২৮৫০.০০',
      lowestPrice: '৳২৬৫০.০০',
      unit: 'প্রতি কেজি',
      updatedAt: 'আজ, বিকাল ৩:৩০',
    ),
    _CropPrice(
      cropName: 'আম',
      district: 'রাজশাহী',
      market: 'চারঘাট',
      lastPrice: '৳৮০.০০',
      marketPrice: '৳৮৫.০০',
      highestPrice: '৳৯২.০০',
      lowestPrice: '৳৭৮.০০',
      unit: 'প্রতি কেজি',
      updatedAt: 'আজ, বিকাল ৪টা',
    ),
    _CropPrice(
      cropName: 'কলা',
      district: 'বরিশাল',
      market: 'উজিরপুর',
      lastPrice: '৳৪৫.০০',
      marketPrice: '৳৪৮.০০',
      highestPrice: '৳৫২.০০',
      lowestPrice: '৳৪২.০০',
      unit: 'প্রতি কেজি',
      updatedAt: 'আজ, বিকাল ৪:৩০',
    ),
    _CropPrice(
      cropName: 'চা',
      district: 'সিলেট',
      market: 'শ্রীমঙ্গল',
      lastPrice: '৳২২০.০০',
      marketPrice: '৳২৩০.০০',
      highestPrice: '৳২৪০.০০',
      lowestPrice: '৳২২০.০০',
      unit: 'প্রতি কেজি',
      updatedAt: 'আজ, বিকাল ৫টা',
    ),
  ];

  late String _activeCrop;
  late String _activeDistrict;
  late String _pendingCrop;
  late String _pendingDistrict;

  @override
  void initState() {
    super.initState();
    _activeCrop = _allCrops;
    _activeDistrict = _allDistricts;
    _pendingCrop = _activeCrop;
    _pendingDistrict = _activeDistrict;
  }

  List<String> _buildCropOptions(List<_CropPrice> prices) {
    final options = <String>[_allCrops];
    final seen = <String>{_allCrops};
    void add(String value) {
      if (value.isEmpty || !seen.add(value)) {
        return;
      }
      options.add(value);
    }

    add(_pendingCrop);
    add(_activeCrop);
    for (final price in prices) {
      add(price.cropName);
    }
    return options;
  }

  List<String> _buildDistrictOptions(List<_CropPrice> prices) {
    final options = <String>[_allDistricts];
    final seen = <String>{_allDistricts};
    void add(String value) {
      if (value.isEmpty || !seen.add(value)) {
        return;
      }
      options.add(value);
    }

    add(_pendingDistrict);
    add(_activeDistrict);
    for (final district in _districtList) {
      add(district);
    }
    for (final price in prices) {
      add(price.district);
    }
    return options;
  }

  List<String> _uniqueValues(Iterable<String> values) {
    final seen = <String>{};
    final result = <String>[];
    for (final value in values) {
      if (seen.add(value)) {
        result.add(value);
      }
    }
    return result;
  }

  void _applyFilters() {
    setState(() {
      _activeCrop = _pendingCrop;
      _activeDistrict = _pendingDistrict;
    });
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

  Stream<QuerySnapshot> _farmerPostsStream(String? uid) {
    if (uid == null || uid.isEmpty) {
      return const Stream<QuerySnapshot>.empty();
    }
    return FirebaseFirestore.instance
        .collection('crops')
        .where('farmerId', isEqualTo: uid)
        .snapshots();
  }

  List<_CropPrice> _buildDistrictSeedPrices(List<String> cropPool) {
    final pool = cropPool.isEmpty ? _seedCropPool : cropPool;
    final prices = <_CropPrice>[];
    for (var d = 0; d < _districtList.length; d++) {
      for (var c = 0; c < pool.length; c++) {
        final base = 25 + (d % 9) * 3 + (c % 6) * 2;
        final market = base + 4;
        var low = base - 3;
        if (low < 5) {
          low = 5;
        }
        final high = market + 5;

        prices.add(
          _CropPrice(
            cropName: pool[c],
            district: _districtList[d],
            market: _marketNames[(d + c) % _marketNames.length],
            lastPrice: _formatPrice(base.toDouble()),
            marketPrice: _formatPrice(market.toDouble()),
            highestPrice: _formatPrice(high.toDouble()),
            lowestPrice: _formatPrice(low.toDouble()),
            unit: 'প্রতি কেজি',
            updatedAt: _timeLabels[(d + c) % _timeLabels.length],
          ),
        );
      }
    }
    return prices;
  }

  List<_CropPrice> _buildPostPrices(List<QueryDocumentSnapshot> docs) {
    final prices = <_CropPrice>[];
    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final cropName = (data['cropName'] ?? '').toString().trim();
      if (cropName.isEmpty) {
        continue;
      }
      final location = (data['location'] ?? '').toString();
      final district = _resolveDistrict(location);
      final priceValue = _parseNumber(data['price']);
      final unit = (data['unit'] ?? 'কেজি').toString().trim();
      final unitLabel = unit.isEmpty ? 'প্রতি কেজি' : 'প্রতি $unit';
      final safePrice = (priceValue.isFinite ? priceValue : 0).toDouble();
      final lowPrice = safePrice == 0 ? 0.0 : safePrice * 0.92;
      final highPrice = safePrice == 0 ? 0.0 : safePrice * 1.08;

      prices.add(
        _CropPrice(
          cropName: cropName,
          district: district,
          market: 'কৃষকের পোস্ট',
          lastPrice: _formatPrice(safePrice > 1 ? safePrice - 1 : safePrice),
          marketPrice: _formatPrice(safePrice),
          highestPrice: _formatPrice(highPrice),
          lowestPrice: _formatPrice(lowPrice),
          unit: unitLabel,
          updatedAt: _formatPostUpdatedAt(data['createdAt']),
        ),
      );
    }
    return prices;
  }

  List<_CropPrice> _mergePrices(List<_CropPrice> postPrices) {
    final cropPool = _uniqueValues([
      ..._seedCropPool,
      ..._cropPrices.map((price) => price.cropName),
      ...postPrices.map((price) => price.cropName),
    ]);
    final districtPrices = _buildDistrictSeedPrices(cropPool);
    final merged = <String, _CropPrice>{};
    void upsert(_CropPrice price) {
      merged['${price.district}|${price.cropName}'] = price;
    }

    for (final price in districtPrices) {
      upsert(price);
    }
    for (final price in _cropPrices) {
      upsert(price);
    }
    for (final price in postPrices) {
      upsert(price);
    }

    return merged.values.toList();
  }

  double _parseNumber(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  String _resolveDistrict(String location) {
    final trimmed = location.trim();
    if (trimmed.isEmpty) {
      return 'অজানা';
    }
    for (final district in _districtList) {
      if (trimmed.contains(district)) {
        return district;
      }
    }
    return trimmed.split(',').first.trim();
  }

  String _formatPostUpdatedAt(dynamic createdAt) {
    if (createdAt is Timestamp) {
      final dt = createdAt.toDate();
      final day = _toBnDigits(dt.day.toString().padLeft(2, '0'));
      final month = _toBnDigits(dt.month.toString().padLeft(2, '0'));
      return '$day/$month';
    }
    return 'আজ';
  }

  String _formatPrice(double value) {
    final safe = value.isFinite ? value : 0;
    return '৳${_toBnDigits(safe.toStringAsFixed(2))}';
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final gridCount = _gridCountForWidth(width);
    final cardHeight = width < 600 ? 260.0 : 240.0;
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Column(
      children: [
        const FarmerPageTitle(icon: Icons.trending_up, title: 'ফসলের দাম'),
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
              StreamBuilder<QuerySnapshot>(
                stream: _farmerPostsStream(uid),
                builder: (context, snapshot) {
                  final docs = snapshot.data?.docs ?? <QueryDocumentSnapshot>[];
                  final postPrices = _buildPostPrices(docs);
                  final allPrices = _mergePrices(postPrices);
                  final cropOptions = _buildCropOptions(allPrices);
                  final districtOptions = _buildDistrictOptions(allPrices);
                  final filteredPrices = allPrices.where((price) {
                    final cropMatches =
                        _activeCrop == _allCrops ||
                        price.cropName == _activeCrop;
                    final districtMatches =
                        _activeDistrict == _allDistricts ||
                        price.district == _activeDistrict;
                    return cropMatches && districtMatches;
                  }).toList();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeroBanner(),
                        const SizedBox(height: 16),
                        _buildSearchCard(width, cropOptions, districtOptions),
                        const SizedBox(height: 16),
                        _buildResultHeader(filteredPrices.length),
                        const SizedBox(height: 12),
                        if (filteredPrices.isEmpty)
                          _buildEmptyState()
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredPrices.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: gridCount,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  mainAxisExtent: cardHeight,
                                ),
                            itemBuilder: (context, index) {
                              return _buildPriceCard(filteredPrices[index]);
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
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
                    value: _pendingCrop,
                    items: cropOptions,
                    icon: Icons.eco_rounded,
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _pendingCrop = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDropdown(
                    label: 'জেলা নির্বাচন করুন',
                    value: _pendingDistrict,
                    items: districtOptions,
                    icon: Icons.location_on_rounded,
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _pendingDistrict = value;
                      });
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
                  value: _pendingCrop,
                  items: cropOptions,
                  icon: Icons.eco_rounded,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _pendingCrop = value;
                    });
                  },
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                  label: 'জেলা নির্বাচন করুন',
                  value: _pendingDistrict,
                  items: districtOptions,
                  icon: Icons.location_on_rounded,
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _pendingDistrict = value;
                    });
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
      onPressed: _applyFilters,
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
            '$count টি ফলাফল',
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

  Widget _buildPriceCard(_CropPrice price) {
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price.cropName,
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
                            price.district,
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
                            price.market,
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
                        price.lastPrice,
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
                        'সর্বোচ্চ ${price.highestPrice}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        price.updatedAt,
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
                        'সর্বনিম্ন ${price.lowestPrice}',
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
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14),
              ),
            ),
            child: Column(
              children: [
                Text(
                  price.unit,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  price.marketPrice,
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
}

class _CropPrice {
  final String cropName;
  final String district;
  final String market;
  final String lastPrice;
  final String marketPrice;
  final String highestPrice;
  final String lowestPrice;
  final String unit;
  final String updatedAt;

  const _CropPrice({
    required this.cropName,
    required this.district,
    required this.market,
    required this.lastPrice,
    required this.marketPrice,
    required this.highestPrice,
    required this.lowestPrice,
    required this.unit,
    required this.updatedAt,
  });
}
