// lib/presentation/screens/favorite/widget/FavoriteButton.dart

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
    _checkFavoriteStatus(); // ✅ Kiểm tra trạng thái khi khởi tạo
  }

  /// ✅ KIỂM TRA TRẠNG THÁI YÊU THÍCH KHI KHỞI TẠO
  Future<void> _checkFavoriteStatus() async {
    if (_authService.currentUserId == null) return;

    try {
      final isFavorite = await _repository.isFavorite(widget.songId);
      if (mounted) {
        setState(() {
          _isFavorite = isFavorite;
        });
      }
    } catch (e) {
      print('❌ Error checking favorite status: $e');
    }
  }

  /// ✅ TOGGLE FAVORITE - IMPROVED
  Future<void> _toggleFavorite() async {
    // Kiểm tra đăng nhập
    if (_authService.currentUserId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn cần đăng nhập để sử dụng chức năng này'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    // Lưu trạng thái cũ để rollback nếu có lỗi
    final oldState = _isFavorite;

    // Optimistic update - cập nhật UI ngay
    setState(() {
      _isFavorite = !_isFavorite;
      _isLoading = true;
    });

    try {
      bool success;

      if (oldState) {
        // Xóa khỏi yêu thích
        print('🗑️ Removing from favorites...');
        success = await _repository.removeFromFavorites(widget.songId);
      } else {
        // Thêm vào yêu thích
        print('❤️ Adding to favorites...');
        success = await _repository.addToFavorites(widget.songId);
      }

      if (!success && mounted) {
        // Rollback nếu thất bại
        setState(() {
          _isFavorite = oldState;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              oldState
                  ? 'Không thể xóa khỏi yêu thích'
                  : 'Không thể thêm vào yêu thích',
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      } else if (mounted) {
        // Callback khi thành công
        widget.onChanged?.call(_isFavorite);

        // Hiển thị thông báo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite
                  ? '❤️ Đã thêm vào yêu thích'
                  : '💔 Đã xóa khỏi yêu thích',
            ),
            backgroundColor: _isFavorite ? Colors.green : Colors.grey[700],
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print('❌ Toggle favorite error: $e');

      if (mounted) {
        // Rollback về trạng thái cũ
        setState(() {
          _isFavorite = oldState;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
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
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00BF6D)),
        ),
      );
    }

    return IconButton(
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
        color: _isFavorite ? Colors.red : Colors.grey[600],
      ),
      onPressed: _toggleFavorite,
      tooltip: _isFavorite ? 'Xóa khỏi yêu thích' : 'Thêm vào yêu thích',
    );
  }
}