import 'package:flutter/material.dart';

class FarmerCalendarPage extends StatefulWidget {
  const FarmerCalendarPage({super.key});

  @override
  State<FarmerCalendarPage> createState() => _FarmerCalendarPageState();
}

class _FarmerCalendarPageState extends State<FarmerCalendarPage> {
  String _filter = 'সব';

  static const _filters = [
    {'label': '🌱 সব ফসল', 'key': 'সব'},
    {'label': '🌾 রবি মৌসুম', 'key': 'রবি'},
    {'label': '☀️ গ্রীষ্ম মৌসুম', 'key': 'গ্রীষ্ম'},
    {'label': '🌿 খরিফ মৌসুম', 'key': 'খরিফ'},
    {'label': '🌧️ বর্ষা মৌসুম', 'key': 'বর্ষা'},
    {'label': '❄️ শীত মৌসুম', 'key': 'শীত'},
  ];

  static final List<Map<String, dynamic>> _crops = [
    // ─── ধান ───────────────────────────────────────────────────
    {
      'name': 'আউশ ধান',
      'icon': '🌾',
      'season': 'গ্রীষ্ম',
      'seasonColor': 0xFFE65100,
      'filter': 'গ্রীষ্ম',
      'plantTime': 'মার্চ-মে\n(মধ্য-এপ্রিল)',
      'harvestTime': 'আগস্ট-সেপ্টেম্বর\n(জুন-জুলাই)',
      'duration': '৪-৫ মাস',
    },
    {
      'name': 'আমন ধান',
      'icon': '🌾',
      'season': 'বর্ষা',
      'seasonColor': 0xFF1565C0,
      'filter': 'বর্ষা',
      'plantTime': 'জুলাই-আগস্ট\n(জুন-জুলাই)',
      'harvestTime': 'নভেম্বর-ডিসেম্বর',
      'duration': '৪-৫ মাস',
    },
    {
      'name': 'বোরো ধান',
      'icon': '🌾',
      'season': 'শীত',
      'seasonColor': 0xFF00838F,
      'filter': 'শীত',
      'plantTime': 'নভেম্বর-ডিসেম্বর\n(নভেম্বর-ডিসেম্বর)',
      'harvestTime': 'এপ্রিল-মে\n(এপ্রিল-মে)',
      'duration': '৫-৬ মাস',
    },
    // ─── শস্য ───────────────────────────────────────────────────
    {
      'name': 'গম',
      'icon': '🌾',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'অক্টোবর-নভেম্বর\n(অক্টোবর-নভেম্বর)',
      'harvestTime': 'ফেব্রুয়ারি-মার্চ\n(ফেব্রুয়ারি-মার্চ)',
      'duration': '৩ মাস',
    },
    {
      'name': 'ভুট্টা',
      'icon': '🌽',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'অক্টোবর-নভেম্বর\n(আশ্বিন-নভেম্বর)',
      'harvestTime': 'ফেব্রুয়ারি-মার্চ\n(জানুয়ারি-মার্চ)',
      'duration': '৩ মাস',
    },
    {
      'name': 'আলু',
      'icon': '🥔',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'অক্টোবর-নভেম্বর\n(অক্টোবর-নভেম্বর)',
      'harvestTime': 'ফেব্রুয়ারি-মার্চ\n(ফেব্রুয়ারি-মার্চ)',
      'duration': '৩ মাস',
    },
    // ─── সবজি ───────────────────────────────────────────────────
    {
      'name': 'পেঁয়াজ',
      'icon': '🧅',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'অক্টোবর-নভেম্বর\n(নভেম্বর-ডিসেম্বর)',
      'harvestTime': 'ফেব্রুয়ারি-মার্চ\n(মার্চ-এপ্রিল)',
      'duration': '৩ মাস',
    },
    {
      'name': 'রসুন',
      'icon': '🧄',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'অক্টোবর-নভেম্বর',
      'harvestTime': 'ফেব্রুয়ারি-মার্চ\n(মার্চ-এপ্রিল)',
      'duration': '৩ মাস',
    },
    {
      'name': 'টমেটো',
      'icon': '🍅',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'সেপ্টেম্বর-অক্টোবর\n(সেপ্টেম্বর-অক্টোবর)',
      'harvestTime': 'ডিসেম্বর-মার্চ\n(জানুয়ারি-মার্চ)',
      'duration': '২-৩ মাস',
    },
    {
      'name': 'বেগুন',
      'icon': '🍆',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'অক্টোবর-নভেম্বর\n(আগস্ট-অক্টোবর)',
      'harvestTime': 'ডিসেম্বর-মার্চ\n(ডিসেম্বর-মার্চ)',
      'duration': '৩ মাস',
    },
    {
      'name': 'মরিচ',
      'icon': '🌶️',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'সেপ্টেম্বর-অক্টোবর',
      'harvestTime': 'ডিসেম্বর-মার্চ',
      'duration': '৩-৪ মাস',
    },
    {
      'name': 'লাউ',
      'icon': '🥬',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'আশ্বিন-কার্তিক\n(সেপ্টেম্বর-অক্টোবর)',
      'harvestTime': 'ফেব্রুয়ারি-মার্চ',
      'duration': '৩-৪ মাস',
    },
    {
      'name': 'মিষ্টি কুমড়া',
      'icon': '🎃',
      'season': 'খরিফ',
      'seasonColor': 0xFF2E7D32,
      'filter': 'খরিফ',
      'plantTime': 'ফেব্রুয়ারি-মার্চ\n(ফেব্রুয়ারি-মার্চ)',
      'harvestTime': 'মে-জুন\n(জুন-জুলাই)',
      'duration': '৩-৪ মাস',
    },
    // ─── তেলবীজ ─────────────────────────────────────────────────
    {
      'name': 'সরিষা',
      'icon': '🌿',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'অক্টোবর-নভেম্বর',
      'harvestTime': 'জানুয়ারি-ফেব্রুয়ারি',
      'duration': '৩ মাস',
    },
    // ─── ডাল ────────────────────────────────────────────────────
    {
      'name': 'মসুর ডাল',
      'icon': '🫘',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'অক্টোবর-নভেম্বর\n(আগস্ট-নভেম্বর)',
      'harvestTime': 'ফেব্রুয়ারি-মার্চ\n(ফেব্রুয়ারি-মার্চ)',
      'duration': '৩ মাস',
    },
    {
      'name': 'ছোলা',
      'icon': '🫘',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'অক্টোবর-নভেম্বর',
      'harvestTime': 'ফেব্রুয়ারি-মার্চ',
      'duration': '৩-৪ মাস',
    },
    // ─── নগদ ফসল ────────────────────────────────────────────────
    {
      'name': 'পাট',
      'icon': '🌿',
      'season': 'খরিফ',
      'seasonColor': 0xFF2E7D32,
      'filter': 'খরিফ',
      'plantTime': 'মার্চ-মে',
      'harvestTime': 'জুলাই-আগস্ট',
      'duration': '৩-৪ মাস',
    },
    // ─── শীত সবজি ───────────────────────────────────────────────
    {
      'name': 'ফুলকপি',
      'icon': '🥦',
      'season': 'শীত',
      'seasonColor': 0xFF00838F,
      'filter': 'শীত',
      'plantTime': 'সেপ্টেম্বর-অক্টোবর',
      'harvestTime': 'ডিসেম্বর-ফেব্রুয়ারি',
      'duration': '২-৩ মাস',
    },
    {
      'name': 'বাঁধাকপি',
      'icon': '🥬',
      'season': 'শীত',
      'seasonColor': 0xFF00838F,
      'filter': 'শীত',
      'plantTime': 'সেপ্টেম্বর-অক্টোবর',
      'harvestTime': 'ডিসেম্বর-ফেব্রুয়ারি',
      'duration': '২-৩ মাস',
    },
    {
      'name': 'শিম',
      'icon': '🫛',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'সেপ্টেম্বর-অক্টোবর',
      'harvestTime': 'নভেম্বর-ফেব্রুয়ারি',
      'duration': '২-৩ মাস',
    },
    // ─── গ্রীষ্ম / খরিফ ─────────────────────────────────────────
    {
      'name': 'তিল',
      'icon': '🌿',
      'season': 'খরিফ',
      'seasonColor': 0xFF2E7D32,
      'filter': 'খরিফ',
      'plantTime': 'মার্চ-এপ্রিল',
      'harvestTime': 'জুন-জুলাই',
      'duration': '৩-৪ মাস',
    },
    {
      'name': 'মুগ ডাল',
      'icon': '🫘',
      'season': 'খরিফ',
      'seasonColor': 0xFF2E7D32,
      'filter': 'খরিফ',
      'plantTime': 'মার্চ-এপ্রিল',
      'harvestTime': 'জুন-জুলাই',
      'duration': '৩ মাস',
    },
    {
      'name': 'ঢেঁড়স',
      'icon': '🌱',
      'season': 'গ্রীষ্ম',
      'seasonColor': 0xFFE65100,
      'filter': 'গ্রীষ্ম',
      'plantTime': 'ফেব্রুয়ারি-মার্চ\n(মার্চ-এপ্রিল)',
      'harvestTime': 'মে-আগস্ট\n(জুন-আগস্ট)',
      'duration': '৩-৪ মাস',
    },
    {
      'name': 'করলা',
      'icon': '🌿',
      'season': 'গ্রীষ্ম',
      'seasonColor': 0xFFE65100,
      'filter': 'গ্রীষ্ম',
      'plantTime': 'ফেব্রুয়ারি-মার্চ',
      'harvestTime': 'মে-জুলাই',
      'duration': '৩-৪ মাস',
    },
    {
      'name': 'চিনাবাদাম',
      'icon': '🥜',
      'season': 'খরিফ',
      'seasonColor': 0xFF2E7D32,
      'filter': 'খরিফ',
      'plantTime': 'এপ্রিল-মে',
      'harvestTime': 'আগস্ট-সেপ্টেম্বর',
      'duration': '৪ মাস',
    },
    {
      'name': 'সয়াবিন',
      'icon': '🌿',
      'season': 'খরিফ',
      'seasonColor': 0xFF2E7D32,
      'filter': 'খরিফ',
      'plantTime': 'জুন-জুলাই',
      'harvestTime': 'অক্টোবর-নভেম্বর',
      'duration': '৪-৫ মাস',
    },
    {
      'name': 'সূর্যমুখী',
      'icon': '🌻',
      'season': 'রবি',
      'seasonColor': 0xFFF9A825,
      'filter': 'রবি',
      'plantTime': 'নভেম্বর-ডিসেম্বর',
      'harvestTime': 'মার্চ-এপ্রিল',
      'duration': '৩-৪ মাস',
    },
    {
      'name': 'আখ',
      'icon': '🎋',
      'season': 'গ্রীষ্ম',
      'seasonColor': 0xFFE65100,
      'filter': 'গ্রীষ্ম',
      'plantTime': 'ফেব্রুয়ারি-এপ্রিল',
      'harvestTime': 'ডিসেম্বর-ফেব্রুয়ারি',
      'duration': '১০-১২ মাস',
    },
    {
      'name': 'তরমুজ',
      'icon': '🍉',
      'season': 'গ্রীষ্ম',
      'seasonColor': 0xFFE65100,
      'filter': 'গ্রীষ্ম',
      'plantTime': 'ডিসেম্বর-জানুয়ারি',
      'harvestTime': 'মার্চ-এপ্রিল',
      'duration': '৩-৪ মাস',
    },
    {
      'name': 'শসা',
      'icon': '🥒',
      'season': 'গ্রীষ্ম',
      'seasonColor': 0xFFE65100,
      'filter': 'গ্রীষ্ম',
      'plantTime': 'ফেব্রুয়ারি-মার্চ',
      'harvestTime': 'এপ্রিল-জুন',
      'duration': '২-৩ মাস',
    },
    {
      'name': 'গাজর',
      'icon': '🥕',
      'season': 'শীত',
      'seasonColor': 0xFF00838F,
      'filter': 'শীত',
      'plantTime': 'অক্টোবর-নভেম্বর',
      'harvestTime': 'জানুয়ারি-ফেব্রুয়ারি',
      'duration': '৩ মাস',
    },
    {
      'name': 'মুলা',
      'icon': '🥬',
      'season': 'শীত',
      'seasonColor': 0xFF00838F,
      'filter': 'শীত',
      'plantTime': 'অক্টোবর-ডিসেম্বর',
      'harvestTime': 'ডিসেম্বর-ফেব্রুয়ারি',
      'duration': '২-৩ মাস',
    },
  ];

