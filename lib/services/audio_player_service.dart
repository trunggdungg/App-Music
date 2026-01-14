// lib/services/audio_player_service.dart

import 'package:just_audio/just_audio.dart';
import '../data/models/song.dart';

/// Service quản lý việc phát nhạc toàn ứng dụng
class AudioPlayerService {
  // Singleton pattern
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();

  Song? _currentSong;/// Bài hát hiện tại
  List<Song> _playlist = []; /// Danh sách phát hiện tại
  int _currentIndex = 0;/// Vị trí bài hát hiện tại trong playlist

  // Getters
  AudioPlayer get audioPlayer => _audioPlayer;
  Song? get currentSong => _currentSong;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;

  // Stream để lắng nghe trạng thái
  Stream<Duration> get positionStream => _audioPlayer.positionStream;/// Vị trí phát hiện tại
  Stream<Duration?> get durationStream => _audioPlayer.durationStream;/// Tổng thời lượng bài hát
  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;/// Trạng thái phát nhạc
  Stream<bool> get playingStream => _audioPlayer.playingStream;/// Trạng thái đang phát hay tạm dừng

  /// Phát một bài hát
  Future<void> playSong(Song song, {List<Song>? playlist, int? index}) async {
    try {
      _currentSong = song;

      if (playlist != null) {
        _playlist = playlist;
        _currentIndex = index ?? 0;
      } else {
        _playlist = [song];
        _currentIndex = 0;
      }
      // lấy duration
      final duration = await _audioPlayer.setUrl(song.audioUrl);
      if(duration != null){
      _currentSong = song.copyWith(duration: duration.inSeconds);

      }

      // Bắt đầu phát
      await _audioPlayer.play();
    } catch (e) {
      print('Lỗi khi phát nhạc: $e');
      rethrow;
    }
  }

  /// Tạm dừng
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  /// Tiếp tục phát
  Future<void> resume() async {
    await _audioPlayer.play();
  }

  /// Dừng hoàn toàn
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSong = null;
  }

  /// Bài tiếp theo
  Future<void> next() async {
    if (_playlist.isEmpty) return;

    _currentIndex = (_currentIndex + 1) % _playlist.length;
    await playSong(_playlist[_currentIndex], playlist: _playlist, index: _currentIndex);
  }

  /// Bài trước
  Future<void> previous() async {
    if (_playlist.isEmpty) return;

    _currentIndex = (_currentIndex - 1 + _playlist.length) % _playlist.length;
    await playSong(_playlist[_currentIndex], playlist: _playlist, index: _currentIndex);
  }

  /// Tua đến vị trí cụ thể
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// Set chế độ lặp lại
  Future<void> setLoopMode(LoopMode mode) async {
    await _audioPlayer.setLoopMode(mode);
  }

  /// Set chế độ shuffle
  Future<void> setShuffleMode(bool enabled) async {
    await _audioPlayer.setShuffleModeEnabled(enabled);
  }

  /// Set âm lượng (0.0 - 1.0)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  /// Dispose khi không dùng nữa
  void dispose() {
    _audioPlayer.dispose();
  }
}