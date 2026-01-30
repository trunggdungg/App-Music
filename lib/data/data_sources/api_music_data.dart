import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_app/data/models/artist.dart';
import 'package:music_app/data/models/favorite.dart';
import 'package:music_app/data/models/search_result.dart';

import '../../services/auth_service.dart';
import '../models/song.dart';

class ApiMusicData {
  static const String baseUrl = 'http://10.0.2.2:8083';
  /// auth
  static const String urlLogin = '$baseUrl/api/auth';

  /// data music
  static const String urlAllSong = '$baseUrl/api/songs';
  static const String urlAllArtist = '$baseUrl/api/artists';
  static const String urlSongsByArtist = '$baseUrl/api/artists';
  static const String urlGetFavoriteByUser = '$baseUrl/api/favorites';
  static const String urlSearchSongAndArtist = '$baseUrl/api/songs/search';

  static final _authService = AuthService();

  // get token
  // Helper method để lấy headers với token
  static Map<String, String> _getHeaders() {
    return _authService.getAuthHeaders();
  }

  static Future<List<Song>> getAllSongs() async {
    try {
      final response = await http.get(
        Uri.parse('$urlAllSong'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Song.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        // Token hết hạn -> logout
        await _authService.logout();
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Failed to load songs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching songs: $e');
      throw Exception('Network error: $e');
    }
  }

  ///get all artists
  static Future<List<Artist>> getAllArtists() async {
    try {
      final response = await http.get(
        Uri.parse('$urlAllArtist'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Artist.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        await _authService.logout();

        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Failed to load artists: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching artists: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<List<Song>> getSongsByArtist(String artistId) async {
    try {
      final response = await http.get(
        Uri.parse('$urlSongsByArtist/$artistId/songs'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Song.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        await _authService.logout();
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception(
          'Failed to load songs by artist: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching songs by artist: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<SearchResult> searchSongAngArtist(String query) async {
    try {
      final res = await http.get(
        Uri.parse('$urlSearchSongAndArtist?query=$query'),
        headers: _getHeaders(),
      );
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(res.body);
        return SearchResult.fromJson(jsonData);
      } else if (res.statusCode == 401) {
        await _authService.logout();
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Failed to search: ${res.statusCode}');
      }
    } catch (e) {
      print('Error searching: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<List<Favorite>> getFavoriteByUserId(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$urlGetFavoriteByUser/${userId}'),
        headers: _getHeaders(),
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Favorite.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        await _authService.logout();
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception('Failed to load favorites: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      throw Exception('Network error: $e');
    }
  }

  /// ✅ ADD FAVORITE - FIXED
  static Future<Favorite> addFavorite({
    required int userId,
    required int songId,
  }) async {
    try {
      print('📤 Adding favorite - userId: $userId, songId: $songId');

      final response = await http.post(
        Uri.parse(urlGetFavoriteByUser),
        headers: {
          ..._getHeaders(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'songId': songId,
        }),
      );

      print('📥 Add favorite response: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // ⚠️ Backend trả về { success, message, favorite }
        if (data['success'] == true && data['favorite'] != null) {
          return Favorite.fromJson(data['favorite']);
        } else {
          throw Exception(data['message'] ?? 'Thêm favorite thất bại');
        }
      } else if (response.statusCode == 401) {
        await _authService.logout();
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Lỗi thêm favorite');
      }
    } catch (e) {
      print('❌ Error adding favorite: $e');
      rethrow;
    }
  }

  /// ✅ REMOVE FAVORITE - FIXED
  static Future<bool> removeFavorite({
    required int userId,
    required int songId,
  }) async {
    try {
      print('🗑️ Removing favorite - userId: $userId, songId: $songId');

      final response = await http.delete(
        Uri.parse('$urlGetFavoriteByUser/$userId/$songId'),
        headers: _getHeaders(),
      );

      print('📥 Remove favorite response: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else if (response.statusCode == 401) {
        await _authService.logout();
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Lỗi xóa favorite');
      }
    } catch (e) {
      print('❌ Error removing favorite: $e');
      rethrow;
    }
  }

  /// ✅ CHECK FAVORITE STATUS - MỚI THÊM
  static Future<bool> checkFavoriteStatus({
    required int userId,
    required int songId,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$urlGetFavoriteByUser/$userId/check/$songId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['isFavorite'] ?? false;
      } else {
        return false;
      }
    } catch (e) {
      print('❌ Error checking favorite status: $e');
      return false;
    }
  }



}
