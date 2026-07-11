// ═══════════════════════════════════════════
// widgets/profile_header.dart
// ═══════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/AppColors.dart';
class ProfileHeader extends StatefulWidget {
  final String title;
  final String subtitle;
  final int step;
  final int totalSteps;
  final bool showBack;
  final VoidCallback? onBack;

  const ProfileHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.step,
    required this.totalSteps,
    this.showBack = true,
    this.onBack,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16,
        right: 16,
        bottom: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            if (widget.showBack)
              GestureDetector(
                onTap: widget.onBack,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            if (widget.showBack) const SizedBox(width: 10),
            Expanded(
              child: Text(widget.title,
                  style: GoogleFonts.sora(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  )),
            ),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('${widget.step} of ${widget.totalSteps}',
                  style: GoogleFonts.sora(
                    fontSize: 11,
                    color: Colors.white70,
                  )),
            ),
          ]),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(left: widget.showBack ? 42 : 0),
            child: Text(widget.subtitle,
                style: GoogleFonts.sora(
                  fontSize: 15,
                  color: Colors.white60,
                )),
          ),
          const SizedBox(height: 12),
          // Progress bar
          Row(
            children: List.generate(
              widget.totalSteps,
                  (i) => Expanded(
                child: Container(
                  margin: EdgeInsets.only(right: i < widget.totalSteps - 1 ? 4 : 0),
                  height: 3,
                  decoration: BoxDecoration(
                    color: i < widget.step
                        ? Colors.white.withOpacity(0.5)
                        : i == widget.step - 1
                        ? AppColors.accent
                        : Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

