import '../models/artist.dart';
import '../models/playlist.dart';
import '../models/song.dart';

class LocalMusicData {
  // ============ ARTISTS ============
  static final List<Artist> artists = [
    Artist(
      id: 'artist_1',
      name: 'Sơn Tùng M-TP',
      imageUrl: 'https://i.pravatar.cc/300?img=1',
      bio: 'Ca sĩ, nhạc sĩ người Việt Nam',
      followers: 5200000,
      genres: ['Pop', 'R&B'],
    ),
    Artist(
      id: 'artist_2',
      name: 'Hòa Minzy',
      imageUrl: 'https://i.pravatar.cc/300?img=2',
      bio: 'Ca sĩ nổi tiếng Việt Nam',
      followers: 3100000,
      genres: ['Pop', 'Ballad'],
    ),
    Artist(
      id: 'artist_3',
      name: 'Đen Vâu',
      imageUrl: 'https://i.pravatar.cc/300?img=3',
      bio: 'Rapper, nhạc sĩ tài năng',
      followers: 4500000,
      genres: ['Rap', 'Hip-hop'],
    ),
    Artist(
      id: 'artist_4',
      name: 'Mỹ Tâm',
      imageUrl: 'https://i.pravatar.cc/300?img=4',
      bio: 'Nữ hoàng nhạc Việt',
      followers: 6800000,
      genres: ['Pop', 'Ballad'],
    ),
    Artist(
      id: 'artist_5',
      name: 'Binz',
      imageUrl: 'https://i.pravatar.cc/300?img=5',
      bio: 'Rapper hàng đầu Việt Nam',
      followers: 2900000,
      genres: ['Rap', 'Hip-hop'],
    ),
  ];

  // ============ SONGS ============
  static final List<Song> songs = [
    // Sơn Tùng M-TP
    Song(
      id: 'song_1',
      title: 'Chúng Ta Của Hiện Tại',
      artist: 'Sơn Tùng M-TP',
      artistId: 'artist_1',
      albumArt: 'https://picsum.photos/300/300?random=1',
      audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',

      // 4:05
      album: 'Single',
      releaseYear: 2022,
      genres: ['Pop'],
    ),
    Song(
      id: 'song_2',
      title: 'Có Chắc Yêu Là Đây',
      artist: 'Sơn Tùng M-TP',
      artistId: 'artist_1',
      albumArt: 'https://picsum.photos/300/300?random=2',
      audioUrl: 'https://example.com/audio2.mp3',
      duration: 268,
      // 4:28
      album: 'Single',
      releaseYear: 2021,
      genres: ['Pop', 'R&B'],
    ),

    // Hòa Minzy
    Song(
      id: 'song_3',
      title: 'Rời Bỏ',
      artist: 'Hòa Minzy',
      artistId: 'artist_2',
      albumArt: 'https://picsum.photos/300/300?random=3',
      audioUrl: 'https://example.com/audio3.mp3',
      duration: 312,
      // 5:12
      album: 'Single',
      releaseYear: 2023,
      genres: ['Ballad'],
    ),
    Song(
      id: 'song_4',
      title: 'Không Thể Cùng Nhau Suốt Kiếp',
      artist: 'Hòa Minzy',
      artistId: 'artist_2',
      albumArt: 'https://picsum.photos/300/300?random=4',
      audioUrl: 'https://example.com/audio4.mp3',
      duration: 290,
      // 4:50
      album: 'Single',
      releaseYear: 2022,
      genres: ['Pop', 'Ballad'],
    ),

    // Đen Vâu
    Song(
      id: 'song_5',
      title: 'Bài Này Chill Phết',
      artist: 'Đen Vâu ft. MIN',
      artistId: 'artist_3',
      albumArt: 'https://picsum.photos/300/300?random=5',
      audioUrl: 'https://example.com/audio5.mp3',
      duration: 234,
      // 3:54
      album: 'Single',
      releaseYear: 2020,
      genres: ['Rap', 'Chill'],
    ),
    Song(
      id: 'song_6',
      title: 'Anh Đếch Cần Gì Nhiều Ngoài Em',
      artist: 'Đen Vâu ft. Thành Đồng',
      artistId: 'artist_3',
      albumArt: 'https://picsum.photos/300/300?random=6',
      audioUrl: 'https://example.com/audio6.mp3',
      duration: 278,
      // 4:38
      album: 'Single',
      releaseYear: 2019,
      genres: ['Rap', 'Hip-hop'],
    ),

    // Mỹ Tâm
    Song(
      id: 'song_7',
      title: 'Đừng Hỏi Em',
      artist: 'Mỹ Tâm',
      artistId: 'artist_4',
      albumArt: 'https://picsum.photos/300/300?random=7',
      audioUrl: 'https://example.com/audio7.mp3',
      duration: 295,
      // 4:55
      album: 'Tâm 9',
      releaseYear: 2015,
      genres: ['Pop'],
    ),
    Song(
      id: 'song_8',
      title: 'Ước Gì',
      artist: 'Mỹ Tâm',
      artistId: 'artist_4',
      albumArt: 'https://picsum.photos/300/300?random=8',
      audioUrl: 'https://example.com/audio8.mp3',
      duration: 310,
      // 5:10
      album: 'Tâm 9',
      releaseYear: 2015,
      genres: ['Ballad'],
    ),

    // Binz
    Song(
      id: 'song_9',
      title: 'Bigcityboi',
      artist: 'Binz',
      artistId: 'artist_5',
      albumArt: 'https://picsum.photos/300/300?random=9',
      audioUrl: 'https://example.com/audio9.mp3',
      duration: 198,
      // 3:18
      album: 'Single',
      releaseYear: 2019,
      genres: ['Rap', 'Hip-hop'],
    ),
    Song(
      id: 'song_10',
      title: 'OK',
      artist: 'Binz',
      artistId: 'artist_5',
      albumArt: 'https://picsum.photos/300/300?random=10',
      audioUrl: 'https://example.com/audio10.mp3',
      duration: 223,
      // 3:43
      album: 'Single',
      releaseYear: 2020,
      genres: ['Rap'],
    ),

    // Thêm một số bài nữa cho đa dạng
    Song(
      id: 'song_11',
      title: 'Hãy Trao Cho Anh',
      artist: 'Sơn Tùng M-TP',
      artistId: 'artist_1',
      albumArt: 'https://picsum.photos/300/300?random=11',
      audioUrl: 'https://example.com/audio11.mp3',
      duration: 256,
      // 4:16
      album: 'Single',
      releaseYear: 2019,
      genres: ['Pop', 'EDM'],
    ),
    Song(
      id: 'song_12',
      title: 'Lạc Trôi',
      artist: 'Sơn Tùng M-TP',
      artistId: 'artist_1',
      albumArt: 'https://picsum.photos/300/300?random=12',
      audioUrl: 'https://example.com/audio12.mp3',
      duration: 287,
      // 4:47
      album: 'Single',
      releaseYear: 2017,
      genres: ['Pop', 'Electronic'],
    ),
  ];

