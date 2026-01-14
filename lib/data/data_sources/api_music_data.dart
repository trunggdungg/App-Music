import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/song.dart';

class ApiMusicData {
  static const String baseUrl = 'http://localhost:8083/api/songs';

  static Future<List<Song>> getAllSongs() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl'),
        headers: {'Content-Type': 'application/json'},
      );
      if(response.statusCode == 200){
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Song.fromJson(json)).toList();
      }else{
        throw Exception('Failed to load songs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching songs: $e');
      throw Exception('Network error: $e');
    }
  }
}
