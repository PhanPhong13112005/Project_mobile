import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import 'add_booking_screen.dart';

class BookingScreen extends StatefulWidget {
  final String token;
  const BookingScreen({super.key, required this.token});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final data = await _apiService.getMyBookings(widget.token);
      if (mounted) setState(() => _bookings = data);
    } catch (e) {
      print(e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch Sử Đặt Sân"),
        actions: [
          IconButton(onPressed: _loadBookings, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                final item = _bookings[index];
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: const Icon(
                      Icons.sports_tennis,
                      color: Colors.green,
                    ),
                    title: Text("Sân số ${item['courtId']}"),
                    subtitle: Text(
                      item['startTime']
                          .toString()
                          .substring(0, 16)
                          .replaceFirst('T', ' '),
                    ),
                    trailing: const Chip(
                      label: Text("Thành công"),
                      backgroundColor: Colors.greenAccent,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () async {
          // Mở màn hình thêm mới và chờ kết quả
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddBookingScreen(token: widget.token),
            ),
          );

          // Nếu đặt thành công (result == true) thì load lại danh sách
          if (result == true) {
            _loadBookings();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
