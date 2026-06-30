import 'package:flutter/material.dart';

import 'app_card.dart';

class DashboardTile
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;

  const DashboardTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor:
            color.withOpacity(.12),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight:
              FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}