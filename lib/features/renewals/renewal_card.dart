import 'package:flutter/material.dart';

import '../../models/renewal_due.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_card.dart';

class RenewalCard extends StatelessWidget {
  final RenewalDue renewal;
  final VoidCallback? onRenew;
  final VoidCallback? onTap;

  const RenewalCard({
    super.key,
    required this.renewal,
    this.onRenew,
    this.onTap,
  });

  /// Color-coded urgency:
  /// Green (>30 days) / Orange (7-30 days) / Red (<=7 days) / Grey (Expired)
  Color get urgencyColor {
    switch (renewal.status) {
      case 'EXPIRED':
        return Colors.grey.shade600;
      case 'DUE_TODAY':
      case 'EXPIRING_SOON':
        return AppColors.danger;
      case 'UPCOMING':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  IconData get statusIcon {
    switch (renewal.status) {
      case 'EXPIRED':
        return Icons.cancel_rounded;
      case 'DUE_TODAY':
      case 'EXPIRING_SOON':
        return Icons.schedule_rounded;
      case 'UPCOMING':
        return Icons.event_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }

  String get statusLabel {
    switch (renewal.status) {
      case 'EXPIRED':
        return 'Expired';
      case 'DUE_TODAY':
        return 'Due Today';
      case 'EXPIRING_SOON':
        return 'Expiring Soon';
      case 'UPCOMING':
        return 'Upcoming';
      default:
        return 'Active';
    }
  }

  /// Expired and far-future (>30 days) members get a "Reminder" action
  /// instead of "Renew" — matches the PRD mock (Aman Gill → [Reminder]).
  bool get showRenewButton =>
      renewal.status == 'DUE_TODAY' ||
      renewal.status == 'EXPIRING_SOON' ||
      renewal.status == 'EXPIRED' ||
      renewal.status == 'UPCOMING';

  @override
  Widget build(BuildContext context) {
    final initial = renewal.memberName.isNotEmpty
        ? renewal.memberName[0].toUpperCase()
        : "?";

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              CircleAvatar(
                radius: 26,
                backgroundColor:
                AppColors.primary.withValues(alpha: 0.12),
                child: Text(
                  initial,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      renewal.memberName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      renewal.phone,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: urgencyColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusIcon,
                      size: 14,
                      color: urgencyColor,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      statusLabel,
                      style: TextStyle(
                        color: urgencyColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Divider(color: Colors.grey.shade200),

          const SizedBox(height: 10),

          Row(
            children: [
              const Icon(
                Icons.workspace_premium_rounded,
                size: 17,
                color: Colors.deepPurple,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  renewal.planName ?? "No Plan Assigned",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 17,
                color: urgencyColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  renewal.expiryText,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: urgencyColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          if (showRenewButton && onRenew != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRenew,
                icon: const Icon(
                  Icons.autorenew_rounded,
                  size: 18,
                ),
                label: const Text("Renew"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
