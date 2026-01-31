import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class BookingHistoryScreen extends StatefulWidget {
  final String token;
  const BookingHistoryScreen({super.key, required this.token});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _refreshBookings();
  }

  void _refreshBookings() {
    setState(() {
      _bookingsFuture = _apiService.getMyBookings(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lịch Sử Đặt Sân")),
      body: RefreshIndicator(
        onRefresh: () async => _refreshBookings(),
        child: FutureBuilder<List<dynamic>>(
          future: _bookingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final bookings = snapshot.data ?? [];

            if (bookings.isEmpty) {
              return const Center(
                child: Text("Bạn chưa có lịch đặt sân nào."),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final item = bookings[index];
                final start = DateTime.parse(item['startTime']);
                final end = DateTime.parse(item['endTime']);

                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A237E).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.event_available, color: Color(0xFF1A237E)),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Sân số: ${item['courtId']}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Ngày: ${DateFormat('dd/MM/yyyy').format(start)}",
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            Text(
                              "Giờ: ${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)}",
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        "Thành công",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
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