import 'package:music_app/data/data_sources/api_music_data.dart';
import 'package:music_app/data/models/artist.dart';

import 'package:music_app/data/models/playlist.dart';

import 'package:music_app/data/models/song.dart';

import 'music_repository.dart';

class ApiMusicRepository  extends MusicRepository {
  @override
  Future<List<Artist>> getAllArtists() {
    // TODO: implement getAllArtists
    throw UnimplementedError();
  }

  @override
  Future<List<Playlist>> getAllPlaylists() {
    // TODO: implement getAllPlaylists
    throw UnimplementedError();
  }

  @override
  Future<List<Song>> getAllSongs() async {
    return await ApiMusicData.getAllSongs();
  }

  @override
  Future<Artist?> getArtistById(String id) {
    // TODO: implement getArtistById
    throw UnimplementedError();
  }

  @override
  Future<Playlist?> getPlaylistById(String id) {
    // TODO: implement getPlaylistById
    throw UnimplementedError();
  }

  @override
  Future<List<Song>> getRecentlyPlayed() {
    // TODO: implement getRecentlyPlayed
    throw UnimplementedError();
  }

  @override
  Future<List<Song>> getRecommendedSongs() {
    // TODO: implement getRecommendedSongs
    throw UnimplementedError();
  }

  @override
  Future<Song?> getSongById(String id) {
    // TODO: implement getSongById
    throw UnimplementedError();
  }

  @override
  Future<List<Song>> getSongsByArtist(String artistId) {
    // TODO: implement getSongsByArtist
    throw UnimplementedError();
  }

  @override
  Future<List<Artist>> searchArtists(String query) {
    // TODO: implement searchArtists
    throw UnimplementedError();
  }

  @override
  Future<List<Song>> searchSongs(String query) {
    // TODO: implement searchSongs
    throw UnimplementedError();
  }

}