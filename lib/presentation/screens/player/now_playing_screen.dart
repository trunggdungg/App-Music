import 'package:flutter/material.dart';

class NowPlayingScreen extends StatefulWidget {
  final String songTitle;
  final String artistName;

  const NowPlayingScreen({
    Key? key,
    required this.songTitle,
    required this.artistName,
  }) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}
///why signal is right, but then you turn left
class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool _isPlaying = true;
  bool _isFavorite = false;
  bool _isRepeat = false;
  bool _isShuffle = false;

  double _currentPosition = 45.0; // giây
  double _totalDuration = 180.0; // 3 phút

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            //  Header với nút Back và More
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down, size: 32),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    "Now Playing",
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
            ),

            const Spacer(),

            // 🖼️ Album Art
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(/// cái này dùng để giữ tỉ lệ khung hình
                  aspectRatio: 1,
                  child: Image.network(
                    "https://picsum.photos/400",
                    fit: BoxFit.cover,/// ảnh sẽ phủ đầy khung hình nhưng vẫn giữ tỉ lệ
                  ),
                ),
              ),
            ),

            const Spacer(),

            // 🎵 Song Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.songTitle,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.artistName,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.red : Colors.grey[600],
                          size: 28,
                        ),
                        onPressed: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 🎚️ Progress Bar
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 14,
                          ),
                        ),
                        child: Slider(
                          value: _currentPosition,
                          max: _totalDuration,
                          activeColor: const Color(0xFF00BF6D),
                          inactiveColor: Colors.grey[300],
                          onChanged: (value) {
                            setState(() {
                              _currentPosition = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(_currentPosition.toInt()),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              _formatDuration(_totalDuration.toInt()),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 🎛️ Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Shuffle
                      IconButton(
                        icon: Icon(
                          Icons.shuffle,
                          color: _isShuffle
                              ? const Color(0xFF00BF6D)
                              : Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            _isShuffle = !_isShuffle;
                          });
                        },
                      ),

                      // Previous
                      IconButton(
                        icon: const Icon(Icons.skip_previous, size: 36),
                        color: Colors.grey[800],
                        onPressed: () {
                          print("Previous song");
                        },
                      ),

                      // Play/Pause
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BF6D),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            _isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 40,
                          ),
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              _isPlaying = !_isPlaying;
                            });
                          },
                        ),
                      ),

                      // Next
                      IconButton(
                        icon: const Icon(Icons.skip_next, size: 36),
                        color: Colors.grey[800],
                        onPressed: () {
                          print("Next song");
                        },
                      ),

                      // Repeat
                      IconButton(
                        icon: Icon(
                          Icons.repeat,
                          color: _isRepeat
                              ? const Color(0xFF00BF6D)
                              : Colors.grey[600],
                        ),
                        onPressed: () {
                          setState(() {
                            _isRepeat = !_isRepeat;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // 🕐 Format thời gian từ giây sang mm:ss
  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}