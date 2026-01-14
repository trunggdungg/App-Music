import 'album.dart';
import 'artist.dart';

class Song {
  final int id;
  final String title;
  final Artist artist;
  final Album album;
  final int duration;
  final String audioUrl;
  final String albumArt;
  final DateTime? releaseDate;
  final String status;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.duration,
    required this.audioUrl,
    required this.albumArt,
    this.releaseDate,
    required this.status,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'] as int,
      title: json['title'] ?? '',
      artist: json['artist'],
      album: json['album'],
      duration: json['duration'] as int,
      audioUrl: json['fileUrl'] ?? '',
      // ✅ KEY ĐÚNG
      albumArt: json['coverImageUrl'] ?? '',
      // ✅ KEY ĐÚNG
      releaseDate: json['releaseDate'] != null
          ? DateTime.parse(json['releaseDate'])
          : null,
      status: json['status'] ?? 'UNKNOWN',
    );
  }

  /// To Json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'duration': duration,
      'fileUrl': audioUrl,
      'coverImageUrl': albumArt,
      'releaseDate': releaseDate?.toIso8601String(),
      'status': status,
    };
  }

  Song copyWith({
    int? id,
    String? title,
    Artist? artist,
    Album? album,
    int? duration,
    String? audioUrl,
    String? albumArt,
    DateTime? releaseDate,
    String? status,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      duration: duration ?? this.duration,
      audioUrl: audioUrl ?? this.audioUrl,
      albumArt: albumArt ?? this.albumArt,
      releaseDate: releaseDate ?? this.releaseDate,
      status: status ?? this.status,
    );
  }

  String get durationFormatted {
    if (duration == null) {
      return '--:--'; // hoặc '00:00'
    }

    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
