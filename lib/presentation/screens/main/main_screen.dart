import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:music_app/presentation/screens/player/now_playing_screen.dart';
import '../home/home_screen.dart';
import '../search/search_screen.dart';
import '../library/library_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Biến giả lập trạng thái phát nhạc
  bool _isPlaying = false;
  String _currentSong = "No song playing";
  String _currentArtist = "";


  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // 🎵 Hàm giả lập khi user chọn bài hát (gọi từ HomeScreen)
  void _playSong(String title, String artist) {
    setState(() {
      _isPlaying = true;
      _currentSong = title;
      _currentArtist = artist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(onSongTap: _playSong, // Truyền callback vào HomeScreen
          ),
          const SearchScreen(),
          const LibraryScreen(),
        ],
      ),

      // 🎵 MINI PLAYER - Chỉ hiện khi đang phát nhạc
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mini Player
          if (_isPlaying)
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) =>
                            NowPlayingScreen(songTitle: _currentSong,artistName: _currentArtist,)
                    ));
                print("Mở Now Playing Screen");
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
                        "https://picsum.photos/200",
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
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
                            _currentSong,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            _currentArtist,
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

          // ⚫ CONVEX BOTTOM BAR
          BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
           /// màu icon khi được chọn
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
          )
        ],
      ),
    );
  }
}