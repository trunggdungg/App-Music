import 'package:flutter/material.dart';
import 'package:music_app/data/models/artist.dart';
import 'package:music_app/data/models/song.dart';
import 'package:music_app/data/repositories/api_music_repository.dart';
import 'package:music_app/data/repositories/music_repository.dart';

import '../../../services/audio_player_service.dart';
import '../player/now_playing_screen.dart';

class ArtistDetailScreen extends StatefulWidget {
  final Artist artist;

  const ArtistDetailScreen({Key? key, required this.artist}) : super(key: key);

  @override
  State<ArtistDetailScreen> createState() => _ArtistDetailScreenState();
}

class _ArtistDetailScreenState extends State<ArtistDetailScreen> {
  final MusicRepository _repository = ApiMusicRepository();
  final AudioPlayerService _audioService = AudioPlayerService();
  List<Song> _artistSongs = [];
  bool _isLoading = true;
  bool _isFollowing = false;

  @override
  void initState() {
    super.initState();
    _loadArtistSongs();
  }

  Future<void> _loadArtistSongs() async {
    setState(() => _isLoading = true);

    try {
      final songs = await _repository.getSongsByArtist(
        widget.artist.artistId.toString(),
      );

      setState(() {
        _artistSongs = songs;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading artist songs: $e');
      setState(() => _isLoading = false);
    }
  }

  /// HÀM PHÁT NHẠC
  void _playSong(Song song, int index) async {
    try {
      // 🔥 Luôn chuyển sang NowPlaying trước
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const NowPlayingScreen(),
          ),
        );
      }

      // 🔥 Sau đó mới play (UI đã sẵn sàng lắng nghe stream)
      await _audioService.playSong(
        song,
        playlist: _artistSongs,
        index: index,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể phát bài hát: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          /// ========== HEADER WITH IMAGE ==========
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  /// Background image with gradient
                  Image.network(
                    widget.artist.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 100),
                      );
                    },
                  ),
                  /// Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  /// Artist name at bottom
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.artist.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${widget.artist.formattedFollowers} followers',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ========== ACTION BUTTONS ==========
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Follow button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() => _isFollowing = !_isFollowing);
                      },
                      icon: Icon(_isFollowing ? Icons.check : Icons.person_add),
                      label: Text(_isFollowing ? 'Following' : 'Follow'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isFollowing
                            ? Colors.grey[300]
                            : const Color(0xFF00BF6D),
                        foregroundColor: _isFollowing
                            ? Colors.black
                            : Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // More options button
                  IconButton(
                    onPressed: () {
                      _showMoreOptions(context);
                    },
                    icon: const Icon(Icons.more_vert),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ========== BIO (if available) ==========
          if (widget.artist.bio != null)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.artist.bio!,
                      style: TextStyle(color: Colors.grey[600], height: 1.5),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

          /// ========== POPULAR SONGS ==========
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Songs',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (_artistSongs.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        // TODO: Play all songs
                      },
                      child: const Text('Play all'),
                    ),
                ],
              ),
            ),
          ),

          /// ========== SONGS LIST ==========
          _isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : _artistSongs.isEmpty
              ? const SliverFillRemaining(
                  child: Center(child: Text('Chưa có bài hát nào')),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final song = _artistSongs[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          song.albumArt,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 56,
                              height: 56,
                              color: Colors.grey[300],
                              child: const Icon(Icons.music_note),
                            );
                          },
                        ),
                      ),
                      title: Text(
                        song.title,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        song.album?.title ?? 'Single',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            song.durationFormatted,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              _showSongOptions(context, song);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        // TODO: Play this song
                        /// sau đó quay về màn hình chính và phát nhạc
                        _playSong(song, index);

                      },
                    );
                  }, childCount: _artistSongs.length),
                ),

          // Bottom padding
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share artist'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement share
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Artist info'),
                onTap: () {
                  Navigator.pop(context);
                  _showArtistInfo(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSongOptions(BuildContext context, Song song) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.playlist_add),
                title: const Text('Add to playlist'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement
                },
              ),
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('Like'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Share'),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Implement
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showArtistInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(widget.artist.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoRow('Followers', widget.artist.formattedFollowers),
              if (widget.artist.genres.isNotEmpty)
                _infoRow('Genres', widget.artist.genres.join(', ')),
              _infoRow('Songs', _artistSongs.length.toString()),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
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
