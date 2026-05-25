import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Buyer Crop Card ──────────────────────────────────────────────────────────

class BuyerCropCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;
  final bool isExpanded;
  final VoidCallback onToggle;
  const BuyerCropCard({
    super.key,
    required this.data,
    required this.docId,
    required this.isExpanded,
    required this.onToggle,
  });

  Future<void> _callPhone(BuildContext context, String phone) async {
    await Clipboard.setData(ClipboardData(text: phone));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.phone, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text('নম্বর কপি হয়েছে: $phone'),
          ],
        ),
        backgroundColor: const Color(0xFF27A745),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _normalizedPhone(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('880')) return digits;
    if (digits.startsWith('0')) return '88$digits';
    if (digits.length == 10 || digits.length == 11) return '88$digits';
    return digits;
  }

  Future<void> _openWhatsApp(BuildContext context, String phone) async {
    final waNumber = _normalizedPhone(phone);
    final uri = Uri.parse('https://wa.me/$waNumber');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      await _callPhone(context, phone);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('WhatsApp খোলা যায়নি, নম্বর কপি করা হয়েছে'),
          backgroundColor: const Color(0xFF1565C0),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _showContactOptions(BuildContext context, String phone) async {
    final waLink = 'wa.me/${_normalizedPhone(phone)}';
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        backgroundColor: const Color(0xFFEFF3F8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFF9BB3ED), width: 2),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE8E9FF),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6F50E9).withOpacity(0.35),
                      blurRadius: 16,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.call,
                  color: Color(0xFF6F50E9),
                  size: 34,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'আপনার যোগাযোগ বিকল্প',
                style: TextStyle(
                  color: Color(0xFF1B2B85),
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E4F2),
                  borderRadius: BorderRadius.circular(14),
                  border: const Border(
                    left: BorderSide(color: Color(0xFF6F50E9), width: 4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.whatshot,
                          color: Color(0xFF25D366),
                          size: 19,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'WhatsApp:',
                          style: TextStyle(
                            color: Color(0xFF1B2B85),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Text(
                        waLink,
                        style: const TextStyle(
                          color: Color(0xFF037A68),
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.call,
                          color: Color(0xFF6F50E9),
                          size: 19,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'ফোন নম্বর:',
                          style: TextStyle(
                            color: Color(0xFF1B2B85),
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: Text(
                        phone,
                        style: const TextStyle(
                          color: Color(0xFF027A72),
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'নিচের বাটন ব্যবহার করে যোগাযোগ করুন',
                style: TextStyle(
                  color: Color(0xFF5E6369),
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        Navigator.of(dialogContext).pop();
                        await _openWhatsApp(context, phone);
                      },
                      icon: const Icon(Icons.chat, size: 18),
                      label: const Text(
                        'এখনই চ্যাট করুন',
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF26C95F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 7,
                        shadowColor: const Color(0x5526C95F),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await _callPhone(context, phone);
                      },
                      icon: const Icon(Icons.copy, size: 18),
                      label: const Text(
                        'নম্বর কপি করুন',
                        textAlign: TextAlign.center,
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF6F50E9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 7,
                        shadowColor: const Color(0x556F50E9),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('বন্ধ করুন'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFFE95A73),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0x55E95A73),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(dynamic ts) {
    if (ts == null) return '';
    if (ts is Timestamp) {
      final d = ts.toDate();
      final months = [
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
      return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} ${d.hour < 12 ? 'AM' : 'PM'}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final phone = data['farmerPhone'] ?? '';
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xE6EAF3FF),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      shadowColor: const Color(0x55274B7A),
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
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                        color: Color(0xFF1B1B1B),
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
                    color: const Color(0xFF27A745),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'সক্রিয়',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            BuyerInfoRow(
              icon: Icons.scale,
              color: Colors.blueGrey,
              text: 'পরিমাণ: ${data['quantity']} ${data['unit']}',
            ),
            const SizedBox(height: 4),
            BuyerInfoRow(
              icon: Icons.currency_exchange,
              color: const Color(0xFF27A745),
              text: 'দাম: ৳${data['price']}/${data['unit']}',
              bold: true,
            ),
            if ((data['location'] ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              BuyerInfoRow(
                icon: Icons.location_on,
                color: Colors.red,
                text: 'এলাকা: ${data['location']}',
              ),
            ],
            if ((data['farmerName'] ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              BuyerInfoRow(
                icon: Icons.person,
                color: const Color(0xFF1565C0),
                text: 'কৃষক: ${data['farmerName']}',
              ),
            ],
            if ((data['description'] ?? '').isNotEmpty) ...[
              const SizedBox(height: 4),
              BuyerInfoRow(
                icon: Icons.info_outline,
                color: Colors.orange,
                text: data['description'],
              ),
            ],
            const SizedBox(height: 12),
            if (phone.isNotEmpty)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showContactOptions(context, phone),
                  icon: const Icon(Icons.phone, color: Colors.white, size: 18),
                  label: Text(
                    'যোগাযোগ করুন: $phone',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF27A745),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isExpanded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        const Text(
                          'বিস্তারিত তথ্য',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                        const SizedBox(height: 6),
                        if ((data['description'] ?? '').isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xDDF4FAFF),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0x99BCD7EE),
                              ),
                            ),
                            child: Text(
                              'বিবরণ: ${data['description']}',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          'পোস্ট করা হয়েছে: ${_formatDate(data['createdAt'])}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
            Center(
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailedCropPage(data: data),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.open_in_full,
                  size: 18,
                  color: Color(0xFF1565C0),
                ),
                label: const Text(
                  'বিস্তারিত পেজ খুলুন',
                  style: TextStyle(color: Color(0xFF1565C0), fontSize: 13),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Info Row ─────────────────────────────────────────────────────────────────

class BuyerInfoRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final bool bold;
  const BuyerInfoRow({
    super.key,
    required this.icon,
    required this.color,
    required this.text,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: bold ? color : Colors.black87,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Filter Field ─────────────────────────────────────────────────────────────

class BuyerFilterField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  const BuyerFilterField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white70, size: 18),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white60, fontSize: 13),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }
}

// ─── Buyer Stat Card ──────────────────────────────────────────────────────────

class BuyerStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final List<Color> gradient;
  const BuyerStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white54, size: 32),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Detailed Crop Page ──────────────────────────────────────────────────────────

class DetailedCropPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailedCropPage({super.key, required this.data});

  String _formatDate(dynamic ts) {
    if (ts == null) return '';
    if (ts is Timestamp) {
      final d = ts.toDate();
      final months = [
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
      return '${d.day.toString().padLeft(2, '0')} ${months[d.month - 1]} ${d.year}, ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')} ${d.hour < 12 ? 'AM' : 'PM'}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF27A745)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              title: Text(
                data['cropName'] ?? 'ফসলের বিস্তারিত',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF27A745).withOpacity(0.15),
                    ),
                    child: const Icon(
                      Icons.grass,
                      color: Color(0xFF27A745),
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    data['cropName'] ?? '',
                    style: const TextStyle(
                      color: Color(0xFF0D3B66),
                      fontWeight: FontWeight.w900,
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  // পরিমাণ, দাম, এলাকা সেকশন
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7E8F5),
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        left: BorderSide(color: Color(0xFF1565C0), width: 5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.scale,
                              color: Color(0xFF0D3B66),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'পরিমাণ: ${data['quantity']} ${data['unit']}',
                              style: const TextStyle(
                                color: Color(0xFF0D3B66),
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.currency_exchange,
                              color: Color(0xFF27A745),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'দাম: ৳${data['price']}/${data['unit']}',
                              style: const TextStyle(
                                color: Color(0xFF27A745),
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        if ((data['location'] ?? '').isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'এলাকা: ${data['location']}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // কৃষক, ফোন সেকশন
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD7F4DD),
                      borderRadius: BorderRadius.circular(12),
                      border: const Border(
                        left: BorderSide(color: Color(0xFF27A745), width: 5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if ((data['farmerName'] ?? '').isNotEmpty) ...[
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Color(0xFF0D5D1A),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'কৃষক: ${data['farmerName']}',
                                style: const TextStyle(
                                  color: Color(0xFF0D5D1A),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                        if ((data['farmerPhone'] ?? '').isNotEmpty)
                          Row(
                            children: [
                              const Icon(
                                Icons.phone,
                                color: Color(0xFF0D5D1A),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'যোগাযোগ: ${data['farmerPhone']}',
                                style: const TextStyle(
                                  color: Color(0xFF0D5D1A),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // বিবরণ সেকশন
                  if ((data['description'] ?? '').isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5E0F5),
                        borderRadius: BorderRadius.circular(12),
                        border: const Border(
                          left: BorderSide(color: Color(0xFFE95A73), width: 5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.description,
                                color: Color(0xFF8B1538),
                                size: 20,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'বিবরণ:',
                                style: TextStyle(
                                  color: Color(0xFF8B1538),
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              data['description'] ?? '',
                              style: const TextStyle(
                                color: Color(0xFF8B1538),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 14),
                  // পোস্ট তারিখ
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'পোস্ট করা হয়েছে: ${_formatDate(data['createdAt'])}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Price Chip ───────────────────────────────────────────────────────────────

class BuyerPriceChip extends StatelessWidget {
  final String label;
  final String price;
  final Color color;
  const BuyerPriceChip({
    super.key,
    required this.label,
    required this.price,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        '$label: $price',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
