import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ─── District list (bn display, en label, lat/lon for Open-Meteo API) ──────────
const _districts = [
  {'bn': 'ঢাকা', 'en': 'Dhaka', 'lat': '23.8103', 'lon': '90.4125'},
  {'bn': 'চট্টগ্রাম', 'en': 'Chittagong', 'lat': '22.3569', 'lon': '91.7832'},
  {'bn': 'রাজশাহী', 'en': 'Rajshahi', 'lat': '24.3745', 'lon': '88.6042'},
  {'bn': 'খুলনা', 'en': 'Khulna', 'lat': '22.8456', 'lon': '89.5403'},
  {'bn': 'বরিশাল', 'en': 'Barisal', 'lat': '22.7010', 'lon': '90.3535'},
  {'bn': 'সিলেট', 'en': 'Sylhet', 'lat': '24.8949', 'lon': '91.8687'},
  {'bn': 'রংপুর', 'en': 'Rangpur', 'lat': '25.7439', 'lon': '89.2752'},
  {'bn': 'ময়মনসিংহ', 'en': 'Mymensingh', 'lat': '24.7471', 'lon': '90.4203'},
  {'bn': 'কুমিল্লা', 'en': 'Comilla', 'lat': '23.4607', 'lon': '91.1809'},
  {
    'bn': 'নারায়ণগঞ্জ',
    'en': 'Narayanganj',
    'lat': '23.6238',
    'lon': '90.4996',
  },
  {'bn': 'গাজীপুর', 'en': 'Gazipur', 'lat': '23.9999', 'lon': '90.4203'},
  {'bn': 'টাঙ্গাইল', 'en': 'Tangail', 'lat': '24.2512', 'lon': '89.9167'},
  {'bn': 'কিশোরগঞ্জ', 'en': 'Kishoreganj', 'lat': '24.4444', 'lon': '90.7760'},
  {'bn': 'মানিকগঞ্জ', 'en': 'Manikganj', 'lat': '23.8643', 'lon': '89.9881'},
  {'bn': 'মুন্সিগঞ্জ', 'en': 'Munshiganj', 'lat': '23.5422', 'lon': '90.5305'},
  {'bn': 'নরসিংদী', 'en': 'Narsingdi', 'lat': '23.9320', 'lon': '90.7150'},
  {'bn': 'ফরিদপুর', 'en': 'Faridpur', 'lat': '23.6070', 'lon': '89.8429'},
  {'bn': 'মাদারীপুর', 'en': 'Madaripur', 'lat': '23.1641', 'lon': '90.2044'},
  {'bn': 'শরীয়তপুর', 'en': 'Shariatpur', 'lat': '23.2433', 'lon': '90.4348'},
  {'bn': 'রাজবাড়ী', 'en': 'Rajbari', 'lat': '23.7574', 'lon': '89.6447'},
  {'bn': 'গোপালগঞ্জ', 'en': 'Gopalganj', 'lat': '23.0050', 'lon': '89.8268'},
  {'bn': 'নেত্রকোণা', 'en': 'Netrokona', 'lat': '24.8710', 'lon': '90.7274'},
  {'bn': 'শেরপুর', 'en': 'Sherpur', 'lat': '25.0195', 'lon': '90.0163'},
  {'bn': 'জামালপুর', 'en': 'Jamalpur', 'lat': '24.9375', 'lon': '89.9378'},
  {'bn': 'কক্সবাজার', 'en': 'Cox\'s Bazar', 'lat': '21.4272', 'lon': '91.9996'},
  {'bn': 'ফেনী', 'en': 'Feni', 'lat': '23.0235', 'lon': '91.3979'},
  {'bn': 'নোয়াখালী', 'en': 'Noakhali', 'lat': '22.8696', 'lon': '91.0996'},
  {'bn': 'লক্ষ্মীপুর', 'en': 'Lakshmipur', 'lat': '22.9447', 'lon': '90.8418'},
  {'bn': 'চাঁদপুর', 'en': 'Chandpur', 'lat': '23.2333', 'lon': '90.6667'},
  {
    'bn': 'ব্রাহ্মণবাড়িয়া',
    'en': 'Brahmanbaria',
    'lat': '23.9570',
    'lon': '91.1115',
  },
  {
    'bn': 'খাগড়াছড়ি',
    'en': 'Khagrachhari',
    'lat': '23.1193',
    'lon': '91.9847',
  },
  {'bn': 'রাঙামাটি', 'en': 'Rangamati', 'lat': '22.6463', 'lon': '92.2055'},
  {'bn': 'বান্দরবান', 'en': 'Bandarban', 'lat': '22.1953', 'lon': '92.2184'},
  {'bn': 'নওগাঁ', 'en': 'Naogaon', 'lat': '24.7936', 'lon': '88.9312'},
  {'bn': 'নাটোর', 'en': 'Natore', 'lat': '24.4203', 'lon': '88.9870'},
  {
    'bn': 'চাঁপাইনবাবগঞ্জ',
    'en': 'Chapai Nawabganj',
    'lat': '24.5965',
    'lon': '88.2785',
  },
  {'bn': 'পাবনা', 'en': 'Pabna', 'lat': '24.0064', 'lon': '89.2372'},
  {'bn': 'সিরাজগঞ্জ', 'en': 'Sirajganj', 'lat': '24.4534', 'lon': '89.7009'},
  {'bn': 'বগুড়া', 'en': 'Bogura', 'lat': '24.8465', 'lon': '89.3720'},
  {'bn': 'জয়পুরহাট', 'en': 'Joypurhat', 'lat': '25.1000', 'lon': '89.0167'},
  {'bn': 'যশোর', 'en': 'Jessore', 'lat': '23.1667', 'lon': '89.2167'},
  {'bn': 'ঝিনাইদহ', 'en': 'Jhenaidah', 'lat': '23.5447', 'lon': '89.1552'},
  {'bn': 'মাগুরা', 'en': 'Magura', 'lat': '23.4876', 'lon': '89.4193'},
  {'bn': 'নড়াইল', 'en': 'Narail', 'lat': '23.1726', 'lon': '89.5124'},
  {'bn': 'কুষ্টিয়া', 'en': 'Kushtia', 'lat': '23.9014', 'lon': '89.1195'},
  {'bn': 'মেহেরপুর', 'en': 'Meherpur', 'lat': '23.7624', 'lon': '88.6318'},
  {'bn': 'চুয়াডাঙ্গা', 'en': 'Chuadanga', 'lat': '23.6402', 'lon': '88.8416'},
  {'bn': 'সাতক্ষীরা', 'en': 'Satkhira', 'lat': '22.7185', 'lon': '89.0705'},
  {'bn': 'বাগেরহাট', 'en': 'Bagerhat', 'lat': '22.6602', 'lon': '89.7854'},
  {'bn': 'পটুয়াখালী', 'en': 'Patuakhali', 'lat': '22.3596', 'lon': '90.3296'},
  {'bn': 'পিরোজপুর', 'en': 'Pirojpur', 'lat': '22.5795', 'lon': '89.9744'},
  {'bn': 'ঝালকাঠি', 'en': 'Jhalokati', 'lat': '22.6445', 'lon': '90.1977'},
  {'bn': 'ভোলা', 'en': 'Bhola', 'lat': '22.6860', 'lon': '90.6518'},
  {'bn': 'বরগুনা', 'en': 'Barguna', 'lat': '22.1500', 'lon': '90.1120'},
  {'bn': 'হবিগঞ্জ', 'en': 'Habiganj', 'lat': '24.3745', 'lon': '91.4153'},
  {'bn': 'মৌলভীবাজার', 'en': 'Moulvibazar', 'lat': '24.4829', 'lon': '91.7775'},
  {'bn': 'সুনামগঞ্জ', 'en': 'Sunamganj', 'lat': '25.0658', 'lon': '91.3950'},
  {'bn': 'গাইবান্ধা', 'en': 'Gaibandha', 'lat': '25.3282', 'lon': '89.5286'},
  {'bn': 'কুড়িগ্রাম', 'en': 'Kurigram', 'lat': '25.8075', 'lon': '89.6358'},
  {'bn': 'লালমনিরহাট', 'en': 'Lalmonirhat', 'lat': '25.9923', 'lon': '89.2847'},
  {'bn': 'নীলফামারী', 'en': 'Nilphamari', 'lat': '25.9314', 'lon': '88.8561'},
  {'bn': 'পঞ্চগড়', 'en': 'Panchagarh', 'lat': '26.3438', 'lon': '88.5557'},
  {'bn': 'ঠাকুরগাঁও', 'en': 'Thakurgaon', 'lat': '26.0336', 'lon': '88.4616'},
  {'bn': 'দিনাজপুর', 'en': 'Dinajpur', 'lat': '25.6279', 'lon': '88.6338'},
];

