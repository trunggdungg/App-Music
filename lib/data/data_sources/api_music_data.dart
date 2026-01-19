import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_app/data/models/artist.dart';
import 'package:music_app/data/models/favorite.dart';
import 'package:music_app/data/models/search_result.dart';

import '../../services/auth_service.dart';
import '../models/song.dart';

class ApiMusicData {
  static const String baseUrl = 'http://10.0.2.2:8083';

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

  static Future<Favorite> addFavorite({
    required int userId,
    required int songId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$urlGetFavoriteByUser'),
        headers: {
          ..._getHeaders(),
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userId': userId,
          'songId': songId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Favorite.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        await _authService.logout();
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception(
          'Failed to add favorite: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error adding favorite: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<bool> removeFavorite({
    required int userId,
    required int songId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('${urlGetFavoriteByUser}/$userId/$songId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else if (response.statusCode == 401) {
        await _authService.logout();
        throw Exception('Phiên đăng nhập hết hạn');
      } else {
        throw Exception(
          'Failed to remove favorite: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error removing favorite: $e');
      rethrow;
    }
  }



}
