import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/dashboard_kpi_card.dart';

class DashboardStatsGrid extends StatelessWidget {
  final int totalMembers;
  final int activeMembers;
  final int expiredMembers;

  const DashboardStatsGrid({
    super.key,
    required this.totalMembers,
    required this.activeMembers,
    required this.expiredMembers,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile: 2 columns
        // Tablet/Desktop: 4 columns
        final bool isWide = constraints.maxWidth > 700;

        if (isWide) {
          return Row(
            children: [
              Expanded(child: _membersCard()),
              const SizedBox(width: 16),
              Expanded(child: _activeCard()),
              const SizedBox(width: 16),
              Expanded(child: _expiringCard()),
              const SizedBox(width: 16),
              Expanded(child: _revenueCard()),
            ],
          );
        }

        return Column(
          children: [
            Row(
              children: [
                Expanded(child: _membersCard()),
                const SizedBox(width: 16),
                Expanded(child: _activeCard()),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: _expiringCard()),
                const SizedBox(width: 16),
                Expanded(child: _revenueCard()),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _membersCard() {
    return DashboardKpiCard(
      title: 'Members',
      value: totalMembers.toString(),
      icon: Icons.groups_rounded,
      color: AppColors.primary,
      subtitle: 'Total registered',
    );
  }

  Widget _activeCard() {
    return DashboardKpiCard(
      title: 'Active',
      value: activeMembers.toString(),
      icon: Icons.check_circle_outline_rounded,
      color: Colors.green,
      subtitle: 'Currently active',
    );
  }

  Widget _expiringCard() {
    return DashboardKpiCard(
      title: 'Expiring',
      value: expiredMembers.toString(),
      icon: Icons.schedule_rounded,
      color: Colors.orange,
      subtitle: 'Need renewal',
    );
  }

  Widget _revenueCard() {
    return DashboardKpiCard(
      title: 'Revenue',
      value: 'Coming Soon',
      icon: Icons.currency_rupee_rounded,
      color: Colors.deepPurple,
      subtitle: 'Next Sprint',
    );
  }
}