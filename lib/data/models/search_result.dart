import 'package:music_app/data/models/song.dart';

import 'artist.dart';

class SearchResult {
  final List<Song> songs;
  final List<Artist> artists;
  final int totalSongs;
  final int totalArtists;

  SearchResult({
    required this.songs,
    required this.artists,
    required this.totalSongs,
    required this.totalArtists,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      songs: json['songs'] != null
          ? (json['songs'] as List).map((s) => Song.fromJson(s)).toList()
          : [],
      artists: json['artists'] != null
          ? (json['artists'] as List).map((a) => Artist.fromJson(a)).toList()
          : [],
      totalSongs: json['totalSongs'] ?? 0,
      totalArtists: json['totalArtists'] ?? 0,
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'songs': songs.map((s) => s.toJson()).toList(),
      'artists': artists.map((a) => a.toJson()).toList(),
      'totalSongs': totalSongs,
      'totalArtists': totalArtists,
    };
  }

  // Helper methods
  bool get isEmpty => songs.isEmpty && artists.isEmpty;
  bool get isNotEmpty => !isEmpty;
  int get totalResults => totalSongs + totalArtists;
}