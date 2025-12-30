// lib/data/models/artist.dart

class Artist {
  final String id;
  final String name;
  final String imageUrl;
  final String? bio;
  final int followers;
  final List<String> genres;

  Artist({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.bio,
    this.followers = 0,
    this.genres = const [],
  });

  // Chuyển từ JSON (chuẩn bị cho API sau này)
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      bio: json['bio'],
      followers: json['followers'] ?? 0,
      genres: json['genres'] != null
          ? List<String>.from(json['genres'])
          : [],
    );
  }

  // Chuyển sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'bio': bio,
      'followers': followers,
      'genres': genres,
    };
  }

  // Copy with method
  Artist copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? bio,
    int? followers,
    List<String>? genres,
  }) {
    return Artist(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      genres: genres ?? this.genres,
    );
  }

  // Format số followers (1M, 500K, ...)
  String get formattedFollowers {
    if (followers >= 1000000) {
      return '${(followers / 1000000).toStringAsFixed(1)}M';
    } else if (followers >= 1000) {
      return '${(followers / 1000).toStringAsFixed(1)}K';
    }
    return followers.toString();
  }
}