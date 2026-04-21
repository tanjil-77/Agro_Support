import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ─── Page Title ───────────────────────────────────────────────────────────────

class FarmerPageTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const FarmerPageTitle({super.key, required this.icon, required this.title});

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

// ─── Form Field ───────────────────────────────────────────────────────────────

class FarmerFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool required;
  const FarmerFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    required this.hint,
    this.keyboardType,
    this.maxLines = 1,
    this.required = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF333333),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: required
              ? (v) => (v == null || v.trim().isEmpty) ? '$label দিন' : null
              : null,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF27A745), size: 20),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF27A745), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Crop Card ────────────────────────────────────────────────────────────────

class FarmerCropCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;
  final bool showContact;
  final bool showActions;
  final String? farmerId;
  const FarmerCropCard({
    super.key,
    required this.data,
    required this.docId,
    this.showContact = true,
    this.showActions = false,
    this.farmerId,
  });

  @override
  Widget build(BuildContext context) {
    final status = data['status'] ?? 'active';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.grass, color: Color(0xFF27A745), size: 20),
                    const SizedBox(width: 6),
                    Text(
                      data['cropName'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
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
                    color: status == 'active'
                        ? const Color(0xFF27A745)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status == 'active' ? 'সক্রিয়' : 'বিক্রিত',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.scale, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'পরিমাণ: ${data['quantity']} ${data['unit']}',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.currency_exchange,
                  size: 16,
                  color: Color(0xFF27A745),
                ),
                const SizedBox(width: 4),
                Text(
                  '৳${data['price']}/${data['unit']}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF27A745),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            if ((data['location'] ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    data['location'] ?? '',
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ],
            if (showActions) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final newStatus = status == 'active'
                            ? 'sold'
                            : 'active';
                        await FirebaseFirestore.instance
                            .collection('crops')
                            .doc(docId)
                            .update({'status': newStatus});
                      },
                      icon: Icon(
                        status == 'active' ? Icons.sell : Icons.refresh,
                        size: 16,
                      ),
                      label: Text(
                        status == 'active'
                            ? 'বিক্রিত চিহ্নিত করুন'
                            : 'সক্রিয় করুন',
                        style: const TextStyle(fontSize: 12),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF27A745)),
                        foregroundColor: const Color(0xFF27A745),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('crops')
                          .doc(docId)
                          .delete();
                    },
                    icon: const Icon(Icons.delete, size: 16),
                    label: const Text('মুছুন', style: TextStyle(fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
