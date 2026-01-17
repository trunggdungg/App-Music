// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:music_app/data/models/favorite.dart';
import 'package:music_app/data/repositories/api_music_repository.dart';
import 'package:music_app/presentation/screens/home/widgets/music_list_tile.dart';
import 'package:music_app/services/audio_player_service.dart';
import '../../../data/repositories/music_repository.dart';
import '../../../data/models/song.dart';
import '../player/now_playing_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final MusicRepository _repository = ApiMusicRepository();
  final AudioPlayerService _audioService = AudioPlayerService();
  List<Favorite> _favorite = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final favorite = await _repository.getFavoritesByUserId(1);
      setState(() {
        _favorite = favorite;
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Lỗi: $_error'),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.navigate_before, size: 32),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            "Dánh sách nhạc yêu thích",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ],
                      ),

                      /// Content
                      const SizedBox(height: 12),
                      _favorite.isEmpty
                          ? const Center(child: Text('Chưa có đề xuất'))
                          : Column(
                              children: _favorite.map((favorite) {
                                return GestureDetector(
                                  onTap: () {
                                    // Xử lý khi người dùng nhấn vào bài hát
                                    print('Nhấn vào bài hát: ${favorite.song.title}');
                                    _audioService.playSong(favorite.song);
                                    if(mounted){
                                      Navigator.push(
                                          context, MaterialPageRoute(
                                          builder: (_) => NowPlayingScreen()));
                                    }
                                  },
                                  child: MusicListTile(
                                    title: favorite.song.title,
                                    artist: favorite.song.artist.name,
                                    imageUrl: favorite.song.artist.imageUrl,
                                  ),
                                );
                              }).toList(),
                            ),

                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
