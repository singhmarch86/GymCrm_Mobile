import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status.toLowerCase()) {
      case 'active':
        color = AppColors.success;
        break;

      case 'expired':
        color = AppColors.danger;
        break;

      default:
        color = AppColors.warning;
    }

    return Chip(
      label: Text(status),
      labelStyle: TextStyle(
        color: color,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor:
      color.withOpacity(.12),
      side: BorderSide.none,
    );
  }
}