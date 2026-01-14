// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:music_app/presentation/screens/home/widgets/artist_card.dart';
import 'package:music_app/presentation/screens/home/widgets/music_card.dart';
import 'package:music_app/presentation/screens/home/widgets/music_list_tile.dart';
import 'package:music_app/presentation/screens/home/widgets/section_title.dart';
import '../../../data/models/artist.dart';
import '../../../data/repositories/music_repository.dart';
import '../../../data/models/song.dart';

class HomeScreen extends StatefulWidget {
  final Function(Song song)? onSongTap;

  const HomeScreen({Key? key, this.onSongTap}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MusicRepository _repository = LocalMusicRepository();
  List<Song> _recentlyPlayed = [];
  List<Song> _recommended = [];
  List<Artist> _popularArtists = []; // ✅ THÊM
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

      final recently = await _repository.getRecentlyPlayed();
      final recommended = await _repository.getRecommendedSongs();
      final artists = await _repository
          .getAllArtists(); // ✅ LẤY DANH SÁCH NGHỆ SĨ

      setState(() {
        _recentlyPlayed = recently;
        _recommended = recommended;
        _popularArtists = artists;
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

                      /// Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Good Morning 👋",
                            style: Theme.of(context).textTheme.headlineSmall!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                              "https://i.pravatar.cc/150",
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Search box
                      TextField(
                        decoration: InputDecoration(
                          hintText: "Search songs, artists...",
                          filled: true,
                          fillColor: const Color(0xFFF5FCF9),
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      /// 🎧 Recently Played
                      const SectionTitle(title: "Recently Played"),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 160,
                        child: _recentlyPlayed.isEmpty
                            ? const Center(child: Text('Chưa có bài hát'))
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _recentlyPlayed.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final song = _recentlyPlayed[index];
                                  return GestureDetector(
                                    onTap: () {
                                      if (widget.onSongTap != null) {
                                        widget.onSongTap!(song);
                                      }
                                    },
                                    child: MusicCard(
                                      title: song.title,
                                      artist: song.artist,
                                      imageUrl: song.albumArt,
                                    ),
                                  );
                                },
                              ),
                      ),

                      const SizedBox(height: 32),

                      /// ⭐ POPULAR ARTISTS - MỚI THÊM
                      const SectionTitle(title: "Popular Artists"),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 140,
                        child: _popularArtists.isEmpty
                            ? const Center(child: Text('Chưa có nghệ sĩ'))
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: _popularArtists.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 16),
                                itemBuilder: (context, index) {
                                  final artist = _popularArtists[index];
                                  return ArtistCard(artist: artist);
                                },
                              ),
                      ),

                      const SizedBox(height: 32),

                      /// 🌟 Recommended
                      const SectionTitle(title: "Recommended For You"),
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
                                    artist: song.artist,
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
