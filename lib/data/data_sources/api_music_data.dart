import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_app/data/models/artist.dart';

import '../models/song.dart';

class ApiMusicData {
  static const String baseUrl = 'http://10.0.2.2:8083';

  static const String urlAllSong   = '$baseUrl/api/songs';
  static const String urlAllArtist = '$baseUrl/api/artists';

  static Future<List<Song>> getAllSongs() async {
    try {
      final response = await http.get(
        Uri.parse('$urlAllSong'),
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

  ///get all artists
  static Future<List<Artist>> getAllArtists() async {
    try {
      final response = await http.get(
        Uri.parse('$urlAllArtist'),
        headers: {'Content-Type': 'application/json'},
      );
      if(response.statusCode == 200){
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Artist.fromJson(json)).toList();
      }else{
        throw Exception('Failed to load artists: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching artists: $e');
      throw Exception('Network error: $e');
    }
  }
}
