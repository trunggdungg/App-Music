import 'package:flutter/material.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Your Library',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Quick access buttons
          Row(
            children: [
              Expanded(
                child: _quickAccessButton(
                  context,
                  icon: Icons.favorite,
                  label: "Liked Songs",
                  color: const Color(0xFF00BF6D),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _quickAccessButton(
                  context,
                  icon: Icons.playlist_play,
                  label: "Playlists",
                  color: Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Library sections
          _buildSection(
            context,
            title: "Playlists",
            items: [
              _LibraryItem(title: "Chill Vibes", count: "24 songs"),
              _LibraryItem(title: "Workout Mix", count: "18 songs"),
              _LibraryItem(title: "Study Session", count: "31 songs"),
            ],
          ),

          const SizedBox(height: 24),

          _buildSection(
            context,
            title: "Artists",
            items: [
              _LibraryItem(title: "Artist Name 1", count: "12 songs"),
              _LibraryItem(title: "Artist Name 2", count: "8 songs"),
            ],
          ),

          const SizedBox(height: 24),

          _buildSection(
            context,
            title: "Albums",
            items: [
              _LibraryItem(title: "Album Title 1", count: "10 tracks"),
              _LibraryItem(title: "Album Title 2", count: "14 tracks"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAccessButton(
      BuildContext context, {
        required IconData icon,
        required String label,
        required Color color,
      }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required List<_LibraryItem> items,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...items.map((item) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFF5FCF9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.music_note),
          ),
          title: Text(item.title),
          subtitle: Text(item.count),
          trailing: const Icon(Icons.more_vert),
          onTap: () {},
        )),
      ],
    );
  }
}

class _LibraryItem {
  final String title;
  final String count;

  _LibraryItem({required this.title, required this.count});
}