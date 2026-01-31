import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class WalletScreen extends StatefulWidget {
  final String token;
  const WalletScreen({super.key, required this.token});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _profile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    try {
      final data = await _apiService.getUserProfile(widget.token);
      if (mounted) setState(() => _profile = data);
    } catch (e) { print(e); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ví Điện Tử")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity, padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.blueAccent, Colors.blue]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Số dư hiện tại", style: TextStyle(color: Colors.white70)),
              Text("${_profile?['walletBalance'] ?? 0} đ", style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}