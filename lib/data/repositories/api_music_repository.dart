import 'package:music_app/data/data_sources/api_music_data.dart';
import 'package:music_app/data/models/artist.dart';
import 'package:music_app/data/models/favorite.dart';

import 'package:music_app/data/models/playlist.dart';
import 'package:music_app/data/models/search_result.dart';

import 'package:music_app/data/models/song.dart';

import '../../services/auth_service.dart';
import 'music_repository.dart';

class ApiMusicRepository implements MusicRepository {
  final AuthService _authService = AuthService();
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
      final currentUserId = _authService.currentUserId;

      if (currentUserId == null) {
        throw Exception('User chưa đăng nhập');
      }
      return await ApiMusicData.getFavoriteByUserId(userId.toString());
    } catch (e) {
      print('Error in getFavoritesByUserId: $e');
      return Future.value([]);
    }
  }

  /// ✅ THÊM PHƯƠNG THỨC: Lấy favorite của user hiện tại
  Future<List<Favorite>> getCurrentUserFavorites() async {
    final currentUserId = _authService.currentUserId;

    if (currentUserId == null) {
      throw Exception('Bạn cần đăng nhập để xem danh sách yêu thích');
    }

    return getFavoritesByUserId(currentUserId);
  }

  /// ✅ THÊM PHƯƠNG THỨC: Thêm bài hát vào yêu thích
  Future<bool> addToFavorites(int songId) async {
    try {
      final currentUserId = _authService.currentUserId;

      if (currentUserId == null) {
        throw Exception('Bạn cần đăng nhập');
      }

      // TODO: Gọi API để thêm favorite
      await ApiMusicData.addFavorite(userId: currentUserId, songId: songId);

      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  /// ✅ THÊM PHƯƠNG THỨC: Xóa bài hát khỏi yêu thích
  Future<bool> removeFromFavorites(int songId) async {
    try {
      final currentUserId = _authService.currentUserId;

      if (currentUserId == null) {
        throw Exception('Bạn cần đăng nhập');
      }

      // TODO: Gọi API để xóa favorite
      return await ApiMusicData.removeFavorite(
        userId: currentUserId,
        songId: songId,
      );

      return true;
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }
}
