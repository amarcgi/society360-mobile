// lib/shared/widgets/app_loader.dart

import 'package:flutter/material.dart';

import '../../theme/AppColors.dart';
import 'app_text_styles.dart';

// ── 1. Inline Loader ─────────────────────────
// Use inside buttons or small spaces
class AppLoader extends StatelessWidget {
  final double size;
  final Color? color;

  const AppLoader({
    super.key,
    this.size  = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) =>
      SizedBox(
        width: size, height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: color ?? AppColors.primary,
        ),
      );
}

// ── 2. Full Screen Loader ────────────────────
// Use when loading a full page
class AppFullScreenLoader extends StatelessWidget {
  final String? message;

  const AppFullScreenLoader({
    super.key, this.message,
  });

  @override
  Widget build(BuildContext context) =>
      ColoredBox(
        color: Colors.black45,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLoader(size: 40),
                if (message != null) ...[
                  const SizedBox(height: 16),
                  Text(message!,
                      style: AppTextStyles.bodyMedium),
                ],
              ],
            ),
          ),
        ),
      );
}

// ── 3. Shimmer Loader ────────────────────────
// Use for list placeholders while loading
class AppShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const AppShimmer({
    super.key,
    this.width        = double.infinity,
    this.height       = 16,
    this.borderRadius = 8,
  });

  @override
  State<AppShimmer> createState() =>
      _AppShimmerState();
}

class _AppShimmerState
    extends State<AppShimmer>
    with SingleTickerProviderStateMixin {

  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween(begin: -2.0, end: 2.0)
        .animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: const [0.0, 0.5, 1.0],
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFF5F5F5),
                Color(0xFFEEEEEE),
              ],
              transform: GradientRotation(_anim.value),
            ),
          ),
        ),
      );
}

// ── 4. List Shimmer ──────────────────────────
// Drop-in replacement while list is loading
class AppListShimmer extends StatelessWidget {
  final int itemCount;

  const AppListShimmer({
    super.key, this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) =>
      ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        separatorBuilder: (_, __) =>
        const SizedBox(height: 12),
        itemBuilder: (_, __) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(children: [
                AppShimmer(width: 40, height: 40,
                    borderRadius: 20),
                const SizedBox(width: 12),
                Expanded(child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    AppShimmer(height: 14,
                        width: double.infinity),
                    const SizedBox(height: 8),
                    AppShimmer(height: 10, width: 120),
                  ],
                )),
              ]),
              const SizedBox(height: 12),
              AppShimmer(height: 10,
                  width: double.infinity),
              const SizedBox(height: 6),
              AppShimmer(height: 10, width: 200),
            ],
          ),
        ),
      );
}
