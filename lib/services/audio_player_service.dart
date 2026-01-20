// lib/services/audio_player_service.dart

import 'dart:async';

import 'package:just_audio/just_audio.dart';
import '../data/models/song.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();

  factory AudioPlayerService() => _instance;

  AudioPlayerService._internal() {
    _init();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  Song? _currentSong;
  List<Song> _playlist = [];
  int _currentIndex = 0;

  // Getters
  AudioPlayer get audioPlayer => _audioPlayer;

  Song? get currentSong => _currentSong;

  List<Song> get playlist => _playlist;

  int get currentIndex => _currentIndex;

  bool get hasNext => _currentIndex < _playlist.length - 1;

  bool get hasPrevious => _currentIndex > 0;

  // Streams
  Stream<Duration> get positionStream => _audioPlayer.positionStream;

  Stream<Duration?> get durationStream => _audioPlayer.durationStream;

  Stream<PlayerState> get playerStateStream => _audioPlayer.playerStateStream;

  Stream<bool> get playingStream => _audioPlayer.playingStream;

  /// THÊM STREAM ĐỂ LẮNG NGHE THAY ĐỔI BÀI HÁT
  Stream<Song?> get currentSongStream => _currentSongController.stream;
  final _currentSongController = StreamController<Song?>.broadcast();

  void _init() {
    // Tự động phát bài tiếp theo khi bài hiện tại kết thúc
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        print('🎵 Bài hát kết thúc, auto-next...');

        // Kiểm tra loop mode
        if (_audioPlayer.loopMode == LoopMode.off && hasNext) {
          _autoNext(); // ✅ GỌI _autoNext thay vì next()
        } else if (_audioPlayer.loopMode == LoopMode.all && !hasNext) {
          // Quay lại bài đầu tiên
          _currentIndex = 0;
          _autoPlaySong(_playlist[0], playlist: _playlist, index: 0);
        } else if (_audioPlayer.loopMode == LoopMode.one) {
          // Phát lại bài hiện tại
          _audioPlayer.seek(Duration.zero);
          _audioPlayer.play();
        }
      }
    });
  }

  /// ✅ AUTO NEXT - KHÔNG NAVIGATE
  Future<void> _autoNext() async {
    if (_playlist.isEmpty || !hasNext) return;

    print('🎵 Auto-next từ bài ${_currentIndex} sang ${_currentIndex + 1}');

    _currentIndex++;
    await _autoPlaySong(
      _playlist[_currentIndex],
      playlist: _playlist,
      index: _currentIndex,
    );
  }

  /// ✅ AUTO PLAY - CHỈ PHÁT NHẠC, KHÔNG NAVIGATE
  Future<void> _autoPlaySong(
    Song song, {
    List<Song>? playlist,
    int? index,
  }) async {
    try {
      print('🎵 Auto playing: ${song.title}');

      _currentSong = song;

      if (playlist != null) {
        _playlist = playlist;
        _currentIndex = index ?? 0;
      }

      // ✅ PHÁT SỰ KIỆN THAY ĐỔI BÀI HÁT
      _currentSongController.add(_currentSong);

      // Load và phát nhạc
      final duration = await _audioPlayer.setUrl(song.audioUrl);
      if (duration != null) {
        _currentSong = song.copyWith(duration: duration.inSeconds);
        _currentSongController.add(_currentSong); // Update lại với duration
      }

      await _audioPlayer.play();
      print('✅ Auto play thành công: ${song.title}');
    } catch (e) {
      print('❌ Lỗi khi auto play: $e');
    }
  }

  /// Phát một bài hát
  Future<void> playSong(Song song, {List<Song>? playlist, int? index}) async {
    if (currentSong?.id == song.id && _audioPlayer.playing) {
      return;
    }

    try {
      _currentSong = song;

      if (playlist != null) {
        _playlist = playlist;
        _currentIndex = index ?? 0;
      } else {
        _playlist = [song];
        _currentIndex = 0;
      }

      // ✅ PHÁT SỰ KIỆN THAY ĐỔI BÀI HÁT
      _currentSongController.add(_currentSong);
      // Load và phát nhạc
      final duration = await _audioPlayer.setUrl(song.audioUrl);
      if (duration != null) {
        _currentSong = song.copyWith(duration: duration.inSeconds);
        _currentSongController.add(_currentSong);
      }

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

  /// Toggle play/pause
  Future<void> togglePlayPause() async {
    if (_audioPlayer.playing) {
      await pause();
    } else {
      await resume();
    }
  }

  /// Dừng hoàn toàn
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentSong = null;
    _currentSongController.add(null);
  }

  /// Bài tiếp theo
  Future<void> next() async {
    if (_playlist.isEmpty) return;

    // Nếu đang shuffle
    if (_audioPlayer.shuffleModeEnabled) {
      // Random một bài khác
      int newIndex;
      do {
        newIndex = DateTime.now().millisecond % _playlist.length;
      } while (newIndex == _currentIndex && _playlist.length > 1);

      _currentIndex = newIndex;
    } else {
      // Kiểm tra loop mode
      if (_audioPlayer.loopMode == LoopMode.one) {
        // Phát lại bài hiện tại
        await seek(Duration.zero);
        await resume();
        return;
      } else if (hasNext) {
        _currentIndex++;
      } else if (_audioPlayer.loopMode == LoopMode.all) {
        // Quay lại bài đầu
        _currentIndex = 0;
      } else {
        // Đã hết playlist và không loop
        return;
      }
    }

    await playSong(
      _playlist[_currentIndex],
      playlist: _playlist,
      index: _currentIndex,
    );
  }

  /// Bài trước
  /// Bài trước
  Future<void> previous() async {
    if (_playlist.isEmpty) return;

    print('🎵 User previous');

    // Nếu đã phát > 3 giây, restart bài hiện tại
    final position = _audioPlayer.position;
    if (position.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }

    // Nếu đang shuffle
    if (_audioPlayer.shuffleModeEnabled) {
      int newIndex;
      do {
        newIndex = DateTime.now().millisecond % _playlist.length;
      } while (newIndex == _currentIndex && _playlist.length > 1);
      _currentIndex = newIndex;
    } else {
      if (_audioPlayer.loopMode == LoopMode.one) {
        await seek(Duration.zero);
        await resume();
        return;
      } else if (hasPrevious) {
        _currentIndex--;
      } else if (_audioPlayer.loopMode == LoopMode.all) {
        _currentIndex = _playlist.length - 1;
      } else {
        await seek(Duration.zero);
        return;
      }
    }

    await playSong(
      _playlist[_currentIndex],
      playlist: _playlist,
      index: _currentIndex,
    );
  }

  /// Tua đến vị trí cụ thể
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// Set chế độ lặp lại
  Future<void> setLoopMode(LoopMode mode) async {
    await _audioPlayer.setLoopMode(mode);
  }

  /// Cycle qua các loop modes: off -> all -> one -> off
  Future<void> cycleLoopMode() async {
    final currentMode = _audioPlayer.loopMode;
    LoopMode nextMode;

    switch (currentMode) {
      case LoopMode.off:
        nextMode = LoopMode.all;
        break;
      case LoopMode.all:
        nextMode = LoopMode.one;
        break;
      case LoopMode.one:
        nextMode = LoopMode.off;
        break;
    }

    await setLoopMode(nextMode);
  }

  /// Set chế độ shuffle
  Future<void> setShuffleMode(bool enabled) async {
    await _audioPlayer.setShuffleModeEnabled(enabled);
  }

  /// Toggle shuffle mode
  Future<void> toggleShuffle() async {
    await setShuffleMode(!_audioPlayer.shuffleModeEnabled);
  }

  /// Set âm lượng (0.0 - 1.0)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Tăng âm lượng
  Future<void> increaseVolume([double amount = 0.1]) async {
    final currentVolume = _audioPlayer.volume;
    await setVolume(currentVolume + amount);
  }

  /// Giảm âm lượng
  Future<void> decreaseVolume([double amount = 0.1]) async {
    final currentVolume = _audioPlayer.volume;
    await setVolume(currentVolume - amount);
  }

  /// Tua tới 10 giây
  Future<void> seekForward([int seconds = 10]) async {
    final position = _audioPlayer.position;
    final duration = _audioPlayer.duration ?? Duration.zero;
    final newPosition = position + Duration(seconds: seconds);

    if (newPosition < duration) {
      await seek(newPosition);
    } else {
      await seek(duration);
    }
  }

  /// Tua lùi 10 giây
  Future<void> seekBackward([int seconds = 10]) async {
    final position = _audioPlayer.position;
    final newPosition = position - Duration(seconds: seconds);

    if (newPosition > Duration.zero) {
      await seek(newPosition);
    } else {
      await seek(Duration.zero);
    }
  }

  /// Phát bài hát theo index
  Future<void> playAtIndex(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    await playSong(_playlist[index], playlist: _playlist, index: index);
  }

  /// Thêm bài vào queue
  void addToQueue(Song song) {
    _playlist.add(song);
  }

  /// Thêm nhiều bài vào queue
  void addAllToQueue(List<Song> songs) {
    _playlist.addAll(songs);
  }

  /// Xóa bài khỏi queue
  void removeFromQueue(int index) {
    if (index < 0 || index >= _playlist.length) return;

    if (index == _currentIndex) {
      // Nếu đang phát bài này, phát bài tiếp theo
      next();
    } else if (index < _currentIndex) {
      // Điều chỉnh index hiện tại
      _currentIndex--;
    }

    _playlist.removeAt(index);
  }

  /// Clear queue
  void clearQueue() {
    stop();
    _playlist.clear();
    _currentIndex = 0;
  }

  /// Dispose
  void dispose() {
    _audioPlayer.dispose();
  }
}
