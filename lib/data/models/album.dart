import 'artist.dart';

class Album {
  final int albumId;
  final String title;
  final Artist artist;           // ✅ artist object
  final String coverImageUrl;
  final String? description;
  final int? totalSongs;
  final DateTime? releaseDate;

  Album({
    required this.albumId,
    required this.title,
    required this.artist,
    required this.coverImageUrl,
    this.description,
    this.totalSongs,
    this.releaseDate,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      albumId: json['albumId'],
      title: json['title'] ?? '',
      artist: Artist.fromJson(json['artist']), // ✅ map nested
      coverImageUrl: json['coverImageUrl'] ?? '',
      description: json['description'],
      totalSongs: json['totalSongs'],
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : null,
    );
  }
}