  List<Map<String, dynamic>> get _filtered => _filter == 'সব'
      ? List.from(_crops)
      : _crops.where((c) => c['filter'] == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return Column(
      children: [
        // ─── Header ────────────────────────────────────────────
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1B5E20), Color(0xFF27A745), Color(0xFF43A047)],
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: const Column(
            children: [
              Text(
                '🗓 ফসলের ক্যালেন্ডার',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                ),
              ),
              SizedBox(height: 4),
              Text(
                'বিভিন্ন ফসলের বপন ও কাটার সময়সূচি জানুন',
                style: TextStyle(color: Colors.white70, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        // ─── Season Filters ─────────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((f) {
                final sel = _filter == f['key'];
                return GestureDetector(
                  onTap: () => setState(() => _filter = f['key']!),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: sel ? const Color(0xFF27A745) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFF27A745),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      f['label']!,
                      style: TextStyle(
                        color: sel ? Colors.white : const Color(0xFF27A745),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // ─── Crop Grid ──────────────────────────────────────────
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.search_off, color: Colors.white38, size: 52),
                      SizedBox(height: 12),
                      Text(
                        'কোনো ফসল পাওয়া যায়নি',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                    ],
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final crossAxisCount = width < 360 ? 2 : 3;
                    final childAspectRatio = crossAxisCount == 2
                        ? 0.80
                        : (width < 420 ? 0.56 : 0.62);

                    return GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (ctx, i) => _CropCard(crop: filtered[i]),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// ─── Crop Card ─────────────────────────────────────────────────────────────────

class _CropCard extends StatelessWidget {
  final Map<String, dynamic> crop;
  const _CropCard({required this.crop});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card Header ─────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(8, 8, 6, 8),
            decoration: const BoxDecoration(
              color: Color(0xFF1B5E20),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      crop['icon'] as String,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        crop['name'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Color(crop['seasonColor'] as int),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    crop['season'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ── Info Rows ────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _infoRow(
                    Icons.calendar_today_outlined,
                    'চাষের সময়',
                    crop['plantTime'] as String,
                  ),
                  _infoRow(
                    Icons.content_cut_outlined,
                    'কাটার সময়',
                    crop['harvestTime'] as String,
                  ),
                  _infoRow(
                    Icons.access_time_outlined,
                    'সময়কাল',
                    crop['duration'] as String,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(icon, color: Colors.white, size: 9),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// end of file
