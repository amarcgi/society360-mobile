// lib/features/Profile/presentation/widgets/
//              family_member_tile.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/AppColors.dart';
import '../models/family_member_model.dart';


class FamilyMemberTile extends StatelessWidget {

  final FamilyMemberModel member;
  final VoidCallback onDelete;

  const FamilyMemberTile({
    super.key,
    required this.member,
    required this.onDelete,
  });

  // Generate initials from name
  String get _initials {
    final parts = member.name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // Relation badge color
  Color get _relationColor {
    return switch (member.relation) {
      'SPOUSE'  => const Color(0xFF534AB7),
      'CHILD'   => const Color(0xFF0F6E56),
      'PARENT'  => const Color(0xFF854F0B),
      'SIBLING' => const Color(0xFF185FA5),
      _         => AppColors.textSecondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(children: [

        // ── Avatar ─────────────────────────────
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _relationColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              _initials,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _relationColor,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // ── Info ───────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                member.name,
                style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '+91 ${member.mobile}',
                style: GoogleFonts.sora(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // ── Relation Badge ─────────────────────
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: _relationColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            member.relation,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _relationColor,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // ── Delete Button ──────────────────────
        GestureDetector(
          onTap: () => _confirmDelete(context),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.delete_outline_rounded,
              size: 16,
              color: AppColors.error,
            ),
          ),
        ),
      ]),
    );
  }

  // ── Confirm before delete ──────────────────────
  Future<void> _confirmDelete(
      BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Remove Member',
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Remove ${member.name} from your family list?',
          style: GoogleFonts.sora(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text(
              'Remove',
              style: TextStyle(
                  color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) onDelete();
  }
}