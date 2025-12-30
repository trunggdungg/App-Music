import 'package:flutter/material.dart';
import '../home/widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  // ✅ Thêm callback để thông báo khi chọn bài hát
  final Function(String title, String artist)? onSongTap;

  const HomeScreen({Key? key, this.onSongTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              ///  Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Good Morning 👋",
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150",
                    ),
                  )
                ],
              ),

              const SizedBox(height: 20),

              ///  Search box
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
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,/// cho phép cuộn ngang
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        // ✅ Gọi callback khi user click bài hát
                        if (onSongTap != null) {
                          onSongTap!(
                            "Song ${index + 1}",
                            "Artist Name",
                          );
                        }
                      },
                      child: MusicCard(
                        title: "Song ${index + 1}",
                        artist: "Artist",
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              /// 🌟 Recommended
              const SectionTitle(title: "Recommended For You"),
              const SizedBox(height: 12),
              Column(
                children: List.generate(
                  5,
                      (index) => GestureDetector(
                    onTap: () {
                      /// Gọi callback khi user click bài hát
                      if (onSongTap != null) {
                        onSongTap!(
                          "Recommended Song ${index + 1}",
                          "Artist Name",
                        );
                      }
                    },
                    child: MusicListTile(
                      title: "Recommended Song ${index + 1}",
                      artist: "Artist Name",
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 100), // ✅ Tăng space cho ConvexBar + MiniPlayer
            ],
          ),
        ),
      ),

      // ❌ BỎ bottomNavigationBar (đã chuyển lên MainScreen)
    );
  }
}