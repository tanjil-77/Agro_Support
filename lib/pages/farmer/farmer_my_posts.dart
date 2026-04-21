import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerMyPostsPage extends StatelessWidget {
  final String uid;
  final Function(int)? onNavigate;
  const FarmerMyPostsPage({super.key, required this.uid, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Column(
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.list_alt, color: Colors.white, size: 18),
                  ),
                  SizedBox(width: 12),
                  Text(
                    'আমার ফসল পোস্ট',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => onNavigate?.call(1),
                icon: const Icon(Icons.add, size: 16, color: Colors.white),
                label: const Text(
                  'নতুন পোস্ট',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white38),
                  ),
                ),
              ),
            ],
          ),
        ),

        // ─── List ──────────────────────────────────────────────────
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('crops')
                .where('farmerId', isEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'সমস্যা হয়েছে:\n${snapshot.error}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              final docs = List.of(snapshot.data?.docs ?? []);
              // sort client-side (newest first)
              docs.sort((a, b) {
                final aT = (a.data() as Map<String, dynamic>)['createdAt'];
                final bT = (b.data() as Map<String, dynamic>)['createdAt'];
                if (aT == null) return 1;
                if (bT == null) return -1;
                return (bT as Timestamp).compareTo(aT as Timestamp);
              });

              if (docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox_outlined,
                        size: 64,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'এখনো কোনো পোস্ট নেই',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'নতুন পোস্ট যোগ করতে উপরের বাটন চাপুন',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: docs.length,
                itemBuilder: (ctx, i) {
                  final d = docs[i].data() as Map<String, dynamic>;
                  return _GlassPostCard(
                    data: d,
                    docId: docs[i].id,
                    index: i + 1,
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

// ─── Glass Post Card ──────────────────────────────────────────────────────────

class _GlassPostCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;
  final int index;
  const _GlassPostCard({
    required this.data,
    required this.docId,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final status = data['status'] ?? 'active';
    final isActive = status == 'active';
    final createdAt = data['createdAt'];
    String dateStr = '';
    if (createdAt is Timestamp) {
      final dt = createdAt.toDate();
      dateStr =
          '${dt.day.toString().padLeft(2, '0')} ${_month(dt.month)} ${dt.year}';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF27A745).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Colored top banner ────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isActive
                    ? [const Color(0xFF1B5E20), const Color(0xFF27A745)]
                    : [Colors.grey.shade700, Colors.grey.shade500],
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.grass, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      data['cropName'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white38),
                  ),
                  child: Text(
                    isActive ? 'সক্রিয়' : 'বিক্রিত',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Info body ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: [
                    _info(Icons.scale, '${data['quantity']} ${data['unit']}'),
                    _info(
                      Icons.currency_exchange,
                      '৳${data['price']}/${data['unit']}',
                      highlight: true,
                    ),
                    if ((data['location'] ?? '').toString().isNotEmpty)
                      _info(Icons.location_on, data['location']),
                    if (dateStr.isNotEmpty)
                      _info(Icons.calendar_today, dateStr),
                    if ((data['farmerPhone'] ?? '').toString().isNotEmpty)
                      _info(Icons.phone, data['farmerPhone']),
                  ],
                ),
                if ((data['description'] ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      data['description'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF444444),
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFE0E0E0)),
                const SizedBox(height: 10),

                // ── Action Buttons ────────────────────────────
                Row(
                  children: [
                    // Edit
                    Expanded(
                      child: _actionBtn(
                        icon: Icons.edit_outlined,
                        label: 'এডিট',
                        color: const Color(0xFF1976D2),
                        onTap: () => _showEditDialog(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Toggle status
                    Expanded(
                      child: _actionBtn(
                        icon: isActive ? Icons.check_circle : Icons.refresh,
                        label: isActive ? 'বিক্রিত' : 'সক্রিয়',
                        color: isActive
                            ? const Color(0xFF7B61FF)
                            : const Color(0xFF27A745),
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection('crops')
                              .doc(docId)
                              .update({'status': isActive ? 'sold' : 'active'});
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Delete
                    _actionBtn(
                      icon: Icons.delete_outline,
                      label: 'মুছুন',
                      color: Colors.redAccent,
                      onTap: () => _confirmDelete(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _info(IconData icon, dynamic val, {bool highlight = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: highlight ? const Color(0xFF27A745) : const Color(0xFF666666),
        ),
        const SizedBox(width: 4),
        Text(
          val.toString(),
          style: TextStyle(
            fontSize: 13,
            color: highlight
                ? const Color(0xFF27A745)
                : const Color(0xFF333333),
            fontWeight: highlight ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final qtyCtrl = TextEditingController(text: '${data['quantity'] ?? ''}');
    final priceCtrl = TextEditingController(text: '${data['price'] ?? ''}');
    final locCtrl = TextEditingController(text: data['location'] ?? '');
    final phoneCtrl = TextEditingController(text: data['farmerPhone'] ?? '');
    final descCtrl = TextEditingController(text: data['description'] ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 14),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF27A745)],
            ),
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Row(
            children: [
              const Icon(Icons.edit, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                '${data['cropName']} এডিট করুন',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                _editField(
                  qtyCtrl,
                  'পরিমাণ',
                  Icons.scale,
                  TextInputType.number,
                  true,
                ),
                const SizedBox(height: 10),
                _editField(
                  priceCtrl,
                  'দাম (টাকা)',
                  Icons.currency_exchange,
                  TextInputType.number,
                  true,
                ),
                const SizedBox(height: 10),
                _editField(
                  locCtrl,
                  'এলাকা/স্থান',
                  Icons.location_on,
                  TextInputType.text,
                  true,
                ),
                const SizedBox(height: 10),
                _editField(
                  phoneCtrl,
                  'ফোন নম্বর',
                  Icons.phone,
                  TextInputType.phone,
                  false,
                ),
                const SizedBox(height: 10),
                _editField(
                  descCtrl,
                  'বিবরণ (ঐচ্ছিক)',
                  Icons.notes,
                  TextInputType.text,
                  false,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(context);
              await FirebaseFirestore.instance
                  .collection('crops')
                  .doc(docId)
                  .update({
                    'quantity':
                        double.tryParse(qtyCtrl.text.trim()) ??
                        data['quantity'],
                    'price':
                        double.tryParse(priceCtrl.text.trim()) ?? data['price'],
                    'location': locCtrl.text.trim(),
                    'farmerPhone': phoneCtrl.text.trim(),
                    'description': descCtrl.text.trim(),
                  });
            },
            icon: const Icon(Icons.save, size: 16, color: Colors.white),
            label: const Text(
              'সেভ করুন',
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF27A745),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _editField(
    TextEditingController ctrl,
    String label,
    IconData icon,
    TextInputType type,
    bool required, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      maxLines: maxLines,
      validator: required
          ? (v) => (v == null || v.trim().isEmpty) ? '$label দিন' : null
          : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF27A745), size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF27A745), width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'পোস্ট মুছবেন?',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text('এই পোস্টটি স্থায়ীভাবে মুছে যাবে।'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('বাতিল'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await FirebaseFirestore.instance
                  .collection('crops')
                  .doc(docId)
                  .delete();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('মুছুন', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _month(int m) {
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
    return months[m - 1];
  }
}
