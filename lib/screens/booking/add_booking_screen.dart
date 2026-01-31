import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '/services/api_service.dart';

class AddBookingScreen extends StatefulWidget {
  final String token;
  const AddBookingScreen({super.key, required this.token});

  @override
  State<AddBookingScreen> createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _courtIdController = TextEditingController();
  
  DateTime _startTime = DateTime.now().add(const Duration(minutes: 30));
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1, minutes: 30));
  
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt Sân Mới'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Thông tin đặt sân", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo)),
              const SizedBox(height: 20),
              
              // 1. NHẬP SỐ SÂN
              TextFormField(
                controller: _courtIdController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Số sân (Ví dụ: 1)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.stadium),
                ),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập số sân' : null,
              ),
              const SizedBox(height: 20),

              // 2. CHỌN GIỜ
              _buildDateTimePicker("Bắt đầu lúc", _startTime, (val) => setState(() => _startTime = val)),
              const Divider(height: 30),
              _buildDateTimePicker("Kết thúc lúc", _endTime, (val) => setState(() => _endTime = val)),
              
              const SizedBox(height: 30),

              // 3. HIỂN THỊ LỖI (NẾU CÓ)
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.shade200)),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 10),
                      Expanded(child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))),
                    ],
                  ),
                ),

              // 4. NÚT XÁC NHẬN
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitBooking,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("XÁC NHẬN ĐẶT SÂN", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(String label, DateTime time, Function(DateTime) onChanged) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text("${time.hour}:${time.minute.toString().padLeft(2,'0')} - ${time.day}/${time.month}/${time.year}", style: const TextStyle(fontSize: 16, color: Colors.black87)),
      trailing: const Icon(Icons.calendar_month, color: Colors.indigo),
      onTap: () async {
        final date = await showDatePicker(context: context, initialDate: time, firstDate: DateTime.now(), lastDate: DateTime(2030));
        if (date != null && mounted) {
          final timeOfDay = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(time));
          if (timeOfDay != null) {
            onChanged(DateTime(date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute));
          }
        }
      },
    );
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      final api = ApiService();
      await api.bookCourt(widget.token, int.parse(_courtIdController.text), _startTime as String, _endTime as String);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Đặt sân thành công!'), backgroundColor: Colors.green));
        Navigator.pop(context, true); // Trả về true để màn hình danh sách biết mà reload
      }
    } on DioException catch (e) {
      if (mounted) setState(() => _errorMessage = e.response?.data?.toString() ?? "Lỗi kết nối!");
    } catch (e) {
      if (mounted) setState(() => _errorMessage = "Lỗi: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}