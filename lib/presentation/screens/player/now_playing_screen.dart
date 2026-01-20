// lib/presentation/screens/player/now_playing_screen.dart

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../data/models/song.dart';
import '../../../services/audio_player_service.dart';
import '../favorite/widget/FavoriteButton.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({Key? key}) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final AudioPlayerService _audioService = AudioPlayerService();
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final currentSong = _audioService.currentSong;

    if (currentSong == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Now Playing')),
        body: const Center(child: Text('Không có bài hát nào đang phát')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down, size: 32),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Column(
                    children: [
                      const Text(
                        "Now Playing",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${_audioService.currentIndex + 1} / ${_audioService.playlist.length}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showMoreOptions(context, currentSong),
                  ),
                ],
              ),
            ),

            const Spacer(),

            /// Album Art
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Hero(
                tag: 'album_art_${currentSong.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      currentSong.albumArt,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.music_note,
                            size: 80,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            /// Song Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentSong.artist.name,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (currentSong.album != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                currentSong.album!.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      FavoriteButton(
                        songId: currentSong.id,
                        initialIsFavorite: _isFavorite,
                        onChanged: (isFavorite) {
                          setState(() => _isFavorite = isFavorite);
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  /// Progress Bar
                  StreamBuilder<Duration>(
                    stream: _audioService.positionStream,
                    builder: (context, positionSnapshot) {
                      final position = positionSnapshot.data ?? Duration.zero;

                      return StreamBuilder<Duration?>(
                        stream: _audioService.durationStream,
                        builder: (context, durationSnapshot) {
                          final duration = durationSnapshot.data ?? Duration.zero;

                          return Column(
                            children: [
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 3,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 6,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 14,
                                  ),
                                ),
                                child: Slider(
                                  value: position.inSeconds.toDouble(),
                                  max: duration.inSeconds > 0
                                      ? duration.inSeconds.toDouble()
                                      : 1.0,
                                  activeColor: const Color(0xFF00BF6D),
                                  inactiveColor: Colors.grey[300],
                                  onChanged: (value) {
                                    _audioService.seek(
                                      Duration(seconds: value.toInt()),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatDuration(position),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      _formatDuration(duration),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  /// Control Buttons
                  StreamBuilder<LoopMode>(
                    stream: _audioService.audioPlayer.loopModeStream,
                    builder: (context, loopSnapshot) {
                      final loopMode = loopSnapshot.data ?? LoopMode.off;

                      return StreamBuilder<bool>(
                        stream: _audioService.audioPlayer.shuffleModeEnabledStream,
                        builder: (context, shuffleSnapshot) {
                          final isShuffleEnabled = shuffleSnapshot.data ?? false;

                          return StreamBuilder<bool>(
                            stream: _audioService.playingStream,
                            builder: (context, playingSnapshot) {
                              final isPlaying = playingSnapshot.data ?? false;

                              return Column(
                                children: [
                                  // Main controls
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // Shuffle
                                      IconButton(
                                        icon: Icon(
                                          Icons.shuffle,
                                          color: isShuffleEnabled
                                              ? const Color(0xFF00BF6D)
                                              : Colors.grey[600],
                                        ),
                                        onPressed: _audioService.toggleShuffle,
                                        tooltip: isShuffleEnabled
                                            ? 'Tắt phát ngẫu nhiên'
                                            : 'Bật phát ngẫu nhiên',
                                      ),

                                      // Previous
                                      IconButton(
                                        icon: Icon(
                                          Icons.skip_previous,
                                          size: 36,
                                          color: _audioService.hasPrevious ||
                                              loopMode == LoopMode.all
                                              ? Colors.grey[800]
                                              : Colors.grey[400],
                                        ),
                                        onPressed: (_audioService.hasPrevious ||
                                            loopMode == LoopMode.all)
                                            ? _audioService.previous
                                            : null,
                                        tooltip: 'Bài trước',
                                      ),

                                      // Play/Pause
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF00BF6D),
                                          shape: BoxShape.circle,
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            isPlaying ? Icons.pause : Icons.play_arrow,
                                            size: 40,
                                          ),
                                          color: Colors.white,
                                          onPressed: _audioService.togglePlayPause,
                                          tooltip: isPlaying ? 'Tạm dừng' : 'Phát',
                                        ),
                                      ),

                                      // Next
                                      IconButton(
                                        icon: Icon(
                                          Icons.skip_next,
                                          size: 36,
                                          color: _audioService.hasNext ||
                                              loopMode == LoopMode.all
                                              ? Colors.grey[800]
                                              : Colors.grey[400],
                                        ),
                                        onPressed: (_audioService.hasNext ||
                                            loopMode == LoopMode.all)
                                            ? _audioService.next
                                            : null,
                                        tooltip: 'Bài tiếp',
                                      ),

                                      // Repeat
                                      IconButton(
                                        icon: Icon(
                                          loopMode == LoopMode.one
                                              ? Icons.repeat_one
                                              : Icons.repeat,
                                          color: loopMode != LoopMode.off
                                              ? const Color(0xFF00BF6D)
                                              : Colors.grey[600],
                                        ),
                                        onPressed: _audioService.cycleLoopMode,
                                        tooltip: loopMode == LoopMode.off
                                            ? 'Lặp tất cả'
                                            : loopMode == LoopMode.all
                                            ? 'Lặp một bài'
                                            : 'Tắt lặp',
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 16),

                                  // Seek controls (tua tới/lùi)
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.replay_10),
                                        onPressed: () => _audioService.seekBackward(10),
                                        tooltip: 'Tua lùi 10s',
                                      ),
                                      const SizedBox(width: 40),
                                      IconButton(
                                        icon: const Icon(Icons.forward_10),
                                        onPressed: () => _audioService.seekForward(10),
                                        tooltip: 'Tua tới 10s',
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  void _showMoreOptions(BuildContext context, Song song) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.queue_music),
                title: const Text('Xem danh sách phát'),
                onTap: () {
                  Navigator.pop(context);
                  _showQueue(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text('Thêm vào playlist'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Chia sẻ'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Thông tin bài hát'),
                onTap: () {
                  Navigator.pop(context);
                  _showSongInfo(context, song);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showQueue(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Danh sách phát (${_audioService.playlist.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _audioService.playlist.length,
                      itemBuilder: (context, index) {
                        final song = _audioService.playlist[index];
                        final isPlaying = index == _audioService.currentIndex;

                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              song.albumArt,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            song.title,
                            style: TextStyle(
                              fontWeight: isPlaying
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isPlaying
                                  ? const Color(0xFF00BF6D)
                                  : null,
                            ),
                          ),
                          subtitle: Text(song.artist.name),
                          trailing: isPlaying
                              ? const Icon(
                            Icons.equalizer,
                            color: Color(0xFF00BF6D),
                          )
                              : null,
                          onTap: () {
                            _audioService.playAtIndex(index);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSongInfo(BuildContext context, Song song) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thông tin bài hát'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('Tên bài', song.title),
              _infoRow('Nghệ sĩ', song.artist.name),
              if (song.album != null) _infoRow('Album', song.album!.title),
              _infoRow('Thời lượng', song.durationFormatted),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}