class _DayForecast {
  final DateTime date;
  final int weatherCode;
  final double maxTemp;
  final double minTemp;
  final int rainChance;

  const _DayForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
    required this.rainChance,
  });
}

class _WeatherData {
  final double tempC;
  final double feelsLikeC;
  final int humidity;
  final double windKmph;
  final String conditionEn;
  final int weatherCode;
  final int rainChance;
  final List<_DayForecast> forecast;

  const _WeatherData({
    required this.tempC,
    required this.feelsLikeC,
    required this.humidity,
    required this.windKmph,
    required this.conditionEn,
    required this.weatherCode,
    required this.rainChance,
    required this.forecast,
  });

  factory _WeatherData.fromJson(Map<String, dynamic> json) {
    final c = json['current'] as Map<String, dynamic>;
    final d = json['daily'] as Map<String, dynamic>? ?? {};

    final forecast = <_DayForecast>[];
    if (d.isNotEmpty) {
      final dates = d['time'] as List? ?? [];
      final codes = d['weather_code'] as List? ?? [];
      final maxTemps = d['temperature_2m_max'] as List? ?? [];
      final minTemps = d['temperature_2m_min'] as List? ?? [];
      final rainChances = d['precipitation_probability_max'] as List? ?? [];

      for (int i = 1; i < dates.length; i++) {
        forecast.add(
          _DayForecast(
            date:
                DateTime.tryParse(dates[i]?.toString() ?? '') ?? DateTime.now(),
            weatherCode: (codes[i] as num?)?.toInt() ?? 0,
            maxTemp: (maxTemps[i] as num?)?.toDouble() ?? 0,
            minTemp: (minTemps[i] as num?)?.toDouble() ?? 0,
            rainChance: (rainChances[i] as num?)?.toInt() ?? 0,
          ),
        );
      }
    }

    return _WeatherData(
      tempC: (c['temperature_2m'] as num).toDouble(),
      feelsLikeC: (c['apparent_temperature'] as num).toDouble(),
      humidity: (c['relative_humidity_2m'] as num).toInt(),
      windKmph: (c['wind_speed_10m'] as num).toDouble(),
      conditionEn: '',
      weatherCode: (c['weather_code'] as num).toInt(),
      rainChance: (c['precipitation_probability'] as num?)?.toInt() ?? 0,
      forecast: forecast,
    );
  }
}

