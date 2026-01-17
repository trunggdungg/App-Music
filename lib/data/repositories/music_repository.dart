// lib/data/repositories/music_repository.dart

import '../models/favorite.dart';
import '../models/search_result.dart';
import '../models/song.dart';
import '../models/artist.dart';
import '../models/playlist.dart';

/// Abstract class định nghĩa các phương thức
/// Sau này chỉ cần implement ApiMusicRepository là xong!
abstract class MusicRepository {
  Future<List<Song>> getAllSongs();

  Future<List<Song>> getSongsByArtist(String artistId);

  Future<List<Song>> getRecentlyPlayed();

  Future<List<Song>> getRecommendedSongs();

  Future<List<Artist>> getAllArtists();

  Future<List<Favorite>> getFavoritesByUserId(int userId);

  Future<SearchResult> search(String keyword);
}
