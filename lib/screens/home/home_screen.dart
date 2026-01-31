import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CLB Pickleball"), backgroundColor: Colors.indigo, foregroundColor: Colors.white, automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Banner Tin Tức
            Container(
              height: 180, width: double.infinity,
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(15)),
              child: const Center(child: Icon(Icons.emoji_events, size: 80, color: Colors.white)),
            ),
            const SizedBox(height: 15),
            const Text("Giải đấu Mùa Hè 2026 sắp khởi tranh!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text("Đăng ký ngay để nhận nhiều phần quà hấp dẫn.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}