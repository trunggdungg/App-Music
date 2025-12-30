// lib/presentation/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import '../../../data/repositories/music_repository.dart';
import '../../../data/models/song.dart';
import '../home/widgets/section_title.dart';

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

      setState(() {
        _recentlyPlayed = recently;
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

// ============ UPDATED WIDGETS ============

class MusicCard extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;

  const MusicCard({
    Key? key,
    required this.title,
    required this.artist,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5FCF9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.music_note, size: 40),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class MusicListTile extends StatelessWidget {
  final String title;
  final String artist;
  final String imageUrl;

  const MusicListTile({
    Key? key,
    required this.title,
    required this.artist,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
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
      title: Text(title),
      subtitle: Text(artist),
      trailing: const Icon(Icons.more_vert),
    );
  }
}
