import 'dart:ui';

import 'package:flutter/material.dart';

class FarmerCropCarePage extends StatefulWidget {
  const FarmerCropCarePage({super.key});

  @override
  State<FarmerCropCarePage> createState() => _FarmerCropCarePageState();
}

class _FarmerCropCarePageState extends State<FarmerCropCarePage> {
  static const String _backgroundAsset = 'lib/pages/image/iot1.jpg';

  static final List<_CropPlan> _plans = [
    _plan(
      crop: 'ধান',
      duration: '১২০-১৫০ দিন',
      land: ['জমি ৬-৮ বার চাষ দিন', 'প্রতি শতকে ৮০-১০০ কেজি জৈব সার দিন'],
      care: [
        '৩০-৩৫ দিনে প্রথম ইউরিয়া টপ ড্রেসিং দিন',
        'জমিতে ২-৪ ইঞ্চি পানি ধরে রাখুন',
      ],
      harvest: [
        'ধানের ৮০% শীষ সোনালি হলে কাটুন',
        'কাটার পর ২-৩ দিন রোদে শুকান',
      ],
      diseases: [
        _Disease(
          name: 'ব্লাস্ট রোগ',
          severity: 'সতর্কতা',
          signs: 'পাতায় ডিম্বাকার দাগ',
          action: 'অনুমোদিত ছত্রাকনাশক স্প্রে করুন',
        ),
        _Disease(
          name: 'শীষ পোড়া',
          severity: 'মাঝারি',
          signs: 'শীষ আংশিক সাদা হয়ে যায়',
          action: 'পটাশ বাড়ান, আক্রান্ত অংশ সরান',
        ),
      ],
    ),
    _plan(
      crop: 'গম',
      duration: '১২০-১৫০ দিন',
      land: ['জমি ঝুরঝুরে করে সমতল করুন', 'সারি দূরত্ব ২০ সেমি রাখুন'],
      care: ['২০-২৫ দিনে প্রথম সেচ দিন', 'আগাছা ২ বার পরিষ্কার করুন'],
      harvest: ['শীষ ও দানা সোনালি হলে কাটুন', 'মাড়াইয়ের আগে ভালোভাবে শুকান'],
      diseases: [
        _Disease(
          name: 'পাতা মরিচা',
          severity: 'সতর্কতা',
          signs: 'পাতায় বাদামি দাগ',
          action: 'প্রয়োজনে ছত্রাকনাশক দিন',
        ),
        _Disease(
          name: 'ব্লাইট',
          severity: 'মাঝারি',
          signs: 'পাতা দ্রুত শুকিয়ে যায়',
          action: 'ঘনবপন কমান, আক্রান্ত অংশ ফেলুন',
        ),
      ],
    ),
    _plan(
      crop: 'আলু',
      duration: '৯০-১২০ দিন',
      land: ['বেড উঁচু করে তৈরি করুন', 'বীজ আলু কেটে ছায়ায় শুকিয়ে নিন'],
      care: ['২০-২৫ দিনে মাটি তুলে দিন', 'কন্দ গঠনের সময় সেচ নিয়মিত দিন'],
      harvest: [
        'গাছ শুকাতে শুরু করলে সেচ বন্ধ করুন',
        'খোসা শক্ত হলে উত্তোলন করুন',
      ],
      diseases: [
        _Disease(
          name: 'লেট ব্লাইট',
          severity: 'উচ্চ',
          signs: 'পাতায় পানিভেজা বাদামি দাগ',
          action: 'দ্রুত প্রতিরোধী স্প্রে দিন',
        ),
        _Disease(
          name: 'স্ক্যাব',
          severity: 'মাঝারি',
          signs: 'কন্দে কর্কশ দাগ',
          action: 'সুষম সেচ ও মাটির pH নিয়ন্ত্রণ করুন',
        ),
      ],
    ),
    _plan(
      crop: 'পাট',
      duration: '১২০-১৫০ দিন',
      land: ['ভাল নিষ্কাশনযুক্ত জমি নিন', 'বপনের পরে হালকা সেচ দিন'],
      care: ['১৫-২০ দিনে পাতলা করে দূরত্ব ঠিক করুন', '২ বার নিড়ানি দিন'],
      harvest: ['ফুলের আগে বা শুরুতে কাটুন', 'রেটিং শেষে আঁশ ধুয়ে শুকান'],
      diseases: [
        _Disease(
          name: 'গোড়া পচা',
          severity: 'সতর্কতা',
          signs: 'গোড়া নরম হয়ে যায়',
          action: 'পানি জমতে দেবেন না',
        ),
        _Disease(
          name: 'পাতা দাগ',
          severity: 'মাঝারি',
          signs: 'পাতায় অনিয়মিত দাগ',
          action: 'ক্ষেতে বায়ু চলাচল বাড়ান',
        ),
      ],
    ),
    _plan(
      crop: 'আখ',
      duration: '১০-১২ মাস',
      land: ['গভীর চাষ দিয়ে নালা তৈরি করুন', 'সেট ২-৩ চোখসহ ব্যবহার করুন'],
      care: ['মাসভিত্তিক টপ ড্রেসিং দিন', 'আগাছা পরিষ্কার ও মাটি তুলে দিন'],
      harvest: ['কাণ্ড শক্ত ও মিষ্টি হলে কাটুন', 'কাটার পর দ্রুত পরিবহন করুন'],
      diseases: [
        _Disease(
          name: 'রেড রট',
          severity: 'উচ্চ',
          signs: 'কাণ্ডের ভেতর লালচে রং',
          action: 'আক্রান্ত গাছ তুলে ফেলুন',
        ),
        _Disease(
          name: 'স্মাট',
          severity: 'মাঝারি',
          signs: 'চাবুকের মতো কালো অংশ',
          action: 'রোগমুক্ত সেট ব্যবহার করুন',
        ),
      ],
    ),
    _plan(
      crop: 'পেঁয়াজ',
      duration: '৯০-১২০ দিন',
      land: ['উঁচু বেড করুন', 'চারা ১০-১২ সেমি দূরত্বে লাগান'],
      care: ['অতিরিক্ত পানি দেবেন না', 'আগাছা নিয়মিত পরিষ্কার করুন'],
      harvest: [
        'পাতা ভেঙে পড়লে উত্তোলন করুন',
        '২-৩ দিন ছায়ায় শুকিয়ে সংরক্ষণ করুন',
      ],
      diseases: [
        _Disease(
          name: 'পার্পল ব্লচ',
          severity: 'সতর্কতা',
          signs: 'পাতায় বেগুনি দাগ',
          action: 'প্রয়োজনে ছত্রাকনাশক স্প্রে',
        ),
        _Disease(
          name: 'পচন',
          severity: 'মাঝারি',
          signs: 'গোড়া নরম ও দুর্গন্ধ',
          action: 'ড্রেনেজ ঠিক রাখুন',
        ),
      ],
    ),
    _plan(
      crop: 'টমেটো',
      duration: '৭০-৯০ দিন',
      land: ['চারা ৪৫-৬০ সেমি দূরত্বে লাগান', 'খুঁটি দিয়ে সাপোর্ট দিন'],
      care: ['ফুলে পটাশ দিন', 'ডাল ছাঁটাই করে আলো-বাতাস দিন'],
      harvest: ['আধাপাকা অবস্থায় সংগ্রহ করুন', 'বাছাই করে ক্রেটে রাখুন'],
      diseases: [
        _Disease(
          name: 'আর্লি ব্লাইট',
          severity: 'সতর্কতা',
          signs: 'পাতায় বৃত্তাকার দাগ',
          action: 'কপারভিত্তিক স্প্রে দিন',
        ),
        _Disease(
          name: 'ফল পচা',
          severity: 'মাঝারি',
          signs: 'ফলে কালো/বাদামি পচন',
          action: 'ক্ষেত শুকনা রাখুন',
        ),
      ],
    ),
    _plan(
      crop: 'ভুট্টা',
      duration: '১০০-১২০ দিন',
      land: ['সারি দূরত্ব ৬০ সেমি রাখুন', 'বপনের সময় বেসাল সার দিন'],
      care: ['৩০ ও ৫০ দিনে ইউরিয়া দিন', 'মোচা আসার আগে সেচ দিন'],
      harvest: ['দানা শক্ত হলে সংগ্রহ করুন', 'ভালোভাবে শুকিয়ে সংরক্ষণ করুন'],
      diseases: [
        _Disease(
          name: 'ডাউনি মিলডিউ',
          severity: 'সতর্কতা',
          signs: 'পাতায় হলুদ ডোরা',
          action: 'রোগমুক্ত বীজ ব্যবহার করুন',
        ),
        _Disease(
          name: 'স্টেম বোরার',
          severity: 'মাঝারি',
          signs: 'কাণ্ডে ছিদ্র',
          action: 'ফেরোমন ট্র্যাপ ব্যবহার করুন',
        ),
      ],
    ),
    _plan(
      crop: 'সরিষা',
      duration: '৮০-৯০ দিন',
      land: ['সারি দূরত্ব ২৫-৩০ সেমি রাখুন', 'বপনের পরে হালকা সেচ দিন'],
      care: ['ফুলের সময় আর্দ্রতা বজায় রাখুন', 'ক্ষেতে পানি জমতে দেবেন না'],
      harvest: ['৭০-৮০% শুঁটি হলদে হলে কাটুন', 'মাড়াইয়ের আগে শুকান'],
      diseases: [
        _Disease(
          name: 'অল্টারনারিয়া ব্লাইট',
          severity: 'সতর্কতা',
          signs: 'পাতা/শুঁটিতে কালো দাগ',
          action: 'সময়মতো ছত্রাকনাশক দিন',
        ),
        _Disease(
          name: 'এফিড',
          severity: 'মাঝারি',
          signs: 'কচি অংশে পোকার দল',
          action: 'জৈব বা অনুমোদিত কীটনাশক ব্যবহার করুন',
        ),
      ],
    ),
    _plan(
      crop: 'মসুর ডাল',
      duration: '১০০-১১০ দিন',
      land: ['সুষম সার দিয়ে বপন করুন', 'জমি সমতল রাখুন'],
      care: ['অতিরিক্ত সেচ দেবেন না', 'আগাছা ১-২ বার পরিষ্কার করুন'],
      harvest: [
        'গাছের বেশিরভাগ অংশ হলদে হলে কাটুন',
        'মাড়াই করে শুকনা স্থানে রাখুন',
      ],
      diseases: [
        _Disease(
          name: 'রুট রট',
          severity: 'সতর্কতা',
          signs: 'গোড়া পচে যায়',
          action: 'নিষ্কাশন ভালো রাখুন',
        ),
        _Disease(
          name: 'এফিড',
          severity: 'মাঝারি',
          signs: 'কচি ডগায় পোকা',
          action: 'হালকা সাবান-পানি/অনুমোদিত স্প্রে দিন',
        ),
      ],
    ),
    _plan(
      crop: 'রসুন',
      duration: '১৪০-১৫৫ দিন',
      land: ['কোয়া ৫-৭ সেমি গভীরে লাগান', 'সারি দূরত্ব ১৫-২০ সেমি রাখুন'],
      care: ['হালকা সেচ দিন, পানি জমতে দেবেন না', 'পাতা হলুদ হলে সেচ কমান'],
      harvest: [
        'পাতা শুকাতে শুরু করলে উত্তোলন করুন',
        'ছায়ায় শুকিয়ে সংরক্ষণ করুন',
      ],
      diseases: [
        _Disease(
          name: 'পার্পল ব্লচ',
          severity: 'সতর্কতা',
          signs: 'পাতায় বেগুনি দাগ',
          action: 'প্রতিরোধী স্প্রে ব্যবহার করুন',
        ),
        _Disease(
          name: 'বাল্ব পচা',
          severity: 'মাঝারি',
          signs: 'কন্দ নরম ও পচা',
          action: 'ড্রেনেজ নিশ্চিত করুন',
        ),
      ],
    ),
    _plan(
      crop: 'বেগুন',
      duration: '৭০-৮০ দিন',
      land: ['চারা ৬০ সেমি দূরত্বে লাগান', 'খুঁটি দিয়ে সাপোর্ট দিন'],
      care: ['ফুলে পটাশ দিন', 'ডগা ও আক্রান্ত ফল ছাঁটাই করুন'],
      harvest: ['কচি ও চকচকে ফল সংগ্রহ করুন', 'নিয়মিত তোলা চালিয়ে যান'],
      diseases: [
        _Disease(
          name: 'ডগা ও ফল ছিদ্রকারী',
          severity: 'উচ্চ',
          signs: 'ফলে ছিদ্র ও পচন',
          action: 'আক্রান্ত অংশ তুলে ফেলুন',
        ),
        _Disease(
          name: 'ব্যাকটেরিয়াল উইল্ট',
          severity: 'মাঝারি',
          signs: 'হঠাৎ গাছ নুইয়ে পড়ে',
          action: 'ফসল পর্যায়ক্রম মেনে চলুন',
        ),
      ],
    ),
    _plan(
      crop: 'মরিচ',
      duration: '৮০-৯০ দিন',
      land: ['সুস্থ চারা রোপণ করুন', 'বেড উঁচু রাখুন'],
      care: ['ফুলের সময় সুষম সেচ দিন', 'পোকা নজরদারি বাড়ান'],
      harvest: [
        'বাজার চাহিদা অনুযায়ী কাঁচা/পাকা সংগ্রহ',
        'পরিষ্কার ঝুড়িতে পরিবহন করুন',
      ],
      diseases: [
        _Disease(
          name: 'পাতা কুঁকড়া ভাইরাস',
          severity: 'উচ্চ',
          signs: 'পাতা কুঁকড়ে ছোট হয়',
          action: 'সাদা মাছি দমন করুন',
        ),
        _Disease(
          name: 'অ্যানথ্রাকনোজ',
          severity: 'মাঝারি',
          signs: 'ফলে কালো দাগ',
          action: 'আক্রান্ত ফল অপসারণ করুন',
        ),
      ],
    ),
    _plan(
      crop: 'শিম',
      duration: '৭০-৮০ দিন',
      land: ['মাচা তৈরি করুন', 'জৈব সার মিশিয়ে রোপণ করুন'],
      care: ['ফুলের সময় পটাশ দিন', 'লতা নিয়মিত মাচায় বেঁধে দিন'],
      harvest: ['কচি শিম নিয়মিত তুলুন', 'পরিষ্কার স্থানে গ্রেডিং করুন'],
      diseases: [
        _Disease(
          name: 'পাতা দাগ',
          severity: 'সতর্কতা',
          signs: 'পাতায় বাদামি দাগ',
          action: 'ঘনত্ব কমিয়ে বায়ু চলাচল রাখুন',
        ),
        _Disease(
          name: 'পোড বোরার',
          severity: 'মাঝারি',
          signs: 'শিমে ছিদ্র',
          action: 'ফেরোমন ট্র্যাপ ও সমন্বিত দমন করুন',
        ),
      ],
    ),
    _plan(
      crop: 'পেপে',
      duration: '৯-১০ মাস',
      land: ['উঁচু জমিতে গর্ত করে চারা লাগান', 'গোড়ায় জৈব সার দিন'],
      care: ['মাসিক সুষম সার দিন', 'পানি জমতে দেবেন না'],
      harvest: ['ফলে হালকা হলুদ ভাব এলে তুলুন', 'হাতলিংয়ে আঘাত এড়ান'],
      diseases: [
        _Disease(
          name: 'রিং স্পট ভাইরাস',
          severity: 'উচ্চ',
          signs: 'পাতায় মোজাইক দাগ',
          action: 'আক্রান্ত গাছ তুলে ফেলুন',
        ),
        _Disease(
          name: 'গোড়া পচা',
          severity: 'মাঝারি',
          signs: 'গোড়া নরম',
          action: 'ড্রেনেজ ঠিক করুন',
        ),
      ],
    ),
    _plan(
      crop: 'লাউ',
      duration: '৯০-১০০ দিন',
      land: ['মাচা তৈরি করুন', 'গর্তে পচা গোবর দিন'],
      care: ['লতায় সঠিক দিক নির্দেশনা দিন', 'ফুলের সময় সেচ-সার সমন্বয় করুন'],
      harvest: ['বাজারযোগ্য আকারে ফল সংগ্রহ', 'নিয়মিত তোলায় নতুন ফল আসে'],
      diseases: [
        _Disease(
          name: 'ডাউনি মিলডিউ',
          severity: 'সতর্কতা',
          signs: 'পাতায় হলদে দাগ',
          action: 'পাতা শুকনা রাখুন',
        ),
        _Disease(
          name: 'ফল মাছি',
          severity: 'মাঝারি',
          signs: 'ফলে পচা দাগ',
          action: 'ফাঁদ ব্যবহার করুন',
        ),
      ],
    ),
    _plan(
      crop: 'মিষ্টি কুমড়া',
      duration: '১০০-১২০ দিন',
      land: ['গর্তে জৈব সার মিশিয়ে রোপণ', 'লতা ছড়ানোর জায়গা রাখুন'],
      care: ['ফল ধরার সময় পটাশ দিন', 'লতায় অতিরিক্ত ডগা ছাঁটাই করুন'],
      harvest: ['খোসা শক্ত হলে সংগ্রহ করুন', 'ডাঁটি রেখে কাটুন'],
      diseases: [
        _Disease(
          name: 'পাউডারি মিলডিউ',
          severity: 'সতর্কতা',
          signs: 'পাতায় সাদা গুঁড়া',
          action: 'অনুমোদিত স্প্রে প্রয়োগ করুন',
        ),
        _Disease(
          name: 'ফল পচা',
          severity: 'মাঝারি',
          signs: 'ফলে নরম পচন',
          action: 'মাটি-সংস্পর্শ কমান',
        ),
      ],
    ),
  ];

