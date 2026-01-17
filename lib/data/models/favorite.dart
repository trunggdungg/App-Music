import 'song.dart';
import 'package:music_app/data/models/user.dart';

class Favorite {
  final int id;
  final User? user;
  final Song song;
  final DateTime createdAt;

  Favorite({
    required this.id,
    this.user,
    required this.song,
    required this.createdAt,
  });

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      id: json['id'] ?? 0,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      song: Song.fromJson(json['song']),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'song': song.toJson(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}