import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart'; 
// 👇 NHỚ IMPORT THÊM FILE NÀY
import '../booking/booking_history_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  final String token;
  const ProfileScreen({super.key, required this.token});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    final data = await _apiService.getUserProfile(widget.token);
    if (mounted) setState(() => _profile = data);
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (_) => const LoginScreen()), 
      (route) => false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Avatar
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1A237E),
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 60),

            // 2. Tên & Thông tin
            Text(
              _profile?['fullName'] ?? "Người dùng",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
            ),
            Text(
              "Thành viên CLB Pickleball",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),

            // 3. Menu Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildProfileOption(Icons.person_outline, "Thông tin tài khoản", () {
                    // Chức năng xem thông tin cá nhân
                  }),
                  
                  // 👇 CẬP NHẬT Ở ĐÂY: Mở màn hình Lịch sử đặt sân
                  _buildProfileOption(Icons.history, "Lịch sử đặt sân", () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingHistoryScreen(token: widget.token),
                      ),
                    );
                  }),

                  _buildProfileOption(Icons.lock_outline, "Đổi mật khẩu", () {}),
                  _buildProfileOption(Icons.help_outline, "Hỗ trợ & Liên hệ", () {}),
                  const SizedBox(height: 20),
                  
                  // Nút Đăng xuất
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text("Đăng Xuất"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10)],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A237E).withOpacity(0.1), 
            borderRadius: BorderRadius.circular(8)
          ),
          child: Icon(icon, color: const Color(0xFF1A237E)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}