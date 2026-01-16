// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:music_app/data/repositories/api_music_repository.dart';
import 'package:music_app/presentation/screens/home/widgets/artist_card.dart';
import 'package:music_app/presentation/screens/home/widgets/music_card.dart';
import 'package:music_app/presentation/screens/home/widgets/music_list_tile.dart';
import 'package:music_app/presentation/screens/home/widgets/section_title.dart';
import '../../../data/models/artist.dart';
import '../../../data/repositories/music_repository.dart';
import '../../../data/models/song.dart';

class FavoriteScreen extends StatefulWidget {
  final Function(Song song)? onSongTap;

  const FavoriteScreen({Key? key, this.onSongTap}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final MusicRepository _repository = ApiMusicRepository();
  List<Song> _recommended = [];
  List<Song> _favorite = [];
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

      final recommended = await _repository.getAllSongs();
      final favorite = await _repository.getAllFavoriteSongs();
      setState(() {
        _recommended = recommended;
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
    print('BUILD favorite length: ${_recommended.length}');
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
                            icon: const Icon(
                              Icons.navigate_before,
                              size: 32,
                            ),
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

                      ///
                      const SizedBox(height: 12),
                      _recommended.isEmpty
                          ? const Center(child: Text('Chưa có đề xuất'))
                          : Column(
                              children: _recommended.map((song) {
                                return GestureDetector(
                                  onTap: () {
                                    if (widget.onSongTap != null) {
                                      widget.onSongTap!(song);
                                    }
                                  },
                                  child: MusicListTile(
                                    title: song.title,
                                    artist: song.artist.name,
                                    imageUrl: song.albumArt,
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
