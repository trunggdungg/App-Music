import 'package:music_app/data/data_sources/api_music_data.dart';
import 'package:music_app/data/models/artist.dart';
import 'package:music_app/data/models/favorite.dart';

import 'package:music_app/data/models/playlist.dart';
import 'package:music_app/data/models/search_result.dart';

import 'package:music_app/data/models/song.dart';

import 'music_repository.dart';

class ApiMusicRepository implements MusicRepository {
  /// lấy tất cả bài hát
  @override
  Future<List<Song>> getAllSongs() async {
    try {
      return await ApiMusicData.getAllSongs();
    } catch (e) {
      print('Error in getAllSongs: $e');
      return [];
    }
  }
/// tìm kiếm bài hát và nghệ sĩ
  @override
  Future<SearchResult> search(String keyword) async{
   try{
     return await ApiMusicData.searchSongAngArtist(keyword);
   }catch(e){
     print('Error in search: $e');
      return SearchResult(songs: [], artists: [], totalSongs: 0, totalArtists: 0);
   }
  }

  /// lấy danh sách bài hát theo nghệ sĩ
  @override
  Future<List<Song>> getSongsByArtist(String artistId) async {
    try {
      final songs = await ApiMusicData.getSongsByArtist(artistId);
      print('Songs by artist $artistId:');
      for (var song in songs) {
        print('- ${song.id} | ${song.title}');
      }
      return songs;
    } catch (e) {
      print('Error in getSongsByArtist: $e');
      return [];
    }
  }

  /// lấy danh sách bài hát đã nghe gần đây
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

  /// lấy danh sách bài hát được đề xuất
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

  /// lấy tất cả nghệ sĩ
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

  /// lấy danh sách yêu thích của user theo userId
  @override
  Future<List<Favorite>> getFavoritesByUserId(int userId) async {
    try {
      return await ApiMusicData.getFavoriteByUserId(userId.toString());
    } catch (e) {
      print('Error in getFavoritesByUserId: $e');
      return Future.value([]);
    }
  }
}
