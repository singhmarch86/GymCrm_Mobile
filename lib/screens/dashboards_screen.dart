import 'package:flutter/material.dart';

import '../login_screen.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';
import '../services/storage_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/dashboard_action_card.dart';
import '../widgets/section_title.dart';
import '../widgets/stat_card.dart';

import '../features/members/member_screen.dart';
import 'plans_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  String token = '';
  String userName = '';
  String role = '';

  int totalMembers = 0;
  int activeMembers = 0;
  int expiredMembers = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    try {
      final savedToken =
      await StorageService.getAccessToken();

      final savedUser =
      await StorageService.getUserName();

      final savedRole =
      await StorageService.getRole();

      final dashboard =
      await DashboardService().getDashboard();

      if (!mounted) return;

      setState(() {
        token = savedToken ?? '';
        userName = savedUser ?? '';
        role = savedRole ?? '';

        totalMembers = dashboard.totalMembers;
        activeMembers = dashboard.activeMembers;
        expiredMembers = dashboard.expiredMembers;

        loading = false;
      });
    } catch (e) {
      debugPrint(e.toString());

      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> logout() async {
    try {
      final accessToken =
      await StorageService.getAccessToken();

      if (accessToken != null &&
          accessToken.isNotEmpty) {
        await AuthService().logout(accessToken);
      }
    } catch (_) {}

    await StorageService.clearAll();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GymCRM"),
        actions: [
          IconButton(
            onPressed: loadDashboard,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: loading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding:
        const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Text(
              "Welcome back 👋",
              style: AppTextStyles.caption,
            ),

            const SizedBox(height: 6),

            Text(
              userName,
              style:
              AppTextStyles.pageTitle,
            ),

            const SizedBox(height: 4),

            Text(
              role.toUpperCase(),
              style:
              AppTextStyles.caption,
            ),

            const SizedBox(height: 30),

            const SectionTitle(
              title:
              "Today's Overview",
            ),

            const SizedBox(height: 12),

            StatCard(
              icon: Icons.groups,
              title:
              "Total Members",
              value: totalMembers,
              color:
              AppColors.primary,
            ),

            StatCard(
              icon:
              Icons.check_circle,
              title:
              "Active Members",
              value: activeMembers,
              color:
              AppColors.success,
            ),

            StatCard(
              icon:
              Icons.warning_amber,
              title:
              "Expired Members",
              value: expiredMembers,
              color:
              AppColors.danger,
            ),

            const SizedBox(height: 30),

            const SectionTitle(
              title:
              "Quick Actions",
            ),

            const SizedBox(height: 12),

            DashboardActionCard(
              icon:
              Icons.people_alt,
              title:
              "Members",
              subtitle:
              "Add, Edit & Manage Members",
              color:
              AppColors.primary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const MembersScreen(),
                  ),
                );
              },
            ),

            DashboardActionCard(
              icon:
              Icons.workspace_premium,
              title:
              "Membership Plans",
              subtitle:
              "Create & Manage Plans",
              color:
              Colors.deepPurple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const PlansScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 30),

            const SectionTitle(
              title:
              "Coming Soon",
            ),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding:
                const EdgeInsets.all(
                    20),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: const [
                    Text(
                      "🚀 Renewals",
                      style: TextStyle(
                        fontWeight:
                        FontWeight
                            .bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Renewal reminders, attendance, payments and reports will appear here.",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}