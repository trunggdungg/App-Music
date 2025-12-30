// lib/presentation/screens/main/main_screen.dart

import 'package:flutter/material.dart';
import '../../../data/models/song.dart';
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

  // Trạng thái phát nhạc với Song object
  bool _isPlaying = false;
  Song? _currentSong;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Hàm phát nhạc nhận Song object
  void _playSong(Song song) {
    setState(() {
      _isPlaying = true;
      _currentSong = song;
    });
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
          if (_isPlaying && _currentSong != null)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NowPlayingScreen(
                      song: _currentSong!,
                    ),
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
                    // Album art
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        _currentSong!.albumArt,
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

                    // Song info
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _currentSong!.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _currentSong!.artist,
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

                    // Play/Pause button
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: const Color(0xFF00BF6D),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPlaying = !_isPlaying;
                        });
                      },
                    ),

                    // Next button
                    IconButton(
                      icon: const Icon(Icons.skip_next),
                      color: Colors.grey[700],
                      onPressed: () {
                        print("Next song");
                      },
                    ),
                  ],
                ),
              ),
            ),

          // ⚫ BOTTOM NAVIGATION BAR
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