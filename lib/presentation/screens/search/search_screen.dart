// lib/presentation/screens/search/search_screen.dart

import 'package:flutter/material.dart';
import 'package:music_app/data/models/search_result.dart';
import 'package:music_app/data/repositories/api_music_repository.dart';
import 'package:music_app/data/repositories/music_repository.dart';
import 'package:music_app/services/audio_player_service.dart';
import '../artist/artist_detail_screen.dart';
import '../player/now_playing_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MusicRepository _repository = ApiMusicRepository();
  final AudioPlayerService _audioService = AudioPlayerService();
  final TextEditingController _searchController = TextEditingController();

  SearchResult? _searchResult;
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResult = null;
        _searchQuery = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchQuery = query;
    });

    try {
      final result = await _repository.search(query.trim());
      setState(() {
        _searchResult = result;
        _isSearching = false;
      });
    } catch (e) {
      print('Error searching: $e');
      setState(() {
        _isSearching = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi tìm kiếm: $e')));
      }
    }
  }

  void _playSong(int index) async {
    if (_searchResult == null || _searchResult!.songs.isEmpty) return;

    final song = _searchResult!.songs[index];
    try {
      await _audioService.playSong(
        song,
        playlist: _searchResult!.songs,
        index: index,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NowPlayingScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể phát bài hát: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Search',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          /// 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Artists or songs",
                filled: true,
                fillColor: const Color(0xFFF5FCF9),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                // Debounce search - chờ 500ms sau khi user ngừng gõ
                Future.delayed(const Duration(milliseconds: 500), () {
                  if (_searchController.text == value) {
                    _performSearch(value);
                  }
                });
              },
              onSubmitted: _performSearch,

            ),
          ),

          /// 📋 SEARCH RESULTS
          Expanded(
            child: _isSearching
                ? const Center(child: CircularProgressIndicator())
                : _searchResult == null
                ? _buildRecentSearches()
                : _searchResult!.isEmpty
                ? _buildNoResults()
                : _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  /// Hiển thị khi chưa search
  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Searches",
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.history),
                  title: Text("Recent search ${index + 1}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Hiển thị khi không có kết quả
  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy kết quả cho "$_searchQuery"',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  /// Hiển thị kết quả tìm kiếm
  Widget _buildSearchResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 📊 THỐNG KÊ KẾT QUẢ
          Text(
            'Tìm thấy ${_searchResult!.totalResults} kết quả',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 24),

          /// 👨‍🎤 ARTISTS
          if (_searchResult!.artists.isNotEmpty) ...[
            Text(
              'Artists (${_searchResult!.totalArtists})',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _searchResult!.artists.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final artist = _searchResult!.artists[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ArtistDetailScreen(artist: artist),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF1DB954),
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              artist.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.person, size: 40),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 100,
                          child: Text(
                            artist.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],

          /// 🎵 SONGS
          if (_searchResult!.songs.isNotEmpty) ...[
            Text(
              'Songs (${_searchResult!.totalSongs})',
              style: Theme.of(
                context,
              ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _searchResult!.songs.length,
              itemBuilder: (context, index) {
                final song = _searchResult!.songs[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      song.albumArt,
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey[300],
                        child: const Icon(Icons.music_note),
                      ),
                    ),
                  ),
                  title: Text(song.title),
                  subtitle: Text(song.artist.name),
                  trailing: const Icon(Icons.more_vert),
                  onTap: () => _playSong(index),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