  // ============ PLAYLISTS ============
  static final List<Playlist> playlists = [
    Playlist(
      id: 'playlist_1',
      name: 'Top V-Pop 2024',
      description: 'Những bài hát V-Pop hot nhất năm 2024',
      coverImage: 'https://picsum.photos/400/400?random=101',
      songs: [songs[0], songs[1], songs[2], songs[6]],
      createdAt: DateTime(2024, 1, 1),
      isPublic: true,
    ),
    Playlist(
      id: 'playlist_2',
      name: 'Chill Vibes',
      description: 'Nhạc thư giãn, nghe lúc làm việc',
      coverImage: 'https://picsum.photos/400/400?random=102',
      songs: [songs[4], songs[5], songs[3]],
      createdAt: DateTime(2024, 2, 15),
      isPublic: true,
    ),
    Playlist(
      id: 'playlist_3',
      name: 'Rap Việt',
      description: 'Tuyển tập rap Việt hay nhất',
      coverImage: 'https://picsum.photos/400/400?random=103',
      songs: [songs[4], songs[5], songs[8], songs[9]],
      createdAt: DateTime(2024, 3, 10),
      isPublic: true,
    ),
    Playlist(
      id: 'playlist_4',
      name: 'Ballad Buồn',
      description: 'Những bản ballad da diết',
      coverImage: 'https://picsum.photos/400/400?random=104',
      songs: [songs[2], songs[3], songs[7]],
      createdAt: DateTime(2024, 4, 5),
      isPublic: true,
    ),
  ];


  // Lấy bài hát theo ID
  static Song? getSongById(String id) {
    try {
      return songs.firstWhere((song) => song.id == id);
    } catch (e) {
      return null;
    }
  }

  // Lấy nghệ sĩ theo ID
  static Artist? getArtistById(String id) {
    try {
      return artists.firstWhere((artist) => artist.id == id);
    } catch (e) {
      return null;
    }
  }

  // Lấy playlist theo ID
  static Playlist? getPlaylistById(String id) {
    try {
      return playlists.firstWhere((playlist) => playlist.id == id);
    } catch (e) {
      return null;
    }
  }

  // Lấy bài hát của 1 nghệ sĩ
  static List<Song> getSongsByArtist(String artistId) {
    return songs.where((song) => song.artistId == artistId).toList();
  }

  // Tìm kiếm bài hát
  static List<Song> searchSongs(String query) {
    final lowerQuery = query.toLowerCase();
    return songs.where((song) {
      return song.title.toLowerCase().contains(lowerQuery) ||
          song.artist.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Tìm kiếm nghệ sĩ
  static List<Artist> searchArtists(String query) {
    final lowerQuery = query.toLowerCase();
    return artists.where((artist) {
      return artist.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Lấy bài hát ngẫu nhiên (cho Recently Played)
  static List<Song> getRandomSongs(int count) {
    final shuffled = List<Song>.from(songs)..shuffle();
    return shuffled.take(count).toList();
  }
}