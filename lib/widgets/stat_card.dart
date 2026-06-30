import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_card.dart';

class StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int value;
  final Color color;

  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor:
            color.withOpacity(0.12),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),

          const SizedBox(width: 18),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                  AppTextStyles.caption,
                ),
                const SizedBox(height: 6),
                Text(
                  value.toString(),
                  style: AppTextStyles
                      .statNumber,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}