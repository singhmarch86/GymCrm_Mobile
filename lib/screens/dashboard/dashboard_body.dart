import 'package:flutter/material.dart';

import '../../widgets/app_spacing.dart';
import '../../widgets/dashboard_header.dart';
import '../../widgets/dashboard_renewals_card.dart';
import '../../widgets/dashboard_section_title.dart';

import 'dashboard_quick_actions.dart';
import 'dashboard_recent_activity.dart';
import 'dashboard_stats_grid.dart';

class DashboardBody extends StatelessWidget {
  final String userName;
  final String role;

  final int totalMembers;
  final int activeMembers;
  final int expiredMembers;

  final VoidCallback onLogout;

  const DashboardBody({
    super.key,
    required this.userName,
    required this.role,
    required this.totalMembers,
    required this.activeMembers,
    required this.expiredMembers,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics:
      const AlwaysScrollableScrollPhysics(),
      padding: AppSpacing.screenPadding,
      children: [

        DashboardHeader(
          userName: userName,
          role: role,
          onLogout: onLogout,
        ),

        AppSpacing.gapXxl,

        const DashboardSectionTitle(
          title: "Today's Overview",
        ),

        AppSpacing.gapLg,

        DashboardStatsGrid(
          totalMembers: totalMembers,
          activeMembers: activeMembers,
          expiredMembers: expiredMembers,
        ),

        AppSpacing.gapLg,

        const DashboardRenewalsCard(),

        AppSpacing.gapXxl,

        const DashboardSectionTitle(
          title: "Quick Actions",
        ),

        AppSpacing.gapLg,

        const DashboardQuickActions(),

        AppSpacing.gapXxl,

        const DashboardSectionTitle(
          title: "Recent Activity",
        ),

        AppSpacing.gapLg,

        const DashboardRecentActivity(),

        AppSpacing.gapXxl,
      ],
    );
  }
}