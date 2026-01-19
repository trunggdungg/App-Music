// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:music_app/data/models/favorite.dart';
import 'package:music_app/data/repositories/api_music_repository.dart';
import 'package:music_app/presentation/screens/home/widgets/music_list_tile.dart';
import 'package:music_app/services/audio_player_service.dart';
import '../../../data/repositories/music_repository.dart';
import '../../../data/models/song.dart';
import '../../../services/auth_service.dart';
import '../player/now_playing_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final MusicRepository _repository = ApiMusicRepository();
  final AudioPlayerService _audioService = AudioPlayerService();
  final AuthService _authService = AuthService();
  List<Favorite> _favorite = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // ✅ KIỂM TRA USER ĐÃ ĐĂNG NHẬP CHƯA
    final currentUserId = _authService.currentUserId;

    if (currentUserId == null) {
      setState(() {
        _error = 'Bạn cần đăng nhập để xem danh sách yêu thích';
        _isLoading = false;
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // ✅ LẤY FAVORITE CỦA USER HIỆN TẠI
      final favorites = await _repository.getFavoritesByUserId(currentUserId);

      setState(() {
        _favorite = favorites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('BUILD favorite length: ${_favorite.length}');
    final currentUser = _authService.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.navigate_before, size: 32),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text(
                          "Danh sách yêu thích",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (currentUser != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            currentUser.fullName ?? currentUser.username,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00BF6D),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    )
                  : _favorite.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Chưa có bài hát yêu thích',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _favorite.length,
                        itemBuilder: (context, index) {
                          final favorite = _favorite[index];
                          return GestureDetector(
                            onTap: () {
                              _audioService.playSong(
                                favorite.song,
                                playlist: _favorite.map((f) => f.song).toList(),
                                index: index,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const NowPlayingScreen(),
                                ),
                              );
                            },
                            child: MusicListTile(
                              title: favorite.song.title,
                              artist: favorite.song.artist.name,
                              imageUrl: favorite.song.albumArt,
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
