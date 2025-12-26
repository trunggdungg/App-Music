import 'package:flutter/material.dart';
import '../home/widgets/section_title.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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

              /// 🔰 Header
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

              /// 🔍 Search box
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
              SectionTitle(title: "Recently Played"),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return MusicCard(
                      title: "Song ${index + 1}",
                      artist: "Artist",
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              /// 🌟 Recommended
              SectionTitle(title: "Recommended For You"),
              const SizedBox(height: 12),
              Column(
                children: List.generate(
                  5,
                      (index) => MusicListTile(
                    title: "Recommended Song ${index + 1}",
                    artist: "Artist Name",
                  ),
                ),
              ),

              const SizedBox(height: 80), // space for mini player
            ],
          ),
        ),
      ),

      /// 🎵 Mini Player (UI only)
      bottomNavigationBar: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          color: Color(0xFFF5FCF9),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                "https://picsum.photos/200",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Now Playing",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Artist name",
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              color: const Color(0xFF00BF6D),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
