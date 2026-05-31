// lib/shared/widgets/app_image.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../theme/AppColors.dart';
import 'app_loader.dart';

class AppImage extends StatelessWidget {

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final IconData placeholderIcon;

  const AppImage({
    super.key,
    this.url,
    this.width,
    this.height,
    this.fit              = BoxFit.cover,
    this.borderRadius     = 12,
    this.placeholderIcon  = Icons.image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return _placeholder();
    }

    return ClipRRect(
      borderRadius:
      BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => _shimmer(),
        errorWidget: (_, __, ___) =>
            _placeholder(),
      ),
    );
  }

  Widget _shimmer() => AppShimmer(
    width: width ?? double.infinity,
    height: height ?? 120,
    borderRadius: borderRadius,
  );

  Widget _placeholder() => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.surfaceAlt,
      borderRadius:
      BorderRadius.circular(borderRadius),
    ),
    child: Icon(
      placeholderIcon,
      color: AppColors.textHint,
      size: 32,
    ),
  );
}

// ── Avatar ───────────────────────────────────
class AppAvatar extends StatelessWidget {

  final String? url;
  final String? name;  // initials fallback
  final double size;

  const AppAvatar({
    super.key,
    this.url,
    this.name,
    this.size = 44,
  });

  String get _initials {
    if (name == null || name!.isEmpty) return '?';
    final parts = name!.trim().split(' ');
    if (parts.length == 1)
      return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (url != null && url!.isNotEmpty) {
      return AppImage(
        url: url,
        width: size, height: size,
        borderRadius: size / 2,
        placeholderIcon: Icons.person_outline,
      );
    }

    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          _initials,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.38,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

// ── Usage ────────────────────────────────────
// AppImage(url: resident.photoUrl,
//   width: double.infinity, height: 200)
// AppAvatar(name: 'Amar Singh', size: 48)
// AppAvatar(url: user.avatar, size: 40)
