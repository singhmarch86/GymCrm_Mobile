import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../widgets/dashboard_action_card.dart';

import '../../features/members/member_screen.dart';
import '../../features/renewals/renewals_screen.dart';
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
          subtitle: 'Track and process expiring memberships',
          icon: Icons.autorenew_rounded,
          color: Colors.orange,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RenewalsScreen(),
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