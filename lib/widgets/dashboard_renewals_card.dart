import 'package:flutter/material.dart';

import '../../features/renewals/renewals_screen.dart';
import '../../services/renewal_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/app_card.dart';

/// Dashboard summary card for renewals, matching the PRD mock:
///   Renewals
///   12 Due Today | 28 Due This Week | 3 Overdue
/// Tapping anywhere on the card opens the full Renewals screen.
///
/// Counts are derived client-side from GET /api/v1/members/renewals — there
/// is no dedicated summary endpoint yet. If/when GET /api/v1/dashboard adds
/// renewal-bucket counts, swap this widget's data source for that instead.
class DashboardRenewalsCard extends StatefulWidget {
  const DashboardRenewalsCard({super.key});

  @override
  State<DashboardRenewalsCard> createState() =>
      _DashboardRenewalsCardState();
}

class _DashboardRenewalsCardState extends State<DashboardRenewalsCard> {
  bool isLoading = true;

  int dueToday = 0;
  int dueThisWeek = 0;
  int overdue = 0;

  @override
  void initState() {
    super.initState();
    loadCounts();
  }

  Future<void> loadCounts() async {
    try {
      final all = await RenewalService().getRenewalsDue();

      if (!mounted) return;

      setState(() {
        dueToday = all.where((r) => r.status == 'DUE_TODAY').length;

        dueThisWeek = all
            .where((r) => r.daysRemaining >= 0 && r.daysRemaining <= 7)
            .length;

        overdue = all.where((r) => r.status == 'EXPIRED').length;

        isLoading = false;
      });
    } catch (e) {
      debugPrint('DASHBOARD RENEWALS CARD ERROR: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  void openRenewals() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RenewalsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: openRenewals,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              const Icon(
                Icons.autorenew_rounded,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              const Text(
                "Renewals",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: AppColors.primary,
              ),
            ],
          ),

          const SizedBox(height: 18),

          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: _Stat(
                    value: dueToday,
                    label: "Due Today",
                    color: AppColors.danger,
                  ),
                ),
                _divider(),
                Expanded(
                  child: _Stat(
                    value: dueThisWeek,
                    label: "Due This Week",
                    color: AppColors.warning,
                  ),
                ),
                _divider(),
                Expanded(
                  child: _Stat(
                    value: overdue,
                    label: "Overdue",
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey.shade200,
    );
  }
}

class _Stat extends StatelessWidget {
  final int value;
  final String label;
  final Color color;

  const _Stat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
