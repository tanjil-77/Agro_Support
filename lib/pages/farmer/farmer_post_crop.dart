import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'farmer_shared_widgets.dart';

class FarmerPostCropPage extends StatefulWidget {
  final String uid;
  final String farmerName;
  final Function(int)? onNavigate;
  const FarmerPostCropPage({
    super.key,
    required this.uid,
    required this.farmerName,
    this.onNavigate,
  });

  @override
  State<FarmerPostCropPage> createState() => _FarmerPostCropPageState();
}

class _FarmerPostCropPageState extends State<FarmerPostCropPage> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _descController = TextEditingController();
  final _emergencyController = TextEditingController();
  final _whatsappImoController = TextEditingController();
  String _unit = 'কেজি';
  String? _selectedCrop;
  bool _isLoading = false;

  final _units = ['কেজি', 'টন', 'মণ', 'পিস', 'লিটার'];

  final _cropList = [
    {'bn': 'আখ', 'en': 'Sugarcane'},
    {'bn': 'আলু', 'en': 'Potato'},
    {'bn': 'আম', 'en': 'Mango'},
    {'bn': 'ইলিশ', 'en': 'Hilsa Fish'},
    {'bn': 'কলা', 'en': 'Banana'},
    {'bn': 'গম', 'en': 'Wheat'},
    {'bn': 'টমেটো', 'en': 'Tomato'},
    {'bn': 'ধান', 'en': 'Rice'},
    {'bn': 'পাট', 'en': 'Jute'},
    {'bn': 'পেঁয়াজ', 'en': 'Onion'},
    {'bn': 'পেপে', 'en': 'Papaya'},
    {'bn': 'বেগুন', 'en': 'Eggplant'},
    {'bn': 'ভুট্টা', 'en': 'Corn'},
    {'bn': 'মরিচ', 'en': 'Chili'},
    {'bn': 'মসুর ডাল', 'en': 'Lentil'},
    {'bn': 'মিষ্টি কুমড়া', 'en': 'Sweet Pumpkin'},
    {'bn': 'রসুন', 'en': 'Garlic'},
    {'bn': 'শিম', 'en': 'Bean'},
    {'bn': 'সরিষা', 'en': 'Mustard'},
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descController.dispose();
    _emergencyController.dispose();
    _whatsappImoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedCrop == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('অনুগ্রহ করে ফসল নির্বাচন করুন'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await FirebaseFirestore.instance.collection('crops').add({
        'farmerId': widget.uid,
        'farmerName': widget.farmerName,
        'farmerPhone': _emergencyController.text.trim(),
        'emergencyPhone': _emergencyController.text.trim(),
        'whatsappImo': _whatsappImoController.text.trim(),
        'cropName': _selectedCrop,
        'quantity': double.tryParse(_quantityController.text) ?? 0,
        'unit': _unit,
        'price': double.tryParse(_priceController.text) ?? 0,
        'location': _locationController.text.trim(),
        'description': _descController.text.trim(),
        'status': 'active',
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _selectedCrop = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('পোস্ট সফলভাবে তৈরি হয়েছে!'),
            ],
          ),
          backgroundColor: const Color(0xFF27A745),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
        ),
      );
      _quantityController.clear();
      _priceController.clear();
      _locationController.clear();
      _descController.clear();
      _emergencyController.clear();
      _whatsappImoController.clear();
      _formKey.currentState!.reset();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('সমস্যা হয়েছে: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFF1B5E20), Color(0xFF27A745)],
              ),
              border: Border(bottom: BorderSide(color: Colors.white24)),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF27A745),
                  child: Icon(Icons.add_box, color: Colors.white, size: 18),
                ),
                SizedBox(width: 12),
                Text(
                  'নতুন ফসল পোস্ট করুন',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // ─── Tips Card ─────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF1B5E20).withOpacity(0.55),
                        const Color(0xFF2E7D32).withOpacity(0.45),
                        const Color(0xFFB45309).withOpacity(0.30),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.8)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.lightbulb,
                            color: Color(0xFFF5A623),
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'টিপস',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...[
                        'সঠিক ফসল নির্বাচন করুন',
                        'বাজার দর অনুযায়ী দাম নির্ধারণ করুন',
                        'পরিমাণ সঠিকভাবে উল্লেখ করুন',
                        'যোগাযোগ নম্বর চালু রাখুন',
                        'পোস্ট করার পরে ক্রেতারা আপনার সাথে সরাসরি যোগাযোগ করতে পারবেন',
                      ].map(
                        (tip) => Padding(
                          padding: const EdgeInsets.only(bottom: 3),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '• ',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  tip,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // ─── Form Card ─────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF0F5A2A).withOpacity(0.78),
                        const Color(0xFF2E7D32).withOpacity(0.68),
                        const Color(0xFF0F766E).withOpacity(0.55),
                        const Color(0xFF1E40AF).withOpacity(0.30),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.88),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.32),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: const Color(0xFF22C55E).withOpacity(0.18),
                        blurRadius: 30,
                        offset: const Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Crop Dropdown
                          _label(Icons.grass, 'ফসল নির্বাচন করুন'),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            value: _selectedCrop,
                            decoration: _dec(hint: 'ফসল বেছে নিন'),
                            isExpanded: true,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            dropdownColor: const Color(0xFF2E7D32),
                            iconEnabledColor: Colors.white70,
                            items: _cropList
                                .map(
                                  (c) => DropdownMenuItem<String>(
                                    value: c['bn'],
                                    child: Text('${c['bn']} (${c['en']})'),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) => setState(() => _selectedCrop = v),
                            validator: (_) => _selectedCrop == null
                                ? 'ফসল নির্বাচন করুন'
                                : null,
                          ),
                          const SizedBox(height: 14),

                          // Quantity + Unit
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label(Icons.scale, 'পরিমাণ'),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _quantityController,
                                      keyboardType: TextInputType.number,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: _dec(hint: '50'),
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? 'প্রয়োজনীয়'
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label(Icons.balance, 'একক'),
                                    const SizedBox(height: 6),
                                    DropdownButtonFormField<String>(
                                      value: _unit,
                                      decoration: _dec(),
                                      isExpanded: true,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      dropdownColor: const Color(0xFF2E7D32),
                                      iconEnabledColor: Colors.white70,
                                      items: _units
                                          .map(
                                            (u) => DropdownMenuItem(
                                              value: u,
                                              child: Text(u),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (v) =>
                                          setState(() => _unit = v!),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Price
                          _label(Icons.currency_exchange, 'দাম (টাকা)'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: _dec(hint: 'প্রতি $_unit দাম লিখুন'),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'দাম লিখুন' : null,
                          ),
                          const SizedBox(height: 14),

                          // Location
                          _label(Icons.location_on, 'এলাকা/স্থান'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _locationController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _dec(hint: 'যেমন: ঢাকা, ময়মনসিংহ'),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'এলাকা লিখুন' : null,
                          ),
                          const SizedBox(height: 14),

                          _label(Icons.local_hospital, 'জরুরি নম্বর'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _emergencyController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.white),
                            decoration: _dec(hint: '01XXXXXXXXX'),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'নম্বর লিখুন' : null,
                          ),
                          const SizedBox(height: 12),

                          _label(
                            Icons.chat_bubble_outline,
                            'WhatsApp/IMO নম্বর',
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _whatsappImoController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.white),
                            decoration: _dec(hint: '01XXXXXXXXX'),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'নম্বর লিখুন' : null,
                          ),
                          const SizedBox(height: 14),

                          // Description
                          Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                size: 14,
                                color: Colors.white70,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                'বিবরণ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black45,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '(ঐচ্ছিক)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _descController,
                            maxLines: 4,
                            style: const TextStyle(color: Colors.white),
                            decoration: _dec(
                              hint: 'ফসল সম্পর্কে অতিরিক্ত তথ্য',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '* চিহ্নিত ফিল্ডগুলো অবশ্যই পূরণ করতে হবে',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.65),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Submit
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _submit,
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                              label: Text(
                                _isLoading ? 'পোস্ট হচ্ছে...' : '✓ পোস্ট করুন',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF27A745),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // My Posts Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => widget.onNavigate?.call(2),
                              icon: const Icon(
                                Icons.list_alt,
                                color: Colors.white,
                              ),
                              label: const Text(
                                '≡ আমার পোস্ট দেখুন',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                side: const BorderSide(color: Colors.white54),
                                backgroundColor: Colors.indigo.withOpacity(
                                  0.75,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white70),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
          ),
        ),
        const Text(
          ' *',
          style: TextStyle(
            color: Color(0xFFFF6B6B),
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  InputDecoration _dec({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.35)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.white, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.22),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}
