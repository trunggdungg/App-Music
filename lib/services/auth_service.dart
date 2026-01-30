import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../data/data_sources/api_music_data.dart';
import '../data/models/user.dart';

class AuthService {
  // static const String baseUrl = 'http://10.0.2.2:8083/api/auth';

  static final AuthService _instance = AuthService._internal();

  factory AuthService() => _instance;

  AuthService._internal();

  // State
  String? _token;
  User? _currentUser;

  String? get token => _token;

  User? get currentUser => _currentUser;
  int? get currentUserId => currentUser?.id;
  bool get isAuthenticated => _token != null;

  /// Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiMusicData.urlLogin}/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Lưu token và user info
        await _saveAuthData(data['token'], data['user']);

        return {
          'success': true,
          'message': data['message'] ?? 'Đăng nhập thành công',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Đăng nhập thất bại',
        };
      }
    } catch (e) {
      print('Login error: $e');
      return {'success': false, 'message': 'Lỗi kết nối!'};
    }
  }

  /// Sign Up
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String fullName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiMusicData.urlLogin}/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'fullName': fullName,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        // Lưu token và user info
        await _saveAuthData(data['token'], data['user']);

        return {
          'success': true,
          'message': data['message'] ?? 'Đăng ký thành công',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Đăng ký thất bại',
        };
      }
    } catch (e) {
      print('Register error: $e');
      return {'success': false, 'message': 'Lỗi kết nối: $e'};
    }
  }

  /// Đăng xuất
  Future<void> logout() async {
    _token = null;
    _currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  Future<void> _saveAuthData(
    String token,
    Map<String, dynamic> userData,
  ) async {
    _token = token;
    _currentUser = User.fromJson(userData);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_data', jsonEncode(userData));
  }
  ///xác thực
  Future<bool> verifyToken() async {
    if (_token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('${ApiMusicData.urlLogin}/verify'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          _currentUser = User.fromJson(data['user']);
          return true;
        }
      }

      // Token không hợp lệ
      await logout();
      return false;
    } catch (e) {
      print('Token verification error: $e');
      return false;
    }
  }

  Future<bool> loadAuthData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userDataStr = prefs.getString('user_data');

      if (token != null && userDataStr != null) {
        _token = token;
        _currentUser = User.fromJson(jsonDecode(userDataStr));

        // Xác thực token có còn hợp lệ không
        return await verifyToken();
      }

      return false;
    } catch (e) {
      print('Load auth data error: $e');
      return false;
    }
  }

  /// lấy thông tin
  Map<String, String> getAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_token != null) 'Authorization': 'Bearer $_token',
    };
  }

}
