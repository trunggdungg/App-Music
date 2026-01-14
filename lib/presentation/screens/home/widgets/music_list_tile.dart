
// ============ MUSIC LIST TILE ============
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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