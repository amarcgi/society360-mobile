// lib/features/Profile/presentation/widgets/
//              vehicle_tile.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/AppColors.dart';

import '../models/vehicle_model.dart';

class VehicleTile extends StatelessWidget {

  final VehicleModel vehicle;
  final VoidCallback onDelete;

  const VehicleTile({
    super.key,
    required this.vehicle,
    required this.onDelete,
  });

  bool get _isFourWheeler =>
      vehicle.vehicleType == 'FOUR_WHEELER';

  IconData get _vehicleIcon => _isFourWheeler
      ? Icons.directions_car_rounded
      : Icons.two_wheeler_rounded;

  String get _vehicleLabel => _isFourWheeler
      ? '4 Wheeler'
      : '2 Wheeler';

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

        // ── Vehicle Icon ───────────────────────
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _vehicleIcon,
            size: 20,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(width: 12),

        // ── Vehicle Info ───────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                vehicle.make ?? _vehicleLabel,
                style: GoogleFonts.sora(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                vehicle.color != null
                    ? '${vehicle.color} · $_vehicleLabel'
                    : _vehicleLabel,
                style: GoogleFonts.sora(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),

        // ── Number Plate ───────────────────────
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            vehicle.vehicleNumber,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
              fontFamily: 'monospace',
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
          'Remove Vehicle',
          style: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Remove ${vehicle.vehicleNumber} from your vehicles?',
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