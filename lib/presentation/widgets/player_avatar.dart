import 'dart:io';
import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  final String? avatarPath;
  final bool isCustomAvatar;
  final String? name;
  final double size;
  final double borderWidth;
  final Color? borderColor;
  final Color? backgroundColor;

  const PlayerAvatar({
    super.key,
    this.avatarPath,
    this.isCustomAvatar = false,
    this.name,
    this.size = 50,
    this.borderWidth = 2,
    this.borderColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Colors.white.withValues(alpha: 0.1),
        border: Border.all(color: borderColor ?? Colors.white24, width: borderWidth),
      ),
      child: ClipOval(child: _buildImage()),
    );
  }

  Widget _buildImage() {
    if (isCustomAvatar && avatarPath != null) {
      final file = File(avatarPath!);
      if (file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover);
      }
    }

    if (avatarPath != null && avatarPath!.startsWith('assets/')) {
      return Image.asset(avatarPath!, fit: BoxFit.cover);
    }

    // Fallback to initial
    return Center(
      child: Text(
        (name?.isNotEmpty == true) ? name![0].toUpperCase() : '?',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: size * 0.4),
      ),
    );
  }
}
