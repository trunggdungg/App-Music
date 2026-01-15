// lib/data/models/artist.dart

class Artist {
  final int artistId;
  final String name;
  final String imageUrl;
  final String? bio;
  final int followers;
  final List<String> genres;

  Artist({
    required this.artistId,
    required this.name,
    required this.imageUrl,
    this.bio,
    this.followers = 0,
    this.genres = const [],
  });

  // Chuyển từ JSON (chuẩn bị cho API sau này)
  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      artistId: json['artistId'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: json['photoUrl'] ?? '',
      bio: json['bio'],
      followers: json['totalFollowers'] ?? 0,
      genres: (json['genres'] is List)
          ? List<String>.from(json['genres'])
          : const [],
    );
  }


  // Chuyển sang JSON
  Map<String, dynamic> toJson() {
    return {
      'artistId': artistId,
      'name': name,
      'imageUrl': imageUrl,
      'bio': bio,
      'followers': followers,
      'genres': genres,
    };
  }

  // Copy with method
  Artist copyWith({
    int? artistId,
    String? name,
    String? imageUrl,
    String? bio,
    int? followers,
    List<String>? genres,
  }) {
    return Artist(
      artistId: artistId ?? this.artistId,
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