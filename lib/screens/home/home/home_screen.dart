import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_flutter_1771020535_phan_luu_phong/screens/booking/add_booking_screen.dart';
import 'package:mobile_flutter_1771020535_phan_luu_phong/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _courtsFuture;

  @override
  void initState() {
    super.initState();
    _refreshCourts();
  }

  void _refreshCourts() {
    setState(() {
      _courtsFuture = _apiService.getCourts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Scaffold(
      appBar: AppBar(
        title: const Text("VỢT THỦ PHỐ NÚI"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshCourts,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshCourts(),
        child: FutureBuilder<List<dynamic>>(
          future: _courtsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Lỗi tải dữ liệu: ${snapshot.error}"));
            }

            final courts = snapshot.data ?? [];
            if (courts.isEmpty) {
              return const Center(child: Text("Hiện chưa có sân nào trực tuyến"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: courts.length,
              itemBuilder: (context, index) {
                final court = courts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      // Hình ảnh minh họa cho sân
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1A237E),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                        child: const Icon(Icons.sports_tennis_rounded, size: 80, color: Color(0xFF76FF03)),
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          court['name'] ?? "Sân Pickleball",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            court['description'] ?? "Mô tả sân đang cập nhật...",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              currencyFormat.format(court['pricePerHour'] ?? 0),
                              style: const TextStyle(
                                color: Color(0xFF1A237E),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Text("/giờ", style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddBookingScreen(token: widget.token),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A237E),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("ĐẶT SÂN NGAY"),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}