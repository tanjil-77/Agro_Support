import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FarmerKnowledgePage extends StatefulWidget {
  const FarmerKnowledgePage({super.key});

  @override
  State<FarmerKnowledgePage> createState() => _FarmerKnowledgePageState();
}

class _FarmerKnowledgePageState extends State<FarmerKnowledgePage> {
  static const String _bgImageUrl =
      'https://img.freepik.com/premium-photo/smart-agriculture-system-enhancing-farm-productivity_932138-38858.jpg';

  final TextEditingController _searchController = TextEditingController();
  late final Future<List<_KnowledgeTopic>> _topicsFuture;
  String _searchText = '';

  static const List<_TopicSeed> _seeds = [
    _TopicSeed('মাটি ব্যবস্থাপনা', Icons.layers, Color(0xFF9C6B3E), 'মৃত্তিকা'),
    _TopicSeed('পোকামাকড় দমন', Icons.bug_report, Color(0xFFE05260), 'কীটনাশক'),
    _TopicSeed('সেচ ব্যবস্থাপনা', Icons.water_drop, Color(0xFF2F89E5), 'সেচ'),
    _TopicSeed('বীজ সংরক্ষণ', Icons.eco, Color(0xFF42B866), 'বীজ'),
    _TopicSeed(
      'রোগ ব্যবস্থাপনা',
      Icons.health_and_safety,
      Color(0xFFF0C62E),
      'উদ্ভিদ রোগ',
    ),
    _TopicSeed('জৈব চাষাবাদ', Icons.spa, Color(0xFF66BB6A), 'জৈব কৃষি'),
    _TopicSeed(
      'আধুনিক প্রযুক্তি',
      Icons.precision_manufacturing,
      Color(0xFF7E57C2),
      'স্মার্ট কৃষি',
    ),
    _TopicSeed(
      'বাজার ও বিপণন',
      Icons.storefront,
      Color(0xFFF9A825),
      'কৃষি বিপণন',
    ),
    _TopicSeed(
      'ফসল সংগ্রহ ও সংরক্ষণ',
      Icons.inventory_2,
      Color(0xFFE63D82),
      'ফসল সংগ্রহ',
    ),
    _TopicSeed(
      'জলবায়ু পরিবর্তন মোকাবেলা',
      Icons.thermostat,
      Color(0xFFAB47BC),
      'জলবায়ু পরিবর্তন',
    ),
    _TopicSeed('পশুপাখি পালন', Icons.pets, Color(0xFF5C6BC0), 'গবাদি পশু'),
    _TopicSeed('মৎস্য চাষ', Icons.set_meal, Color(0xFF2FB9CC), 'মৎস্য চাষ'),
    _TopicSeed('ফল চাষ', Icons.apple, Color(0xFFF45E57), 'ফল চাষ'),
    _TopicSeed(
      'সবজি চাষ',
      Icons.energy_savings_leaf,
      Color(0xFFFF7043),
      'সবজি চাষ',
    ),
    _TopicSeed('চা ও কফি চাষ', Icons.coffee, Color(0xFF6D5B4B), 'চা চাষ'),
    _TopicSeed(
      'কৃষি প্রশিক্ষণ ও উন্নয়ন',
      Icons.school,
      Color(0xFF42A5F5),
      'কৃষি সম্প্রসারণ',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _topicsFuture = _KnowledgeApiService().fetchTopics(_seeds);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            _bgImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFF9FDF9),
                      Color(0xFFF0F8F2),
                      Color(0xFFE8F3EC),
                    ],
                  ),
                ),
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
                  Colors.white.withOpacity(0.22),
                  Colors.white.withOpacity(0.10),
                  Colors.white.withOpacity(0.04),
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0x5538A169),
                  const Color(0x3342BF88),
                  const Color(0x44FFC34D),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: -70,
          right: -45,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [const Color(0xAA69F0AE), const Color(0x0077FFCC)],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -80,
          left: -50,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [const Color(0x77FFE082), const Color(0x00FFD54F)],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              Expanded(
                child: FutureBuilder<List<_KnowledgeTopic>>(
                  future: _topicsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'তথ্য লোড করা যায়নি। ইন্টারনেট সংযোগ চেক করে আবার চেষ্টা করুন।',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }

                    final all = snapshot.data ?? const <_KnowledgeTopic>[];
                    final filtered = all.where((topic) {
                      if (_searchText.isEmpty) {
                        return true;
                      }
                      final q = _searchText.toLowerCase();
                      return topic.title.toLowerCase().contains(q) ||
                          topic.tips.any(
                            (tip) => tip.toLowerCase().contains(q),
                          );
                    }).toList();

                    if (filtered.isEmpty) {
                      return const Center(
                        child: Text(
                          'এই বিষয়ে কোনো তথ্য পাওয়া যায়নি',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
                      itemCount: filtered.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.15,
                          ),
                      itemBuilder: (context, index) {
                        final topic = filtered[index];
                        return _TopicCard(topic: topic);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xEA0A6C3A), Color(0xEA12A57A), Color(0xEA40C98E)],
        ),
        border: Border.all(color: const Color(0xD9FFFFFF), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E5C3A).withOpacity(0.42),
            blurRadius: 28,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.menu_book, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'জ্ঞান ভান্ডার',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 32,
                  shadows: [Shadow(color: Colors.black38, blurRadius: 2)],
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'কৃষক-বান্ধব ব্যবহারিক টিপস',
            style: TextStyle(
              color: Color(0xFFF2FFF7),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xE6F4FFF8),
            const Color(0xD9DFFFEA),
            const Color(0xCCFFF7E4),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF5EB77E), width: 1.6),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E5C3A).withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() => _searchText = value.trim()),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search, color: Color(0xFF4DAE67)),
          hintText: 'বিষয় অনুসন্ধান করুন...',
          hintStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF4E6557),
          ),
          filled: true,
          fillColor: const Color(0xFAFFFFFF),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(color: Color(0xFF66BB6A), width: 1.4),
          ),
        ),
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  final _KnowledgeTopic topic;

  const _TopicCard({required this.topic});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 8,
      shadowColor: topic.color.withOpacity(0.48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetails(context),
        splashColor: Colors.white.withOpacity(0.12),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.alphaBlend(Colors.white.withOpacity(0.20), topic.color),
                topic.color,
                Color.alphaBlend(Colors.black.withOpacity(0.26), topic.color),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.14),
                blurRadius: 12,
                offset: const Offset(-2, -2),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.34), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white.withOpacity(0.34),
                    child: Icon(topic.icon, color: Colors.white, size: 18),
                  ),
                  const Spacer(),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withOpacity(0.34),
                          Colors.white.withOpacity(0.18),
                        ],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                topic.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFFFFFEF7),
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${topic.tips.length} টি টিপস',
                style: const TextStyle(
                  color: Color(0xFFF9FFF9),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.alphaBlend(Colors.white.withOpacity(0.70), topic.color),
                Color.alphaBlend(Colors.white.withOpacity(0.88), topic.color),
                Colors.white.withOpacity(0.98),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: topic.color.withOpacity(0.28),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 52,
                height: 5,
                decoration: BoxDecoration(
                  color: topic.color.withOpacity(0.38),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: topic.color.withOpacity(0.14),
                  child: Icon(topic.icon, color: topic.color),
                ),
                title: Text(
                  topic.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text('কৃষক-বান্ধব ব্যবহারিক টিপস'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: topic.fromApi
                          ? const Color(0xFFE1F7E6)
                          : const Color(0xFFFFF2DE),
                      border: Border.all(
                        color: topic.fromApi
                            ? const Color(0xFFACE5BA)
                            : const Color(0xFFFFD8A3),
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: topic.color.withOpacity(0.14),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      topic.sourceLabel,
                      style: TextStyle(
                        color: topic.fromApi
                            ? const Color(0xFF167D3F)
                            : const Color(0xFFA06A00),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 10, 14, 18),
                  itemCount: topic.tips.length,
                  itemBuilder: (context, index) {
                    final bandColor = HSLColor.fromColor(
                      topic.color,
                    ).withSaturation(0.78).withLightness(0.38).toColor();
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.98),
                            topic.color.withOpacity(0.16),
                          ],
                        ),
                        border: Border.all(
                          color: topic.color.withOpacity(0.40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: topic.color.withOpacity(0.18),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            width: 4,
                            height: 42,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  bandColor,
                                  Color.alphaBlend(
                                    Colors.black.withOpacity(0.15),
                                    bandColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              '${index + 1}. ${topic.tips[index]}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF202B24),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopicSeed {
  final String title;
  final IconData icon;
  final Color color;
  final String wikiTitle;

  const _TopicSeed(this.title, this.icon, this.color, this.wikiTitle);
}

class _KnowledgeTopic {
  final String title;
  final IconData icon;
  final Color color;
  final List<String> tips;
  final String sourceLabel;
  final bool fromApi;

  const _KnowledgeTopic({
    required this.title,
    required this.icon,
    required this.color,
    required this.tips,
    required this.sourceLabel,
    required this.fromApi,
  });
}

class _KnowledgeApiService {
  static const _summaryUrl =
      'https://bn.wikipedia.org/api/rest_v1/page/summary/';
  static const _searchUrl =
      'https://bn.wikipedia.org/w/api.php?action=query&list=search&format=json&srlimit=1&srsearch=';
  static const _extractUrl =
      'https://bn.wikipedia.org/w/api.php?action=query&prop=extracts&explaintext=1&format=json&titles=';

  Future<List<_KnowledgeTopic>> fetchTopics(List<_TopicSeed> seeds) async {
    final futures = seeds.map(_fetchSingleTopic).toList();
    return Future.wait(futures);
  }

  Future<_KnowledgeTopic> _fetchSingleTopic(_TopicSeed seed) async {
    try {
      final resolvedTitle = await _resolveTitle(seed.wikiTitle);
      if (resolvedTitle == null) {
        return _fallbackTopic(seed);
      }

      final extract = await _fetchDetailedExtract(resolvedTitle);
      if (extract.isEmpty) {
        return _fallbackTopic(seed);
      }

      final practicalTips = _buildPracticalTips(seed.title, extract);
      if (practicalTips.length < 4) {
        return _fallbackTopic(seed);
      }

      return _KnowledgeTopic(
        title: seed.title,
        icon: seed.icon,
        color: seed.color,
        tips: practicalTips,
        sourceLabel: 'কৃষক-বান্ধব ব্যবহারিক টিপস',
        fromApi: true,
      );
    } catch (_) {
      return _fallbackTopic(seed);
    }
  }

  Future<String> _fetchDetailedExtract(String resolvedTitle) async {
    final extractUri = Uri.parse(
      '$_extractUrl${Uri.encodeComponent(resolvedTitle)}',
    );
    final response = await http
        .get(extractUri)
        .timeout(const Duration(seconds: 12));
    if (response.statusCode != 200) {
      return '';
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final queryData = data['query'];
    if (queryData is! Map<String, dynamic>) {
      return '';
    }
    final pages = queryData['pages'];
    if (pages is! Map<String, dynamic> || pages.isEmpty) {
      return '';
    }

    for (final entry in pages.values) {
      if (entry is! Map<String, dynamic>) {
        continue;
      }
      final extract = (entry['extract'] as String?)?.trim() ?? '';
      if (extract.isNotEmpty) {
        return extract;
      }
    }

    return '';
  }

  Future<String?> _resolveTitle(String query) async {
    final url = Uri.parse('$_searchUrl${Uri.encodeComponent(query)}');
    final response = await http.get(url).timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) {
      return null;
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final queryData = data['query'];
    if (queryData is! Map<String, dynamic>) {
      return null;
    }
    final search = queryData['search'];
    if (search is! List || search.isEmpty) {
      return null;
    }
    final first = search.first;
    if (first is! Map<String, dynamic>) {
      return null;
    }

    final title = (first['title'] as String?)?.trim();
    return (title == null || title.isEmpty) ? null : title;
  }

  _KnowledgeTopic _fallbackTopic(_TopicSeed seed) {
    final tips = _fallbackPracticalTips(seed.title);

    return _KnowledgeTopic(
      title: seed.title,
      icon: seed.icon,
      color: seed.color,
      tips: tips,
      sourceLabel: 'কৃষক-বান্ধব ব্যবহারিক টিপস',
      fromApi: false,
    );
  }

  List<String> _buildPracticalTips(String title, String text) {
    final base = _topicPracticalBaseTips(title);
    final dynamic = _extractContextHints(text);

    final merged = <String>[];
    final seen = <String>{};

    for (final item in [...base, ...dynamic]) {
      final tip = item.trim();
      if (tip.isEmpty) {
        continue;
      }
      if (seen.add(tip)) {
        merged.add(tip);
      }
      if (merged.length == 6) {
        break;
      }
    }

    return merged;
  }

  List<String> _extractContextHints(String text) {
    final cleanText = text
        .replaceAll(RegExp(r'\[[^\]]*\]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final segments = cleanText
        .split(RegExp(r'[।!?]+'))
        .map((part) => part.trim())
        .where((part) => part.length >= 25)
        .where((part) => part.length <= 140)
        .where(
          (part) =>
              !part.contains('এই নিবন্ধ') &&
              !part.contains('উইকিপিডিয়া') &&
              !part.contains('তথ্যসূত্র'),
        )
        .toList();

    final hints = <String>[];
    final seen = <String>{};

    for (final segment in segments) {
      final formatted = _toActionableHint(segment);
      if (formatted.isEmpty) {
        continue;
      }
      if (seen.add(formatted)) {
        hints.add(formatted);
      }
      if (hints.length == 2) {
        break;
      }
    }

    return hints;
  }

  String _toActionableHint(String raw) {
    var sentence = raw
        .replaceAll(' ,', ',')
        .replaceAll(' .', '.')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (sentence.isEmpty) {
      return '';
    }

    if (sentence.length > 100) {
      sentence = '${sentence.substring(0, 100).trim()}...';
    }

    return 'মাঠ পর্যায়ে কাজের সময় "$sentence" বিষয়টি মাথায় রেখে সিদ্ধান্ত নিন।';
  }

  List<String> _fallbackPracticalTips(String title) {
    return [
      '$title বিষয়ে কাজ শুরু করার আগে স্থানীয় কৃষি অফিস বা বিশেষজ্ঞের পরামর্শ নিন।',
      '$title বাস্তবায়নে জমি, আবহাওয়া ও খরচ অনুযায়ী ধাপে ধাপে পরিকল্পনা করুন।',
      '$title সংক্রান্ত ইনপুট (বীজ/সার/ঔষধ/পানি) সঠিক ডোজ ও সময়ে ব্যবহার করুন।',
      '$title চর্চায় সমস্যা দেখা দিলে দ্রুত পর্যবেক্ষণ করে সমাধান নিন।',
    ];
  }

  List<String> _topicPracticalBaseTips(String title) {
    switch (title) {
      case 'মাটি ব্যবস্থাপনা':
        return const [
          'চাষের আগে মাটি পরীক্ষা করে pH ৫.৫-৭.০ এর মধ্যে আছে কি না নিশ্চিত করুন।',
          'প্রতি একরে ৪-৬ টন পচা গোবর বা কম্পোস্ট মাটির সাথে মিশিয়ে নিন।',
          'জমিতে পানি জমে থাকলে নালা করে দ্রুত নিষ্কাশনের ব্যবস্থা রাখুন।',
          'একই জমিতে একই ফসল বারবার না দিয়ে ফসল পর্যায়ক্রম অনুসরণ করুন।',
        ];
      case 'পোকামাকড় দমন':
        return const [
          'সপ্তাহে অন্তত ২ দিন জমি পর্যবেক্ষণ করে আক্রান্ত পাতা তুলে ফেলুন।',
          'হলুদ স্টিকি ট্র্যাপ প্রতি শতকে ৩-৪টি বসান।',
          'নিম তেল ৫ মিলি/লিটার পানিতে মিশিয়ে ৭-১০ দিন পরপর স্প্রে করুন।',
          'প্রয়োজনে অনুমোদিত কীটনাশক লেবেল ডোজ মেনে সকাল বা বিকেলে ব্যবহার করুন।',
        ];
      case 'সেচ ব্যবস্থাপনা':
        return const [
          'চারা রোপণের পর হালকা সেচ দিন, এরপর মাটির আর্দ্রতা দেখে সেচ দিন।',
          'বেলে মাটিতে অল্প অল্প করে ঘন ঘন এবং এঁটেল মাটিতে কম ঘন ঘন সেচ দিন।',
          'ড্রিপ বা ফারো সেচ ব্যবহার করে পানি সাশ্রয় করুন।',
          'অতিরিক্ত পানি জমে গেলে দ্রুত বের করে দিন।',
        ];
      case 'বীজ সংরক্ষণ':
        return const [
          'বীজ রোদে শুকিয়ে আর্দ্রতা ১০-১২% এর কাছাকাছি নামিয়ে আনুন।',
          'এয়ারটাইট পাত্রে শুকনো পরিবেশে বীজ সংরক্ষণ করুন।',
          'পোকা রোধে নিমপাতা বা শুকনা মরিচ ব্যবহার করুন।',
          '৩-৪ মাস পরপর অঙ্কুরোদগম পরীক্ষা করে ভালো বীজ আলাদা রাখুন।',
        ];
      case 'রোগ ব্যবস্থাপনা':
        return const [
          'রোগ দেখা দিলে আক্রান্ত অংশ কেটে জমির বাইরে নষ্ট করুন।',
          'গাছের গোড়ায় পানি জমতে দেবেন না, এতে ছত্রাকজনিত রোগ কমে।',
          'বীজ শোধন করে বপন করুন এবং ফসল পর্যায়ক্রম বজায় রাখুন।',
          'প্রয়োজনে কৃষি কর্মকর্তার পরামর্শে নির্দিষ্ট রোগনাশক ব্যবহার করুন।',
        ];
      case 'জৈব চাষাবাদ':
        return const [
          'গোবর সার, কম্পোস্ট ও ভার্মি কম্পোস্ট নিয়মিত প্রয়োগ করুন।',
          'সবুজ সার ফসল চাষ করে মাটিতে মিশিয়ে মাটির উর্বরতা বাড়ান।',
          'নিম নির্যাসের মতো জৈব বালাইনাশক ব্যবহার করুন।',
          'রাসায়নিক ইনপুট ধীরে ধীরে কমিয়ে জৈব ইনপুট বাড়ান।',
        ];
      case 'আধুনিক প্রযুক্তি':
        return const [
          'আবহাওয়ার আপডেট দেখে বপন, সেচ ও স্প্রে সময় নির্ধারণ করুন।',
          'মাটির আর্দ্রতা তথ্যের ভিত্তিতে সেচ দিন।',
          'ড্রিপ সেচ ও মালচিং ব্যবহার করে পানি ও খরচ কমান।',
          'খরচ-লাভ নিয়মিত নোট করে সিদ্ধান্ত নিন।',
        ];
      case 'বাজার ও বিপণন':
        return const [
          'ফসল কাটার আগে বিভিন্ন বাজারের দর যাচাই করুন।',
          'গ্রেডিং করে পণ্য আলাদা প্যাকেজিং করলে দাম বাড়ে।',
          'স্থানীয় পাইকার, হাট ও অনলাইন গ্রুপে সমন্বিতভাবে দর তুলনা করুন।',
          'দলবদ্ধভাবে বিক্রি করলে পরিবহন খরচ কমে।',
        ];
      case 'ফসল সংগ্রহ ও সংরক্ষণ':
        return const [
          'পূর্ণ পরিপক্ব অবস্থায় শুকনা সময়ে ফসল সংগ্রহ করুন।',
          'সংগ্রহের পর ছায়ায় শুকিয়ে পরিষ্কার পাত্রে ভরুন।',
          'সংরক্ষণাগার শুকনো ও বায়ুচলাচলযুক্ত রাখুন।',
          'পচা বা আক্রান্ত ফসল সাথে সাথে আলাদা করুন।',
        ];
      case 'জলবায়ু পরিবর্তন মোকাবেলা':
        return const [
          'খরা সহনশীল ও স্বল্পমেয়াদি জাত নির্বাচন করুন।',
          'মালচিং ও উঁচু বেড ব্যবহার করে আর্দ্রতা ধরে রাখুন।',
          'ভারী বৃষ্টির আগে নালা পরিষ্কার করে পানি নিষ্কাশন নিশ্চিত করুন।',
          'একাধিক ফসল রেখে ঝুঁকি ভাগ করে নিন।',
        ];
      case 'পশুপাখি পালন':
        return const [
          'খামার প্রতিদিন পরিষ্কার ও শুকনা রাখুন।',
          'বয়স অনুযায়ী সুষম খাদ্য ও নিরাপদ পানি দিন।',
          'টিকা ও কৃমিনাশক সময়সূচি মেনে দিন।',
          'অসুস্থ প্রাণী আলাদা করে দ্রুত চিকিৎসা নিন।',
        ];
      case 'মৎস্য চাষ':
        return const [
          'পোনা ছাড়ার আগে পুকুর প্রস্তুত করতে চুন ও সার ব্যবহার করুন।',
          'প্রজাতি অনুযায়ী সঠিক ঘনত্বে পোনা মজুদ করুন।',
          'প্রতিদিন নির্ধারিত মাত্রায় খাদ্য দিন, অতিরিক্ত নয়।',
          'নিয়মিত পানির pH ও দ্রবীভূত অক্সিজেন পরীক্ষা করুন।',
        ];
      case 'ফল চাষ':
        return const [
          'গর্ত প্রস্তুত করে জৈব সার মিশিয়ে চারা রোপণ করুন।',
          'গাছের বয়স অনুযায়ী ছাঁটাই, সেচ ও সার দিন।',
          'ফুল-ফল পর্যায়ে প্রয়োজনীয় অনুপুষ্টি স্প্রে করুন।',
          'ফল মাছি দমনে ফাঁদ ও পরিচ্ছন্নতা বজায় রাখুন।',
        ];
      case 'সবজি চাষ':
        return const [
          'উঁচু বেডে চারা লাগালে পানি জমা কমে ও ফলন ভালো হয়।',
          'রোপণের ৭-১০ দিন পর হালকা টপ ড্রেসিং দিন।',
          'নিয়মিত আগাছা পরিষ্কার ও মাটি আলগা করুন।',
          'পোকা-রোগ দেখামাত্র সমন্বিত বালাই ব্যবস্থাপনা নিন।',
        ];
      case 'চা ও কফি চাষ':
        return const [
          'আংশিক ছায়াযুক্ত এবং পানি নিষ্কাশন ভালো এমন জমি বেছে নিন।',
          'নিয়মিত প্রুনিং করে নতুন কুশি/ডাল গজানো নিশ্চিত করুন।',
          'মালচিং ব্যবহার করে মাটির আর্দ্রতা ধরে রাখুন।',
          'সময়মতো পাতা/চেরি সংগ্রহ ও প্রক্রিয়াজাত করুন।',
        ];
      case 'কৃষি প্রশিক্ষণ ও উন্নয়ন':
        return const [
          'উপজেলা কৃষি অফিসের প্রশিক্ষণে নিয়মিত অংশ নিন।',
          'প্রশিক্ষণে শেখা পদ্ধতি ছোট প্লটে আগে পরীক্ষা করুন।',
          'সফল কৃষকের খামার ভিজিট করে নোট নিন।',
          'মৌসুম শেষে খরচ-লাভ বিশ্লেষণ করে পরের পরিকল্পনা ঠিক করুন।',
        ];
      default:
        return _fallbackPracticalTips(title);
    }
  }
}
