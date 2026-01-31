import 'package:dio/dio.dart';

class ApiService {
  // Đường dẫn Backend đã được triển khai thực tế trên VPS Ubuntu
  static const String baseUrl = "https://luuphong-cntt1708.ddns.net/api";

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15), // Tăng thời gian chờ cho mạng ổn định
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  // 1. ĐĂNG KÝ
  Future<bool> register(String username, String password, String fullName) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'userName': username,
        'password': password,
        'fullName': fullName,
      });
      return response.statusCode == 200;
    } catch (e) {
      print('Lỗi đăng ký: $e');
      return false;
    }
  }

  // 2. ĐĂNG NHẬP (Nhận token để sử dụng cho các phiên sau)
  Future<String?> login(String username, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'userName': username,
        'password': password,
      });
      // Token nhận được từ server xác thực danh tính người dùng
      return response.data['token'];
    } catch (e) {
      print('Lỗi đăng nhập: $e');
      return null;
    }
  }

  // 3. LẤY THÔNG TIN NGƯỜI DÙNG
  Future<Map<String, dynamic>?> getUserProfile(String token) async {
    try {
      // Gửi kèm Bearer Token trong Header để vượt qua kiểm tra bảo mật (401)
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('/auth/me');
      return response.data;
    } catch (e) {
      print('Lỗi lấy profile: $e');
      return null;
    }
  }

  // 4. LẤY DANH SÁCH 5 SÂN ĐÃ NẠP
  Future<List<dynamic>> getCourts() async {
    try {
      // Endpoint này không yêu cầu token để khách hàng xem trước sân
      final response = await _dio.get('/Courts');
      if (response.data is List) {
        return response.data;
      }
      return [];
    } catch (e) {
      print('Lỗi lấy danh sách sân: $e');
      return [];
    }
  }

  // 5. NẠP TIỀN VÀO VÍ
  Future<bool> deposit(String token, double amount, dynamic imageFile) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post('/wallet/deposit', data: {
        "amount": amount,
        "description": "Nạp tiền qua App Mobile (Demo)"
      });
      return response.statusCode == 200;
    } catch (e) {
      print("Lỗi nạp tiền: $e");
      return false;
    }
  }

  // 6. ĐẶT SÂN (Logic quan trọng để tạo dữ liệu cho phần 4 Demo)
  Future<bool> bookCourt(String token, int courtId, String startTime, String endTime) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.post('/bookings', data: {
        "courtId": courtId,
        "startTime": startTime,
        "endTime": endTime,
        "memberId": 0 // MemberId sẽ được server tự động ánh xạ từ Token JWT
      });
      return response.statusCode == 200;
    } catch (e) {
      print('Lỗi đặt sân: $e');
      return false;
    }
  }

  // 7. LẤY LỊCH SỬ ĐẶT SÂN (Để chứng minh dữ liệu đồng bộ)
  Future<List<dynamic>> getMyBookings(String token) async {
    try {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      // Sử dụng đúng Endpoint để lấy dữ liệu cá nhân
      final response = await _dio.get('/bookings/my-bookings');
      return response.data;
    } catch (e) {
      print('Lỗi lấy lịch sử đặt sân: $e');
      return [];
    }
  }
}