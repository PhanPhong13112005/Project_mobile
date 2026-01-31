import 'package:flutter/material.dart';
import 'package:mobile_flutter_1771020535_phan_luu_phong/screens/home/home/home_screen.dart';
import 'wallet/wallet_screen.dart';
import 'profile/profile_screen.dart';

class MainLayout extends StatefulWidget {
  final String token;
  const MainLayout({super.key, required this.token});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Danh sách các tab chính của ứng dụng
    _screens = [
      HomeScreen(token: widget.token),
      WalletScreen(token: widget.token),
      ProfileScreen(token: widget.token),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFF1A237E), // Xanh Navy
            unselectedItemColor: Colors.grey.shade400,
            showUnselectedLabels: true,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.sports_tennis),
                activeIcon: Icon(Icons.sports_tennis, color: Color(0xFF1A237E)),
                label: "Sân Bóng",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet_outlined),
                activeIcon: Icon(Icons.account_balance_wallet, color: Color(0xFF1A237E)),
                label: "Ví Tiền",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person, color: Color(0xFF1A237E)),
                label: "Cá Nhân",
              ),
            ],
          ),
        ),
      ),
    );
  }
}