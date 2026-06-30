import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/dashboard_action_card.dart';

import '../member_screen.dart';
import '../plans_screen.dart';

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        DashboardActionCard(
          title: 'Members',
          subtitle: 'Manage all gym members',
          icon: Icons.groups_rounded,
          color: AppColors.primary,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MembersScreen(),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        DashboardActionCard(
          title: 'Plans',
          subtitle: 'Create & update membership plans',
          icon: Icons.workspace_premium_rounded,
          color: Colors.deepPurple,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PlansScreen(),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        DashboardActionCard(
          title: 'Renewals',
          subtitle: 'Coming in Sprint 2',
          icon: Icons.autorenew_rounded,
          color: Colors.orange,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Renewals module coming soon 🚀',
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        DashboardActionCard(
          title: 'Reports',
          subtitle: 'Coming in Sprint 3',
          icon: Icons.bar_chart_rounded,
          color: Colors.green,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Reports module coming soon 📈',
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}