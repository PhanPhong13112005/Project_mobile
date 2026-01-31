import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/api_service.dart';

class WalletScreen extends StatefulWidget {
  final String token;
  const WalletScreen({super.key, required this.token});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _amountController = TextEditingController();
  Map<String, dynamic>? _profile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    try {
      final data = await _apiService.getUserProfile(widget.token);
      if (mounted) setState(() => _profile = data);
    } catch (e) {
      print(e);
    }
  }

  void _showDepositDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Nạp Tiền"),
        content: TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Nhập số tiền (VNĐ)", prefixIcon: Icon(Icons.attach_money)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _submitDeposit();
            },
            child: const Text("Xác nhận"),
          )
        ],
      ),
    );
  }

  Future<void> _submitDeposit() async {
    setState(() => _isLoading = true);
    double amount = double.tryParse(_amountController.text) ?? 0;
    bool success = await _apiService.deposit(widget.token, amount, null);
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("✅ Nạp thành công!"), backgroundColor: Colors.green));
        _amountController.clear();
        _loadProfile();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("❌ Lỗi nạp tiền"), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    double balance = double.tryParse(_profile?['walletBalance']?.toString() ?? "0") ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      appBar: AppBar(title: const Text("Ví Của Tôi"), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- THẺ VISA ẢO (GIAO DIỆN MỚI) ---
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF42A5F5)], // Gradient Xanh Navy -> Xanh Dương
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 10))],
              ),
              child: Stack(
                children: [
                  // Họa tiết trang trí mờ
                  Positioned(right: -50, top: -50, child: CircleAvatar(radius: 100, backgroundColor: Colors.white.withOpacity(0.1))),
                  Positioned(left: -30, bottom: -50, child: CircleAvatar(radius: 80, backgroundColor: Colors.white.withOpacity(0.1))),
                  
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("PCM WALLET", style: TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 2)),
                            Icon(Icons.nfc, color: Colors.white70),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Số dư khả dụng", style: TextStyle(color: Colors.white70, fontSize: 14)),
                            const SizedBox(height: 5),
                            Text(
                              currencyFormat.format(balance),
                              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_profile?['fullName'] ?? "Member Name", style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                            const Icon(Icons.credit_card, color: Colors.white, size: 30),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),

            // --- NÚT CHỨC NĂNG (TO & ĐẸP) ---
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _showDepositDialog,
                icon: _isLoading ? const SizedBox.shrink() : const Icon(Icons.add_circle_outline),
                label: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("NẠP TIỀN NGAY", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF76FF03), foregroundColor: Colors.black), // Màu xanh Pickleball nổi bật
              ),
            ),

            const SizedBox(height: 30),

            // --- DANH SÁCH LỊCH SỬ ---
            const Align(alignment: Alignment.centerLeft, child: Text("Giao dịch gần đây", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87))),
            const SizedBox(height: 15),
            _buildHistoryItem("Nạp tiền vào ví", "+ 500.000 đ", Colors.green, Icons.arrow_downward),
            _buildHistoryItem("Đặt sân VIP 1", "- 150.000 đ", Colors.red, Icons.sports_tennis),
            _buildHistoryItem("Phí giải đấu Mùa Hè", "- 200.000 đ", Colors.orange, Icons.emoji_events),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String amount, Color color, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                const Text("Hôm nay, 10:30 AM", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}