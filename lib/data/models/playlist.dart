import 'package:music_app/data/models/song.dart';

class Playlist {
  final String id;
  final String name;
  final String description;
  final String coverImage;
  final List<Song> songs;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isPublic;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.coverImage,
    required this.songs,
    required this.createdAt,
    this.updatedAt,
    this.isPublic = true,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'] ?? '',
      songs: json['songs'] != null
          ? (json['songs'] as List).map((s) => Song.fromJson(s)).toList()
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
      isPublic: json['isPublic'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'coverImage': coverImage,
      'songs': songs.map((s) => s.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isPublic': isPublic,
    };
  }

  int get totalDuration {
    return songs.fold(0, (sum, song) => sum + song.duration);
  }

  // Tổng số bài hát
  int get songCount => songs.length;

  String get formattedTotalDuration {
    int hours = totalDuration ~/ 3600;
    int minutes = (totalDuration % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Playlist copyWith({
    String? id,
    String? name,
    String? description,
    String? coverImage,
    List<Song>? songs,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublic,
  }) {
    return Playlist(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      songs: songs ?? this.songs,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublic: isPublic ?? this.isPublic,
    );
  }
}
