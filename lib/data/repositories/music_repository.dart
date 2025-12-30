// lib/data/repositories/music_repository.dart

import '../models/song.dart';
import '../models/artist.dart';
import '../models/playlist.dart';
import '../data_sources/local_music_data.dart';

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
}

/// Implementation dùng local data
/// Sau này sẽ có ApiMusicRepository
class LocalMusicRepository implements MusicRepository {

  // Giả lập delay network để realistic hơn
  Future<void> _simulateNetworkDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Future<List<Song>> getAllSongs() async {
    await _simulateNetworkDelay();
    return LocalMusicData.songs;
  }

  @override
  Future<Song?> getSongById(String id) async {
    await _simulateNetworkDelay();
    return LocalMusicData.getSongById(id);
  }

  @override
  Future<List<Song>> getRecentlyPlayed() async {
    await _simulateNetworkDelay();
    // Giả lập lấy 8 bài gần đây nhất (random)
    return LocalMusicData.getRandomSongs(8);
  }

  @override
  Future<List<Song>> getRecommendedSongs() async {
    await _simulateNetworkDelay();
    // Giả lập lấy 10 bài recommend (random)
    return LocalMusicData.getRandomSongs(10);
  }

  @override
  Future<List<Song>> searchSongs(String query) async {
    await _simulateNetworkDelay();
    return LocalMusicData.searchSongs(query);
  }

  @override
  Future<List<Artist>> getAllArtists() async {
    await _simulateNetworkDelay();
    return LocalMusicData.artists;
  }

  @override
  Future<Artist?> getArtistById(String id) async {
    await _simulateNetworkDelay();
    return LocalMusicData.getArtistById(id);
  }

  @override
  Future<List<Song>> getSongsByArtist(String artistId) async {
    await _simulateNetworkDelay();
    return LocalMusicData.getSongsByArtist(artistId);
  }

  @override
  Future<List<Artist>> searchArtists(String query) async {
    await _simulateNetworkDelay();
    return LocalMusicData.searchArtists(query);
  }

  @override
  Future<List<Playlist>> getAllPlaylists() async {
    await _simulateNetworkDelay();
    return LocalMusicData.playlists;
  }

  @override
  Future<Playlist?> getPlaylistById(String id) async {
    await _simulateNetworkDelay();
    return LocalMusicData.getPlaylistById(id);
  }
}

// ========== SAU NÀY KHI LÀM API ==========
// class ApiMusicRepository implements MusicRepository {
//   final String baseUrl = 'http://your-api.com';
//
//   @override
//   Future<List<Song>> getAllSongs() async {
//     final response = await http.get(Uri.parse('$baseUrl/songs'));
//     final data = json.decode(response.body) as List;
//     return data.map((json) => Song.fromJson(json)).toList();
//   }
//
//   // ... implement các method khác
// }