  String? _selectedCrop;

  @override
  Widget build(BuildContext context) {
    final plan = _selectedCrop == null
        ? null
        : _plans.firstWhere((p) => p.crop == _selectedCrop);

    return Stack(
      children: [
        Positioned.fill(child: _BackgroundLayer()),
        Positioned.fill(
          child: Container(color: Colors.black.withValues(alpha: 0.33)),
        ),
        SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderCard(),
                const SizedBox(height: 10),
                _InfoCard(),
                const SizedBox(height: 10),
                _SelectionCard(
                  plans: _plans,
                  selectedCrop: _selectedCrop,
                  onChanged: (v) {
                    if (v == null) return;
                    setState(() => _selectedCrop = v);
                  },
                ),
                if (plan != null) ...[
                  const SizedBox(height: 12),
                  _PlanBody(plan: plan),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _BackgroundLayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _FarmerCropCarePageState._backgroundAsset,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF164E2A), Color(0xFF081B10)],
          ),
        ),
      ),
    );
  }
}

class _GlassBox extends StatelessWidget {
  final Widget child;
  final Color border;
  final Color fill;
  final EdgeInsetsGeometry padding;

  const _GlassBox({
    required this.child,
    required this.border,
    required this.fill,
    this.padding = const EdgeInsets.all(14),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: fill,
            border: Border.all(color: border),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      border: const Color(0xFF87E0AB),
      fill: const Color(0xCC4ACD89),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.menu_book_rounded,
                color: Colors.white,
                size: 30,
              ),
              const SizedBox(width: 8),
              Text(
                'ফসল পরিচর্যা গাইড',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'প্র্যাকটিক্যাল ধাপে ধাপে নির্দেশনা',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.94),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      border: const Color(0xFF8FD3EA),
      fill: const Color(0xB0255A70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                'কীভাবে ব্যবহার করবেন',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'ফসল নির্বাচন করুন, সময়কাল দেখুন, তারপর ধাপভিত্তিক কাজগুলো মাঠে প্রয়োগ করুন।',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.94),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final List<_CropPlan> plans;
  final String? selectedCrop;
  final ValueChanged<String?> onChanged;

  const _SelectionCard({
    required this.plans,
    required this.selectedCrop,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      border: const Color(0xFF84DCA0),
      fill: const Color(0xB11F6B42),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.spa, color: Color(0xFFB6FFC8), size: 24),
              const SizedBox(width: 6),
              Text(
                'আপনার ফসল নির্বাচন করুন',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFE8FFE8),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: selectedCrop,
            isExpanded: true,
            hint: const Text(
              '-- ফসল বেছে নিন --',
              style: TextStyle(
                color: Color(0xFF21562D),
                fontWeight: FontWeight.w700,
              ),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF85C998),
                  width: 1.3,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF85C998),
                  width: 1.3,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Color(0xFF229953),
                  width: 1.8,
                ),
              ),
            ),
            items: plans
                .map(
                  (p) => DropdownMenuItem<String>(
                    value: p.crop,
                    child: Text(
                      '${p.crop} (সময়কাল: ${p.duration})',
                      style: const TextStyle(
                        color: Color(0xFF21562D),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _PlanBody extends StatelessWidget {
  final _CropPlan plan;

  const _PlanBody({required this.plan});

  @override
  Widget build(BuildContext context) {
    return _GlassBox(
      border: const Color(0xFF8DD6A9),
      fill: const Color(0xD6194127),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF82D69E)),
                ),
                child: Text(
                  '${plan.crop} চাষ পদ্ধতি',
                  style: const TextStyle(
                    color: Color(0xFF2A9B54),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFB7D8C1)),
                ),
                child: Text(
                  'সময়কাল: ${plan.duration}',
                  style: const TextStyle(
                    color: Color(0xFF1D2A1F),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _sectionBar('চাষের ধাপসমূহ'),
          const SizedBox(height: 10),
          _Timeline(stages: plan.stages),
          const SizedBox(height: 12),
          _sectionBar('রোগ ব্যবস্থাপনা'),
          const SizedBox(height: 10),
          ...plan.diseases.map((d) => _DiseaseCard(disease: d)),
        ],
      ),
    );
  }

  Widget _sectionBar(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5BC488), Color(0xFF57CBB2)],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  final List<_Stage> stages;

  const _Timeline({required this.stages});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 14,
          top: 10,
          bottom: 10,
          child: Container(width: 2, color: const Color(0xFF67C789)),
        ),
        Column(
          children: List.generate(stages.length, (i) {
            final stage = stages[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    margin: const EdgeInsets.only(top: 8, right: 10, left: 7),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2AB86E),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: _StageCard(index: i + 1, stage: stage),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _StageCard extends StatelessWidget {
  final int index;
  final _Stage stage;

  const _StageCard({required this.index, required this.stage});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFA7D8B7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF64BD82)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$index. ${stage.title}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFB9BDC3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  stage.days,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...stage.tasks.map(
            (t) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: const Color(0xFFAEDBBE)),
              ),
              child: Text(
                t,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiseaseCard extends StatelessWidget {
  final _Disease disease;

  const _DiseaseCard({required this.disease});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.93),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE6A7A7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE9E9),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFE28F8F)),
                ),
                child: Text(
                  disease.name,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'ঝুঁকি: ${disease.severity}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'লক্ষণ: ${disease.signs}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 5),
          Text(
            'করণীয়: ${disease.action}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

_CropPlan _plan({
  required String crop,
  required String duration,
  required List<String> land,
  required List<String> care,
  required List<String> harvest,
  required List<_Disease> diseases,
}) {
  return _CropPlan(
    crop: crop,
    duration: duration,
    stages: [
      _Stage(title: 'জমি প্রস্তুতি', days: 'বপনের পূর্বে', tasks: land),
      _Stage(
        title: 'বপন/রোপণ ও প্রাথমিক পরিচর্যা',
        days: '০-৪৫ দিন',
        tasks: care,
      ),
      _Stage(title: 'পরিপক্কতা ও সংগ্রহ', days: 'শেষ ধাপ', tasks: harvest),
    ],
    diseases: diseases,
  );
}

class _CropPlan {
  final String crop;
  final String duration;
  final List<_Stage> stages;
  final List<_Disease> diseases;

  const _CropPlan({
    required this.crop,
    required this.duration,
    required this.stages,
    required this.diseases,
  });
}

class _Stage {
  final String title;
  final String days;
  final List<String> tasks;

  const _Stage({required this.title, required this.days, required this.tasks});
}

class _Disease {
  final String name;
  final String severity;
  final String signs;
  final String action;

  const _Disease({
    required this.name,
    required this.severity,
    required this.signs,
    required this.action,
  });
}
