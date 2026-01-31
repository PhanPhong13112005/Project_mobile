import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class AddBookingScreen extends StatefulWidget {
  final String token;
  const AddBookingScreen({super.key, required this.token});

  @override
  State<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  final _courtIdController = TextEditingController();
  final ApiService api = ApiService();
  
  // Biến lưu ngày giờ đã chọn
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 8, minute: 0);
  bool _isLoading = false;

  // Hàm chọn ngày
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2026, 12),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1A237E), // Màu xanh Navy
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // Hàm chọn giờ
  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startTime = picked;
        else _endTime = picked;
      });
    }
  }

  void _submitBooking() async {
    if (_courtIdController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Vui lòng nhập số sân!"), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);

    // Ghép ngày + giờ lại thành chuỗi chuẩn ISO
    final startDateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _startTime.hour, _startTime.minute);
    final endDateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _endTime.hour, _endTime.minute);

    bool success = await api.bookCourt(
      widget.token,
      int.parse(_courtIdController.text),
      startDateTime.toIso8601String(),
      endDateTime.toIso8601String(),
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        // Hiện thông báo thành công đẹp mắt
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            icon: const Icon(Icons.check_circle, color: Colors.green, size: 50),
            title: const Text("Đặt Sân Thành Công!"),
            content: const Text("Yêu cầu của bạn đã được gửi. Vui lòng đến sân đúng giờ nhé."),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx); // Đóng popup
                  Navigator.pop(context); // Về trang chủ
                },
                child: const Text("Về Trang Chủ"),
              )
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Đặt sân thất bại (Có thể đã kín lịch)"), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(title: const Text("Đặt Lịch Ngay")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Card chọn thông tin
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Thông tin đặt sân", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                  const SizedBox(height: 20),
                  
                  // Nhập ID Sân
                  TextField(
                    controller: _courtIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Nhập Số Sân (ID)",
                      prefixIcon: Icon(Icons.sports_tennis),
                      hintText: "Ví dụ: 1",
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),

                  // Chọn Ngày
                  const Text("Ngày chơi", style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat('dd/MM/yyyy').format(_selectedDate), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const Icon(Icons.calendar_month, color: Color(0xFF1A237E)),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // Chọn Giờ Bắt đầu & Kết thúc
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Bắt đầu", style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () => _pickTime(true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(color: const Color(0xFFE8EAF6), borderRadius: BorderRadius.circular(10)),
                                child: Center(child: Text(_startTime.format(context), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)))),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.arrow_forward, color: Colors.grey),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Kết thúc", style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: () => _pickTime(false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(color: const Color(0xFFE8EAF6), borderRadius: BorderRadius.circular(10)),
                                child: Center(child: Text(_endTime.format(context), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Nút Xác Nhận
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A237E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("XÁC NHẬN ĐẶT SÂN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}