import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart'; // Đảm bảo đường dẫn này đúng với project của bạn

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pickleball Pro',
      
      // --- BỘ GIAO DIỆN MỚI (MODERN SPORTY THEME) ---
      theme: ThemeData(
        useMaterial3: true,
        
        // Màu chủ đạo: Xanh Navy đậm (Chuyên nghiệp)
        primaryColor: const Color(0xFF1A237E), 
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          // Màu phụ: Xanh Neon (Màu quả bóng Pickleball - Dùng cho điểm nhấn)
          secondary: const Color(0xFF76FF03), 
        ),
        
        // Màu nền App: Xám nhạt (Giúp nội dung nổi bật, đỡ mỏi mắt)
        scaffoldBackgroundColor: const Color(0xFFF5F5FA), 
        
        // Giao diện thanh tiêu đề (AppBar)
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          foregroundColor: Colors.white, // Chữ màu trắng
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        
        // Giao diện nút bấm (ElevatedButton) - Bo tròn, nổi khối
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A237E),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5, // Đổ bóng nhẹ
          ),
        ),
        
        // Giao diện ô nhập liệu (TextField) - Nền trắng, bo góc mềm mại
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, // Không viền đen xấu xí
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1A237E), width: 2), // Khi bấm vào thì viền xanh
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
      // --- KẾT THÚC CẤU HÌNH THEME ---

      home: const LoginScreen(),
    );
  }
}