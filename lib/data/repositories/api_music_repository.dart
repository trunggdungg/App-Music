import 'package:music_app/data/data_sources/api_music_data.dart';
import 'package:music_app/data/models/artist.dart';

import 'package:music_app/data/models/playlist.dart';

import 'package:music_app/data/models/song.dart';

import 'music_repository.dart';

class ApiMusicRepository implements MusicRepository {
  @override
  Future<List<Song>> getAllSongs() async {
    try {
      return await ApiMusicData.getAllSongs();
    } catch (e) {
      print('Error in getAllSongs: $e');
      return [];
    }
  }

  @override
  Future<List<Song>> getRecentlyPlayed() async {
    try {
      final songs = await getAllSongs();
      return songs.take(8).toList();
    } catch (e) {
      print('Error in getRecentlyPlayed: $e');
      return [];
    }
  }

  @override
  Future<List<Song>> getRecommendedSongs() async {
    try {
      final songs = await getAllSongs();
      return songs.skip(8).take(10).toList();
    } catch (e) {
      print('Error in getRecommendedSongs: $e');
      return [];
    }
  }

  @override
  Future<List<Song>> searchSongs(String query) async {
    throw UnimplementedError();
  }

  // ✅ IMPLEMENT CÁC METHOD CÒN LẠI
  @override
  Future<List<Artist>> getAllArtists() async {
    try {
      final artists = await ApiMusicData.getAllArtists();
      return artists;
    } catch (e) {
      print('Error in getAllArtists: $e');
      return [];
    }
  }

  @override
  Future<Artist?> getArtistById(String id) async {
    // TODO: Khi backend có API /api/artists/{id}
    return null;
  }

  @override
  Future<List<Song>> getSongsByArtist(String artistId) async {
    // TODO: Khi backend có API /api/songs/artist/{artistId}
    return [];
  }

  @override
  Future<List<Artist>> searchArtists(String query) async {
    // TODO: Khi backend có API /api/artists/search
    return [];
  }

  @override
  Future<List<Playlist>> getAllPlaylists() async {
    // TODO: Khi backend có API /api/playlists
    return [];
  }

  @override
  Future<Playlist?> getPlaylistById(String id) async {
    // TODO: Khi backend có API /api/playlists/{id}
    return null;
  }

  @override
  Future<Song?> getSongById(String id) {
    // TODO: implement getSongById
    throw UnimplementedError();
  }
}
