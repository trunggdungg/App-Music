// lib/presentation/screens/main/main_screen.dart

import 'package:flutter/material.dart';
import '../../../data/models/song.dart';
import '../../../services/audio_player_service.dart';
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../library/library_screen.dart';
import '../player/now_playing_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final AudioPlayerService _audioService = AudioPlayerService();

  // @override
  // void dispose() {
  //   // Không dispose audioService ở đây vì nó là singleton
  //   super.dispose();
  // }
/// Hàm xử lý khi nhấn vào tab ở Bottom Navigation Bar
  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  /// Hàm phát nhạc nhận Song object
  void _playSong(Song song) async {
    try {
      await _audioService.playSong(song);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Không thể phát bài hát: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(onSongTap: _playSong),
          const SearchScreen(),
          const LibraryScreen(),
        ],
      ),

      // Mini Player + Bottom Navigation
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🎵 MINI PLAYER
          StreamBuilder<Song?>(
            stream: Stream.periodic(const Duration(milliseconds: 100))
                .map((_) => _audioService.currentSong),
            builder: (context, snapshot) {
              final currentSong = snapshot.data;

              if (currentSong == null) {
                return const SizedBox.shrink();
              }

              return StreamBuilder<bool>(
                stream: _audioService.playingStream,
                builder: (context, playingSnapshot) {
                  final isPlaying = playingSnapshot.data ?? false;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NowPlayingScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5FCF9),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          /// image album art
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              currentSong.albumArt,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 48,
                                  height: 48,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.music_note),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),

                          /// thông tin bài hát
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentSong.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  currentSong.artist.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          /// Play/Pause button
                          IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: const Color(0xFF00BF6D),
                            ),
                            onPressed: () async {
                              if (isPlaying) {
                                await _audioService.pause();
                              } else {
                                await _audioService.resume();
                              }
                            },
                          ),

                          /// Next button
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            color: Colors.grey[700],
                            onPressed: () async {
                              await _audioService.next();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),


          /// ⚫ BOTTOM NAVIGATION BAR
          BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onTabTapped,
            selectedItemColor: Colors.green,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0 ? Colors.green : Colors.grey,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: _selectedIndex == 1 ? Colors.green : Colors.grey,
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.library_music,
                  color: _selectedIndex == 2 ? Colors.green : Colors.grey,
                ),
                label: 'Library',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
