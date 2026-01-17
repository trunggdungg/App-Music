// lib/data/repositories/music_repository.dart

import '../models/favorite.dart';
import '../models/song.dart';
import '../models/artist.dart';
import '../models/playlist.dart';

/// Abstract class định nghĩa các phương thức
/// Sau này chỉ cần implement ApiMusicRepository là xong!
abstract class MusicRepository {
  Future<List<Song>> getAllSongs();
  Future<Song?> getSongById(String id);
  Future<List<Song>> getRecentlyPlayed();
  Future<List<Song>> getRecommendedSongs();
  Future<List<Song>> searchSongs(String query);

  Future<List<Artist>> getAllArtists();
  Future<Artist?> getArtistById(String id);
  Future<List<Song>> getSongsByArtist(String artistId);
  Future<List<Artist>> searchArtists(String query);

  Future<List<Playlist>> getAllPlaylists();
  Future<Playlist?> getPlaylistById(String id);

  // Future<List<Song>> getFavoriteSongsByUserId();

  Future<List<Favorite>> getFavoritesByUserId(int userId);
}