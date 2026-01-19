// lib/presentation/widgets/favorite_button.dart

import 'package:flutter/material.dart';
import 'package:music_app/data/repositories/api_music_repository.dart';
import 'package:music_app/services/auth_service.dart';

class FavoriteButton extends StatefulWidget {
  final int songId;
  final bool initialIsFavorite;
  final Function(bool)? onChanged;

  const FavoriteButton({
    Key? key,
    required this.songId,
    this.initialIsFavorite = false,
    this.onChanged,
  }) : super(key: key);

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorite;
  bool _isLoading = false;
  final _repository = ApiMusicRepository();
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.initialIsFavorite;
  }

  Future<void> _toggleFavorite() async {
    // Kiểm tra đăng nhập
    if (_authService.currentUserId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn cần đăng nhập để sử dụng chức năng này'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool success;

      if (_isFavorite) {
        // Xóa khỏi yêu thích
        success = await _repository.removeFromFavorites(widget.songId);
      } else {
        // Thêm vào yêu thích
        success = await _repository.addToFavorites(widget.songId);
      }

      if (success && mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });

        // Callback
        widget.onChanged?.call(_isFavorite);

        // Hiển thị thông báo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite
                  ? 'Đã thêm vào yêu thích'
                  : 'Đã xóa khỏi yêu thích',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : Colors.grey[600],
      ),
      onPressed: _toggleFavorite,
    );
  }
}