// ─── Weather page ─────────────────────────────────────────────────────────────

class FarmerWeatherPage extends StatefulWidget {
  const FarmerWeatherPage({super.key});

  @override
  State<FarmerWeatherPage> createState() => _FarmerWeatherPageState();
}

class _FarmerWeatherPageState extends State<FarmerWeatherPage> {
  String? _selectedEn; // use 'en' string as dropdown value
  Map<String, String>? _selectedDistrict;
  _WeatherData? _weather;
  bool _loading = false;
  String? _error;

  Future<void> _fetchWeather(Map<String, String> district) async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
      _weather = null;
    });
    try {
      final lat = district['lat']!;
      final lon = district['lon']!;
      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$lat&longitude=$lon'
        '&current=temperature_2m,relative_humidity_2m,apparent_temperature,'
        'precipitation_probability,weather_code,wind_speed_10m'
        '&daily=weather_code,temperature_2m_max,temperature_2m_min,'
        'precipitation_probability_max'
        '&forecast_days=6'
        '&wind_speed_unit=kmh'
        '&timezone=Asia%2FDhaka',
      );
      final res = await http.get(uri).timeout(const Duration(seconds: 15));
      if (!mounted) return;
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        setState(() {
          _weather = _WeatherData.fromJson(data);
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'সার্ভার থেকে ডেটা পাওয়া যায়নি (${res.statusCode})';
          _loading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'ইন্টারনেট সংযোগ পরীক্ষা করুন: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─── Header ─────────────────────────────────────────────
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
                backgroundColor: Colors.white24,
                child: Icon(Icons.cloud, color: Colors.white, size: 18),
              ),
              SizedBox(width: 12),
              Text(
                'আবহাওয়া ভিত্তিক ফসল পরামর্শ',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
                ),
              ),
            ],
          ),
        ),

        // ─── Body ───────────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // District selector card
                _glassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.redAccent,
                            size: 18,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'জেলা নির্বাচন করুন',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _selectedEn,
                        decoration: InputDecoration(
                          hintText: 'জেলা বেছে নিন',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.35),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withOpacity(0.35),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        dropdownColor: const Color(0xFF1B5E20),
                        iconEnabledColor: Colors.white70,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        isExpanded: true,
                        items: _districts
                            .map(
                              (d) => DropdownMenuItem<String>(
                                value: d['en'],
                                child: Text(d['bn']!),
                              ),
                            )
                            .toList(),
                        onChanged: (en) {
                          if (en == null) return;
                          final d = _districts.firstWhere((x) => x['en'] == en);
                          final district = Map<String, String>.from(d);
                          setState(() {
                            _selectedEn = en;
                            _selectedDistrict = district;
                          });
                          _fetchWeather(district);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Static tips card (always visible)
                const _TipsCard(),
                const SizedBox(height: 14),

                // Weather content
                if (_loading)
                  Container(
                    height: 180,
                    alignment: Alignment.center,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Colors.white),
                        SizedBox(height: 14),
                        Text(
                          'আবহাওয়া তথ্য লোড হচ্ছে...',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                else if (_error != null)
                  _glassCard(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.wifi_off,
                          color: Colors.orange,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: () {
                            if (_selectedDistrict != null) {
                              _fetchWeather(_selectedDistrict!);
                            }
                          },
                        ),
                      ],
                    ),
                  )
                else if (_weather != null && _selectedDistrict != null)
                  _WeatherResult(
                    weather: _weather!,
                    district: _selectedDistrict!,
                  )
                else
                  _glassCard(
                    child: Column(
                      children: [
                        Icon(
                          Icons.wb_cloudy,
                          size: 56,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'উপরে জেলা নির্বাচন করুন',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'আপনার এলাকার সর্বশেষ আবহাওয়া তথ্য দেখতে\nজেলা বেছে নিন',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─── Weather result widget ────────────────────────────────────────────────────

class _WeatherResult extends StatelessWidget {
  final _WeatherData weather;
  final Map<String, String> district;
  const _WeatherResult({required this.weather, required this.district});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Main weather card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _gradientColors(weather.weatherCode),
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    district['bn']!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _conditionBn(weather.weatherCode),
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _weatherEmoji(weather.weatherCode),
                    style: const TextStyle(fontSize: 52),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${weather.tempC.round()}°C',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 58,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _conditionBn(weather.weatherCode),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // Stats grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.8,
          children: [
            _statCard(
              icon: Icons.thermostat,
              iconColor: const Color(0xFFFF7043),
              label: 'অনুভূত তাপমাত্রা',
              value: '${weather.feelsLikeC.round()}°C',
            ),
            _statCard(
              icon: Icons.water_drop,
              iconColor: const Color(0xFF29B6F6),
              label: 'আর্দ্রতা',
              value: '${weather.humidity}%',
            ),
            _statCard(
              icon: Icons.air,
              iconColor: const Color(0xFF78909C),
              label: 'বাতাসের গতি',
              value: '${weather.windKmph.round()} km/h',
            ),
            _statCard(
              icon: Icons.grain,
              iconColor: const Color(0xFF42A5F5),
              label: 'বৃষ্টির সম্ভাবনা',
              value: '${weather.rainChance}%',
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Crop advice
        _CropAdviceCard(weather: weather),
        const SizedBox(height: 14),

        // 5-day forecast
        if (weather.forecast.isNotEmpty) ...[
          _FiveDayForecastCard(forecast: weather.forecast),
          const SizedBox(height: 14),
        ],

        // Data source note
        Text(
          'তথ্যসূত্র: Open-Meteo (রিয়েল-টাইম ডেটা)',
          // open-meteo.com — free, no API key, WMO weather codes
          style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 11),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1A1A1A),
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF666666)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // WMO weather codes (Open-Meteo)
  List<Color> _gradientColors(int code) {
    if (code <= 1) {
      return [const Color(0xFF1976D2), const Color(0xFF42A5F5)]; // sunny
    } else if (code == 2 || code == 3) {
      return [const Color(0xFF455A64), const Color(0xFF78909C)]; // cloudy
    } else if (code == 45 || code == 48) {
      return [const Color(0xFF607D8B), const Color(0xFF90A4AE)]; // fog
    } else if (code >= 51 && code <= 82) {
      return [const Color(0xFF1565C0), const Color(0xFF5C6BC0)]; // rain
    } else if (code >= 95) {
      return [const Color(0xFF37474F), const Color(0xFF7B1FA2)]; // thunder
    }
    return [const Color(0xFF1B5E20), const Color(0xFF27A745)]; // default
  }

  String _weatherEmoji(int code) {
    if (code == 0 || code == 1) return '☀️';
    if (code == 2) return '⛅';
    if (code == 3) return '☁️';
    if (code == 45 || code == 48) return '🌫️';
    if (code >= 51 && code <= 57) return '🌦️';
    if (code >= 61 && code <= 67) return '🌧️';
    if (code >= 71 && code <= 77) return '🌨️';
    if (code >= 80 && code <= 82) return '🌦️';
    if (code >= 85 && code <= 86) return '🌨️';
    if (code >= 95) return '⛈️';
    return '🌤️';
  }

  String _conditionBn(int code) {
    if (code == 0 || code == 1) return 'রৌদ্রোজ্জ্বল';
    if (code == 2) return 'আংশিক মেঘলা';
    if (code == 3) return 'সম্পূর্ণ মেঘলা';
    if (code == 45 || code == 48) return 'কুয়াশাচ্ছন্ন';
    if (code >= 51 && code <= 55) return 'গুঁড়ি গুঁড়ি বৃষ্টি';
    if (code == 61 || code == 63) return 'বৃষ্টি';
    if (code == 65) return 'ভারী বৃষ্টি';
    if (code >= 71 && code <= 77) return 'তুষারপাত';
    if (code >= 80 && code <= 81) return 'বৃষ্টিপাত';
    if (code == 82) return 'ভারী বৃষ্টিপাত';
    if (code == 95) return 'বজ্রবৃষ্টি';
    if (code == 96 || code == 99) return 'শিলাবৃষ্টি সহ বজ্র';
    return 'পরিষ্কার আকাশ';
  }
}

// ─── Crop advice card ─────────────────────────────────────────────────────────

class _CropAdviceCard extends StatelessWidget {
  final _WeatherData weather;
  const _CropAdviceCard({required this.weather});

  @override
  Widget build(BuildContext context) {
    final advices = _getAdvices();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1B5E20), Color(0xFF27A745)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              children: [
                Icon(Icons.agriculture, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'কৃষি পরামর্শ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: advices
                  .map(
                    (a) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: (a['color'] as Color).withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                a['icon'] as IconData,
                                size: 16,
                                color: a['color'] as Color,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a['title'] as String,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    color: a['color'] as Color,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  a['msg'] as String,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF444444),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getAdvices() {
    final advices = <Map<String, dynamic>>[];
    final code = weather.weatherCode;
    final temp = weather.tempC;
    final humid = weather.humidity;
    final rain = weather.rainChance;

    // Rain advice (WMO codes: 65=heavy rain, 82=violent showers)
    if (code == 65 || code == 82 || rain > 70) {
      advices.add({
        'title': 'ভারী বৃষ্টির সতর্কতা',
        'msg':
            'ফসল সংগ্রহ বন্ধ রাখুন। মাঠ থেকে অতিরিক্ত পানি নিষ্কাশনের ব্যবস্থা করুন। সেচ দেওয়া থেকে বিরত থাকুন।',
        'icon': Icons.warning_amber,
        'color': const Color(0xFFE53935),
      });
    } else if ((code >= 51 && code <= 63) ||
        (code >= 80 && code <= 81) ||
        (rain > 30 && rain <= 70)) {
      advices.add({
        'title': 'বৃষ্টির সম্ভাবনা',
        'msg':
            'সার প্রয়োগের ভালো সময়। সেচ বন্ধ রাখুন। পাকা ফসল থাকলে দ্রুত সংগ্রহ করুন।',
        'icon': Icons.grain,
        'color': const Color(0xFF1976D2),
      });
    }

    // Thunder (WMO codes: 95, 96, 99)
    if (code >= 95) {
      advices.add({
        'title': 'বজ্রপাত সতর্কতা',
        'msg':
            'মাঠে কাজ বন্ধ রাখুন। নিরাপদ আশ্রয়ে থাকুন। পাকা ফসল আগেই ঘরে তুলুন।',
        'icon': Icons.bolt,
        'color': const Color(0xFFF57F17),
      });
    }

    // Temperature advice
    if (temp > 38) {
      advices.add({
        'title': 'তীব্র গরম',
        'msg':
            'বিকেলে বা সন্ধ্যায় সেচ দিন। ফসলে মালচিং করুন। নিয়মিত পানি সরবরাহ নিশ্চিত করুন।',
        'icon': Icons.thermostat,
        'color': const Color(0xFFBF360C),
      });
    } else if (temp < 15) {
      advices.add({
        'title': 'শীতের প্রভাব',
        'msg':
            'ঠান্ডা সংবেদনশীল ফসল ঢেকে রাখুন। শুষ্ক আবহাওয়ায় সেচ বাড়ান। সার প্রয়োগ সকালে করুন।',
        'icon': Icons.ac_unit,
        'color': const Color(0xFF1565C0),
      });
    } else if (temp >= 25 && temp <= 35) {
      advices.add({
        'title': 'আদর্শ তাপমাত্রা',
        'msg':
            'বেশিরভাগ ফসলের জন্য উপযুক্ত আবহাওয়া। বীজ বপন ও সার প্রয়োগের ভালো সময়।',
        'icon': Icons.check_circle,
        'color': const Color(0xFF27A745),
      });
    }

    // Humidity / fog (WMO codes: 45, 48)
    if (code == 45 || code == 48 || humid > 88) {
      advices.add({
        'title': 'উচ্চ আর্দ্রতা / কুয়াশা',
        'msg':
            'ছত্রাকজনিত রোগের ঝুঁকি বেশি। প্রতিরোধমূলক ছত্রাকনাশক স্প্রে করুন। পাতা ভেজা রাখবেন না।',
        'icon': Icons.bug_report,
        'color': const Color(0xFF7B1FA2),
      });
    }

    // Sunny / dry (WMO 0=clear, 1=mainly clear)
    if ((code == 0 || code == 1) && rain < 10 && temp > 32) {
      advices.add({
        'title': 'খরার ঝুঁকি',
        'msg':
            'নিয়মিত সেচ দিন। মাটির আর্দ্রতা পরীক্ষা করুন। বিকেলে সেচ সবচেয়ে কার্যকর।',
        'icon': Icons.wb_sunny,
        'color': const Color(0xFFFF8F00),
      });
    }

    // General if nothing triggered
    if (advices.isEmpty) {
      advices.add({
        'title': 'স্বাভাবিক আবহাওয়া',
        'msg':
            'আবহাওয়া স্বাভাবিক আছে। নিয়মিত কৃষি কাজ চালিয়ে যান। ফসলের অবস্থা পর্যবেক্ষণ করুন।',
        'icon': Icons.eco,
        'color': const Color(0xFF2E7D32),
      });
    }

    return advices;
  }
}

// ─── Static Tips Card ─────────────────────────────────────────────────────────

class _TipsCard extends StatelessWidget {
  const _TipsCard();

  @override
  Widget build(BuildContext context) {
    final tips = [
      {
        'icon': Icons.grain,
        'color': const Color(0xFF1976D2),
        'title': 'বৃষ্টির আগে:',
        'msg': 'ফসল কাটার কাজ দ্রুত শেষ করুন এবং ফসল সংরক্ষণ করুন',
      },
      {
        'icon': Icons.wb_sunny,
        'color': const Color(0xFFF57F17),
        'title': 'গরমের সময়:',
        'msg': 'সকাল বা বিকালে সেচ দিন। দুপুরে সেচ এড়িয়ে চলুন',
      },
      {
        'icon': Icons.ac_unit,
        'color': const Color(0xFF1565C0),
        'title': 'শীতকালে:',
        'msg': 'তুষার ও ঠান্ডা থেকে ফসল রক্ষা করুন',
      },
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.13),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
              Text(
                'আবহাওয়া সংক্রান্ত গুরুত্বপূর্ণ টিপস',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: tips.map((t) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Icon(
                        t['icon'] as IconData,
                        color: t['color'] as Color,
                        size: 28,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        t['title'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        t['msg'] as String,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ─── 5-Day Forecast Card ──────────────────────────────────────────────────────

class _FiveDayForecastCard extends StatelessWidget {
  final List<_DayForecast> forecast;
  const _FiveDayForecastCard({required this.forecast});

  static const _dayNames = [
    'রবি',
    'সোম',
    'মঙ্গল',
    'বুধ',
    'বৃহঃ',
    'শুক্র',
    'শনি',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.88),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0277BD), Color(0xFF29B6F6)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: const Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'আগামী ৫ দিনের আবহাওয়া',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: forecast.take(5).map((day) {
                return Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 4,
                    ),
                    child: Column(
                      children: [
                        Text(
                          _dayNames[day.date.weekday % 7],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF333333),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${day.date.day}/${day.date.month}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF777777),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _emoji(day.weatherCode),
                          style: const TextStyle(fontSize: 26),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '${day.maxTemp.round()}°',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFE53935),
                          ),
                        ),
                        Text(
                          '${day.minTemp.round()}°',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.water_drop,
                              size: 10,
                              color: Color(0xFF29B6F6),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${day.rainChance}%',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF555555),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _emoji(int code) {
    if (code == 0 || code == 1) return '☀️';
    if (code == 2) return '⛅';
    if (code == 3) return '☁️';
    if (code == 45 || code == 48) return '🌫️';
    if (code >= 51 && code <= 57) return '🌦️';
    if (code >= 61 && code <= 67) return '🌧️';
    if (code >= 71 && code <= 77) return '🌨️';
    if (code >= 80 && code <= 82) return '🌦️';
    if (code >= 95) return '⛈️';
    return '🌤️';
  }
}
