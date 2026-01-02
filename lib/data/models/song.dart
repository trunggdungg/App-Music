class Song {
  final String id;
  final String title;
  final String artist;
  final String artistId;
  final String albumArt;
  final String audioUrl;
  final int? duration; // Duration in seconds
  final String? album;
  final int? releaseYear;
  final List<String> genres;

  Song({
  required this.id,
  required this.title,
  required this.artist,
  required this.artistId,
  required this.albumArt,
  required this.audioUrl,
  this.duration,
  this.album,
  this.releaseYear,
  this.genres = const [],
  });

  /// Json
 factory Song.fromJson(Map<String, dynamic> json){
   return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      artistId: json['artistId'],
      albumArt: json['albumArt'],
      audioUrl: json['audioUrl'],
      duration: json['duration'],
      album: json['album'],
      releaseYear: json['releaseYear'],
      genres: List<String>.from(json['genres'] ?? []),
   );
 }

  /// To Json
  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'artistId': artistId,
      'albumArt': albumArt,
      'audioUrl': audioUrl,
      'duration': duration,
      'album': album,
      'releaseYear': releaseYear,
      'genres': genres,
    };
  }

  Song copyWith({
    String? id,
    String? title,
    String? artist,
    String? artistId,
    String? albumArt,
    String? audioUrl,
    int? duration,
    String? album,
    int? releaseYear,
    List<String>? genres,
  }) {
    return Song(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      artistId: artistId ?? this.artistId,
      albumArt: albumArt ?? this.albumArt,
      audioUrl: audioUrl ?? this.audioUrl,
      duration: duration ?? this.duration,
      album: album ?? this.album,
      releaseYear: releaseYear ?? this.releaseYear,
      genres: genres ?? this.genres,
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